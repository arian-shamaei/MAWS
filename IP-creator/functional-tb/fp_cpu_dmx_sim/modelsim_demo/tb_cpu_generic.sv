`timescale 1ns/1ps
`include "tb_cpu_common.svh"
import dmx_pkg::*;

module tb_cpu_generic #(
    parameter string CPU_SCRIPT_PARAM = "extensive"
);

  // CPU script selector; default via parameter, overridable via +CPU_SCRIPT=<name>.
  string cpu_script_sel = CPU_SCRIPT_PARAM;

  // Clock/reset
  logic clock = 0;
  logic reset_n = 0;
  always #5 clock = ~clock;

  // DMX CPU-side signals
  logic        instr_valid;
  logic [4:0]  instr_opcode;
  logic [1:0]  instr_fmt;
  logic [63:0] src0_data, src1_data, src2_data;
  logic [3:0]  cpu_tid;
  logic [2:0]  csr_rounding_mode;
  logic        csr_tininess_mode;
  logic        cpu_req_ready;
  logic        cpu_resp_valid;
  logic [3:0]  cpu_resp_tid;
  logic [63:0] cpu_resp_data;
  logic [4:0]  cpu_resp_flags;

  // DMX <-> FP32
  logic        fp32_req_valid, fp32_req_ready;
  logic [7:0]  fp32_ctrl;
  logic [32:0] fp32_a_rec, fp32_b_rec, fp32_c_rec;
  logic [2:0]  fp32_rounding_mode;
  logic        fp32_tininess_mode;
  logic        fp32_resp_valid;
  logic [32:0] fp32_result_rec;
  logic [4:0]  fp32_flags;

  // DMX <-> FP64
  logic        fp64_req_valid;
  logic [255:0] fp64_a_matrix, fp64_b_matrix;
  logic [2:0]  fp64_rounding_mode;
  logic        fp64_detect_tininess;
  logic        fp64_resp_valid;
  logic [255:0] fp64_c_matrix;
  logic [19:0] fp64_flags;

  dmx_hub u_dmx (
      .clock(clock),
      .reset_n(reset_n),
      .instr_valid(instr_valid),
      .instr_opcode(instr_opcode),
      .instr_fmt(instr_fmt),
      .src0_data(src0_data),
      .src1_data(src1_data),
      .src2_data(src2_data),
      .cpu_tid(cpu_tid),
      .csr_rounding_mode(csr_rounding_mode),
      .csr_tininess_mode(csr_tininess_mode),
      .cpu_req_ready(cpu_req_ready),
      .cpu_resp_valid(cpu_resp_valid),
      .cpu_resp_tid(cpu_resp_tid),
      .cpu_resp_data(cpu_resp_data),
      .cpu_resp_flags(cpu_resp_flags),
      .fp32_req_valid(fp32_req_valid),
      .fp32_req_ready(fp32_req_ready),
      .fp32_ctrl(fp32_ctrl),
      .fp32_a_rec(fp32_a_rec),
      .fp32_b_rec(fp32_b_rec),
      .fp32_c_rec(fp32_c_rec),
      .fp32_rounding_mode(fp32_rounding_mode),
      .fp32_tininess_mode(fp32_tininess_mode),
      .fp32_resp_valid(fp32_resp_valid),
      .fp32_result_rec(fp32_result_rec),
      .fp32_flags(fp32_flags),
      .fp64_req_valid(fp64_req_valid),
      .fp64_a_matrix(fp64_a_matrix),
      .fp64_b_matrix(fp64_b_matrix),
      .fp64_rounding_mode(fp64_rounding_mode),
      .fp64_detect_tininess(fp64_detect_tininess),
      .fp64_resp_valid(fp64_resp_valid),
      .fp64_c_matrix(fp64_c_matrix),
      .fp64_flags(fp64_flags)
  );

  dmx_fp32_wrapper u_fp32 (
      .clock(clock),
      .reset_n(reset_n),
      .req_valid(fp32_req_valid),
      .req_ready(fp32_req_ready),
      .ctrl(fp32_ctrl),
      .a_rec(fp32_a_rec),
      .b_rec(fp32_b_rec),
      .c_rec(fp32_c_rec),
      .rounding_mode(fp32_rounding_mode),
      .tininess_mode(fp32_tininess_mode),
      .resp_valid(fp32_resp_valid),
      .result_rec(fp32_result_rec),
      .flags(fp32_flags)
  );

  dmx_fp64_wrapper u_fp64 (
      .clock(clock),
      .reset_n(reset_n),
      .req_valid(fp64_req_valid),
      .a_matrix(fp64_a_matrix),
      .b_matrix(fp64_b_matrix),
      .rounding_mode(fp64_rounding_mode),
      .detect_tininess(fp64_detect_tininess),
      .resp_valid(fp64_resp_valid),
      .c_matrix(fp64_c_matrix),
      .flags(fp64_flags)
  );

  // Trace instruction issue/response to debug hangs.
  always @(posedge clock) begin
    if (instr_valid && cpu_req_ready) begin
      $display("ISSUE %s fmt=%0d tid=%0d @%0t",
               opcode_name(instr_opcode), instr_fmt, cpu_tid, $time);
    end
    if (cpu_resp_valid) begin
      $display("RESP  tid=%0d data=%016h flags=%05b @%0t",
               cpu_resp_tid, cpu_resp_data, cpu_resp_flags, $time);
    end
  end

  // CPU script library (each file defines run_cpu_<name> tasks).
`include "cpu_scripts/script_manifest.svh"

  initial begin : run_cpu_script
    string plusarg_sel;
    if ($value$plusargs("CPU_SCRIPT=%s", plusarg_sel)) begin
      cpu_script_sel = plusarg_sel;
      $display("CPU script selected via +CPU_SCRIPT: %s", cpu_script_sel);
    end else begin
      $display("CPU script selected via parameter: %s", cpu_script_sel);
    end

    instr_valid        = 1'b0;
    instr_opcode       = OPC_NOP;
    instr_fmt          = FMT_FP32;
    src0_data          = '0;
    src1_data          = '0;
    src2_data          = '0;
    cpu_tid            = 4'd0;
    csr_rounding_mode  = 3'b000;
    csr_tininess_mode  = 1'b1;
    reset_n            = 1'b0;
    repeat (5) @(posedge clock);
    reset_n = 1'b1;
    repeat (2) @(posedge clock); // allow reset to propagate through wrappers

    $display("Starting %s", cpu_script_sel);

    // Run the selected CPU script (drives instr_* signals and prints results).
    `CPU_SCRIPT_CASES(instr_valid, instr_opcode, instr_fmt,
                      src0_data, src1_data, src2_data, cpu_tid,
                      cpu_req_ready,
                      cpu_resp_valid, cpu_resp_tid, cpu_resp_data, cpu_resp_flags)
    #20;
    $finish;
  end

  // uwu 
  initial begin
    #100ms; // 50 us at 100 MHz
    $display("Timeout: CPU script did not finish. instr_valid=%0b cpu_req_ready=%0b cpu_resp_valid=%0b opcode=%0d fmt=%0d",
             instr_valid, cpu_req_ready, cpu_resp_valid, instr_opcode, instr_fmt);
    $stop;
  end
endmodule
