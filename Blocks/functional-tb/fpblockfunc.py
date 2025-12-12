"""
Generic functional testbench runner for MAWS blocks.

Usage:
  python fpblockfunc.py <block_name> --vectors a,b a,b ...
  python fpblockfunc.py <block_name> --vector-file vectors.txt [--expected-file expected.txt]

Assumptions:
  - Manifest lives at Blocks/fp_blocks/<block_name>/functional-tb/manifest.json
  - Manifest contains:
      {
        "top_module": "Fp16Adder",
        "filelist": [
          "Blocks/fp_blocks/hardfloat_fp16_adder/rtl/Fp16Adder.v"
        ],
        "inputs": [
          {"name": "a", "width": 16},
          {"name": "b", "width": 16},
          {"name": "roundingMode", "width": 3, "default": 0}
        ],
        "outputs": [
          {"name": "out", "width": 16},
          {"name": "exceptionFlags", "width": 5}
        ]
      }
  - Uses ModelSim (vsim) in PATH.
"""

from __future__ import annotations

import argparse
import json
import pathlib
import subprocess
import sys
import tempfile
from typing import Any, Dict, List, Optional


def load_manifest(block: str, repo_root: pathlib.Path) -> Dict[str, Any]:
    manifest_path = repo_root / "Blocks" / "fp_blocks" / block / "functional-tb" / "manifest.json"
    if not manifest_path.exists():
        raise SystemExit(f"Manifest not found: {manifest_path}")
    with manifest_path.open("r", encoding="utf-8") as fh:
        return json.load(fh)


def parse_vectors(raw_vectors: List[str], inputs: List[Dict[str, Any]]) -> List[List[str]]:
    if not raw_vectors:
        raise SystemExit("Provide at least one vector (via --vectors or --vector-file).")
    expected = len(inputs)
    parsed: List[List[str]] = []
    for v in raw_vectors:
        parts = v.split(",")
        if len(parts) != expected:
            raise SystemExit(f"Vector '{v}' has {len(parts)} fields, expected {expected}.")
        parsed.append(parts)
    return parsed


def load_lines_file(path: pathlib.Path) -> List[str]:
    if not path.exists():
        raise SystemExit(f"File not found: {path}")
    with path.open("r", encoding="utf-8") as fh:
        lines = [ln.strip() for ln in fh.readlines() if ln.strip() and not ln.strip().startswith("#")]
    return lines


