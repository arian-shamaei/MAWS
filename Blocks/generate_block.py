
"""
FP Block Wizard (spec-driven)

Interactive or CLI (flag-driven) front-end for wrapping Berkeley HardFloat.
Key capabilities:
 1) Mode (quick/advanced), project metadata, formats (single/multi) with fmtSel.
 2) Operation families and per-family details, honoring multi-format coverage.
 3) Manual or auto opSel encoding; per-op format, signedness, overflow policy.
 4) Interface choice: IEEE or recFN ports; rounding subset with clamp/assert.
 5) Specialization knobs: tininess before/after rounding, NaN compare style,
    div/sqrt variant selection.
 6) Artifacts: config.json, functional-tb manifest/vectors/expected, README,
    generate.ps1, and an Emit<top>.scala emitter that uses the full config.

Outputs:
  - Blocks/fp_blocks/<block>/config.json (full wizard state)
  - Blocks/fp_blocks/<block>/functional-tb/{manifest.json,vectors.txt,expected.txt,testfloat.md}
  - Blocks/generators/berkeley-hardfloat/hardfloat/src/main/scala/Emit<top>.scala
  - Blocks/fp_blocks/<block>/generate.ps1

Notes:
  - Uses sbt (or bundled sbt-launch.jar) to emit RTL.
  - Does not modify the upstream Berkeley HardFloat sources beyond adding the
    generated emitter.
"""

from __future__ import annotations

import argparse
import json
import math
import pathlib
import subprocess
import textwrap
from typing import Any, Dict, List, Optional

REPO_ROOT = pathlib.Path(__file__).resolve().parents[1]
HF_CANDIDATES = [
    REPO_ROOT / "Blocks" / "generators" / "berkeley-hardfloat",
    REPO_ROOT / "Blocks" / "generators" / "berkeley-hardfloat-master" / "berkeley-hardfloat-master",
]

OPS_FAMILIES = ["ADD_SUB", "FMA", "DIV_SQRT", "CMP", "F2F", "F2I", "I2F"]
ROUNDING_NAMES = [
    "round_near_even",
    "round_near_maxMag",
    "round_minMag",
    "round_min",
    "round_max",
    "round_odd",
]
ROUNDING_CODE = {
    "round_near_even": 0,
    "round_near_maxMag": 1,
    "round_minMag": 2,
    "round_min": 3,
    "round_max": 4,
    "round_odd": 6,
}
DIVSQRT_VARIANTS = {
    "small": "DivSqrtRecFN_small",
    "standard": "DivSqrtRecFN",
}


def _find_hf_root() -> Optional[pathlib.Path]:
    for cand in HF_CANDIDATES:
        if cand.exists():
            return cand
    return None


def _bootstrap_hint() -> str:
    helper = REPO_ROOT / "scripts" / "bootstrap_hardfloat.py"
    try:
        rel = helper.relative_to(REPO_ROOT)
    except ValueError:
        rel = helper
    return f"python {rel.as_posix()}"


def ensure_hf_root() -> pathlib.Path:
    root = _find_hf_root()
    if root is None:
        raise SystemExit(
            "Berkeley HardFloat not found under Blocks/generators.\n"
            f"Run {_bootstrap_hint()} or clone the repository into Blocks/generators/berkeley-hardfloat."
        )
    return root


def optional_hf_root() -> Optional[pathlib.Path]:
    return _find_hf_root()


def hf_scala_dir(required: bool = True) -> pathlib.Path:
    root = optional_hf_root()
    if root is None:
        if required:
            raise SystemExit(
                "Berkeley HardFloat not found. "
                f"Run {_bootstrap_hint()} before generating blocks."
            )
        # Return the primary candidate to simplify downstream path joining.
        root = HF_CANDIDATES[0]
    return root / "hardfloat" / "src" / "main" / "scala"


def prompt(msg: str, default: str | None = None) -> str:
    try:
        resp = input(msg)
    except EOFError:
        resp = ""
    if not resp and default is not None:
        return default
    return resp


def yesno(msg: str, default: bool = False) -> bool:
    d = "Y/n" if default else "y/N"
    resp = prompt(f"{msg} ({d}): ", "")
    if not resp:
        return default
    return resp.strip().lower().startswith("y")


def discover_emit_classes() -> List[str]:
    scala_dir = hf_scala_dir(required=False)
    if not scala_dir.exists():
        return []
    return sorted([p.stem for p in scala_dir.glob("Emit*.scala")])


def parse_int_list(text: str, default: List[int]) -> List[int]:
    if not text.strip():
        return default
    vals: List[int] = []
    for part in text.split(","):
        part = part.strip()
        if not part:
            continue
        try:
            vals.append(int(part))
        except ValueError:
            continue
    return vals or default


def collect_formats(quick: bool, exp_override: Optional[int] = None, sig_override: Optional[int] = None, interactive: bool = True) -> List[Dict[str, Any]]:
    formats: List[Dict[str, Any]] = []
    if quick:
        default_exp = 8 if exp_override is None else exp_override
        default_sig = 24 if sig_override is None else sig_override
        if interactive and (exp_override is None or sig_override is None):
            exp = int(prompt(f"expWidth [{default_exp}]: ", str(default_exp)))
            sig = int(prompt(f"sigWidth [{default_sig}]: ", str(default_sig)))
        else:
            exp, sig = default_exp, default_sig
        formats.append({"id": 0, "name": f"fp{exp+sig}", "exp": exp, "sig": sig})
        return formats
    multi = yesno("Use multiple FP formats?", False)
    if not multi:
        exp = int(prompt("Base expWidth [8]: ", "8"))
        sig = int(prompt("Base sigWidth [24]: ", "24"))
        formats.append({"id": 0, "name": "fp_base", "exp": exp, "sig": sig})
    else:
        count = int(prompt("How many FP formats? [2]: ", "2"))
        for idx in range(count):
            name = prompt(f"Format {idx} name [fp{idx}]: ", f"fp{idx}")
            exp = int(prompt("  expWidth: ", "8"))
            sig = int(prompt("  sigWidth: ", "24"))
            formats.append({"id": idx, "name": name, "exp": exp, "sig": sig})
    return formats


def select_op_families(quick: bool, override: Optional[str] = None) -> List[str]:
    if override:
        parsed = [s.strip().upper() for s in override.split(",") if s.strip()]
        return [p for p in parsed if p in OPS_FAMILIES]
    if quick:
        return OPS_FAMILIES.copy()
    print("+-----------------------------+")
    print("| * Select operation families |")
    print("+-----------------------------+")
    for idx, fam in enumerate(OPS_FAMILIES):
        print(f"| [{idx}] {fam}")
    print("+-----------------------------+")
    sel = prompt("Select one or more (comma-separated): ", "")
    choices = [int(s.strip()) for s in sel.split(",") if s.strip().isdigit()]
    enabled: List[str] = []
    for c in choices:
        if 0 <= c < len(OPS_FAMILIES):
            enabled.append(OPS_FAMILIES[c])
    return enabled


