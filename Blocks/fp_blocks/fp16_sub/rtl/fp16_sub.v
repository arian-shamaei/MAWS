module AddRawFN(
  input         io_subOp,
  input         io_a_isNaN,
  input         io_a_isInf,
  input         io_a_isZero,
  input         io_a_sign,
  input  [6:0]  io_a_sExp,
  input  [11:0] io_a_sig,
  input         io_b_isNaN,
  input         io_b_isInf,
  input         io_b_isZero,
  input         io_b_sign,
  input  [6:0]  io_b_sExp,
  input  [11:0] io_b_sig,
  input  [2:0]  io_roundingMode,
  output        io_invalidExc,
  output        io_rawOut_isNaN,
  output        io_rawOut_isInf,
  output        io_rawOut_isZero,
  output        io_rawOut_sign,
  output [6:0]  io_rawOut_sExp,
  output [13:0] io_rawOut_sig
);
  wire  effSignB = io_b_sign ^ io_subOp; // @[AddRecFN.scala 60:30]
  wire  eqSigns = io_a_sign == effSignB; // @[AddRecFN.scala 61:29]
  wire  notEqSigns_signZero = io_roundingMode == 3'h2; // @[AddRecFN.scala 62:47]
  wire [6:0] sDiffExps = $signed(io_a_sExp) - $signed(io_b_sExp); // @[AddRecFN.scala 63:31]
  wire  _modNatAlignDist_T = $signed(sDiffExps) < 7'sh0; // @[AddRecFN.scala 64:41]
  wire [6:0] _modNatAlignDist_T_3 = $signed(io_b_sExp) - $signed(io_a_sExp); // @[AddRecFN.scala 64:58]
  wire [6:0] _modNatAlignDist_T_4 = $signed(sDiffExps) < 7'sh0 ? $signed(_modNatAlignDist_T_3) : $signed(sDiffExps); // @[AddRecFN.scala 64:30]
  wire [3:0] modNatAlignDist = _modNatAlignDist_T_4[3:0]; // @[AddRecFN.scala 64:81]
  wire [2:0] _isMaxAlign_T = sDiffExps[6:4]; // @[AddRecFN.scala 66:19]
  wire  _isMaxAlign_T_6 = $signed(_isMaxAlign_T) != -3'sh1 | sDiffExps[3:0] == 4'h0; // @[AddRecFN.scala 67:51]
  wire  isMaxAlign = $signed(_isMaxAlign_T) != 3'sh0 & _isMaxAlign_T_6; // @[AddRecFN.scala 66:45]
  wire [3:0] alignDist = isMaxAlign ? 4'hf : modNatAlignDist; // @[AddRecFN.scala 68:24]
  wire  _closeSubMags_T = ~eqSigns; // @[AddRecFN.scala 69:24]
  wire  closeSubMags = ~eqSigns & ~isMaxAlign & modNatAlignDist <= 4'h1; // @[AddRecFN.scala 69:48]
  wire  _close_alignedSigA_T = 7'sh0 <= $signed(sDiffExps); // @[AddRecFN.scala 73:18]
  wire [13:0] _close_alignedSigA_T_3 = {io_a_sig, 2'h0}; // @[AddRecFN.scala 73:58]
  wire [13:0] _close_alignedSigA_T_4 = 7'sh0 <= $signed(sDiffExps) & sDiffExps[0] ? _close_alignedSigA_T_3 : 14'h0; // @[AddRecFN.scala 73:12]
  wire [12:0] _close_alignedSigA_T_9 = {io_a_sig, 1'h0}; // @[AddRecFN.scala 74:58]
  wire [12:0] _close_alignedSigA_T_10 = _close_alignedSigA_T & ~sDiffExps[0] ? _close_alignedSigA_T_9 : 13'h0; // @[AddRecFN.scala 74:12]
  wire [13:0] _GEN_0 = {{1'd0}, _close_alignedSigA_T_10}; // @[AddRecFN.scala 73:68]
  wire [13:0] _close_alignedSigA_T_11 = _close_alignedSigA_T_4 | _GEN_0; // @[AddRecFN.scala 73:68]
  wire [11:0] _close_alignedSigA_T_13 = _modNatAlignDist_T ? io_a_sig : 12'h0; // @[AddRecFN.scala 75:12]
  wire [13:0] _GEN_1 = {{2'd0}, _close_alignedSigA_T_13}; // @[AddRecFN.scala 74:68]
  wire [13:0] _close_sSigSum_T = _close_alignedSigA_T_11 | _GEN_1; // @[AddRecFN.scala 76:43]
  wire [12:0] _close_sSigSum_T_2 = {io_b_sig, 1'h0}; // @[AddRecFN.scala 76:66]
  wire [13:0] _GEN_2 = {{1{_close_sSigSum_T_2[12]}},_close_sSigSum_T_2}; // @[AddRecFN.scala 76:50]
  wire [13:0] close_sSigSum = $signed(_close_sSigSum_T) - $signed(_GEN_2); // @[AddRecFN.scala 76:50]
  wire  _close_sigSum_T = $signed(close_sSigSum) < 14'sh0; // @[AddRecFN.scala 77:42]
  wire [13:0] _close_sigSum_T_3 = 14'sh0 - $signed(close_sSigSum); // @[AddRecFN.scala 77:49]
  wire [13:0] _close_sigSum_T_4 = $signed(close_sSigSum) < 14'sh0 ? $signed(_close_sigSum_T_3) : $signed(close_sSigSum); // @[AddRecFN.scala 77:27]
  wire [12:0] close_sigSum = _close_sigSum_T_4[12:0]; // @[AddRecFN.scala 77:79]
  wire [13:0] close_adjustedSigSum = {close_sigSum, 1'h0}; // @[AddRecFN.scala 78:44]
  wire  close_reduced2SigSum_reducedVec_0 = |close_adjustedSigSum[1:0]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_1 = |close_adjustedSigSum[3:2]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_2 = |close_adjustedSigSum[5:4]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_3 = |close_adjustedSigSum[7:6]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_4 = |close_adjustedSigSum[9:8]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_5 = |close_adjustedSigSum[11:10]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_6 = |close_adjustedSigSum[13:12]; // @[primitives.scala 106:57]
  wire [6:0] close_reduced2SigSum = {close_reduced2SigSum_reducedVec_6,close_reduced2SigSum_reducedVec_5,
    close_reduced2SigSum_reducedVec_4,close_reduced2SigSum_reducedVec_3,close_reduced2SigSum_reducedVec_2,
    close_reduced2SigSum_reducedVec_1,close_reduced2SigSum_reducedVec_0}; // @[primitives.scala 107:20]
  wire [2:0] _close_normDistReduced2_T_7 = close_reduced2SigSum[1] ? 3'h5 : 3'h6; // @[Mux.scala 47:70]
  wire [2:0] _close_normDistReduced2_T_8 = close_reduced2SigSum[2] ? 3'h4 : _close_normDistReduced2_T_7; // @[Mux.scala 47:70]
  wire [2:0] _close_normDistReduced2_T_9 = close_reduced2SigSum[3] ? 3'h3 : _close_normDistReduced2_T_8; // @[Mux.scala 47:70]
  wire [2:0] _close_normDistReduced2_T_10 = close_reduced2SigSum[4] ? 3'h2 : _close_normDistReduced2_T_9; // @[Mux.scala 47:70]
  wire [2:0] _close_normDistReduced2_T_11 = close_reduced2SigSum[5] ? 3'h1 : _close_normDistReduced2_T_10; // @[Mux.scala 47:70]
  wire [2:0] close_normDistReduced2 = close_reduced2SigSum[6] ? 3'h0 : _close_normDistReduced2_T_11; // @[Mux.scala 47:70]
  wire [3:0] close_nearNormDist = {close_normDistReduced2, 1'h0}; // @[AddRecFN.scala 81:53]
  wire [27:0] _GEN_7 = {{15'd0}, close_sigSum}; // @[AddRecFN.scala 82:38]
  wire [27:0] _close_sigOut_T = _GEN_7 << close_nearNormDist; // @[AddRecFN.scala 82:38]
  wire [28:0] _close_sigOut_T_1 = {_close_sigOut_T, 1'h0}; // @[AddRecFN.scala 82:59]
  wire [13:0] close_sigOut = _close_sigOut_T_1[13:0]; // @[AddRecFN.scala 82:63]
  wire  close_totalCancellation = ~(|close_sigOut[13:12]); // @[AddRecFN.scala 83:35]
  wire  close_notTotalCancellation_signOut = io_a_sign ^ _close_sigSum_T; // @[AddRecFN.scala 84:56]
  wire  far_signOut = _modNatAlignDist_T ? effSignB : io_a_sign; // @[AddRecFN.scala 87:26]
  wire [11:0] _far_sigLarger_T_1 = _modNatAlignDist_T ? io_b_sig : io_a_sig; // @[AddRecFN.scala 88:29]
  wire [10:0] far_sigLarger = _far_sigLarger_T_1[10:0]; // @[AddRecFN.scala 88:66]
  wire [11:0] _far_sigSmaller_T_1 = _modNatAlignDist_T ? io_a_sig : io_b_sig; // @[AddRecFN.scala 89:29]
  wire [10:0] far_sigSmaller = _far_sigSmaller_T_1[10:0]; // @[AddRecFN.scala 89:66]
  wire [15:0] _far_mainAlignedSigSmaller_T = {far_sigSmaller, 5'h0}; // @[AddRecFN.scala 90:52]
  wire [15:0] far_mainAlignedSigSmaller = _far_mainAlignedSigSmaller_T >> alignDist; // @[AddRecFN.scala 90:56]
  wire [12:0] _far_reduced4SigSmaller_T = {far_sigSmaller, 2'h0}; // @[AddRecFN.scala 91:60]
  wire  far_reduced4SigSmaller_reducedVec_0 = |_far_reduced4SigSmaller_T[3:0]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_1 = |_far_reduced4SigSmaller_T[7:4]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_2 = |_far_reduced4SigSmaller_T[11:8]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_3 = |_far_reduced4SigSmaller_T[12]; // @[primitives.scala 123:57]
  wire [3:0] far_reduced4SigSmaller = {far_reduced4SigSmaller_reducedVec_3,far_reduced4SigSmaller_reducedVec_2,
    far_reduced4SigSmaller_reducedVec_1,far_reduced4SigSmaller_reducedVec_0}; // @[primitives.scala 124:20]
  wire [4:0] far_roundExtraMask_shift = 5'sh10 >>> alignDist[3:2]; // @[primitives.scala 76:56]
  wire [3:0] far_roundExtraMask = {far_roundExtraMask_shift[0],far_roundExtraMask_shift[1],far_roundExtraMask_shift[2],
    far_roundExtraMask_shift[3]}; // @[Cat.scala 33:92]
  wire [3:0] _far_alignedSigSmaller_T_3 = far_reduced4SigSmaller & far_roundExtraMask; // @[AddRecFN.scala 95:76]
  wire  _far_alignedSigSmaller_T_5 = |far_mainAlignedSigSmaller[2:0] | |_far_alignedSigSmaller_T_3; // @[AddRecFN.scala 95:49]
  wire [13:0] far_alignedSigSmaller = {far_mainAlignedSigSmaller[15:3],_far_alignedSigSmaller_T_5}; // @[Cat.scala 33:92]
  wire [13:0] _far_negAlignedSigSmaller_T = ~far_alignedSigSmaller; // @[AddRecFN.scala 97:62]
  wire [14:0] _far_negAlignedSigSmaller_T_1 = {1'h1,_far_negAlignedSigSmaller_T}; // @[Cat.scala 33:92]
  wire [14:0] far_negAlignedSigSmaller = _closeSubMags_T ? _far_negAlignedSigSmaller_T_1 : {{1'd0},
    far_alignedSigSmaller}; // @[AddRecFN.scala 97:39]
  wire [13:0] _far_sigSum_T = {far_sigLarger, 3'h0}; // @[AddRecFN.scala 98:36]
  wire [14:0] _GEN_3 = {{1'd0}, _far_sigSum_T}; // @[AddRecFN.scala 98:41]
  wire [14:0] _far_sigSum_T_2 = _GEN_3 + far_negAlignedSigSmaller; // @[AddRecFN.scala 98:41]
  wire [14:0] _GEN_4 = {{14'd0}, _closeSubMags_T}; // @[AddRecFN.scala 98:68]
  wire [14:0] far_sigSum = _far_sigSum_T_2 + _GEN_4; // @[AddRecFN.scala 98:68]
  wire [13:0] _GEN_5 = {{13'd0}, far_sigSum[0]}; // @[AddRecFN.scala 99:67]
  wire [13:0] _far_sigOut_T_2 = far_sigSum[14:1] | _GEN_5; // @[AddRecFN.scala 99:67]
  wire [14:0] _far_sigOut_T_3 = _closeSubMags_T ? far_sigSum : {{1'd0}, _far_sigOut_T_2}; // @[AddRecFN.scala 99:25]
  wire [13:0] far_sigOut = _far_sigOut_T_3[13:0]; // @[AddRecFN.scala 99:83]
  wire  notSigNaN_invalidExc = io_a_isInf & io_b_isInf & _closeSubMags_T; // @[AddRecFN.scala 102:57]
  wire  notNaN_isInfOut = io_a_isInf | io_b_isInf; // @[AddRecFN.scala 103:38]
  wire  addZeros = io_a_isZero & io_b_isZero; // @[AddRecFN.scala 104:32]
  wire  notNaN_specialCase = notNaN_isInfOut | addZeros; // @[AddRecFN.scala 105:46]
  wire  notNaN_isZeroOut = addZeros | ~notNaN_isInfOut & closeSubMags & close_totalCancellation; // @[AddRecFN.scala 106:37]
  wire  _notNaN_signOut_T_1 = io_a_isInf & io_a_sign; // @[AddRecFN.scala 109:39]
  wire  _notNaN_signOut_T_2 = eqSigns & io_a_sign | _notNaN_signOut_T_1; // @[AddRecFN.scala 108:63]
  wire  _notNaN_signOut_T_3 = io_b_isInf & effSignB; // @[AddRecFN.scala 110:39]
  wire  _notNaN_signOut_T_4 = _notNaN_signOut_T_2 | _notNaN_signOut_T_3; // @[AddRecFN.scala 109:63]
  wire  _notNaN_signOut_T_7 = notNaN_isZeroOut & _closeSubMags_T & notEqSigns_signZero; // @[AddRecFN.scala 111:39]
  wire  _notNaN_signOut_T_8 = _notNaN_signOut_T_4 | _notNaN_signOut_T_7; // @[AddRecFN.scala 110:63]
  wire  _notNaN_signOut_T_9 = ~notNaN_specialCase; // @[AddRecFN.scala 112:10]
  wire  _notNaN_signOut_T_12 = ~notNaN_specialCase & closeSubMags & ~close_totalCancellation; // @[AddRecFN.scala 112:46]
  wire  _notNaN_signOut_T_13 = _notNaN_signOut_T_12 & close_notTotalCancellation_signOut; // @[AddRecFN.scala 113:38]
  wire  _notNaN_signOut_T_14 = _notNaN_signOut_T_8 | _notNaN_signOut_T_13; // @[AddRecFN.scala 111:63]
  wire  _notNaN_signOut_T_18 = _notNaN_signOut_T_9 & ~closeSubMags & far_signOut; // @[AddRecFN.scala 114:47]
  wire [6:0] _common_sExpOut_T_2 = closeSubMags | _modNatAlignDist_T ? $signed(io_b_sExp) : $signed(io_a_sExp); // @[AddRecFN.scala 116:13]
  wire [3:0] _common_sExpOut_T_3 = closeSubMags ? close_nearNormDist : {{3'd0}, _closeSubMags_T}; // @[AddRecFN.scala 117:18]
  wire [4:0] _common_sExpOut_T_4 = {1'b0,$signed(_common_sExpOut_T_3)}; // @[AddRecFN.scala 117:66]
  wire [6:0] _GEN_6 = {{2{_common_sExpOut_T_4[4]}},_common_sExpOut_T_4}; // @[AddRecFN.scala 117:13]
  wire  _io_invalidExc_T_2 = io_a_isNaN & ~io_a_sig[9]; // @[common.scala 82:46]
  wire  _io_invalidExc_T_5 = io_b_isNaN & ~io_b_sig[9]; // @[common.scala 82:46]
  assign io_invalidExc = _io_invalidExc_T_2 | _io_invalidExc_T_5 | notSigNaN_invalidExc; // @[AddRecFN.scala 121:71]
  assign io_rawOut_isNaN = io_a_isNaN | io_b_isNaN; // @[AddRecFN.scala 125:35]
  assign io_rawOut_isInf = io_a_isInf | io_b_isInf; // @[AddRecFN.scala 103:38]
  assign io_rawOut_isZero = addZeros | ~notNaN_isInfOut & closeSubMags & close_totalCancellation; // @[AddRecFN.scala 106:37]
  assign io_rawOut_sign = _notNaN_signOut_T_14 | _notNaN_signOut_T_18; // @[AddRecFN.scala 113:77]
  assign io_rawOut_sExp = $signed(_common_sExpOut_T_2) - $signed(_GEN_6); // @[AddRecFN.scala 117:13]
  assign io_rawOut_sig = closeSubMags ? close_sigOut : far_sigOut; // @[AddRecFN.scala 118:28]
endmodule
module RoundAnyRawFNToRecFN_ie5_is13_oe5_os11(
  input         io_invalidExc,
  input         io_in_isNaN,
  input         io_in_isInf,
  input         io_in_isZero,
  input         io_in_sign,
  input  [6:0]  io_in_sExp,
  input  [13:0] io_in_sig,
  input  [2:0]  io_roundingMode,
  output [16:0] io_out,
  output [4:0]  io_exceptionFlags
);
  wire  roundingMode_near_even = io_roundingMode == 3'h0; // @[RoundAnyRawFNToRecFN.scala 90:53]
  wire  roundingMode_min = io_roundingMode == 3'h2; // @[RoundAnyRawFNToRecFN.scala 92:53]
  wire  roundingMode_max = io_roundingMode == 3'h3; // @[RoundAnyRawFNToRecFN.scala 93:53]
  wire  roundingMode_near_maxMag = io_roundingMode == 3'h4; // @[RoundAnyRawFNToRecFN.scala 94:53]
  wire  roundingMode_odd = io_roundingMode == 3'h6; // @[RoundAnyRawFNToRecFN.scala 95:53]
  wire  roundMagUp = roundingMode_min & io_in_sign | roundingMode_max & ~io_in_sign; // @[RoundAnyRawFNToRecFN.scala 98:42]
  wire  doShiftSigDown1 = io_in_sig[13]; // @[RoundAnyRawFNToRecFN.scala 120:57]
  wire [5:0] _roundMask_T_1 = ~io_in_sExp[5:0]; // @[primitives.scala 52:21]
  wire [64:0] roundMask_shift = 65'sh10000000000000000 >>> _roundMask_T_1; // @[primitives.scala 76:56]
  wire [7:0] _GEN_0 = {{4'd0}, roundMask_shift[14:11]}; // @[Bitwise.scala 108:31]
  wire [7:0] _roundMask_T_7 = _GEN_0 & 8'hf; // @[Bitwise.scala 108:31]
  wire [7:0] _roundMask_T_9 = {roundMask_shift[10:7], 4'h0}; // @[Bitwise.scala 108:70]
  wire [7:0] _roundMask_T_11 = _roundMask_T_9 & 8'hf0; // @[Bitwise.scala 108:80]
  wire [7:0] _roundMask_T_12 = _roundMask_T_7 | _roundMask_T_11; // @[Bitwise.scala 108:39]
  wire [7:0] _GEN_1 = {{2'd0}, _roundMask_T_12[7:2]}; // @[Bitwise.scala 108:31]
  wire [7:0] _roundMask_T_17 = _GEN_1 & 8'h33; // @[Bitwise.scala 108:31]
  wire [7:0] _roundMask_T_19 = {_roundMask_T_12[5:0], 2'h0}; // @[Bitwise.scala 108:70]
  wire [7:0] _roundMask_T_21 = _roundMask_T_19 & 8'hcc; // @[Bitwise.scala 108:80]
  wire [7:0] _roundMask_T_22 = _roundMask_T_17 | _roundMask_T_21; // @[Bitwise.scala 108:39]
  wire [7:0] _GEN_2 = {{1'd0}, _roundMask_T_22[7:1]}; // @[Bitwise.scala 108:31]
  wire [7:0] _roundMask_T_27 = _GEN_2 & 8'h55; // @[Bitwise.scala 108:31]
  wire [7:0] _roundMask_T_29 = {_roundMask_T_22[6:0], 1'h0}; // @[Bitwise.scala 108:70]
  wire [7:0] _roundMask_T_31 = _roundMask_T_29 & 8'haa; // @[Bitwise.scala 108:80]
  wire [7:0] _roundMask_T_32 = _roundMask_T_27 | _roundMask_T_31; // @[Bitwise.scala 108:39]
  wire [11:0] _roundMask_T_43 = {_roundMask_T_32,roundMask_shift[15],roundMask_shift[16],roundMask_shift[17],
    roundMask_shift[18]}; // @[Cat.scala 33:92]
  wire [11:0] _GEN_3 = {{11'd0}, doShiftSigDown1}; // @[RoundAnyRawFNToRecFN.scala 159:23]
  wire [11:0] _roundMask_T_44 = _roundMask_T_43 | _GEN_3; // @[RoundAnyRawFNToRecFN.scala 159:23]
  wire [13:0] roundMask = {_roundMask_T_44,2'h3}; // @[RoundAnyRawFNToRecFN.scala 159:42]
  wire [14:0] _shiftedRoundMask_T = {1'h0,_roundMask_T_44,2'h3}; // @[RoundAnyRawFNToRecFN.scala 162:41]
  wire [13:0] shiftedRoundMask = _shiftedRoundMask_T[14:1]; // @[RoundAnyRawFNToRecFN.scala 162:53]
  wire [13:0] _roundPosMask_T = ~shiftedRoundMask; // @[RoundAnyRawFNToRecFN.scala 163:28]
  wire [13:0] roundPosMask = _roundPosMask_T & roundMask; // @[RoundAnyRawFNToRecFN.scala 163:46]
  wire [13:0] _roundPosBit_T = io_in_sig & roundPosMask; // @[RoundAnyRawFNToRecFN.scala 164:40]
  wire  roundPosBit = |_roundPosBit_T; // @[RoundAnyRawFNToRecFN.scala 164:56]
  wire [13:0] _anyRoundExtra_T = io_in_sig & shiftedRoundMask; // @[RoundAnyRawFNToRecFN.scala 165:42]
  wire  anyRoundExtra = |_anyRoundExtra_T; // @[RoundAnyRawFNToRecFN.scala 165:62]
  wire  anyRound = roundPosBit | anyRoundExtra; // @[RoundAnyRawFNToRecFN.scala 166:36]
  wire  _roundIncr_T = roundingMode_near_even | roundingMode_near_maxMag; // @[RoundAnyRawFNToRecFN.scala 169:38]
  wire  _roundIncr_T_1 = (roundingMode_near_even | roundingMode_near_maxMag) & roundPosBit; // @[RoundAnyRawFNToRecFN.scala 169:67]
  wire  _roundIncr_T_2 = roundMagUp & anyRound; // @[RoundAnyRawFNToRecFN.scala 171:29]
  wire  roundIncr = _roundIncr_T_1 | _roundIncr_T_2; // @[RoundAnyRawFNToRecFN.scala 170:31]
  wire [13:0] _roundedSig_T = io_in_sig | roundMask; // @[RoundAnyRawFNToRecFN.scala 174:32]
  wire [12:0] _roundedSig_T_2 = _roundedSig_T[13:2] + 12'h1; // @[RoundAnyRawFNToRecFN.scala 174:49]
  wire  _roundedSig_T_4 = ~anyRoundExtra; // @[RoundAnyRawFNToRecFN.scala 176:30]
  wire [12:0] _roundedSig_T_7 = roundingMode_near_even & roundPosBit & _roundedSig_T_4 ? roundMask[13:1] : 13'h0; // @[RoundAnyRawFNToRecFN.scala 175:25]
  wire [12:0] _roundedSig_T_8 = ~_roundedSig_T_7; // @[RoundAnyRawFNToRecFN.scala 175:21]
  wire [12:0] _roundedSig_T_9 = _roundedSig_T_2 & _roundedSig_T_8; // @[RoundAnyRawFNToRecFN.scala 174:57]
  wire [13:0] _roundedSig_T_10 = ~roundMask; // @[RoundAnyRawFNToRecFN.scala 180:32]
  wire [13:0] _roundedSig_T_11 = io_in_sig & _roundedSig_T_10; // @[RoundAnyRawFNToRecFN.scala 180:30]
  wire [12:0] _roundedSig_T_15 = roundingMode_odd & anyRound ? roundPosMask[13:1] : 13'h0; // @[RoundAnyRawFNToRecFN.scala 181:24]
  wire [12:0] _GEN_4 = {{1'd0}, _roundedSig_T_11[13:2]}; // @[RoundAnyRawFNToRecFN.scala 180:47]
  wire [12:0] _roundedSig_T_16 = _GEN_4 | _roundedSig_T_15; // @[RoundAnyRawFNToRecFN.scala 180:47]
  wire [12:0] roundedSig = roundIncr ? _roundedSig_T_9 : _roundedSig_T_16; // @[RoundAnyRawFNToRecFN.scala 173:16]
  wire [2:0] _sRoundedExp_T_1 = {1'b0,$signed(roundedSig[12:11])}; // @[RoundAnyRawFNToRecFN.scala 185:76]
  wire [6:0] _GEN_5 = {{4{_sRoundedExp_T_1[2]}},_sRoundedExp_T_1}; // @[RoundAnyRawFNToRecFN.scala 185:40]
  wire [7:0] sRoundedExp = $signed(io_in_sExp) + $signed(_GEN_5); // @[RoundAnyRawFNToRecFN.scala 185:40]
  wire [5:0] common_expOut = sRoundedExp[5:0]; // @[RoundAnyRawFNToRecFN.scala 187:37]
  wire [9:0] common_fractOut = doShiftSigDown1 ? roundedSig[10:1] : roundedSig[9:0]; // @[RoundAnyRawFNToRecFN.scala 189:16]
  wire [3:0] _common_overflow_T = sRoundedExp[7:4]; // @[RoundAnyRawFNToRecFN.scala 196:30]
  wire  common_overflow = $signed(_common_overflow_T) >= 4'sh3; // @[RoundAnyRawFNToRecFN.scala 196:50]
  wire  common_totalUnderflow = $signed(sRoundedExp) < 8'sh8; // @[RoundAnyRawFNToRecFN.scala 200:31]
  wire [1:0] _common_underflow_T = io_in_sExp[6:5]; // @[RoundAnyRawFNToRecFN.scala 220:49]
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
  wire [5:0] _expOut_T_1 = io_in_isZero | common_totalUnderflow ? 6'h38 : 6'h0; // @[RoundAnyRawFNToRecFN.scala 253:18]
  wire [5:0] _expOut_T_2 = ~_expOut_T_1; // @[RoundAnyRawFNToRecFN.scala 253:14]
  wire [5:0] _expOut_T_3 = common_expOut & _expOut_T_2; // @[RoundAnyRawFNToRecFN.scala 252:24]
  wire [5:0] _expOut_T_5 = pegMinNonzeroMagOut ? 6'h37 : 6'h0; // @[RoundAnyRawFNToRecFN.scala 257:18]
  wire [5:0] _expOut_T_6 = ~_expOut_T_5; // @[RoundAnyRawFNToRecFN.scala 257:14]
  wire [5:0] _expOut_T_7 = _expOut_T_3 & _expOut_T_6; // @[RoundAnyRawFNToRecFN.scala 256:17]
  wire [5:0] _expOut_T_8 = pegMaxFiniteMagOut ? 6'h10 : 6'h0; // @[RoundAnyRawFNToRecFN.scala 261:18]
  wire [5:0] _expOut_T_9 = ~_expOut_T_8; // @[RoundAnyRawFNToRecFN.scala 261:14]
  wire [5:0] _expOut_T_10 = _expOut_T_7 & _expOut_T_9; // @[RoundAnyRawFNToRecFN.scala 260:17]
  wire [5:0] _expOut_T_11 = notNaN_isInfOut ? 6'h8 : 6'h0; // @[RoundAnyRawFNToRecFN.scala 265:18]
  wire [5:0] _expOut_T_12 = ~_expOut_T_11; // @[RoundAnyRawFNToRecFN.scala 265:14]
  wire [5:0] _expOut_T_13 = _expOut_T_10 & _expOut_T_12; // @[RoundAnyRawFNToRecFN.scala 264:17]
  wire [5:0] _expOut_T_14 = pegMinNonzeroMagOut ? 6'h8 : 6'h0; // @[RoundAnyRawFNToRecFN.scala 269:16]
  wire [5:0] _expOut_T_15 = _expOut_T_13 | _expOut_T_14; // @[RoundAnyRawFNToRecFN.scala 268:18]
  wire [5:0] _expOut_T_16 = pegMaxFiniteMagOut ? 6'h2f : 6'h0; // @[RoundAnyRawFNToRecFN.scala 273:16]
  wire [5:0] _expOut_T_17 = _expOut_T_15 | _expOut_T_16; // @[RoundAnyRawFNToRecFN.scala 272:15]
  wire [5:0] _expOut_T_18 = notNaN_isInfOut ? 6'h30 : 6'h0; // @[RoundAnyRawFNToRecFN.scala 277:16]
  wire [5:0] _expOut_T_19 = _expOut_T_17 | _expOut_T_18; // @[RoundAnyRawFNToRecFN.scala 276:15]
  wire [5:0] _expOut_T_20 = isNaNOut ? 6'h38 : 6'h0; // @[RoundAnyRawFNToRecFN.scala 278:16]
  wire [5:0] expOut = _expOut_T_19 | _expOut_T_20; // @[RoundAnyRawFNToRecFN.scala 277:73]
  wire [9:0] _fractOut_T_2 = isNaNOut ? 10'h200 : 10'h0; // @[RoundAnyRawFNToRecFN.scala 281:16]
  wire [9:0] _fractOut_T_3 = isNaNOut | io_in_isZero | common_totalUnderflow ? _fractOut_T_2 : common_fractOut; // @[RoundAnyRawFNToRecFN.scala 280:12]
  wire [9:0] _fractOut_T_5 = pegMaxFiniteMagOut ? 10'h3ff : 10'h0; // @[Bitwise.scala 77:12]
  wire [9:0] fractOut = _fractOut_T_3 | _fractOut_T_5; // @[RoundAnyRawFNToRecFN.scala 283:11]
  wire [6:0] _io_out_T = {signOut,expOut}; // @[RoundAnyRawFNToRecFN.scala 286:23]
  wire [3:0] _io_exceptionFlags_T_2 = {io_invalidExc,1'h0,overflow,underflow}; // @[RoundAnyRawFNToRecFN.scala 288:53]
  assign io_out = {_io_out_T,fractOut}; // @[RoundAnyRawFNToRecFN.scala 286:33]
  assign io_exceptionFlags = {_io_exceptionFlags_T_2,inexact}; // @[RoundAnyRawFNToRecFN.scala 288:66]
endmodule
module RoundRawFNToRecFN_e5_s11(
  input         io_invalidExc,
  input         io_in_isNaN,
  input         io_in_isInf,
  input         io_in_isZero,
  input         io_in_sign,
  input  [6:0]  io_in_sExp,
  input  [13:0] io_in_sig,
  input  [2:0]  io_roundingMode,
  output [16:0] io_out,
  output [4:0]  io_exceptionFlags
);
  wire  roundAnyRawFNToRecFN_io_invalidExc; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire  roundAnyRawFNToRecFN_io_in_isNaN; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire  roundAnyRawFNToRecFN_io_in_isInf; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire  roundAnyRawFNToRecFN_io_in_isZero; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire  roundAnyRawFNToRecFN_io_in_sign; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire [6:0] roundAnyRawFNToRecFN_io_in_sExp; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire [13:0] roundAnyRawFNToRecFN_io_in_sig; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire [2:0] roundAnyRawFNToRecFN_io_roundingMode; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire [16:0] roundAnyRawFNToRecFN_io_out; // @[RoundAnyRawFNToRecFN.scala 310:15]
  wire [4:0] roundAnyRawFNToRecFN_io_exceptionFlags; // @[RoundAnyRawFNToRecFN.scala 310:15]
  RoundAnyRawFNToRecFN_ie5_is13_oe5_os11 roundAnyRawFNToRecFN ( // @[RoundAnyRawFNToRecFN.scala 310:15]
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
module AddRecFN(
  input         io_subOp,
  input  [16:0] io_a,
  input  [16:0] io_b,
  input  [2:0]  io_roundingMode,
  output [16:0] io_out,
  output [4:0]  io_exceptionFlags
);
  wire  addRawFN__io_subOp; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_a_isNaN; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_a_isInf; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_a_isZero; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_a_sign; // @[AddRecFN.scala 147:26]
  wire [6:0] addRawFN__io_a_sExp; // @[AddRecFN.scala 147:26]
  wire [11:0] addRawFN__io_a_sig; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_b_isNaN; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_b_isInf; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_b_isZero; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_b_sign; // @[AddRecFN.scala 147:26]
  wire [6:0] addRawFN__io_b_sExp; // @[AddRecFN.scala 147:26]
  wire [11:0] addRawFN__io_b_sig; // @[AddRecFN.scala 147:26]
  wire [2:0] addRawFN__io_roundingMode; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_invalidExc; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_rawOut_isNaN; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_rawOut_isInf; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_rawOut_isZero; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_rawOut_sign; // @[AddRecFN.scala 147:26]
  wire [6:0] addRawFN__io_rawOut_sExp; // @[AddRecFN.scala 147:26]
  wire [13:0] addRawFN__io_rawOut_sig; // @[AddRecFN.scala 147:26]
  wire  roundRawFNToRecFN_io_invalidExc; // @[AddRecFN.scala 157:15]
  wire  roundRawFNToRecFN_io_in_isNaN; // @[AddRecFN.scala 157:15]
  wire  roundRawFNToRecFN_io_in_isInf; // @[AddRecFN.scala 157:15]
  wire  roundRawFNToRecFN_io_in_isZero; // @[AddRecFN.scala 157:15]
  wire  roundRawFNToRecFN_io_in_sign; // @[AddRecFN.scala 157:15]
  wire [6:0] roundRawFNToRecFN_io_in_sExp; // @[AddRecFN.scala 157:15]
  wire [13:0] roundRawFNToRecFN_io_in_sig; // @[AddRecFN.scala 157:15]
  wire [2:0] roundRawFNToRecFN_io_roundingMode; // @[AddRecFN.scala 157:15]
  wire [16:0] roundRawFNToRecFN_io_out; // @[AddRecFN.scala 157:15]
  wire [4:0] roundRawFNToRecFN_io_exceptionFlags; // @[AddRecFN.scala 157:15]
  wire [5:0] addRawFN_io_a_exp = io_a[15:10]; // @[rawFloatFromRecFN.scala 51:21]
  wire  addRawFN_io_a_isZero = addRawFN_io_a_exp[5:3] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  addRawFN_io_a_isSpecial = addRawFN_io_a_exp[5:4] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  _addRawFN_io_a_out_sig_T = ~addRawFN_io_a_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [1:0] _addRawFN_io_a_out_sig_T_1 = {1'h0,_addRawFN_io_a_out_sig_T}; // @[rawFloatFromRecFN.scala 61:32]
  wire [5:0] addRawFN_io_b_exp = io_b[15:10]; // @[rawFloatFromRecFN.scala 51:21]
  wire  addRawFN_io_b_isZero = addRawFN_io_b_exp[5:3] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  addRawFN_io_b_isSpecial = addRawFN_io_b_exp[5:4] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  _addRawFN_io_b_out_sig_T = ~addRawFN_io_b_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [1:0] _addRawFN_io_b_out_sig_T_1 = {1'h0,_addRawFN_io_b_out_sig_T}; // @[rawFloatFromRecFN.scala 61:32]
  AddRawFN addRawFN_ ( // @[AddRecFN.scala 147:26]
    .io_subOp(addRawFN__io_subOp),
    .io_a_isNaN(addRawFN__io_a_isNaN),
    .io_a_isInf(addRawFN__io_a_isInf),
    .io_a_isZero(addRawFN__io_a_isZero),
    .io_a_sign(addRawFN__io_a_sign),
    .io_a_sExp(addRawFN__io_a_sExp),
    .io_a_sig(addRawFN__io_a_sig),
    .io_b_isNaN(addRawFN__io_b_isNaN),
    .io_b_isInf(addRawFN__io_b_isInf),
    .io_b_isZero(addRawFN__io_b_isZero),
    .io_b_sign(addRawFN__io_b_sign),
    .io_b_sExp(addRawFN__io_b_sExp),
    .io_b_sig(addRawFN__io_b_sig),
    .io_roundingMode(addRawFN__io_roundingMode),
    .io_invalidExc(addRawFN__io_invalidExc),
    .io_rawOut_isNaN(addRawFN__io_rawOut_isNaN),
    .io_rawOut_isInf(addRawFN__io_rawOut_isInf),
    .io_rawOut_isZero(addRawFN__io_rawOut_isZero),
    .io_rawOut_sign(addRawFN__io_rawOut_sign),
    .io_rawOut_sExp(addRawFN__io_rawOut_sExp),
    .io_rawOut_sig(addRawFN__io_rawOut_sig)
  );
  RoundRawFNToRecFN_e5_s11 roundRawFNToRecFN ( // @[AddRecFN.scala 157:15]
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
  assign io_out = roundRawFNToRecFN_io_out; // @[AddRecFN.scala 163:23]
  assign io_exceptionFlags = roundRawFNToRecFN_io_exceptionFlags; // @[AddRecFN.scala 164:23]
  assign addRawFN__io_subOp = io_subOp; // @[AddRecFN.scala 149:30]
  assign addRawFN__io_a_isNaN = addRawFN_io_a_isSpecial & addRawFN_io_a_exp[3]; // @[rawFloatFromRecFN.scala 56:33]
  assign addRawFN__io_a_isInf = addRawFN_io_a_isSpecial & ~addRawFN_io_a_exp[3]; // @[rawFloatFromRecFN.scala 57:33]
  assign addRawFN__io_a_isZero = addRawFN_io_a_exp[5:3] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign addRawFN__io_a_sign = io_a[16]; // @[rawFloatFromRecFN.scala 59:25]
  assign addRawFN__io_a_sExp = {1'b0,$signed(addRawFN_io_a_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  assign addRawFN__io_a_sig = {_addRawFN_io_a_out_sig_T_1,io_a[9:0]}; // @[rawFloatFromRecFN.scala 61:44]
  assign addRawFN__io_b_isNaN = addRawFN_io_b_isSpecial & addRawFN_io_b_exp[3]; // @[rawFloatFromRecFN.scala 56:33]
  assign addRawFN__io_b_isInf = addRawFN_io_b_isSpecial & ~addRawFN_io_b_exp[3]; // @[rawFloatFromRecFN.scala 57:33]
  assign addRawFN__io_b_isZero = addRawFN_io_b_exp[5:3] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign addRawFN__io_b_sign = io_b[16]; // @[rawFloatFromRecFN.scala 59:25]
  assign addRawFN__io_b_sExp = {1'b0,$signed(addRawFN_io_b_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  assign addRawFN__io_b_sig = {_addRawFN_io_b_out_sig_T_1,io_b[9:0]}; // @[rawFloatFromRecFN.scala 61:44]
  assign addRawFN__io_roundingMode = io_roundingMode; // @[AddRecFN.scala 152:30]
  assign roundRawFNToRecFN_io_invalidExc = addRawFN__io_invalidExc; // @[AddRecFN.scala 158:39]
  assign roundRawFNToRecFN_io_in_isNaN = addRawFN__io_rawOut_isNaN; // @[AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_in_isInf = addRawFN__io_rawOut_isInf; // @[AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_in_isZero = addRawFN__io_rawOut_isZero; // @[AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_in_sign = addRawFN__io_rawOut_sign; // @[AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_in_sExp = addRawFN__io_rawOut_sExp; // @[AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_in_sig = addRawFN__io_rawOut_sig; // @[AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_roundingMode = io_roundingMode; // @[AddRecFN.scala 161:39]
endmodule
module fp16_sub(
  input         clock,
  input         reset,
  input         io_opSel,
  input  [15:0] io_a,
  input  [15:0] io_b,
  input  [15:0] io_c,
  input  [2:0]  io_roundingMode,
  output [15:0] io_out,
  output [4:0]  io_exceptionFlags
);
  wire  add_f0_io_subOp; // @[Emitfp16_sub.scala 39:22]
  wire [16:0] add_f0_io_a; // @[Emitfp16_sub.scala 39:22]
  wire [16:0] add_f0_io_b; // @[Emitfp16_sub.scala 39:22]
  wire [2:0] add_f0_io_roundingMode; // @[Emitfp16_sub.scala 39:22]
  wire [16:0] add_f0_io_out; // @[Emitfp16_sub.scala 39:22]
  wire [4:0] add_f0_io_exceptionFlags; // @[Emitfp16_sub.scala 39:22]
  wire  roundingMatches_0 = 3'h0 == io_roundingMode; // @[Emitfp16_sub.scala 19:47]
  wire  fmt0_recA_rawIn_sign = io_a[15]; // @[rawFloatFromFN.scala 44:18]
  wire [4:0] fmt0_recA_rawIn_expIn = io_a[14:10]; // @[rawFloatFromFN.scala 45:19]
  wire [9:0] fmt0_recA_rawIn_fractIn = io_a[9:0]; // @[rawFloatFromFN.scala 46:21]
  wire  fmt0_recA_rawIn_isZeroExpIn = fmt0_recA_rawIn_expIn == 5'h0; // @[rawFloatFromFN.scala 48:30]
  wire  fmt0_recA_rawIn_isZeroFractIn = fmt0_recA_rawIn_fractIn == 10'h0; // @[rawFloatFromFN.scala 49:34]
  wire [3:0] _fmt0_recA_rawIn_normDist_T_10 = fmt0_recA_rawIn_fractIn[1] ? 4'h8 : 4'h9; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recA_rawIn_normDist_T_11 = fmt0_recA_rawIn_fractIn[2] ? 4'h7 : _fmt0_recA_rawIn_normDist_T_10; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recA_rawIn_normDist_T_12 = fmt0_recA_rawIn_fractIn[3] ? 4'h6 : _fmt0_recA_rawIn_normDist_T_11; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recA_rawIn_normDist_T_13 = fmt0_recA_rawIn_fractIn[4] ? 4'h5 : _fmt0_recA_rawIn_normDist_T_12; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recA_rawIn_normDist_T_14 = fmt0_recA_rawIn_fractIn[5] ? 4'h4 : _fmt0_recA_rawIn_normDist_T_13; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recA_rawIn_normDist_T_15 = fmt0_recA_rawIn_fractIn[6] ? 4'h3 : _fmt0_recA_rawIn_normDist_T_14; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recA_rawIn_normDist_T_16 = fmt0_recA_rawIn_fractIn[7] ? 4'h2 : _fmt0_recA_rawIn_normDist_T_15; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recA_rawIn_normDist_T_17 = fmt0_recA_rawIn_fractIn[8] ? 4'h1 : _fmt0_recA_rawIn_normDist_T_16; // @[Mux.scala 47:70]
  wire [3:0] fmt0_recA_rawIn_normDist = fmt0_recA_rawIn_fractIn[9] ? 4'h0 : _fmt0_recA_rawIn_normDist_T_17; // @[Mux.scala 47:70]
  wire [24:0] _GEN_0 = {{15'd0}, fmt0_recA_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [24:0] _fmt0_recA_rawIn_subnormFract_T = _GEN_0 << fmt0_recA_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [9:0] fmt0_recA_rawIn_subnormFract = {_fmt0_recA_rawIn_subnormFract_T[8:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [5:0] _GEN_3 = {{2'd0}, fmt0_recA_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [5:0] _fmt0_recA_rawIn_adjustedExp_T = _GEN_3 ^ 6'h3f; // @[rawFloatFromFN.scala 55:18]
  wire [5:0] _fmt0_recA_rawIn_adjustedExp_T_1 = fmt0_recA_rawIn_isZeroExpIn ? _fmt0_recA_rawIn_adjustedExp_T : {{1'd0},
    fmt0_recA_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _fmt0_recA_rawIn_adjustedExp_T_2 = fmt0_recA_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [4:0] _GEN_4 = {{3'd0}, _fmt0_recA_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [4:0] _fmt0_recA_rawIn_adjustedExp_T_3 = 5'h10 | _GEN_4; // @[rawFloatFromFN.scala 58:9]
  wire [5:0] _GEN_5 = {{1'd0}, _fmt0_recA_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [5:0] fmt0_recA_rawIn_adjustedExp = _fmt0_recA_rawIn_adjustedExp_T_1 + _GEN_5; // @[rawFloatFromFN.scala 57:9]
  wire  fmt0_recA_rawIn_isZero = fmt0_recA_rawIn_isZeroExpIn & fmt0_recA_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  fmt0_recA_rawIn_isSpecial = fmt0_recA_rawIn_adjustedExp[5:4] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  fmt0_recA_rawIn__isNaN = fmt0_recA_rawIn_isSpecial & ~fmt0_recA_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [6:0] fmt0_recA_rawIn__sExp = {1'b0,$signed(fmt0_recA_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _fmt0_recA_rawIn_out_sig_T = ~fmt0_recA_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [9:0] _fmt0_recA_rawIn_out_sig_T_2 = fmt0_recA_rawIn_isZeroExpIn ? fmt0_recA_rawIn_subnormFract :
    fmt0_recA_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [11:0] fmt0_recA_rawIn__sig = {1'h0,_fmt0_recA_rawIn_out_sig_T,_fmt0_recA_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _fmt0_recA_T_2 = fmt0_recA_rawIn_isZero ? 3'h0 : fmt0_recA_rawIn__sExp[5:3]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_6 = {{2'd0}, fmt0_recA_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _fmt0_recA_T_4 = _fmt0_recA_T_2 | _GEN_6; // @[recFNFromFN.scala 48:76]
  wire [6:0] _fmt0_recA_T_7 = {fmt0_recA_rawIn_sign,_fmt0_recA_T_4,fmt0_recA_rawIn__sExp[2:0]}; // @[recFNFromFN.scala 49:45]
  wire  fmt0_recB_rawIn_sign = io_b[15]; // @[rawFloatFromFN.scala 44:18]
  wire [4:0] fmt0_recB_rawIn_expIn = io_b[14:10]; // @[rawFloatFromFN.scala 45:19]
  wire [9:0] fmt0_recB_rawIn_fractIn = io_b[9:0]; // @[rawFloatFromFN.scala 46:21]
  wire  fmt0_recB_rawIn_isZeroExpIn = fmt0_recB_rawIn_expIn == 5'h0; // @[rawFloatFromFN.scala 48:30]
  wire  fmt0_recB_rawIn_isZeroFractIn = fmt0_recB_rawIn_fractIn == 10'h0; // @[rawFloatFromFN.scala 49:34]
  wire [3:0] _fmt0_recB_rawIn_normDist_T_10 = fmt0_recB_rawIn_fractIn[1] ? 4'h8 : 4'h9; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recB_rawIn_normDist_T_11 = fmt0_recB_rawIn_fractIn[2] ? 4'h7 : _fmt0_recB_rawIn_normDist_T_10; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recB_rawIn_normDist_T_12 = fmt0_recB_rawIn_fractIn[3] ? 4'h6 : _fmt0_recB_rawIn_normDist_T_11; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recB_rawIn_normDist_T_13 = fmt0_recB_rawIn_fractIn[4] ? 4'h5 : _fmt0_recB_rawIn_normDist_T_12; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recB_rawIn_normDist_T_14 = fmt0_recB_rawIn_fractIn[5] ? 4'h4 : _fmt0_recB_rawIn_normDist_T_13; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recB_rawIn_normDist_T_15 = fmt0_recB_rawIn_fractIn[6] ? 4'h3 : _fmt0_recB_rawIn_normDist_T_14; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recB_rawIn_normDist_T_16 = fmt0_recB_rawIn_fractIn[7] ? 4'h2 : _fmt0_recB_rawIn_normDist_T_15; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recB_rawIn_normDist_T_17 = fmt0_recB_rawIn_fractIn[8] ? 4'h1 : _fmt0_recB_rawIn_normDist_T_16; // @[Mux.scala 47:70]
  wire [3:0] fmt0_recB_rawIn_normDist = fmt0_recB_rawIn_fractIn[9] ? 4'h0 : _fmt0_recB_rawIn_normDist_T_17; // @[Mux.scala 47:70]
  wire [24:0] _GEN_1 = {{15'd0}, fmt0_recB_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [24:0] _fmt0_recB_rawIn_subnormFract_T = _GEN_1 << fmt0_recB_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [9:0] fmt0_recB_rawIn_subnormFract = {_fmt0_recB_rawIn_subnormFract_T[8:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [5:0] _GEN_7 = {{2'd0}, fmt0_recB_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [5:0] _fmt0_recB_rawIn_adjustedExp_T = _GEN_7 ^ 6'h3f; // @[rawFloatFromFN.scala 55:18]
  wire [5:0] _fmt0_recB_rawIn_adjustedExp_T_1 = fmt0_recB_rawIn_isZeroExpIn ? _fmt0_recB_rawIn_adjustedExp_T : {{1'd0},
    fmt0_recB_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _fmt0_recB_rawIn_adjustedExp_T_2 = fmt0_recB_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [4:0] _GEN_8 = {{3'd0}, _fmt0_recB_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [4:0] _fmt0_recB_rawIn_adjustedExp_T_3 = 5'h10 | _GEN_8; // @[rawFloatFromFN.scala 58:9]
  wire [5:0] _GEN_9 = {{1'd0}, _fmt0_recB_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [5:0] fmt0_recB_rawIn_adjustedExp = _fmt0_recB_rawIn_adjustedExp_T_1 + _GEN_9; // @[rawFloatFromFN.scala 57:9]
  wire  fmt0_recB_rawIn_isZero = fmt0_recB_rawIn_isZeroExpIn & fmt0_recB_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  fmt0_recB_rawIn_isSpecial = fmt0_recB_rawIn_adjustedExp[5:4] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  fmt0_recB_rawIn__isNaN = fmt0_recB_rawIn_isSpecial & ~fmt0_recB_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [6:0] fmt0_recB_rawIn__sExp = {1'b0,$signed(fmt0_recB_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _fmt0_recB_rawIn_out_sig_T = ~fmt0_recB_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [9:0] _fmt0_recB_rawIn_out_sig_T_2 = fmt0_recB_rawIn_isZeroExpIn ? fmt0_recB_rawIn_subnormFract :
    fmt0_recB_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [11:0] fmt0_recB_rawIn__sig = {1'h0,_fmt0_recB_rawIn_out_sig_T,_fmt0_recB_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _fmt0_recB_T_2 = fmt0_recB_rawIn_isZero ? 3'h0 : fmt0_recB_rawIn__sExp[5:3]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_10 = {{2'd0}, fmt0_recB_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _fmt0_recB_T_4 = _fmt0_recB_T_2 | _GEN_10; // @[recFNFromFN.scala 48:76]
  wire [6:0] _fmt0_recB_T_7 = {fmt0_recB_rawIn_sign,_fmt0_recB_T_4,fmt0_recB_rawIn__sExp[2:0]}; // @[recFNFromFN.scala 49:45]
  wire  _add_f0_io_subOp_T = ~io_opSel; // @[Emitfp16_sub.scala 42:31]
  wire [16:0] outRec = _add_f0_io_subOp_T ? add_f0_io_out : 17'h0; // @[Emitfp16_sub.scala 51:20 53:16 45:27]
  wire  recNonZero = |outRec; // @[Emitfp16_sub.scala 59:27]
  wire [5:0] outIeee_rawIn_exp = outRec[15:10]; // @[rawFloatFromRecFN.scala 51:21]
  wire  outIeee_rawIn_isZero = outIeee_rawIn_exp[5:3] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  outIeee_rawIn_isSpecial = outIeee_rawIn_exp[5:4] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  outIeee_rawIn__isNaN = outIeee_rawIn_isSpecial & outIeee_rawIn_exp[3]; // @[rawFloatFromRecFN.scala 56:33]
  wire  outIeee_rawIn__isInf = outIeee_rawIn_isSpecial & ~outIeee_rawIn_exp[3]; // @[rawFloatFromRecFN.scala 57:33]
  wire  outIeee_rawIn__sign = outRec[16]; // @[rawFloatFromRecFN.scala 59:25]
  wire [6:0] outIeee_rawIn__sExp = {1'b0,$signed(outIeee_rawIn_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _outIeee_rawIn_out_sig_T = ~outIeee_rawIn_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [11:0] outIeee_rawIn__sig = {1'h0,_outIeee_rawIn_out_sig_T,outRec[9:0]}; // @[rawFloatFromRecFN.scala 61:44]
  wire  outIeee_isSubnormal = $signed(outIeee_rawIn__sExp) < 7'sh12; // @[fNFromRecFN.scala 51:38]
  wire [3:0] outIeee_denormShiftDist = 4'h1 - outIeee_rawIn__sExp[3:0]; // @[fNFromRecFN.scala 52:35]
  wire [10:0] _outIeee_denormFract_T_1 = outIeee_rawIn__sig[11:1] >> outIeee_denormShiftDist; // @[fNFromRecFN.scala 53:42]
  wire [9:0] outIeee_denormFract = _outIeee_denormFract_T_1[9:0]; // @[fNFromRecFN.scala 53:60]
  wire [4:0] _outIeee_expOut_T_2 = outIeee_rawIn__sExp[4:0] - 5'h11; // @[fNFromRecFN.scala 58:45]
  wire [4:0] _outIeee_expOut_T_3 = outIeee_isSubnormal ? 5'h0 : _outIeee_expOut_T_2; // @[fNFromRecFN.scala 56:16]
  wire  _outIeee_expOut_T_4 = outIeee_rawIn__isNaN | outIeee_rawIn__isInf; // @[fNFromRecFN.scala 60:44]
  wire [4:0] _outIeee_expOut_T_6 = _outIeee_expOut_T_4 ? 5'h1f : 5'h0; // @[Bitwise.scala 77:12]
  wire [4:0] outIeee_expOut = _outIeee_expOut_T_3 | _outIeee_expOut_T_6; // @[fNFromRecFN.scala 60:15]
  wire [9:0] _outIeee_fractOut_T_1 = outIeee_rawIn__isInf ? 10'h0 : outIeee_rawIn__sig[9:0]; // @[fNFromRecFN.scala 64:20]
  wire [9:0] outIeee_fractOut = outIeee_isSubnormal ? outIeee_denormFract : _outIeee_fractOut_T_1; // @[fNFromRecFN.scala 62:16]
  wire [15:0] outIeee = {outIeee_rawIn__sign,outIeee_expOut,outIeee_fractOut}; // @[Cat.scala 33:92]
  AddRecFN add_f0 ( // @[Emitfp16_sub.scala 39:22]
    .io_subOp(add_f0_io_subOp),
    .io_a(add_f0_io_a),
    .io_b(add_f0_io_b),
    .io_roundingMode(add_f0_io_roundingMode),
    .io_out(add_f0_io_out),
    .io_exceptionFlags(add_f0_io_exceptionFlags)
  );
  assign io_out = recNonZero ? outIeee : 16'h0; // @[Emitfp16_sub.scala 62:16]
  assign io_exceptionFlags = _add_f0_io_subOp_T ? add_f0_io_exceptionFlags : 5'h0; // @[Emitfp16_sub.scala 51:20 54:16 47:27]
  assign add_f0_io_subOp = ~io_opSel; // @[Emitfp16_sub.scala 42:31]
  assign add_f0_io_a = {_fmt0_recA_T_7,fmt0_recA_rawIn__sig[9:0]}; // @[recFNFromFN.scala 50:41]
  assign add_f0_io_b = {_fmt0_recB_T_7,fmt0_recB_rawIn__sig[9:0]}; // @[recFNFromFN.scala 50:41]
  assign add_f0_io_roundingMode = roundingMatches_0 ? io_roundingMode : 3'h0; // @[Emitfp16_sub.scala 21:25]
endmodule
