# FP CPU + DMX Simulation Playground

This sandbox mirrors the original `fp_cpu_sim` project but routes all math through the DMX hub and wrappers:

1. `fp_blocks/fp32_block_workspace` – FP32 HardFloat block accessed via the DMX FP32 wrapper.
2. `fp_cpu_sim/src/FP64MatrixMulBlock_ns.sv` – FP64 2×2 matrix multiplier accessed via the DMX FP64 wrapper.
3. `DMX/src` – `dmx_hub` plus FP32/FP64 wrapper glue.

`src/fp_cpu_dmx_top.sv` performs the same three micro-coded stages as the original CPU, but issues DMX instructions instead of driving the blocks directly:

1. **FP32 Stage (FMA)** – issues `OPC_FP32_FMA` (FMT_FP32) and records the IEEE32 result/flags/latency.
2. **FP64 Stage (matrix multiply)** – streams A/B rows via FP64 load opcodes, kicks `OPC_FP64_EXECUTE`, latches C00/flags from the DMX completion.
3. **FP32 Stage (final add)** – converts C00 to IEEE32, issues `OPC_FP32_ADD` with a constant, and logs result/flags/latency.

## Layout

- `src/fp_cpu_dmx_top.sv` – CPU/control FSM, IEEE↔recFN helpers, DMX instruction issue, telemetry.
- `src/FP64MatrixMulBlock_ns.sv` – namespaced FP64 block used by the FP64 wrapper.
- `modelsim_demo/` – ready-to-run ModelSim example:
  - `tb_cpu_generic.sv` – DMX + wrappers + pluggable CPU script driver.
  - `cpu_scripts/` – drop-in CPU driver tasks (e.g., `nominal`, `sum_mul`).
  - `run_tb.do` – compiles the design and runs the selected CPU script.

Regenerate the CPU script manifest when adding/removing scripts:

```
python modelsim_demo/generate_cpu_script_manifest.py
```

## Running the Example

```
cd IP-creator/functional-tb/fp_cpu_dmx_sim/modelsim_demo
vsim -c -do "do run_tb.do"
CPU_SCRIPT=sum_mul vsim -c -do "do run_tb.do"
vsim -c -do "do run_tb.do -sum_mul"
python analyze_latencies.py                  # optional: reuse plotting helpers
python plot_data_flow.py
```

`run_tb.do` accepts the script name via (priority) argument to the do file (e.g., `-sum_mul`), `CPU_SCRIPT` env variable, or falls back to the testbench default/explicit `-gCPU_SCRIPT_PARAM=<name>`.

Each testbench report mirrors `fp_cpu_sim`: hex/decimal values, exception flags, per-stage latency, and data-path narrative. CSV traces remain compatible with the existing Python plotting helpers. Use this variant to study DMX issue/retire timing and flag behavior without changing the higher-level CPU flow.