def gen_tb(manifest: Dict[str, Any], vectors: List[List[str]], expected: Optional[List[List[str]]], vec_delay: int) -> str:
    top = manifest["top_module"]
    inputs = manifest["inputs"]
    outputs = manifest["outputs"]
    has_out_valid = any(o["name"] == "io_outValid" for o in outputs)

    def should_drive(name: str) -> bool:
        # clock/reset already have dedicated generators; keep them out of vector-driven assigns
        return name not in ("clock", "reset")

    lines: List[str] = []
    lines.append("`timescale 1ns/1ps")
    lines.append("")
    lines.append("module tb_block;")
    for sig in inputs:
        lines.append(f"  logic [{sig['width']-1}:0] {sig['name']};")
    for sig in outputs:
        lines.append(f"  logic [{sig['width']-1}:0] {sig['name']};")
    if has_out_valid:
        lines.append("  logic sample_io_outValid;")
    lines.append("")
    lines.append(f"  {top} dut (")
    port_lines = []
    for sig in inputs:
        port_lines.append(f"    .{sig['name']}({sig['name']})")
    for sig in outputs:
        port_lines.append(f"    .{sig['name']}({sig['name']})")
    lines.append(",\n".join(port_lines))
    lines.append("  );")
    lines.append("")
    lines.append("  initial clock = 1'b0;")
    lines.append("  always #5 clock = ~clock;")
    lines.append("  initial begin reset = 1'b1; #40; reset = 1'b0; end")
    lines.append("")
    lines.append("  integer pass_count;")
    lines.append("  integer flag_count;")
    lines.append("  integer cmp_total;")
    lines.append("  integer cmp_match;")
    lines.append("  integer cmp_fail;")
    lines.append("  integer cmp_unknown;")
    lines.append("  integer wait_cycles;")
    lines.append("")
    lines.append("  initial begin")
    lines.append("    bit any_unknown;")
    lines.append("    bit any_mismatch;")
    lines.append("    bit saw_outvalid;")
    # defaults
    lines.append("    pass_count = 0;")
    lines.append("    flag_count = 0;")
    lines.append("    cmp_total = 0;")
    lines.append("    cmp_match = 0;")
    lines.append("    cmp_fail = 0;")
    lines.append("    cmp_unknown = 0;")
    if has_out_valid:
        lines.append("    sample_io_outValid = 1'b0;")
    for sig in inputs:
        if not should_drive(sig["name"]):
            continue
        default = sig.get("default", 0)
        lines.append(f"    {sig['name']} = {sig['width']}'h{default:x};")
    lines.append("    #20;")
    for idx, vec in enumerate(vectors):
        for sig, val in zip(inputs, vec):
            if not should_drive(sig["name"]):
                continue
            lines.append(f"    {sig['name']} = {sig['width']}'h{val};")
        if any(o["name"] == "io_outValid" for o in outputs):
            lines.append("    wait_cycles = 0;")
            lines.append("    any_unknown = 0;")
            lines.append("    saw_outvalid = 0;")
            lines.append(f"    while (wait_cycles < {vec_delay//10} && !saw_outvalid) begin")
            lines.append("      @(posedge clock);")
            lines.append("      wait_cycles = wait_cycles + 1;")
            lines.append("      if (^io_outValid === 1'bx) begin")
            lines.append("        any_unknown = 1;")
            lines.append("      end else if (io_outValid === 1'b1) begin")
            lines.append("        saw_outvalid = 1;")
            lines.append("      end")
            lines.append("    end")
            if has_out_valid:
                lines.append("    sample_io_outValid = saw_outvalid ? 1'b1 : io_outValid;")
            lines.append("    if (!saw_outvalid) begin")
            lines.append(f'      $display("[warn] vec={idx} io_outValid not asserted within wait window, skipping check");')
            lines.append("      any_unknown = 1;")
            lines.append("    end else begin")
            lines.append("      #1;")
            lines.append("    end")
        else:
            lines.append(f"    #{vec_delay};")
        out_disp = " ".join([f"{o['name']}=0x%h" for o in outputs])
        out_vars = ", ".join(
            [("sample_" + o["name"]) if (has_out_valid and o["name"] == "io_outValid") else o["name"] for o in outputs]
        )
        if expected:
            exp_disp = " ".join([f"{name}_exp=0x%h" for name in [o['name'] for o in outputs]])
            exp_vals = ", ".join([f"{o['width']}'h{exp_val}" for o, exp_val in zip(outputs, expected[idx])])
            lines.append(f'    $display("[resp] vec={idx} {out_disp} || {exp_disp}", {out_vars}, {exp_vals});')
        else:
            lines.append(f'    $display("[resp] vec={idx} {out_disp}", {out_vars});')
        if expected:
            lines.append("    any_unknown = 0;")
            lines.append("    any_mismatch = 0;")
            lines.append("    cmp_total = cmp_total + 1;")
            for o, exp_val in zip(outputs, expected[idx]):
                sig_name = f"sample_{o['name']}" if (has_out_valid and o["name"] == "io_outValid") else o["name"]
                lines.append(f"    if (^({sig_name}) === 1'bx) begin")
                lines.append(f'      $display("[warn] vec={idx} {o["name"]} unknown, skipping check");')
                lines.append("      any_unknown = 1;")
                lines.append("    end else if (")
                lines.append(f"      {sig_name} !== {o['width']}'h{exp_val}) begin")
                lines.append("      any_mismatch = 1;")
                lines.append(f'      $display("[error] vec={idx} {o["name"]} expected 0x{exp_val} got 0x%h", {sig_name});')
                lines.append("    end")
            lines.append("    if (any_unknown) begin")
            lines.append("      cmp_unknown = cmp_unknown + 1;")
            lines.append("    end else if (any_mismatch) begin")
            lines.append("      cmp_fail = cmp_fail + 1;")
            lines.append("    end else begin")
            lines.append("      cmp_match = cmp_match + 1;")
            lines.append("      pass_count = pass_count + 1;")
            # If exceptionFlags present, track flag matches separately (assumes last output is flags)
            flag_sig = next((o for o in outputs if o["name"] == "io_exceptionFlags"), None)
            if flag_sig:
                lines.append(
                    f"      if (io_exceptionFlags === {flag_sig['width']}'h{expected[idx][-1]}) flag_count = flag_count + 1;")
            lines.append("    end")
    lines.append("    #20;")
    lines.append('    $display("[info] Vectors passed: %0d/%0d", pass_count, ' + str(len(vectors)) + ");")
    lines.append('    $display("[info] Compare summary: matched=%0d mismatched=%0d unknown=%0d total=%0d", cmp_match, cmp_fail, cmp_unknown, cmp_total);')
    lines.append('    $display("[info] Exception flag matches: %0d/%0d", flag_count, ' + str(len(vectors)) + ");")
    lines.append("    $finish;")
    lines.append("  end")
    lines.append("endmodule")
    return "\n".join(lines)


