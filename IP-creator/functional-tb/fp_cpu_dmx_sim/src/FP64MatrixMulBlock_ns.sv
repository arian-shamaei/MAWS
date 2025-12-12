module fp64_MulFullRawFN(
  input          io_a_isNaN,
  input          io_a_isInf,
  input          io_a_isZero,
  input          io_a_sign,
  input  [12:0]  io_a_sExp,
  input  [53:0]  io_a_sig,
  input          io_b_isNaN,
  input          io_b_isInf,
  input          io_b_isZero,
  input          io_b_sign,
  input  [12:0]  io_b_sExp,
  input  [53:0]  io_b_sig,
  output         io_invalidExc,
  output         io_rawOut_isNaN,
  output         io_rawOut_isInf,
  output         io_rawOut_isZero,
  output         io_rawOut_sign,
  output [12:0]  io_rawOut_sExp,
  output [105:0] io_rawOut_sig
);
  wire  notSigNaN_invalidExc = io_a_isInf & io_b_isZero | io_a_isZero & io_b_isInf; // @[fp64_MulRecFN.scala 58:60]
  wire [12:0] _common_sExpOut_T_2 = $signed(io_a_sExp) + $signed(io_b_sExp); // @[fp64_MulRecFN.scala 62:36]
  wire [107:0] _common_sigOut_T = io_a_sig * io_b_sig; // @[fp64_MulRecFN.scala 63:35]
  wire  _io_invalidExc_T_2 = io_a_isNaN & ~io_a_sig[51]; // @[common.scala 82:46]
  wire  _io_invalidExc_T_5 = io_b_isNaN & ~io_b_sig[51]; // @[common.scala 82:46]
  assign io_invalidExc = _io_invalidExc_T_2 | _io_invalidExc_T_5 | notSigNaN_invalidExc; // @[fp64_MulRecFN.scala 66:71]
  assign io_rawOut_isNaN = io_a_isNaN | io_b_isNaN; // @[fp64_MulRecFN.scala 70:35]
  assign io_rawOut_isInf = io_a_isInf | io_b_isInf; // @[fp64_MulRecFN.scala 59:38]
  assign io_rawOut_isZero = io_a_isZero | io_b_isZero; // @[fp64_MulRecFN.scala 60:40]
  assign io_rawOut_sign = io_a_sign ^ io_b_sign; // @[fp64_MulRecFN.scala 61:36]
  assign io_rawOut_sExp = $signed(_common_sExpOut_T_2) - 13'sh800; // @[fp64_MulRecFN.scala 62:48]
  assign io_rawOut_sig = _common_sigOut_T[105:0]; // @[fp64_MulRecFN.scala 63:46]
endmodule
module fp64_MulRawFN(
  input         io_a_isNaN,
  input         io_a_isInf,
  input         io_a_isZero,
  input         io_a_sign,
  input  [12:0] io_a_sExp,
  input  [53:0] io_a_sig,
  input         io_b_isNaN,
  input         io_b_isInf,
  input         io_b_isZero,
  input         io_b_sign,
  input  [12:0] io_b_sExp,
  input  [53:0] io_b_sig,
  output        io_invalidExc,
  output        io_rawOut_isNaN,
  output        io_rawOut_isInf,
  output        io_rawOut_isZero,
  output        io_rawOut_sign,
  output [12:0] io_rawOut_sExp,
  output [55:0] io_rawOut_sig
);
  wire  mulFullRaw_io_a_isNaN; // @[fp64_MulRecFN.scala 84:28]
  wire  mulFullRaw_io_a_isInf; // @[fp64_MulRecFN.scala 84:28]
  wire  mulFullRaw_io_a_isZero; // @[fp64_MulRecFN.scala 84:28]
  wire  mulFullRaw_io_a_sign; // @[fp64_MulRecFN.scala 84:28]
  wire [12:0] mulFullRaw_io_a_sExp; // @[fp64_MulRecFN.scala 84:28]
  wire [53:0] mulFullRaw_io_a_sig; // @[fp64_MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_isNaN; // @[fp64_MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_isInf; // @[fp64_MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_isZero; // @[fp64_MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_sign; // @[fp64_MulRecFN.scala 84:28]
  wire [12:0] mulFullRaw_io_b_sExp; // @[fp64_MulRecFN.scala 84:28]
  wire [53:0] mulFullRaw_io_b_sig; // @[fp64_MulRecFN.scala 84:28]
  wire  mulFullRaw_io_invalidExc; // @[fp64_MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_isNaN; // @[fp64_MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_isInf; // @[fp64_MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_isZero; // @[fp64_MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_sign; // @[fp64_MulRecFN.scala 84:28]
  wire [12:0] mulFullRaw_io_rawOut_sExp; // @[fp64_MulRecFN.scala 84:28]
  wire [105:0] mulFullRaw_io_rawOut_sig; // @[fp64_MulRecFN.scala 84:28]
  wire  _io_rawOut_sig_T_2 = |mulFullRaw_io_rawOut_sig[50:0]; // @[fp64_MulRecFN.scala 93:55]
  fp64_MulFullRawFN mulFullRaw ( // @[fp64_MulRecFN.scala 84:28]
    .io_a_isNaN(mulFullRaw_io_a_isNaN),
    .io_a_isInf(mulFullRaw_io_a_isInf),
    .io_a_isZero(mulFullRaw_io_a_isZero),
    .io_a_sign(mulFullRaw_io_a_sign),
    .io_a_sExp(mulFullRaw_io_a_sExp),
    .io_a_sig(mulFullRaw_io_a_sig),
    .io_b_isNaN(mulFullRaw_io_b_isNaN),
    .io_b_isInf(mulFullRaw_io_b_isInf),
    .io_b_isZero(mulFullRaw_io_b_isZero),
    .io_b_sign(mulFullRaw_io_b_sign),
    .io_b_sExp(mulFullRaw_io_b_sExp),
    .io_b_sig(mulFullRaw_io_b_sig),
    .io_invalidExc(mulFullRaw_io_invalidExc),
    .io_rawOut_isNaN(mulFullRaw_io_rawOut_isNaN),
    .io_rawOut_isInf(mulFullRaw_io_rawOut_isInf),
    .io_rawOut_isZero(mulFullRaw_io_rawOut_isZero),
    .io_rawOut_sign(mulFullRaw_io_rawOut_sign),
    .io_rawOut_sExp(mulFullRaw_io_rawOut_sExp),
    .io_rawOut_sig(mulFullRaw_io_rawOut_sig)
  );
  assign io_invalidExc = mulFullRaw_io_invalidExc; // @[fp64_MulRecFN.scala 89:19]
  assign io_rawOut_isNaN = mulFullRaw_io_rawOut_isNaN; // @[fp64_MulRecFN.scala 90:15]
  assign io_rawOut_isInf = mulFullRaw_io_rawOut_isInf; // @[fp64_MulRecFN.scala 90:15]
  assign io_rawOut_isZero = mulFullRaw_io_rawOut_isZero; // @[fp64_MulRecFN.scala 90:15]
  assign io_rawOut_sign = mulFullRaw_io_rawOut_sign; // @[fp64_MulRecFN.scala 90:15]
  assign io_rawOut_sExp = mulFullRaw_io_rawOut_sExp; // @[fp64_MulRecFN.scala 90:15]
  assign io_rawOut_sig = {mulFullRaw_io_rawOut_sig[105:51],_io_rawOut_sig_T_2}; // @[Cat.scala 33:92]
  assign mulFullRaw_io_a_isNaN = io_a_isNaN; // @[fp64_MulRecFN.scala 86:21]
  assign mulFullRaw_io_a_isInf = io_a_isInf; // @[fp64_MulRecFN.scala 86:21]
  assign mulFullRaw_io_a_isZero = io_a_isZero; // @[fp64_MulRecFN.scala 86:21]
  assign mulFullRaw_io_a_sign = io_a_sign; // @[fp64_MulRecFN.scala 86:21]
  assign mulFullRaw_io_a_sExp = io_a_sExp; // @[fp64_MulRecFN.scala 86:21]
  assign mulFullRaw_io_a_sig = io_a_sig; // @[fp64_MulRecFN.scala 86:21]
  assign mulFullRaw_io_b_isNaN = io_b_isNaN; // @[fp64_MulRecFN.scala 87:21]
  assign mulFullRaw_io_b_isInf = io_b_isInf; // @[fp64_MulRecFN.scala 87:21]
  assign mulFullRaw_io_b_isZero = io_b_isZero; // @[fp64_MulRecFN.scala 87:21]
  assign mulFullRaw_io_b_sign = io_b_sign; // @[fp64_MulRecFN.scala 87:21]
  assign mulFullRaw_io_b_sExp = io_b_sExp; // @[fp64_MulRecFN.scala 87:21]
  assign mulFullRaw_io_b_sig = io_b_sig; // @[fp64_MulRecFN.scala 87:21]