def collect_family_details(
    fams: List[str], formats: List[Dict[str, Any]], interactive: bool
) -> Dict[str, Any]:
    details: Dict[str, Any] = {}
    fmt_ids = [f["id"] for f in formats]

    def pick_formats(msg: str, default: Optional[List[int]] = None) -> List[int]:
        default = default if default is not None else [fmt_ids[0]]
        if not interactive:
            return default
        sel = prompt(
            msg + f" (comma-separated ids {fmt_ids}) [{','.join(map(str, default))}]: ",
            ",".join(map(str, default)),
        )
        choices = [int(s.strip()) for s in sel.split(",") if s.strip().isdigit()]
        return [c for c in choices if c in fmt_ids] or default

    if "ADD_SUB" in fams:
        detail = {}
        detail["formats"] = pick_formats("Formats for ADD/SUB")
        if interactive:
            mode = prompt(
                "Add/Sub mode [1] combined (io_subOp) [2] split add/sub [3] sub-only [4] add-only [1]: ",
                "1",
            ).strip()
        else:
            mode = "1"
        detail["split_add_sub"] = mode == "2"
        detail["sub_only"] = mode == "3"
        detail["add_only"] = mode == "4"
        details["ADD_SUB"] = detail
    if "FMA" in fams:
        detail = {}
        detail["formats"] = pick_formats("Formats for FMA/MUL")
        if interactive:
            mode = prompt(
                "FMA/MUL mode [1] fma_only [2] mul_only [3] both [3]: ",
                "3",
            ).strip()
        else:
            mode = "3"
        detail["expose_mul"] = mode
        detail["fma_only"] = mode == "1"
        detail["mul_only"] = mode == "2"
        details["FMA"] = detail
    if "DIV_SQRT" in fams:
        detail = {}
        detail["formats"] = pick_formats("Formats for DIV/SQRT")
        if interactive:
            mode = prompt(
                "Div/Sqrt mode [1] combined (sqrtOp) [2] split ops [3] div-only [4] sqrt-only [1]: ",
                "1",
            ).strip()
        else:
            mode = "1"
        detail["div_enabled"] = mode in ("1", "2", "3")
        detail["sqrt_enabled"] = mode in ("1", "2", "4")
        detail["split_div_sqrt"] = mode == "2"
        detail["div_only"] = mode == "3"
        detail["sqrt_only"] = mode == "4"
        detail["variant"] = prompt("Div/Sqrt variant [small/standard] [small]: ", "small") if interactive else "small"
        details["DIV_SQRT"] = detail
    if "CMP" in fams:
        detail = {}
        detail["formats"] = pick_formats("Formats for CMP")
        detail["cmp_out_encoding"] = (
            prompt("CMP output encoding [2bit_lt_eq / 3bit_unord_lt_eq] [2bit_lt_eq]: ", "2bit_lt_eq")
            if interactive
            else "2bit_lt_eq"
        )
        detail["nan_behavior"] = (
            prompt("NaN compare behavior [quiet/signaling/both] [quiet]: ", "quiet")
            if interactive
            else "quiet"
        )
        details["CMP"] = detail
    if "F2F" in fams:
        detail = {}
        detail["src_formats"] = pick_formats("Source formats for F2F")
        detail["dst_formats"] = pick_formats("Destination formats for F2F", default=fmt_ids)
        detail["default_dst"] = (
            prompt("Default dest format id (blank = same as src): ", "") if interactive else ""
        )
        details["F2F"] = detail
    if "F2I" in fams:
        detail = {}
        detail["formats"] = pick_formats("Formats for F2I")
        detail["int_widths"] = (
            prompt("Integer widths (comma, e.g., 32,64) [32]: ", "32") if interactive else "32"
        )
        detail["signedness"] = (
            prompt(
                "Signedness exposure [flag|separate] (flag adds io_signedOut) [flag]: ", "flag"
            )
            if interactive
            else "flag"
        )
        detail["overflow_policy"] = (
            prompt("Overflow policy (saturate/wrap/zero/sentinel) [saturate]: ", "saturate")
            if interactive
            else "saturate"
        )
        details["F2I"] = detail
    if "I2F" in fams:
        detail = {}
        detail["dst_formats"] = pick_formats("Destination formats for I2F")
        detail["int_widths"] = (
            prompt("Integer widths (comma, e.g., 32,64) [32]: ", "32") if interactive else "32"
        )
        detail["signedness"] = (
            prompt(
                "Signedness exposure [flag|separate] (flag adds io_signedIn) [flag]: ", "flag"
            )
            if interactive
            else "flag"
        )
        details["I2F"] = detail
    return details


def collect_rounding(quick: bool) -> Dict[str, Any]:
    if quick:
        return {"modes": [ROUNDING_NAMES[0]], "policy": "clamp", "default": ROUNDING_NAMES[0]}
    print("+----------------------------------+")
    print("| Select rounding modes to support |")
    print("+----------------------------------+")
    for idx, name in enumerate(ROUNDING_NAMES):
        print(f"| [{idx}] {name}")
    print("+----------------------------------+")
    sel = prompt("Select one or more (comma-separated) [0]: ", "0")
    picks = [int(s.strip()) for s in sel.split(",") if s.strip().isdigit()]
    modes = [ROUNDING_NAMES[i] for i in picks if 0 <= i < len(ROUNDING_NAMES)]
    if not modes:
        modes = [ROUNDING_NAMES[0]]
    policy = prompt("Rounding policy [assert/clamp] [clamp]: ", "clamp")
    default_mode = modes[0]
    return {"modes": modes, "policy": policy, "default": default_mode}


def parse_opcode_map(path: Optional[str]) -> Dict[str, int]:
    if not path:
        return {}
    p = pathlib.Path(path)
    if not p.exists():
        raise FileNotFoundError(f"Opcode map file not found: {p}")
    data = json.loads(p.read_text(encoding="utf-8"))
    if not isinstance(data, dict):
        raise ValueError("Opcode map must be a JSON object mapping op name -> opcode int")
    return {k: int(v) for k, v in data.items()}


def op_name(base: str, fmt_id: int, extra: Optional[str] = None) -> str:
    suffix = f"_f{fmt_id}"
    if extra:
        suffix += f"_{extra}"
    return f"{base}{suffix}"


