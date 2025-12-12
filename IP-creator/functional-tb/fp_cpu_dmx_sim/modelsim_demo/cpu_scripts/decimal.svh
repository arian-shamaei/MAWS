// Extensive CPU script (decimal stress): exercises FP32 and FP64 paths with 10 instructions.
task automatic run_cpu_decimal(
    ref logic        instr_valid,
    ref logic [4:0]  instr_opcode,
    ref logic [1:0]  instr_fmt,
    ref logic [63:0] src0_data,
    ref logic [63:0] src1_data,
    ref logic [63:0] src2_data,
    ref logic [3:0]  cpu_tid,
    ref logic        cpu_req_ready,
    ref logic        cpu_resp_valid,
    ref logic [3:0]  cpu_resp_tid,
    ref logic [63:0] cpu_resp_data,
    ref logic [4:0]  cpu_resp_flags
);
  // ---------------------------------------------------------------------------
  // FP32 operands (all decimal-heavy, chosen to stress rounding):
  //   A = 0.1f, B = 0.2f, C = 0.3f, D = 1.5f, E = -0.75f, F = (1.0f / 7.0f)
  // ---------------------------------------------------------------------------
  localparam logic [31:0] F32_A = 32'h3dcccccd; //  0.10000000149011612f
  localparam logic [31:0] F32_B = 32'h3e4ccccd; //  0.20000000298023224f
  localparam logic [31:0] F32_C = 32'h3e99999a; //  0.30000001192092896f
  localparam logic [31:0] F32_D = 32'h3fc00000; //  1.5f
  localparam logic [31:0] F32_E = 32'hbf400000; // -0.75f
  localparam logic [31:0] F32_F = 32'h3e124925; //  0.1428571492433548f ≈ 1/7

  // ---------------------------------------------------------------------------
  // FP64 matrix operands:
  //   A00 = sqrt(F32_F) in FP32, then promoted to FP64 in hardware.
  //   A01 = 1.25, A10 = -2.75, A11 = 3.5
  //   B00 = 0.1,  B01 = -0.2,  B10 = 10/3, B11 = -5.75
  // ---------------------------------------------------------------------------
  localparam logic [63:0] FP64_A01 = 64'h3ff4000000000000; //  1.25
  localparam logic [63:0] FP64_A10 = 64'hc006000000000000; // -2.75
  localparam logic [63:0] FP64_A11 = 64'h400c000000000000; //  3.5

  localparam logic [63:0] FP64_B00 = 64'h3fb999999999999a; //  0.1
  localparam logic [63:0] FP64_B01 = 64'hbfc999999999999a; // -0.2
  localparam logic [63:0] FP64_B10 = 64'h400aaaaaaaaaaaab; //  10/3 ≈ 3.3333333333333335
  localparam logic [63:0] FP64_B11 = 64'hc017000000000000; // -5.75

  // ---------------------------------------------------------------------------
  // FP32 expected results (all correctly rounded to single precision):
  //   ADD  = A + B          ≈ 0.30000001192092896
  //   SUB  = C - A          ≈ 0.20000001788139343
  //   MUL  = D * B          ≈ 0.30000001192092896
  //   FMA  = E * B + A      ≈ -0.05000000074505806 (true fused in model)
  //   DIV  = F / C          ≈ 0.4761904776096344
  //   SQRT = sqrt(F)        ≈ 0.37796446681022644
  // ---------------------------------------------------------------------------
  localparam logic [31:0] EXPECT_ADD   = 32'h3e99999a; //  A+B
  localparam logic [31:0] EXPECT_SUB   = 32'h3e4cccce; //  C-A
  localparam logic [31:0] EXPECT_MUL   = 32'h3e99999a; //  D*B
  localparam logic [31:0] EXPECT_FMA   = 32'hbd4ccccd; //  E*B + A (fused)
  localparam logic [31:0] EXPECT_DIV   = 32'h3ef3cf3d; //  F/C
  localparam logic [31:0] EXPECT_SQRT  = 32'h3ec1848f; //  sqrt(F)

  // ---------------------------------------------------------------------------
  // FP64 expected C00:
  //   A00 = FP32(sqrt(F)), then promoted to FP64
  //   C00 = A00*B00 + A01*B10
  //       ≈ 0.37796446681022644*0.1 + 1.25*(10/3)
  //       ≈ 4.20446311334769
  // ---------------------------------------------------------------------------
  localparam logic [63:0] EXPECT_C00   = 64'h4010d15ec7444445; // C00 ≈ 4.20446311334769

  logic [63:0] data64;
  logic [4:0]  flags;
  bit          pass = 1'b1;

  $display("ENTER run_cpu_extensive_decimal @%0t", $time);

  instr_valid  = 1'b0;
  instr_opcode = OPC_NOP;
  instr_fmt    = FMT_FP32;
  src0_data    = '0;
  src1_data    = '0;
  src2_data    = '0;
  cpu_tid      = 4'd0;
  scoreboard_reset();

  // ---------------------------------------------------------------------------
  // 1) FP32 ADD: A + B
  // ---------------------------------------------------------------------------
  instr_opcode = OPC_FP32_ADD; instr_fmt = FMT_FP32;
  src0_data    = {32'd0, F32_A};
  src1_data    = {32'd0, F32_B};
  cpu_tid      = 4'd1;
  instr_valid  = 1'b1;
  @(posedge clock);
  while (!cpu_req_ready) @(posedge clock);
  instr_valid  = 1'b0;

  @(posedge cpu_resp_valid);
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  pass  &= (data64[31:0] == EXPECT_ADD);
  report_stage("Stage 1: add = A+B", 1'b0, 64'd0, data64[31:0], flags,
               EXPECT_ADD, "FP32 add via DMX (decimal stress)");

  // ---------------------------------------------------------------------------
  // 2) FP32 SUB: C - A
  // ---------------------------------------------------------------------------
  instr_opcode = OPC_FP32_SUB; instr_fmt = FMT_FP32;
  src0_data    = {32'd0, F32_C};
  src1_data    = {32'd0, F32_A};
  cpu_tid      = 4'd2;
  instr_valid  = 1'b1;
  @(posedge clock);
  while (!cpu_req_ready) @(posedge clock);
  instr_valid  = 1'b0;

  @(posedge cpu_resp_valid);
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  pass  &= (data64[31:0] == EXPECT_SUB);
  report_stage("Stage 2: sub = C-A", 1'b0, 64'd0, data64[31:0], flags,
               EXPECT_SUB, "FP32 sub via DMX (decimal stress)");

  // ---------------------------------------------------------------------------
  // 3) FP32 MUL: D * B
  // ---------------------------------------------------------------------------
  instr_opcode = OPC_FP32_MUL; instr_fmt = FMT_FP32;
  src0_data    = {32'd0, F32_D};
  src1_data    = {32'd0, F32_B};
  cpu_tid      = 4'd3;
  instr_valid  = 1'b1;
  @(posedge clock);
  while (!cpu_req_ready) @(posedge clock);
  instr_valid  = 1'b0;

  @(posedge cpu_resp_valid);
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  pass  &= (data64[31:0] == EXPECT_MUL);
  report_stage("Stage 3: mul = D*B", 1'b0, 64'd0, data64[31:0], flags,
               EXPECT_MUL, "FP32 mul via DMX (decimal stress)");

  // ---------------------------------------------------------------------------
  // 4) FP32 FMA: E * B + A (fused)
  // ---------------------------------------------------------------------------
  instr_opcode = OPC_FP32_FMA; instr_fmt = FMT_FP32;
  src0_data    = {32'd0, F32_E};
  src1_data    = {32'd0, F32_B};
  src2_data    = {32'd0, F32_A};
  cpu_tid      = 4'd4;
  instr_valid  = 1'b1;
  @(posedge clock);
  while (!cpu_req_ready) @(posedge clock);
  instr_valid  = 1'b0;

  @(posedge cpu_resp_valid);
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  pass  &= (data64[31:0] == EXPECT_FMA);
  report_stage("Stage 4: fma = E*B+A", 1'b0, 64'd0, data64[31:0], flags,
               EXPECT_FMA, "FP32 fma via DMX (decimal stress)");

  // ---------------------------------------------------------------------------
  // 5) FP32 DIV: F / C
  // ---------------------------------------------------------------------------
  instr_opcode = OPC_FP32_DIV; instr_fmt = FMT_FP32;
  src0_data    = {32'd0, F32_F};
  src1_data    = {32'd0, F32_C};
  cpu_tid      = 4'd5;
  instr_valid  = 1'b1;
  @(posedge clock);
  while (!cpu_req_ready) @(posedge clock);
  instr_valid  = 1'b0;

  @(posedge cpu_resp_valid);
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  pass  &= (data64[31:0] == EXPECT_DIV);
  report_stage("Stage 5: div = F/C", 1'b0, 64'd0, data64[31:0], flags,
               EXPECT_DIV, "FP32 div via DMX (decimal stress)");

  // ---------------------------------------------------------------------------
  // 6) FP32 SQRT: sqrt(F)
  // ---------------------------------------------------------------------------
  instr_opcode = OPC_FP32_SQRT; instr_fmt = FMT_FP32;
  src0_data    = {32'd0, F32_F};
  src1_data    = 64'd0;
  cpu_tid      = 4'd6;
  instr_valid  = 1'b1;
  @(posedge clock);
  while (!cpu_req_ready) @(posedge clock);
  instr_valid  = 1'b0;

  @(posedge cpu_resp_valid);
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  pass  &= (data64[31:0] == EXPECT_SQRT);
  report_stage("Stage 6: sqrt = sqrt(F)", 1'b0, 64'd0, data64[31:0], flags,
               EXPECT_SQRT, "FP32 sqrt via DMX (decimal stress)");

  // ---------------------------------------------------------------------------
  // 7) FP64 LOAD A row0
  //     A00 = last FP32 result (sqrt(F)) widened to FP64 in the DMX,
  //     A01 = FP64_A01.
  // ---------------------------------------------------------------------------
  instr_opcode = OPC_FP64_LOAD_A_ROW0; instr_fmt = FMT_FP64;
  src0_data    = cpu_resp_data; // reuse last FP32 result as A00 (IEEE32 -> recFN -> FP64 path)
  src1_data    = FP64_A01;
  cpu_tid      = 4'd7;
  instr_valid  = 1'b1;
  @(posedge clock);
  while (!cpu_req_ready) @(posedge clock);
  instr_valid  = 1'b0;

  @(posedge cpu_resp_valid);
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  report_stage("Stage 7: load A row0", 1'b1, data64, 32'd0, flags, 32'd0,
               "FP64 A[0,*] load via DMX");

  // ---------------------------------------------------------------------------
  // 8) FP64 LOAD A row1
  // ---------------------------------------------------------------------------
  instr_opcode = OPC_FP64_LOAD_A_ROW1; instr_fmt = FMT_FP64;
  src0_data    = FP64_A10;
  src1_data    = FP64_A11;
  cpu_tid      = 4'd8;
  instr_valid  = 1'b1;
  @(posedge clock);
  while (!cpu_req_ready) @(posedge clock);
  instr_valid  = 1'b0;

  @(posedge cpu_resp_valid);
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  report_stage("Stage 8: load A row1", 1'b1, data64, 32'd0, flags, 32'd0,
               "FP64 A[1,*] load via DMX");

  // ---------------------------------------------------------------------------
  // 9) FP64 LOAD B row0/row1 back-to-back
  // ---------------------------------------------------------------------------
  instr_opcode = OPC_FP64_LOAD_B_ROW0; instr_fmt = FMT_FP64;
  src0_data    = FP64_B00;
  src1_data    = FP64_B01;
  cpu_tid      = 4'd9;
  instr_valid  = 1'b1;
  @(posedge clock);
  while (!cpu_req_ready) @(posedge clock);
  instr_valid  = 1'b0;

  @(posedge cpu_resp_valid);
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  report_stage("Stage 9: load B row0", 1'b1, data64, 32'd0, flags, 32'd0,
               "FP64 B[0,*] load via DMX");

  instr_opcode = OPC_FP64_LOAD_B_ROW1; instr_fmt = FMT_FP64;
  src0_data    = FP64_B10;
  src1_data    = FP64_B11;
  cpu_tid      = 4'd10;
  instr_valid  = 1'b1;
  @(posedge clock);
  while (!cpu_req_ready) @(posedge clock);
  instr_valid  = 1'b0;

  @(posedge cpu_resp_valid);
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  report_stage("Stage 10: load B row1", 1'b1, data64, 32'd0, flags, 32'd0,
               "FP64 B[1,*] load via DMX");

  // ---------------------------------------------------------------------------
  // 10) FP64 EXECUTE and consume response (matrix multiply)
  // ---------------------------------------------------------------------------
  instr_opcode = OPC_FP64_EXECUTE; instr_fmt = FMT_FP64;
  cpu_tid      = 4'd11;
  instr_valid  = 1'b1;
  @(posedge clock);
  while (!cpu_req_ready) @(posedge clock);
  instr_valid  = 1'b0;

  @(posedge cpu_resp_valid);
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  report_stage("Stage 11: execute FP64", 1'b1, data64, 32'd0, flags, 32'd0,
               "FP64 2x2 matrix multiply via DMX (decimal stress)");

  // ---------------------------------------------------------------------------
  // Read back C00 and check against EXPECT_C00
  // ---------------------------------------------------------------------------
  instr_opcode = OPC_FP64_READ_C00; instr_fmt = FMT_FP64;
  cpu_tid      = 4'd12;
  instr_valid  = 1'b1;
  @(posedge clock);
  while (!cpu_req_ready) @(posedge clock);
  instr_valid  = 1'b0;

  @(posedge cpu_resp_valid);
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  pass  &= (data64 == EXPECT_C00);
  report_stage("Stage 12: read C00", 1'b1, data64, 32'd0, flags,
               EXPECT_C00[31:0], "FP64 C00 result readback (decimal stress)");

  $display("Extensive decimal script complete. C00=0x%016h flags=%05b",
           cpu_resp_data, cpu_resp_flags);
  report_header("Extensive FP32/FP64 Decimal", pass);
endtask
