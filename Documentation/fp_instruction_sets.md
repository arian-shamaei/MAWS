# Floating-Point Block Instruction Sets and Bit Maps

Extended reference for the two floating-point blocks in this repository:

- `fp_blocks/fp32_block_workspace`: single-precision HardFloat block with recFN interfaces and selectable operations.
- `fp_blocks/hardfloat_fp64_matrix_quartus`: double-precision 2×2 matrix multiply with IEEE ports and configurable rounding/tininess.

---

## 1) FP32 HardFloat Block (recFN I/O)

### Control (“instruction”) fields

| Field | Bits | Width | Codes / meaning | Source |
| --- | --- | --- | --- | --- |
| `op_sel` | `[2:0]` | 3 | `000` ADD, `001` SUB, `010` MUL, `011` FMA, `100` DIV, `101` SQRT | `fp32_pkg.sv` |
| `fma_op` | `[1:0]` | 2 | HardFloat FMA polarity: `00` +a*b + c, `01` +a*b − c, `10` −a*b + c, `11` −a*b − c | `MulAddRecFN` |
| `sqrt_op` | `[0]` | 1 | Forces square-root inside the div/sqrt block when asserted; otherwise divider runs | `fp32_block_top.sv` |
| `rounding_mode` | `[2:0]` | 3 | See rounding table below (shared with FP64) | `fp32_pkg.sv` |
| `tininess_mode` | `[0]` | 1 | `0` detect underflow before rounding, `1` after rounding (default) | `fp32_pkg.sv` |

#### Rounding mode meanings

| Code | Name | Behavior |
| --- | --- | --- |
| `000` | nearest-even | Round to closest representable; ties to even LSB (IEEE default). |
| `001` | toward zero (minMag) | Truncate toward zero. |
| `010` | toward −∞ (min) | Round down toward negative infinity. |
| `011` | toward +∞ (max) | Round up toward positive infinity. |
| `100` | nearest-max-mag | Round to nearest by magnitude; ties go to larger magnitude. |
| `101` | odd | If rounding is needed, force result LSB to 1 (useful for integer conversions). |

#### Tininess mode

- `tininess_mode=0` (before rounding): flag underflow if the unrounded intermediate is tiny.
- `tininess_mode=1` (after rounding): flag underflow only when the rounded result is tiny. This matches IEEE-754 recommendations and is the default.

### Exception flag outputs

| Bit | Name | Meaning |
| --- | --- | --- |
| 4 | `invalid` | Signaling NaN, inf−inf, 0/0, sqrt(negative), etc. |
| 3 | `div_by_zero` | Finite non-zero numerator divided by zero. |
| 2 | `overflow` | Rounded exponent overflow. |
| 1 | `underflow` | Rounded exponent underflow per `tininess_mode`. |
| 0 | `inexact` | Rounded result differs from exact value (e.g., 1/3). |

Example for `inexact`: dividing 1.0 by 3.0 cannot be represented exactly in binary32; the rounded value (0x3EAAAAAB) asserts `inexact=1`.

### recFN32 data layout (block I/O)

```
bit 32 31........23 22................0
+-----+-----------+-------------------+
| sign| rec exp   |  significand      |
+-----+-----------+-------------------+
```

| Bits | Field | Notes |
| --- | --- | --- |
| 32 | `sign` | 1 = negative |
| 31:23 | `rec_exp` | 9-bit recoded exponent. High bits encode operand class: zero, subnormal, normal, infinity, NaN. |
| 22:0 | `sig` | 23-bit significand including the hidden 1 for normals. |

**rec_exp classification note:** recFN adds an extra exponent bit to mark zero/subnormal/inf/NaN versus normal exponents. Downstream logic can decode these classes without inspecting the fraction, simplifying special-case handling.

### IEEE binary32 (converter interface)

```
bit 31 30.....23 22................0
+-----+--------+-------------------+
| sign| exponent| fraction         |
+-----+--------+-------------------+
```

| Bits | Field | Notes |
| --- | --- | --- |
| 31 | `sign` | 1 = negative |
| 30:23 | `exp` | 8-bit biased exponent (`bias = 127`, meaning stored exponent = true exponent + 127). |
| 22:0 | `frac` | Fraction bits; the leading `1.` of normalized numbers is not stored (“hidden 1”). |

