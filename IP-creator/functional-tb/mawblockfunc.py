"""
CPU-like instruction stream testbench runner for MAW systems.

Usage:
  python mawblockfunc.py <block_name> --vector-file <vectors> [--expected-file <expected>]

Semantics:
  - Each vector line = one instruction payload (non-control inputs only).
  - TB drives clocks/resets, asserts instr_valid for one cycle per vector,
    waits for resp_valid, logs the response in order.
  - Optional expected file: per-vector expected outputs (same order as manifest outputs).

Assumptions:
  - Manifest lives at IP-creator/maw_blocks/<block>/functional-tb/manifest.json
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
    manifest_path = repo_root / "IP-creator" / "maw_blocks" / block / "functional-tb" / "manifest.json"
    if not manifest_path.exists():
        raise SystemExit(f"Manifest not found: {manifest_path}")
    with manifest_path.open("r", encoding="utf-8") as fh:
        return json.load(fh)


def parse_vectors(raw_vectors: List[str], inputs: List[Dict[str, Any]]) -> List[List[str]]:
    if not raw_vectors:
        raise SystemExit("Provide at least one vector (via --vectors or --vector-file).")
    # Skip clocks/resets in vector payload
    def is_ctrl(name: str) -> bool:
        return "clock" in name or name.endswith("_clk") or name == "reset" or "reset_n" in name
    payload_inputs = [i for i in inputs if not is_ctrl(i["name"])]
    expected = len(payload_inputs)
    parsed: List[List[str]] = []
    for v in raw_vectors:
        parts = v.split(",")
        if len(parts) != expected:
            raise SystemExit(f"Vector '{v}' has {len(parts)} fields, expected {expected} payload inputs.")
        parsed.append(parts)
    return parsed


def load_lines_file(path: pathlib.Path) -> List[str]:
    if not path.exists():
        raise SystemExit(f"File not found: {path}")
    with path.open("r", encoding="utf-8") as fh:
        lines = [ln.strip() for ln in fh.readlines() if ln.strip() and not ln.strip().startswith("#")]
    return lines


def gen_tb(manifest: Dict[str, Any], vectors: List[List[str]], expected: Optional[List[List[str]]]) -> str:
    top = manifest["top_module"]
    inputs = manifest["inputs"]
    outputs = manifest["outputs"]

    lines: List[str] = []
    lines.append("`timescale 1ns/1ps")
    lines.append("")
    lines.append("module tb_block;")
    for sig in inputs:
        lines.append(f"  logic [{sig['width']-1}:0] {sig['name']};")
    for sig in outputs:
        lines.append(f"  logic [{sig['width']-1}:0] {sig['name']};")
    lines.append("")
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
    # Drive a clock if present
    clk_names = [s["name"] for s in inputs if "clock" in s["name"] or s["name"].endswith("_clk")]
    if clk_names:
        clk = clk_names[0]
        lines.append(f"  always #5 {clk} = ~{clk};")
    # Apply a simple reset pulse if reset_n exists
    resetn_names = [s["name"] for s in inputs if "reset_n" in s["name"]]
    reset_names = [s["name"] for s in inputs if s["name"] == "reset" or s["name"].endswith("_reset")]
    lines.append("")
    lines.append("  integer pass_count;")
    lines.append("  integer flag_count;")
    lines.append("  initial begin")
    lines.append("    pass_count = 0;")
    lines.append("    flag_count = 0;")
    ctrl_inputs = set()
    for sig in inputs:
        default = sig.get("default", 0)
        lines.append(f"    {sig['name']} = {sig['width']}'h{default:x};")
        if sig["name"] in clk_names or sig["name"] in reset_names or sig["name"] in resetn_names:
            ctrl_inputs.add(sig["name"])
    lines.append("    #10;")
    if resetn_names:
        rn = resetn_names[0]
        lines.append(f"    {rn} = 1'b0;")
        lines.append("    #20;")
        lines.append(f"    {rn} = 1'b1;")
        lines.append("    #10;")
    elif reset_names:
        r = reset_names[0]
        lines.append(f"    {r} = 1'b1;")
        lines.append("    #20;")
        lines.append(f"    {r} = 1'b0;")
        lines.append("    #10;")
    payload_inputs = [i for i in inputs if i["name"] not in ctrl_inputs]
    instr_valid_name = next((i["name"] for i in payload_inputs if "instr_valid" in i["name"]), None)
    resp_valid_name = next((o["name"] for o in outputs if "resp_valid" in o["name"]), None)
    for idx, vec in enumerate(vectors):
        for sig, val in zip(payload_inputs, vec):
            lines.append(f"    {sig['name']} = {sig['width']}'h{val};")
        if instr_valid_name:
            lines.append(f"    {instr_valid_name} = 1'b1;")
            lines.append("    @(posedge clock);")
            lines.append(f"    {instr_valid_name} = 1'b0;")
            if resp_valid_name:
                lines.append(f"    wait({resp_valid_name});")
        else:
            lines.append("    @(posedge clock);")
        out_disp = " ".join([f"{o['name']}=0x%h" for o in outputs])
        out_vars = ", ".join([o["name"] for o in outputs])
        lines.append(f'    $display("[resp] vec={idx} {out_disp}", {out_vars});')
        if expected:
            for o, exp_val in zip(outputs, expected[idx]):
                lines.append(
                    f"    if ({o['name']} !== {o['width']}'h{exp_val}) begin "
                    f'$display("[error] vec={idx} {o["name"]} expected 0x{exp_val} got 0x%h", {o["name"]}); $fatal; end')
            lines.append("    pass_count = pass_count + 1;")
            flag_sig = next((o for o in outputs if o["name"] == "io_exceptionFlags"), None)
            if flag_sig:
                lines.append(
                    f"    if (io_exceptionFlags === {flag_sig['width']}'h{expected[idx][-1]}) flag_count = flag_count + 1;")
        lines.append("    #10;")
    lines.append("    #20;")
    lines.append('    $display("[info] Vectors passed: %0d/%0d", pass_count, ' + str(len(vectors)) + ");")
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
    do_dir = str(do_path.parent).replace("\\", "/")
    cmd = ["vsim", "-c", "-do", f"cd {do_dir} ; do run.do"]
    print(f"[mawblockfunc] Running: {' '.join(cmd)}")
    subprocess.run(cmd, check=True)


def main() -> None:
    parser = argparse.ArgumentParser(description="Generic functional TB runner for MAW system blocks")
    parser.add_argument("block", help="Block name (folder under IP-creator/maw_blocks/<block>/functional-tb/manifest.json)")
    parser.add_argument("--vector-file", required=True, help="File containing vectors (one comma-separated line per vector).")
    parser.add_argument("--expected-file", help="File containing expected outputs (one line per vector, comma-separated per manifest outputs).")
    args = parser.parse_args()

    repo_root = pathlib.Path(__file__).resolve().parents[2]
    manifest = load_manifest(args.block, repo_root)
    raw_vecs = load_lines_file(pathlib.Path(args.vector_file))
    vectors = parse_vectors(raw_vecs, manifest["inputs"])
    raw_expected = None
    if args.expected_file:
        raw_expected = load_lines_file(pathlib.Path(args.expected_file))
        if len(raw_expected) != len(vectors):
            raise SystemExit("Expected file line count must match vector count.")
        raw_expected = [ln.split(",") for ln in raw_expected]

    tb_src = gen_tb(manifest, vectors, raw_expected)
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
