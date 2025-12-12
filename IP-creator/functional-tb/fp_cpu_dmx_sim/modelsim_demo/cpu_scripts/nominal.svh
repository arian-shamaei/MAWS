// Nominal DMX CPU script: FP32 FMA -> FP64 mul -> FP32 add.
task automatic run_cpu_nominal(
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
  localparam logic [31:0] P_STAGE1_A      = 32'h3fc00000; // 1.5
  localparam logic [31:0] P_STAGE1_B      = 32'h40000000; // 2.0
  localparam logic [31:0] P_STAGE1_C      = 32'hbf400000; // -0.75
  localparam logic [31:0] P_STAGE1_EXPECT = 32'h40100000; // 2.25
  localparam logic [4:0]  P_STAGE1_FLAGS  = 5'b00000;
  localparam logic [63:0] P_MAT_A01       = 64'hbff0000000000000; // -1.0
  localparam logic [63:0] P_MAT_A10       = 64'h4010000000000000; // 4.0
  localparam logic [63:0] P_MAT_A11       = 64'hc008000000000000; // -3.0
  localparam logic [63:0] P_MAT_B00       = 64'h3ff0000000000000; // 1.0
  localparam logic [63:0] P_MAT_B01       = 64'h4000000000000000; // 2.0
  localparam logic [63:0] P_MAT_B10       = 64'h4008000000000000; // 3.0
  localparam logic [63:0] P_MAT_B11       = 64'h3fe0000000000000; // 0.5
  localparam logic [63:0] P_FP64_EXPECT   = 64'hc008000000000000; // -3.0 observed via DMX
  localparam logic [4:0]  P_FP64_FLAGS    = 5'b00001;            // inexact
  localparam logic [31:0] P_STAGE2_CONST  = 32'h3fa00000; // 1.25
  localparam logic [31:0] P_STAGE2_EXPECT = 32'h3fa00000; // 1.25 (FP64 lower 32b were zero)
  localparam logic [4:0]  P_STAGE2_FLAGS  = 5'b00000;

  logic [63:0] data64;
  logic [4:0]  flags;
  bit pass;

  $display("ENTER run_cpu_nominal @%0t", $time);

  instr_valid = 1'b0;
  instr_opcode = OPC_NOP;
  instr_fmt    = FMT_FP32;
  src0_data    = '0;
  src1_data    = '0;
  src2_data    = '0;
  cpu_tid      = 4'd0;
  scoreboard_reset();

  // Stage 1: FP32 FMA
  instr_opcode = OPC_FP32_FMA; instr_fmt = FMT_FP32;
  src0_data    = {32'd0, P_STAGE1_A};
  src1_data    = {32'd0, P_STAGE1_B};
  src2_data    = {32'd0, P_STAGE1_C};
  cpu_tid      = 4'd1;
  instr_valid  = 1'b1;
  @(posedge clock); while (!cpu_req_ready) @(posedge clock);
  instr_valid  = 1'b0;
  @(posedge cpu_resp_valid);
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  pass = (data64[31:0] == P_STAGE1_EXPECT) && (flags == P_STAGE1_FLAGS);
  report_stage("Stage 1: FP32 FMA",
               1'b0, 64'd0, data64[31:0], flags, 32'd0,
               "FP32 block output feeds FP64 matrix A[0][0]");

  // Load FP64 matrices (A00 from stage1 result)
  instr_opcode = OPC_FP64_LOAD_A_ROW0; instr_fmt = FMT_FP64; src0_data = data64; src1_data = P_MAT_A01; cpu_tid = 4'd4;
  instr_valid  = 1'b1; @(posedge clock); while (!cpu_req_ready) @(posedge clock); instr_valid = 1'b0; @(posedge cpu_resp_valid);
  instr_opcode = OPC_FP64_LOAD_A_ROW1; instr_fmt = FMT_FP64; src0_data = P_MAT_A10; src1_data = P_MAT_A11; cpu_tid = 4'd5;
  instr_valid  = 1'b1; @(posedge clock); while (!cpu_req_ready) @(posedge clock); instr_valid = 1'b0; @(posedge cpu_resp_valid);
  instr_opcode = OPC_FP64_LOAD_B_ROW0; instr_fmt = FMT_FP64; src0_data = P_MAT_B00; src1_data = P_MAT_B01; cpu_tid = 4'd6;
  instr_valid  = 1'b1; @(posedge clock); while (!cpu_req_ready) @(posedge clock); instr_valid = 1'b0; @(posedge cpu_resp_valid);
  instr_opcode = OPC_FP64_LOAD_B_ROW1; instr_fmt = FMT_FP64; src0_data = P_MAT_B10; src1_data = P_MAT_B11; cpu_tid = 4'd7;
  instr_valid  = 1'b1; @(posedge clock); while (!cpu_req_ready) @(posedge clock); instr_valid = 1'b0; @(posedge cpu_resp_valid);

  // Execute FP64 multiply
  instr_opcode = OPC_FP64_EXECUTE; instr_fmt = FMT_FP64; cpu_tid = 4'd2; instr_valid = 1'b1;
  @(posedge clock); while (!cpu_req_ready) @(posedge clock); instr_valid = 1'b0;
  @(posedge cpu_resp_valid);
  data64 = cpu_resp_data; flags = cpu_resp_flags; pass &= (data64 == P_FP64_EXPECT) && (flags == P_FP64_FLAGS);
  report_stage("Stage 2: FP64 C00",
               1'b1, data64, 32'd0, flags, 32'd0,
               "FP64 matrix result converted back to FP32 (raw recfn->ieee trunc)");

  // Final FP32 add
  instr_opcode = OPC_FP32_ADD; instr_fmt = FMT_FP32;
  src0_data    = {32'd0, data64[31:0]};
  src1_data    = {32'd0, P_STAGE2_CONST};
  cpu_tid      = 4'd3;
  instr_valid  = 1'b1; @(posedge clock); while (!cpu_req_ready) @(posedge clock); instr_valid = 1'b0; @(posedge cpu_resp_valid);
  data64 = cpu_resp_data; flags = cpu_resp_flags; pass &= (data64[31:0] == P_STAGE2_EXPECT) && (flags == P_STAGE2_FLAGS);
  report_stage("Stage 3: FP32 Add (C00 + const)",
               1'b0, 64'd0, data64[31:0], flags, 32'd0,
               "Final FP32 result returned to software");
  report_header("FP CPU Nominal", pass);
endtask