def gen_do(filelist: List[str], tb_path: pathlib.Path, repo_root: pathlib.Path) -> str:
    lines = ["vlib work", "vmap work work"]
    for f in filelist:
        abs_f = (repo_root / f).resolve().as_posix()
        lines.append(f"vlog {abs_f}")
    lines.append(f"vlog {tb_path.name}")
    lines.append("vsim tb_block")
    lines.append("run -all")
    lines.append("quit -code 0")
    return "\n".join(lines)


def run_vsim(do_path: pathlib.Path) -> None:
    # ModelSim on Windows needs forward slashes in "do" paths.
    do_dir = str(do_path.parent).replace("\\", "/")
    cmd = ["vsim", "-c", "-do", f"cd {do_dir} ; do run.do"]
    print(f"[fpblockfunc] Running: {' '.join(cmd)}")
    subprocess.run(cmd, check=True)


def main() -> None:
    parser = argparse.ArgumentParser(description="Generic functional TB runner for MAWS blocks")
    parser.add_argument("block", help="Block name (folder under Blocks/fp_blocks/<block>/functional-tb/manifest.json)")
    parser.add_argument(
        "--vectors",
        nargs="+",
        help="Comma-separated input values per vector (hex). Order matches manifest inputs.",
    )
    parser.add_argument("--vector-file", help="File containing vectors (one comma-separated line per vector).")
    parser.add_argument("--expected-file", help="File containing expected outputs (one line per vector, comma-separated per manifest outputs).")
    parser.add_argument("--vector-delay", type=int, default=100, help="Delay (ns) to wait after driving each vector before sampling outputs.")
    args = parser.parse_args()

    repo_root = pathlib.Path(__file__).resolve().parents[2]
    manifest = load_manifest(args.block, repo_root)
    raw_vecs = args.vectors or []
    if args.vector_file:
        raw_vecs = load_lines_file(pathlib.Path(args.vector_file))
    vectors = parse_vectors(raw_vecs, manifest["inputs"])
    raw_expected = None
    if args.expected_file:
        raw_expected = load_lines_file(pathlib.Path(args.expected_file))
        if len(raw_expected) != len(vectors):
            raise SystemExit("Expected file line count must match vector count.")
        raw_expected = [ln.split(",") for ln in raw_expected]

    tb_src = gen_tb(manifest, vectors, raw_expected, args.vector_delay)
    do_src = gen_do(manifest["filelist"], pathlib.Path("tb_block.sv"), repo_root)

    with tempfile.TemporaryDirectory() as tmpdir:
        tmpdir_path = pathlib.Path(tmpdir)
        tb_path = tmpdir_path / "tb_block.sv"
        do_path = tmpdir_path / "run.do"
        tb_path.write_text(tb_src, encoding="utf-8")
        do_path.write_text(do_src, encoding="utf-8")
        run_vsim(do_path)


if __name__ == "__main__":
    main()