**Hidden 1 implied for normals:** IEEE stores only the fraction bits after the binary point. Normalized numbers always begin with `1.xxx`, so the leading 1 is implicit and not transmitted, saving one bit. Subnormals have an implicit leading 0 instead.

### Handshake behavior

```
[req_valid, op_sel, fma_op, sqrt_op, rounding_mode, tininess_mode, a_rec, b_rec, c_rec]
      |
      v
 fp32_block_top
      |
      +--> result_rec, exception_flags, resp_valid (or resp_valid_div / resp_valid_sqrt)
```

- `req_valid` asserts when operands/control are stable; `req_ready` returns high when the block can accept them.
- For ADD/MUL/FMA, `resp_valid` pulses after the pipeline latency (typically one registered stage).
- For DIV/SQRT, `resp_valid_div` or `resp_valid_sqrt` asserts when the iterative unit finishes; `req_ready` stays low while it is busy so the upstream logic stalls safely.

---

## 2) FP64 Matrix Multiply Block (IEEE I/O)

This block always performs a 2×2 matrix multiply: each output element is `(a0*b0) + (a1*b1)` using a multiplier plus FMA. Control signals only select IEEE rounding/tininess policy.

### Control fields

| Field | Bits | Width | Codes / meaning | Source |
| --- | --- | --- | --- | --- |
| `rounding_mode` | `[2:0]` | 3 | Same table as FP32 (nearest-even … odd). |
| `detect_tininess` | `[0]` | 1 | `0` = detect after rounding (default); `1` = before rounding. |

### Exception flags per matrix element

| Bit | Name | Meaning |
| --- | --- | --- |
| 4 | `invalid` | NaN operations, inf−inf, 0/0, etc. |
| 3 | `infinite/div0` | Aggregated infinite/div-by-zero indicator (multiplier + FMA). |
| 2 | `overflow` | Rounded exponent overflow. |
| 1 | `underflow` | Underflow per `detect_tininess`. |
| 0 | `inexact` | Rounding changed the exact result. |

### IEEE binary64 layout (external ports)

```
bit 63 62........52 51..................0
+-----+-----------+---------------------+
| sign| exponent  | fraction            |
+-----+-----------+---------------------+
```

| Bits | Field | Notes |
| --- | --- | --- |
| 63 | `sign` | 1 = negative |
| 62:52 | `exp` | 11-bit biased exponent (`bias = 1023`). |
| 51:0 | `frac` | Fraction bits; hidden 1 implied for normals. |

### recFN64 layout (internal to converters)

```
bit 64 63........52 51..................0
+-----+-----------+---------------------+
| sign| rec exp   |  significand        |
+-----+-----------+---------------------+
```

| Bits | Field | Notes |
| --- | --- | --- |
| 64 | `sign` | 1 = negative |
| 63:52 | `rec_exp` | 12-bit recoded exponent with explicit class bits. |
| 51:0 | `sig` | 52-bit significand including hidden 1 for normals. |

### Block wiring sketch

```
        IEEE64 A[2][2]      IEEE64 B[2][2]
               |                    |
       +-------+---------+----------+-------+
       |   FP64MatrixMulBlock (HardFloat)   |
       |  recFN conv | four FMAs | recFN->IEEE|
       +-------+---------+----------+-------+
               |                    |
          IEEE64 C[2][2]     flags[2][2][5]
```

---

## 3) Terminology Table

| Term | Meaning |
| --- | --- |
| recFN | HardFloat recoded IEEE format with an extra exponent bit to flag zero/subnormal/inf/NaN vs. normal. |
| IEEE binary32 | Standard single-precision float (1 sign, 8 exponent, 23 fraction, bias 127). |
| IEEE binary64 | Standard double-precision float (1 sign, 11 exponent, 52 fraction, bias 1023). |
| Hidden 1 | Implicit leading significand bit for normalized IEEE numbers; not stored explicitly. |
| Bias | Offset added to the true exponent when stored (e.g., 127 for binary32). |
| Tininess | IEEE underflow condition; detection point selected by `tininess_mode` / `detect_tininess`. |
| Rounding modes | IEEE rounding codes listed above (`nearest-even`, `toward zero`, etc.). |
| `sqrt_op` | FP32 control bit forcing square-root mode in the shared div/sqrt core. |
| FMA polarity | `fma_op[1:0]` selecting ±a*b ± c combinations. |
| Exception flags | `{invalid, div_by_zero, overflow, underflow, inexact}` outputs from HardFloat pipelines. |
