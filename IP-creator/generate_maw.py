from __future__ import annotations

import argparse
from datetime import datetime, timezone
import json
import re
import subprocess
import sys
import shutil
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional, Set

REPO_ROOT = Path(__file__).resolve().parents[1]
IP_ROOT = Path(__file__).resolve().parent
BLOCKS_ROOT = REPO_ROOT / "Blocks" / "fp_blocks"
DMX_SBT_ROOT = IP_ROOT / "generators" / "dmx"
DEFAULT_OUT_ROOT = IP_ROOT / "maw_blocks"


@dataclass
class BlockSpec:
    name: str
    top: str
    fmt: int
    manifest: Dict
    uses_c: bool
    uses_subop: bool
    uses_rounding: bool

    @property
    def filelist(self) -> List[str]:
        return self.manifest.get("filelist", [])

    @property
    def inputs(self) -> List[Dict]:
        return self.manifest.get("inputs", [])

    @property
    def outputs(self) -> List[Dict]:
        return self.manifest.get("outputs", [])


def _load_json(path: Path) -> Dict:
    return json.loads(path.read_text())


def _write_json(path: Path, payload: Dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def _has_port(inputs: List[Dict], name: str) -> bool:
    return any(p.get("name") == name for p in inputs)


def _width_of(items: List[Dict], name: str, default: int = 0) -> int:
    for item in items:
        if item.get("name") == name:
            return int(item.get("width", default))
    return default


def load_block_spec(entry: Dict) -> BlockSpec:
    name = entry["name"]
    manifest_path = Path(
        entry.get(
            "manifest",
            BLOCKS_ROOT / name / "functional-tb" / "manifest.json",
        )
    ).resolve()
    if not manifest_path.exists():
        raise SystemExit(f"Block manifest not found for {name}: {manifest_path}")

    manifest = _load_json(manifest_path)
    top = entry.get("top") or manifest.get("top_module") or name
    fmt = int(entry.get("fmt", entry.get("format", 0)))
    uses_c = entry.get("uses_c")
    uses_subop = entry.get("uses_subOp") or entry.get("uses_subop")
    uses_rounding = entry.get("uses_rounding")

    inputs = manifest.get("inputs", [])
    uses_c = bool(_has_port(inputs, "io_c")) if uses_c is None else bool(uses_c)
    uses_subop = bool(_has_port(inputs, "io_subOp")) if uses_subop is None else bool(uses_subop)
    uses_rounding = bool(_has_port(inputs, "io_roundingMode")) if uses_rounding is None else bool(uses_rounding)

    return BlockSpec(
        name=entry.get("instance") or name,
        top=top,
        fmt=fmt,
        manifest=manifest,
        uses_c=uses_c,
        uses_subop=uses_subop,
        uses_rounding=uses_rounding,
    )


def default_formats(config: Dict) -> List[Dict]:
    if "formats" in config:
        return config["formats"]
    return [{"id": 0, "name": "fp64", "exp": 11, "sig": 53}]


def derive_ops(config: Dict, blocks: List[BlockSpec]) -> List[Dict]:
    if "ops" in config and config["ops"]:
        return config["ops"]

    ops: List[Dict] = []
    for idx, blk in enumerate(blocks):
        ops.append(
            {
                "name": f"OP_{blk.name}",
                "opcode": idx,
                "fmt": blk.fmt,
                "block": blk.name,
                "uses_subOp": blk.uses_subop,
                "uses_rounding": blk.uses_rounding,
                "uses_c": blk.uses_c,
            }
        )
    return ops


def build_dmx_config(config: Dict, blocks: List[BlockSpec], system_name: str) -> Dict:
    ops = derive_ops(config, blocks)
    block_names = {b.name for b in blocks}
    for op in ops:
        if op["block"] not in block_names:
            raise SystemExit(f"Op '{op['name']}' references unknown block '{op['block']}'")
    return {
        "system": system_name,
        "tidWidth": int(config.get("tid_width", 4)),
        "busWidth": int(config.get("bus_width", 64)),
        "formats": default_formats(config),
        "blocks": [
            {"name": blk.name, "top": blk.top, "fmt": blk.fmt, "manifest": blk.manifest}
            for blk in blocks
        ],
        "ops": ops,
    }



def run_sbt(cfg_path: Path, out_hdl: Path, sbt_cmd: str) -> None:
    resolved = shutil.which(sbt_cmd)
    if resolved is None:
        raise SystemExit(f"sbt command '{sbt_cmd}' not found. Install sbt or override with --sbt-cmd.")

    task = f'"runMain dmx.EmitDmx {cfg_path} {out_hdl}"'
    use_shell = resolved.lower().endswith((".bat", ".cmd"))
    if use_shell:
        cmd = f'"{resolved}" {task}'
    else:
        cmd = [resolved, task]

    print(f"[maw_generate] Running: {cmd}")
    log_path = out_hdl.parent / "logs" / "sbt.log"
    log_path.parent.mkdir(parents=True, exist_ok=True)
    proc = subprocess.Popen(
        cmd,
        cwd=DMX_SBT_ROOT,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        shell=use_shell,
    )
    lines: List[str] = []
    assert proc.stdout is not None
    for line in proc.stdout:
        sys.stdout.write(line)
        sys.stdout.flush()
        lines.append(line)
    proc.wait()
    log_path.write_text("".join(lines), encoding="utf-8")
    if proc.returncode != 0:
        raise SystemExit(f"sbt DMX generation failed (see {log_path}). Return code {proc.returncode}")


def render_design_readme(design: str, config_dir: Path, hdl_dir: Path, system_top: str) -> str:
    return f"""# {design} DMX IP

Artifacts generated under this folder are ready to drop into vendor-neutral flows.

Structure:
- config/: frozen config used to emit DMX
- hdl/: generated SystemVerilog (dmx_pkg.sv, dmx_wrapper.sv, dmx_system.sv)
- tb/: functional TB scaffold (user to populate stimuli)
- docs/: design-specific manifest and quickstart
- scripts/: helper packaging stubs
- constraints/: placeholder for pin/timing constraints
- logs/: generation log

Regenerate:
  python IP-creator/generate_maw.py
  # reuse saved config at {config_dir / 'design.json'} (wizard auto-saves)

Top module: {system_top}_dmx_system (wrapper: {system_top}_dmx_wrapper)
HDL path: {hdl_dir}
"""


def render_tb_stub(design: str, bus_width: int, tid_width: int, system_top: str) -> str:
    top = f"{system_top}_dmx_system"
    return f"""`timescale 1ns/1ps

module tb_{design};
  reg clock = 0;
  reg reset_n = 0;
  reg instr_valid = 0;
  reg [7:0] instr_opcode = 0;
  reg [1:0] instr_fmt = 0;
  reg [{bus_width-1}:0] src0_data = 0;
  reg [{bus_width-1}:0] src1_data = 0;
  reg [{bus_width-1}:0] src2_data = 0;
  reg [{tid_width-1}:0] cpu_tid = 0;
  reg [2:0] csr_rounding_mode = 0;
  reg csr_tininess_mode = 0;
  wire cpu_req_ready;
  wire cpu_resp_valid;
  wire [{tid_width-1}:0] cpu_resp_tid;
  wire [{bus_width-1}:0] cpu_resp_data;
  wire [4:0] cpu_resp_flags;

  always #5 clock = ~clock;

  initial begin
    reset_n = 0;
    #50;
    reset_n = 1;
    instr_valid = 0;
    // TODO: drive instructions/opcodes and data
    #500;
    $finish;
  end

  {top} dut (
    .clock(clock),
    .reset(reset_n), // active-high in generated system
    .io_clock(clock),
    .io_reset_n(reset_n),
    .io_instr_valid(instr_valid),
    .io_instr_opcode(instr_opcode),
    .io_instr_fmt(instr_fmt),
    .io_src0_data(src0_data),
    .io_src1_data(src1_data),
    .io_src2_data(src2_data),
    .io_cpu_tid(cpu_tid),
    .io_csr_rounding_mode(csr_rounding_mode),
    .io_csr_tininess_mode(csr_tininess_mode),
    .io_cpu_req_ready(cpu_req_ready),
    .io_cpu_resp_valid(cpu_resp_valid),
    .io_cpu_resp_tid(cpu_resp_tid),
    .io_cpu_resp_data(cpu_resp_data),
    .io_cpu_resp_flags(cpu_resp_flags)
  );
endmodule
"""


def build_design_manifest(
    design_name: str, system_top: str, hdl_files: List[str], dmx_cfg: Dict, blocks: List[BlockSpec]
) -> Dict:
    return {
        "design_name": design_name,
        "top_module": f"{system_top}_dmx_system",
        "wrapper_module": f"{system_top}_dmx_wrapper",
        "hdl": hdl_files,
        "dmx_config": "config/dmx_config.json",
        "blocks": [
            {
                "name": blk.name,
                "top": blk.top,
                "fmt": blk.fmt,
                "filelist": blk.filelist,
                "inputs": blk.inputs,
                "outputs": blk.outputs,
            }
            for blk in blocks
        ],
        "ops": dmx_cfg["ops"],
        "bus_width": dmx_cfg["busWidth"],
        "tid_width": dmx_cfg["tidWidth"],
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "vectors": "tb/vectors.txt",
        "expected": "tb/expected.txt",
    }


def run_generation(user_cfg: Dict, args: argparse.Namespace, cfg_source: Path) -> Path:
    if "design_name" not in user_cfg:
        raise SystemExit("Config must include design_name.")

    requested_system = args.system_name or user_cfg.get("system_name") or "maws_system"
    sanitized = re.sub(r"[^A-Za-z0-9_]", "_", requested_system.strip())
    system_name = sanitized or "maws_system"
    user_cfg["system_name"] = system_name

    out_root = Path(args.out_root or DEFAULT_OUT_ROOT).resolve() / user_cfg["design_name"]
    hdl_dir = out_root / "hdl"
    config_dir = out_root / "config"
    tb_dir = out_root / "tb"
    docs_dir = out_root / "docs"
    scripts_dir = out_root / "scripts"
    constraints_dir = out_root / "constraints"
    logs_dir = out_root / "logs"

    blocks = [load_block_spec(entry) for entry in user_cfg.get("blocks", [])]
    if not blocks:
        raise SystemExit("Config must list at least one block under 'blocks'.")

    dmx_cfg = build_dmx_config(user_cfg, blocks, system_name)

    # Persist configs
    config_dir.mkdir(parents=True, exist_ok=True)
    _write_json(config_dir / "design.json", user_cfg)
    _write_json(config_dir / "dmx_config.json", dmx_cfg)

    # Generate HDL via sbt/Chisel
    hdl_dir.mkdir(parents=True, exist_ok=True)
    if not args.skip_sbt:
        run_sbt(config_dir / "dmx_config.json", hdl_dir, args.sbt_cmd)
    else:
        print("[maw_generate] Skipping sbt DMX generation (--skip-sbt)")
    # Remove standalone wrapper (dmx_system contains wrapper module)
    wrapper_path = hdl_dir / "dmx_wrapper.sv"
    if wrapper_path.exists():
        wrapper_path.unlink()

    # Collateral: TB scaffold and sample vectors/expected
    tb_dir.mkdir(parents=True, exist_ok=True)
    (tb_dir / f"tb_{user_cfg['design_name']}.sv").write_text(
        render_tb_stub(user_cfg["design_name"], dmx_cfg["busWidth"], dmx_cfg["tidWidth"], system_name),
        encoding="utf-8",
    )
    # If user provided vectors/expected in config, copy; otherwise emit placeholders
    vec_lines = user_cfg.get("vectors", [])
    exp_lines = user_cfg.get("expected", [])
    if vec_lines:
        (tb_dir / "vectors.txt").write_text("\n".join(vec_lines) + "\n", encoding="utf-8")
    else:
        (tb_dir / "vectors.txt").write_text("# instr_valid,opcode,fmt,src0,src1,src2,tid,round,tininess\n", encoding="utf-8")
    if exp_lines:
        (tb_dir / "expected.txt").write_text("\n".join(exp_lines) + "\n", encoding="utf-8")
    else:
        (tb_dir / "expected.txt").write_text("# optional expected outputs\n", encoding="utf-8")

    docs_dir.mkdir(parents=True, exist_ok=True)
    (docs_dir / "README.md").write_text(
        render_design_readme(user_cfg["design_name"], config_dir, hdl_dir, system_name),
        encoding="utf-8",
    )

    scripts_dir.mkdir(parents=True, exist_ok=True)
    (scripts_dir / "pack.tcl").write_text(
        "# Placeholder TCL for vendor packaging. Add create_ip or add_files commands here.\n", encoding="utf-8"
    )

    constraints_dir.mkdir(parents=True, exist_ok=True)
    (constraints_dir / "README.md").write_text(
        "Add XDC/SDC constraints for your target platform here.\n", encoding="utf-8"
    )

    logs_dir.mkdir(parents=True, exist_ok=True)
    (logs_dir / "generate.log").write_text(
        f"Generated {user_cfg['design_name']} at {datetime.now(timezone.utc).isoformat()}\n"
        f"Config source: {cfg_source}\n"
        f"sbt skipped: {args.skip_sbt}\n",
        encoding="utf-8",
    )

    def strip_duplicate_modules(text: str, seen: Set[str]) -> str:
        out_lines: List[str] = []
        skipping = False
        current_mod = None
        mod_re = re.compile(r"^\s*module\s+([A-Za-z0-9_]+)")
        end_re = re.compile(r"^\s*endmodule\b")
        for line in text.splitlines():
            if not skipping:
                m = mod_re.match(line)
                if m:
                    name = m.group(1)
                    if name in seen:
                        skipping = True
                        current_mod = name
                        continue
                    seen.add(name)
                out_lines.append(line)
            else:
                if end_re.match(line):
                    skipping = False
                    current_mod = None
        return "\n".join(out_lines) + "\n"

    copied_block_files: List[str] = []
    copied_paths: Set[Path] = set()
    seen_modules: Set[str] = set()
    for blk in blocks:
        for src in blk.filelist:
            src_path = (REPO_ROOT / src).resolve()
            if not src_path.exists():
                print(f"[warn] File from block list not found, skipping: {src_path}")
                continue
            text = src_path.read_text(encoding="utf-8", errors="ignore")
            filtered = strip_duplicate_modules(text, seen_modules)
            # If no modules remain, skip writing a blank file
            if not any(line.strip().startswith("module ") for line in filtered.splitlines()):
                continue
            rel_target = Path("hdl") / "blocks" / blk.name / src_path.name
            dest_path = out_root / rel_target
            if dest_path in copied_paths:
                continue
            dest_path.parent.mkdir(parents=True, exist_ok=True)
            dest_path.write_text(filtered, encoding="utf-8")
            copied_paths.add(dest_path)
            copied_block_files.append(str(rel_target).replace("\\", "/"))

    hdl_files = [
        "hdl/dmx_pkg.sv",
        "hdl/dmx_system.sv",
    ]
    hdl_files.extend(copied_block_files)

    #Quartus sourc list
    qsf_tcl = scripts_dir / "quartus_sources.tcl"
    qsf_lines = []
    for f in hdl_files:
        qsf_lines.append(f'set_global_assignment -name SYSTEMVERILOG_FILE "{(out_root / f).resolve()}"')
    qsf_tcl.write_text("\n".join(qsf_lines) + "\n", encoding="utf-8")

    manifest = build_design_manifest(user_cfg["design_name"], system_name, hdl_files, dmx_cfg, blocks)
    _write_json(out_root / "design_manifest.json", manifest)

    print(f"[maw_generate] Wrote IP to {out_root}")
    return out_root


def parse_args(argv: Optional[List[str]] = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="MAW IP-creator wizard")
    parser.add_argument("--name", help="Design name (noninteractive).")
    parser.add_argument("--bus-width", type=int, help="Bus width (default 64).")
    parser.add_argument("--tid-width", type=int, help="TID width (default 4).")
    parser.add_argument(
        "--blocks",
        help="Comma-separated block names from Blocks/fp_blocks (noninteractive).",
    )
    parser.add_argument(
        "--vectors",
        help="Path to a vectors file to copy into tb/vectors.txt (noninteractive).",
    )
    parser.add_argument(
        "--expected",
        help="Path to an expected file to copy into tb/expected.txt (noninteractive).",
    )
    parser.add_argument("--out-root", help="Output root (default: IP-creator/maw_blocks)")
    parser.add_argument(
        "--skip-sbt", action="store_true", help="Skip running sbt (assumes HDL already generated)"
    )
    parser.add_argument("--sbt-cmd", default="sbt", help="sbt command (default: sbt)")
    parser.add_argument("--system-name", help="Override the system/module prefix (default: maws_system)")
    return parser.parse_args(argv)


def interactive_wizard() -> Dict:
    print("MAW IP-creator interactive wizard")
    design_name = input("Design name [maw_system]: ").strip() or "maw_system"
    system_name = input("System prefix for module names [maws_system]: ").strip() or "maws_system"
    try:
        bus_width = int(input("Bus width [64]: ").strip() or "64")
    except ValueError:
        bus_width = 64
    try:
        tid_width = int(input("TID width [4]: ").strip() or "4")
    except ValueError:
        tid_width = 4

    available = sorted([p.name for p in BLOCKS_ROOT.iterdir() if p.is_dir()]) if BLOCKS_ROOT.exists() else []
    if available:
        print("Available Blocks/fp_blocks:")
        for idx, name in enumerate(available):
            print(f" [{idx}] {name}")
    raw_blocks = input("Select blocks (comma-separated indices): ").strip()
    selections: List[str] = []
    if raw_blocks:
        for token in raw_blocks.split(","):
            token = token.strip()
            if not token:
                continue
            try:
                idx = int(token)
                if idx < 0 or idx >= len(available):
                    raise ValueError
                selections.append(available[idx])
            except ValueError:
                print(f"Ignoring invalid selection '{token}'")
    if not selections:
        raise SystemExit("No blocks selected.")

    blocks_cfg: List[Dict] = []
    for name in selections:
        instance = input(f"Instance name for {name} [default: {name}]: ").strip() or name
        fmt_raw = input(f"Format id for {instance} [0]: ").strip() or "0"
        try:
            fmt_val = int(fmt_raw)
        except ValueError:
            fmt_val = 0
        blocks_cfg.append({"name": name, "instance": instance, "fmt": fmt_val})

    include_vectors = input("Add sample vectors/expected files? [y/N]: ").strip().lower().startswith("y")

    vectors: List[str] = []
    expected: List[str] = []
    if include_vectors:
        print("Enter vectors as: instr_valid,opcode,fmt,src0,src1,src2,tid,round,tininess (hex for data). Empty line to stop.")
        while True:
            line = input("vector> ").strip()
            if not line:
                break
            vectors.append(line)
        print("Enter expected outputs as: outputs in manifest order (comma-separated). Empty line to stop.")
        while True:
            line = input("expected> ").strip()
            if not line:
                break
            expected.append(line)

    print("Using derived ops (one per block, sequential opcodes). Provide custom ops by editing the saved config later if needed.")
    return {
        "design_name": design_name,
        "system_name": system_name,
        "bus_width": bus_width,
        "tid_width": tid_width,
        "blocks": blocks_cfg,
        "vectors": vectors,
        "expected": expected,
    }


def main(argv: Optional[List[str]] = None) -> None:
    args = parse_args(argv)

    if args.name and args.blocks:

        def block_entry_from_token(token: str) -> Dict:
            t = token.strip()
            if not t:
                return {}
            if t.startswith(("/", "\\")) or t.replace("\\", "/").startswith("Blocks/"):
                t_clean = t.lstrip("\\/")
                path_hint = REPO_ROOT / t_clean
                name = Path(t_clean).name
                manifest = path_hint / "functional-tb" / "manifest.json"
                return {"name": name, "instance": name, "fmt": 0, "manifest": str(manifest)}
            return {"name": t, "instance": t, "fmt": 0}

        blocks_cfg: List[Dict] = []
        for token in args.blocks.split(","):
            entry = block_entry_from_token(token)
            if not entry:
                continue
            blocks_cfg.append(entry)
        cfg = {
            "design_name": args.name,
            "system_name": args.system_name or "maws_system",
            "bus_width": args.bus_width or 64,
            "tid_width": args.tid_width or 4,
            "blocks": blocks_cfg,
            "vectors": [],
            "expected": [],
        }
        if args.vectors:
            cfg["vectors"] = [ln.strip() for ln in Path(args.vectors).read_text().splitlines() if ln.strip() and not ln.strip().startswith("#")]
        if args.expected:
            cfg["expected"] = [ln.strip() for ln in Path(args.expected).read_text().splitlines() if ln.strip() and not ln.strip().startswith("#")]

            
    else:
        cfg = interactive_wizard()

    config_dir = IP_ROOT / "config"
    config_dir.mkdir(parents=True, exist_ok=True)
    tmp_path = config_dir / f"{cfg['design_name']}_interactive.json"
    _write_json(tmp_path, cfg)
    print(f"[wizard] Saved interactive config to {tmp_path}")
    run_generation(cfg, args, tmp_path)


if __name__ == "__main__":
    main()