def auto_op_entries(
    enabled: List[str],
    family_details: Dict[str, Any],
    opcode_map: Dict[str, int],
) -> List[Dict[str, Any]]:
    ops: List[Dict[str, Any]] = []
    used_opcodes = set(opcode_map.values())
    next_opcode = 0

    def alloc(name: str) -> int:
        nonlocal next_opcode
        if name in opcode_map:
            return opcode_map[name]
        while next_opcode in used_opcodes:
            next_opcode += 1
        val = next_opcode
        used_opcodes.add(val)
        next_opcode += 1
        return val

    if "ADD_SUB" in enabled:
        detail = family_details.get("ADD_SUB", {})
        for fmt in detail.get("formats", [0]):
            if detail.get("sub_only", False):
                ops.append({"name": op_name("SUB", fmt), "opcode": alloc(op_name("SUB", fmt)), "fmt": fmt, "type": "sub"})
            elif detail.get("add_only", False):
                ops.append({"name": op_name("ADD", fmt), "opcode": alloc(op_name("ADD", fmt)), "fmt": fmt, "type": "add"})
            elif detail.get("split_add_sub", False):
                ops.append({"name": op_name("ADD", fmt), "opcode": alloc(op_name("ADD", fmt)), "fmt": fmt, "type": "add"})
                ops.append({"name": op_name("SUB", fmt), "opcode": alloc(op_name("SUB", fmt)), "fmt": fmt, "type": "sub"})
            else:
                ops.append({"name": op_name("ADD_SUB", fmt), "opcode": alloc(op_name("ADD_SUB", fmt)), "fmt": fmt, "type": "addsub"})
    if "FMA" in enabled:
        detail = family_details.get("FMA", {})
        expose_mul = detail.get("expose_mul", "3")
        for fmt in detail.get("formats", [0]):
            if not detail.get("mul_only", False):
                ops.append({"name": op_name("FMA", fmt), "opcode": alloc(op_name("FMA", fmt)), "fmt": fmt, "type": "fma"})
            if expose_mul in ("2", "3") or detail.get("mul_only", False):
                ops.append({"name": op_name("MUL", fmt), "opcode": alloc(op_name("MUL", fmt)), "fmt": fmt, "type": "mul"})
    if "DIV_SQRT" in enabled:
        detail = family_details.get("DIV_SQRT", {})
        for fmt in detail.get("formats", [0]):
            if detail.get("div_only", False):
                ops.append({"name": op_name("DIV", fmt), "opcode": alloc(op_name("DIV", fmt)), "fmt": fmt, "type": "div"})
            elif detail.get("sqrt_only", False):
                ops.append({"name": op_name("SQRT", fmt), "opcode": alloc(op_name("SQRT", fmt)), "fmt": fmt, "type": "sqrt"})
            elif detail.get("div_enabled", True):
                if detail.get("split_div_sqrt", False):
                    if detail.get("div_enabled", True):
                        ops.append({"name": op_name("DIV", fmt), "opcode": alloc(op_name("DIV", fmt)), "fmt": fmt, "type": "div"})
                    if detail.get("sqrt_enabled", True):
                        ops.append({"name": op_name("SQRT", fmt), "opcode": alloc(op_name("SQRT", fmt)), "fmt": fmt, "type": "sqrt"})
                else:
                    ops.append({"name": op_name("DIV_SQRT", fmt), "opcode": alloc(op_name("DIV_SQRT", fmt)), "fmt": fmt, "type": "divsqrt"})
    if "CMP" in enabled:
        detail = family_details.get("CMP", {})
        for fmt in detail.get("formats", [0]):
            ops.append({"name": op_name("CMP", fmt), "opcode": alloc(op_name("CMP", fmt)), "fmt": fmt, "type": "cmp"})
    if "F2F" in enabled:
        detail = family_details.get("F2F", {})
        srcs = detail.get("src_formats", [0])
        dsts = detail.get("dst_formats", srcs)
        for s in srcs:
            for d in dsts:
                ops.append({"name": op_name("F2F", s, f"to{d}"), "opcode": alloc(op_name("F2F", s, f"to{d}")), "fmt": s, "type": "f2f", "dst_fmt": d})
    if "F2I" in enabled:
        detail = family_details.get("F2I", {})
        int_widths = parse_int_list(detail.get("int_widths", "32"), [32])
        formats = detail.get("formats", [0])
        if detail.get("signedness", "flag") == "separate":
            for fmt in formats:
                for w in int_widths:
                    ops.append({"name": op_name("F2I_S", fmt, f"w{w}"), "opcode": alloc(op_name("F2I_S", fmt, f"w{w}")), "fmt": fmt, "type": "f2i", "int_width": w, "signed": True, "overflow_policy": detail.get("overflow_policy", "saturate")})
                    ops.append({"name": op_name("F2I_U", fmt, f"w{w}"), "opcode": alloc(op_name("F2I_U", fmt, f"w{w}")), "fmt": fmt, "type": "f2i", "int_width": w, "signed": False, "overflow_policy": detail.get("overflow_policy", "saturate")})
        else:
            for fmt in formats:
                for w in int_widths:
                    ops.append({"name": op_name("F2I", fmt, f"w{w}"), "opcode": alloc(op_name("F2I", fmt, f"w{w}")), "fmt": fmt, "type": "f2i", "int_width": w, "signed_flag": True, "overflow_policy": detail.get("overflow_policy", "saturate")})
    if "I2F" in enabled:
        detail = family_details.get("I2F", {})
        int_widths = parse_int_list(detail.get("int_widths", "32"), [32])
        dst_formats = detail.get("dst_formats", [0])
        if detail.get("signedness", "flag") == "separate":
            for fmt in dst_formats:
                for w in int_widths:
                    ops.append({"name": op_name("I2F_S", fmt, f"w{w}"), "opcode": alloc(op_name("I2F_S", fmt, f"w{w}")), "fmt": fmt, "type": "i2f", "int_width": w, "signed": True})
                    ops.append({"name": op_name("I2F_U", fmt, f"w{w}"), "opcode": alloc(op_name("I2F_U", fmt, f"w{w}")), "fmt": fmt, "type": "i2f", "int_width": w, "signed": False})
        else:
            for fmt in dst_formats:
                for w in int_widths:
                    ops.append({"name": op_name("I2F", fmt, f"w{w}"), "opcode": alloc(op_name("I2F", fmt, f"w{w}")), "fmt": fmt, "type": "i2f", "int_width": w, "signed_flag": True})
    return ops


def pick_generator_class(block: str, top: str, user_gen: str | None) -> str:
    if user_gen:
        return user_gen
    return f"hardfloat.Emit{top}"


def fmt_bus_width(fmt: Dict[str, Any], interface: str) -> int:
    if interface == "recfn":
        return fmt["exp"] + fmt["sig"] + 1
    return fmt["exp"] + fmt["sig"]


