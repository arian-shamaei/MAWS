`ifndef TB_CPU_COMMON_SVH
`define TB_CPU_COMMON_SVH

function automatic real f32_to_real(logic [31:0] bits);
  shortreal sr;
  sr = $bitstoshortreal(bits);
  return sr;
endfunction

function automatic real f64_to_real(logic [63:0] bits);
  real dr;
  dr = $bitstoreal(bits);
  return dr;
endfunction

function automatic string flags_to_text(logic [4:0] flags);
  string s;
  if (flags == 5'b0) return "none";
  if (flags[4]) s = {s, " invalid"};
  if (flags[3]) s = {s, " divByZero"};
  if (flags[2]) s = {s, " overflow"};
  if (flags[1]) s = {s, " underflow"};
  if (flags[0]) s = {s, " inexact"};
  return s;
endfunction

int scoreboard_stage_count = 0;

task automatic scoreboard_reset();
  scoreboard_stage_count = 0;
endtask

function automatic string state_name(logic [3:0] id);
  case (id)
    4'd0: state_name = "RESET";
    4'd1: state_name = "FP32_FMA_REQ";
    4'd2: state_name = "FP32_FMA_WAIT";
    4'd3: state_name = "FP64_LOAD_A0";
    4'd4: state_name = "FP64_LOAD_A1";
    4'd5: state_name = "FP64_LOAD_B0";
    4'd6: state_name = "FP64_LOAD_B1";
    4'd7: state_name = "FP64_EXEC_REQ";
    4'd8: state_name = "FP64_EXEC_WAIT";
    4'd9: state_name = "FP32_ADD_REQ";
    4'd10: state_name = "FP32_ADD_WAIT";
    4'd11: state_name = "FINISH";
    default: state_name = "UNKNOWN";
  endcase
endfunction

task automatic report_stage(
    input string label,
    input bit     is_fp64,
    input logic [63:0] bits64,
    input logic [31:0] bits32,
    input logic [4:0]  flags,
    input logic [31:0] cycles,
    input string path_desc
);
  real value;
  real time_ns;
  scoreboard_stage_count++;
  if (is_fp64) value = f64_to_real(bits64);
  else         value = f32_to_real(bits32);
  time_ns = cycles * 10.0;
  $display("----------------------------------------------------------------");
  $display("%s", label);
  $display("  Hex        : %s", is_fp64 ? $sformatf("%016h", bits64) : $sformatf("%08h", bits32));
  $display("  Decimal    : %f", value);
  $display("  Flags      : %s", flags_to_text(flags));
  $display("  Latency    : %0d cycles (~%0.1f ns)", cycles, time_ns);
  $display("  Flow       : %s", path_desc);
endtask

task automatic report_header(input string title, input bit pass);
  $display("");
  $display("=== %s ===", title);
  $display("Overall result: %s", pass ? "PASS" : "FAIL");
  $display("Total stages : %0d", scoreboard_stage_count);
endtask

task automatic log_flow(
    input int    fd,
    input string scenario,
    input string stage,
    input string source,
    input string destination,
    input logic [31:0] start_cycle,
    input logic [31:0] end_cycle,
    input string value_hex,
    input string value_decimal,
    input string flags_text
);
  if (fd != 0) begin
    $fwrite(fd, "%s,%s,%s,%s,%0d,%0d,%s,%s,%s\n",
            scenario, stage, source, destination,
            start_cycle, end_cycle,
            value_hex, value_decimal, flags_text.len() ? flags_text : "none");
  end
endtask

`endif // TB_CPU_COMMON_SVH
