# Modular Accelerator Wrapper Stream (MAWS)

MAWS is a modular, scriptable flow for composing floating-point accelerator blocks behind a DMX-style issue hub, verifying them with supplied ModelSim benches, and exporting turn-key IP packages.

## Prerequisites

- Python 3.11+ (standard library only)
- Java 11+ and [sbt](https://www.scala-sbt.org/) for the Chisel/HardFloat generators
- ModelSim/Questa for the supplied functional testbenches (optional but recommended)
- FPGA toolchain for downstream integration

## First-Time Setup

1. Clone this repo.
2. Fetch Berkeley HardFloat: `python scripts/bootstrap_hardfloat.py`
3. Follow the workflow below to generate blocks and systems.

### Build or clone FP blocks (`Blocks/`)

- Generate new blocks with the wizard:
  ```
  python Blocks/generate_block.py
  ```
  This produces `Blocks/fp_blocks/<block>/` along with a `generate.ps1` helper ready to rebuild RTL once HardFloat is present.
- Use the functional TB scaffolds under `Blocks/functional-tb/` to validate blocks before composing them into a system.

### Assemble a DMX system (`IP-creator/`)

- Use the CLI wizard or provide a JSON config (see `IP-creator/examples/minimal_design.json`):
  ```
  python IP-creator/generate_maw.py --name fp32_demo --blocks ieee_fp32_mul --system-name maws_system
  ```
- Output lands in `IP-creator/maw_blocks/<design>/` (config, HDL, TB, docs, packaging stubs).

### Verify

- Run the supplied CPU+DMX testbench under `IP-creator/functional-tb/fp_cpu_dmx_sim/` (`vsim -c -do run_tb.do`).
- Add vectors under `<design>/tb/` and iterate until both block-level and system-level benches pass.

## Repository Layout

- `Blocks/` – FP block wizard, block sources, and block-level TB helpers.
  - `generators/` – drop third-party generators here (e.g., Berkeley HardFloat).
  - `fp_blocks/` – checked-in sample blocks ready to use or extend.
- `Documentation/` – reference material for DMX, opcodes, and architecture notes.
- `IP-creator/` – system generator, configs, ModelSim benches, and empty `maw_blocks/` output folder.
- `scripts/` – helpers such as `bootstrap_hardfloat.py`.

## Credits

MAWS builds on the excellent [Berkeley HardFloat](https://github.com/ucb-bar/berkeley-hardfloat) project for FP unit generation, with additional contributions from [Yara Al Shorman](https://github.com/YaraAlShorman). Please reference the upstream projects and licenses when redistributing generated blocks or emitters.
