module fp_cpu_dmx_top #(
    parameter string SCENARIO_NAME = "dmx_nominal",
    parameter logic [31:0] P_STAGE1_A          = 32'h3fc00000, // 1.5
    parameter logic [31:0] P_STAGE1_B          = 32'h40000000, // 2.0
    parameter logic [31:0] P_STAGE1_C          = 32'hbf400000, // -0.75
    parameter logic [31:0] P_STAGE1_EXPECT     = 32'h40100000, // 2.25
    parameter logic [4:0]  P_STAGE1_FLAGS      = 5'b00000,
    parameter logic [63:0] P_MAT_A01           = 64'hbff0000000000000, // -1.0
    parameter logic [63:0] P_MAT_A10           = 64'h4010000000000000, // 4.0
    parameter logic [63:0] P_MAT_A11           = 64'hc008000000000000, // -3.0
    parameter logic [63:0] P_MAT_B00           = 64'h3ff0000000000000, // 1.0
    parameter logic [63:0] P_MAT_B01           = 64'h4000000000000000, // 2.0
    parameter logic [63:0] P_MAT_B10           = 64'h4008000000000000, // 3.0
    parameter logic [63:0] P_MAT_B11           = 64'h3fe0000000000000, // 0.5
    parameter logic [63:0] P_FP64_EXPECT_C00   = 64'hbfe8000000000000, // -0.75
    parameter logic [4:0]  P_FP64_EXPECT_FLAGS = 5'b00000,
    parameter logic [31:0] P_STAGE2_CONST      = 32'h3fa00000, // 1.25
    parameter logic [31:0] P_STAGE2_EXPECT     = 32'h3f000000, // 0.5
    parameter logic [4:0]  P_STAGE2_FLAGS      = 5'b00000
)(
    input  logic        clock,
    input  logic        reset_n,
    output logic        done,
    output logic        pass,
    output logic [3:0]  state_id,
    output logic [31:0] cycle_counter,
    output logic        stage1_complete,
    output logic        stage_fp64_complete,
    output logic        stage2_complete,
    output logic [31:0] stage1_cycles,
    output logic [31:0] stage_fp64_cycles,
    output logic [31:0] stage2_cycles,
    output logic [31:0] stage1_start_cycle_o,
    output logic [31:0] stage_fp64_start_cycle_o,
    output logic [31:0] stage2_start_cycle_o,
    output logic [31:0] stage1_fp32_ieee,
    output logic [4:0]  stage1_flags,
    output logic [63:0] stage_fp64_c00,
    output logic [63:0] stage_fp64_c01,
    output logic [63:0] stage_fp64_c10,
    output logic [63:0] stage_fp64_c11,
    output logic [4:0]  stage_fp64_flags,
    output logic [31:0] stage2_input_ieee,
    output logic [31:0] stage2_const_ieee,
    output logic [31:0] stage2_fp32_ieee,
    output logic [4:0]  stage2_flags
);
  import dmx_pkg::*;
  import fp32_pkg::*;

  // ---------------------------------------------------------------------------
  // Conversion helpers (simulation only).
  // ---------------------------------------------------------------------------
  function automatic logic [63:0] f32_to_f64_bits(logic [31:0] f32);
    shortreal sr;
    real dr;
    sr = $bitstoshortreal(f32);
    dr = sr;
    return $realtobits(dr);
  endfunction

  function automatic logic [31:0] f64_to_f32_bits(logic [63:0] f64);
    real dr;
    shortreal sr;
    dr = $bitstoreal(f64);
    sr = dr;
    return $shortrealtobits(sr);
  endfunction

  // ---------------------------------------------------------------------------
  // DMX CPU-side signals.
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // DMX <-> FP32
  // ---------------------------------------------------------------------------
  logic        fp32_req_valid, fp32_req_ready;
  logic [7:0]  fp32_ctrl;
  logic [32:0] fp32_a_rec, fp32_b_rec, fp32_c_rec;
  logic [2:0]  fp32_rounding_mode;
  logic        fp32_tininess_mode;
  logic        fp32_resp_valid;
  logic [32:0] fp32_result_rec;
  logic [4:0]  fp32_flags;

  // ---------------------------------------------------------------------------
  // DMX <-> FP64
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // CPU control state machine (DMX issued ops).
  // ---------------------------------------------------------------------------
  typedef enum logic [3:0] {
    ST_RESET,
    ST_FP32_FMA_REQ,
    ST_FP32_FMA_WAIT,
    ST_FP64_LOAD_A0,
    ST_FP64_LOAD_A1,
    ST_FP64_LOAD_B0,
    ST_FP64_LOAD_B1,
    ST_FP64_EXEC_REQ,
    ST_FP64_EXEC_WAIT,
    ST_FP32_ADD_REQ,
    ST_FP32_ADD_WAIT,
    ST_FINISH
  } state_e;

  state_e state;

  logic [31:0] stage1_start_cycle, stage_fp64_start_cycle, stage2_start_cycle;
  logic [3:0]  tid_ctr;
  logic [3:0]  tid_stage1, tid_exec, tid_stage2;
  logic [63:0] stage1_to_fp64;
  logic [31:0] fp32_from_fp64;

  assign csr_rounding_mode = 3'b000; // nearest-even
  assign csr_tininess_mode = 1'b1;   // after rounding

  // Default matrices use parameters; A[0][0] is injected after FP32 stage completes.
  function automatic logic [255:0] pack_matrix(logic [63:0] m00,
                                               logic [63:0] m01,
                                               logic [63:0] m10,
                                               logic [63:0] m11);
    return {m11, m10, m01, m00};
  endfunction

  // Bookkeeping for the latest FP64 result and flags.
  logic [63:0] fp64_c00_latched;
  logic [4:0]  fp64_flags_latched;

  // Issue convenience wires.
  logic instr_fire;
  assign instr_fire = instr_valid && cpu_req_ready;

  // Default drives.
  always_comb begin
    instr_valid = 1'b0;
    instr_opcode = OPC_NOP;
    instr_fmt = FMT_FP32;
    src0_data = '0;
    src1_data = '0;
    src2_data = '0;
    cpu_tid   = tid_ctr;
    case (state)
      ST_FP32_FMA_REQ: begin
        instr_valid  = 1'b1;
        instr_opcode = OPC_FP32_FMA;
        instr_fmt    = FMT_FP32;
        src0_data    = {32'd0, P_STAGE1_A};
        src1_data    = {32'd0, P_STAGE1_B};
        src2_data    = {32'd0, P_STAGE1_C};
        cpu_tid      = tid_stage1;
      end
      ST_FP64_LOAD_A0: begin
        instr_valid  = 1'b1;
        instr_opcode = OPC_FP64_LOAD_A_ROW0;
        instr_fmt    = FMT_FP64;
        src0_data    = stage1_to_fp64;
        src1_data    = P_MAT_A01;
        cpu_tid      = tid_ctr;
      end
      ST_FP64_LOAD_A1: begin
        instr_valid  = 1'b1;
        instr_opcode = OPC_FP64_LOAD_A_ROW1;
        instr_fmt    = FMT_FP64;
        src0_data    = P_MAT_A10;
        src1_data    = P_MAT_A11;
        cpu_tid      = tid_ctr;
      end
      ST_FP64_LOAD_B0: begin
        instr_valid  = 1'b1;
        instr_opcode = OPC_FP64_LOAD_B_ROW0;
        instr_fmt    = FMT_FP64;
        src0_data    = P_MAT_B00;
        src1_data    = P_MAT_B01;
        cpu_tid      = tid_ctr;
      end
      ST_FP64_LOAD_B1: begin
        instr_valid  = 1'b1;
        instr_opcode = OPC_FP64_LOAD_B_ROW1;
        instr_fmt    = FMT_FP64;
        src0_data    = P_MAT_B10;
        src1_data    = P_MAT_B11;
        cpu_tid      = tid_ctr;
      end
      ST_FP64_EXEC_REQ: begin
        instr_valid  = 1'b1;
        instr_opcode = OPC_FP64_EXECUTE;
        instr_fmt    = FMT_FP64;
        cpu_tid      = tid_exec;
      end
      ST_FP32_ADD_REQ: begin
        instr_valid  = 1'b1;
        instr_opcode = OPC_FP32_ADD;
        instr_fmt    = FMT_FP32;
        src0_data    = {32'd0, fp32_from_fp64};
        src1_data    = {32'd0, P_STAGE2_CONST};
        cpu_tid      = tid_stage2;
      end
      default: ;
    endcase
  end

  // CPU FSM.
  always_ff @(posedge clock or negedge reset_n) begin
    if (!reset_n) begin
      state               <= ST_RESET;
      tid_ctr             <= 4'd1;
      tid_stage1          <= 4'd1;
      tid_exec            <= 4'd2;
      tid_stage2          <= 4'd3;
      stage1_fp32_ieee    <= 32'd0;
      stage1_flags        <= '0;
      stage_fp64_c00      <= 64'd0;
      stage_fp64_c01      <= 64'd0;
      stage_fp64_c10      <= 64'd0;
      stage_fp64_c11      <= 64'd0;
      stage_fp64_flags    <= '0;
      stage2_fp32_ieee    <= 32'd0;
      stage2_flags        <= '0;
      stage2_input_ieee   <= 32'd0;
      stage2_const_ieee   <= P_STAGE2_CONST;
      stage1_to_fp64      <= 64'd0;
      fp64_c00_latched    <= 64'd0;
      fp64_flags_latched  <= '0;
      fp32_from_fp64      <= 32'd0;
      stage1_cycles       <= 32'd0;
      stage_fp64_cycles   <= 32'd0;
      stage2_cycles       <= 32'd0;
      stage1_start_cycle  <= 32'd0;
      stage_fp64_start_cycle <= 32'd0;
      stage2_start_cycle  <= 32'd0;
      cycle_counter       <= 32'd0;
      stage1_complete     <= 1'b0;
      stage_fp64_complete <= 1'b0;
      stage2_complete     <= 1'b0;
      done                <= 1'b0;
      pass                <= 1'b0;
      state_id            <= ST_RESET;
    end else begin
      cycle_counter <= cycle_counter + 1;
      state_id      <= state;

      // Capture any response; consume queue implicitly.
      if (cpu_resp_valid) begin
        $display("[%0t] DMX RESP tid=%0d data=0x%016h flags=0x%02h",
                 $time, cpu_resp_tid, cpu_resp_data, cpu_resp_flags);
        if (cpu_resp_tid == tid_stage1 && !stage1_complete) begin
          stage1_fp32_ieee   <= cpu_resp_data[31:0];
          stage1_flags       <= cpu_resp_flags;
          stage1_cycles      <= cycle_counter - stage1_start_cycle + 1;
          stage1_complete    <= 1'b1;
          stage1_to_fp64     <= f32_to_f64_bits(cpu_resp_data[31:0]);
        end
        if (cpu_resp_tid == tid_exec && !stage_fp64_complete) begin
          fp64_c00_latched   <= cpu_resp_data;
          fp64_flags_latched <= cpu_resp_flags;
          stage_fp64_c00     <= cpu_resp_data;
          stage_fp64_flags   <= cpu_resp_flags;
          stage_fp64_cycles  <= cycle_counter - stage_fp64_start_cycle + 1;
          stage_fp64_complete <= 1'b1;
          fp32_from_fp64     <= f64_to_f32_bits(cpu_resp_data);
          stage2_input_ieee  <= f64_to_f32_bits(cpu_resp_data);
        end
        if (cpu_resp_tid == tid_stage2 && !stage2_complete) begin
          stage2_fp32_ieee   <= cpu_resp_data[31:0];
          stage2_flags       <= cpu_resp_flags;
          stage2_cycles      <= cycle_counter - stage2_start_cycle + 1;
          stage2_complete    <= 1'b1;
        end
      end

      case (state)
        ST_RESET: begin
          stage1_complete     <= 1'b0;
          stage_fp64_complete <= 1'b0;
          stage2_complete     <= 1'b0;
          done                <= 1'b0;
          pass                <= 1'b0;
          stage2_const_ieee   <= P_STAGE2_CONST;
          tid_ctr             <= 4'd4;
          tid_stage1          <= 4'd1;
          tid_exec            <= 4'd2;
          tid_stage2          <= 4'd3;
          stage1_start_cycle  <= cycle_counter;
          state               <= ST_FP32_FMA_REQ;
        end
        ST_FP32_FMA_REQ: begin
          $display("[%0t] FP32_FMA_REQ instr_valid=%0b ready=%0b tid=%0d",
                   $time, instr_valid, cpu_req_ready, tid_stage1);
          if (instr_fire) begin
            stage1_start_cycle <= cycle_counter;
            state <= ST_FP32_FMA_WAIT;
          end
        end
        ST_FP32_FMA_WAIT: begin
          if (stage1_complete) begin
            state <= ST_FP64_LOAD_A0;
          end
        end
        ST_FP64_LOAD_A0: begin
          if (instr_fire) begin
            tid_ctr <= tid_ctr + 1;
            state   <= ST_FP64_LOAD_A1;
          end
        end
        ST_FP64_LOAD_A1: begin
          if (instr_fire) begin
            tid_ctr <= tid_ctr + 1;
            state   <= ST_FP64_LOAD_B0;
          end
        end
        ST_FP64_LOAD_B0: begin
          if (instr_fire) begin
            tid_ctr <= tid_ctr + 1;
            state   <= ST_FP64_LOAD_B1;
          end
        end
        ST_FP64_LOAD_B1: begin
          if (instr_fire) begin
            tid_ctr <= tid_ctr + 1;
            state   <= ST_FP64_EXEC_REQ;
          end
        end
        ST_FP64_EXEC_REQ: begin
          if (instr_fire) begin
            stage_fp64_start_cycle <= cycle_counter;
            state                  <= ST_FP64_EXEC_WAIT;
          end
        end
        ST_FP64_EXEC_WAIT: begin
          if (stage_fp64_complete) begin
            stage2_start_cycle <= cycle_counter + 1;
            state              <= ST_FP32_ADD_REQ;
          end
        end
        ST_FP32_ADD_REQ: begin
          if (instr_fire) begin
            stage2_start_cycle <= cycle_counter;
            state              <= ST_FP32_ADD_WAIT;
          end
        end
        ST_FP32_ADD_WAIT: begin
          if (stage2_complete) begin
            state <= ST_FINISH;
          end
        end
        ST_FINISH: begin
          done <= 1'b1;
          pass <= (stage1_fp32_ieee == P_STAGE1_EXPECT) &&
                  (stage1_flags == P_STAGE1_FLAGS) &&
                  (stage_fp64_c00 == P_FP64_EXPECT_C00) &&
                  (stage_fp64_flags == P_FP64_EXPECT_FLAGS) &&
                  (stage2_fp32_ieee == P_STAGE2_EXPECT) &&
                  (stage2_flags == P_STAGE2_FLAGS);
        end
        default: state <= ST_FINISH;
      endcase
    end
  end

  assign stage1_start_cycle_o    = stage1_start_cycle;
  assign stage_fp64_start_cycle_o = stage_fp64_start_cycle;
  assign stage2_start_cycle_o    = stage2_start_cycle;

endmodule
