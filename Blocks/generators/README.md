# Generators

This directory hosts any third-party generators that MAWS relies on.

## Required

- `berkeley-hardfloat/`: clone [ucb-bar/berkeley-hardfloat](https://github.com/ucb-bar/berkeley-hardfloat)
  so the FP block wizard can emit new blocks. Run
  `python scripts/bootstrap_hardfloat.py` from the repo root to download it,
  or drop an existing checkout here.

The folder is intentionally ignored in git; users are expected to provide their
own copy before running `Blocks/generate_block.py` or the per-block
`generate.ps1` helpers.