endmodule
module fp64_RoundAnyRawFNToRecFN_ie11_is55_oe11_os53(
  input         io_invalidExc,
  input         io_in_isNaN,
  input         io_in_isInf,
  input         io_in_isZero,
  input         io_in_sign,
  input  [12:0] io_in_sExp,
  input  [55:0] io_in_sig,
  input  [2:0]  io_roundingMode,
  input         io_detectTininess,
  output [64:0] io_out,
  output [4:0]  io_exceptionFlags
);
  wire  roundingMode_near_even = io_roundingMode == 3'h0; // @[RoundAnyRawFNToRecFN.scala 90:53]
  wire  roundingMode_min = io_roundingMode == 3'h2; // @[RoundAnyRawFNToRecFN.scala 92:53]
  wire  roundingMode_max = io_roundingMode == 3'h3; // @[RoundAnyRawFNToRecFN.scala 93:53]
  wire  roundingMode_near_maxMag = io_roundingMode == 3'h4; // @[RoundAnyRawFNToRecFN.scala 94:53]
  wire  roundingMode_odd = io_roundingMode == 3'h6; // @[RoundAnyRawFNToRecFN.scala 95:53]
  wire  roundMagUp = roundingMode_min & io_in_sign | roundingMode_max & ~io_in_sign; // @[RoundAnyRawFNToRecFN.scala 98:42]
  wire  doShiftSigDown1 = io_in_sig[55]; // @[RoundAnyRawFNToRecFN.scala 120:57]
  wire [11:0] _roundMask_T_1 = ~io_in_sExp[11:0]; // @[primitives.scala 52:21]
  wire  roundMask_msb = _roundMask_T_1[11]; // @[primitives.scala 58:25]
  wire [10:0] roundMask_lsbs = _roundMask_T_1[10:0]; // @[primitives.scala 59:26]
  wire  roundMask_msb_1 = roundMask_lsbs[10]; // @[primitives.scala 58:25]
  wire [9:0] roundMask_lsbs_1 = roundMask_lsbs[9:0]; // @[primitives.scala 59:26]
  wire  roundMask_msb_2 = roundMask_lsbs_1[9]; // @[primitives.scala 58:25]
  wire [8:0] roundMask_lsbs_2 = roundMask_lsbs_1[8:0]; // @[primitives.scala 59:26]
  wire  roundMask_msb_3 = roundMask_lsbs_2[8]; // @[primitives.scala 58:25]
  wire [7:0] roundMask_lsbs_3 = roundMask_lsbs_2[7:0]; // @[primitives.scala 59:26]
  wire  roundMask_msb_4 = roundMask_lsbs_3[7]; // @[primitives.scala 58:25]
  wire [6:0] roundMask_lsbs_4 = roundMask_lsbs_3[6:0]; // @[primitives.scala 59:26]
  wire  roundMask_msb_5 = roundMask_lsbs_4[6]; // @[primitives.scala 58:25]
  wire [5:0] roundMask_lsbs_5 = roundMask_lsbs_4[5:0]; // @[primitives.scala 59:26]
  wire [64:0] roundMask_shift = 65'sh10000000000000000 >>> roundMask_lsbs_5; // @[primitives.scala 76:56]
  wire [31:0] _GEN_0 = {{16'd0}, roundMask_shift[44:29]}; // @[Bitwise.scala 108:31]
  wire [31:0] _roundMask_T_7 = _GEN_0 & 32'hffff; // @[Bitwise.scala 108:31]
  wire [31:0] _roundMask_T_9 = {roundMask_shift[28:13], 16'h0}; // @[Bitwise.scala 108:70]
  wire [31:0] _roundMask_T_11 = _roundMask_T_9 & 32'hffff0000; // @[Bitwise.scala 108:80]
  wire [31:0] _roundMask_T_12 = _roundMask_T_7 | _roundMask_T_11; // @[Bitwise.scala 108:39]
  wire [31:0] _GEN_1 = {{8'd0}, _roundMask_T_12[31:8]}; // @[Bitwise.scala 108:31]
  wire [31:0] _roundMask_T_17 = _GEN_1 & 32'hff00ff; // @[Bitwise.scala 108:31]
  wire [31:0] _roundMask_T_19 = {_roundMask_T_12[23:0], 8'h0}; // @[Bitwise.scala 108:70]
  wire [31:0] _roundMask_T_21 = _roundMask_T_19 & 32'hff00ff00; // @[Bitwise.scala 108:80]
  wire [31:0] _roundMask_T_22 = _roundMask_T_17 | _roundMask_T_21; // @[Bitwise.scala 108:39]
  wire [31:0] _GEN_2 = {{4'd0}, _roundMask_T_22[31:4]}; // @[Bitwise.scala 108:31]
  wire [31:0] _roundMask_T_27 = _GEN_2 & 32'hf0f0f0f; // @[Bitwise.scala 108:31]
  wire [31:0] _roundMask_T_29 = {_roundMask_T_22[27:0], 4'h0}; // @[Bitwise.scala 108:70]
  wire [31:0] _roundMask_T_31 = _roundMask_T_29 & 32'hf0f0f0f0; // @[Bitwise.scala 108:80]
  wire [31:0] _roundMask_T_32 = _roundMask_T_27 | _roundMask_T_31; // @[Bitwise.scala 108:39]
  wire [31:0] _GEN_3 = {{2'd0}, _roundMask_T_32[31:2]}; // @[Bitwise.scala 108:31]
  wire [31:0] _roundMask_T_37 = _GEN_3 & 32'h33333333; // @[Bitwise.scala 108:31]
  wire [31:0] _roundMask_T_39 = {_roundMask_T_32[29:0], 2'h0}; // @[Bitwise.scala 108:70]
  wire [31:0] _roundMask_T_41 = _roundMask_T_39 & 32'hcccccccc; // @[Bitwise.scala 108:80]
  wire [31:0] _roundMask_T_42 = _roundMask_T_37 | _roundMask_T_41; // @[Bitwise.scala 108:39]
  wire [31:0] _GEN_4 = {{1'd0}, _roundMask_T_42[31:1]}; // @[Bitwise.scala 108:31]
  wire [31:0] _roundMask_T_47 = _GEN_4 & 32'h55555555; // @[Bitwise.scala 108:31]
  wire [31:0] _roundMask_T_49 = {_roundMask_T_42[30:0], 1'h0}; // @[Bitwise.scala 108:70]
  wire [31:0] _roundMask_T_51 = _roundMask_T_49 & 32'haaaaaaaa; // @[Bitwise.scala 108:80]
  wire [31:0] _roundMask_T_52 = _roundMask_T_47 | _roundMask_T_51; // @[Bitwise.scala 108:39]
  wire [15:0] _GEN_5 = {{8'd0}, roundMask_shift[60:53]}; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_58 = _GEN_5 & 16'hff; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_60 = {roundMask_shift[52:45], 8'h0}; // @[Bitwise.scala 108:70]
  wire [15:0] _roundMask_T_62 = _roundMask_T_60 & 16'hff00; // @[Bitwise.scala 108:80]
  wire [15:0] _roundMask_T_63 = _roundMask_T_58 | _roundMask_T_62; // @[Bitwise.scala 108:39]
  wire [15:0] _GEN_6 = {{4'd0}, _roundMask_T_63[15:4]}; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_68 = _GEN_6 & 16'hf0f; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_70 = {_roundMask_T_63[11:0], 4'h0}; // @[Bitwise.scala 108:70]
  wire [15:0] _roundMask_T_72 = _roundMask_T_70 & 16'hf0f0; // @[Bitwise.scala 108:80]
  wire [15:0] _roundMask_T_73 = _roundMask_T_68 | _roundMask_T_72; // @[Bitwise.scala 108:39]
  wire [15:0] _GEN_7 = {{2'd0}, _roundMask_T_73[15:2]}; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_78 = _GEN_7 & 16'h3333; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_80 = {_roundMask_T_73[13:0], 2'h0}; // @[Bitwise.scala 108:70]
  wire [15:0] _roundMask_T_82 = _roundMask_T_80 & 16'hcccc; // @[Bitwise.scala 108:80]
  wire [15:0] _roundMask_T_83 = _roundMask_T_78 | _roundMask_T_82; // @[Bitwise.scala 108:39]
  wire [15:0] _GEN_8 = {{1'd0}, _roundMask_T_83[15:1]}; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_88 = _GEN_8 & 16'h5555; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_90 = {_roundMask_T_83[14:0], 1'h0}; // @[Bitwise.scala 108:70]
  wire [15:0] _roundMask_T_92 = _roundMask_T_90 & 16'haaaa; // @[Bitwise.scala 108:80]
  wire [15:0] _roundMask_T_93 = _roundMask_T_88 | _roundMask_T_92; // @[Bitwise.scala 108:39]
  wire [50:0] _roundMask_T_102 = {_roundMask_T_52,_roundMask_T_93,roundMask_shift[61],roundMask_shift[62],
    roundMask_shift[63]}; // @[Cat.scala 33:92]
  wire [50:0] _roundMask_T_103 = ~_roundMask_T_102; // @[primitives.scala 73:32]
  wire [50:0] _roundMask_T_104 = roundMask_msb_5 ? 51'h0 : _roundMask_T_103; // @[primitives.scala 73:21]
  wire [50:0] _roundMask_T_105 = ~_roundMask_T_104; // @[primitives.scala 73:17]
  wire [50:0] _roundMask_T_106 = ~_roundMask_T_105; // @[primitives.scala 73:32]
  wire [50:0] _roundMask_T_107 = roundMask_msb_4 ? 51'h0 : _roundMask_T_106; // @[primitives.scala 73:21]
  wire [50:0] _roundMask_T_108 = ~_roundMask_T_107; // @[primitives.scala 73:17]
  wire [50:0] _roundMask_T_109 = ~_roundMask_T_108; // @[primitives.scala 73:32]
  wire [50:0] _roundMask_T_110 = roundMask_msb_3 ? 51'h0 : _roundMask_T_109; // @[primitives.scala 73:21]
  wire [50:0] _roundMask_T_111 = ~_roundMask_T_110; // @[primitives.scala 73:17]
  wire [50:0] _roundMask_T_112 = ~_roundMask_T_111; // @[primitives.scala 73:32]
  wire [50:0] _roundMask_T_113 = roundMask_msb_2 ? 51'h0 : _roundMask_T_112; // @[primitives.scala 73:21]
  wire [50:0] _roundMask_T_114 = ~_roundMask_T_113; // @[primitives.scala 73:17]
  wire [53:0] _roundMask_T_115 = {_roundMask_T_114,3'h7}; // @[primitives.scala 68:58]
  wire [2:0] _roundMask_T_122 = {roundMask_shift[0],roundMask_shift[1],roundMask_shift[2]}; // @[Cat.scala 33:92]
  wire [2:0] _roundMask_T_123 = roundMask_msb_5 ? _roundMask_T_122 : 3'h0; // @[primitives.scala 62:24]
  wire [2:0] _roundMask_T_124 = roundMask_msb_4 ? _roundMask_T_123 : 3'h0; // @[primitives.scala 62:24]
  wire [2:0] _roundMask_T_125 = roundMask_msb_3 ? _roundMask_T_124 : 3'h0; // @[primitives.scala 62:24]
  wire [2:0] _roundMask_T_126 = roundMask_msb_2 ? _roundMask_T_125 : 3'h0; // @[primitives.scala 62:24]
  wire [53:0] _roundMask_T_127 = roundMask_msb_1 ? _roundMask_T_115 : {{51'd0}, _roundMask_T_126}; // @[primitives.scala 67:24]
  wire [53:0] _roundMask_T_128 = roundMask_msb ? _roundMask_T_127 : 54'h0; // @[primitives.scala 62:24]
  wire [53:0] _GEN_9 = {{53'd0}, doShiftSigDown1}; // @[RoundAnyRawFNToRecFN.scala 159:23]
  wire [53:0] _roundMask_T_129 = _roundMask_T_128 | _GEN_9; // @[RoundAnyRawFNToRecFN.scala 159:23]
  wire [55:0] roundMask = {_roundMask_T_129,2'h3}; // @[RoundAnyRawFNToRecFN.scala 159:42]
  wire [56:0] _shiftedRoundMask_T = {1'h0,_roundMask_T_129,2'h3}; // @[RoundAnyRawFNToRecFN.scala 162:41]
  wire [55:0] shiftedRoundMask = _shiftedRoundMask_T[56:1]; // @[RoundAnyRawFNToRecFN.scala 162:53]
  wire [55:0] _roundPosMask_T = ~shiftedRoundMask; // @[RoundAnyRawFNToRecFN.scala 163:28]
  wire [55:0] roundPosMask = _roundPosMask_T & roundMask; // @[RoundAnyRawFNToRecFN.scala 163:46]
  wire [55:0] _roundPosBit_T = io_in_sig & roundPosMask; // @[RoundAnyRawFNToRecFN.scala 164:40]
  wire  roundPosBit = |_roundPosBit_T; // @[RoundAnyRawFNToRecFN.scala 164:56]
  wire [55:0] _anyRoundExtra_T = io_in_sig & shiftedRoundMask; // @[RoundAnyRawFNToRecFN.scala 165:42]
  wire  anyRoundExtra = |_anyRoundExtra_T; // @[RoundAnyRawFNToRecFN.scala 165:62]
  wire  anyRound = roundPosBit | anyRoundExtra; // @[RoundAnyRawFNToRecFN.scala 166:36]
  wire  _roundIncr_T = roundingMode_near_even | roundingMode_near_maxMag; // @[RoundAnyRawFNToRecFN.scala 169:38]
  wire  _roundIncr_T_1 = (roundingMode_near_even | roundingMode_near_maxMag) & roundPosBit; // @[RoundAnyRawFNToRecFN.scala 169:67]
  wire  _roundIncr_T_2 = roundMagUp & anyRound; // @[RoundAnyRawFNToRecFN.scala 171:29]
  wire  roundIncr = _roundIncr_T_1 | _roundIncr_T_2; // @[RoundAnyRawFNToRecFN.scala 170:31]
  wire [55:0] _roundedSig_T = io_in_sig | roundMask; // @[RoundAnyRawFNToRecFN.scala 174:32]
  wire [54:0] _roundedSig_T_2 = _roundedSig_T[55:2] + 54'h1; // @[RoundAnyRawFNToRecFN.scala 174:49]
  wire  _roundedSig_T_4 = ~anyRoundExtra; // @[RoundAnyRawFNToRecFN.scala 176:30]
  wire [54:0] _roundedSig_T_7 = roundingMode_near_even & roundPosBit & _roundedSig_T_4 ? roundMask[55:1] : 55'h0; // @[RoundAnyRawFNToRecFN.scala 175:25]
  wire [54:0] _roundedSig_T_8 = ~_roundedSig_T_7; // @[RoundAnyRawFNToRecFN.scala 175:21]
  wire [54:0] _roundedSig_T_9 = _roundedSig_T_2 & _roundedSig_T_8; // @[RoundAnyRawFNToRecFN.scala 174:57]
  wire [55:0] _roundedSig_T_10 = ~roundMask; // @[RoundAnyRawFNToRecFN.scala 180:32]
  wire [55:0] _roundedSig_T_11 = io_in_sig & _roundedSig_T_10; // @[RoundAnyRawFNToRecFN.scala 180:30]
  wire [54:0] _roundedSig_T_15 = roundingMode_odd & anyRound ? roundPosMask[55:1] : 55'h0; // @[RoundAnyRawFNToRecFN.scala 181:24]
  wire [54:0] _GEN_10 = {{1'd0}, _roundedSig_T_11[55:2]}; // @[RoundAnyRawFNToRecFN.scala 180:47]
  wire [54:0] _roundedSig_T_16 = _GEN_10 | _roundedSig_T_15; // @[RoundAnyRawFNToRecFN.scala 180:47]
  wire [54:0] roundedSig = roundIncr ? _roundedSig_T_9 : _roundedSig_T_16; // @[RoundAnyRawFNToRecFN.scala 173:16]
  wire [2:0] _sRoundedExp_T_1 = {1'b0,$signed(roundedSig[54:53])}; // @[RoundAnyRawFNToRecFN.scala 185:76]
  wire [12:0] _GEN_11 = {{10{_sRoundedExp_T_1[2]}},_sRoundedExp_T_1}; // @[RoundAnyRawFNToRecFN.scala 185:40]
  wire [13:0] sRoundedExp = $signed(io_in_sExp) + $signed(_GEN_11); // @[RoundAnyRawFNToRecFN.scala 185:40]
  wire [11:0] common_expOut = sRoundedExp[11:0]; // @[RoundAnyRawFNToRecFN.scala 187:37]
  wire [51:0] common_fractOut = doShiftSigDown1 ? roundedSig[52:1] : roundedSig[51:0]; // @[RoundAnyRawFNToRecFN.scala 189:16]
  wire [3:0] _common_overflow_T = sRoundedExp[13:10]; // @[RoundAnyRawFNToRecFN.scala 196:30]
  wire  common_overflow = $signed(_common_overflow_T) >= 4'sh3; // @[RoundAnyRawFNToRecFN.scala 196:50]
  wire  common_totalUnderflow = $signed(sRoundedExp) < 14'sh3ce; // @[RoundAnyRawFNToRecFN.scala 200:31]
  wire  unboundedRange_roundPosBit = doShiftSigDown1 ? io_in_sig[2] : io_in_sig[1]; // @[RoundAnyRawFNToRecFN.scala 203:16]
  wire  unboundedRange_anyRound = doShiftSigDown1 & io_in_sig[2] | |io_in_sig[1:0]; // @[RoundAnyRawFNToRecFN.scala 205:49]
  wire  _unboundedRange_roundIncr_T_1 = _roundIncr_T & unboundedRange_roundPosBit; // @[RoundAnyRawFNToRecFN.scala 207:67]
  wire  _unboundedRange_roundIncr_T_2 = roundMagUp & unboundedRange_anyRound; // @[RoundAnyRawFNToRecFN.scala 209:29]
  wire  unboundedRange_roundIncr = _unboundedRange_roundIncr_T_1 | _unboundedRange_roundIncr_T_2; // @[RoundAnyRawFNToRecFN.scala 208:46]
  wire  roundCarry = doShiftSigDown1 ? roundedSig[54] : roundedSig[53]; // @[RoundAnyRawFNToRecFN.scala 211:16]
  wire [1:0] _common_underflow_T = io_in_sExp[12:11]; // @[RoundAnyRawFNToRecFN.scala 220:49]
  wire  _common_underflow_T_5 = doShiftSigDown1 ? roundMask[3] : roundMask[2]; // @[RoundAnyRawFNToRecFN.scala 221:30]
  wire  _common_underflow_T_6 = anyRound & $signed(_common_underflow_T) <= 2'sh0 & _common_underflow_T_5; // @[RoundAnyRawFNToRecFN.scala 220:72]
  wire  _common_underflow_T_10 = doShiftSigDown1 ? roundMask[4] : roundMask[3]; // @[RoundAnyRawFNToRecFN.scala 223:39]
  wire  _common_underflow_T_11 = ~_common_underflow_T_10; // @[RoundAnyRawFNToRecFN.scala 223:34]
  wire  _common_underflow_T_12 = io_detectTininess & _common_underflow_T_11; // @[RoundAnyRawFNToRecFN.scala 222:77]
  wire  _common_underflow_T_13 = _common_underflow_T_12 & roundCarry; // @[RoundAnyRawFNToRecFN.scala 226:38]
  wire  _common_underflow_T_15 = _common_underflow_T_13 & roundPosBit & unboundedRange_roundIncr; // @[RoundAnyRawFNToRecFN.scala 227:60]
  wire  _common_underflow_T_16 = ~_common_underflow_T_15; // @[RoundAnyRawFNToRecFN.scala 222:27]
  wire  _common_underflow_T_17 = _common_underflow_T_6 & _common_underflow_T_16; // @[RoundAnyRawFNToRecFN.scala 221:76]
  wire  common_underflow = common_totalUnderflow | _common_underflow_T_17; // @[RoundAnyRawFNToRecFN.scala 217:40]
  wire  common_inexact = common_totalUnderflow | anyRound; // @[RoundAnyRawFNToRecFN.scala 230:49]
  wire  isNaNOut = io_invalidExc | io_in_isNaN; // @[RoundAnyRawFNToRecFN.scala 235:34]
  wire  commonCase = ~isNaNOut & ~io_in_isInf & ~io_in_isZero; // @[RoundAnyRawFNToRecFN.scala 237:61]
  wire  overflow = commonCase & common_overflow; // @[RoundAnyRawFNToRecFN.scala 238:32]
  wire  underflow = commonCase & common_underflow; // @[RoundAnyRawFNToRecFN.scala 239:32]
  wire  inexact = overflow | commonCase & common_inexact; // @[RoundAnyRawFNToRecFN.scala 240:28]
  wire  overflow_roundMagUp = _roundIncr_T | roundMagUp; // @[RoundAnyRawFNToRecFN.scala 243:60]
  wire  pegMinNonzeroMagOut = commonCase & common_totalUnderflow & (roundMagUp | roundingMode_odd); // @[RoundAnyRawFNToRecFN.scala 245:45]
  wire  pegMaxFiniteMagOut = overflow & ~overflow_roundMagUp; // @[RoundAnyRawFNToRecFN.scala 246:39]
  wire  notNaN_isInfOut = io_in_isInf | overflow & overflow_roundMagUp; // @[RoundAnyRawFNToRecFN.scala 248:32]
  wire  signOut = isNaNOut ? 1'h0 : io_in_sign; // @[RoundAnyRawFNToRecFN.scala 250:22]
  wire [11:0] _expOut_T_1 = io_in_isZero | common_totalUnderflow ? 12'he00 : 12'h0; // @[RoundAnyRawFNToRecFN.scala 253:18]
  wire [11:0] _expOut_T_2 = ~_expOut_T_1; // @[RoundAnyRawFNToRecFN.scala 253:14]
  wire [11:0] _expOut_T_3 = common_expOut & _expOut_T_2; // @[RoundAnyRawFNToRecFN.scala 252:24]
  wire [11:0] _expOut_T_5 = pegMinNonzeroMagOut ? 12'hc31 : 12'h0; // @[RoundAnyRawFNToRecFN.scala 257:18]
  wire [11:0] _expOut_T_6 = ~_expOut_T_5; // @[RoundAnyRawFNToRecFN.scala 257:14]
  wire [11:0] _expOut_T_7 = _expOut_T_3 & _expOut_T_6; // @[RoundAnyRawFNToRecFN.scala 256:17]
  wire [11:0] _expOut_T_8 = pegMaxFiniteMagOut ? 12'h400 : 12'h0; // @[RoundAnyRawFNToRecFN.scala 261:18]
  wire [11:0] _expOut_T_9 = ~_expOut_T_8; // @[RoundAnyRawFNToRecFN.scala 261:14]
  wire [11:0] _expOut_T_10 = _expOut_T_7 & _expOut_T_9; // @[RoundAnyRawFNToRecFN.scala 260:17]
  wire [11:0] _expOut_T_11 = notNaN_isInfOut ? 12'h200 : 12'h0; // @[RoundAnyRawFNToRecFN.scala 265:18]
  wire [11:0] _expOut_T_12 = ~_expOut_T_11; // @[RoundAnyRawFNToRecFN.scala 265:14]
  wire [11:0] _expOut_T_13 = _expOut_T_10 & _expOut_T_12; // @[RoundAnyRawFNToRecFN.scala 264:17]
  wire [11:0] _expOut_T_14 = pegMinNonzeroMagOut ? 12'h3ce : 12'h0; // @[RoundAnyRawFNToRecFN.scala 269:16]
  wire [11:0] _expOut_T_15 = _expOut_T_13 | _expOut_T_14; // @[RoundAnyRawFNToRecFN.scala 268:18]
  wire [11:0] _expOut_T_16 = pegMaxFiniteMagOut ? 12'hbff : 12'h0; // @[RoundAnyRawFNToRecFN.scala 273:16]
  wire [11:0] _expOut_T_17 = _expOut_T_15 | _expOut_T_16; // @[RoundAnyRawFNToRecFN.scala 272:15]
  wire [11:0] _expOut_T_18 = notNaN_isInfOut ? 12'hc00 : 12'h0; // @[RoundAnyRawFNToRecFN.scala 277:16]
  wire [11:0] _expOut_T_19 = _expOut_T_17 | _expOut_T_18; // @[RoundAnyRawFNToRecFN.scala 276:15]
  wire [11:0] _expOut_T_20 = isNaNOut ? 12'he00 : 12'h0; // @[RoundAnyRawFNToRecFN.scala 278:16]
  wire [11:0] expOut = _expOut_T_19 | _expOut_T_20; // @[RoundAnyRawFNToRecFN.scala 277:73]
  wire [51:0] _fractOut_T_2 = isNaNOut ? 52'h8000000000000 : 52'h0; // @[RoundAnyRawFNToRecFN.scala 281:16]
  wire [51:0] _fractOut_T_3 = isNaNOut | io_in_isZero | common_totalUnderflow ? _fractOut_T_2 : common_fractOut; // @[RoundAnyRawFNToRecFN.scala 280:12]
  wire [51:0] _fractOut_T_5 = pegMaxFiniteMagOut ? 52'hfffffffffffff : 52'h0; // @[Bitwise.scala 77:12]
  wire [51:0] fractOut = _fractOut_T_3 | _fractOut_T_5; // @[RoundAnyRawFNToRecFN.scala 283:11]
  wire [12:0] _io_out_T = {signOut,expOut}; // @[RoundAnyRawFNToRecFN.scala 286:23]
  wire [3:0] _io_exceptionFlags_T_2 = {io_invalidExc,1'h0,overflow,underflow}; // @[RoundAnyRawFNToRecFN.scala 288:53]
  assign io_out = {_io_out_T,fractOut}; // @[RoundAnyRawFNToRecFN.scala 286:33]
  assign io_exceptionFlags = {_io_exceptionFlags_T_2,inexact}; // @[RoundAnyRawFNToRecFN.scala 288:66]
endmodule
module fp64_RoundRawFNToRecFN_e11_s53(
  input         io_invalidExc,
  input         io_in_isNaN,
  input         io_in_isInf,
  input         io_in_isZero,
  input         io_in_sign,
  input  [12:0] io_in_sExp,
  input  [55:0] io_in_sig,
  input  [2:0]  io_roundingMode,
  input         io_detectTininess,
  output [64:0] io_out,
  output [4:0]  io_exceptionFlags
);
  wire  roundAnyRawFNToRecFN_io_invalidExc; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire  roundAnyRawFNToRecFN_io_in_isNaN; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire  roundAnyRawFNToRecFN_io_in_isInf; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire  roundAnyRawFNToRecFN_io_in_isZero; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire  roundAnyRawFNToRecFN_io_in_sign; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire [12:0] roundAnyRawFNToRecFN_io_in_sExp; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire [55:0] roundAnyRawFNToRecFN_io_in_sig; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire [2:0] roundAnyRawFNToRecFN_io_roundingMode; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire  roundAnyRawFNToRecFN_io_detectTininess; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire [64:0] roundAnyRawFNToRecFN_io_out; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire [4:0] roundAnyRawFNToRecFN_io_exceptionFlags; // @[RoundAnyRawFNToRecFN.scala 310:15]
  fp64_RoundAnyRawFNToRecFN_ie11_is55_oe11_os53 roundAnyRawFNToRecFN ( // @[RoundAnyRawFNToRecFN.scala 310:15]
    .io_invalidExc(roundAnyRawFNToRecFN_io_invalidExc),
    .io_in_isNaN(roundAnyRawFNToRecFN_io_in_isNaN),
    .io_in_isInf(roundAnyRawFNToRecFN_io_in_isInf),
    .io_in_isZero(roundAnyRawFNToRecFN_io_in_isZero),
    .io_in_sign(roundAnyRawFNToRecFN_io_in_sign),
    .io_in_sExp(roundAnyRawFNToRecFN_io_in_sExp),
    .io_in_sig(roundAnyRawFNToRecFN_io_in_sig),
    .io_roundingMode(roundAnyRawFNToRecFN_io_roundingMode),
    .io_detectTininess(roundAnyRawFNToRecFN_io_detectTininess),
    .io_out(roundAnyRawFNToRecFN_io_out),
    .io_exceptionFlags(roundAnyRawFNToRecFN_io_exceptionFlags)
  );
  assign io_out = roundAnyRawFNToRecFN_io_out; // @[RoundAnyRawFNToRecFN.scala 318:23]
  assign io_exceptionFlags = roundAnyRawFNToRecFN_io_exceptionFlags; // @[RoundAnyRawFNToRecFN.scala 319:23]
  assign roundAnyRawFNToRecFN_io_invalidExc = io_invalidExc; // @[RoundAnyRawFNToRecFN.scala 313:44]
  assign roundAnyRawFNToRecFN_io_in_isNaN = io_in_isNaN; // @[RoundAnyRawFNToRecFN.scala 315:44]
  assign roundAnyRawFNToRecFN_io_in_isInf = io_in_isInf; // @[RoundAnyRawFNToRecFN.scala 315:44]
  assign roundAnyRawFNToRecFN_io_in_isZero = io_in_isZero; // @[RoundAnyRawFNToRecFN.scala 315:44]
  assign roundAnyRawFNToRecFN_io_in_sign = io_in_sign; // @[RoundAnyRawFNToRecFN.scala 315:44]
  assign roundAnyRawFNToRecFN_io_in_sExp = io_in_sExp; // @[RoundAnyRawFNToRecFN.scala 315:44]
  assign roundAnyRawFNToRecFN_io_in_sig = io_in_sig; // @[RoundAnyRawFNToRecFN.scala 315:44]
  assign roundAnyRawFNToRecFN_io_roundingMode = io_roundingMode; // @[RoundAnyRawFNToRecFN.scala 316:44]
  assign roundAnyRawFNToRecFN_io_detectTininess = io_detectTininess; // @[RoundAnyRawFNToRecFN.scala 317:44]
endmodule
module fp64_MulRecFN(
  input  [64:0] io_a,
  input  [64:0] io_b,
  input  [2:0]  io_roundingMode,
  input         io_detectTininess,
  output [64:0] io_out,
  output [4:0]  io_exceptionFlags
);
  wire  fp64_MulRawFN__io_a_isNaN; // @[fp64_MulRecFN.scala 113:26]
  wire  fp64_MulRawFN__io_a_isInf; // @[fp64_MulRecFN.scala 113:26]
  wire  fp64_MulRawFN__io_a_isZero; // @[fp64_MulRecFN.scala 113:26]
  wire  fp64_MulRawFN__io_a_sign; // @[fp64_MulRecFN.scala 113:26]
  wire [12:0] fp64_MulRawFN__io_a_sExp; // @[fp64_MulRecFN.scala 113:26]
  wire [53:0] fp64_MulRawFN__io_a_sig; // @[fp64_MulRecFN.scala 113:26]
  wire  fp64_MulRawFN__io_b_isNaN; // @[fp64_MulRecFN.scala 113:26]
  wire  fp64_MulRawFN__io_b_isInf; // @[fp64_MulRecFN.scala 113:26]
  wire  fp64_MulRawFN__io_b_isZero; // @[fp64_MulRecFN.scala 113:26]
  wire  fp64_MulRawFN__io_b_sign; // @[fp64_MulRecFN.scala 113:26]
  wire [12:0] fp64_MulRawFN__io_b_sExp; // @[fp64_MulRecFN.scala 113:26]
  wire [53:0] fp64_MulRawFN__io_b_sig; // @[fp64_MulRecFN.scala 113:26]
  wire  fp64_MulRawFN__io_invalidExc; // @[fp64_MulRecFN.scala 113:26]
  wire  fp64_MulRawFN__io_rawOut_isNaN; // @[fp64_MulRecFN.scala 113:26]
  wire  fp64_MulRawFN__io_rawOut_isInf; // @[fp64_MulRecFN.scala 113:26]
  wire  fp64_MulRawFN__io_rawOut_isZero; // @[fp64_MulRecFN.scala 113:26]
  wire  fp64_MulRawFN__io_rawOut_sign; // @[fp64_MulRecFN.scala 113:26]
  wire [12:0] fp64_MulRawFN__io_rawOut_sExp; // @[fp64_MulRecFN.scala 113:26]
  wire [55:0] fp64_MulRawFN__io_rawOut_sig; // @[fp64_MulRecFN.scala 113:26]
  wire  roundRawFNToRecFN_io_invalidExc; // @[fp64_MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_isNaN; // @[fp64_MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_isInf; // @[fp64_MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_isZero; // @[fp64_MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_sign; // @[fp64_MulRecFN.scala 121:15]
  wire [12:0] roundRawFNToRecFN_io_in_sExp; // @[fp64_MulRecFN.scala 121:15]
  wire [55:0] roundRawFNToRecFN_io_in_sig; // @[fp64_MulRecFN.scala 121:15]
  wire [2:0] roundRawFNToRecFN_io_roundingMode; // @[fp64_MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_detectTininess; // @[fp64_MulRecFN.scala 121:15]
  wire [64:0] roundRawFNToRecFN_io_out; // @[fp64_MulRecFN.scala 121:15]
  wire [4:0] roundRawFNToRecFN_io_exceptionFlags; // @[fp64_MulRecFN.scala 121:15]
  wire [11:0] fp64_MulRawFN_io_a_exp = io_a[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  fp64_MulRawFN_io_a_isZero = fp64_MulRawFN_io_a_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  fp64_MulRawFN_io_a_isSpecial = fp64_MulRawFN_io_a_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  _fp64_MulRawFN_io_a_out_sig_T = ~fp64_MulRawFN_io_a_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [1:0] _fp64_MulRawFN_io_a_out_sig_T_1 = {1'h0,_fp64_MulRawFN_io_a_out_sig_T}; // @[rawFloatFromRecFN.scala 61:32]
  wire [11:0] fp64_MulRawFN_io_b_exp = io_b[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  fp64_MulRawFN_io_b_isZero = fp64_MulRawFN_io_b_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  fp64_MulRawFN_io_b_isSpecial = fp64_MulRawFN_io_b_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  _fp64_MulRawFN_io_b_out_sig_T = ~fp64_MulRawFN_io_b_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [1:0] _fp64_MulRawFN_io_b_out_sig_T_1 = {1'h0,_fp64_MulRawFN_io_b_out_sig_T}; // @[rawFloatFromRecFN.scala 61:32]
  fp64_MulRawFN fp64_MulRawFN_ ( // @[fp64_MulRecFN.scala 113:26]
    .io_a_isNaN(fp64_MulRawFN__io_a_isNaN),
    .io_a_isInf(fp64_MulRawFN__io_a_isInf),
    .io_a_isZero(fp64_MulRawFN__io_a_isZero),
    .io_a_sign(fp64_MulRawFN__io_a_sign),
    .io_a_sExp(fp64_MulRawFN__io_a_sExp),
    .io_a_sig(fp64_MulRawFN__io_a_sig),
    .io_b_isNaN(fp64_MulRawFN__io_b_isNaN),
    .io_b_isInf(fp64_MulRawFN__io_b_isInf),
    .io_b_isZero(fp64_MulRawFN__io_b_isZero),
    .io_b_sign(fp64_MulRawFN__io_b_sign),
    .io_b_sExp(fp64_MulRawFN__io_b_sExp),
    .io_b_sig(fp64_MulRawFN__io_b_sig),
    .io_invalidExc(fp64_MulRawFN__io_invalidExc),
    .io_rawOut_isNaN(fp64_MulRawFN__io_rawOut_isNaN),
    .io_rawOut_isInf(fp64_MulRawFN__io_rawOut_isInf),
    .io_rawOut_isZero(fp64_MulRawFN__io_rawOut_isZero),
    .io_rawOut_sign(fp64_MulRawFN__io_rawOut_sign),
    .io_rawOut_sExp(fp64_MulRawFN__io_rawOut_sExp),
    .io_rawOut_sig(fp64_MulRawFN__io_rawOut_sig)
  );
  fp64_RoundRawFNToRecFN_e11_s53 roundRawFNToRecFN ( // @[fp64_MulRecFN.scala 121:15]
    .io_invalidExc(roundRawFNToRecFN_io_invalidExc),
    .io_in_isNaN(roundRawFNToRecFN_io_in_isNaN),
    .io_in_isInf(roundRawFNToRecFN_io_in_isInf),
    .io_in_isZero(roundRawFNToRecFN_io_in_isZero),
    .io_in_sign(roundRawFNToRecFN_io_in_sign),
    .io_in_sExp(roundRawFNToRecFN_io_in_sExp),
    .io_in_sig(roundRawFNToRecFN_io_in_sig),
    .io_roundingMode(roundRawFNToRecFN_io_roundingMode),
    .io_detectTininess(roundRawFNToRecFN_io_detectTininess),
    .io_out(roundRawFNToRecFN_io_out),
    .io_exceptionFlags(roundRawFNToRecFN_io_exceptionFlags)
  );
  assign io_out = roundRawFNToRecFN_io_out; // @[fp64_MulRecFN.scala 127:23]
  assign io_exceptionFlags = roundRawFNToRecFN_io_exceptionFlags; // @[fp64_MulRecFN.scala 128:23]
  assign fp64_MulRawFN__io_a_isNaN = fp64_MulRawFN_io_a_isSpecial & fp64_MulRawFN_io_a_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  assign fp64_MulRawFN__io_a_isInf = fp64_MulRawFN_io_a_isSpecial & ~fp64_MulRawFN_io_a_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  assign fp64_MulRawFN__io_a_isZero = fp64_MulRawFN_io_a_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign fp64_MulRawFN__io_a_sign = io_a[64]; // @[rawFloatFromRecFN.scala 59:25]
  assign fp64_MulRawFN__io_a_sExp = {1'b0,$signed(fp64_MulRawFN_io_a_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  assign fp64_MulRawFN__io_a_sig = {_fp64_MulRawFN_io_a_out_sig_T_1,io_a[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  assign fp64_MulRawFN__io_b_isNaN = fp64_MulRawFN_io_b_isSpecial & fp64_MulRawFN_io_b_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  assign fp64_MulRawFN__io_b_isInf = fp64_MulRawFN_io_b_isSpecial & ~fp64_MulRawFN_io_b_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  assign fp64_MulRawFN__io_b_isZero = fp64_MulRawFN_io_b_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign fp64_MulRawFN__io_b_sign = io_b[64]; // @[rawFloatFromRecFN.scala 59:25]
  assign fp64_MulRawFN__io_b_sExp = {1'b0,$signed(fp64_MulRawFN_io_b_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  assign fp64_MulRawFN__io_b_sig = {_fp64_MulRawFN_io_b_out_sig_T_1,io_b[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  assign roundRawFNToRecFN_io_invalidExc = fp64_MulRawFN__io_invalidExc; // @[fp64_MulRecFN.scala 122:39]
  assign roundRawFNToRecFN_io_in_isNaN = fp64_MulRawFN__io_rawOut_isNaN; // @[fp64_MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_isInf = fp64_MulRawFN__io_rawOut_isInf; // @[fp64_MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_isZero = fp64_MulRawFN__io_rawOut_isZero; // @[fp64_MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_sign = fp64_MulRawFN__io_rawOut_sign; // @[fp64_MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_sExp = fp64_MulRawFN__io_rawOut_sExp; // @[fp64_MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_sig = fp64_MulRawFN__io_rawOut_sig; // @[fp64_MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_roundingMode = io_roundingMode; // @[fp64_MulRecFN.scala 125:39]
  assign roundRawFNToRecFN_io_detectTininess = io_detectTininess; // @[fp64_MulRecFN.scala 126:41]
endmodule
module fp64_MulAddRecFNToRaw_preMul_e11_s53(
  input  [64:0]  io_a,
  input  [64:0]  io_b,
  input  [64:0]  io_c,
  output [52:0]  io_mulAddA,
  output [52:0]  io_mulAddB,
  output [105:0] io_mulAddC,
  output         io_toPostMul_isSigNaNAny,
  output         io_toPostMul_isNaNAOrB,
  output         io_toPostMul_isInfA,
  output         io_toPostMul_isZeroA,
  output         io_toPostMul_isInfB,
  output         io_toPostMul_isZeroB,
  output         io_toPostMul_signProd,
  output         io_toPostMul_isNaNC,
  output         io_toPostMul_isInfC,
  output         io_toPostMul_isZeroC,
  output [12:0]  io_toPostMul_sExpSum,
  output         io_toPostMul_doSubMags,
  output         io_toPostMul_CIsDominant,
  output [5:0]   io_toPostMul_CDom_CAlignDist,
  output [54:0]  io_toPostMul_highAlignedSigC,
  output         io_toPostMul_bit0AlignedSigC
);
  wire [11:0] rawA_exp = io_a[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  rawA_isZero = rawA_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  rawA_isSpecial = rawA_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  rawA__isNaN = rawA_isSpecial & rawA_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  wire  rawA__sign = io_a[64]; // @[rawFloatFromRecFN.scala 59:25]
  wire [12:0] rawA__sExp = {1'b0,$signed(rawA_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _rawA_out_sig_T = ~rawA_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [53:0] rawA__sig = {1'h0,_rawA_out_sig_T,io_a[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  wire [11:0] rawB_exp = io_b[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  rawB_isZero = rawB_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  rawB_isSpecial = rawB_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  rawB__isNaN = rawB_isSpecial & rawB_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  wire  rawB__sign = io_b[64]; // @[rawFloatFromRecFN.scala 59:25]
  wire [12:0] rawB__sExp = {1'b0,$signed(rawB_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _rawB_out_sig_T = ~rawB_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [53:0] rawB__sig = {1'h0,_rawB_out_sig_T,io_b[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  wire [11:0] rawC_exp = io_c[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  rawC_isZero = rawC_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  rawC_isSpecial = rawC_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  rawC__isNaN = rawC_isSpecial & rawC_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  wire  rawC__sign = io_c[64]; // @[rawFloatFromRecFN.scala 59:25]
  wire [12:0] rawC__sExp = {1'b0,$signed(rawC_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _rawC_out_sig_T = ~rawC_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [53:0] rawC__sig = {1'h0,_rawC_out_sig_T,io_c[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  wire  signProd = rawA__sign ^ rawB__sign; // @[MulAddRecFN.scala 97:30]
  wire [13:0] _sExpAlignedProd_T = $signed(rawA__sExp) + $signed(rawB__sExp); // @[MulAddRecFN.scala 100:19]
  wire [13:0] sExpAlignedProd = $signed(_sExpAlignedProd_T) - 14'sh7c8; // @[MulAddRecFN.scala 100:32]
  wire  doSubMags = signProd ^ rawC__sign; // @[MulAddRecFN.scala 102:30]
  wire [13:0] _GEN_0 = {{1{rawC__sExp[12]}},rawC__sExp}; // @[MulAddRecFN.scala 106:42]
  wire [13:0] sNatCAlignDist = $signed(sExpAlignedProd) - $signed(_GEN_0); // @[MulAddRecFN.scala 106:42]
  wire [12:0] posNatCAlignDist = sNatCAlignDist[12:0]; // @[MulAddRecFN.scala 107:42]
  wire  isMinCAlign = rawA_isZero | rawB_isZero | $signed(sNatCAlignDist) < 14'sh0; // @[MulAddRecFN.scala 108:50]
  wire  CIsDominant = _rawC_out_sig_T & (isMinCAlign | posNatCAlignDist <= 13'h35); // @[MulAddRecFN.scala 110:23]
  wire [7:0] _CAlignDist_T_2 = posNatCAlignDist < 13'ha1 ? posNatCAlignDist[7:0] : 8'ha1; // @[MulAddRecFN.scala 114:16]
  wire [7:0] CAlignDist = isMinCAlign ? 8'h0 : _CAlignDist_T_2; // @[MulAddRecFN.scala 112:12]
  wire [53:0] _mainAlignedSigC_T = ~rawC__sig; // @[MulAddRecFN.scala 120:25]
  wire [53:0] _mainAlignedSigC_T_1 = doSubMags ? _mainAlignedSigC_T : rawC__sig; // @[MulAddRecFN.scala 120:13]
  wire [110:0] _mainAlignedSigC_T_3 = doSubMags ? 111'h7fffffffffffffffffffffffffff : 111'h0; // @[Bitwise.scala 77:12]
  wire [164:0] _mainAlignedSigC_T_5 = {_mainAlignedSigC_T_1,_mainAlignedSigC_T_3}; // @[MulAddRecFN.scala 120:94]
  wire [164:0] mainAlignedSigC = $signed(_mainAlignedSigC_T_5) >>> CAlignDist; // @[MulAddRecFN.scala 120:100]
  wire  reduced4CExtra_reducedVec_0 = |rawC__sig[3:0]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_1 = |rawC__sig[7:4]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_2 = |rawC__sig[11:8]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_3 = |rawC__sig[15:12]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_4 = |rawC__sig[19:16]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_5 = |rawC__sig[23:20]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_6 = |rawC__sig[27:24]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_7 = |rawC__sig[31:28]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_8 = |rawC__sig[35:32]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_9 = |rawC__sig[39:36]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_10 = |rawC__sig[43:40]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_11 = |rawC__sig[47:44]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_12 = |rawC__sig[51:48]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_13 = |rawC__sig[53:52]; // @[primitives.scala 123:57]
  wire [6:0] reduced4CExtra_lo = {reduced4CExtra_reducedVec_6,reduced4CExtra_reducedVec_5,reduced4CExtra_reducedVec_4,
    reduced4CExtra_reducedVec_3,reduced4CExtra_reducedVec_2,reduced4CExtra_reducedVec_1,reduced4CExtra_reducedVec_0}; // @[primitives.scala 124:20]
  wire [13:0] _reduced4CExtra_T_1 = {reduced4CExtra_reducedVec_13,reduced4CExtra_reducedVec_12,
    reduced4CExtra_reducedVec_11,reduced4CExtra_reducedVec_10,reduced4CExtra_reducedVec_9,reduced4CExtra_reducedVec_8,
    reduced4CExtra_reducedVec_7,reduced4CExtra_lo}; // @[primitives.scala 124:20]
  wire [64:0] reduced4CExtra_shift = 65'sh10000000000000000 >>> CAlignDist[7:2]; // @[primitives.scala 76:56]
  wire [7:0] _GEN_1 = {{4'd0}, reduced4CExtra_shift[31:28]}; // @[Bitwise.scala 108:31]
  wire [7:0] _reduced4CExtra_T_8 = _GEN_1 & 8'hf; // @[Bitwise.scala 108:31]
  wire [7:0] _reduced4CExtra_T_10 = {reduced4CExtra_shift[27:24], 4'h0}; // @[Bitwise.scala 108:70]
  wire [7:0] _reduced4CExtra_T_12 = _reduced4CExtra_T_10 & 8'hf0; // @[Bitwise.scala 108:80]
  wire [7:0] _reduced4CExtra_T_13 = _reduced4CExtra_T_8 | _reduced4CExtra_T_12; // @[Bitwise.scala 108:39]
  wire [7:0] _GEN_2 = {{2'd0}, _reduced4CExtra_T_13[7:2]}; // @[Bitwise.scala 108:31]
  wire [7:0] _reduced4CExtra_T_18 = _GEN_2 & 8'h33; // @[Bitwise.scala 108:31]
  wire [7:0] _reduced4CExtra_T_20 = {_reduced4CExtra_T_13[5:0], 2'h0}; // @[Bitwise.scala 108:70]
  wire [7:0] _reduced4CExtra_T_22 = _reduced4CExtra_T_20 & 8'hcc; // @[Bitwise.scala 108:80]
  wire [7:0] _reduced4CExtra_T_23 = _reduced4CExtra_T_18 | _reduced4CExtra_T_22; // @[Bitwise.scala 108:39]
  wire [7:0] _GEN_3 = {{1'd0}, _reduced4CExtra_T_23[7:1]}; // @[Bitwise.scala 108:31]
  wire [7:0] _reduced4CExtra_T_28 = _GEN_3 & 8'h55; // @[Bitwise.scala 108:31]
  wire [7:0] _reduced4CExtra_T_30 = {_reduced4CExtra_T_23[6:0], 1'h0}; // @[Bitwise.scala 108:70]
  wire [7:0] _reduced4CExtra_T_32 = _reduced4CExtra_T_30 & 8'haa; // @[Bitwise.scala 108:80]
  wire [7:0] _reduced4CExtra_T_33 = _reduced4CExtra_T_28 | _reduced4CExtra_T_32; // @[Bitwise.scala 108:39]
  wire [12:0] _reduced4CExtra_T_47 = {_reduced4CExtra_T_33,reduced4CExtra_shift[32],reduced4CExtra_shift[33],
    reduced4CExtra_shift[34],reduced4CExtra_shift[35],reduced4CExtra_shift[36]}; // @[Cat.scala 33:92]
  wire [13:0] _GEN_4 = {{1'd0}, _reduced4CExtra_T_47}; // @[MulAddRecFN.scala 122:68]
  wire [13:0] _reduced4CExtra_T_48 = _reduced4CExtra_T_1 & _GEN_4; // @[MulAddRecFN.scala 122:68]
  wire  reduced4CExtra = |_reduced4CExtra_T_48; // @[MulAddRecFN.scala 130:11]
  wire  _alignedSigC_T_4 = &mainAlignedSigC[2:0] & ~reduced4CExtra; // @[MulAddRecFN.scala 134:44]
  wire  _alignedSigC_T_7 = |mainAlignedSigC[2:0] | reduced4CExtra; // @[MulAddRecFN.scala 135:44]
  wire  _alignedSigC_T_8 = doSubMags ? _alignedSigC_T_4 : _alignedSigC_T_7; // @[MulAddRecFN.scala 133:16]
  wire [161:0] alignedSigC_hi = mainAlignedSigC[164:3]; // @[Cat.scala 33:92]
  wire [162:0] alignedSigC = {alignedSigC_hi,_alignedSigC_T_8}; // @[Cat.scala 33:92]
  wire  _io_toPostMul_isSigNaNAny_T_2 = rawA__isNaN & ~rawA__sig[51]; // @[common.scala 82:46]
  wire  _io_toPostMul_isSigNaNAny_T_5 = rawB__isNaN & ~rawB__sig[51]; // @[common.scala 82:46]
  wire  _io_toPostMul_isSigNaNAny_T_9 = rawC__isNaN & ~rawC__sig[51]; // @[common.scala 82:46]
  wire [13:0] _io_toPostMul_sExpSum_T_2 = $signed(sExpAlignedProd) - 14'sh35; // @[MulAddRecFN.scala 158:53]
  wire [13:0] _io_toPostMul_sExpSum_T_3 = CIsDominant ? $signed({{1{rawC__sExp[12]}},rawC__sExp}) : $signed(
    _io_toPostMul_sExpSum_T_2); // @[MulAddRecFN.scala 158:12]
  assign io_mulAddA = rawA__sig[52:0]; // @[MulAddRecFN.scala 141:16]
  assign io_mulAddB = rawB__sig[52:0]; // @[MulAddRecFN.scala 142:16]
  assign io_mulAddC = alignedSigC[106:1]; // @[MulAddRecFN.scala 143:30]
  assign io_toPostMul_isSigNaNAny = _io_toPostMul_isSigNaNAny_T_2 | _io_toPostMul_isSigNaNAny_T_5 |
    _io_toPostMul_isSigNaNAny_T_9; // @[MulAddRecFN.scala 146:58]
  assign io_toPostMul_isNaNAOrB = rawA__isNaN | rawB__isNaN; // @[MulAddRecFN.scala 148:42]
  assign io_toPostMul_isInfA = rawA_isSpecial & ~rawA_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  assign io_toPostMul_isZeroA = rawA_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign io_toPostMul_isInfB = rawB_isSpecial & ~rawB_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  assign io_toPostMul_isZeroB = rawB_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign io_toPostMul_signProd = rawA__sign ^ rawB__sign; // @[MulAddRecFN.scala 97:30]
  assign io_toPostMul_isNaNC = rawC_isSpecial & rawC_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  assign io_toPostMul_isInfC = rawC_isSpecial & ~rawC_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  assign io_toPostMul_isZeroC = rawC_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign io_toPostMul_sExpSum = _io_toPostMul_sExpSum_T_3[12:0]; // @[MulAddRecFN.scala 157:28]
  assign io_toPostMul_doSubMags = signProd ^ rawC__sign; // @[MulAddRecFN.scala 102:30]
  assign io_toPostMul_CIsDominant = _rawC_out_sig_T & (isMinCAlign | posNatCAlignDist <= 13'h35); // @[MulAddRecFN.scala 110:23]
  assign io_toPostMul_CDom_CAlignDist = CAlignDist[5:0]; // @[MulAddRecFN.scala 161:47]
  assign io_toPostMul_highAlignedSigC = alignedSigC[161:107]; // @[MulAddRecFN.scala 163:20]
  assign io_toPostMul_bit0AlignedSigC = alignedSigC[0]; // @[MulAddRecFN.scala 164:48]
endmodule
module fp64_MulAddRecFNToRaw_postMul_e11_s53(
  input          io_fromPreMul_isSigNaNAny,
  input          io_fromPreMul_isNaNAOrB,
  input          io_fromPreMul_isInfA,
  input          io_fromPreMul_isZeroA,
  input          io_fromPreMul_isInfB,
  input          io_fromPreMul_isZeroB,
  input          io_fromPreMul_signProd,
  input          io_fromPreMul_isNaNC,
  input          io_fromPreMul_isInfC,
  input          io_fromPreMul_isZeroC,
  input  [12:0]  io_fromPreMul_sExpSum,
  input          io_fromPreMul_doSubMags,
  input          io_fromPreMul_CIsDominant,
  input  [5:0]   io_fromPreMul_CDom_CAlignDist,
  input  [54:0]  io_fromPreMul_highAlignedSigC,
  input          io_fromPreMul_bit0AlignedSigC,
  input  [106:0] io_mulAddResult,
  input  [2:0]   io_roundingMode,
  output         io_invalidExc,
  output         io_rawOut_isNaN,
  output         io_rawOut_isInf,
  output         io_rawOut_isZero,
  output         io_rawOut_sign,
  output [12:0]  io_rawOut_sExp,
  output [55:0]  io_rawOut_sig
);
  wire  roundingMode_min = io_roundingMode == 3'h2; // @[MulAddRecFN.scala 186:45]
  wire  CDom_sign = io_fromPreMul_signProd ^ io_fromPreMul_doSubMags; // @[MulAddRecFN.scala 190:42]
  wire [54:0] _sigSum_T_2 = io_fromPreMul_highAlignedSigC + 55'h1; // @[MulAddRecFN.scala 193:47]
  wire [54:0] _sigSum_T_3 = io_mulAddResult[106] ? _sigSum_T_2 : io_fromPreMul_highAlignedSigC; // @[MulAddRecFN.scala 192:16]
  wire [161:0] sigSum = {_sigSum_T_3,io_mulAddResult[105:0],io_fromPreMul_bit0AlignedSigC}; // @[Cat.scala 33:92]
  wire [1:0] _CDom_sExp_T = {1'b0,$signed(io_fromPreMul_doSubMags)}; // @[MulAddRecFN.scala 203:69]
  wire [12:0] _GEN_0 = {{11{_CDom_sExp_T[1]}},_CDom_sExp_T}; // @[MulAddRecFN.scala 203:43]
  wire [12:0] CDom_sExp = $signed(io_fromPreMul_sExpSum) - $signed(_GEN_0); // @[MulAddRecFN.scala 203:43]
  wire [107:0] _CDom_absSigSum_T_1 = ~sigSum[161:54]; // @[MulAddRecFN.scala 206:13]
  wire [107:0] _CDom_absSigSum_T_5 = {1'h0,io_fromPreMul_highAlignedSigC[54:53],sigSum[159:55]}; // @[MulAddRecFN.scala 209:71]
  wire [107:0] CDom_absSigSum = io_fromPreMul_doSubMags ? _CDom_absSigSum_T_1 : _CDom_absSigSum_T_5; // @[MulAddRecFN.scala 205:12]
  wire [52:0] _CDom_absSigSumExtra_T_1 = ~sigSum[53:1]; // @[MulAddRecFN.scala 215:14]
  wire  _CDom_absSigSumExtra_T_2 = |_CDom_absSigSumExtra_T_1; // @[MulAddRecFN.scala 215:36]
  wire  _CDom_absSigSumExtra_T_4 = |sigSum[54:1]; // @[MulAddRecFN.scala 216:37]
  wire  CDom_absSigSumExtra = io_fromPreMul_doSubMags ? _CDom_absSigSumExtra_T_2 : _CDom_absSigSumExtra_T_4; // @[MulAddRecFN.scala 214:12]
  wire [170:0] _GEN_11 = {{63'd0}, CDom_absSigSum}; // @[MulAddRecFN.scala 219:24]
  wire [170:0] _CDom_mainSig_T = _GEN_11 << io_fromPreMul_CDom_CAlignDist; // @[MulAddRecFN.scala 219:24]
  wire [57:0] CDom_mainSig = _CDom_mainSig_T[107:50]; // @[MulAddRecFN.scala 219:56]
  wire [54:0] _CDom_reduced4SigExtra_T_1 = {CDom_absSigSum[52:0], 2'h0}; // @[MulAddRecFN.scala 222:53]
  wire  CDom_reduced4SigExtra_reducedVec_0 = |_CDom_reduced4SigExtra_T_1[3:0]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_1 = |_CDom_reduced4SigExtra_T_1[7:4]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_2 = |_CDom_reduced4SigExtra_T_1[11:8]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_3 = |_CDom_reduced4SigExtra_T_1[15:12]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_4 = |_CDom_reduced4SigExtra_T_1[19:16]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_5 = |_CDom_reduced4SigExtra_T_1[23:20]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_6 = |_CDom_reduced4SigExtra_T_1[27:24]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_7 = |_CDom_reduced4SigExtra_T_1[31:28]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_8 = |_CDom_reduced4SigExtra_T_1[35:32]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_9 = |_CDom_reduced4SigExtra_T_1[39:36]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_10 = |_CDom_reduced4SigExtra_T_1[43:40]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_11 = |_CDom_reduced4SigExtra_T_1[47:44]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_12 = |_CDom_reduced4SigExtra_T_1[51:48]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_13 = |_CDom_reduced4SigExtra_T_1[54:52]; // @[primitives.scala 123:57]
  wire [6:0] CDom_reduced4SigExtra_lo = {CDom_reduced4SigExtra_reducedVec_6,CDom_reduced4SigExtra_reducedVec_5,
    CDom_reduced4SigExtra_reducedVec_4,CDom_reduced4SigExtra_reducedVec_3,CDom_reduced4SigExtra_reducedVec_2,
    CDom_reduced4SigExtra_reducedVec_1,CDom_reduced4SigExtra_reducedVec_0}; // @[primitives.scala 124:20]
  wire [13:0] _CDom_reduced4SigExtra_T_2 = {CDom_reduced4SigExtra_reducedVec_13,CDom_reduced4SigExtra_reducedVec_12,
    CDom_reduced4SigExtra_reducedVec_11,CDom_reduced4SigExtra_reducedVec_10,CDom_reduced4SigExtra_reducedVec_9,
    CDom_reduced4SigExtra_reducedVec_8,CDom_reduced4SigExtra_reducedVec_7,CDom_reduced4SigExtra_lo}; // @[primitives.scala 124:20]
  wire [3:0] _CDom_reduced4SigExtra_T_4 = ~io_fromPreMul_CDom_CAlignDist[5:2]; // @[primitives.scala 52:21]
  wire [16:0] CDom_reduced4SigExtra_shift = 17'sh10000 >>> _CDom_reduced4SigExtra_T_4; // @[primitives.scala 76:56]
  wire [7:0] _GEN_1 = {{4'd0}, CDom_reduced4SigExtra_shift[8:5]}; // @[Bitwise.scala 108:31]
  wire [7:0] _CDom_reduced4SigExtra_T_10 = _GEN_1 & 8'hf; // @[Bitwise.scala 108:31]
  wire [7:0] _CDom_reduced4SigExtra_T_12 = {CDom_reduced4SigExtra_shift[4:1], 4'h0}; // @[Bitwise.scala 108:70]
  wire [7:0] _CDom_reduced4SigExtra_T_14 = _CDom_reduced4SigExtra_T_12 & 8'hf0; // @[Bitwise.scala 108:80]
  wire [7:0] _CDom_reduced4SigExtra_T_15 = _CDom_reduced4SigExtra_T_10 | _CDom_reduced4SigExtra_T_14; // @[Bitwise.scala 108:39]
  wire [7:0] _GEN_2 = {{2'd0}, _CDom_reduced4SigExtra_T_15[7:2]}; // @[Bitwise.scala 108:31]
  wire [7:0] _CDom_reduced4SigExtra_T_20 = _GEN_2 & 8'h33; // @[Bitwise.scala 108:31]
  wire [7:0] _CDom_reduced4SigExtra_T_22 = {_CDom_reduced4SigExtra_T_15[5:0], 2'h0}; // @[Bitwise.scala 108:70]
  wire [7:0] _CDom_reduced4SigExtra_T_24 = _CDom_reduced4SigExtra_T_22 & 8'hcc; // @[Bitwise.scala 108:80]
  wire [7:0] _CDom_reduced4SigExtra_T_25 = _CDom_reduced4SigExtra_T_20 | _CDom_reduced4SigExtra_T_24; // @[Bitwise.scala 108:39]
  wire [7:0] _GEN_3 = {{1'd0}, _CDom_reduced4SigExtra_T_25[7:1]}; // @[Bitwise.scala 108:31]
  wire [7:0] _CDom_reduced4SigExtra_T_30 = _GEN_3 & 8'h55; // @[Bitwise.scala 108:31]
  wire [7:0] _CDom_reduced4SigExtra_T_32 = {_CDom_reduced4SigExtra_T_25[6:0], 1'h0}; // @[Bitwise.scala 108:70]
  wire [7:0] _CDom_reduced4SigExtra_T_34 = _CDom_reduced4SigExtra_T_32 & 8'haa; // @[Bitwise.scala 108:80]
  wire [7:0] _CDom_reduced4SigExtra_T_35 = _CDom_reduced4SigExtra_T_30 | _CDom_reduced4SigExtra_T_34; // @[Bitwise.scala 108:39]
  wire [12:0] _CDom_reduced4SigExtra_T_49 = {_CDom_reduced4SigExtra_T_35,CDom_reduced4SigExtra_shift[9],
    CDom_reduced4SigExtra_shift[10],CDom_reduced4SigExtra_shift[11],CDom_reduced4SigExtra_shift[12],
    CDom_reduced4SigExtra_shift[13]}; // @[Cat.scala 33:92]
  wire [13:0] _GEN_4 = {{1'd0}, _CDom_reduced4SigExtra_T_49}; // @[MulAddRecFN.scala 222:72]
  wire [13:0] _CDom_reduced4SigExtra_T_50 = _CDom_reduced4SigExtra_T_2 & _GEN_4; // @[MulAddRecFN.scala 222:72]
  wire  CDom_reduced4SigExtra = |_CDom_reduced4SigExtra_T_50; // @[MulAddRecFN.scala 223:73]
  wire  _CDom_sig_T_4 = |CDom_mainSig[2:0] | CDom_reduced4SigExtra | CDom_absSigSumExtra; // @[MulAddRecFN.scala 226:61]
  wire [55:0] CDom_sig = {CDom_mainSig[57:3],_CDom_sig_T_4}; // @[Cat.scala 33:92]
  wire  notCDom_signSigSum = sigSum[109]; // @[MulAddRecFN.scala 232:36]
  wire [108:0] _notCDom_absSigSum_T_1 = ~sigSum[108:0]; // @[MulAddRecFN.scala 235:13]
  wire [108:0] _GEN_5 = {{108'd0}, io_fromPreMul_doSubMags}; // @[MulAddRecFN.scala 236:41]
  wire [108:0] _notCDom_absSigSum_T_4 = sigSum[108:0] + _GEN_5; // @[MulAddRecFN.scala 236:41]
  wire [108:0] notCDom_absSigSum = notCDom_signSigSum ? _notCDom_absSigSum_T_1 : _notCDom_absSigSum_T_4; // @[MulAddRecFN.scala 234:12]
  wire  notCDom_reduced2AbsSigSum_reducedVec_0 = |notCDom_absSigSum[1:0]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_1 = |notCDom_absSigSum[3:2]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_2 = |notCDom_absSigSum[5:4]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_3 = |notCDom_absSigSum[7:6]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_4 = |notCDom_absSigSum[9:8]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_5 = |notCDom_absSigSum[11:10]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_6 = |notCDom_absSigSum[13:12]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_7 = |notCDom_absSigSum[15:14]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_8 = |notCDom_absSigSum[17:16]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_9 = |notCDom_absSigSum[19:18]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_10 = |notCDom_absSigSum[21:20]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_11 = |notCDom_absSigSum[23:22]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_12 = |notCDom_absSigSum[25:24]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_13 = |notCDom_absSigSum[27:26]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_14 = |notCDom_absSigSum[29:28]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_15 = |notCDom_absSigSum[31:30]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_16 = |notCDom_absSigSum[33:32]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_17 = |notCDom_absSigSum[35:34]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_18 = |notCDom_absSigSum[37:36]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_19 = |notCDom_absSigSum[39:38]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_20 = |notCDom_absSigSum[41:40]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_21 = |notCDom_absSigSum[43:42]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_22 = |notCDom_absSigSum[45:44]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_23 = |notCDom_absSigSum[47:46]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_24 = |notCDom_absSigSum[49:48]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_25 = |notCDom_absSigSum[51:50]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_26 = |notCDom_absSigSum[53:52]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_27 = |notCDom_absSigSum[55:54]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_28 = |notCDom_absSigSum[57:56]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_29 = |notCDom_absSigSum[59:58]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_30 = |notCDom_absSigSum[61:60]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_31 = |notCDom_absSigSum[63:62]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_32 = |notCDom_absSigSum[65:64]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_33 = |notCDom_absSigSum[67:66]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_34 = |notCDom_absSigSum[69:68]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_35 = |notCDom_absSigSum[71:70]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_36 = |notCDom_absSigSum[73:72]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_37 = |notCDom_absSigSum[75:74]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_38 = |notCDom_absSigSum[77:76]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_39 = |notCDom_absSigSum[79:78]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_40 = |notCDom_absSigSum[81:80]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_41 = |notCDom_absSigSum[83:82]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_42 = |notCDom_absSigSum[85:84]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_43 = |notCDom_absSigSum[87:86]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_44 = |notCDom_absSigSum[89:88]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_45 = |notCDom_absSigSum[91:90]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_46 = |notCDom_absSigSum[93:92]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_47 = |notCDom_absSigSum[95:94]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_48 = |notCDom_absSigSum[97:96]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_49 = |notCDom_absSigSum[99:98]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_50 = |notCDom_absSigSum[101:100]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_51 = |notCDom_absSigSum[103:102]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_52 = |notCDom_absSigSum[105:104]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_53 = |notCDom_absSigSum[107:106]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_54 = |notCDom_absSigSum[108]; // @[primitives.scala 106:57]
  wire [5:0] notCDom_reduced2AbsSigSum_lo_lo_lo = {notCDom_reduced2AbsSigSum_reducedVec_5,
    notCDom_reduced2AbsSigSum_reducedVec_4,notCDom_reduced2AbsSigSum_reducedVec_3,notCDom_reduced2AbsSigSum_reducedVec_2
    ,notCDom_reduced2AbsSigSum_reducedVec_1,notCDom_reduced2AbsSigSum_reducedVec_0}; // @[primitives.scala 107:20]
  wire [12:0] notCDom_reduced2AbsSigSum_lo_lo = {notCDom_reduced2AbsSigSum_reducedVec_12,
    notCDom_reduced2AbsSigSum_reducedVec_11,notCDom_reduced2AbsSigSum_reducedVec_10,
    notCDom_reduced2AbsSigSum_reducedVec_9,notCDom_reduced2AbsSigSum_reducedVec_8,notCDom_reduced2AbsSigSum_reducedVec_7
    ,notCDom_reduced2AbsSigSum_reducedVec_6,notCDom_reduced2AbsSigSum_lo_lo_lo}; // @[primitives.scala 107:20]
  wire [6:0] notCDom_reduced2AbsSigSum_lo_hi_lo = {notCDom_reduced2AbsSigSum_reducedVec_19,
    notCDom_reduced2AbsSigSum_reducedVec_18,notCDom_reduced2AbsSigSum_reducedVec_17,
    notCDom_reduced2AbsSigSum_reducedVec_16,notCDom_reduced2AbsSigSum_reducedVec_15,
    notCDom_reduced2AbsSigSum_reducedVec_14,notCDom_reduced2AbsSigSum_reducedVec_13}; // @[primitives.scala 107:20]
  wire [26:0] notCDom_reduced2AbsSigSum_lo = {notCDom_reduced2AbsSigSum_reducedVec_26,
    notCDom_reduced2AbsSigSum_reducedVec_25,notCDom_reduced2AbsSigSum_reducedVec_24,
    notCDom_reduced2AbsSigSum_reducedVec_23,notCDom_reduced2AbsSigSum_reducedVec_22,
    notCDom_reduced2AbsSigSum_reducedVec_21,notCDom_reduced2AbsSigSum_reducedVec_20,notCDom_reduced2AbsSigSum_lo_hi_lo,
    notCDom_reduced2AbsSigSum_lo_lo}; // @[primitives.scala 107:20]
  wire [6:0] notCDom_reduced2AbsSigSum_hi_lo_lo = {notCDom_reduced2AbsSigSum_reducedVec_33,
    notCDom_reduced2AbsSigSum_reducedVec_32,notCDom_reduced2AbsSigSum_reducedVec_31,
    notCDom_reduced2AbsSigSum_reducedVec_30,notCDom_reduced2AbsSigSum_reducedVec_29,
    notCDom_reduced2AbsSigSum_reducedVec_28,notCDom_reduced2AbsSigSum_reducedVec_27}; // @[primitives.scala 107:20]
  wire [13:0] notCDom_reduced2AbsSigSum_hi_lo = {notCDom_reduced2AbsSigSum_reducedVec_40,
    notCDom_reduced2AbsSigSum_reducedVec_39,notCDom_reduced2AbsSigSum_reducedVec_38,
    notCDom_reduced2AbsSigSum_reducedVec_37,notCDom_reduced2AbsSigSum_reducedVec_36,
    notCDom_reduced2AbsSigSum_reducedVec_35,notCDom_reduced2AbsSigSum_reducedVec_34,notCDom_reduced2AbsSigSum_hi_lo_lo}; // @[primitives.scala 107:20]
  wire [6:0] notCDom_reduced2AbsSigSum_hi_hi_lo = {notCDom_reduced2AbsSigSum_reducedVec_47,
    notCDom_reduced2AbsSigSum_reducedVec_46,notCDom_reduced2AbsSigSum_reducedVec_45,
    notCDom_reduced2AbsSigSum_reducedVec_44,notCDom_reduced2AbsSigSum_reducedVec_43,
    notCDom_reduced2AbsSigSum_reducedVec_42,notCDom_reduced2AbsSigSum_reducedVec_41}; // @[primitives.scala 107:20]
  wire [54:0] notCDom_reduced2AbsSigSum = {notCDom_reduced2AbsSigSum_reducedVec_54,
    notCDom_reduced2AbsSigSum_reducedVec_53,notCDom_reduced2AbsSigSum_reducedVec_52,
    notCDom_reduced2AbsSigSum_reducedVec_51,notCDom_reduced2AbsSigSum_reducedVec_50,
    notCDom_reduced2AbsSigSum_reducedVec_49,notCDom_reduced2AbsSigSum_reducedVec_48,notCDom_reduced2AbsSigSum_hi_hi_lo,
    notCDom_reduced2AbsSigSum_hi_lo,notCDom_reduced2AbsSigSum_lo}; // @[primitives.scala 107:20]
  wire [5:0] _notCDom_normDistReduced2_T_55 = notCDom_reduced2AbsSigSum[1] ? 6'h35 : 6'h36; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_56 = notCDom_reduced2AbsSigSum[2] ? 6'h34 : _notCDom_normDistReduced2_T_55; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_57 = notCDom_reduced2AbsSigSum[3] ? 6'h33 : _notCDom_normDistReduced2_T_56; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_58 = notCDom_reduced2AbsSigSum[4] ? 6'h32 : _notCDom_normDistReduced2_T_57; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_59 = notCDom_reduced2AbsSigSum[5] ? 6'h31 : _notCDom_normDistReduced2_T_58; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_60 = notCDom_reduced2AbsSigSum[6] ? 6'h30 : _notCDom_normDistReduced2_T_59; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_61 = notCDom_reduced2AbsSigSum[7] ? 6'h2f : _notCDom_normDistReduced2_T_60; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_62 = notCDom_reduced2AbsSigSum[8] ? 6'h2e : _notCDom_normDistReduced2_T_61; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_63 = notCDom_reduced2AbsSigSum[9] ? 6'h2d : _notCDom_normDistReduced2_T_62; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_64 = notCDom_reduced2AbsSigSum[10] ? 6'h2c : _notCDom_normDistReduced2_T_63; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_65 = notCDom_reduced2AbsSigSum[11] ? 6'h2b : _notCDom_normDistReduced2_T_64; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_66 = notCDom_reduced2AbsSigSum[12] ? 6'h2a : _notCDom_normDistReduced2_T_65; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_67 = notCDom_reduced2AbsSigSum[13] ? 6'h29 : _notCDom_normDistReduced2_T_66; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_68 = notCDom_reduced2AbsSigSum[14] ? 6'h28 : _notCDom_normDistReduced2_T_67; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_69 = notCDom_reduced2AbsSigSum[15] ? 6'h27 : _notCDom_normDistReduced2_T_68; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_70 = notCDom_reduced2AbsSigSum[16] ? 6'h26 : _notCDom_normDistReduced2_T_69; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_71 = notCDom_reduced2AbsSigSum[17] ? 6'h25 : _notCDom_normDistReduced2_T_70; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_72 = notCDom_reduced2AbsSigSum[18] ? 6'h24 : _notCDom_normDistReduced2_T_71; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_73 = notCDom_reduced2AbsSigSum[19] ? 6'h23 : _notCDom_normDistReduced2_T_72; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_74 = notCDom_reduced2AbsSigSum[20] ? 6'h22 : _notCDom_normDistReduced2_T_73; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_75 = notCDom_reduced2AbsSigSum[21] ? 6'h21 : _notCDom_normDistReduced2_T_74; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_76 = notCDom_reduced2AbsSigSum[22] ? 6'h20 : _notCDom_normDistReduced2_T_75; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_77 = notCDom_reduced2AbsSigSum[23] ? 6'h1f : _notCDom_normDistReduced2_T_76; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_78 = notCDom_reduced2AbsSigSum[24] ? 6'h1e : _notCDom_normDistReduced2_T_77; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_79 = notCDom_reduced2AbsSigSum[25] ? 6'h1d : _notCDom_normDistReduced2_T_78; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_80 = notCDom_reduced2AbsSigSum[26] ? 6'h1c : _notCDom_normDistReduced2_T_79; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_81 = notCDom_reduced2AbsSigSum[27] ? 6'h1b : _notCDom_normDistReduced2_T_80; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_82 = notCDom_reduced2AbsSigSum[28] ? 6'h1a : _notCDom_normDistReduced2_T_81; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_83 = notCDom_reduced2AbsSigSum[29] ? 6'h19 : _notCDom_normDistReduced2_T_82; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_84 = notCDom_reduced2AbsSigSum[30] ? 6'h18 : _notCDom_normDistReduced2_T_83; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_85 = notCDom_reduced2AbsSigSum[31] ? 6'h17 : _notCDom_normDistReduced2_T_84; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_86 = notCDom_reduced2AbsSigSum[32] ? 6'h16 : _notCDom_normDistReduced2_T_85; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_87 = notCDom_reduced2AbsSigSum[33] ? 6'h15 : _notCDom_normDistReduced2_T_86; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_88 = notCDom_reduced2AbsSigSum[34] ? 6'h14 : _notCDom_normDistReduced2_T_87; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_89 = notCDom_reduced2AbsSigSum[35] ? 6'h13 : _notCDom_normDistReduced2_T_88; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_90 = notCDom_reduced2AbsSigSum[36] ? 6'h12 : _notCDom_normDistReduced2_T_89; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_91 = notCDom_reduced2AbsSigSum[37] ? 6'h11 : _notCDom_normDistReduced2_T_90; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_92 = notCDom_reduced2AbsSigSum[38] ? 6'h10 : _notCDom_normDistReduced2_T_91; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_93 = notCDom_reduced2AbsSigSum[39] ? 6'hf : _notCDom_normDistReduced2_T_92; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_94 = notCDom_reduced2AbsSigSum[40] ? 6'he : _notCDom_normDistReduced2_T_93; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_95 = notCDom_reduced2AbsSigSum[41] ? 6'hd : _notCDom_normDistReduced2_T_94; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_96 = notCDom_reduced2AbsSigSum[42] ? 6'hc : _notCDom_normDistReduced2_T_95; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_97 = notCDom_reduced2AbsSigSum[43] ? 6'hb : _notCDom_normDistReduced2_T_96; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_98 = notCDom_reduced2AbsSigSum[44] ? 6'ha : _notCDom_normDistReduced2_T_97; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_99 = notCDom_reduced2AbsSigSum[45] ? 6'h9 : _notCDom_normDistReduced2_T_98; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_100 = notCDom_reduced2AbsSigSum[46] ? 6'h8 : _notCDom_normDistReduced2_T_99; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_101 = notCDom_reduced2AbsSigSum[47] ? 6'h7 : _notCDom_normDistReduced2_T_100; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_102 = notCDom_reduced2AbsSigSum[48] ? 6'h6 : _notCDom_normDistReduced2_T_101; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_103 = notCDom_reduced2AbsSigSum[49] ? 6'h5 : _notCDom_normDistReduced2_T_102; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_104 = notCDom_reduced2AbsSigSum[50] ? 6'h4 : _notCDom_normDistReduced2_T_103; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_105 = notCDom_reduced2AbsSigSum[51] ? 6'h3 : _notCDom_normDistReduced2_T_104; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_106 = notCDom_reduced2AbsSigSum[52] ? 6'h2 : _notCDom_normDistReduced2_T_105; // @[Mux.scala 47:70]
  wire [5:0] _notCDom_normDistReduced2_T_107 = notCDom_reduced2AbsSigSum[53] ? 6'h1 : _notCDom_normDistReduced2_T_106; // @[Mux.scala 47:70]
  wire [5:0] notCDom_normDistReduced2 = notCDom_reduced2AbsSigSum[54] ? 6'h0 : _notCDom_normDistReduced2_T_107; // @[Mux.scala 47:70]
  wire [6:0] notCDom_nearNormDist = {notCDom_normDistReduced2, 1'h0}; // @[MulAddRecFN.scala 240:56]
  wire [7:0] _notCDom_sExp_T = {1'b0,$signed(notCDom_nearNormDist)}; // @[MulAddRecFN.scala 241:76]
  wire [12:0] _GEN_6 = {{5{_notCDom_sExp_T[7]}},_notCDom_sExp_T}; // @[MulAddRecFN.scala 241:46]
  wire [12:0] notCDom_sExp = $signed(io_fromPreMul_sExpSum) - $signed(_GEN_6); // @[MulAddRecFN.scala 241:46]
  wire [235:0] _GEN_12 = {{127'd0}, notCDom_absSigSum}; // @[MulAddRecFN.scala 243:27]
  wire [235:0] _notCDom_mainSig_T = _GEN_12 << notCDom_nearNormDist; // @[MulAddRecFN.scala 243:27]
  wire [57:0] notCDom_mainSig = _notCDom_mainSig_T[109:52]; // @[MulAddRecFN.scala 243:50]
  wire  notCDom_reduced4SigExtra_reducedVec_0 = |notCDom_reduced2AbsSigSum[1:0]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_1 = |notCDom_reduced2AbsSigSum[3:2]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_2 = |notCDom_reduced2AbsSigSum[5:4]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_3 = |notCDom_reduced2AbsSigSum[7:6]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_4 = |notCDom_reduced2AbsSigSum[9:8]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_5 = |notCDom_reduced2AbsSigSum[11:10]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_6 = |notCDom_reduced2AbsSigSum[13:12]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_7 = |notCDom_reduced2AbsSigSum[15:14]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_8 = |notCDom_reduced2AbsSigSum[17:16]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_9 = |notCDom_reduced2AbsSigSum[19:18]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_10 = |notCDom_reduced2AbsSigSum[21:20]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_11 = |notCDom_reduced2AbsSigSum[23:22]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_12 = |notCDom_reduced2AbsSigSum[25:24]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_13 = |notCDom_reduced2AbsSigSum[26]; // @[primitives.scala 106:57]
  wire [6:0] notCDom_reduced4SigExtra_lo = {notCDom_reduced4SigExtra_reducedVec_6,notCDom_reduced4SigExtra_reducedVec_5,
    notCDom_reduced4SigExtra_reducedVec_4,notCDom_reduced4SigExtra_reducedVec_3,notCDom_reduced4SigExtra_reducedVec_2,
    notCDom_reduced4SigExtra_reducedVec_1,notCDom_reduced4SigExtra_reducedVec_0}; // @[primitives.scala 107:20]
  wire [13:0] _notCDom_reduced4SigExtra_T_2 = {notCDom_reduced4SigExtra_reducedVec_13,
    notCDom_reduced4SigExtra_reducedVec_12,notCDom_reduced4SigExtra_reducedVec_11,notCDom_reduced4SigExtra_reducedVec_10
    ,notCDom_reduced4SigExtra_reducedVec_9,notCDom_reduced4SigExtra_reducedVec_8,notCDom_reduced4SigExtra_reducedVec_7,
    notCDom_reduced4SigExtra_lo}; // @[primitives.scala 107:20]
  wire [4:0] _notCDom_reduced4SigExtra_T_4 = ~notCDom_normDistReduced2[5:1]; // @[primitives.scala 52:21]
  wire [32:0] notCDom_reduced4SigExtra_shift = 33'sh100000000 >>> _notCDom_reduced4SigExtra_T_4; // @[primitives.scala 76:56]
  wire [7:0] _GEN_7 = {{4'd0}, notCDom_reduced4SigExtra_shift[8:5]}; // @[Bitwise.scala 108:31]
  wire [7:0] _notCDom_reduced4SigExtra_T_10 = _GEN_7 & 8'hf; // @[Bitwise.scala 108:31]
  wire [7:0] _notCDom_reduced4SigExtra_T_12 = {notCDom_reduced4SigExtra_shift[4:1], 4'h0}; // @[Bitwise.scala 108:70]
  wire [7:0] _notCDom_reduced4SigExtra_T_14 = _notCDom_reduced4SigExtra_T_12 & 8'hf0; // @[Bitwise.scala 108:80]
  wire [7:0] _notCDom_reduced4SigExtra_T_15 = _notCDom_reduced4SigExtra_T_10 | _notCDom_reduced4SigExtra_T_14; // @[Bitwise.scala 108:39]
  wire [7:0] _GEN_8 = {{2'd0}, _notCDom_reduced4SigExtra_T_15[7:2]}; // @[Bitwise.scala 108:31]
  wire [7:0] _notCDom_reduced4SigExtra_T_20 = _GEN_8 & 8'h33; // @[Bitwise.scala 108:31]
  wire [7:0] _notCDom_reduced4SigExtra_T_22 = {_notCDom_reduced4SigExtra_T_15[5:0], 2'h0}; // @[Bitwise.scala 108:70]
  wire [7:0] _notCDom_reduced4SigExtra_T_24 = _notCDom_reduced4SigExtra_T_22 & 8'hcc; // @[Bitwise.scala 108:80]
  wire [7:0] _notCDom_reduced4SigExtra_T_25 = _notCDom_reduced4SigExtra_T_20 | _notCDom_reduced4SigExtra_T_24; // @[Bitwise.scala 108:39]
  wire [7:0] _GEN_9 = {{1'd0}, _notCDom_reduced4SigExtra_T_25[7:1]}; // @[Bitwise.scala 108:31]
  wire [7:0] _notCDom_reduced4SigExtra_T_30 = _GEN_9 & 8'h55; // @[Bitwise.scala 108:31]
  wire [7:0] _notCDom_reduced4SigExtra_T_32 = {_notCDom_reduced4SigExtra_T_25[6:0], 1'h0}; // @[Bitwise.scala 108:70]
  wire [7:0] _notCDom_reduced4SigExtra_T_34 = _notCDom_reduced4SigExtra_T_32 & 8'haa; // @[Bitwise.scala 108:80]
  wire [7:0] _notCDom_reduced4SigExtra_T_35 = _notCDom_reduced4SigExtra_T_30 | _notCDom_reduced4SigExtra_T_34; // @[Bitwise.scala 108:39]
  wire [12:0] _notCDom_reduced4SigExtra_T_49 = {_notCDom_reduced4SigExtra_T_35,notCDom_reduced4SigExtra_shift[9],
    notCDom_reduced4SigExtra_shift[10],notCDom_reduced4SigExtra_shift[11],notCDom_reduced4SigExtra_shift[12],
    notCDom_reduced4SigExtra_shift[13]}; // @[Cat.scala 33:92]
  wire [13:0] _GEN_10 = {{1'd0}, _notCDom_reduced4SigExtra_T_49}; // @[MulAddRecFN.scala 247:78]
  wire [13:0] _notCDom_reduced4SigExtra_T_50 = _notCDom_reduced4SigExtra_T_2 & _GEN_10; // @[MulAddRecFN.scala 247:78]
  wire  notCDom_reduced4SigExtra = |_notCDom_reduced4SigExtra_T_50; // @[MulAddRecFN.scala 249:11]
  wire  _notCDom_sig_T_3 = |notCDom_mainSig[2:0] | notCDom_reduced4SigExtra; // @[MulAddRecFN.scala 252:39]
  wire [55:0] notCDom_sig = {notCDom_mainSig[57:3],_notCDom_sig_T_3}; // @[Cat.scala 33:92]
  wire  notCDom_completeCancellation = notCDom_sig[55:54] == 2'h0; // @[MulAddRecFN.scala 255:50]
  wire  _notCDom_sign_T = io_fromPreMul_signProd ^ notCDom_signSigSum; // @[MulAddRecFN.scala 259:36]
  wire  notCDom_sign = notCDom_completeCancellation ? roundingMode_min : _notCDom_sign_T; // @[MulAddRecFN.scala 257:12]
  wire  notNaN_isInfProd = io_fromPreMul_isInfA | io_fromPreMul_isInfB; // @[MulAddRecFN.scala 264:49]
  wire  notNaN_isInfOut = notNaN_isInfProd | io_fromPreMul_isInfC; // @[MulAddRecFN.scala 265:44]
  wire  notNaN_addZeros = (io_fromPreMul_isZeroA | io_fromPreMul_isZeroB) & io_fromPreMul_isZeroC; // @[MulAddRecFN.scala 267:58]
  wire  _io_invalidExc_T = io_fromPreMul_isInfA & io_fromPreMul_isZeroB; // @[MulAddRecFN.scala 272:31]
  wire  _io_invalidExc_T_1 = io_fromPreMul_isSigNaNAny | _io_invalidExc_T; // @[MulAddRecFN.scala 271:35]
  wire  _io_invalidExc_T_2 = io_fromPreMul_isZeroA & io_fromPreMul_isInfB; // @[MulAddRecFN.scala 273:32]
  wire  _io_invalidExc_T_3 = _io_invalidExc_T_1 | _io_invalidExc_T_2; // @[MulAddRecFN.scala 272:57]
  wire  _io_invalidExc_T_6 = ~io_fromPreMul_isNaNAOrB & notNaN_isInfProd; // @[MulAddRecFN.scala 274:36]
  wire  _io_invalidExc_T_7 = _io_invalidExc_T_6 & io_fromPreMul_isInfC; // @[MulAddRecFN.scala 275:61]
  wire  _io_invalidExc_T_8 = _io_invalidExc_T_7 & io_fromPreMul_doSubMags; // @[MulAddRecFN.scala 276:35]
  wire  _io_rawOut_isZero_T_1 = ~io_fromPreMul_CIsDominant & notCDom_completeCancellation; // @[MulAddRecFN.scala 283:42]
  wire  _io_rawOut_sign_T_1 = io_fromPreMul_isInfC & CDom_sign; // @[MulAddRecFN.scala 286:31]
  wire  _io_rawOut_sign_T_2 = notNaN_isInfProd & io_fromPreMul_signProd | _io_rawOut_sign_T_1; // @[MulAddRecFN.scala 285:54]
  wire  _io_rawOut_sign_T_5 = notNaN_addZeros & ~roundingMode_min & io_fromPreMul_signProd; // @[MulAddRecFN.scala 287:48]
  wire  _io_rawOut_sign_T_6 = _io_rawOut_sign_T_5 & CDom_sign; // @[MulAddRecFN.scala 288:36]
  wire  _io_rawOut_sign_T_7 = _io_rawOut_sign_T_2 | _io_rawOut_sign_T_6; // @[MulAddRecFN.scala 286:43]
  wire  _io_rawOut_sign_T_9 = io_fromPreMul_signProd | CDom_sign; // @[MulAddRecFN.scala 290:37]
  wire  _io_rawOut_sign_T_10 = notNaN_addZeros & roundingMode_min & _io_rawOut_sign_T_9; // @[MulAddRecFN.scala 289:46]
  wire  _io_rawOut_sign_T_11 = _io_rawOut_sign_T_7 | _io_rawOut_sign_T_10; // @[MulAddRecFN.scala 288:48]
  wire  _io_rawOut_sign_T_15 = io_fromPreMul_CIsDominant ? CDom_sign : notCDom_sign; // @[MulAddRecFN.scala 292:17]
  wire  _io_rawOut_sign_T_16 = ~notNaN_isInfOut & ~notNaN_addZeros & _io_rawOut_sign_T_15; // @[MulAddRecFN.scala 291:49]
  assign io_invalidExc = _io_invalidExc_T_3 | _io_invalidExc_T_8; // @[MulAddRecFN.scala 273:57]
  assign io_rawOut_isNaN = io_fromPreMul_isNaNAOrB | io_fromPreMul_isNaNC; // @[MulAddRecFN.scala 278:48]
  assign io_rawOut_isInf = notNaN_isInfProd | io_fromPreMul_isInfC; // @[MulAddRecFN.scala 265:44]
  assign io_rawOut_isZero = notNaN_addZeros | _io_rawOut_isZero_T_1; // @[MulAddRecFN.scala 282:25]
  assign io_rawOut_sign = _io_rawOut_sign_T_11 | _io_rawOut_sign_T_16; // @[MulAddRecFN.scala 290:50]
  assign io_rawOut_sExp = io_fromPreMul_CIsDominant ? $signed(CDom_sExp) : $signed(notCDom_sExp); // @[MulAddRecFN.scala 293:26]
  assign io_rawOut_sig = io_fromPreMul_CIsDominant ? CDom_sig : notCDom_sig; // @[MulAddRecFN.scala 294:25]
endmodule
module fp64_MulAddRecFN_e11_s53(
  input  [64:0] io_a,
  input  [64:0] io_b,
  input  [64:0] io_c,
  input  [2:0]  io_roundingMode,
  input         io_detectTininess,
  output [64:0] io_out,
  output [4:0]  io_exceptionFlags
);
  wire [64:0] mulAddRecFNToRaw_preMul_io_a; // @[MulAddRecFN.scala 317:15]
  wire [64:0] mulAddRecFNToRaw_preMul_io_b; // @[MulAddRecFN.scala 317:15]
  wire [64:0] mulAddRecFNToRaw_preMul_io_c; // @[MulAddRecFN.scala 317:15]
  wire [52:0] mulAddRecFNToRaw_preMul_io_mulAddA; // @[MulAddRecFN.scala 317:15]
  wire [52:0] mulAddRecFNToRaw_preMul_io_mulAddB; // @[MulAddRecFN.scala 317:15]
  wire [105:0] mulAddRecFNToRaw_preMul_io_mulAddC; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isSigNaNAny; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isNaNAOrB; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isInfA; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isZeroA; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isInfB; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isZeroB; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_signProd; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isNaNC; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isInfC; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isZeroC; // @[MulAddRecFN.scala 317:15]
  wire [12:0] mulAddRecFNToRaw_preMul_io_toPostMul_sExpSum; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_doSubMags; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_CIsDominant; // @[MulAddRecFN.scala 317:15]
  wire [5:0] mulAddRecFNToRaw_preMul_io_toPostMul_CDom_CAlignDist; // @[MulAddRecFN.scala 317:15]
  wire [54:0] mulAddRecFNToRaw_preMul_io_toPostMul_highAlignedSigC; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_bit0AlignedSigC; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isSigNaNAny; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isNaNAOrB; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isInfA; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroA; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isInfB; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroB; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_signProd; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isNaNC; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isInfC; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroC; // @[MulAddRecFN.scala 319:15]
  wire [12:0] mulAddRecFNToRaw_postMul_io_fromPreMul_sExpSum; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_doSubMags; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_CIsDominant; // @[MulAddRecFN.scala 319:15]
  wire [5:0] mulAddRecFNToRaw_postMul_io_fromPreMul_CDom_CAlignDist; // @[MulAddRecFN.scala 319:15]
  wire [54:0] mulAddRecFNToRaw_postMul_io_fromPreMul_highAlignedSigC; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_bit0AlignedSigC; // @[MulAddRecFN.scala 319:15]
  wire [106:0] mulAddRecFNToRaw_postMul_io_mulAddResult; // @[MulAddRecFN.scala 319:15]
  wire [2:0] mulAddRecFNToRaw_postMul_io_roundingMode; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_invalidExc; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_rawOut_isNaN; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_rawOut_isInf; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_rawOut_isZero; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_rawOut_sign; // @[MulAddRecFN.scala 319:15]
  wire [12:0] mulAddRecFNToRaw_postMul_io_rawOut_sExp; // @[MulAddRecFN.scala 319:15]
  wire [55:0] mulAddRecFNToRaw_postMul_io_rawOut_sig; // @[MulAddRecFN.scala 319:15]
  wire  roundRawFNToRecFN_io_invalidExc; // @[MulAddRecFN.scala 339:15]
  wire  roundRawFNToRecFN_io_in_isNaN; // @[MulAddRecFN.scala 339:15]
  wire  roundRawFNToRecFN_io_in_isInf; // @[MulAddRecFN.scala 339:15]
  wire  roundRawFNToRecFN_io_in_isZero; // @[MulAddRecFN.scala 339:15]
  wire  roundRawFNToRecFN_io_in_sign; // @[MulAddRecFN.scala 339:15]
  wire [12:0] roundRawFNToRecFN_io_in_sExp; // @[MulAddRecFN.scala 339:15]
  wire [55:0] roundRawFNToRecFN_io_in_sig; // @[MulAddRecFN.scala 339:15]
  wire [2:0] roundRawFNToRecFN_io_roundingMode; // @[MulAddRecFN.scala 339:15]
  wire  roundRawFNToRecFN_io_detectTininess; // @[MulAddRecFN.scala 339:15]
  wire [64:0] roundRawFNToRecFN_io_out; // @[MulAddRecFN.scala 339:15]
  wire [4:0] roundRawFNToRecFN_io_exceptionFlags; // @[MulAddRecFN.scala 339:15]
  wire [105:0] _mulAddResult_T = mulAddRecFNToRaw_preMul_io_mulAddA * mulAddRecFNToRaw_preMul_io_mulAddB; // @[MulAddRecFN.scala 327:45]
  fp64_MulAddRecFNToRaw_preMul_e11_s53 mulAddRecFNToRaw_preMul ( // @[MulAddRecFN.scala 317:15]
    .io_a(mulAddRecFNToRaw_preMul_io_a),
    .io_b(mulAddRecFNToRaw_preMul_io_b),
    .io_c(mulAddRecFNToRaw_preMul_io_c),
    .io_mulAddA(mulAddRecFNToRaw_preMul_io_mulAddA),
    .io_mulAddB(mulAddRecFNToRaw_preMul_io_mulAddB),
    .io_mulAddC(mulAddRecFNToRaw_preMul_io_mulAddC),
    .io_toPostMul_isSigNaNAny(mulAddRecFNToRaw_preMul_io_toPostMul_isSigNaNAny),
    .io_toPostMul_isNaNAOrB(mulAddRecFNToRaw_preMul_io_toPostMul_isNaNAOrB),
    .io_toPostMul_isInfA(mulAddRecFNToRaw_preMul_io_toPostMul_isInfA),
    .io_toPostMul_isZeroA(mulAddRecFNToRaw_preMul_io_toPostMul_isZeroA),
    .io_toPostMul_isInfB(mulAddRecFNToRaw_preMul_io_toPostMul_isInfB),
    .io_toPostMul_isZeroB(mulAddRecFNToRaw_preMul_io_toPostMul_isZeroB),
    .io_toPostMul_signProd(mulAddRecFNToRaw_preMul_io_toPostMul_signProd),
    .io_toPostMul_isNaNC(mulAddRecFNToRaw_preMul_io_toPostMul_isNaNC),
    .io_toPostMul_isInfC(mulAddRecFNToRaw_preMul_io_toPostMul_isInfC),
    .io_toPostMul_isZeroC(mulAddRecFNToRaw_preMul_io_toPostMul_isZeroC),
    .io_toPostMul_sExpSum(mulAddRecFNToRaw_preMul_io_toPostMul_sExpSum),
    .io_toPostMul_doSubMags(mulAddRecFNToRaw_preMul_io_toPostMul_doSubMags),
    .io_toPostMul_CIsDominant(mulAddRecFNToRaw_preMul_io_toPostMul_CIsDominant),
    .io_toPostMul_CDom_CAlignDist(mulAddRecFNToRaw_preMul_io_toPostMul_CDom_CAlignDist),
    .io_toPostMul_highAlignedSigC(mulAddRecFNToRaw_preMul_io_toPostMul_highAlignedSigC),
    .io_toPostMul_bit0AlignedSigC(mulAddRecFNToRaw_preMul_io_toPostMul_bit0AlignedSigC)
  );
  fp64_MulAddRecFNToRaw_postMul_e11_s53 mulAddRecFNToRaw_postMul ( // @[MulAddRecFN.scala 319:15]
    .io_fromPreMul_isSigNaNAny(mulAddRecFNToRaw_postMul_io_fromPreMul_isSigNaNAny),
    .io_fromPreMul_isNaNAOrB(mulAddRecFNToRaw_postMul_io_fromPreMul_isNaNAOrB),
    .io_fromPreMul_isInfA(mulAddRecFNToRaw_postMul_io_fromPreMul_isInfA),
    .io_fromPreMul_isZeroA(mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroA),
    .io_fromPreMul_isInfB(mulAddRecFNToRaw_postMul_io_fromPreMul_isInfB),
    .io_fromPreMul_isZeroB(mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroB),
    .io_fromPreMul_signProd(mulAddRecFNToRaw_postMul_io_fromPreMul_signProd),
    .io_fromPreMul_isNaNC(mulAddRecFNToRaw_postMul_io_fromPreMul_isNaNC),
    .io_fromPreMul_isInfC(mulAddRecFNToRaw_postMul_io_fromPreMul_isInfC),
    .io_fromPreMul_isZeroC(mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroC),
    .io_fromPreMul_sExpSum(mulAddRecFNToRaw_postMul_io_fromPreMul_sExpSum),
    .io_fromPreMul_doSubMags(mulAddRecFNToRaw_postMul_io_fromPreMul_doSubMags),
    .io_fromPreMul_CIsDominant(mulAddRecFNToRaw_postMul_io_fromPreMul_CIsDominant),
    .io_fromPreMul_CDom_CAlignDist(mulAddRecFNToRaw_postMul_io_fromPreMul_CDom_CAlignDist),
    .io_fromPreMul_highAlignedSigC(mulAddRecFNToRaw_postMul_io_fromPreMul_highAlignedSigC),
    .io_fromPreMul_bit0AlignedSigC(mulAddRecFNToRaw_postMul_io_fromPreMul_bit0AlignedSigC),
    .io_mulAddResult(mulAddRecFNToRaw_postMul_io_mulAddResult),
    .io_roundingMode(mulAddRecFNToRaw_postMul_io_roundingMode),
    .io_invalidExc(mulAddRecFNToRaw_postMul_io_invalidExc),
    .io_rawOut_isNaN(mulAddRecFNToRaw_postMul_io_rawOut_isNaN),
    .io_rawOut_isInf(mulAddRecFNToRaw_postMul_io_rawOut_isInf),
    .io_rawOut_isZero(mulAddRecFNToRaw_postMul_io_rawOut_isZero),
    .io_rawOut_sign(mulAddRecFNToRaw_postMul_io_rawOut_sign),
    .io_rawOut_sExp(mulAddRecFNToRaw_postMul_io_rawOut_sExp),
    .io_rawOut_sig(mulAddRecFNToRaw_postMul_io_rawOut_sig)
  );
  fp64_RoundRawFNToRecFN_e11_s53 roundRawFNToRecFN ( // @[MulAddRecFN.scala 339:15]
    .io_invalidExc(roundRawFNToRecFN_io_invalidExc),
    .io_in_isNaN(roundRawFNToRecFN_io_in_isNaN),
    .io_in_isInf(roundRawFNToRecFN_io_in_isInf),
    .io_in_isZero(roundRawFNToRecFN_io_in_isZero),
    .io_in_sign(roundRawFNToRecFN_io_in_sign),
    .io_in_sExp(roundRawFNToRecFN_io_in_sExp),
    .io_in_sig(roundRawFNToRecFN_io_in_sig),
    .io_roundingMode(roundRawFNToRecFN_io_roundingMode),
    .io_detectTininess(roundRawFNToRecFN_io_detectTininess),
    .io_out(roundRawFNToRecFN_io_out),
    .io_exceptionFlags(roundRawFNToRecFN_io_exceptionFlags)
  );
  assign io_out = roundRawFNToRecFN_io_out; // @[MulAddRecFN.scala 345:23]
  assign io_exceptionFlags = roundRawFNToRecFN_io_exceptionFlags; // @[MulAddRecFN.scala 346:23]
  assign mulAddRecFNToRaw_preMul_io_a = io_a; // @[MulAddRecFN.scala 322:35]
  assign mulAddRecFNToRaw_preMul_io_b = io_b; // @[MulAddRecFN.scala 323:35]
  assign mulAddRecFNToRaw_preMul_io_c = io_c; // @[MulAddRecFN.scala 324:35]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isSigNaNAny = mulAddRecFNToRaw_preMul_io_toPostMul_isSigNaNAny; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isNaNAOrB = mulAddRecFNToRaw_preMul_io_toPostMul_isNaNAOrB; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isInfA = mulAddRecFNToRaw_preMul_io_toPostMul_isInfA; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroA = mulAddRecFNToRaw_preMul_io_toPostMul_isZeroA; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isInfB = mulAddRecFNToRaw_preMul_io_toPostMul_isInfB; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroB = mulAddRecFNToRaw_preMul_io_toPostMul_isZeroB; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_signProd = mulAddRecFNToRaw_preMul_io_toPostMul_signProd; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isNaNC = mulAddRecFNToRaw_preMul_io_toPostMul_isNaNC; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isInfC = mulAddRecFNToRaw_preMul_io_toPostMul_isInfC; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroC = mulAddRecFNToRaw_preMul_io_toPostMul_isZeroC; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_sExpSum = mulAddRecFNToRaw_preMul_io_toPostMul_sExpSum; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_doSubMags = mulAddRecFNToRaw_preMul_io_toPostMul_doSubMags; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_CIsDominant = mulAddRecFNToRaw_preMul_io_toPostMul_CIsDominant; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_CDom_CAlignDist = mulAddRecFNToRaw_preMul_io_toPostMul_CDom_CAlignDist; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_highAlignedSigC = mulAddRecFNToRaw_preMul_io_toPostMul_highAlignedSigC; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_bit0AlignedSigC = mulAddRecFNToRaw_preMul_io_toPostMul_bit0AlignedSigC; // @[MulAddRecFN.scala 331:44]
  assign mulAddRecFNToRaw_postMul_io_mulAddResult = _mulAddResult_T + mulAddRecFNToRaw_preMul_io_mulAddC; // @[MulAddRecFN.scala 328:50]
  assign mulAddRecFNToRaw_postMul_io_roundingMode = io_roundingMode; // @[MulAddRecFN.scala 334:46]
  assign roundRawFNToRecFN_io_invalidExc = mulAddRecFNToRaw_postMul_io_invalidExc; // @[MulAddRecFN.scala 340:39]
  assign roundRawFNToRecFN_io_in_isNaN = mulAddRecFNToRaw_postMul_io_rawOut_isNaN; // @[MulAddRecFN.scala 342:39]
  assign roundRawFNToRecFN_io_in_isInf = mulAddRecFNToRaw_postMul_io_rawOut_isInf; // @[MulAddRecFN.scala 342:39]
  assign roundRawFNToRecFN_io_in_isZero = mulAddRecFNToRaw_postMul_io_rawOut_isZero; // @[MulAddRecFN.scala 342:39]
  assign roundRawFNToRecFN_io_in_sign = mulAddRecFNToRaw_postMul_io_rawOut_sign; // @[MulAddRecFN.scala 342:39]
  assign roundRawFNToRecFN_io_in_sExp = mulAddRecFNToRaw_postMul_io_rawOut_sExp; // @[MulAddRecFN.scala 342:39]
  assign roundRawFNToRecFN_io_in_sig = mulAddRecFNToRaw_postMul_io_rawOut_sig; // @[MulAddRecFN.scala 342:39]
  assign roundRawFNToRecFN_io_roundingMode = io_roundingMode; // @[MulAddRecFN.scala 343:39]
  assign roundRawFNToRecFN_io_detectTininess = io_detectTininess; // @[MulAddRecFN.scala 344:41]
endmodule
module FP64MatrixMulBlock(
  input         clock,
  input         reset,
  input  [63:0] io_a_0_0,
  input  [63:0] io_a_0_1,
  input  [63:0] io_a_1_0,
  input  [63:0] io_a_1_1,
  input  [63:0] io_b_0_0,
  input  [63:0] io_b_0_1,
  input  [63:0] io_b_1_0,
  input  [63:0] io_b_1_1,
  input  [2:0]  io_roundingMode,
  input         io_detectTininess,
  output [63:0] io_c_0_0,
  output [63:0] io_c_0_1,
  output [63:0] io_c_1_0,
  output [63:0] io_c_1_1,
  output [4:0]  io_exceptionFlags_0_0,
  output [4:0]  io_exceptionFlags_0_1,
  output [4:0]  io_exceptionFlags_1_0,
  output [4:0]  io_exceptionFlags_1_1
);
  wire [64:0] secondProduct_io_a; // @[FP64MatrixMulBlock.scala 34:33]
  wire [64:0] secondProduct_io_b; // @[FP64MatrixMulBlock.scala 34:33]
  wire [2:0] secondProduct_io_roundingMode; // @[FP64MatrixMulBlock.scala 34:33]
  wire  secondProduct_io_detectTininess; // @[FP64MatrixMulBlock.scala 34:33]
  wire [64:0] secondProduct_io_out; // @[FP64MatrixMulBlock.scala 34:33]
  wire [4:0] secondProduct_io_exceptionFlags; // @[FP64MatrixMulBlock.scala 34:33]
  wire [64:0] dotFMA_io_a; // @[FP64MatrixMulBlock.scala 41:26]
  wire [64:0] dotFMA_io_b; // @[FP64MatrixMulBlock.scala 41:26]
  wire [64:0] dotFMA_io_c; // @[FP64MatrixMulBlock.scala 41:26]
  wire [2:0] dotFMA_io_roundingMode; // @[FP64MatrixMulBlock.scala 41:26]
  wire  dotFMA_io_detectTininess; // @[FP64MatrixMulBlock.scala 41:26]
  wire [64:0] dotFMA_io_out; // @[FP64MatrixMulBlock.scala 41:26]
  wire [4:0] dotFMA_io_exceptionFlags; // @[FP64MatrixMulBlock.scala 41:26]
  wire [64:0] secondProduct_1_io_a; // @[FP64MatrixMulBlock.scala 34:33]
  wire [64:0] secondProduct_1_io_b; // @[FP64MatrixMulBlock.scala 34:33]
  wire [2:0] secondProduct_1_io_roundingMode; // @[FP64MatrixMulBlock.scala 34:33]
  wire  secondProduct_1_io_detectTininess; // @[FP64MatrixMulBlock.scala 34:33]
  wire [64:0] secondProduct_1_io_out; // @[FP64MatrixMulBlock.scala 34:33]
  wire [4:0] secondProduct_1_io_exceptionFlags; // @[FP64MatrixMulBlock.scala 34:33]
  wire [64:0] dotFMA_1_io_a; // @[FP64MatrixMulBlock.scala 41:26]
  wire [64:0] dotFMA_1_io_b; // @[FP64MatrixMulBlock.scala 41:26]
  wire [64:0] dotFMA_1_io_c; // @[FP64MatrixMulBlock.scala 41:26]
  wire [2:0] dotFMA_1_io_roundingMode; // @[FP64MatrixMulBlock.scala 41:26]
  wire  dotFMA_1_io_detectTininess; // @[FP64MatrixMulBlock.scala 41:26]
  wire [64:0] dotFMA_1_io_out; // @[FP64MatrixMulBlock.scala 41:26]
  wire [4:0] dotFMA_1_io_exceptionFlags; // @[FP64MatrixMulBlock.scala 41:26]
  wire [64:0] secondProduct_2_io_a; // @[FP64MatrixMulBlock.scala 34:33]
  wire [64:0] secondProduct_2_io_b; // @[FP64MatrixMulBlock.scala 34:33]
  wire [2:0] secondProduct_2_io_roundingMode; // @[FP64MatrixMulBlock.scala 34:33]
  wire  secondProduct_2_io_detectTininess; // @[FP64MatrixMulBlock.scala 34:33]
  wire [64:0] secondProduct_2_io_out; // @[FP64MatrixMulBlock.scala 34:33]
  wire [4:0] secondProduct_2_io_exceptionFlags; // @[FP64MatrixMulBlock.scala 34:33]
  wire [64:0] dotFMA_2_io_a; // @[FP64MatrixMulBlock.scala 41:26]
  wire [64:0] dotFMA_2_io_b; // @[FP64MatrixMulBlock.scala 41:26]
  wire [64:0] dotFMA_2_io_c; // @[FP64MatrixMulBlock.scala 41:26]
  wire [2:0] dotFMA_2_io_roundingMode; // @[FP64MatrixMulBlock.scala 41:26]
  wire  dotFMA_2_io_detectTininess; // @[FP64MatrixMulBlock.scala 41:26]
  wire [64:0] dotFMA_2_io_out; // @[FP64MatrixMulBlock.scala 41:26]
  wire [4:0] dotFMA_2_io_exceptionFlags; // @[FP64MatrixMulBlock.scala 41:26]
  wire [64:0] secondProduct_3_io_a; // @[FP64MatrixMulBlock.scala 34:33]
  wire [64:0] secondProduct_3_io_b; // @[FP64MatrixMulBlock.scala 34:33]
  wire [2:0] secondProduct_3_io_roundingMode; // @[FP64MatrixMulBlock.scala 34:33]
  wire  secondProduct_3_io_detectTininess; // @[FP64MatrixMulBlock.scala 34:33]
  wire [64:0] secondProduct_3_io_out; // @[FP64MatrixMulBlock.scala 34:33]
  wire [4:0] secondProduct_3_io_exceptionFlags; // @[FP64MatrixMulBlock.scala 34:33]
  wire [64:0] dotFMA_3_io_a; // @[FP64MatrixMulBlock.scala 41:26]
  wire [64:0] dotFMA_3_io_b; // @[FP64MatrixMulBlock.scala 41:26]
  wire [64:0] dotFMA_3_io_c; // @[FP64MatrixMulBlock.scala 41:26]
  wire [2:0] dotFMA_3_io_roundingMode; // @[FP64MatrixMulBlock.scala 41:26]
  wire  dotFMA_3_io_detectTininess; // @[FP64MatrixMulBlock.scala 41:26]
  wire [64:0] dotFMA_3_io_out; // @[FP64MatrixMulBlock.scala 41:26]
  wire [4:0] dotFMA_3_io_exceptionFlags; // @[FP64MatrixMulBlock.scala 41:26]
  wire  aRec_0_0_rawIn_sign = io_a_0_0[63]; // @[rawFloatFromFN.scala 44:18]
  wire [10:0] aRec_0_0_rawIn_expIn = io_a_0_0[62:52]; // @[rawFloatFromFN.scala 45:19]
  wire [51:0] aRec_0_0_rawIn_fractIn = io_a_0_0[51:0]; // @[rawFloatFromFN.scala 46:21]
  wire  aRec_0_0_rawIn_isZeroExpIn = aRec_0_0_rawIn_expIn == 11'h0; // @[rawFloatFromFN.scala 48:30]
  wire  aRec_0_0_rawIn_isZeroFractIn = aRec_0_0_rawIn_fractIn == 52'h0; // @[rawFloatFromFN.scala 49:34]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_52 = aRec_0_0_rawIn_fractIn[1] ? 6'h32 : 6'h33; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_53 = aRec_0_0_rawIn_fractIn[2] ? 6'h31 : _aRec_0_0_rawIn_normDist_T_52; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_54 = aRec_0_0_rawIn_fractIn[3] ? 6'h30 : _aRec_0_0_rawIn_normDist_T_53; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_55 = aRec_0_0_rawIn_fractIn[4] ? 6'h2f : _aRec_0_0_rawIn_normDist_T_54; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_56 = aRec_0_0_rawIn_fractIn[5] ? 6'h2e : _aRec_0_0_rawIn_normDist_T_55; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_57 = aRec_0_0_rawIn_fractIn[6] ? 6'h2d : _aRec_0_0_rawIn_normDist_T_56; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_58 = aRec_0_0_rawIn_fractIn[7] ? 6'h2c : _aRec_0_0_rawIn_normDist_T_57; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_59 = aRec_0_0_rawIn_fractIn[8] ? 6'h2b : _aRec_0_0_rawIn_normDist_T_58; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_60 = aRec_0_0_rawIn_fractIn[9] ? 6'h2a : _aRec_0_0_rawIn_normDist_T_59; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_61 = aRec_0_0_rawIn_fractIn[10] ? 6'h29 : _aRec_0_0_rawIn_normDist_T_60; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_62 = aRec_0_0_rawIn_fractIn[11] ? 6'h28 : _aRec_0_0_rawIn_normDist_T_61; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_63 = aRec_0_0_rawIn_fractIn[12] ? 6'h27 : _aRec_0_0_rawIn_normDist_T_62; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_64 = aRec_0_0_rawIn_fractIn[13] ? 6'h26 : _aRec_0_0_rawIn_normDist_T_63; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_65 = aRec_0_0_rawIn_fractIn[14] ? 6'h25 : _aRec_0_0_rawIn_normDist_T_64; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_66 = aRec_0_0_rawIn_fractIn[15] ? 6'h24 : _aRec_0_0_rawIn_normDist_T_65; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_67 = aRec_0_0_rawIn_fractIn[16] ? 6'h23 : _aRec_0_0_rawIn_normDist_T_66; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_68 = aRec_0_0_rawIn_fractIn[17] ? 6'h22 : _aRec_0_0_rawIn_normDist_T_67; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_69 = aRec_0_0_rawIn_fractIn[18] ? 6'h21 : _aRec_0_0_rawIn_normDist_T_68; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_70 = aRec_0_0_rawIn_fractIn[19] ? 6'h20 : _aRec_0_0_rawIn_normDist_T_69; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_71 = aRec_0_0_rawIn_fractIn[20] ? 6'h1f : _aRec_0_0_rawIn_normDist_T_70; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_72 = aRec_0_0_rawIn_fractIn[21] ? 6'h1e : _aRec_0_0_rawIn_normDist_T_71; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_73 = aRec_0_0_rawIn_fractIn[22] ? 6'h1d : _aRec_0_0_rawIn_normDist_T_72; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_74 = aRec_0_0_rawIn_fractIn[23] ? 6'h1c : _aRec_0_0_rawIn_normDist_T_73; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_75 = aRec_0_0_rawIn_fractIn[24] ? 6'h1b : _aRec_0_0_rawIn_normDist_T_74; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_76 = aRec_0_0_rawIn_fractIn[25] ? 6'h1a : _aRec_0_0_rawIn_normDist_T_75; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_77 = aRec_0_0_rawIn_fractIn[26] ? 6'h19 : _aRec_0_0_rawIn_normDist_T_76; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_78 = aRec_0_0_rawIn_fractIn[27] ? 6'h18 : _aRec_0_0_rawIn_normDist_T_77; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_79 = aRec_0_0_rawIn_fractIn[28] ? 6'h17 : _aRec_0_0_rawIn_normDist_T_78; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_80 = aRec_0_0_rawIn_fractIn[29] ? 6'h16 : _aRec_0_0_rawIn_normDist_T_79; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_81 = aRec_0_0_rawIn_fractIn[30] ? 6'h15 : _aRec_0_0_rawIn_normDist_T_80; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_82 = aRec_0_0_rawIn_fractIn[31] ? 6'h14 : _aRec_0_0_rawIn_normDist_T_81; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_83 = aRec_0_0_rawIn_fractIn[32] ? 6'h13 : _aRec_0_0_rawIn_normDist_T_82; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_84 = aRec_0_0_rawIn_fractIn[33] ? 6'h12 : _aRec_0_0_rawIn_normDist_T_83; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_85 = aRec_0_0_rawIn_fractIn[34] ? 6'h11 : _aRec_0_0_rawIn_normDist_T_84; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_86 = aRec_0_0_rawIn_fractIn[35] ? 6'h10 : _aRec_0_0_rawIn_normDist_T_85; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_87 = aRec_0_0_rawIn_fractIn[36] ? 6'hf : _aRec_0_0_rawIn_normDist_T_86; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_88 = aRec_0_0_rawIn_fractIn[37] ? 6'he : _aRec_0_0_rawIn_normDist_T_87; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_89 = aRec_0_0_rawIn_fractIn[38] ? 6'hd : _aRec_0_0_rawIn_normDist_T_88; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_90 = aRec_0_0_rawIn_fractIn[39] ? 6'hc : _aRec_0_0_rawIn_normDist_T_89; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_91 = aRec_0_0_rawIn_fractIn[40] ? 6'hb : _aRec_0_0_rawIn_normDist_T_90; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_92 = aRec_0_0_rawIn_fractIn[41] ? 6'ha : _aRec_0_0_rawIn_normDist_T_91; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_93 = aRec_0_0_rawIn_fractIn[42] ? 6'h9 : _aRec_0_0_rawIn_normDist_T_92; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_94 = aRec_0_0_rawIn_fractIn[43] ? 6'h8 : _aRec_0_0_rawIn_normDist_T_93; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_95 = aRec_0_0_rawIn_fractIn[44] ? 6'h7 : _aRec_0_0_rawIn_normDist_T_94; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_96 = aRec_0_0_rawIn_fractIn[45] ? 6'h6 : _aRec_0_0_rawIn_normDist_T_95; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_97 = aRec_0_0_rawIn_fractIn[46] ? 6'h5 : _aRec_0_0_rawIn_normDist_T_96; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_98 = aRec_0_0_rawIn_fractIn[47] ? 6'h4 : _aRec_0_0_rawIn_normDist_T_97; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_99 = aRec_0_0_rawIn_fractIn[48] ? 6'h3 : _aRec_0_0_rawIn_normDist_T_98; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_100 = aRec_0_0_rawIn_fractIn[49] ? 6'h2 : _aRec_0_0_rawIn_normDist_T_99; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_0_rawIn_normDist_T_101 = aRec_0_0_rawIn_fractIn[50] ? 6'h1 : _aRec_0_0_rawIn_normDist_T_100; // @[Mux.scala 47:70]
  wire [5:0] aRec_0_0_rawIn_normDist = aRec_0_0_rawIn_fractIn[51] ? 6'h0 : _aRec_0_0_rawIn_normDist_T_101; // @[Mux.scala 47:70]
  wire [114:0] _GEN_32 = {{63'd0}, aRec_0_0_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [114:0] _aRec_0_0_rawIn_subnormFract_T = _GEN_32 << aRec_0_0_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [51:0] aRec_0_0_rawIn_subnormFract = {_aRec_0_0_rawIn_subnormFract_T[50:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [11:0] _GEN_0 = {{6'd0}, aRec_0_0_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _aRec_0_0_rawIn_adjustedExp_T = _GEN_0 ^ 12'hfff; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _aRec_0_0_rawIn_adjustedExp_T_1 = aRec_0_0_rawIn_isZeroExpIn ? _aRec_0_0_rawIn_adjustedExp_T : {{1'd0},
    aRec_0_0_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _aRec_0_0_rawIn_adjustedExp_T_2 = aRec_0_0_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [10:0] _GEN_1 = {{9'd0}, _aRec_0_0_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [10:0] _aRec_0_0_rawIn_adjustedExp_T_3 = 11'h400 | _GEN_1; // @[rawFloatFromFN.scala 58:9]
  wire [11:0] _GEN_2 = {{1'd0}, _aRec_0_0_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [11:0] aRec_0_0_rawIn_adjustedExp = _aRec_0_0_rawIn_adjustedExp_T_1 + _GEN_2; // @[rawFloatFromFN.scala 57:9]
  wire  aRec_0_0_rawIn_isZero = aRec_0_0_rawIn_isZeroExpIn & aRec_0_0_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  aRec_0_0_rawIn_isSpecial = aRec_0_0_rawIn_adjustedExp[11:10] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  aRec_0_0_rawIn__isNaN = aRec_0_0_rawIn_isSpecial & ~aRec_0_0_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [12:0] aRec_0_0_rawIn__sExp = {1'b0,$signed(aRec_0_0_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _aRec_0_0_rawIn_out_sig_T = ~aRec_0_0_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [51:0] _aRec_0_0_rawIn_out_sig_T_2 = aRec_0_0_rawIn_isZeroExpIn ? aRec_0_0_rawIn_subnormFract :
    aRec_0_0_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [53:0] aRec_0_0_rawIn__sig = {1'h0,_aRec_0_0_rawIn_out_sig_T,_aRec_0_0_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _aRec_0_0_T_1 = aRec_0_0_rawIn_isZero ? 3'h0 : aRec_0_0_rawIn__sExp[11:9]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_3 = {{2'd0}, aRec_0_0_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _aRec_0_0_T_3 = _aRec_0_0_T_1 | _GEN_3; // @[recFNFromFN.scala 48:76]
  wire [12:0] _aRec_0_0_T_6 = {aRec_0_0_rawIn_sign,_aRec_0_0_T_3,aRec_0_0_rawIn__sExp[8:0]}; // @[recFNFromFN.scala 49:45]
  wire  bRec_0_0_rawIn_sign = io_b_0_0[63]; // @[rawFloatFromFN.scala 44:18]
  wire [10:0] bRec_0_0_rawIn_expIn = io_b_0_0[62:52]; // @[rawFloatFromFN.scala 45:19]
  wire [51:0] bRec_0_0_rawIn_fractIn = io_b_0_0[51:0]; // @[rawFloatFromFN.scala 46:21]
  wire  bRec_0_0_rawIn_isZeroExpIn = bRec_0_0_rawIn_expIn == 11'h0; // @[rawFloatFromFN.scala 48:30]
  wire  bRec_0_0_rawIn_isZeroFractIn = bRec_0_0_rawIn_fractIn == 52'h0; // @[rawFloatFromFN.scala 49:34]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_52 = bRec_0_0_rawIn_fractIn[1] ? 6'h32 : 6'h33; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_53 = bRec_0_0_rawIn_fractIn[2] ? 6'h31 : _bRec_0_0_rawIn_normDist_T_52; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_54 = bRec_0_0_rawIn_fractIn[3] ? 6'h30 : _bRec_0_0_rawIn_normDist_T_53; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_55 = bRec_0_0_rawIn_fractIn[4] ? 6'h2f : _bRec_0_0_rawIn_normDist_T_54; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_56 = bRec_0_0_rawIn_fractIn[5] ? 6'h2e : _bRec_0_0_rawIn_normDist_T_55; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_57 = bRec_0_0_rawIn_fractIn[6] ? 6'h2d : _bRec_0_0_rawIn_normDist_T_56; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_58 = bRec_0_0_rawIn_fractIn[7] ? 6'h2c : _bRec_0_0_rawIn_normDist_T_57; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_59 = bRec_0_0_rawIn_fractIn[8] ? 6'h2b : _bRec_0_0_rawIn_normDist_T_58; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_60 = bRec_0_0_rawIn_fractIn[9] ? 6'h2a : _bRec_0_0_rawIn_normDist_T_59; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_61 = bRec_0_0_rawIn_fractIn[10] ? 6'h29 : _bRec_0_0_rawIn_normDist_T_60; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_62 = bRec_0_0_rawIn_fractIn[11] ? 6'h28 : _bRec_0_0_rawIn_normDist_T_61; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_63 = bRec_0_0_rawIn_fractIn[12] ? 6'h27 : _bRec_0_0_rawIn_normDist_T_62; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_64 = bRec_0_0_rawIn_fractIn[13] ? 6'h26 : _bRec_0_0_rawIn_normDist_T_63; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_65 = bRec_0_0_rawIn_fractIn[14] ? 6'h25 : _bRec_0_0_rawIn_normDist_T_64; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_66 = bRec_0_0_rawIn_fractIn[15] ? 6'h24 : _bRec_0_0_rawIn_normDist_T_65; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_67 = bRec_0_0_rawIn_fractIn[16] ? 6'h23 : _bRec_0_0_rawIn_normDist_T_66; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_68 = bRec_0_0_rawIn_fractIn[17] ? 6'h22 : _bRec_0_0_rawIn_normDist_T_67; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_69 = bRec_0_0_rawIn_fractIn[18] ? 6'h21 : _bRec_0_0_rawIn_normDist_T_68; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_70 = bRec_0_0_rawIn_fractIn[19] ? 6'h20 : _bRec_0_0_rawIn_normDist_T_69; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_71 = bRec_0_0_rawIn_fractIn[20] ? 6'h1f : _bRec_0_0_rawIn_normDist_T_70; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_72 = bRec_0_0_rawIn_fractIn[21] ? 6'h1e : _bRec_0_0_rawIn_normDist_T_71; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_73 = bRec_0_0_rawIn_fractIn[22] ? 6'h1d : _bRec_0_0_rawIn_normDist_T_72; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_74 = bRec_0_0_rawIn_fractIn[23] ? 6'h1c : _bRec_0_0_rawIn_normDist_T_73; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_75 = bRec_0_0_rawIn_fractIn[24] ? 6'h1b : _bRec_0_0_rawIn_normDist_T_74; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_76 = bRec_0_0_rawIn_fractIn[25] ? 6'h1a : _bRec_0_0_rawIn_normDist_T_75; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_77 = bRec_0_0_rawIn_fractIn[26] ? 6'h19 : _bRec_0_0_rawIn_normDist_T_76; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_78 = bRec_0_0_rawIn_fractIn[27] ? 6'h18 : _bRec_0_0_rawIn_normDist_T_77; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_79 = bRec_0_0_rawIn_fractIn[28] ? 6'h17 : _bRec_0_0_rawIn_normDist_T_78; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_80 = bRec_0_0_rawIn_fractIn[29] ? 6'h16 : _bRec_0_0_rawIn_normDist_T_79; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_81 = bRec_0_0_rawIn_fractIn[30] ? 6'h15 : _bRec_0_0_rawIn_normDist_T_80; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_82 = bRec_0_0_rawIn_fractIn[31] ? 6'h14 : _bRec_0_0_rawIn_normDist_T_81; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_83 = bRec_0_0_rawIn_fractIn[32] ? 6'h13 : _bRec_0_0_rawIn_normDist_T_82; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_84 = bRec_0_0_rawIn_fractIn[33] ? 6'h12 : _bRec_0_0_rawIn_normDist_T_83; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_85 = bRec_0_0_rawIn_fractIn[34] ? 6'h11 : _bRec_0_0_rawIn_normDist_T_84; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_86 = bRec_0_0_rawIn_fractIn[35] ? 6'h10 : _bRec_0_0_rawIn_normDist_T_85; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_87 = bRec_0_0_rawIn_fractIn[36] ? 6'hf : _bRec_0_0_rawIn_normDist_T_86; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_88 = bRec_0_0_rawIn_fractIn[37] ? 6'he : _bRec_0_0_rawIn_normDist_T_87; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_89 = bRec_0_0_rawIn_fractIn[38] ? 6'hd : _bRec_0_0_rawIn_normDist_T_88; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_90 = bRec_0_0_rawIn_fractIn[39] ? 6'hc : _bRec_0_0_rawIn_normDist_T_89; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_91 = bRec_0_0_rawIn_fractIn[40] ? 6'hb : _bRec_0_0_rawIn_normDist_T_90; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_92 = bRec_0_0_rawIn_fractIn[41] ? 6'ha : _bRec_0_0_rawIn_normDist_T_91; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_93 = bRec_0_0_rawIn_fractIn[42] ? 6'h9 : _bRec_0_0_rawIn_normDist_T_92; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_94 = bRec_0_0_rawIn_fractIn[43] ? 6'h8 : _bRec_0_0_rawIn_normDist_T_93; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_95 = bRec_0_0_rawIn_fractIn[44] ? 6'h7 : _bRec_0_0_rawIn_normDist_T_94; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_96 = bRec_0_0_rawIn_fractIn[45] ? 6'h6 : _bRec_0_0_rawIn_normDist_T_95; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_97 = bRec_0_0_rawIn_fractIn[46] ? 6'h5 : _bRec_0_0_rawIn_normDist_T_96; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_98 = bRec_0_0_rawIn_fractIn[47] ? 6'h4 : _bRec_0_0_rawIn_normDist_T_97; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_99 = bRec_0_0_rawIn_fractIn[48] ? 6'h3 : _bRec_0_0_rawIn_normDist_T_98; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_100 = bRec_0_0_rawIn_fractIn[49] ? 6'h2 : _bRec_0_0_rawIn_normDist_T_99; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_0_rawIn_normDist_T_101 = bRec_0_0_rawIn_fractIn[50] ? 6'h1 : _bRec_0_0_rawIn_normDist_T_100; // @[Mux.scala 47:70]
  wire [5:0] bRec_0_0_rawIn_normDist = bRec_0_0_rawIn_fractIn[51] ? 6'h0 : _bRec_0_0_rawIn_normDist_T_101; // @[Mux.scala 47:70]
  wire [114:0] _GEN_33 = {{63'd0}, bRec_0_0_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [114:0] _bRec_0_0_rawIn_subnormFract_T = _GEN_33 << bRec_0_0_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [51:0] bRec_0_0_rawIn_subnormFract = {_bRec_0_0_rawIn_subnormFract_T[50:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [11:0] _GEN_4 = {{6'd0}, bRec_0_0_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _bRec_0_0_rawIn_adjustedExp_T = _GEN_4 ^ 12'hfff; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _bRec_0_0_rawIn_adjustedExp_T_1 = bRec_0_0_rawIn_isZeroExpIn ? _bRec_0_0_rawIn_adjustedExp_T : {{1'd0},
    bRec_0_0_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _bRec_0_0_rawIn_adjustedExp_T_2 = bRec_0_0_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [10:0] _GEN_5 = {{9'd0}, _bRec_0_0_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [10:0] _bRec_0_0_rawIn_adjustedExp_T_3 = 11'h400 | _GEN_5; // @[rawFloatFromFN.scala 58:9]
  wire [11:0] _GEN_6 = {{1'd0}, _bRec_0_0_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [11:0] bRec_0_0_rawIn_adjustedExp = _bRec_0_0_rawIn_adjustedExp_T_1 + _GEN_6; // @[rawFloatFromFN.scala 57:9]
  wire  bRec_0_0_rawIn_isZero = bRec_0_0_rawIn_isZeroExpIn & bRec_0_0_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  bRec_0_0_rawIn_isSpecial = bRec_0_0_rawIn_adjustedExp[11:10] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  bRec_0_0_rawIn__isNaN = bRec_0_0_rawIn_isSpecial & ~bRec_0_0_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [12:0] bRec_0_0_rawIn__sExp = {1'b0,$signed(bRec_0_0_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _bRec_0_0_rawIn_out_sig_T = ~bRec_0_0_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [51:0] _bRec_0_0_rawIn_out_sig_T_2 = bRec_0_0_rawIn_isZeroExpIn ? bRec_0_0_rawIn_subnormFract :
    bRec_0_0_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [53:0] bRec_0_0_rawIn__sig = {1'h0,_bRec_0_0_rawIn_out_sig_T,_bRec_0_0_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _bRec_0_0_T_1 = bRec_0_0_rawIn_isZero ? 3'h0 : bRec_0_0_rawIn__sExp[11:9]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_7 = {{2'd0}, bRec_0_0_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _bRec_0_0_T_3 = _bRec_0_0_T_1 | _GEN_7; // @[recFNFromFN.scala 48:76]
  wire [12:0] _bRec_0_0_T_6 = {bRec_0_0_rawIn_sign,_bRec_0_0_T_3,bRec_0_0_rawIn__sExp[8:0]}; // @[recFNFromFN.scala 49:45]
  wire  aRec_0_1_rawIn_sign = io_a_0_1[63]; // @[rawFloatFromFN.scala 44:18]
  wire [10:0] aRec_0_1_rawIn_expIn = io_a_0_1[62:52]; // @[rawFloatFromFN.scala 45:19]
  wire [51:0] aRec_0_1_rawIn_fractIn = io_a_0_1[51:0]; // @[rawFloatFromFN.scala 46:21]
  wire  aRec_0_1_rawIn_isZeroExpIn = aRec_0_1_rawIn_expIn == 11'h0; // @[rawFloatFromFN.scala 48:30]
  wire  aRec_0_1_rawIn_isZeroFractIn = aRec_0_1_rawIn_fractIn == 52'h0; // @[rawFloatFromFN.scala 49:34]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_52 = aRec_0_1_rawIn_fractIn[1] ? 6'h32 : 6'h33; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_53 = aRec_0_1_rawIn_fractIn[2] ? 6'h31 : _aRec_0_1_rawIn_normDist_T_52; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_54 = aRec_0_1_rawIn_fractIn[3] ? 6'h30 : _aRec_0_1_rawIn_normDist_T_53; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_55 = aRec_0_1_rawIn_fractIn[4] ? 6'h2f : _aRec_0_1_rawIn_normDist_T_54; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_56 = aRec_0_1_rawIn_fractIn[5] ? 6'h2e : _aRec_0_1_rawIn_normDist_T_55; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_57 = aRec_0_1_rawIn_fractIn[6] ? 6'h2d : _aRec_0_1_rawIn_normDist_T_56; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_58 = aRec_0_1_rawIn_fractIn[7] ? 6'h2c : _aRec_0_1_rawIn_normDist_T_57; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_59 = aRec_0_1_rawIn_fractIn[8] ? 6'h2b : _aRec_0_1_rawIn_normDist_T_58; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_60 = aRec_0_1_rawIn_fractIn[9] ? 6'h2a : _aRec_0_1_rawIn_normDist_T_59; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_61 = aRec_0_1_rawIn_fractIn[10] ? 6'h29 : _aRec_0_1_rawIn_normDist_T_60; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_62 = aRec_0_1_rawIn_fractIn[11] ? 6'h28 : _aRec_0_1_rawIn_normDist_T_61; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_63 = aRec_0_1_rawIn_fractIn[12] ? 6'h27 : _aRec_0_1_rawIn_normDist_T_62; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_64 = aRec_0_1_rawIn_fractIn[13] ? 6'h26 : _aRec_0_1_rawIn_normDist_T_63; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_65 = aRec_0_1_rawIn_fractIn[14] ? 6'h25 : _aRec_0_1_rawIn_normDist_T_64; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_66 = aRec_0_1_rawIn_fractIn[15] ? 6'h24 : _aRec_0_1_rawIn_normDist_T_65; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_67 = aRec_0_1_rawIn_fractIn[16] ? 6'h23 : _aRec_0_1_rawIn_normDist_T_66; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_68 = aRec_0_1_rawIn_fractIn[17] ? 6'h22 : _aRec_0_1_rawIn_normDist_T_67; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_69 = aRec_0_1_rawIn_fractIn[18] ? 6'h21 : _aRec_0_1_rawIn_normDist_T_68; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_70 = aRec_0_1_rawIn_fractIn[19] ? 6'h20 : _aRec_0_1_rawIn_normDist_T_69; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_71 = aRec_0_1_rawIn_fractIn[20] ? 6'h1f : _aRec_0_1_rawIn_normDist_T_70; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_72 = aRec_0_1_rawIn_fractIn[21] ? 6'h1e : _aRec_0_1_rawIn_normDist_T_71; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_73 = aRec_0_1_rawIn_fractIn[22] ? 6'h1d : _aRec_0_1_rawIn_normDist_T_72; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_74 = aRec_0_1_rawIn_fractIn[23] ? 6'h1c : _aRec_0_1_rawIn_normDist_T_73; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_75 = aRec_0_1_rawIn_fractIn[24] ? 6'h1b : _aRec_0_1_rawIn_normDist_T_74; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_76 = aRec_0_1_rawIn_fractIn[25] ? 6'h1a : _aRec_0_1_rawIn_normDist_T_75; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_77 = aRec_0_1_rawIn_fractIn[26] ? 6'h19 : _aRec_0_1_rawIn_normDist_T_76; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_78 = aRec_0_1_rawIn_fractIn[27] ? 6'h18 : _aRec_0_1_rawIn_normDist_T_77; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_79 = aRec_0_1_rawIn_fractIn[28] ? 6'h17 : _aRec_0_1_rawIn_normDist_T_78; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_80 = aRec_0_1_rawIn_fractIn[29] ? 6'h16 : _aRec_0_1_rawIn_normDist_T_79; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_81 = aRec_0_1_rawIn_fractIn[30] ? 6'h15 : _aRec_0_1_rawIn_normDist_T_80; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_82 = aRec_0_1_rawIn_fractIn[31] ? 6'h14 : _aRec_0_1_rawIn_normDist_T_81; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_83 = aRec_0_1_rawIn_fractIn[32] ? 6'h13 : _aRec_0_1_rawIn_normDist_T_82; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_84 = aRec_0_1_rawIn_fractIn[33] ? 6'h12 : _aRec_0_1_rawIn_normDist_T_83; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_85 = aRec_0_1_rawIn_fractIn[34] ? 6'h11 : _aRec_0_1_rawIn_normDist_T_84; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_86 = aRec_0_1_rawIn_fractIn[35] ? 6'h10 : _aRec_0_1_rawIn_normDist_T_85; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_87 = aRec_0_1_rawIn_fractIn[36] ? 6'hf : _aRec_0_1_rawIn_normDist_T_86; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_88 = aRec_0_1_rawIn_fractIn[37] ? 6'he : _aRec_0_1_rawIn_normDist_T_87; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_89 = aRec_0_1_rawIn_fractIn[38] ? 6'hd : _aRec_0_1_rawIn_normDist_T_88; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_90 = aRec_0_1_rawIn_fractIn[39] ? 6'hc : _aRec_0_1_rawIn_normDist_T_89; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_91 = aRec_0_1_rawIn_fractIn[40] ? 6'hb : _aRec_0_1_rawIn_normDist_T_90; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_92 = aRec_0_1_rawIn_fractIn[41] ? 6'ha : _aRec_0_1_rawIn_normDist_T_91; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_93 = aRec_0_1_rawIn_fractIn[42] ? 6'h9 : _aRec_0_1_rawIn_normDist_T_92; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_94 = aRec_0_1_rawIn_fractIn[43] ? 6'h8 : _aRec_0_1_rawIn_normDist_T_93; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_95 = aRec_0_1_rawIn_fractIn[44] ? 6'h7 : _aRec_0_1_rawIn_normDist_T_94; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_96 = aRec_0_1_rawIn_fractIn[45] ? 6'h6 : _aRec_0_1_rawIn_normDist_T_95; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_97 = aRec_0_1_rawIn_fractIn[46] ? 6'h5 : _aRec_0_1_rawIn_normDist_T_96; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_98 = aRec_0_1_rawIn_fractIn[47] ? 6'h4 : _aRec_0_1_rawIn_normDist_T_97; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_99 = aRec_0_1_rawIn_fractIn[48] ? 6'h3 : _aRec_0_1_rawIn_normDist_T_98; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_100 = aRec_0_1_rawIn_fractIn[49] ? 6'h2 : _aRec_0_1_rawIn_normDist_T_99; // @[Mux.scala 47:70]
  wire [5:0] _aRec_0_1_rawIn_normDist_T_101 = aRec_0_1_rawIn_fractIn[50] ? 6'h1 : _aRec_0_1_rawIn_normDist_T_100; // @[Mux.scala 47:70]
  wire [5:0] aRec_0_1_rawIn_normDist = aRec_0_1_rawIn_fractIn[51] ? 6'h0 : _aRec_0_1_rawIn_normDist_T_101; // @[Mux.scala 47:70]
  wire [114:0] _GEN_34 = {{63'd0}, aRec_0_1_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [114:0] _aRec_0_1_rawIn_subnormFract_T = _GEN_34 << aRec_0_1_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [51:0] aRec_0_1_rawIn_subnormFract = {_aRec_0_1_rawIn_subnormFract_T[50:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [11:0] _GEN_8 = {{6'd0}, aRec_0_1_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _aRec_0_1_rawIn_adjustedExp_T = _GEN_8 ^ 12'hfff; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _aRec_0_1_rawIn_adjustedExp_T_1 = aRec_0_1_rawIn_isZeroExpIn ? _aRec_0_1_rawIn_adjustedExp_T : {{1'd0},
    aRec_0_1_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _aRec_0_1_rawIn_adjustedExp_T_2 = aRec_0_1_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [10:0] _GEN_9 = {{9'd0}, _aRec_0_1_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [10:0] _aRec_0_1_rawIn_adjustedExp_T_3 = 11'h400 | _GEN_9; // @[rawFloatFromFN.scala 58:9]
  wire [11:0] _GEN_10 = {{1'd0}, _aRec_0_1_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [11:0] aRec_0_1_rawIn_adjustedExp = _aRec_0_1_rawIn_adjustedExp_T_1 + _GEN_10; // @[rawFloatFromFN.scala 57:9]
  wire  aRec_0_1_rawIn_isZero = aRec_0_1_rawIn_isZeroExpIn & aRec_0_1_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  aRec_0_1_rawIn_isSpecial = aRec_0_1_rawIn_adjustedExp[11:10] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  aRec_0_1_rawIn__isNaN = aRec_0_1_rawIn_isSpecial & ~aRec_0_1_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [12:0] aRec_0_1_rawIn__sExp = {1'b0,$signed(aRec_0_1_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _aRec_0_1_rawIn_out_sig_T = ~aRec_0_1_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [51:0] _aRec_0_1_rawIn_out_sig_T_2 = aRec_0_1_rawIn_isZeroExpIn ? aRec_0_1_rawIn_subnormFract :
    aRec_0_1_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [53:0] aRec_0_1_rawIn__sig = {1'h0,_aRec_0_1_rawIn_out_sig_T,_aRec_0_1_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _aRec_0_1_T_1 = aRec_0_1_rawIn_isZero ? 3'h0 : aRec_0_1_rawIn__sExp[11:9]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_11 = {{2'd0}, aRec_0_1_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _aRec_0_1_T_3 = _aRec_0_1_T_1 | _GEN_11; // @[recFNFromFN.scala 48:76]
  wire [12:0] _aRec_0_1_T_6 = {aRec_0_1_rawIn_sign,_aRec_0_1_T_3,aRec_0_1_rawIn__sExp[8:0]}; // @[recFNFromFN.scala 49:45]
  wire  bRec_0_1_rawIn_sign = io_b_0_1[63]; // @[rawFloatFromFN.scala 44:18]
  wire [10:0] bRec_0_1_rawIn_expIn = io_b_0_1[62:52]; // @[rawFloatFromFN.scala 45:19]
  wire [51:0] bRec_0_1_rawIn_fractIn = io_b_0_1[51:0]; // @[rawFloatFromFN.scala 46:21]
  wire  bRec_0_1_rawIn_isZeroExpIn = bRec_0_1_rawIn_expIn == 11'h0; // @[rawFloatFromFN.scala 48:30]
  wire  bRec_0_1_rawIn_isZeroFractIn = bRec_0_1_rawIn_fractIn == 52'h0; // @[rawFloatFromFN.scala 49:34]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_52 = bRec_0_1_rawIn_fractIn[1] ? 6'h32 : 6'h33; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_53 = bRec_0_1_rawIn_fractIn[2] ? 6'h31 : _bRec_0_1_rawIn_normDist_T_52; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_54 = bRec_0_1_rawIn_fractIn[3] ? 6'h30 : _bRec_0_1_rawIn_normDist_T_53; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_55 = bRec_0_1_rawIn_fractIn[4] ? 6'h2f : _bRec_0_1_rawIn_normDist_T_54; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_56 = bRec_0_1_rawIn_fractIn[5] ? 6'h2e : _bRec_0_1_rawIn_normDist_T_55; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_57 = bRec_0_1_rawIn_fractIn[6] ? 6'h2d : _bRec_0_1_rawIn_normDist_T_56; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_58 = bRec_0_1_rawIn_fractIn[7] ? 6'h2c : _bRec_0_1_rawIn_normDist_T_57; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_59 = bRec_0_1_rawIn_fractIn[8] ? 6'h2b : _bRec_0_1_rawIn_normDist_T_58; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_60 = bRec_0_1_rawIn_fractIn[9] ? 6'h2a : _bRec_0_1_rawIn_normDist_T_59; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_61 = bRec_0_1_rawIn_fractIn[10] ? 6'h29 : _bRec_0_1_rawIn_normDist_T_60; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_62 = bRec_0_1_rawIn_fractIn[11] ? 6'h28 : _bRec_0_1_rawIn_normDist_T_61; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_63 = bRec_0_1_rawIn_fractIn[12] ? 6'h27 : _bRec_0_1_rawIn_normDist_T_62; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_64 = bRec_0_1_rawIn_fractIn[13] ? 6'h26 : _bRec_0_1_rawIn_normDist_T_63; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_65 = bRec_0_1_rawIn_fractIn[14] ? 6'h25 : _bRec_0_1_rawIn_normDist_T_64; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_66 = bRec_0_1_rawIn_fractIn[15] ? 6'h24 : _bRec_0_1_rawIn_normDist_T_65; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_67 = bRec_0_1_rawIn_fractIn[16] ? 6'h23 : _bRec_0_1_rawIn_normDist_T_66; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_68 = bRec_0_1_rawIn_fractIn[17] ? 6'h22 : _bRec_0_1_rawIn_normDist_T_67; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_69 = bRec_0_1_rawIn_fractIn[18] ? 6'h21 : _bRec_0_1_rawIn_normDist_T_68; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_70 = bRec_0_1_rawIn_fractIn[19] ? 6'h20 : _bRec_0_1_rawIn_normDist_T_69; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_71 = bRec_0_1_rawIn_fractIn[20] ? 6'h1f : _bRec_0_1_rawIn_normDist_T_70; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_72 = bRec_0_1_rawIn_fractIn[21] ? 6'h1e : _bRec_0_1_rawIn_normDist_T_71; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_73 = bRec_0_1_rawIn_fractIn[22] ? 6'h1d : _bRec_0_1_rawIn_normDist_T_72; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_74 = bRec_0_1_rawIn_fractIn[23] ? 6'h1c : _bRec_0_1_rawIn_normDist_T_73; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_75 = bRec_0_1_rawIn_fractIn[24] ? 6'h1b : _bRec_0_1_rawIn_normDist_T_74; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_76 = bRec_0_1_rawIn_fractIn[25] ? 6'h1a : _bRec_0_1_rawIn_normDist_T_75; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_77 = bRec_0_1_rawIn_fractIn[26] ? 6'h19 : _bRec_0_1_rawIn_normDist_T_76; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_78 = bRec_0_1_rawIn_fractIn[27] ? 6'h18 : _bRec_0_1_rawIn_normDist_T_77; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_79 = bRec_0_1_rawIn_fractIn[28] ? 6'h17 : _bRec_0_1_rawIn_normDist_T_78; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_80 = bRec_0_1_rawIn_fractIn[29] ? 6'h16 : _bRec_0_1_rawIn_normDist_T_79; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_81 = bRec_0_1_rawIn_fractIn[30] ? 6'h15 : _bRec_0_1_rawIn_normDist_T_80; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_82 = bRec_0_1_rawIn_fractIn[31] ? 6'h14 : _bRec_0_1_rawIn_normDist_T_81; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_83 = bRec_0_1_rawIn_fractIn[32] ? 6'h13 : _bRec_0_1_rawIn_normDist_T_82; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_84 = bRec_0_1_rawIn_fractIn[33] ? 6'h12 : _bRec_0_1_rawIn_normDist_T_83; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_85 = bRec_0_1_rawIn_fractIn[34] ? 6'h11 : _bRec_0_1_rawIn_normDist_T_84; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_86 = bRec_0_1_rawIn_fractIn[35] ? 6'h10 : _bRec_0_1_rawIn_normDist_T_85; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_87 = bRec_0_1_rawIn_fractIn[36] ? 6'hf : _bRec_0_1_rawIn_normDist_T_86; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_88 = bRec_0_1_rawIn_fractIn[37] ? 6'he : _bRec_0_1_rawIn_normDist_T_87; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_89 = bRec_0_1_rawIn_fractIn[38] ? 6'hd : _bRec_0_1_rawIn_normDist_T_88; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_90 = bRec_0_1_rawIn_fractIn[39] ? 6'hc : _bRec_0_1_rawIn_normDist_T_89; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_91 = bRec_0_1_rawIn_fractIn[40] ? 6'hb : _bRec_0_1_rawIn_normDist_T_90; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_92 = bRec_0_1_rawIn_fractIn[41] ? 6'ha : _bRec_0_1_rawIn_normDist_T_91; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_93 = bRec_0_1_rawIn_fractIn[42] ? 6'h9 : _bRec_0_1_rawIn_normDist_T_92; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_94 = bRec_0_1_rawIn_fractIn[43] ? 6'h8 : _bRec_0_1_rawIn_normDist_T_93; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_95 = bRec_0_1_rawIn_fractIn[44] ? 6'h7 : _bRec_0_1_rawIn_normDist_T_94; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_96 = bRec_0_1_rawIn_fractIn[45] ? 6'h6 : _bRec_0_1_rawIn_normDist_T_95; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_97 = bRec_0_1_rawIn_fractIn[46] ? 6'h5 : _bRec_0_1_rawIn_normDist_T_96; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_98 = bRec_0_1_rawIn_fractIn[47] ? 6'h4 : _bRec_0_1_rawIn_normDist_T_97; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_99 = bRec_0_1_rawIn_fractIn[48] ? 6'h3 : _bRec_0_1_rawIn_normDist_T_98; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_100 = bRec_0_1_rawIn_fractIn[49] ? 6'h2 : _bRec_0_1_rawIn_normDist_T_99; // @[Mux.scala 47:70]
  wire [5:0] _bRec_0_1_rawIn_normDist_T_101 = bRec_0_1_rawIn_fractIn[50] ? 6'h1 : _bRec_0_1_rawIn_normDist_T_100; // @[Mux.scala 47:70]
  wire [5:0] bRec_0_1_rawIn_normDist = bRec_0_1_rawIn_fractIn[51] ? 6'h0 : _bRec_0_1_rawIn_normDist_T_101; // @[Mux.scala 47:70]
  wire [114:0] _GEN_35 = {{63'd0}, bRec_0_1_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [114:0] _bRec_0_1_rawIn_subnormFract_T = _GEN_35 << bRec_0_1_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [51:0] bRec_0_1_rawIn_subnormFract = {_bRec_0_1_rawIn_subnormFract_T[50:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [11:0] _GEN_12 = {{6'd0}, bRec_0_1_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _bRec_0_1_rawIn_adjustedExp_T = _GEN_12 ^ 12'hfff; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _bRec_0_1_rawIn_adjustedExp_T_1 = bRec_0_1_rawIn_isZeroExpIn ? _bRec_0_1_rawIn_adjustedExp_T : {{1'd0},
    bRec_0_1_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _bRec_0_1_rawIn_adjustedExp_T_2 = bRec_0_1_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [10:0] _GEN_13 = {{9'd0}, _bRec_0_1_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [10:0] _bRec_0_1_rawIn_adjustedExp_T_3 = 11'h400 | _GEN_13; // @[rawFloatFromFN.scala 58:9]
  wire [11:0] _GEN_14 = {{1'd0}, _bRec_0_1_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [11:0] bRec_0_1_rawIn_adjustedExp = _bRec_0_1_rawIn_adjustedExp_T_1 + _GEN_14; // @[rawFloatFromFN.scala 57:9]
  wire  bRec_0_1_rawIn_isZero = bRec_0_1_rawIn_isZeroExpIn & bRec_0_1_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  bRec_0_1_rawIn_isSpecial = bRec_0_1_rawIn_adjustedExp[11:10] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  bRec_0_1_rawIn__isNaN = bRec_0_1_rawIn_isSpecial & ~bRec_0_1_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [12:0] bRec_0_1_rawIn__sExp = {1'b0,$signed(bRec_0_1_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _bRec_0_1_rawIn_out_sig_T = ~bRec_0_1_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [51:0] _bRec_0_1_rawIn_out_sig_T_2 = bRec_0_1_rawIn_isZeroExpIn ? bRec_0_1_rawIn_subnormFract :
    bRec_0_1_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [53:0] bRec_0_1_rawIn__sig = {1'h0,_bRec_0_1_rawIn_out_sig_T,_bRec_0_1_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _bRec_0_1_T_1 = bRec_0_1_rawIn_isZero ? 3'h0 : bRec_0_1_rawIn__sExp[11:9]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_15 = {{2'd0}, bRec_0_1_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _bRec_0_1_T_3 = _bRec_0_1_T_1 | _GEN_15; // @[recFNFromFN.scala 48:76]
  wire [12:0] _bRec_0_1_T_6 = {bRec_0_1_rawIn_sign,_bRec_0_1_T_3,bRec_0_1_rawIn__sExp[8:0]}; // @[recFNFromFN.scala 49:45]
  wire  aRec_1_0_rawIn_sign = io_a_1_0[63]; // @[rawFloatFromFN.scala 44:18]
  wire [10:0] aRec_1_0_rawIn_expIn = io_a_1_0[62:52]; // @[rawFloatFromFN.scala 45:19]
  wire [51:0] aRec_1_0_rawIn_fractIn = io_a_1_0[51:0]; // @[rawFloatFromFN.scala 46:21]
  wire  aRec_1_0_rawIn_isZeroExpIn = aRec_1_0_rawIn_expIn == 11'h0; // @[rawFloatFromFN.scala 48:30]
  wire  aRec_1_0_rawIn_isZeroFractIn = aRec_1_0_rawIn_fractIn == 52'h0; // @[rawFloatFromFN.scala 49:34]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_52 = aRec_1_0_rawIn_fractIn[1] ? 6'h32 : 6'h33; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_53 = aRec_1_0_rawIn_fractIn[2] ? 6'h31 : _aRec_1_0_rawIn_normDist_T_52; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_54 = aRec_1_0_rawIn_fractIn[3] ? 6'h30 : _aRec_1_0_rawIn_normDist_T_53; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_55 = aRec_1_0_rawIn_fractIn[4] ? 6'h2f : _aRec_1_0_rawIn_normDist_T_54; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_56 = aRec_1_0_rawIn_fractIn[5] ? 6'h2e : _aRec_1_0_rawIn_normDist_T_55; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_57 = aRec_1_0_rawIn_fractIn[6] ? 6'h2d : _aRec_1_0_rawIn_normDist_T_56; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_58 = aRec_1_0_rawIn_fractIn[7] ? 6'h2c : _aRec_1_0_rawIn_normDist_T_57; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_59 = aRec_1_0_rawIn_fractIn[8] ? 6'h2b : _aRec_1_0_rawIn_normDist_T_58; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_60 = aRec_1_0_rawIn_fractIn[9] ? 6'h2a : _aRec_1_0_rawIn_normDist_T_59; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_61 = aRec_1_0_rawIn_fractIn[10] ? 6'h29 : _aRec_1_0_rawIn_normDist_T_60; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_62 = aRec_1_0_rawIn_fractIn[11] ? 6'h28 : _aRec_1_0_rawIn_normDist_T_61; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_63 = aRec_1_0_rawIn_fractIn[12] ? 6'h27 : _aRec_1_0_rawIn_normDist_T_62; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_64 = aRec_1_0_rawIn_fractIn[13] ? 6'h26 : _aRec_1_0_rawIn_normDist_T_63; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_65 = aRec_1_0_rawIn_fractIn[14] ? 6'h25 : _aRec_1_0_rawIn_normDist_T_64; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_66 = aRec_1_0_rawIn_fractIn[15] ? 6'h24 : _aRec_1_0_rawIn_normDist_T_65; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_67 = aRec_1_0_rawIn_fractIn[16] ? 6'h23 : _aRec_1_0_rawIn_normDist_T_66; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_68 = aRec_1_0_rawIn_fractIn[17] ? 6'h22 : _aRec_1_0_rawIn_normDist_T_67; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_69 = aRec_1_0_rawIn_fractIn[18] ? 6'h21 : _aRec_1_0_rawIn_normDist_T_68; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_70 = aRec_1_0_rawIn_fractIn[19] ? 6'h20 : _aRec_1_0_rawIn_normDist_T_69; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_71 = aRec_1_0_rawIn_fractIn[20] ? 6'h1f : _aRec_1_0_rawIn_normDist_T_70; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_72 = aRec_1_0_rawIn_fractIn[21] ? 6'h1e : _aRec_1_0_rawIn_normDist_T_71; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_73 = aRec_1_0_rawIn_fractIn[22] ? 6'h1d : _aRec_1_0_rawIn_normDist_T_72; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_74 = aRec_1_0_rawIn_fractIn[23] ? 6'h1c : _aRec_1_0_rawIn_normDist_T_73; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_75 = aRec_1_0_rawIn_fractIn[24] ? 6'h1b : _aRec_1_0_rawIn_normDist_T_74; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_76 = aRec_1_0_rawIn_fractIn[25] ? 6'h1a : _aRec_1_0_rawIn_normDist_T_75; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_77 = aRec_1_0_rawIn_fractIn[26] ? 6'h19 : _aRec_1_0_rawIn_normDist_T_76; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_78 = aRec_1_0_rawIn_fractIn[27] ? 6'h18 : _aRec_1_0_rawIn_normDist_T_77; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_79 = aRec_1_0_rawIn_fractIn[28] ? 6'h17 : _aRec_1_0_rawIn_normDist_T_78; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_80 = aRec_1_0_rawIn_fractIn[29] ? 6'h16 : _aRec_1_0_rawIn_normDist_T_79; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_81 = aRec_1_0_rawIn_fractIn[30] ? 6'h15 : _aRec_1_0_rawIn_normDist_T_80; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_82 = aRec_1_0_rawIn_fractIn[31] ? 6'h14 : _aRec_1_0_rawIn_normDist_T_81; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_83 = aRec_1_0_rawIn_fractIn[32] ? 6'h13 : _aRec_1_0_rawIn_normDist_T_82; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_84 = aRec_1_0_rawIn_fractIn[33] ? 6'h12 : _aRec_1_0_rawIn_normDist_T_83; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_85 = aRec_1_0_rawIn_fractIn[34] ? 6'h11 : _aRec_1_0_rawIn_normDist_T_84; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_86 = aRec_1_0_rawIn_fractIn[35] ? 6'h10 : _aRec_1_0_rawIn_normDist_T_85; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_87 = aRec_1_0_rawIn_fractIn[36] ? 6'hf : _aRec_1_0_rawIn_normDist_T_86; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_88 = aRec_1_0_rawIn_fractIn[37] ? 6'he : _aRec_1_0_rawIn_normDist_T_87; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_89 = aRec_1_0_rawIn_fractIn[38] ? 6'hd : _aRec_1_0_rawIn_normDist_T_88; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_90 = aRec_1_0_rawIn_fractIn[39] ? 6'hc : _aRec_1_0_rawIn_normDist_T_89; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_91 = aRec_1_0_rawIn_fractIn[40] ? 6'hb : _aRec_1_0_rawIn_normDist_T_90; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_92 = aRec_1_0_rawIn_fractIn[41] ? 6'ha : _aRec_1_0_rawIn_normDist_T_91; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_93 = aRec_1_0_rawIn_fractIn[42] ? 6'h9 : _aRec_1_0_rawIn_normDist_T_92; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_94 = aRec_1_0_rawIn_fractIn[43] ? 6'h8 : _aRec_1_0_rawIn_normDist_T_93; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_95 = aRec_1_0_rawIn_fractIn[44] ? 6'h7 : _aRec_1_0_rawIn_normDist_T_94; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_96 = aRec_1_0_rawIn_fractIn[45] ? 6'h6 : _aRec_1_0_rawIn_normDist_T_95; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_97 = aRec_1_0_rawIn_fractIn[46] ? 6'h5 : _aRec_1_0_rawIn_normDist_T_96; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_98 = aRec_1_0_rawIn_fractIn[47] ? 6'h4 : _aRec_1_0_rawIn_normDist_T_97; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_99 = aRec_1_0_rawIn_fractIn[48] ? 6'h3 : _aRec_1_0_rawIn_normDist_T_98; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_100 = aRec_1_0_rawIn_fractIn[49] ? 6'h2 : _aRec_1_0_rawIn_normDist_T_99; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_0_rawIn_normDist_T_101 = aRec_1_0_rawIn_fractIn[50] ? 6'h1 : _aRec_1_0_rawIn_normDist_T_100; // @[Mux.scala 47:70]
  wire [5:0] aRec_1_0_rawIn_normDist = aRec_1_0_rawIn_fractIn[51] ? 6'h0 : _aRec_1_0_rawIn_normDist_T_101; // @[Mux.scala 47:70]
  wire [114:0] _GEN_36 = {{63'd0}, aRec_1_0_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [114:0] _aRec_1_0_rawIn_subnormFract_T = _GEN_36 << aRec_1_0_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [51:0] aRec_1_0_rawIn_subnormFract = {_aRec_1_0_rawIn_subnormFract_T[50:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [11:0] _GEN_16 = {{6'd0}, aRec_1_0_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _aRec_1_0_rawIn_adjustedExp_T = _GEN_16 ^ 12'hfff; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _aRec_1_0_rawIn_adjustedExp_T_1 = aRec_1_0_rawIn_isZeroExpIn ? _aRec_1_0_rawIn_adjustedExp_T : {{1'd0},
    aRec_1_0_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _aRec_1_0_rawIn_adjustedExp_T_2 = aRec_1_0_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [10:0] _GEN_17 = {{9'd0}, _aRec_1_0_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [10:0] _aRec_1_0_rawIn_adjustedExp_T_3 = 11'h400 | _GEN_17; // @[rawFloatFromFN.scala 58:9]
  wire [11:0] _GEN_18 = {{1'd0}, _aRec_1_0_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [11:0] aRec_1_0_rawIn_adjustedExp = _aRec_1_0_rawIn_adjustedExp_T_1 + _GEN_18; // @[rawFloatFromFN.scala 57:9]
  wire  aRec_1_0_rawIn_isZero = aRec_1_0_rawIn_isZeroExpIn & aRec_1_0_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  aRec_1_0_rawIn_isSpecial = aRec_1_0_rawIn_adjustedExp[11:10] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  aRec_1_0_rawIn__isNaN = aRec_1_0_rawIn_isSpecial & ~aRec_1_0_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [12:0] aRec_1_0_rawIn__sExp = {1'b0,$signed(aRec_1_0_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _aRec_1_0_rawIn_out_sig_T = ~aRec_1_0_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [51:0] _aRec_1_0_rawIn_out_sig_T_2 = aRec_1_0_rawIn_isZeroExpIn ? aRec_1_0_rawIn_subnormFract :
    aRec_1_0_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [53:0] aRec_1_0_rawIn__sig = {1'h0,_aRec_1_0_rawIn_out_sig_T,_aRec_1_0_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _aRec_1_0_T_1 = aRec_1_0_rawIn_isZero ? 3'h0 : aRec_1_0_rawIn__sExp[11:9]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_19 = {{2'd0}, aRec_1_0_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _aRec_1_0_T_3 = _aRec_1_0_T_1 | _GEN_19; // @[recFNFromFN.scala 48:76]
  wire [12:0] _aRec_1_0_T_6 = {aRec_1_0_rawIn_sign,_aRec_1_0_T_3,aRec_1_0_rawIn__sExp[8:0]}; // @[recFNFromFN.scala 49:45]
  wire  bRec_1_0_rawIn_sign = io_b_1_0[63]; // @[rawFloatFromFN.scala 44:18]
  wire [10:0] bRec_1_0_rawIn_expIn = io_b_1_0[62:52]; // @[rawFloatFromFN.scala 45:19]
  wire [51:0] bRec_1_0_rawIn_fractIn = io_b_1_0[51:0]; // @[rawFloatFromFN.scala 46:21]
  wire  bRec_1_0_rawIn_isZeroExpIn = bRec_1_0_rawIn_expIn == 11'h0; // @[rawFloatFromFN.scala 48:30]
  wire  bRec_1_0_rawIn_isZeroFractIn = bRec_1_0_rawIn_fractIn == 52'h0; // @[rawFloatFromFN.scala 49:34]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_52 = bRec_1_0_rawIn_fractIn[1] ? 6'h32 : 6'h33; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_53 = bRec_1_0_rawIn_fractIn[2] ? 6'h31 : _bRec_1_0_rawIn_normDist_T_52; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_54 = bRec_1_0_rawIn_fractIn[3] ? 6'h30 : _bRec_1_0_rawIn_normDist_T_53; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_55 = bRec_1_0_rawIn_fractIn[4] ? 6'h2f : _bRec_1_0_rawIn_normDist_T_54; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_56 = bRec_1_0_rawIn_fractIn[5] ? 6'h2e : _bRec_1_0_rawIn_normDist_T_55; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_57 = bRec_1_0_rawIn_fractIn[6] ? 6'h2d : _bRec_1_0_rawIn_normDist_T_56; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_58 = bRec_1_0_rawIn_fractIn[7] ? 6'h2c : _bRec_1_0_rawIn_normDist_T_57; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_59 = bRec_1_0_rawIn_fractIn[8] ? 6'h2b : _bRec_1_0_rawIn_normDist_T_58; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_60 = bRec_1_0_rawIn_fractIn[9] ? 6'h2a : _bRec_1_0_rawIn_normDist_T_59; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_61 = bRec_1_0_rawIn_fractIn[10] ? 6'h29 : _bRec_1_0_rawIn_normDist_T_60; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_62 = bRec_1_0_rawIn_fractIn[11] ? 6'h28 : _bRec_1_0_rawIn_normDist_T_61; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_63 = bRec_1_0_rawIn_fractIn[12] ? 6'h27 : _bRec_1_0_rawIn_normDist_T_62; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_64 = bRec_1_0_rawIn_fractIn[13] ? 6'h26 : _bRec_1_0_rawIn_normDist_T_63; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_65 = bRec_1_0_rawIn_fractIn[14] ? 6'h25 : _bRec_1_0_rawIn_normDist_T_64; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_66 = bRec_1_0_rawIn_fractIn[15] ? 6'h24 : _bRec_1_0_rawIn_normDist_T_65; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_67 = bRec_1_0_rawIn_fractIn[16] ? 6'h23 : _bRec_1_0_rawIn_normDist_T_66; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_68 = bRec_1_0_rawIn_fractIn[17] ? 6'h22 : _bRec_1_0_rawIn_normDist_T_67; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_69 = bRec_1_0_rawIn_fractIn[18] ? 6'h21 : _bRec_1_0_rawIn_normDist_T_68; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_70 = bRec_1_0_rawIn_fractIn[19] ? 6'h20 : _bRec_1_0_rawIn_normDist_T_69; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_71 = bRec_1_0_rawIn_fractIn[20] ? 6'h1f : _bRec_1_0_rawIn_normDist_T_70; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_72 = bRec_1_0_rawIn_fractIn[21] ? 6'h1e : _bRec_1_0_rawIn_normDist_T_71; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_73 = bRec_1_0_rawIn_fractIn[22] ? 6'h1d : _bRec_1_0_rawIn_normDist_T_72; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_74 = bRec_1_0_rawIn_fractIn[23] ? 6'h1c : _bRec_1_0_rawIn_normDist_T_73; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_75 = bRec_1_0_rawIn_fractIn[24] ? 6'h1b : _bRec_1_0_rawIn_normDist_T_74; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_76 = bRec_1_0_rawIn_fractIn[25] ? 6'h1a : _bRec_1_0_rawIn_normDist_T_75; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_77 = bRec_1_0_rawIn_fractIn[26] ? 6'h19 : _bRec_1_0_rawIn_normDist_T_76; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_78 = bRec_1_0_rawIn_fractIn[27] ? 6'h18 : _bRec_1_0_rawIn_normDist_T_77; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_79 = bRec_1_0_rawIn_fractIn[28] ? 6'h17 : _bRec_1_0_rawIn_normDist_T_78; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_80 = bRec_1_0_rawIn_fractIn[29] ? 6'h16 : _bRec_1_0_rawIn_normDist_T_79; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_81 = bRec_1_0_rawIn_fractIn[30] ? 6'h15 : _bRec_1_0_rawIn_normDist_T_80; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_82 = bRec_1_0_rawIn_fractIn[31] ? 6'h14 : _bRec_1_0_rawIn_normDist_T_81; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_83 = bRec_1_0_rawIn_fractIn[32] ? 6'h13 : _bRec_1_0_rawIn_normDist_T_82; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_84 = bRec_1_0_rawIn_fractIn[33] ? 6'h12 : _bRec_1_0_rawIn_normDist_T_83; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_85 = bRec_1_0_rawIn_fractIn[34] ? 6'h11 : _bRec_1_0_rawIn_normDist_T_84; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_86 = bRec_1_0_rawIn_fractIn[35] ? 6'h10 : _bRec_1_0_rawIn_normDist_T_85; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_87 = bRec_1_0_rawIn_fractIn[36] ? 6'hf : _bRec_1_0_rawIn_normDist_T_86; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_88 = bRec_1_0_rawIn_fractIn[37] ? 6'he : _bRec_1_0_rawIn_normDist_T_87; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_89 = bRec_1_0_rawIn_fractIn[38] ? 6'hd : _bRec_1_0_rawIn_normDist_T_88; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_90 = bRec_1_0_rawIn_fractIn[39] ? 6'hc : _bRec_1_0_rawIn_normDist_T_89; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_91 = bRec_1_0_rawIn_fractIn[40] ? 6'hb : _bRec_1_0_rawIn_normDist_T_90; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_92 = bRec_1_0_rawIn_fractIn[41] ? 6'ha : _bRec_1_0_rawIn_normDist_T_91; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_93 = bRec_1_0_rawIn_fractIn[42] ? 6'h9 : _bRec_1_0_rawIn_normDist_T_92; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_94 = bRec_1_0_rawIn_fractIn[43] ? 6'h8 : _bRec_1_0_rawIn_normDist_T_93; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_95 = bRec_1_0_rawIn_fractIn[44] ? 6'h7 : _bRec_1_0_rawIn_normDist_T_94; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_96 = bRec_1_0_rawIn_fractIn[45] ? 6'h6 : _bRec_1_0_rawIn_normDist_T_95; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_97 = bRec_1_0_rawIn_fractIn[46] ? 6'h5 : _bRec_1_0_rawIn_normDist_T_96; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_98 = bRec_1_0_rawIn_fractIn[47] ? 6'h4 : _bRec_1_0_rawIn_normDist_T_97; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_99 = bRec_1_0_rawIn_fractIn[48] ? 6'h3 : _bRec_1_0_rawIn_normDist_T_98; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_100 = bRec_1_0_rawIn_fractIn[49] ? 6'h2 : _bRec_1_0_rawIn_normDist_T_99; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_0_rawIn_normDist_T_101 = bRec_1_0_rawIn_fractIn[50] ? 6'h1 : _bRec_1_0_rawIn_normDist_T_100; // @[Mux.scala 47:70]
  wire [5:0] bRec_1_0_rawIn_normDist = bRec_1_0_rawIn_fractIn[51] ? 6'h0 : _bRec_1_0_rawIn_normDist_T_101; // @[Mux.scala 47:70]
  wire [114:0] _GEN_37 = {{63'd0}, bRec_1_0_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [114:0] _bRec_1_0_rawIn_subnormFract_T = _GEN_37 << bRec_1_0_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [51:0] bRec_1_0_rawIn_subnormFract = {_bRec_1_0_rawIn_subnormFract_T[50:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [11:0] _GEN_20 = {{6'd0}, bRec_1_0_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _bRec_1_0_rawIn_adjustedExp_T = _GEN_20 ^ 12'hfff; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _bRec_1_0_rawIn_adjustedExp_T_1 = bRec_1_0_rawIn_isZeroExpIn ? _bRec_1_0_rawIn_adjustedExp_T : {{1'd0},
    bRec_1_0_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _bRec_1_0_rawIn_adjustedExp_T_2 = bRec_1_0_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [10:0] _GEN_21 = {{9'd0}, _bRec_1_0_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [10:0] _bRec_1_0_rawIn_adjustedExp_T_3 = 11'h400 | _GEN_21; // @[rawFloatFromFN.scala 58:9]
  wire [11:0] _GEN_22 = {{1'd0}, _bRec_1_0_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [11:0] bRec_1_0_rawIn_adjustedExp = _bRec_1_0_rawIn_adjustedExp_T_1 + _GEN_22; // @[rawFloatFromFN.scala 57:9]
  wire  bRec_1_0_rawIn_isZero = bRec_1_0_rawIn_isZeroExpIn & bRec_1_0_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  bRec_1_0_rawIn_isSpecial = bRec_1_0_rawIn_adjustedExp[11:10] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  bRec_1_0_rawIn__isNaN = bRec_1_0_rawIn_isSpecial & ~bRec_1_0_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [12:0] bRec_1_0_rawIn__sExp = {1'b0,$signed(bRec_1_0_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _bRec_1_0_rawIn_out_sig_T = ~bRec_1_0_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [51:0] _bRec_1_0_rawIn_out_sig_T_2 = bRec_1_0_rawIn_isZeroExpIn ? bRec_1_0_rawIn_subnormFract :
    bRec_1_0_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [53:0] bRec_1_0_rawIn__sig = {1'h0,_bRec_1_0_rawIn_out_sig_T,_bRec_1_0_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _bRec_1_0_T_1 = bRec_1_0_rawIn_isZero ? 3'h0 : bRec_1_0_rawIn__sExp[11:9]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_23 = {{2'd0}, bRec_1_0_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _bRec_1_0_T_3 = _bRec_1_0_T_1 | _GEN_23; // @[recFNFromFN.scala 48:76]
  wire [12:0] _bRec_1_0_T_6 = {bRec_1_0_rawIn_sign,_bRec_1_0_T_3,bRec_1_0_rawIn__sExp[8:0]}; // @[recFNFromFN.scala 49:45]
  wire  aRec_1_1_rawIn_sign = io_a_1_1[63]; // @[rawFloatFromFN.scala 44:18]
  wire [10:0] aRec_1_1_rawIn_expIn = io_a_1_1[62:52]; // @[rawFloatFromFN.scala 45:19]
  wire [51:0] aRec_1_1_rawIn_fractIn = io_a_1_1[51:0]; // @[rawFloatFromFN.scala 46:21]
  wire  aRec_1_1_rawIn_isZeroExpIn = aRec_1_1_rawIn_expIn == 11'h0; // @[rawFloatFromFN.scala 48:30]
  wire  aRec_1_1_rawIn_isZeroFractIn = aRec_1_1_rawIn_fractIn == 52'h0; // @[rawFloatFromFN.scala 49:34]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_52 = aRec_1_1_rawIn_fractIn[1] ? 6'h32 : 6'h33; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_53 = aRec_1_1_rawIn_fractIn[2] ? 6'h31 : _aRec_1_1_rawIn_normDist_T_52; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_54 = aRec_1_1_rawIn_fractIn[3] ? 6'h30 : _aRec_1_1_rawIn_normDist_T_53; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_55 = aRec_1_1_rawIn_fractIn[4] ? 6'h2f : _aRec_1_1_rawIn_normDist_T_54; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_56 = aRec_1_1_rawIn_fractIn[5] ? 6'h2e : _aRec_1_1_rawIn_normDist_T_55; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_57 = aRec_1_1_rawIn_fractIn[6] ? 6'h2d : _aRec_1_1_rawIn_normDist_T_56; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_58 = aRec_1_1_rawIn_fractIn[7] ? 6'h2c : _aRec_1_1_rawIn_normDist_T_57; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_59 = aRec_1_1_rawIn_fractIn[8] ? 6'h2b : _aRec_1_1_rawIn_normDist_T_58; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_60 = aRec_1_1_rawIn_fractIn[9] ? 6'h2a : _aRec_1_1_rawIn_normDist_T_59; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_61 = aRec_1_1_rawIn_fractIn[10] ? 6'h29 : _aRec_1_1_rawIn_normDist_T_60; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_62 = aRec_1_1_rawIn_fractIn[11] ? 6'h28 : _aRec_1_1_rawIn_normDist_T_61; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_63 = aRec_1_1_rawIn_fractIn[12] ? 6'h27 : _aRec_1_1_rawIn_normDist_T_62; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_64 = aRec_1_1_rawIn_fractIn[13] ? 6'h26 : _aRec_1_1_rawIn_normDist_T_63; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_65 = aRec_1_1_rawIn_fractIn[14] ? 6'h25 : _aRec_1_1_rawIn_normDist_T_64; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_66 = aRec_1_1_rawIn_fractIn[15] ? 6'h24 : _aRec_1_1_rawIn_normDist_T_65; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_67 = aRec_1_1_rawIn_fractIn[16] ? 6'h23 : _aRec_1_1_rawIn_normDist_T_66; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_68 = aRec_1_1_rawIn_fractIn[17] ? 6'h22 : _aRec_1_1_rawIn_normDist_T_67; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_69 = aRec_1_1_rawIn_fractIn[18] ? 6'h21 : _aRec_1_1_rawIn_normDist_T_68; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_70 = aRec_1_1_rawIn_fractIn[19] ? 6'h20 : _aRec_1_1_rawIn_normDist_T_69; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_71 = aRec_1_1_rawIn_fractIn[20] ? 6'h1f : _aRec_1_1_rawIn_normDist_T_70; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_72 = aRec_1_1_rawIn_fractIn[21] ? 6'h1e : _aRec_1_1_rawIn_normDist_T_71; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_73 = aRec_1_1_rawIn_fractIn[22] ? 6'h1d : _aRec_1_1_rawIn_normDist_T_72; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_74 = aRec_1_1_rawIn_fractIn[23] ? 6'h1c : _aRec_1_1_rawIn_normDist_T_73; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_75 = aRec_1_1_rawIn_fractIn[24] ? 6'h1b : _aRec_1_1_rawIn_normDist_T_74; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_76 = aRec_1_1_rawIn_fractIn[25] ? 6'h1a : _aRec_1_1_rawIn_normDist_T_75; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_77 = aRec_1_1_rawIn_fractIn[26] ? 6'h19 : _aRec_1_1_rawIn_normDist_T_76; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_78 = aRec_1_1_rawIn_fractIn[27] ? 6'h18 : _aRec_1_1_rawIn_normDist_T_77; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_79 = aRec_1_1_rawIn_fractIn[28] ? 6'h17 : _aRec_1_1_rawIn_normDist_T_78; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_80 = aRec_1_1_rawIn_fractIn[29] ? 6'h16 : _aRec_1_1_rawIn_normDist_T_79; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_81 = aRec_1_1_rawIn_fractIn[30] ? 6'h15 : _aRec_1_1_rawIn_normDist_T_80; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_82 = aRec_1_1_rawIn_fractIn[31] ? 6'h14 : _aRec_1_1_rawIn_normDist_T_81; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_83 = aRec_1_1_rawIn_fractIn[32] ? 6'h13 : _aRec_1_1_rawIn_normDist_T_82; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_84 = aRec_1_1_rawIn_fractIn[33] ? 6'h12 : _aRec_1_1_rawIn_normDist_T_83; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_85 = aRec_1_1_rawIn_fractIn[34] ? 6'h11 : _aRec_1_1_rawIn_normDist_T_84; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_86 = aRec_1_1_rawIn_fractIn[35] ? 6'h10 : _aRec_1_1_rawIn_normDist_T_85; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_87 = aRec_1_1_rawIn_fractIn[36] ? 6'hf : _aRec_1_1_rawIn_normDist_T_86; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_88 = aRec_1_1_rawIn_fractIn[37] ? 6'he : _aRec_1_1_rawIn_normDist_T_87; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_89 = aRec_1_1_rawIn_fractIn[38] ? 6'hd : _aRec_1_1_rawIn_normDist_T_88; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_90 = aRec_1_1_rawIn_fractIn[39] ? 6'hc : _aRec_1_1_rawIn_normDist_T_89; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_91 = aRec_1_1_rawIn_fractIn[40] ? 6'hb : _aRec_1_1_rawIn_normDist_T_90; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_92 = aRec_1_1_rawIn_fractIn[41] ? 6'ha : _aRec_1_1_rawIn_normDist_T_91; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_93 = aRec_1_1_rawIn_fractIn[42] ? 6'h9 : _aRec_1_1_rawIn_normDist_T_92; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_94 = aRec_1_1_rawIn_fractIn[43] ? 6'h8 : _aRec_1_1_rawIn_normDist_T_93; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_95 = aRec_1_1_rawIn_fractIn[44] ? 6'h7 : _aRec_1_1_rawIn_normDist_T_94; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_96 = aRec_1_1_rawIn_fractIn[45] ? 6'h6 : _aRec_1_1_rawIn_normDist_T_95; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_97 = aRec_1_1_rawIn_fractIn[46] ? 6'h5 : _aRec_1_1_rawIn_normDist_T_96; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_98 = aRec_1_1_rawIn_fractIn[47] ? 6'h4 : _aRec_1_1_rawIn_normDist_T_97; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_99 = aRec_1_1_rawIn_fractIn[48] ? 6'h3 : _aRec_1_1_rawIn_normDist_T_98; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_100 = aRec_1_1_rawIn_fractIn[49] ? 6'h2 : _aRec_1_1_rawIn_normDist_T_99; // @[Mux.scala 47:70]
  wire [5:0] _aRec_1_1_rawIn_normDist_T_101 = aRec_1_1_rawIn_fractIn[50] ? 6'h1 : _aRec_1_1_rawIn_normDist_T_100; // @[Mux.scala 47:70]
  wire [5:0] aRec_1_1_rawIn_normDist = aRec_1_1_rawIn_fractIn[51] ? 6'h0 : _aRec_1_1_rawIn_normDist_T_101; // @[Mux.scala 47:70]
  wire [114:0] _GEN_38 = {{63'd0}, aRec_1_1_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [114:0] _aRec_1_1_rawIn_subnormFract_T = _GEN_38 << aRec_1_1_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [51:0] aRec_1_1_rawIn_subnormFract = {_aRec_1_1_rawIn_subnormFract_T[50:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [11:0] _GEN_24 = {{6'd0}, aRec_1_1_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _aRec_1_1_rawIn_adjustedExp_T = _GEN_24 ^ 12'hfff; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _aRec_1_1_rawIn_adjustedExp_T_1 = aRec_1_1_rawIn_isZeroExpIn ? _aRec_1_1_rawIn_adjustedExp_T : {{1'd0},
    aRec_1_1_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _aRec_1_1_rawIn_adjustedExp_T_2 = aRec_1_1_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [10:0] _GEN_25 = {{9'd0}, _aRec_1_1_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [10:0] _aRec_1_1_rawIn_adjustedExp_T_3 = 11'h400 | _GEN_25; // @[rawFloatFromFN.scala 58:9]
  wire [11:0] _GEN_26 = {{1'd0}, _aRec_1_1_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [11:0] aRec_1_1_rawIn_adjustedExp = _aRec_1_1_rawIn_adjustedExp_T_1 + _GEN_26; // @[rawFloatFromFN.scala 57:9]
  wire  aRec_1_1_rawIn_isZero = aRec_1_1_rawIn_isZeroExpIn & aRec_1_1_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  aRec_1_1_rawIn_isSpecial = aRec_1_1_rawIn_adjustedExp[11:10] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  aRec_1_1_rawIn__isNaN = aRec_1_1_rawIn_isSpecial & ~aRec_1_1_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [12:0] aRec_1_1_rawIn__sExp = {1'b0,$signed(aRec_1_1_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _aRec_1_1_rawIn_out_sig_T = ~aRec_1_1_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [51:0] _aRec_1_1_rawIn_out_sig_T_2 = aRec_1_1_rawIn_isZeroExpIn ? aRec_1_1_rawIn_subnormFract :
    aRec_1_1_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [53:0] aRec_1_1_rawIn__sig = {1'h0,_aRec_1_1_rawIn_out_sig_T,_aRec_1_1_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _aRec_1_1_T_1 = aRec_1_1_rawIn_isZero ? 3'h0 : aRec_1_1_rawIn__sExp[11:9]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_27 = {{2'd0}, aRec_1_1_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _aRec_1_1_T_3 = _aRec_1_1_T_1 | _GEN_27; // @[recFNFromFN.scala 48:76]
  wire [12:0] _aRec_1_1_T_6 = {aRec_1_1_rawIn_sign,_aRec_1_1_T_3,aRec_1_1_rawIn__sExp[8:0]}; // @[recFNFromFN.scala 49:45]
  wire  bRec_1_1_rawIn_sign = io_b_1_1[63]; // @[rawFloatFromFN.scala 44:18]
  wire [10:0] bRec_1_1_rawIn_expIn = io_b_1_1[62:52]; // @[rawFloatFromFN.scala 45:19]
  wire [51:0] bRec_1_1_rawIn_fractIn = io_b_1_1[51:0]; // @[rawFloatFromFN.scala 46:21]
  wire  bRec_1_1_rawIn_isZeroExpIn = bRec_1_1_rawIn_expIn == 11'h0; // @[rawFloatFromFN.scala 48:30]
  wire  bRec_1_1_rawIn_isZeroFractIn = bRec_1_1_rawIn_fractIn == 52'h0; // @[rawFloatFromFN.scala 49:34]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_52 = bRec_1_1_rawIn_fractIn[1] ? 6'h32 : 6'h33; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_53 = bRec_1_1_rawIn_fractIn[2] ? 6'h31 : _bRec_1_1_rawIn_normDist_T_52; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_54 = bRec_1_1_rawIn_fractIn[3] ? 6'h30 : _bRec_1_1_rawIn_normDist_T_53; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_55 = bRec_1_1_rawIn_fractIn[4] ? 6'h2f : _bRec_1_1_rawIn_normDist_T_54; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_56 = bRec_1_1_rawIn_fractIn[5] ? 6'h2e : _bRec_1_1_rawIn_normDist_T_55; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_57 = bRec_1_1_rawIn_fractIn[6] ? 6'h2d : _bRec_1_1_rawIn_normDist_T_56; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_58 = bRec_1_1_rawIn_fractIn[7] ? 6'h2c : _bRec_1_1_rawIn_normDist_T_57; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_59 = bRec_1_1_rawIn_fractIn[8] ? 6'h2b : _bRec_1_1_rawIn_normDist_T_58; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_60 = bRec_1_1_rawIn_fractIn[9] ? 6'h2a : _bRec_1_1_rawIn_normDist_T_59; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_61 = bRec_1_1_rawIn_fractIn[10] ? 6'h29 : _bRec_1_1_rawIn_normDist_T_60; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_62 = bRec_1_1_rawIn_fractIn[11] ? 6'h28 : _bRec_1_1_rawIn_normDist_T_61; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_63 = bRec_1_1_rawIn_fractIn[12] ? 6'h27 : _bRec_1_1_rawIn_normDist_T_62; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_64 = bRec_1_1_rawIn_fractIn[13] ? 6'h26 : _bRec_1_1_rawIn_normDist_T_63; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_65 = bRec_1_1_rawIn_fractIn[14] ? 6'h25 : _bRec_1_1_rawIn_normDist_T_64; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_66 = bRec_1_1_rawIn_fractIn[15] ? 6'h24 : _bRec_1_1_rawIn_normDist_T_65; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_67 = bRec_1_1_rawIn_fractIn[16] ? 6'h23 : _bRec_1_1_rawIn_normDist_T_66; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_68 = bRec_1_1_rawIn_fractIn[17] ? 6'h22 : _bRec_1_1_rawIn_normDist_T_67; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_69 = bRec_1_1_rawIn_fractIn[18] ? 6'h21 : _bRec_1_1_rawIn_normDist_T_68; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_70 = bRec_1_1_rawIn_fractIn[19] ? 6'h20 : _bRec_1_1_rawIn_normDist_T_69; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_71 = bRec_1_1_rawIn_fractIn[20] ? 6'h1f : _bRec_1_1_rawIn_normDist_T_70; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_72 = bRec_1_1_rawIn_fractIn[21] ? 6'h1e : _bRec_1_1_rawIn_normDist_T_71; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_73 = bRec_1_1_rawIn_fractIn[22] ? 6'h1d : _bRec_1_1_rawIn_normDist_T_72; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_74 = bRec_1_1_rawIn_fractIn[23] ? 6'h1c : _bRec_1_1_rawIn_normDist_T_73; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_75 = bRec_1_1_rawIn_fractIn[24] ? 6'h1b : _bRec_1_1_rawIn_normDist_T_74; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_76 = bRec_1_1_rawIn_fractIn[25] ? 6'h1a : _bRec_1_1_rawIn_normDist_T_75; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_77 = bRec_1_1_rawIn_fractIn[26] ? 6'h19 : _bRec_1_1_rawIn_normDist_T_76; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_78 = bRec_1_1_rawIn_fractIn[27] ? 6'h18 : _bRec_1_1_rawIn_normDist_T_77; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_79 = bRec_1_1_rawIn_fractIn[28] ? 6'h17 : _bRec_1_1_rawIn_normDist_T_78; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_80 = bRec_1_1_rawIn_fractIn[29] ? 6'h16 : _bRec_1_1_rawIn_normDist_T_79; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_81 = bRec_1_1_rawIn_fractIn[30] ? 6'h15 : _bRec_1_1_rawIn_normDist_T_80; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_82 = bRec_1_1_rawIn_fractIn[31] ? 6'h14 : _bRec_1_1_rawIn_normDist_T_81; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_83 = bRec_1_1_rawIn_fractIn[32] ? 6'h13 : _bRec_1_1_rawIn_normDist_T_82; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_84 = bRec_1_1_rawIn_fractIn[33] ? 6'h12 : _bRec_1_1_rawIn_normDist_T_83; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_85 = bRec_1_1_rawIn_fractIn[34] ? 6'h11 : _bRec_1_1_rawIn_normDist_T_84; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_86 = bRec_1_1_rawIn_fractIn[35] ? 6'h10 : _bRec_1_1_rawIn_normDist_T_85; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_87 = bRec_1_1_rawIn_fractIn[36] ? 6'hf : _bRec_1_1_rawIn_normDist_T_86; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_88 = bRec_1_1_rawIn_fractIn[37] ? 6'he : _bRec_1_1_rawIn_normDist_T_87; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_89 = bRec_1_1_rawIn_fractIn[38] ? 6'hd : _bRec_1_1_rawIn_normDist_T_88; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_90 = bRec_1_1_rawIn_fractIn[39] ? 6'hc : _bRec_1_1_rawIn_normDist_T_89; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_91 = bRec_1_1_rawIn_fractIn[40] ? 6'hb : _bRec_1_1_rawIn_normDist_T_90; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_92 = bRec_1_1_rawIn_fractIn[41] ? 6'ha : _bRec_1_1_rawIn_normDist_T_91; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_93 = bRec_1_1_rawIn_fractIn[42] ? 6'h9 : _bRec_1_1_rawIn_normDist_T_92; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_94 = bRec_1_1_rawIn_fractIn[43] ? 6'h8 : _bRec_1_1_rawIn_normDist_T_93; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_95 = bRec_1_1_rawIn_fractIn[44] ? 6'h7 : _bRec_1_1_rawIn_normDist_T_94; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_96 = bRec_1_1_rawIn_fractIn[45] ? 6'h6 : _bRec_1_1_rawIn_normDist_T_95; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_97 = bRec_1_1_rawIn_fractIn[46] ? 6'h5 : _bRec_1_1_rawIn_normDist_T_96; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_98 = bRec_1_1_rawIn_fractIn[47] ? 6'h4 : _bRec_1_1_rawIn_normDist_T_97; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_99 = bRec_1_1_rawIn_fractIn[48] ? 6'h3 : _bRec_1_1_rawIn_normDist_T_98; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_100 = bRec_1_1_rawIn_fractIn[49] ? 6'h2 : _bRec_1_1_rawIn_normDist_T_99; // @[Mux.scala 47:70]
  wire [5:0] _bRec_1_1_rawIn_normDist_T_101 = bRec_1_1_rawIn_fractIn[50] ? 6'h1 : _bRec_1_1_rawIn_normDist_T_100; // @[Mux.scala 47:70]
  wire [5:0] bRec_1_1_rawIn_normDist = bRec_1_1_rawIn_fractIn[51] ? 6'h0 : _bRec_1_1_rawIn_normDist_T_101; // @[Mux.scala 47:70]
  wire [114:0] _GEN_39 = {{63'd0}, bRec_1_1_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [114:0] _bRec_1_1_rawIn_subnormFract_T = _GEN_39 << bRec_1_1_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [51:0] bRec_1_1_rawIn_subnormFract = {_bRec_1_1_rawIn_subnormFract_T[50:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [11:0] _GEN_28 = {{6'd0}, bRec_1_1_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _bRec_1_1_rawIn_adjustedExp_T = _GEN_28 ^ 12'hfff; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _bRec_1_1_rawIn_adjustedExp_T_1 = bRec_1_1_rawIn_isZeroExpIn ? _bRec_1_1_rawIn_adjustedExp_T : {{1'd0},
    bRec_1_1_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _bRec_1_1_rawIn_adjustedExp_T_2 = bRec_1_1_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [10:0] _GEN_29 = {{9'd0}, _bRec_1_1_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [10:0] _bRec_1_1_rawIn_adjustedExp_T_3 = 11'h400 | _GEN_29; // @[rawFloatFromFN.scala 58:9]
  wire [11:0] _GEN_30 = {{1'd0}, _bRec_1_1_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [11:0] bRec_1_1_rawIn_adjustedExp = _bRec_1_1_rawIn_adjustedExp_T_1 + _GEN_30; // @[rawFloatFromFN.scala 57:9]
  wire  bRec_1_1_rawIn_isZero = bRec_1_1_rawIn_isZeroExpIn & bRec_1_1_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  bRec_1_1_rawIn_isSpecial = bRec_1_1_rawIn_adjustedExp[11:10] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  bRec_1_1_rawIn__isNaN = bRec_1_1_rawIn_isSpecial & ~bRec_1_1_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [12:0] bRec_1_1_rawIn__sExp = {1'b0,$signed(bRec_1_1_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _bRec_1_1_rawIn_out_sig_T = ~bRec_1_1_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [51:0] _bRec_1_1_rawIn_out_sig_T_2 = bRec_1_1_rawIn_isZeroExpIn ? bRec_1_1_rawIn_subnormFract :
    bRec_1_1_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [53:0] bRec_1_1_rawIn__sig = {1'h0,_bRec_1_1_rawIn_out_sig_T,_bRec_1_1_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _bRec_1_1_T_1 = bRec_1_1_rawIn_isZero ? 3'h0 : bRec_1_1_rawIn__sExp[11:9]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_31 = {{2'd0}, bRec_1_1_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _bRec_1_1_T_3 = _bRec_1_1_T_1 | _GEN_31; // @[recFNFromFN.scala 48:76]
  wire [12:0] _bRec_1_1_T_6 = {bRec_1_1_rawIn_sign,_bRec_1_1_T_3,bRec_1_1_rawIn__sExp[8:0]}; // @[recFNFromFN.scala 49:45]
  wire [11:0] io_c_0_0_rawIn_exp = dotFMA_io_out[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  io_c_0_0_rawIn_isZero = io_c_0_0_rawIn_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  io_c_0_0_rawIn_isSpecial = io_c_0_0_rawIn_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  io_c_0_0_rawIn__isNaN = io_c_0_0_rawIn_isSpecial & io_c_0_0_rawIn_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  wire  io_c_0_0_rawIn__isInf = io_c_0_0_rawIn_isSpecial & ~io_c_0_0_rawIn_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  wire  io_c_0_0_rawIn__sign = dotFMA_io_out[64]; // @[rawFloatFromRecFN.scala 59:25]
  wire [12:0] io_c_0_0_rawIn__sExp = {1'b0,$signed(io_c_0_0_rawIn_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _io_c_0_0_rawIn_out_sig_T = ~io_c_0_0_rawIn_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [53:0] io_c_0_0_rawIn__sig = {1'h0,_io_c_0_0_rawIn_out_sig_T,dotFMA_io_out[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  wire  io_c_0_0_isSubnormal = $signed(io_c_0_0_rawIn__sExp) < 13'sh402; // @[fNFromRecFN.scala 51:38]
  wire [5:0] io_c_0_0_denormShiftDist = 6'h1 - io_c_0_0_rawIn__sExp[5:0]; // @[fNFromRecFN.scala 52:35]
  wire [52:0] _io_c_0_0_denormFract_T_1 = io_c_0_0_rawIn__sig[53:1] >> io_c_0_0_denormShiftDist; // @[fNFromRecFN.scala 53:42]
  wire [51:0] io_c_0_0_denormFract = _io_c_0_0_denormFract_T_1[51:0]; // @[fNFromRecFN.scala 53:60]
  wire [10:0] _io_c_0_0_expOut_T_2 = io_c_0_0_rawIn__sExp[10:0] - 11'h401; // @[fNFromRecFN.scala 58:45]
  wire [10:0] _io_c_0_0_expOut_T_3 = io_c_0_0_isSubnormal ? 11'h0 : _io_c_0_0_expOut_T_2; // @[fNFromRecFN.scala 56:16]
  wire  _io_c_0_0_expOut_T_4 = io_c_0_0_rawIn__isNaN | io_c_0_0_rawIn__isInf; // @[fNFromRecFN.scala 60:44]
  wire [10:0] _io_c_0_0_expOut_T_6 = _io_c_0_0_expOut_T_4 ? 11'h7ff : 11'h0; // @[Bitwise.scala 77:12]
  wire [10:0] io_c_0_0_expOut = _io_c_0_0_expOut_T_3 | _io_c_0_0_expOut_T_6; // @[fNFromRecFN.scala 60:15]
  wire [51:0] _io_c_0_0_fractOut_T_1 = io_c_0_0_rawIn__isInf ? 52'h0 : io_c_0_0_rawIn__sig[51:0]; // @[fNFromRecFN.scala 64:20]
  wire [51:0] io_c_0_0_fractOut = io_c_0_0_isSubnormal ? io_c_0_0_denormFract : _io_c_0_0_fractOut_T_1; // @[fNFromRecFN.scala 62:16]
  wire [11:0] io_c_0_0_hi = {io_c_0_0_rawIn__sign,io_c_0_0_expOut}; // @[Cat.scala 33:92]
  wire [11:0] io_c_0_1_rawIn_exp = dotFMA_1_io_out[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  io_c_0_1_rawIn_isZero = io_c_0_1_rawIn_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  io_c_0_1_rawIn_isSpecial = io_c_0_1_rawIn_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  io_c_0_1_rawIn__isNaN = io_c_0_1_rawIn_isSpecial & io_c_0_1_rawIn_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  wire  io_c_0_1_rawIn__isInf = io_c_0_1_rawIn_isSpecial & ~io_c_0_1_rawIn_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  wire  io_c_0_1_rawIn__sign = dotFMA_1_io_out[64]; // @[rawFloatFromRecFN.scala 59:25]
  wire [12:0] io_c_0_1_rawIn__sExp = {1'b0,$signed(io_c_0_1_rawIn_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _io_c_0_1_rawIn_out_sig_T = ~io_c_0_1_rawIn_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [53:0] io_c_0_1_rawIn__sig = {1'h0,_io_c_0_1_rawIn_out_sig_T,dotFMA_1_io_out[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  wire  io_c_0_1_isSubnormal = $signed(io_c_0_1_rawIn__sExp) < 13'sh402; // @[fNFromRecFN.scala 51:38]
  wire [5:0] io_c_0_1_denormShiftDist = 6'h1 - io_c_0_1_rawIn__sExp[5:0]; // @[fNFromRecFN.scala 52:35]
  wire [52:0] _io_c_0_1_denormFract_T_1 = io_c_0_1_rawIn__sig[53:1] >> io_c_0_1_denormShiftDist; // @[fNFromRecFN.scala 53:42]
  wire [51:0] io_c_0_1_denormFract = _io_c_0_1_denormFract_T_1[51:0]; // @[fNFromRecFN.scala 53:60]
  wire [10:0] _io_c_0_1_expOut_T_2 = io_c_0_1_rawIn__sExp[10:0] - 11'h401; // @[fNFromRecFN.scala 58:45]
  wire [10:0] _io_c_0_1_expOut_T_3 = io_c_0_1_isSubnormal ? 11'h0 : _io_c_0_1_expOut_T_2; // @[fNFromRecFN.scala 56:16]
  wire  _io_c_0_1_expOut_T_4 = io_c_0_1_rawIn__isNaN | io_c_0_1_rawIn__isInf; // @[fNFromRecFN.scala 60:44]
  wire [10:0] _io_c_0_1_expOut_T_6 = _io_c_0_1_expOut_T_4 ? 11'h7ff : 11'h0; // @[Bitwise.scala 77:12]
  wire [10:0] io_c_0_1_expOut = _io_c_0_1_expOut_T_3 | _io_c_0_1_expOut_T_6; // @[fNFromRecFN.scala 60:15]
  wire [51:0] _io_c_0_1_fractOut_T_1 = io_c_0_1_rawIn__isInf ? 52'h0 : io_c_0_1_rawIn__sig[51:0]; // @[fNFromRecFN.scala 64:20]
  wire [51:0] io_c_0_1_fractOut = io_c_0_1_isSubnormal ? io_c_0_1_denormFract : _io_c_0_1_fractOut_T_1; // @[fNFromRecFN.scala 62:16]
  wire [11:0] io_c_0_1_hi = {io_c_0_1_rawIn__sign,io_c_0_1_expOut}; // @[Cat.scala 33:92]
  wire [11:0] io_c_1_0_rawIn_exp = dotFMA_2_io_out[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  io_c_1_0_rawIn_isZero = io_c_1_0_rawIn_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  io_c_1_0_rawIn_isSpecial = io_c_1_0_rawIn_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  io_c_1_0_rawIn__isNaN = io_c_1_0_rawIn_isSpecial & io_c_1_0_rawIn_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  wire  io_c_1_0_rawIn__isInf = io_c_1_0_rawIn_isSpecial & ~io_c_1_0_rawIn_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  wire  io_c_1_0_rawIn__sign = dotFMA_2_io_out[64]; // @[rawFloatFromRecFN.scala 59:25]
  wire [12:0] io_c_1_0_rawIn__sExp = {1'b0,$signed(io_c_1_0_rawIn_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _io_c_1_0_rawIn_out_sig_T = ~io_c_1_0_rawIn_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [53:0] io_c_1_0_rawIn__sig = {1'h0,_io_c_1_0_rawIn_out_sig_T,dotFMA_2_io_out[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  wire  io_c_1_0_isSubnormal = $signed(io_c_1_0_rawIn__sExp) < 13'sh402; // @[fNFromRecFN.scala 51:38]
  wire [5:0] io_c_1_0_denormShiftDist = 6'h1 - io_c_1_0_rawIn__sExp[5:0]; // @[fNFromRecFN.scala 52:35]
  wire [52:0] _io_c_1_0_denormFract_T_1 = io_c_1_0_rawIn__sig[53:1] >> io_c_1_0_denormShiftDist; // @[fNFromRecFN.scala 53:42]
  wire [51:0] io_c_1_0_denormFract = _io_c_1_0_denormFract_T_1[51:0]; // @[fNFromRecFN.scala 53:60]
  wire [10:0] _io_c_1_0_expOut_T_2 = io_c_1_0_rawIn__sExp[10:0] - 11'h401; // @[fNFromRecFN.scala 58:45]
  wire [10:0] _io_c_1_0_expOut_T_3 = io_c_1_0_isSubnormal ? 11'h0 : _io_c_1_0_expOut_T_2; // @[fNFromRecFN.scala 56:16]
  wire  _io_c_1_0_expOut_T_4 = io_c_1_0_rawIn__isNaN | io_c_1_0_rawIn__isInf; // @[fNFromRecFN.scala 60:44]
  wire [10:0] _io_c_1_0_expOut_T_6 = _io_c_1_0_expOut_T_4 ? 11'h7ff : 11'h0; // @[Bitwise.scala 77:12]
  wire [10:0] io_c_1_0_expOut = _io_c_1_0_expOut_T_3 | _io_c_1_0_expOut_T_6; // @[fNFromRecFN.scala 60:15]
  wire [51:0] _io_c_1_0_fractOut_T_1 = io_c_1_0_rawIn__isInf ? 52'h0 : io_c_1_0_rawIn__sig[51:0]; // @[fNFromRecFN.scala 64:20]
  wire [51:0] io_c_1_0_fractOut = io_c_1_0_isSubnormal ? io_c_1_0_denormFract : _io_c_1_0_fractOut_T_1; // @[fNFromRecFN.scala 62:16]
  wire [11:0] io_c_1_0_hi = {io_c_1_0_rawIn__sign,io_c_1_0_expOut}; // @[Cat.scala 33:92]
  wire [11:0] io_c_1_1_rawIn_exp = dotFMA_3_io_out[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  io_c_1_1_rawIn_isZero = io_c_1_1_rawIn_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  io_c_1_1_rawIn_isSpecial = io_c_1_1_rawIn_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  io_c_1_1_rawIn__isNaN = io_c_1_1_rawIn_isSpecial & io_c_1_1_rawIn_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  wire  io_c_1_1_rawIn__isInf = io_c_1_1_rawIn_isSpecial & ~io_c_1_1_rawIn_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  wire  io_c_1_1_rawIn__sign = dotFMA_3_io_out[64]; // @[rawFloatFromRecFN.scala 59:25]
  wire [12:0] io_c_1_1_rawIn__sExp = {1'b0,$signed(io_c_1_1_rawIn_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _io_c_1_1_rawIn_out_sig_T = ~io_c_1_1_rawIn_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [53:0] io_c_1_1_rawIn__sig = {1'h0,_io_c_1_1_rawIn_out_sig_T,dotFMA_3_io_out[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  wire  io_c_1_1_isSubnormal = $signed(io_c_1_1_rawIn__sExp) < 13'sh402; // @[fNFromRecFN.scala 51:38]
  wire [5:0] io_c_1_1_denormShiftDist = 6'h1 - io_c_1_1_rawIn__sExp[5:0]; // @[fNFromRecFN.scala 52:35]
  wire [52:0] _io_c_1_1_denormFract_T_1 = io_c_1_1_rawIn__sig[53:1] >> io_c_1_1_denormShiftDist; // @[fNFromRecFN.scala 53:42]
  wire [51:0] io_c_1_1_denormFract = _io_c_1_1_denormFract_T_1[51:0]; // @[fNFromRecFN.scala 53:60]
  wire [10:0] _io_c_1_1_expOut_T_2 = io_c_1_1_rawIn__sExp[10:0] - 11'h401; // @[fNFromRecFN.scala 58:45]
  wire [10:0] _io_c_1_1_expOut_T_3 = io_c_1_1_isSubnormal ? 11'h0 : _io_c_1_1_expOut_T_2; // @[fNFromRecFN.scala 56:16]
  wire  _io_c_1_1_expOut_T_4 = io_c_1_1_rawIn__isNaN | io_c_1_1_rawIn__isInf; // @[fNFromRecFN.scala 60:44]
  wire [10:0] _io_c_1_1_expOut_T_6 = _io_c_1_1_expOut_T_4 ? 11'h7ff : 11'h0; // @[Bitwise.scala 77:12]
  wire [10:0] io_c_1_1_expOut = _io_c_1_1_expOut_T_3 | _io_c_1_1_expOut_T_6; // @[fNFromRecFN.scala 60:15]
  wire [51:0] _io_c_1_1_fractOut_T_1 = io_c_1_1_rawIn__isInf ? 52'h0 : io_c_1_1_rawIn__sig[51:0]; // @[fNFromRecFN.scala 64:20]
  wire [51:0] io_c_1_1_fractOut = io_c_1_1_isSubnormal ? io_c_1_1_denormFract : _io_c_1_1_fractOut_T_1; // @[fNFromRecFN.scala 62:16]
  wire [11:0] io_c_1_1_hi = {io_c_1_1_rawIn__sign,io_c_1_1_expOut}; // @[Cat.scala 33:92]
  fp64_MulRecFN secondProduct ( // @[FP64MatrixMulBlock.scala 34:33]
    .io_a(secondProduct_io_a),
    .io_b(secondProduct_io_b),
    .io_roundingMode(secondProduct_io_roundingMode),
    .io_detectTininess(secondProduct_io_detectTininess),
    .io_out(secondProduct_io_out),
    .io_exceptionFlags(secondProduct_io_exceptionFlags)
  );
  fp64_MulAddRecFN_e11_s53 dotFMA ( // @[FP64MatrixMulBlock.scala 41:26]
    .io_a(dotFMA_io_a),
    .io_b(dotFMA_io_b),
    .io_c(dotFMA_io_c),
    .io_roundingMode(dotFMA_io_roundingMode),
    .io_detectTininess(dotFMA_io_detectTininess),
    .io_out(dotFMA_io_out),
    .io_exceptionFlags(dotFMA_io_exceptionFlags)
  );
  fp64_MulRecFN secondProduct_1 ( // @[FP64MatrixMulBlock.scala 34:33]
    .io_a(secondProduct_1_io_a),
    .io_b(secondProduct_1_io_b),
    .io_roundingMode(secondProduct_1_io_roundingMode),
    .io_detectTininess(secondProduct_1_io_detectTininess),
    .io_out(secondProduct_1_io_out),
    .io_exceptionFlags(secondProduct_1_io_exceptionFlags)
  );
  fp64_MulAddRecFN_e11_s53 dotFMA_1 ( // @[FP64MatrixMulBlock.scala 41:26]
    .io_a(dotFMA_1_io_a),
    .io_b(dotFMA_1_io_b),
    .io_c(dotFMA_1_io_c),
    .io_roundingMode(dotFMA_1_io_roundingMode),
    .io_detectTininess(dotFMA_1_io_detectTininess),
    .io_out(dotFMA_1_io_out),
    .io_exceptionFlags(dotFMA_1_io_exceptionFlags)
  );
  fp64_MulRecFN secondProduct_2 ( // @[FP64MatrixMulBlock.scala 34:33]
    .io_a(secondProduct_2_io_a),
    .io_b(secondProduct_2_io_b),
    .io_roundingMode(secondProduct_2_io_roundingMode),
    .io_detectTininess(secondProduct_2_io_detectTininess),
    .io_out(secondProduct_2_io_out),
    .io_exceptionFlags(secondProduct_2_io_exceptionFlags)
  );
  fp64_MulAddRecFN_e11_s53 dotFMA_2 ( // @[FP64MatrixMulBlock.scala 41:26]
    .io_a(dotFMA_2_io_a),
    .io_b(dotFMA_2_io_b),
    .io_c(dotFMA_2_io_c),
    .io_roundingMode(dotFMA_2_io_roundingMode),
    .io_detectTininess(dotFMA_2_io_detectTininess),
    .io_out(dotFMA_2_io_out),
    .io_exceptionFlags(dotFMA_2_io_exceptionFlags)
  );
  fp64_MulRecFN secondProduct_3 ( // @[FP64MatrixMulBlock.scala 34:33]
    .io_a(secondProduct_3_io_a),
    .io_b(secondProduct_3_io_b),
    .io_roundingMode(secondProduct_3_io_roundingMode),
    .io_detectTininess(secondProduct_3_io_detectTininess),
    .io_out(secondProduct_3_io_out),
    .io_exceptionFlags(secondProduct_3_io_exceptionFlags)
  );
  fp64_MulAddRecFN_e11_s53 dotFMA_3 ( // @[FP64MatrixMulBlock.scala 41:26]
    .io_a(dotFMA_3_io_a),
    .io_b(dotFMA_3_io_b),
    .io_c(dotFMA_3_io_c),
    .io_roundingMode(dotFMA_3_io_roundingMode),
    .io_detectTininess(dotFMA_3_io_detectTininess),
    .io_out(dotFMA_3_io_out),
    .io_exceptionFlags(dotFMA_3_io_exceptionFlags)
  );
  assign io_c_0_0 = {io_c_0_0_hi,io_c_0_0_fractOut}; // @[Cat.scala 33:92]
  assign io_c_0_1 = {io_c_0_1_hi,io_c_0_1_fractOut}; // @[Cat.scala 33:92]
  assign io_c_1_0 = {io_c_1_0_hi,io_c_1_0_fractOut}; // @[Cat.scala 33:92]
  assign io_c_1_1 = {io_c_1_1_hi,io_c_1_1_fractOut}; // @[Cat.scala 33:92]
  assign io_exceptionFlags_0_0 = dotFMA_io_exceptionFlags | secondProduct_io_exceptionFlags; // @[FP64MatrixMulBlock.scala 50:63]
  assign io_exceptionFlags_0_1 = dotFMA_1_io_exceptionFlags | secondProduct_1_io_exceptionFlags; // @[FP64MatrixMulBlock.scala 50:63]
  assign io_exceptionFlags_1_0 = dotFMA_2_io_exceptionFlags | secondProduct_2_io_exceptionFlags; // @[FP64MatrixMulBlock.scala 50:63]
  assign io_exceptionFlags_1_1 = dotFMA_3_io_exceptionFlags | secondProduct_3_io_exceptionFlags; // @[FP64MatrixMulBlock.scala 50:63]
  assign secondProduct_io_a = {_aRec_0_1_T_6,aRec_0_1_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign secondProduct_io_b = {_bRec_1_0_T_6,bRec_1_0_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign secondProduct_io_roundingMode = io_roundingMode; // @[FP64MatrixMulBlock.scala 37:37]
  assign secondProduct_io_detectTininess = io_detectTininess; // @[FP64MatrixMulBlock.scala 38:39]
  assign dotFMA_io_a = {_aRec_0_0_T_6,aRec_0_0_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign dotFMA_io_b = {_bRec_0_0_T_6,bRec_0_0_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign dotFMA_io_c = secondProduct_io_out; // @[FP64MatrixMulBlock.scala 45:19]
  assign dotFMA_io_roundingMode = io_roundingMode; // @[FP64MatrixMulBlock.scala 46:30]
  assign dotFMA_io_detectTininess = io_detectTininess; // @[FP64MatrixMulBlock.scala 47:32]
  assign secondProduct_1_io_a = {_aRec_0_1_T_6,aRec_0_1_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign secondProduct_1_io_b = {_bRec_1_1_T_6,bRec_1_1_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign secondProduct_1_io_roundingMode = io_roundingMode; // @[FP64MatrixMulBlock.scala 37:37]
  assign secondProduct_1_io_detectTininess = io_detectTininess; // @[FP64MatrixMulBlock.scala 38:39]
  assign dotFMA_1_io_a = {_aRec_0_0_T_6,aRec_0_0_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign dotFMA_1_io_b = {_bRec_0_1_T_6,bRec_0_1_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign dotFMA_1_io_c = secondProduct_1_io_out; // @[FP64MatrixMulBlock.scala 45:19]
  assign dotFMA_1_io_roundingMode = io_roundingMode; // @[FP64MatrixMulBlock.scala 46:30]
  assign dotFMA_1_io_detectTininess = io_detectTininess; // @[FP64MatrixMulBlock.scala 47:32]
  assign secondProduct_2_io_a = {_aRec_1_1_T_6,aRec_1_1_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign secondProduct_2_io_b = {_bRec_1_0_T_6,bRec_1_0_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign secondProduct_2_io_roundingMode = io_roundingMode; // @[FP64MatrixMulBlock.scala 37:37]
  assign secondProduct_2_io_detectTininess = io_detectTininess; // @[FP64MatrixMulBlock.scala 38:39]
  assign dotFMA_2_io_a = {_aRec_1_0_T_6,aRec_1_0_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign dotFMA_2_io_b = {_bRec_0_0_T_6,bRec_0_0_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign dotFMA_2_io_c = secondProduct_2_io_out; // @[FP64MatrixMulBlock.scala 45:19]
  assign dotFMA_2_io_roundingMode = io_roundingMode; // @[FP64MatrixMulBlock.scala 46:30]
  assign dotFMA_2_io_detectTininess = io_detectTininess; // @[FP64MatrixMulBlock.scala 47:32]
  assign secondProduct_3_io_a = {_aRec_1_1_T_6,aRec_1_1_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign secondProduct_3_io_b = {_bRec_1_1_T_6,bRec_1_1_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign secondProduct_3_io_roundingMode = io_roundingMode; // @[FP64MatrixMulBlock.scala 37:37]
  assign secondProduct_3_io_detectTininess = io_detectTininess; // @[FP64MatrixMulBlock.scala 38:39]
  assign dotFMA_3_io_a = {_aRec_1_0_T_6,aRec_1_0_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign dotFMA_3_io_b = {_bRec_0_1_T_6,bRec_0_1_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign dotFMA_3_io_c = secondProduct_3_io_out; // @[FP64MatrixMulBlock.scala 45:19]
  assign dotFMA_3_io_roundingMode = io_roundingMode; // @[FP64MatrixMulBlock.scala 46:30]
  assign dotFMA_3_io_detectTininess = io_detectTininess; // @[FP64MatrixMulBlock.scala 47:32]
endmodule