def rounding_literal(name: str) -> int:
    return ROUNDING_CODE[name]


def emit_scala_generator(top: str, config: Dict[str, Any]) -> None:
    formats = config["formats"]
    interface = config["interface"]
    rounding = config["rounding"]
    family_details = config["family_details"]
    ops = config["ops"]
    detect_tininess = 1 if config.get("tininess", "after") == "before" else 0
    cmp_encoding = family_details.get("CMP", {}).get("cmp_out_encoding", "2bit_lt_eq")
    cmp_width = 2 if cmp_encoding == "2bit_lt_eq" else 3
    opcodes = [op["opcode"] for op in ops]
    op_width = max(1, math.ceil(math.log2(max(opcodes) + 1)) if opcodes else 1)
    fmt_sel_bits = max(1, math.ceil(math.log2(len(formats)))) if len(formats) > 1 else 1
    max_intw = max([op.get("int_width", 0) for op in ops], default=0)
    bus_width = max(max(fmt_bus_width(f, interface) for f in formats), max_intw or 0)
    rec_widths = {f["id"]: f["exp"] + f["sig"] + 1 for f in formats}

    scala_dir = hf_scala_dir()
    scala_dir.mkdir(parents=True, exist_ok=True)

    ops_by_fmt: Dict[int, List[Dict[str, Any]]] = {}
    for op in ops:
        ops_by_fmt.setdefault(op["fmt"], []).append(op)

    allowed_rounding_vals = [rounding_literal(n) for n in rounding["modes"]]
    default_rounding_val = rounding_literal(rounding["default"])
    rounding_policy = rounding.get("policy", "clamp")

    scala_lines: List[str] = []
    sl = scala_lines.append
    sl(f"package hardfloat\n")
    sl("import chisel3._")
    sl("import chisel3.util._")
    sl("import hardfloat._\n")
    sl(f"class {top} extends Module {{")
    sl("  val io = IO(new Bundle {")
    sl(f"    val opSel = Input(UInt({op_width}.W))")
    if len(formats) > 1:
        sl(f"    val fmtSel = Input(UInt({fmt_sel_bits}.W))")
    sl(f"    val a = Input(UInt({bus_width}.W))")
    sl(f"    val b = Input(UInt({bus_width}.W))")
    sl(f"    val c = Input(UInt({bus_width}.W))")
    sl("    val roundingMode = Input(UInt(3.W))")
    if any(op["type"] == "addsub" for op in ops):
        sl("    val subOp = Input(Bool())")
    if any(op["type"] == "divsqrt" for op in ops):
        sl("    val sqrtOp = Input(Bool())")
        sl("    val outValid = Output(Bool())")
    if any(op.get("signed_flag") for op in ops if op["type"] in ("f2i", "i2f")):
        sl("    val signedSel = Input(Bool())")
    sl(f"    val out = Output(UInt({bus_width}.W))")
    sl("    val exceptionFlags = Output(UInt(5.W))")
    if any(op["type"] == "cmp" for op in ops):
        sl(f"    val cmpOut = Output(UInt({cmp_width}.W))")
    sl("  })\n")

    allowed_vec = ", ".join(f"{v}.U" for v in allowed_rounding_vals)
    sl(f"  val allowedRounding = VecInit(Seq({allowed_vec}))")
    sl("  val roundingMatches = allowedRounding.map(_ === io.roundingMode)")
    sl("  val roundingValid = roundingMatches.reduce(_||_)")
    if rounding_policy == "assert":
        sl('  assert(roundingValid, "Unsupported rounding mode")')
        sl("  val roundingMode = io.roundingMode")
    else:
        sl("  val roundingMode = Mux(roundingValid, io.roundingMode, allowedRounding(0))")

    for fmt in formats:
        fid = fmt["id"]
        exp = fmt["exp"]
        sig = fmt["sig"]
        width = fmt_bus_width(fmt, interface)
        recw = rec_widths[fid]
        if interface == "ieee":
            sl(f"  def recFromFN_f{fid}(x: UInt) = {{")
            sl(f"    recFNFromFN({exp}, {sig}, x({width}-1, 0))")
            sl("  }")
            sl(f"  def fnFromRec_f{fid}(x: UInt) = {{")
            sl(f"    fNFromRecFN({exp}, {sig}, x)")
            sl("  }")
        sl(f"  val recZero_f{fid} = 0.U({recw}.W)")

    sl("  // Per-format operator instances")
    sl("  val excInvalid = 16.U(5.W)")
    sl("  val excDefault = 0.U(5.W)")
    for fmt in formats:
        fid = fmt["id"]
        exp = fmt["exp"]
        sig = fmt["sig"]
        recw = rec_widths[fid]
        sl(f"  // Format {fid}: exp={exp} sig={sig}")
        sl(f"  val fmt{fid}_recA = Wire(UInt({recw}.W))")
        sl(f"  val fmt{fid}_recB = Wire(UInt({recw}.W))")
        sl(f"  val fmt{fid}_recC = Wire(UInt({recw}.W))")
        if interface == "ieee":
            sl(f"  fmt{fid}_recA := recFromFN_f{fid}(io.a)")
            sl(f"  fmt{fid}_recB := recFromFN_f{fid}(io.b)")
            sl(f"  fmt{fid}_recC := recFromFN_f{fid}(io.c)")
        else:
            width = recw
            sl(f"  fmt{fid}_recA := io.a({width}-1, 0)")
            sl(f"  fmt{fid}_recB := io.b({width}-1, 0)")
            sl(f"  fmt{fid}_recC := io.c({width}-1, 0)")

        fmt_ops = ops_by_fmt.get(fid, [])
        types_in_fmt = {o["type"] for o in fmt_ops}
        if any(t in types_in_fmt for t in ("add", "sub", "addsub")):
            sl(f"  val add_f{fid} = Module(new AddRecFN({exp}, {sig}))")
            sl(f"  add_f{fid}.io.a := fmt{fid}_recA")
            sl(f"  add_f{fid}.io.b := fmt{fid}_recB")
            sub_cond = f"io.opSel === {next(o['opcode'] for o in fmt_ops if o['type']=='sub')}.U" if any(o["type"] == "sub" for o in fmt_ops) else "io.subOp"
            sl(f"  add_f{fid}.io.subOp := {sub_cond}")
            sl(f"  add_f{fid}.io.roundingMode := roundingMode")
            sl(f"  add_f{fid}.io.detectTininess := {detect_tininess}.U")
        if any(t == "fma" for t in types_in_fmt):
            sl(f"  val fma_f{fid} = Module(new MulAddRecFN({exp}, {sig}))")
            sl(f"  fma_f{fid}.io.op := 0.U")
            sl(f"  fma_f{fid}.io.a := fmt{fid}_recA")
            sl(f"  fma_f{fid}.io.b := fmt{fid}_recB")
            sl(f"  fma_f{fid}.io.c := fmt{fid}_recC")
            sl(f"  fma_f{fid}.io.roundingMode := roundingMode")
            sl(f"  fma_f{fid}.io.detectTininess := {detect_tininess}.U")
        if any(t == "mul" for t in types_in_fmt):
            sl(f"  val mul_f{fid} = Module(new MulRecFN({exp}, {sig}))")
            sl(f"  mul_f{fid}.io.a := fmt{fid}_recA")
            sl(f"  mul_f{fid}.io.b := fmt{fid}_recB")
            sl(f"  mul_f{fid}.io.roundingMode := roundingMode")
            sl(f"  mul_f{fid}.io.detectTininess := {detect_tininess}.U")
        if any(t in ("div", "sqrt", "divsqrt") for t in types_in_fmt):
            variant = family_details.get("DIV_SQRT", {}).get("variant", "small")
            clazz = DIVSQRT_VARIANTS.get(variant, "DivSqrtRecFN_small")
            sl(f"  val divsqrt_f{fid} = Module(new {clazz}({exp}, {sig}, 0))")
            sl(f"  val div_in_f{fid} = WireInit(false.B)")
            sl(f"  divsqrt_f{fid}.io.inValid := div_in_f{fid}")
            sl(f"  divsqrt_f{fid}.io.a := fmt{fid}_recA")
            sl(f"  divsqrt_f{fid}.io.b := fmt{fid}_recB")
            sl(f"  divsqrt_f{fid}.io.roundingMode := roundingMode")
            sl(f"  divsqrt_f{fid}.io.detectTininess := {detect_tininess}.U")
            sqrt_opcode = next((o["opcode"] for o in fmt_ops if o["type"] == "sqrt"), None)
            div_opcode = next((o["opcode"] for o in fmt_ops if o["type"] == "div"), None)
            if sqrt_opcode is not None or div_opcode is not None:
                sqrt_expr = []
                if sqrt_opcode is not None:
                    sqrt_expr.append(f"io.opSel === {sqrt_opcode}.U")
                if any(o["type"] == "divsqrt" for o in fmt_ops):
                    sqrt_expr.append("io.sqrtOp")
                sl(f"  divsqrt_f{fid}.io.sqrtOp := {' || '.join(sqrt_expr) if sqrt_expr else 'false.B'}")
            else:
                sl(f"  divsqrt_f{fid}.io.sqrtOp := io.sqrtOp")
            sl(f"  val divOutValid = divsqrt_f{fid}.io.outValid_div || divsqrt_f{fid}.io.outValid_sqrt")
        if any(t == "cmp" for t in types_in_fmt):
            signaling = "true.B" if family_details.get("CMP", {}).get("nan_behavior", "quiet") == "signaling" else "false.B"
            sl(f"  val cmp_f{fid} = Module(new CompareRecFN({exp}, {sig}))")
            sl(f"  cmp_f{fid}.io.a := fmt{fid}_recA")
            sl(f"  cmp_f{fid}.io.b := fmt{fid}_recB")
            sl(f"  cmp_f{fid}.io.signaling := {signaling}")
        if any(t == "f2f" for t in types_in_fmt):
            for op in [o for o in fmt_ops if o["type"] == "f2f"]:
                dst = op["dst_fmt"]
                dst_fmt = next(f for f in formats if f["id"] == dst)
                sl(f"  val f2f_f{fid}_to_{dst} = Module(new RecFNToRecFN({exp}, {sig}, {dst_fmt['exp']}, {dst_fmt['sig']}))")
                sl(f"  f2f_f{fid}_to_{dst}.io.in := fmt{fid}_recA")
                sl(f"  f2f_f{fid}_to_{dst}.io.roundingMode := roundingMode")
                sl(f"  f2f_f{fid}_to_{dst}.io.detectTininess := {detect_tininess}.U")
        if any(t == "f2i" for t in types_in_fmt):
            for op in [o for o in fmt_ops if o["type"] == "f2i"]:
                intw = op.get("int_width", fmt["exp"] + fmt["sig"])
                sl(f"  val f2i_f{fid}_w{intw}_{op['name']} = Module(new RecFNToIN({exp}, {sig}, {intw}))")
                sl(f"  f2i_f{fid}_w{intw}_{op['name']}.io.in := fmt{fid}_recA")
                sl(f"  f2i_f{fid}_w{intw}_{op['name']}.io.roundingMode := roundingMode")
                signed_expr = (
                    "io.signedSel"
                    if op.get("signed_flag")
                    else ("true.B" if op.get("signed", True) else "false.B")
                )
                sl(f"  f2i_f{fid}_w{intw}_{op['name']}.io.signedOut := {signed_expr}")
        if any(t == "i2f" for t in types_in_fmt):
            for op in [o for o in fmt_ops if o["type"] == "i2f"]:
                intw = op.get("int_width", fmt["exp"] + fmt["sig"])
                sl(f"  val i2f_f{fid}_w{intw}_{op['name']} = Module(new INToRecFN({intw}, {exp}, {sig}))")
                signed_expr = (
                    "io.signedSel"
                    if op.get("signed_flag")
                    else ("true.B" if op.get("signed", True) else "false.B")
                )
                sl(f"  i2f_f{fid}_w{intw}_{op['name']}.io.signedIn := {signed_expr}")
                sl(f"  i2f_f{fid}_w{intw}_{op['name']}.io.in := io.a({intw}-1, 0)")
                sl(f"  i2f_f{fid}_w{intw}_{op['name']}.io.roundingMode := roundingMode")
                sl(f"  i2f_f{fid}_w{intw}_{op['name']}.io.detectTininess := {detect_tininess}.U")

    sl(f"  val outRec = WireDefault(0.U({max(rec_widths.values())}.W))")
    sl("  val outInt = WireDefault(0.U(io.out.getWidth.W))")
    sl("  val outExc = WireDefault(excDefault)")
    sl("  val outValid = WireDefault(false.B)")
    sl("  val busy = RegInit(false.B)")
    if any(op["type"] == "cmp" for op in ops):
        sl(f"  val cmpOut = WireDefault(0.U({cmp_width}.W))")

    sl("  // Operation decode")
    sl("  switch(io.opSel) {")
    for op in ops:
        fid = op["fmt"]
        if len(formats) > 1:
            sl(f"    is({op['opcode']}.U) {{")
            sl(f"      when(io.fmtSel === {fid}.U) {{")
        else:
            sl(f"    is({op['opcode']}.U) {{")
        otype = op["type"]
        recw = rec_widths[fid]
        if otype in ("add", "sub", "addsub"):
            sl(f"        outRec := add_f{fid}.io.out")
            sl(f"        outExc := add_f{fid}.io.exceptionFlags")
            if otype == "addsub":
                sl(f"        add_f{fid}.io.subOp := io.subOp")
            sl(f"        outValid := true.B")
        elif otype == "fma":
            sl(f"        outRec := fma_f{fid}.io.out")
            sl(f"        outExc := fma_f{fid}.io.exceptionFlags")
            sl(f"        outValid := true.B")
        elif otype == "mul":
            sl(f"        outRec := mul_f{fid}.io.out")
            sl(f"        outExc := mul_f{fid}.io.exceptionFlags")
            sl(f"        outValid := true.B")
        elif otype in ("div", "sqrt", "divsqrt"):
            sl(f"        val divPending = RegInit(false.B)")
            sl(f"        when(!busy && (io.opSel === {op['opcode']}.U)) {{")
            sl(f"          divPending := true.B")
            sl(f"        }}")
            sl(f"        div_in_f{fid} := divPending")
            sl(f"        when(divPending && divsqrt_f{fid}.io.inReady) {{")
            sl(f"          divPending := false.B")
            sl(f"          busy := true.B")
            sl(f"        }}")
            sl(f"        outRec := divsqrt_f{fid}.io.out")
            sl(f"        outExc := divsqrt_f{fid}.io.exceptionFlags")
            sl(f"        outValid := divOutValid")
            sl(f"        when(divOutValid) {{ busy := false.B }}")
        elif otype == "cmp":
            if cmp_width == 2:
                sl(f"        cmpOut := Cat(cmp_f{fid}.io.lt, cmp_f{fid}.io.eq)")
            else:
                sl(f"        cmpOut := Cat(cmp_f{fid}.io.unordered, cmp_f{fid}.io.lt, cmp_f{fid}.io.eq)")
            sl(f"        outExc := cmp_f{fid}.io.exceptionFlags")
            sl(f"        outValid := true.B")
        elif otype == "f2f":
            dst = op["dst_fmt"]
            dst_fmt = next(f for f in formats if f["id"] == dst)
            dst_recw = dst_fmt["exp"] + dst_fmt["sig"] + 1
            sl(f"        outRec := f2f_f{fid}_to_{dst}.io.out")
            sl(f"        outExc := f2f_f{fid}_to_{dst}.io.exceptionFlags")
            sl(f"        outValid := true.B")
        elif otype == "f2i":
            base_name = f"f2i_f{fid}_w{op.get('int_width', formats[0]['exp'] + formats[0]['sig'])}_{op['name']}"
            sl(f"        outInt := {base_name}.io.out")
            sl(f"        outExc := Cat({base_name}.io.intExceptionFlags(2), 0.U(1.W), {base_name}.io.intExceptionFlags(1), 0.U(1.W), {base_name}.io.intExceptionFlags(0))")
            if op.get("overflow_policy") == "saturate":
                signed_sel_expr = "io.signedSel" if op.get("signed_flag") else ("true.B" if op.get("signed", True) else "false.B")
                sl(f"        when({base_name}.io.intExceptionFlags.orR) {{")
                sl(f"          when({signed_sel_expr}) {{")
                sl(f"            outInt := Mux({base_name}.io.out({op.get('int_width', formats[0]['exp'] + formats[0]['sig'])}-1), ((BigInt(1) << ({op.get('int_width', formats[0]['exp'] + formats[0]['sig'])}-1)) - 1).U, (BigInt(1) << ({op.get('int_width', formats[0]['exp'] + formats[0]['sig'])}-1)).U)")
                sl("          }.otherwise {")
                sl(f"            outInt := ((BigInt(1) << {op.get('int_width', formats[0]['exp'] + formats[0]['sig'])}) - 1).U")
                sl("          }")
                sl("        }")
            elif op.get("overflow_policy") == "zero":
                sl(f"        when({base_name}.io.intExceptionFlags.orR) {{ outInt := 0.U }}")
            elif op.get("overflow_policy") == "sentinel":
                sl(f"        when({base_name}.io.intExceptionFlags.orR) {{ outInt := Fill(outInt.getWidth, 1.U) }}")
            sl(f"        outValid := true.B")
        elif otype == "i2f":
            base_name = f"i2f_f{fid}_w{op.get('int_width', formats[0]['exp'] + formats[0]['sig'])}_{op['name']}"
            sl(f"        outRec := i2f_f{fid}_w{op.get('int_width', formats[0]['exp'] + formats[0]['sig'])}_{op['name']}.io.out")
            sl(f"        outExc := i2f_f{fid}_w{op.get('int_width', formats[0]['exp'] + formats[0]['sig'])}_{op['name']}.io.exceptionFlags")
            sl(f"        outValid := true.B")
        if len(formats) > 1:
            sl("      }")
        sl("    }")
    sl("  }\n")
    if interface == "ieee":
        sl("  val recNonZero = outRec.orR")
        sl("  val outIeee = Wire(UInt(io.out.getWidth.W))")
        if len(formats) == 1:
            fid = formats[0]["id"]
            sl(f"  outIeee := fnFromRec_f{fid}(outRec)")
        else:
            sl("  outIeee := 0.U")
            for fmt in formats:
                fid = fmt["id"]
                sl(f"  when(io.fmtSel === {fid}.U) {{ outIeee := fnFromRec_f{fid}(outRec) }}")
        sl("  io.out := Mux(recNonZero, outIeee, outInt)")
    else:
        sl("  io.out := Mux(outRec.orR, outRec, outInt)")
    sl("  io.exceptionFlags := outExc")
    if any(op["type"] == "cmp" for op in ops):
        sl("  io.cmpOut := cmpOut")
    if any(op["type"] == "divsqrt" for op in ops):
        sl("  io.outValid := outValid")
    sl("}\n")
    sl(f"object Emit{top} extends App {{")
    sl('  val outDir = if (args.length > 0) args(0) else "generated"')
    sl(f'  (new chisel3.stage.ChiselStage).emitVerilog(new {top}, Array("--target-dir", outDir))')
    sl("}")

    (scala_dir / f"Emit{top}.scala").write_text("\n".join(scala_lines), encoding="utf-8")


