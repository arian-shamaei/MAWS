# TestFloat Integration (hook)
- Use berkeley-testfloat-3 to generate vectors for the operations you enabled.
- Map opSel/fmtSel/roundingMode to TestFloat arguments; the wizard records opcodes in config.json.
- io_out carries the numeric result; io_exceptionFlags matches IEEE flags.
- For cmp operations, io_cmpOut exposes compare bits; integer conversions use io_out when integer.
