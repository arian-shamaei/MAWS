module MulFullRawFN(
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
  wire  notSigNaN_invalidExc = io_a_isInf & io_b_isZero | io_a_isZero & io_b_isInf; // @[MulRecFN.scala 58:60]
  wire [12:0] _common_sExpOut_T_2 = $signed(io_a_sExp) + $signed(io_b_sExp); // @[MulRecFN.scala 62:36]
  wire [107:0] _common_sigOut_T = io_a_sig * io_b_sig; // @[MulRecFN.scala 63:35]
  wire  _io_invalidExc_T_2 = io_a_isNaN & ~io_a_sig[51]; // @[common.scala 82:46]
  wire  _io_invalidExc_T_5 = io_b_isNaN & ~io_b_sig[51]; // @[common.scala 82:46]
  assign io_invalidExc = _io_invalidExc_T_2 | _io_invalidExc_T_5 | notSigNaN_invalidExc; // @[MulRecFN.scala 66:71]
  assign io_rawOut_isNaN = io_a_isNaN | io_b_isNaN; // @[MulRecFN.scala 70:35]
  assign io_rawOut_isInf = io_a_isInf | io_b_isInf; // @[MulRecFN.scala 59:38]
  assign io_rawOut_isZero = io_a_isZero | io_b_isZero; // @[MulRecFN.scala 60:40]
  assign io_rawOut_sign = io_a_sign ^ io_b_sign; // @[MulRecFN.scala 61:36]
  assign io_rawOut_sExp = $signed(_common_sExpOut_T_2) - 13'sh800; // @[MulRecFN.scala 62:48]
  assign io_rawOut_sig = _common_sigOut_T[105:0]; // @[MulRecFN.scala 63:46]
endmodule
module MulRawFN(
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
  wire  mulFullRaw_io_a_isNaN; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_a_isInf; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_a_isZero; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_a_sign; // @[MulRecFN.scala 84:28]
  wire [12:0] mulFullRaw_io_a_sExp; // @[MulRecFN.scala 84:28]
  wire [53:0] mulFullRaw_io_a_sig; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_isNaN; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_isInf; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_isZero; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_sign; // @[MulRecFN.scala 84:28]
  wire [12:0] mulFullRaw_io_b_sExp; // @[MulRecFN.scala 84:28]
  wire [53:0] mulFullRaw_io_b_sig; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_invalidExc; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_isNaN; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_isInf; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_isZero; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_sign; // @[MulRecFN.scala 84:28]
  wire [12:0] mulFullRaw_io_rawOut_sExp; // @[MulRecFN.scala 84:28]
  wire [105:0] mulFullRaw_io_rawOut_sig; // @[MulRecFN.scala 84:28]
  wire  _io_rawOut_sig_T_2 = |mulFullRaw_io_rawOut_sig[50:0]; // @[MulRecFN.scala 93:55]
  MulFullRawFN mulFullRaw ( // @[MulRecFN.scala 84:28]
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
  assign io_invalidExc = mulFullRaw_io_invalidExc; // @[MulRecFN.scala 89:19]
  assign io_rawOut_isNaN = mulFullRaw_io_rawOut_isNaN; // @[MulRecFN.scala 90:15]
  assign io_rawOut_isInf = mulFullRaw_io_rawOut_isInf; // @[MulRecFN.scala 90:15]
  assign io_rawOut_isZero = mulFullRaw_io_rawOut_isZero; // @[MulRecFN.scala 90:15]
  assign io_rawOut_sign = mulFullRaw_io_rawOut_sign; // @[MulRecFN.scala 90:15]
  assign io_rawOut_sExp = mulFullRaw_io_rawOut_sExp; // @[MulRecFN.scala 90:15]
  assign io_rawOut_sig = {mulFullRaw_io_rawOut_sig[105:51],_io_rawOut_sig_T_2}; // @[Cat.scala 33:92]
  assign mulFullRaw_io_a_isNaN = io_a_isNaN; // @[MulRecFN.scala 86:21]
  assign mulFullRaw_io_a_isInf = io_a_isInf; // @[MulRecFN.scala 86:21]
  assign mulFullRaw_io_a_isZero = io_a_isZero; // @[MulRecFN.scala 86:21]
  assign mulFullRaw_io_a_sign = io_a_sign; // @[MulRecFN.scala 86:21]
  assign mulFullRaw_io_a_sExp = io_a_sExp; // @[MulRecFN.scala 86:21]
  assign mulFullRaw_io_a_sig = io_a_sig; // @[MulRecFN.scala 86:21]
  assign mulFullRaw_io_b_isNaN = io_b_isNaN; // @[MulRecFN.scala 87:21]
  assign mulFullRaw_io_b_isInf = io_b_isInf; // @[MulRecFN.scala 87:21]
  assign mulFullRaw_io_b_isZero = io_b_isZero; // @[MulRecFN.scala 87:21]
  assign mulFullRaw_io_b_sign = io_b_sign; // @[MulRecFN.scala 87:21]
  assign mulFullRaw_io_b_sExp = io_b_sExp; // @[MulRecFN.scala 87:21]
  assign mulFullRaw_io_b_sig = io_b_sig; // @[MulRecFN.scala 87:21]
endmodule
module RoundAnyRawFNToRecFN_ie11_is55_oe11_os53(
  input         io_invalidExc,
  input         io_in_isNaN,
  input         io_in_isInf,
  input         io_in_isZero,
  input         io_in_sign,
  input  [12:0] io_in_sExp,
  input  [55:0] io_in_sig,
  input  [2:0]  io_roundingMode,
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
  wire [1:0] _common_underflow_T = io_in_sExp[12:11]; // @[RoundAnyRawFNToRecFN.scala 220:49]
  wire  _common_underflow_T_5 = doShiftSigDown1 ? roundMask[3] : roundMask[2]; // @[RoundAnyRawFNToRecFN.scala 221:30]
  wire  _common_underflow_T_6 = anyRound & $signed(_common_underflow_T) <= 2'sh0 & _common_underflow_T_5; // @[RoundAnyRawFNToRecFN.scala 220:72]
  wire  common_underflow = common_totalUnderflow | _common_underflow_T_6; // @[RoundAnyRawFNToRecFN.scala 217:40]
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
module RoundRawFNToRecFN_e11_s53(
  input         io_invalidExc,
  input         io_in_isNaN,
  input         io_in_isInf,
  input         io_in_isZero,
  input         io_in_sign,
  input  [12:0] io_in_sExp,
  input  [55:0] io_in_sig,
  input  [2:0]  io_roundingMode,
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
  wire [64:0] roundAnyRawFNToRecFN_io_out; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire [4:0] roundAnyRawFNToRecFN_io_exceptionFlags; // @[RoundAnyRawFNToRecFN.scala 310:15]
  RoundAnyRawFNToRecFN_ie11_is55_oe11_os53 roundAnyRawFNToRecFN ( // @[RoundAnyRawFNToRecFN.scala 310:15]
    .io_invalidExc(roundAnyRawFNToRecFN_io_invalidExc),
    .io_in_isNaN(roundAnyRawFNToRecFN_io_in_isNaN),
    .io_in_isInf(roundAnyRawFNToRecFN_io_in_isInf),
    .io_in_isZero(roundAnyRawFNToRecFN_io_in_isZero),
    .io_in_sign(roundAnyRawFNToRecFN_io_in_sign),
    .io_in_sExp(roundAnyRawFNToRecFN_io_in_sExp),
    .io_in_sig(roundAnyRawFNToRecFN_io_in_sig),
    .io_roundingMode(roundAnyRawFNToRecFN_io_roundingMode),
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
endmodule
module MulRecFN(
  input  [64:0] io_a,
  input  [64:0] io_b,
  input  [2:0]  io_roundingMode,
  output [64:0] io_out,
  output [4:0]  io_exceptionFlags
);
  wire  mulRawFN__io_a_isNaN; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_a_isInf; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_a_isZero; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_a_sign; // @[MulRecFN.scala 113:26]
  wire [12:0] mulRawFN__io_a_sExp; // @[MulRecFN.scala 113:26]
  wire [53:0] mulRawFN__io_a_sig; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_b_isNaN; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_b_isInf; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_b_isZero; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_b_sign; // @[MulRecFN.scala 113:26]
  wire [12:0] mulRawFN__io_b_sExp; // @[MulRecFN.scala 113:26]
  wire [53:0] mulRawFN__io_b_sig; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_invalidExc; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_rawOut_isNaN; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_rawOut_isInf; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_rawOut_isZero; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_rawOut_sign; // @[MulRecFN.scala 113:26]
  wire [12:0] mulRawFN__io_rawOut_sExp; // @[MulRecFN.scala 113:26]
  wire [55:0] mulRawFN__io_rawOut_sig; // @[MulRecFN.scala 113:26]
  wire  roundRawFNToRecFN_io_invalidExc; // @[MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_isNaN; // @[MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_isInf; // @[MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_isZero; // @[MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_sign; // @[MulRecFN.scala 121:15]
  wire [12:0] roundRawFNToRecFN_io_in_sExp; // @[MulRecFN.scala 121:15]
  wire [55:0] roundRawFNToRecFN_io_in_sig; // @[MulRecFN.scala 121:15]
  wire [2:0] roundRawFNToRecFN_io_roundingMode; // @[MulRecFN.scala 121:15]
  wire [64:0] roundRawFNToRecFN_io_out; // @[MulRecFN.scala 121:15]
  wire [4:0] roundRawFNToRecFN_io_exceptionFlags; // @[MulRecFN.scala 121:15]
  wire [11:0] mulRawFN_io_a_exp = io_a[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  mulRawFN_io_a_isZero = mulRawFN_io_a_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  mulRawFN_io_a_isSpecial = mulRawFN_io_a_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  _mulRawFN_io_a_out_sig_T = ~mulRawFN_io_a_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [1:0] _mulRawFN_io_a_out_sig_T_1 = {1'h0,_mulRawFN_io_a_out_sig_T}; // @[rawFloatFromRecFN.scala 61:32]
  wire [11:0] mulRawFN_io_b_exp = io_b[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  mulRawFN_io_b_isZero = mulRawFN_io_b_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  mulRawFN_io_b_isSpecial = mulRawFN_io_b_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  _mulRawFN_io_b_out_sig_T = ~mulRawFN_io_b_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [1:0] _mulRawFN_io_b_out_sig_T_1 = {1'h0,_mulRawFN_io_b_out_sig_T}; // @[rawFloatFromRecFN.scala 61:32]
  MulRawFN mulRawFN_ ( // @[MulRecFN.scala 113:26]
    .io_a_isNaN(mulRawFN__io_a_isNaN),
    .io_a_isInf(mulRawFN__io_a_isInf),
    .io_a_isZero(mulRawFN__io_a_isZero),
    .io_a_sign(mulRawFN__io_a_sign),
    .io_a_sExp(mulRawFN__io_a_sExp),
    .io_a_sig(mulRawFN__io_a_sig),
    .io_b_isNaN(mulRawFN__io_b_isNaN),
    .io_b_isInf(mulRawFN__io_b_isInf),
    .io_b_isZero(mulRawFN__io_b_isZero),
    .io_b_sign(mulRawFN__io_b_sign),
    .io_b_sExp(mulRawFN__io_b_sExp),
    .io_b_sig(mulRawFN__io_b_sig),
    .io_invalidExc(mulRawFN__io_invalidExc),
    .io_rawOut_isNaN(mulRawFN__io_rawOut_isNaN),
    .io_rawOut_isInf(mulRawFN__io_rawOut_isInf),
    .io_rawOut_isZero(mulRawFN__io_rawOut_isZero),
    .io_rawOut_sign(mulRawFN__io_rawOut_sign),
    .io_rawOut_sExp(mulRawFN__io_rawOut_sExp),
    .io_rawOut_sig(mulRawFN__io_rawOut_sig)
  );
  RoundRawFNToRecFN_e11_s53 roundRawFNToRecFN ( // @[MulRecFN.scala 121:15]
    .io_invalidExc(roundRawFNToRecFN_io_invalidExc),
    .io_in_isNaN(roundRawFNToRecFN_io_in_isNaN),
    .io_in_isInf(roundRawFNToRecFN_io_in_isInf),
    .io_in_isZero(roundRawFNToRecFN_io_in_isZero),
    .io_in_sign(roundRawFNToRecFN_io_in_sign),
    .io_in_sExp(roundRawFNToRecFN_io_in_sExp),
    .io_in_sig(roundRawFNToRecFN_io_in_sig),
    .io_roundingMode(roundRawFNToRecFN_io_roundingMode),
    .io_out(roundRawFNToRecFN_io_out),
    .io_exceptionFlags(roundRawFNToRecFN_io_exceptionFlags)
  );
  assign io_out = roundRawFNToRecFN_io_out; // @[MulRecFN.scala 127:23]
  assign io_exceptionFlags = roundRawFNToRecFN_io_exceptionFlags; // @[MulRecFN.scala 128:23]
  assign mulRawFN__io_a_isNaN = mulRawFN_io_a_isSpecial & mulRawFN_io_a_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  assign mulRawFN__io_a_isInf = mulRawFN_io_a_isSpecial & ~mulRawFN_io_a_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  assign mulRawFN__io_a_isZero = mulRawFN_io_a_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign mulRawFN__io_a_sign = io_a[64]; // @[rawFloatFromRecFN.scala 59:25]
  assign mulRawFN__io_a_sExp = {1'b0,$signed(mulRawFN_io_a_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  assign mulRawFN__io_a_sig = {_mulRawFN_io_a_out_sig_T_1,io_a[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  assign mulRawFN__io_b_isNaN = mulRawFN_io_b_isSpecial & mulRawFN_io_b_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  assign mulRawFN__io_b_isInf = mulRawFN_io_b_isSpecial & ~mulRawFN_io_b_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  assign mulRawFN__io_b_isZero = mulRawFN_io_b_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign mulRawFN__io_b_sign = io_b[64]; // @[rawFloatFromRecFN.scala 59:25]
  assign mulRawFN__io_b_sExp = {1'b0,$signed(mulRawFN_io_b_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  assign mulRawFN__io_b_sig = {_mulRawFN_io_b_out_sig_T_1,io_b[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  assign roundRawFNToRecFN_io_invalidExc = mulRawFN__io_invalidExc; // @[MulRecFN.scala 122:39]
  assign roundRawFNToRecFN_io_in_isNaN = mulRawFN__io_rawOut_isNaN; // @[MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_isInf = mulRawFN__io_rawOut_isInf; // @[MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_isZero = mulRawFN__io_rawOut_isZero; // @[MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_sign = mulRawFN__io_rawOut_sign; // @[MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_sExp = mulRawFN__io_rawOut_sExp; // @[MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_sig = mulRawFN__io_rawOut_sig; // @[MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_roundingMode = io_roundingMode; // @[MulRecFN.scala 125:39]
endmodule
module ieee_fp64_mul(
  input         clock,
  input         reset,
  input         io_opSel,
  input  [63:0] io_a,
  input  [63:0] io_b,
  input  [63:0] io_c,
  input  [2:0]  io_roundingMode,
  output [63:0] io_out,
  output [4:0]  io_exceptionFlags
);
  wire [64:0] mul_f0_io_a; // @[Emitieee_fp64_mul.scala 39:22]
  wire [64:0] mul_f0_io_b; // @[Emitieee_fp64_mul.scala 39:22]
  wire [2:0] mul_f0_io_roundingMode; // @[Emitieee_fp64_mul.scala 39:22]
  wire [64:0] mul_f0_io_out; // @[Emitieee_fp64_mul.scala 39:22]
  wire [4:0] mul_f0_io_exceptionFlags; // @[Emitieee_fp64_mul.scala 39:22]
  wire  roundingMatches_0 = 3'h0 == io_roundingMode; // @[Emitieee_fp64_mul.scala 19:47]
  wire  fmt0_recA_rawIn_sign = io_a[63]; // @[rawFloatFromFN.scala 44:18]
  wire [10:0] fmt0_recA_rawIn_expIn = io_a[62:52]; // @[rawFloatFromFN.scala 45:19]
  wire [51:0] fmt0_recA_rawIn_fractIn = io_a[51:0]; // @[rawFloatFromFN.scala 46:21]
  wire  fmt0_recA_rawIn_isZeroExpIn = fmt0_recA_rawIn_expIn == 11'h0; // @[rawFloatFromFN.scala 48:30]
  wire  fmt0_recA_rawIn_isZeroFractIn = fmt0_recA_rawIn_fractIn == 52'h0; // @[rawFloatFromFN.scala 49:34]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_52 = fmt0_recA_rawIn_fractIn[1] ? 6'h32 : 6'h33; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_53 = fmt0_recA_rawIn_fractIn[2] ? 6'h31 : _fmt0_recA_rawIn_normDist_T_52; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_54 = fmt0_recA_rawIn_fractIn[3] ? 6'h30 : _fmt0_recA_rawIn_normDist_T_53; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_55 = fmt0_recA_rawIn_fractIn[4] ? 6'h2f : _fmt0_recA_rawIn_normDist_T_54; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_56 = fmt0_recA_rawIn_fractIn[5] ? 6'h2e : _fmt0_recA_rawIn_normDist_T_55; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_57 = fmt0_recA_rawIn_fractIn[6] ? 6'h2d : _fmt0_recA_rawIn_normDist_T_56; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_58 = fmt0_recA_rawIn_fractIn[7] ? 6'h2c : _fmt0_recA_rawIn_normDist_T_57; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_59 = fmt0_recA_rawIn_fractIn[8] ? 6'h2b : _fmt0_recA_rawIn_normDist_T_58; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_60 = fmt0_recA_rawIn_fractIn[9] ? 6'h2a : _fmt0_recA_rawIn_normDist_T_59; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_61 = fmt0_recA_rawIn_fractIn[10] ? 6'h29 : _fmt0_recA_rawIn_normDist_T_60; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_62 = fmt0_recA_rawIn_fractIn[11] ? 6'h28 : _fmt0_recA_rawIn_normDist_T_61; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_63 = fmt0_recA_rawIn_fractIn[12] ? 6'h27 : _fmt0_recA_rawIn_normDist_T_62; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_64 = fmt0_recA_rawIn_fractIn[13] ? 6'h26 : _fmt0_recA_rawIn_normDist_T_63; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_65 = fmt0_recA_rawIn_fractIn[14] ? 6'h25 : _fmt0_recA_rawIn_normDist_T_64; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_66 = fmt0_recA_rawIn_fractIn[15] ? 6'h24 : _fmt0_recA_rawIn_normDist_T_65; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_67 = fmt0_recA_rawIn_fractIn[16] ? 6'h23 : _fmt0_recA_rawIn_normDist_T_66; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_68 = fmt0_recA_rawIn_fractIn[17] ? 6'h22 : _fmt0_recA_rawIn_normDist_T_67; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_69 = fmt0_recA_rawIn_fractIn[18] ? 6'h21 : _fmt0_recA_rawIn_normDist_T_68; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_70 = fmt0_recA_rawIn_fractIn[19] ? 6'h20 : _fmt0_recA_rawIn_normDist_T_69; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_71 = fmt0_recA_rawIn_fractIn[20] ? 6'h1f : _fmt0_recA_rawIn_normDist_T_70; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_72 = fmt0_recA_rawIn_fractIn[21] ? 6'h1e : _fmt0_recA_rawIn_normDist_T_71; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_73 = fmt0_recA_rawIn_fractIn[22] ? 6'h1d : _fmt0_recA_rawIn_normDist_T_72; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_74 = fmt0_recA_rawIn_fractIn[23] ? 6'h1c : _fmt0_recA_rawIn_normDist_T_73; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_75 = fmt0_recA_rawIn_fractIn[24] ? 6'h1b : _fmt0_recA_rawIn_normDist_T_74; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_76 = fmt0_recA_rawIn_fractIn[25] ? 6'h1a : _fmt0_recA_rawIn_normDist_T_75; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_77 = fmt0_recA_rawIn_fractIn[26] ? 6'h19 : _fmt0_recA_rawIn_normDist_T_76; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_78 = fmt0_recA_rawIn_fractIn[27] ? 6'h18 : _fmt0_recA_rawIn_normDist_T_77; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_79 = fmt0_recA_rawIn_fractIn[28] ? 6'h17 : _fmt0_recA_rawIn_normDist_T_78; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_80 = fmt0_recA_rawIn_fractIn[29] ? 6'h16 : _fmt0_recA_rawIn_normDist_T_79; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_81 = fmt0_recA_rawIn_fractIn[30] ? 6'h15 : _fmt0_recA_rawIn_normDist_T_80; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_82 = fmt0_recA_rawIn_fractIn[31] ? 6'h14 : _fmt0_recA_rawIn_normDist_T_81; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_83 = fmt0_recA_rawIn_fractIn[32] ? 6'h13 : _fmt0_recA_rawIn_normDist_T_82; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_84 = fmt0_recA_rawIn_fractIn[33] ? 6'h12 : _fmt0_recA_rawIn_normDist_T_83; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_85 = fmt0_recA_rawIn_fractIn[34] ? 6'h11 : _fmt0_recA_rawIn_normDist_T_84; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_86 = fmt0_recA_rawIn_fractIn[35] ? 6'h10 : _fmt0_recA_rawIn_normDist_T_85; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_87 = fmt0_recA_rawIn_fractIn[36] ? 6'hf : _fmt0_recA_rawIn_normDist_T_86; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_88 = fmt0_recA_rawIn_fractIn[37] ? 6'he : _fmt0_recA_rawIn_normDist_T_87; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_89 = fmt0_recA_rawIn_fractIn[38] ? 6'hd : _fmt0_recA_rawIn_normDist_T_88; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_90 = fmt0_recA_rawIn_fractIn[39] ? 6'hc : _fmt0_recA_rawIn_normDist_T_89; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_91 = fmt0_recA_rawIn_fractIn[40] ? 6'hb : _fmt0_recA_rawIn_normDist_T_90; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_92 = fmt0_recA_rawIn_fractIn[41] ? 6'ha : _fmt0_recA_rawIn_normDist_T_91; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_93 = fmt0_recA_rawIn_fractIn[42] ? 6'h9 : _fmt0_recA_rawIn_normDist_T_92; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_94 = fmt0_recA_rawIn_fractIn[43] ? 6'h8 : _fmt0_recA_rawIn_normDist_T_93; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_95 = fmt0_recA_rawIn_fractIn[44] ? 6'h7 : _fmt0_recA_rawIn_normDist_T_94; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_96 = fmt0_recA_rawIn_fractIn[45] ? 6'h6 : _fmt0_recA_rawIn_normDist_T_95; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_97 = fmt0_recA_rawIn_fractIn[46] ? 6'h5 : _fmt0_recA_rawIn_normDist_T_96; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_98 = fmt0_recA_rawIn_fractIn[47] ? 6'h4 : _fmt0_recA_rawIn_normDist_T_97; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_99 = fmt0_recA_rawIn_fractIn[48] ? 6'h3 : _fmt0_recA_rawIn_normDist_T_98; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_100 = fmt0_recA_rawIn_fractIn[49] ? 6'h2 : _fmt0_recA_rawIn_normDist_T_99; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recA_rawIn_normDist_T_101 = fmt0_recA_rawIn_fractIn[50] ? 6'h1 : _fmt0_recA_rawIn_normDist_T_100; // @[Mux.scala 47:70]
  wire [5:0] fmt0_recA_rawIn_normDist = fmt0_recA_rawIn_fractIn[51] ? 6'h0 : _fmt0_recA_rawIn_normDist_T_101; // @[Mux.scala 47:70]
  wire [114:0] _GEN_0 = {{63'd0}, fmt0_recA_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [114:0] _fmt0_recA_rawIn_subnormFract_T = _GEN_0 << fmt0_recA_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [51:0] fmt0_recA_rawIn_subnormFract = {_fmt0_recA_rawIn_subnormFract_T[50:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [11:0] _GEN_3 = {{6'd0}, fmt0_recA_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _fmt0_recA_rawIn_adjustedExp_T = _GEN_3 ^ 12'hfff; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _fmt0_recA_rawIn_adjustedExp_T_1 = fmt0_recA_rawIn_isZeroExpIn ? _fmt0_recA_rawIn_adjustedExp_T : {{1
    'd0}, fmt0_recA_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _fmt0_recA_rawIn_adjustedExp_T_2 = fmt0_recA_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [10:0] _GEN_4 = {{9'd0}, _fmt0_recA_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [10:0] _fmt0_recA_rawIn_adjustedExp_T_3 = 11'h400 | _GEN_4; // @[rawFloatFromFN.scala 58:9]
  wire [11:0] _GEN_5 = {{1'd0}, _fmt0_recA_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [11:0] fmt0_recA_rawIn_adjustedExp = _fmt0_recA_rawIn_adjustedExp_T_1 + _GEN_5; // @[rawFloatFromFN.scala 57:9]
  wire  fmt0_recA_rawIn_isZero = fmt0_recA_rawIn_isZeroExpIn & fmt0_recA_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  fmt0_recA_rawIn_isSpecial = fmt0_recA_rawIn_adjustedExp[11:10] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  fmt0_recA_rawIn__isNaN = fmt0_recA_rawIn_isSpecial & ~fmt0_recA_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [12:0] fmt0_recA_rawIn__sExp = {1'b0,$signed(fmt0_recA_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _fmt0_recA_rawIn_out_sig_T = ~fmt0_recA_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [51:0] _fmt0_recA_rawIn_out_sig_T_2 = fmt0_recA_rawIn_isZeroExpIn ? fmt0_recA_rawIn_subnormFract :
    fmt0_recA_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [53:0] fmt0_recA_rawIn__sig = {1'h0,_fmt0_recA_rawIn_out_sig_T,_fmt0_recA_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _fmt0_recA_T_2 = fmt0_recA_rawIn_isZero ? 3'h0 : fmt0_recA_rawIn__sExp[11:9]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_6 = {{2'd0}, fmt0_recA_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _fmt0_recA_T_4 = _fmt0_recA_T_2 | _GEN_6; // @[recFNFromFN.scala 48:76]
  wire [12:0] _fmt0_recA_T_7 = {fmt0_recA_rawIn_sign,_fmt0_recA_T_4,fmt0_recA_rawIn__sExp[8:0]}; // @[recFNFromFN.scala 49:45]
  wire  fmt0_recB_rawIn_sign = io_b[63]; // @[rawFloatFromFN.scala 44:18]
  wire [10:0] fmt0_recB_rawIn_expIn = io_b[62:52]; // @[rawFloatFromFN.scala 45:19]
  wire [51:0] fmt0_recB_rawIn_fractIn = io_b[51:0]; // @[rawFloatFromFN.scala 46:21]
  wire  fmt0_recB_rawIn_isZeroExpIn = fmt0_recB_rawIn_expIn == 11'h0; // @[rawFloatFromFN.scala 48:30]
  wire  fmt0_recB_rawIn_isZeroFractIn = fmt0_recB_rawIn_fractIn == 52'h0; // @[rawFloatFromFN.scala 49:34]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_52 = fmt0_recB_rawIn_fractIn[1] ? 6'h32 : 6'h33; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_53 = fmt0_recB_rawIn_fractIn[2] ? 6'h31 : _fmt0_recB_rawIn_normDist_T_52; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_54 = fmt0_recB_rawIn_fractIn[3] ? 6'h30 : _fmt0_recB_rawIn_normDist_T_53; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_55 = fmt0_recB_rawIn_fractIn[4] ? 6'h2f : _fmt0_recB_rawIn_normDist_T_54; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_56 = fmt0_recB_rawIn_fractIn[5] ? 6'h2e : _fmt0_recB_rawIn_normDist_T_55; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_57 = fmt0_recB_rawIn_fractIn[6] ? 6'h2d : _fmt0_recB_rawIn_normDist_T_56; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_58 = fmt0_recB_rawIn_fractIn[7] ? 6'h2c : _fmt0_recB_rawIn_normDist_T_57; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_59 = fmt0_recB_rawIn_fractIn[8] ? 6'h2b : _fmt0_recB_rawIn_normDist_T_58; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_60 = fmt0_recB_rawIn_fractIn[9] ? 6'h2a : _fmt0_recB_rawIn_normDist_T_59; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_61 = fmt0_recB_rawIn_fractIn[10] ? 6'h29 : _fmt0_recB_rawIn_normDist_T_60; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_62 = fmt0_recB_rawIn_fractIn[11] ? 6'h28 : _fmt0_recB_rawIn_normDist_T_61; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_63 = fmt0_recB_rawIn_fractIn[12] ? 6'h27 : _fmt0_recB_rawIn_normDist_T_62; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_64 = fmt0_recB_rawIn_fractIn[13] ? 6'h26 : _fmt0_recB_rawIn_normDist_T_63; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_65 = fmt0_recB_rawIn_fractIn[14] ? 6'h25 : _fmt0_recB_rawIn_normDist_T_64; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_66 = fmt0_recB_rawIn_fractIn[15] ? 6'h24 : _fmt0_recB_rawIn_normDist_T_65; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_67 = fmt0_recB_rawIn_fractIn[16] ? 6'h23 : _fmt0_recB_rawIn_normDist_T_66; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_68 = fmt0_recB_rawIn_fractIn[17] ? 6'h22 : _fmt0_recB_rawIn_normDist_T_67; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_69 = fmt0_recB_rawIn_fractIn[18] ? 6'h21 : _fmt0_recB_rawIn_normDist_T_68; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_70 = fmt0_recB_rawIn_fractIn[19] ? 6'h20 : _fmt0_recB_rawIn_normDist_T_69; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_71 = fmt0_recB_rawIn_fractIn[20] ? 6'h1f : _fmt0_recB_rawIn_normDist_T_70; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_72 = fmt0_recB_rawIn_fractIn[21] ? 6'h1e : _fmt0_recB_rawIn_normDist_T_71; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_73 = fmt0_recB_rawIn_fractIn[22] ? 6'h1d : _fmt0_recB_rawIn_normDist_T_72; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_74 = fmt0_recB_rawIn_fractIn[23] ? 6'h1c : _fmt0_recB_rawIn_normDist_T_73; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_75 = fmt0_recB_rawIn_fractIn[24] ? 6'h1b : _fmt0_recB_rawIn_normDist_T_74; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_76 = fmt0_recB_rawIn_fractIn[25] ? 6'h1a : _fmt0_recB_rawIn_normDist_T_75; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_77 = fmt0_recB_rawIn_fractIn[26] ? 6'h19 : _fmt0_recB_rawIn_normDist_T_76; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_78 = fmt0_recB_rawIn_fractIn[27] ? 6'h18 : _fmt0_recB_rawIn_normDist_T_77; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_79 = fmt0_recB_rawIn_fractIn[28] ? 6'h17 : _fmt0_recB_rawIn_normDist_T_78; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_80 = fmt0_recB_rawIn_fractIn[29] ? 6'h16 : _fmt0_recB_rawIn_normDist_T_79; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_81 = fmt0_recB_rawIn_fractIn[30] ? 6'h15 : _fmt0_recB_rawIn_normDist_T_80; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_82 = fmt0_recB_rawIn_fractIn[31] ? 6'h14 : _fmt0_recB_rawIn_normDist_T_81; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_83 = fmt0_recB_rawIn_fractIn[32] ? 6'h13 : _fmt0_recB_rawIn_normDist_T_82; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_84 = fmt0_recB_rawIn_fractIn[33] ? 6'h12 : _fmt0_recB_rawIn_normDist_T_83; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_85 = fmt0_recB_rawIn_fractIn[34] ? 6'h11 : _fmt0_recB_rawIn_normDist_T_84; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_86 = fmt0_recB_rawIn_fractIn[35] ? 6'h10 : _fmt0_recB_rawIn_normDist_T_85; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_87 = fmt0_recB_rawIn_fractIn[36] ? 6'hf : _fmt0_recB_rawIn_normDist_T_86; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_88 = fmt0_recB_rawIn_fractIn[37] ? 6'he : _fmt0_recB_rawIn_normDist_T_87; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_89 = fmt0_recB_rawIn_fractIn[38] ? 6'hd : _fmt0_recB_rawIn_normDist_T_88; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_90 = fmt0_recB_rawIn_fractIn[39] ? 6'hc : _fmt0_recB_rawIn_normDist_T_89; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_91 = fmt0_recB_rawIn_fractIn[40] ? 6'hb : _fmt0_recB_rawIn_normDist_T_90; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_92 = fmt0_recB_rawIn_fractIn[41] ? 6'ha : _fmt0_recB_rawIn_normDist_T_91; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_93 = fmt0_recB_rawIn_fractIn[42] ? 6'h9 : _fmt0_recB_rawIn_normDist_T_92; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_94 = fmt0_recB_rawIn_fractIn[43] ? 6'h8 : _fmt0_recB_rawIn_normDist_T_93; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_95 = fmt0_recB_rawIn_fractIn[44] ? 6'h7 : _fmt0_recB_rawIn_normDist_T_94; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_96 = fmt0_recB_rawIn_fractIn[45] ? 6'h6 : _fmt0_recB_rawIn_normDist_T_95; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_97 = fmt0_recB_rawIn_fractIn[46] ? 6'h5 : _fmt0_recB_rawIn_normDist_T_96; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_98 = fmt0_recB_rawIn_fractIn[47] ? 6'h4 : _fmt0_recB_rawIn_normDist_T_97; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_99 = fmt0_recB_rawIn_fractIn[48] ? 6'h3 : _fmt0_recB_rawIn_normDist_T_98; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_100 = fmt0_recB_rawIn_fractIn[49] ? 6'h2 : _fmt0_recB_rawIn_normDist_T_99; // @[Mux.scala 47:70]
  wire [5:0] _fmt0_recB_rawIn_normDist_T_101 = fmt0_recB_rawIn_fractIn[50] ? 6'h1 : _fmt0_recB_rawIn_normDist_T_100; // @[Mux.scala 47:70]
  wire [5:0] fmt0_recB_rawIn_normDist = fmt0_recB_rawIn_fractIn[51] ? 6'h0 : _fmt0_recB_rawIn_normDist_T_101; // @[Mux.scala 47:70]
  wire [114:0] _GEN_1 = {{63'd0}, fmt0_recB_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [114:0] _fmt0_recB_rawIn_subnormFract_T = _GEN_1 << fmt0_recB_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [51:0] fmt0_recB_rawIn_subnormFract = {_fmt0_recB_rawIn_subnormFract_T[50:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [11:0] _GEN_7 = {{6'd0}, fmt0_recB_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _fmt0_recB_rawIn_adjustedExp_T = _GEN_7 ^ 12'hfff; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _fmt0_recB_rawIn_adjustedExp_T_1 = fmt0_recB_rawIn_isZeroExpIn ? _fmt0_recB_rawIn_adjustedExp_T : {{1
    'd0}, fmt0_recB_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _fmt0_recB_rawIn_adjustedExp_T_2 = fmt0_recB_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [10:0] _GEN_8 = {{9'd0}, _fmt0_recB_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [10:0] _fmt0_recB_rawIn_adjustedExp_T_3 = 11'h400 | _GEN_8; // @[rawFloatFromFN.scala 58:9]
  wire [11:0] _GEN_9 = {{1'd0}, _fmt0_recB_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [11:0] fmt0_recB_rawIn_adjustedExp = _fmt0_recB_rawIn_adjustedExp_T_1 + _GEN_9; // @[rawFloatFromFN.scala 57:9]
  wire  fmt0_recB_rawIn_isZero = fmt0_recB_rawIn_isZeroExpIn & fmt0_recB_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  fmt0_recB_rawIn_isSpecial = fmt0_recB_rawIn_adjustedExp[11:10] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  fmt0_recB_rawIn__isNaN = fmt0_recB_rawIn_isSpecial & ~fmt0_recB_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [12:0] fmt0_recB_rawIn__sExp = {1'b0,$signed(fmt0_recB_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _fmt0_recB_rawIn_out_sig_T = ~fmt0_recB_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [51:0] _fmt0_recB_rawIn_out_sig_T_2 = fmt0_recB_rawIn_isZeroExpIn ? fmt0_recB_rawIn_subnormFract :
    fmt0_recB_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [53:0] fmt0_recB_rawIn__sig = {1'h0,_fmt0_recB_rawIn_out_sig_T,_fmt0_recB_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _fmt0_recB_T_2 = fmt0_recB_rawIn_isZero ? 3'h0 : fmt0_recB_rawIn__sExp[11:9]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_10 = {{2'd0}, fmt0_recB_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _fmt0_recB_T_4 = _fmt0_recB_T_2 | _GEN_10; // @[recFNFromFN.scala 48:76]
  wire [12:0] _fmt0_recB_T_7 = {fmt0_recB_rawIn_sign,_fmt0_recB_T_4,fmt0_recB_rawIn__sExp[8:0]}; // @[recFNFromFN.scala 49:45]
  wire  outValid = ~io_opSel; // @[Emitieee_fp64_mul.scala 50:20]
  wire [64:0] outRec = outValid ? mul_f0_io_out : 65'h0; // @[Emitieee_fp64_mul.scala 50:20 52:16 44:27]
  wire  recNonZero = |outRec; // @[Emitieee_fp64_mul.scala 58:27]
  wire [11:0] outIeee_rawIn_exp = outRec[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  outIeee_rawIn_isZero = outIeee_rawIn_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  outIeee_rawIn_isSpecial = outIeee_rawIn_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  outIeee_rawIn__isNaN = outIeee_rawIn_isSpecial & outIeee_rawIn_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  wire  outIeee_rawIn__isInf = outIeee_rawIn_isSpecial & ~outIeee_rawIn_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  wire  outIeee_rawIn__sign = outRec[64]; // @[rawFloatFromRecFN.scala 59:25]
  wire [12:0] outIeee_rawIn__sExp = {1'b0,$signed(outIeee_rawIn_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _outIeee_rawIn_out_sig_T = ~outIeee_rawIn_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [53:0] outIeee_rawIn__sig = {1'h0,_outIeee_rawIn_out_sig_T,outRec[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  wire  outIeee_isSubnormal = $signed(outIeee_rawIn__sExp) < 13'sh402; // @[fNFromRecFN.scala 51:38]
  wire [5:0] outIeee_denormShiftDist = 6'h1 - outIeee_rawIn__sExp[5:0]; // @[fNFromRecFN.scala 52:35]
  wire [52:0] _outIeee_denormFract_T_1 = outIeee_rawIn__sig[53:1] >> outIeee_denormShiftDist; // @[fNFromRecFN.scala 53:42]
  wire [51:0] outIeee_denormFract = _outIeee_denormFract_T_1[51:0]; // @[fNFromRecFN.scala 53:60]
  wire [10:0] _outIeee_expOut_T_2 = outIeee_rawIn__sExp[10:0] - 11'h401; // @[fNFromRecFN.scala 58:45]
  wire [10:0] _outIeee_expOut_T_3 = outIeee_isSubnormal ? 11'h0 : _outIeee_expOut_T_2; // @[fNFromRecFN.scala 56:16]
  wire  _outIeee_expOut_T_4 = outIeee_rawIn__isNaN | outIeee_rawIn__isInf; // @[fNFromRecFN.scala 60:44]
  wire [10:0] _outIeee_expOut_T_6 = _outIeee_expOut_T_4 ? 11'h7ff : 11'h0; // @[Bitwise.scala 77:12]
  wire [10:0] outIeee_expOut = _outIeee_expOut_T_3 | _outIeee_expOut_T_6; // @[fNFromRecFN.scala 60:15]
  wire [51:0] _outIeee_fractOut_T_1 = outIeee_rawIn__isInf ? 52'h0 : outIeee_rawIn__sig[51:0]; // @[fNFromRecFN.scala 64:20]
  wire [51:0] outIeee_fractOut = outIeee_isSubnormal ? outIeee_denormFract : _outIeee_fractOut_T_1; // @[fNFromRecFN.scala 62:16]
  wire [63:0] outIeee = {outIeee_rawIn__sign,outIeee_expOut,outIeee_fractOut}; // @[Cat.scala 33:92]
  MulRecFN mul_f0 ( // @[Emitieee_fp64_mul.scala 39:22]
    .io_a(mul_f0_io_a),
    .io_b(mul_f0_io_b),
    .io_roundingMode(mul_f0_io_roundingMode),
    .io_out(mul_f0_io_out),
    .io_exceptionFlags(mul_f0_io_exceptionFlags)
  );
  assign io_out = recNonZero ? outIeee : 64'h0; // @[Emitieee_fp64_mul.scala 61:16]
  assign io_exceptionFlags = outValid ? mul_f0_io_exceptionFlags : 5'h0; // @[Emitieee_fp64_mul.scala 50:20 53:16 46:27]
  assign mul_f0_io_a = {_fmt0_recA_T_7,fmt0_recA_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign mul_f0_io_b = {_fmt0_recB_T_7,fmt0_recB_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign mul_f0_io_roundingMode = roundingMatches_0 ? io_roundingMode : 3'h0; // @[Emitieee_fp64_mul.scala 21:25]
endmodule