def run_sbt(gen_class: str, out_dir: pathlib.Path) -> None:
    hf_root = ensure_hf_root()
    launch_jar = hf_root / "sbt-launch.jar"
    cmd = ["sbt", f'runMain {gen_class} {out_dir.as_posix()}']
    print(f"[generate_block] Running: {' '.join(cmd)} (cwd={hf_root})")
    try:
        subprocess.run(cmd, cwd=hf_root, check=True)
        return
    except FileNotFoundError:
        if not launch_jar.exists():
            raise
        cmd = ["java", "-jar", str(launch_jar), f'runMain {gen_class} {out_dir.as_posix()}']
        print(f"[generate_block] Falling back to bundled sbt-launch.jar: {' '.join(cmd)}")
        subprocess.run(cmd, cwd=hf_root, check=True)


def main() -> None:
    parser = argparse.ArgumentParser(description="FP block generator wizard")
    parser.add_argument("--noninteractive", action="store_true", help="Force CLI-only mode (no prompts)")
    parser.add_argument("--name", help="Block name")
    parser.add_argument("--mode", choices=["quick", "advanced"])
    parser.add_argument("--exp-width", type=int, help="expWidth for quick mode (default 8)")
    parser.add_argument("--sig-width", type=int, help="sigWidth for quick mode (default 24)")
    parser.add_argument("--generator", help="Generator class (e.g., hardfloat.EmitFp32Add)")
    parser.add_argument("--interface", choices=["ieee", "recfn"], default="ieee")
    parser.add_argument(
        "--add-sub-mode",
        choices=["combined", "split", "sub_only", "add_only"],
        help="Exposure for ADD/SUB family (combined uses io_subOp; split emits separate ops; sub_only/add_only emit only that op)",
    )
    parser.add_argument(
        "--fma-mode",
        choices=["both", "fma_only", "mul_only"],
        help="FMA family exposure (both=fma+mul, fma_only, mul_only)",
    )
    parser.add_argument(
        "--div-sqrt-mode",
        choices=["combined", "split", "div_only", "sqrt_only"],
        help="DIV/SQRT exposure (combined uses sqrtOp, split emits separate ops, or div_only/sqrt_only)",
    )
    parser.add_argument("--op-families", help="Comma list of op families to enable (e.g., ADD_SUB,FMA)")
    parser.add_argument("--opcode-map", help="JSON file mapping op names to opcode ints")
    parser.add_argument("--skip-sbt", action="store_true", help="Skip running sbt (default: run)")
    parser.add_argument("--vector-file-source", help="Path to vectors file to copy into functional-tb/vectors.txt")
    parser.add_argument("--expected-file-source", help="Path to expected file to copy into functional-tb/expected.txt")
    args = parser.parse_args()

    opcode_map = parse_opcode_map(args.opcode_map)

    def can_auto_quick(a: argparse.Namespace) -> bool:
        # Required for auto-quick: block name and both exp/sig provided
        return bool(a.name) and ((a.mode or "quick") == "quick") and (a.exp_width is not None) and (a.sig_width is not None)

    auto_noninteractive = args.noninteractive or can_auto_quick(args)

    vector_src = args.vector_file_source
    expected_src = args.expected_file_source

    if auto_noninteractive:
        block = args.name or "fp_block"
        mode_quick = (args.mode or "quick") == "quick"
        user_gen = args.generator
    else:
        mode = prompt("Mode: [1] Quick (FP32 defaults) [2] Advanced [1]: ", "1")
        mode_quick = mode.strip() != "2"
        block = prompt("* Block name (folder under Blocks/fp_blocks): ") or ""
        if not block:
            print("Block name required.")
            return
        user_gen = prompt("* Generator class override (leave blank for auto): ", "")
        args.interface = prompt("Interface [ieee/recfn] [ieee]: ", "ieee") or "ieee"
        if not vector_src:
            vector_src = prompt("Path to vectors file to copy (blank = create empty): ", "")
        if not expected_src:
            expected_src = prompt("Path to expected file to copy (blank = create empty): ", "")

    formats = collect_formats(
        mode_quick,
        exp_override=args.exp_width,
        sig_override=args.sig_width,
        interactive=not auto_noninteractive,
    )
    enabled = select_op_families(mode_quick, override=args.op_families)
    fam_details = collect_family_details(enabled, formats, interactive=not auto_noninteractive)
    if "ADD_SUB" in fam_details:
        mode = args.add_sub_mode
        if mode:
            fam_details["ADD_SUB"]["split_add_sub"] = mode == "split"
            fam_details["ADD_SUB"]["sub_only"] = mode == "sub_only"
            fam_details["ADD_SUB"]["add_only"] = mode == "add_only"
        fam_details["ADD_SUB"].setdefault("sub_only", False)
        fam_details["ADD_SUB"].setdefault("add_only", False)
    if "FMA" in fam_details:
        mode = args.fma_mode
        if mode:
            fam_details["FMA"]["fma_only"] = mode == "fma_only"
            fam_details["FMA"]["mul_only"] = mode == "mul_only"
            fam_details["FMA"]["expose_mul"] = {"fma_only": "1", "mul_only": "2", "both": "3"}[mode]
        fam_details["FMA"].setdefault("fma_only", False)
        fam_details["FMA"].setdefault("mul_only", False)
    if "DIV_SQRT" in fam_details:
        mode = args.div_sqrt_mode
        if mode:
            fam_details["DIV_SQRT"]["div_only"] = mode == "div_only"
            fam_details["DIV_SQRT"]["sqrt_only"] = mode == "sqrt_only"
            fam_details["DIV_SQRT"]["split_div_sqrt"] = mode == "split"
            fam_details["DIV_SQRT"]["div_enabled"] = mode in ("combined", "split", "div_only")
            fam_details["DIV_SQRT"]["sqrt_enabled"] = mode in ("combined", "split", "sqrt_only")
        fam_details["DIV_SQRT"].setdefault("div_only", False)
        fam_details["DIV_SQRT"].setdefault("sqrt_only", False)
    rounding = collect_rounding(mode_quick)
    tininess = "after"
    nan_policy = "default"
    if not mode_quick:
        tininess = prompt("Tininess detection [before/after] [after]: ", "after")
        nan_policy = prompt("NaN propagation policy description (stored only) [default]: ", "default")

    ops = auto_op_entries(enabled, fam_details, opcode_map)
    opcodes = [o["opcode"] for o in ops]
    op_width = max(1, math.ceil(math.log2(max(opcodes) + 1))) if opcodes else 4
    max_intw = max([op.get("int_width", 0) for op in ops], default=0)
    bus_width = max(max(fmt_bus_width(f, args.interface) for f in formats), max_intw or 0)
    top = block
    gen_class = pick_generator_class(block, top, user_gen if user_gen else None)

    block_dir = REPO_ROOT / "Blocks" / "fp_blocks" / block
    (block_dir / "rtl").mkdir(parents=True, exist_ok=True)
    (block_dir / "functional-tb").mkdir(parents=True, exist_ok=True)

    def io_name(base: str) -> str:
        if base in ("clock", "reset"):
            return base
        return base if base.startswith("io_") else f"io_{base}"

    manifest_inputs = [
        {"name": io_name("clock"), "width": 1, "default": 0},
        {"name": io_name("reset"), "width": 1, "default": 0},
        {"name": io_name("opSel"), "width": op_width, "default": 0},
    ]
    if len(formats) > 1:
        fmt_sel_bits = max(1, math.ceil(math.log2(len(formats))))
        manifest_inputs.append({"name": io_name("fmtSel"), "width": fmt_sel_bits, "default": 0})
    manifest_inputs.extend(
        [
            {"name": io_name("a"), "width": bus_width},
            {"name": io_name("b"), "width": bus_width},
            {"name": io_name("c"), "width": bus_width},
            {"name": io_name("roundingMode"), "width": 3, "default": rounding_literal(rounding["default"])},
        ]
    )
    if any(o["type"] == "addsub" for o in ops):
        manifest_inputs.append({"name": io_name("subOp"), "width": 1, "default": 0})
    if any(o["type"] == "divsqrt" for o in ops):
        manifest_inputs.append({"name": io_name("sqrtOp"), "width": 1, "default": 0})
    if any(o.get("signed_flag") for o in ops if o["type"] in ("f2i", "i2f")):
        manifest_inputs.append({"name": io_name("signedSel"), "width": 1, "default": 0})

    manifest_outputs = [
        {"name": io_name("out"), "width": bus_width},
        {"name": io_name("exceptionFlags"), "width": 5},
    ]
    if any(o["type"] == "cmp" for o in ops):
        cmp_encoding = fam_details.get("CMP", {}).get("cmp_out_encoding", "2bit_lt_eq")
        cmp_width = 2 if cmp_encoding == "2bit_lt_eq" else 3
        manifest_outputs.append({"name": io_name("cmpOut"), "width": cmp_width})
    if any(o["type"] == "divsqrt" for o in ops):
        manifest_outputs.append({"name": io_name("outValid"), "width": 1})

    manifest = {
        "top_module": top,
        "filelist": [f"Blocks/fp_blocks/{block}/rtl/{top}.v"],
        "inputs": manifest_inputs,
        "outputs": manifest_outputs,
    }
    (block_dir / "functional-tb" / "manifest.json").write_text(
        json.dumps(manifest, indent=2), encoding="utf-8"
    )

    def copy_or_blank(src_path: str | None, dest: pathlib.Path, blank_hint: str) -> None:
        if src_path:
            p = pathlib.Path(src_path)
            if p.exists():
                dest.write_text(p.read_text(encoding="utf-8"), encoding="utf-8")
                return
            else:
                print(f"[generate_block] Warning: {p} not found; writing blank {dest.name}")
        dest.write_text(blank_hint, encoding="utf-8")

    copy_or_blank(vector_src, block_dir / "functional-tb" / "vectors.txt", "# add vectors here\n")
    copy_or_blank(expected_src, block_dir / "functional-tb" / "expected.txt", "# add expected here\n")
    (block_dir / "functional-tb" / "testfloat.md").write_text(
        textwrap.dedent(
            f"""\
            # TestFloat Integration (hook)
            - Use berkeley-testfloat-3 to generate vectors for the operations you enabled.
            - Map opSel/fmtSel/roundingMode to TestFloat arguments; the wizard records opcodes in config.json.
            - io_out carries the numeric result; io_exceptionFlags matches IEEE flags.
            - For cmp operations, io_cmpOut exposes compare bits; integer conversions use io_out when integer.
            """
        ),
        encoding="utf-8",
    )

    config = {
        "mode": "quick" if mode_quick else "advanced",
        "formats": formats,
        "interface": args.interface,
        "op_families": enabled,
        "family_details": fam_details,
        "ops": ops,
        "rounding": rounding,
        "generator_class": gen_class,
        "hf_emit_classes": discover_emit_classes(),
        "tininess": tininess,
        "nan_policy": nan_policy,
        "opcode_map": opcode_map,
    }
    (block_dir / "config.json").write_text(json.dumps(config, indent=2), encoding="utf-8")

    emit_name = gen_class.split(".")[-1]
    scala_dir = hf_scala_dir()
    emit_path = scala_dir / f"{emit_name}.scala"
    emit_scala_generator(top, config)
    print(f"[generate_block] Generated emitter {emit_path}")

    bootstrap_hint = _bootstrap_hint()
    ps1 = textwrap.dedent(
        f"""\
        # Invoke the Berkeley HardFloat generator for this block.
        $ErrorActionPreference = "Stop"
        $blockRoot = $PSScriptRoot
        $fpBlocksRoot = Split-Path -Parent $blockRoot
        $blocksRoot = Split-Path -Parent $fpBlocksRoot
        $hfCandidates = @(
          (Join-Path (Join-Path $blocksRoot "generators") "berkeley-hardfloat"),
          (Join-Path (Join-Path (Join-Path $blocksRoot "generators") "berkeley-hardfloat-master") "berkeley-hardfloat-master")
        )
        $hfRoot = $null
        foreach ($cand in $hfCandidates) {{
          if (Test-Path $cand) {{
            $hfRoot = $cand
            break
          }}
        }}
        if (-not $hfRoot) {{
          throw "Berkeley HardFloat not found. Run {bootstrap_hint} before regenerating RTL."
        }}
        Push-Location $hfRoot
        try {{
          if (Get-Command sbt -ErrorAction SilentlyContinue) {{
            sbt "runMain {gen_class} ../../fp_blocks/{block}/rtl"
          }} elseif (Test-Path "sbt-launch.jar") {{
            java -jar sbt-launch.jar "runMain {gen_class} ../../fp_blocks/{block}/rtl"
          }} else {{
            throw "sbt not found and no sbt-launch.jar present"
          }}
          if ($LASTEXITCODE -ne 0) {{ throw "sbt failed" }}
        }} finally {{
          Pop-Location
        }}
        """
    )
    (block_dir / "generate.ps1").write_text(ps1, encoding="utf-8")
    (block_dir / "README.md").write_text(
        textwrap.dedent(
            f"""\
            # {block}
            Generated by MAWS FP block wizard.
            - Interface: {args.interface}
            - Formats: {formats}
            - Ops: see config.json for opcode map and formats.
            - Rounding: {rounding}
            - Tininess: {tininess}
            - Generator: {gen_class}
            """
        ),
        encoding="utf-8",
    )

    if not args.skip_sbt:
        run_sbt(gen_class, block_dir / "rtl")

    print(f"[generate_block] Created scaffold at {block_dir}")


if __name__ == "__main__":
    main()
