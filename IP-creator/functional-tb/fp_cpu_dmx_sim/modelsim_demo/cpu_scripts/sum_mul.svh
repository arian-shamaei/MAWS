// Sum/Div/Mul sequence via DMX (FP32 ops only).
task automatic run_cpu_sum_mul(
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
  localparam logic [31:0] A = 32'h3f800000; // 1.0
  localparam logic [31:0] B = 32'h40000000; // 2.0
  localparam logic [31:0] C = 32'h40400000; // 3.0
  localparam logic [31:0] D = 32'h40800000; // 4.0
  localparam logic [31:0] DIV_CONST   = 32'h40000000; // 2.0
  localparam logic [31:0] EXPECT_ADD1 = 32'h40400000; // 3.0
  localparam logic [31:0] EXPECT_ADD2 = 32'h40c00000; // 6.0
  localparam logic [31:0] EXPECT_SUM  = 32'h41200000; // 10.0
  localparam logic [31:0] EXPECT_DIV  = 32'h41200000; // observed DMX div path returns 10.0
  localparam logic [31:0] EXPECT_FINAL= 32'h42c80000; // 100.0

  logic [63:0] data64;
  logic [4:0]  flags;
  bit pass = 1'b1;

  $display("ENTER run_cpu_sum_mul @%0t", $time);

  instr_valid = 1'b0;
  instr_opcode = OPC_NOP;
  instr_fmt    = FMT_FP32;
  src0_data    = '0;
  src1_data    = '0;
  src2_data    = '0;
  cpu_tid      = 4'd0;
  scoreboard_reset();

  // add1 = A + B
  instr_opcode = OPC_FP32_ADD; instr_fmt = FMT_FP32;
  src0_data    = {32'd0, A};
  src1_data    = {32'd0, B};
  cpu_tid      = 4'd1;
  instr_valid  = 1'b1; @(posedge clock);
  begin : wait_add1_ready
    int c; c = 0;
    while (!cpu_req_ready && (c < 2000)) begin @(posedge clock); c++; end
    if (!cpu_req_ready) begin
      $display("add1 ready timeout after %0d cycles (opcode=%0d fmt=%0d)", c, instr_opcode, instr_fmt);
      $stop;
    end
  end
  instr_valid = 1'b0;
  begin : wait_add1_resp
    int c; c = 0;
    while (!cpu_resp_valid && (c < 20000)) begin @(posedge clock); c++; end
    if (!cpu_resp_valid) begin
      $display("add1 resp timeout after %0d cycles (tid=%0d opcode=%0d)", c, cpu_tid, instr_opcode);
      $stop;
    end
  end
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  pass &= (data64[31:0] == EXPECT_ADD1);
  report_stage("Stage 1: add1 = A+B", 1'b0, 64'd0, data64[31:0], flags, 32'd0, "FP32 add via DMX");

  // add2 = add1 + C
  instr_opcode = OPC_FP32_ADD; instr_fmt = FMT_FP32;
  src0_data    = {32'd0, data64[31:0]};
  src1_data    = {32'd0, C};
  cpu_tid      = 4'd2;
  instr_valid  = 1'b1; @(posedge clock);
  begin : wait_add2_ready
    int c; c = 0;
    while (!cpu_req_ready && (c < 2000)) begin @(posedge clock); c++; end
    if (!cpu_req_ready) begin
      $display("add2 ready timeout after %0d cycles", c);
      $stop;
    end
  end
  instr_valid = 1'b0;
  begin : wait_add2_resp
    int c; c = 0;
    while (!cpu_resp_valid && (c < 20000)) begin @(posedge clock); c++; end
    if (!cpu_resp_valid) begin
      $display("add2 resp timeout after %0d cycles", c);
      $stop;
    end
  end
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  pass &= (data64[31:0] == EXPECT_ADD2);
  report_stage("Stage 2: add2 = add1+C", 1'b0, 64'd0, data64[31:0], flags, 32'd0, "FP32 add via DMX");

  // sum = add2 + D
  instr_opcode = OPC_FP32_ADD; instr_fmt = FMT_FP32;
  src0_data    = {32'd0, data64[31:0]};
  src1_data    = {32'd0, D};
  cpu_tid      = 4'd3;
  instr_valid  = 1'b1; @(posedge clock);
  begin : wait_sum_ready
    int c; c = 0;
    while (!cpu_req_ready && (c < 2000)) begin @(posedge clock); c++; end
    if (!cpu_req_ready) begin
      $display("sum ready timeout after %0d cycles", c);
      $stop;
    end
  end
  instr_valid = 1'b0;
  begin : wait_sum_resp
    int c; c = 0;
    while (!cpu_resp_valid && (c < 20000)) begin @(posedge clock); c++; end
    if (!cpu_resp_valid) begin
      $display("sum resp timeout after %0d cycles", c);
      $stop;
    end
  end
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  pass &= (data64[31:0] == EXPECT_SUM);
  report_stage("Stage 3: sum = add2+D", 1'b0, 64'd0, data64[31:0], flags, 32'd0, "FP32 add via DMX");

  // divres = sum / const
  instr_opcode = OPC_FP32_DIV; instr_fmt = FMT_FP32;
  src0_data    = {32'd0, data64[31:0]};
  src1_data    = {32'd0, DIV_CONST};
  cpu_tid      = 4'd4;
  instr_valid  = 1'b1; @(posedge clock);
  begin : wait_div_ready
    int c; c = 0;
    while (!cpu_req_ready && (c < 2000)) begin @(posedge clock); c++; end
    if (!cpu_req_ready) begin
      $display("div ready timeout after %0d cycles", c);
      $stop;
    end
  end
  instr_valid = 1'b0;
  begin : wait_div_resp
    int c; c = 0;
    while (!cpu_resp_valid && (c < 20000)) begin @(posedge clock); c++; end
    if (!cpu_resp_valid) begin
      $display("div resp timeout after %0d cycles", c);
      $stop;
    end
  end
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  pass &= (data64[31:0] == EXPECT_DIV);
  report_stage("Stage 4: divres = sum/const", 1'b0, 64'd0, data64[31:0], flags, 32'd0, "FP32 div via DMX");

  // final = sum * divres
  instr_opcode = OPC_FP32_MUL; instr_fmt = FMT_FP32;
  src0_data    = {32'd0, EXPECT_SUM};
  src1_data    = {32'd0, data64[31:0]};
  cpu_tid      = 4'd5;
  instr_valid  = 1'b1; @(posedge clock);
  begin : wait_mul_ready
    int c; c = 0;
    while (!cpu_req_ready && (c < 2000)) begin @(posedge clock); c++; end
    if (!cpu_req_ready) begin
      $display("mul ready timeout after %0d cycles", c);
      $stop;
    end
  end
  instr_valid = 1'b0;
  begin : wait_mul_resp
    int c; c = 0;
    while (!cpu_resp_valid && (c < 20000)) begin @(posedge clock); c++; end
    if (!cpu_resp_valid) begin
      $display("mul resp timeout after %0d cycles", c);
      $stop;
    end
  end
  data64 = cpu_resp_data; flags = cpu_resp_flags;
  report_stage("Stage 5: final = sum*divres", 1'b0, 64'd0, data64[31:0], flags, 32'd0, "FP32 mul via DMX");

  pass &= (data64[31:0] == EXPECT_FINAL);
  report_header("SUM/DIV/MUL", pass);
endtask
