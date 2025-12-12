# Config Workspace

Interactive runs of `generate_maw.py` save their last-used options here
as `<design>_interactive.json` so you can iterate without re-entering
everything. These files are ignored in git to avoid leaking personal
data.

See `../examples/minimal_design.json` for a clean template that you can
copy, customize, and pass back to the generator via `--name` and
`--blocks`.
