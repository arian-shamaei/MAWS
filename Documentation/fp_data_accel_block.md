# Floating-Point Data Acceleration Hub

A reference for the `dmx_hub` that bridges the CPU instruction channel to the FP32 HardFloat block and the FP64 2×2 matrix-multiply block.

- `src/dmx_hub.sv`: top-level dispatcher and response queue.
- `src/dmx_fp32_wrapper.sv`: wraps `fp32_block_top` with recFN/IEEE conversion.
- `src/dmx_fp64_wrapper.sv`: wraps `FP64MatrixMulBlock` with matrix packing.

---

## 1) CPU Instruction Interface

| Signal | Bits | Direction | Description |
| --- | --- | --- | --- |
| `instr_valid` | 1 | CPU→hub | Marks opcode/format/operands as valid. |
| `instr_opcode` | `[4:0]` | CPU→hub | Encodes FP32 scalar ops and FP64 matrix load/exec/read ops (see opcode table). |
| `instr_fmt` | `[1:0]` | CPU→hub | `00` FP32, `01` FP64, `10` SYS (reserved). Must match opcode target. |
| `src0_data` | `[63:0]` | CPU→hub | Operand 0; lower 32 bits used for FP32. |
| `src1_data` | `[63:0]` | CPU→hub | Operand 1. |
| `src2_data` | `[63:0]` | CPU→hub | Operand 2 (FP32 FMA third operand). |
| `cpu_tid` | `[3:0]` | CPU→hub | Tag returned on completion. |
| `csr_rounding_mode` | `[2:0]` | CPU→hub | IEEE rounding code (shared with both blocks). |
| `csr_tininess_mode` | 1 | CPU→hub | Tininess detect: `0` before rounding, `1` after rounding. |
| `cpu_req_ready` | 1 | hub→CPU | Back-pressure; high when the hub can accept `instr_valid`. |

### Opcode map (from `src/dmx_pkg.sv`)

| Name | Value | Target | Notes |
| --- | --- | --- | --- |
| `OPC_NOP` | `0` | none | No-op. |
| `OPC_FP32_ADD` | `1` | FP32 | Scalar add. |
| `OPC_FP32_SUB` | `2` | FP32 | Scalar subtract. |
| `OPC_FP32_MUL` | `3` | FP32 | Scalar multiply. |
| `OPC_FP32_FMA` | `4` | FP32 | Scalar fused multiply-add. |
| `OPC_FP32_DIV` | `5` | FP32 | Scalar divide. |
| `OPC_FP32_SQRT` | `6` | FP32 | Scalar square root. |
| `OPC_FP64_LOAD_A_ROW0/1` | `16/17` | FP64 | Load 2×1 row into matrix A. |
| `OPC_FP64_LOAD_B_ROW0/1` | `18/19` | FP64 | Load 2×1 row into matrix B. |
| `OPC_FP64_EXECUTE` | `20` | FP64 | Kick off 2×2 matrix multiply. |
| `OPC_FP64_READ_C00/01/10/11` | `21–24` | FP64 | Read one element of the last computed C matrix. |

Illegal instruction rules: opcode must be in the table and `instr_fmt` must match the target (FP32 vs FP64). Otherwise the hub immediately returns an error response with flags=`5'b10000`.

---

## 2) FP32 Path (scalar HardFloat)

| Signal | Bits | Direction | Description |
| --- | --- | --- | --- |
| `fp32_req_valid` / `fp32_req_ready` | 1 | hub↔FP32 | Handshake for issuing a scalar op. |
| `fp32_ctrl` | `[7:0]` | hub→FP32 | `{2'b00, sqrt_op, fma_op[1:0], op_sel[2:0]}` derived from opcode. |
| `fp32_a_rec/b_rec/c_rec` | `[32:0]` | hub→FP32 | recFN33 operands produced by `RecFNFromFN_8_24`. |
| `fp32_rounding_mode` | `[2:0]` | hub→FP32 | CSR rounding mode. |
| `fp32_tininess_mode` | 1 | hub→FP32 | CSR tininess policy. |
| `fp32_resp_valid` | 1 | FP32→hub | Completion pulse (DIV/SQRT use their dedicated done signals OR’ed). |
| `fp32_result_rec` | `[32:0]` | FP32→hub | recoded result. Converted back to IEEE32 for CPU. |
| `fp32_flags` | `[4:0]` | FP32→hub | `{invalid, div_by_zero, overflow, underflow, inexact}`. |

Issue policy:
- Only one FP32 op may be in flight (`fp32_busy` latch). `cpu_req_ready` is held low for FP32 targets while busy.
- Operands `src0/1/2_data[31:0]` are converted to recFN before issuing.
- On `fp32_resp_valid`, the hub clears busy, converts back to IEEE32, and enqueues a response tagged with `cpu_tid`.

---

## 3) FP64 Path (2×2 matrix multiply)

| Signal | Bits | Direction | Description |
| --- | --- | --- | --- |
| `fp64_req_valid` | 1 | hub→FP64 | Asserted with a snapshot of matrices A/B and CSR modes. |
| `fp64_a_matrix` / `fp64_b_matrix` | `[255:0]` | hub→FP64 | Packed IEEE64 words `{m11,m10,m01,m00}` (little-endian by word). |
| `fp64_rounding_mode` | `[2:0]` | hub→FP64 | CSR rounding mode. |
| `fp64_detect_tininess` | 1 | hub→FP64 | CSR tininess policy. |
| `fp64_resp_valid` | 1 | FP64→hub | Completion pulse after the multiply finishes. |
| `fp64_c_matrix` | `[255:0]` | FP64→hub | Packed IEEE64 results. |
| `fp64_flags` | `[19:0]` | FP64→hub | Four 5-bit flag bundles `{C11,C10,C01,C00}`. |

Register files and sequencing:
- Two 2×2 register files hold A and B. LOAD opcodes write rows immediately and return an ack response.
- EXECUTE snapshots A/B plus CSR modes into the wrapper, asserts `fp64_req_valid`, and sets `fp64_busy`.
- On `fp64_resp_valid`, the hub latches `fp64_c_matrix/flags`, sets `fp64_result_valid`, clears busy, and emits a completion response.
- READ opcodes return a selected C element. If no valid result is present, the hub returns flags=`5'b10000` to signal an error.


---

## 4) Response Handling

| Signal | Bits | Direction | Description |
| --- | --- | --- | --- |
| `cpu_resp_valid` | 1 | hub→CPU | Pops the oldest entry from the response FIFO. |
| `cpu_resp_tid` | `[3:0]` | hub→CPU | Original tag. |
| `cpu_resp_data` | `[63:0]` | hub→CPU | IEEE64 for FP64 paths; zero-extended IEEE32 for FP32 completions. |
| `cpu_resp_flags` | `[4:0]` | hub→CPU | `{invalid, div_by_zero, overflow, underflow, inexact}`. FP64 flags are OR-reduced across all four elements for completions, or reduced on the selected element for READs. |

Response FIFO:
- Depth 8, accepts up to 5 pushes per cycle (illegal-instr, FP64 load ack, FP64 readback, FP32 completion, FP64 completion).
- Service is oldest-first; if the FIFO is empty, `cpu_resp_valid` stays low.

