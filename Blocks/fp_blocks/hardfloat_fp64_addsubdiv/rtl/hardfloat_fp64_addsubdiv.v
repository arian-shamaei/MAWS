module AddRawFN(
  input         io_subOp,
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
  input  [2:0]  io_roundingMode,
  output        io_invalidExc,
  output        io_rawOut_isNaN,
  output        io_rawOut_isInf,
  output        io_rawOut_isZero,
  output        io_rawOut_sign,
  output [12:0] io_rawOut_sExp,
  output [55:0] io_rawOut_sig
);
  wire  effSignB = io_b_sign ^ io_subOp; // @[AddRecFN.scala 60:30]
  wire  eqSigns = io_a_sign == effSignB; // @[AddRecFN.scala 61:29]
  wire  notEqSigns_signZero = io_roundingMode == 3'h2; // @[AddRecFN.scala 62:47]
  wire [12:0] sDiffExps = $signed(io_a_sExp) - $signed(io_b_sExp); // @[AddRecFN.scala 63:31]
  wire  _modNatAlignDist_T = $signed(sDiffExps) < 13'sh0; // @[AddRecFN.scala 64:41]
  wire [12:0] _modNatAlignDist_T_3 = $signed(io_b_sExp) - $signed(io_a_sExp); // @[AddRecFN.scala 64:58]
  wire [12:0] _modNatAlignDist_T_4 = $signed(sDiffExps) < 13'sh0 ? $signed(_modNatAlignDist_T_3) : $signed(sDiffExps); // @[AddRecFN.scala 64:30]
  wire [5:0] modNatAlignDist = _modNatAlignDist_T_4[5:0]; // @[AddRecFN.scala 64:81]
  wire [6:0] _isMaxAlign_T = sDiffExps[12:6]; // @[AddRecFN.scala 66:19]
  wire  _isMaxAlign_T_6 = $signed(_isMaxAlign_T) != -7'sh1 | sDiffExps[5:0] == 6'h0; // @[AddRecFN.scala 67:51]
  wire  isMaxAlign = $signed(_isMaxAlign_T) != 7'sh0 & _isMaxAlign_T_6; // @[AddRecFN.scala 66:45]
  wire [5:0] alignDist = isMaxAlign ? 6'h3f : modNatAlignDist; // @[AddRecFN.scala 68:24]
  wire  _closeSubMags_T = ~eqSigns; // @[AddRecFN.scala 69:24]
  wire  closeSubMags = ~eqSigns & ~isMaxAlign & modNatAlignDist <= 6'h1; // @[AddRecFN.scala 69:48]
  wire  _close_alignedSigA_T = 13'sh0 <= $signed(sDiffExps); // @[AddRecFN.scala 73:18]
  wire [55:0] _close_alignedSigA_T_3 = {io_a_sig, 2'h0}; // @[AddRecFN.scala 73:58]
  wire [55:0] _close_alignedSigA_T_4 = 13'sh0 <= $signed(sDiffExps) & sDiffExps[0] ? _close_alignedSigA_T_3 : 56'h0; // @[AddRecFN.scala 73:12]
  wire [54:0] _close_alignedSigA_T_9 = {io_a_sig, 1'h0}; // @[AddRecFN.scala 74:58]
  wire [54:0] _close_alignedSigA_T_10 = _close_alignedSigA_T & ~sDiffExps[0] ? _close_alignedSigA_T_9 : 55'h0; // @[AddRecFN.scala 74:12]
  wire [55:0] _GEN_0 = {{1'd0}, _close_alignedSigA_T_10}; // @[AddRecFN.scala 73:68]
  wire [55:0] _close_alignedSigA_T_11 = _close_alignedSigA_T_4 | _GEN_0; // @[AddRecFN.scala 73:68]
  wire [53:0] _close_alignedSigA_T_13 = _modNatAlignDist_T ? io_a_sig : 54'h0; // @[AddRecFN.scala 75:12]
  wire [55:0] _GEN_1 = {{2'd0}, _close_alignedSigA_T_13}; // @[AddRecFN.scala 74:68]
  wire [55:0] _close_sSigSum_T = _close_alignedSigA_T_11 | _GEN_1; // @[AddRecFN.scala 76:43]
  wire [54:0] _close_sSigSum_T_2 = {io_b_sig, 1'h0}; // @[AddRecFN.scala 76:66]
  wire [55:0] _GEN_2 = {{1{_close_sSigSum_T_2[54]}},_close_sSigSum_T_2}; // @[AddRecFN.scala 76:50]
  wire [55:0] close_sSigSum = $signed(_close_sSigSum_T) - $signed(_GEN_2); // @[AddRecFN.scala 76:50]
  wire  _close_sigSum_T = $signed(close_sSigSum) < 56'sh0; // @[AddRecFN.scala 77:42]
  wire [55:0] _close_sigSum_T_3 = 56'sh0 - $signed(close_sSigSum); // @[AddRecFN.scala 77:49]
  wire [55:0] _close_sigSum_T_4 = $signed(close_sSigSum) < 56'sh0 ? $signed(_close_sigSum_T_3) : $signed(close_sSigSum); // @[AddRecFN.scala 77:27]
  wire [54:0] close_sigSum = _close_sigSum_T_4[54:0]; // @[AddRecFN.scala 77:79]
  wire [55:0] close_adjustedSigSum = {close_sigSum, 1'h0}; // @[AddRecFN.scala 78:44]
  wire  close_reduced2SigSum_reducedVec_0 = |close_adjustedSigSum[1:0]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_1 = |close_adjustedSigSum[3:2]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_2 = |close_adjustedSigSum[5:4]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_3 = |close_adjustedSigSum[7:6]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_4 = |close_adjustedSigSum[9:8]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_5 = |close_adjustedSigSum[11:10]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_6 = |close_adjustedSigSum[13:12]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_7 = |close_adjustedSigSum[15:14]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_8 = |close_adjustedSigSum[17:16]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_9 = |close_adjustedSigSum[19:18]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_10 = |close_adjustedSigSum[21:20]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_11 = |close_adjustedSigSum[23:22]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_12 = |close_adjustedSigSum[25:24]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_13 = |close_adjustedSigSum[27:26]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_14 = |close_adjustedSigSum[29:28]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_15 = |close_adjustedSigSum[31:30]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_16 = |close_adjustedSigSum[33:32]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_17 = |close_adjustedSigSum[35:34]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_18 = |close_adjustedSigSum[37:36]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_19 = |close_adjustedSigSum[39:38]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_20 = |close_adjustedSigSum[41:40]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_21 = |close_adjustedSigSum[43:42]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_22 = |close_adjustedSigSum[45:44]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_23 = |close_adjustedSigSum[47:46]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_24 = |close_adjustedSigSum[49:48]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_25 = |close_adjustedSigSum[51:50]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_26 = |close_adjustedSigSum[53:52]; // @[primitives.scala 103:54]
  wire  close_reduced2SigSum_reducedVec_27 = |close_adjustedSigSum[55:54]; // @[primitives.scala 106:57]
  wire [6:0] close_reduced2SigSum_lo_lo = {close_reduced2SigSum_reducedVec_6,close_reduced2SigSum_reducedVec_5,
    close_reduced2SigSum_reducedVec_4,close_reduced2SigSum_reducedVec_3,close_reduced2SigSum_reducedVec_2,
    close_reduced2SigSum_reducedVec_1,close_reduced2SigSum_reducedVec_0}; // @[primitives.scala 107:20]
  wire [13:0] close_reduced2SigSum_lo = {close_reduced2SigSum_reducedVec_13,close_reduced2SigSum_reducedVec_12,
    close_reduced2SigSum_reducedVec_11,close_reduced2SigSum_reducedVec_10,close_reduced2SigSum_reducedVec_9,
    close_reduced2SigSum_reducedVec_8,close_reduced2SigSum_reducedVec_7,close_reduced2SigSum_lo_lo}; // @[primitives.scala 107:20]
  wire [6:0] close_reduced2SigSum_hi_lo = {close_reduced2SigSum_reducedVec_20,close_reduced2SigSum_reducedVec_19,
    close_reduced2SigSum_reducedVec_18,close_reduced2SigSum_reducedVec_17,close_reduced2SigSum_reducedVec_16,
    close_reduced2SigSum_reducedVec_15,close_reduced2SigSum_reducedVec_14}; // @[primitives.scala 107:20]
  wire [27:0] close_reduced2SigSum = {close_reduced2SigSum_reducedVec_27,close_reduced2SigSum_reducedVec_26,
    close_reduced2SigSum_reducedVec_25,close_reduced2SigSum_reducedVec_24,close_reduced2SigSum_reducedVec_23,
    close_reduced2SigSum_reducedVec_22,close_reduced2SigSum_reducedVec_21,close_reduced2SigSum_hi_lo,
    close_reduced2SigSum_lo}; // @[primitives.scala 107:20]
  wire [4:0] _close_normDistReduced2_T_28 = close_reduced2SigSum[1] ? 5'h1a : 5'h1b; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_29 = close_reduced2SigSum[2] ? 5'h19 : _close_normDistReduced2_T_28; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_30 = close_reduced2SigSum[3] ? 5'h18 : _close_normDistReduced2_T_29; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_31 = close_reduced2SigSum[4] ? 5'h17 : _close_normDistReduced2_T_30; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_32 = close_reduced2SigSum[5] ? 5'h16 : _close_normDistReduced2_T_31; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_33 = close_reduced2SigSum[6] ? 5'h15 : _close_normDistReduced2_T_32; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_34 = close_reduced2SigSum[7] ? 5'h14 : _close_normDistReduced2_T_33; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_35 = close_reduced2SigSum[8] ? 5'h13 : _close_normDistReduced2_T_34; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_36 = close_reduced2SigSum[9] ? 5'h12 : _close_normDistReduced2_T_35; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_37 = close_reduced2SigSum[10] ? 5'h11 : _close_normDistReduced2_T_36; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_38 = close_reduced2SigSum[11] ? 5'h10 : _close_normDistReduced2_T_37; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_39 = close_reduced2SigSum[12] ? 5'hf : _close_normDistReduced2_T_38; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_40 = close_reduced2SigSum[13] ? 5'he : _close_normDistReduced2_T_39; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_41 = close_reduced2SigSum[14] ? 5'hd : _close_normDistReduced2_T_40; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_42 = close_reduced2SigSum[15] ? 5'hc : _close_normDistReduced2_T_41; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_43 = close_reduced2SigSum[16] ? 5'hb : _close_normDistReduced2_T_42; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_44 = close_reduced2SigSum[17] ? 5'ha : _close_normDistReduced2_T_43; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_45 = close_reduced2SigSum[18] ? 5'h9 : _close_normDistReduced2_T_44; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_46 = close_reduced2SigSum[19] ? 5'h8 : _close_normDistReduced2_T_45; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_47 = close_reduced2SigSum[20] ? 5'h7 : _close_normDistReduced2_T_46; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_48 = close_reduced2SigSum[21] ? 5'h6 : _close_normDistReduced2_T_47; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_49 = close_reduced2SigSum[22] ? 5'h5 : _close_normDistReduced2_T_48; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_50 = close_reduced2SigSum[23] ? 5'h4 : _close_normDistReduced2_T_49; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_51 = close_reduced2SigSum[24] ? 5'h3 : _close_normDistReduced2_T_50; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_52 = close_reduced2SigSum[25] ? 5'h2 : _close_normDistReduced2_T_51; // @[Mux.scala 47:70]
  wire [4:0] _close_normDistReduced2_T_53 = close_reduced2SigSum[26] ? 5'h1 : _close_normDistReduced2_T_52; // @[Mux.scala 47:70]
  wire [4:0] close_normDistReduced2 = close_reduced2SigSum[27] ? 5'h0 : _close_normDistReduced2_T_53; // @[Mux.scala 47:70]
  wire [5:0] close_nearNormDist = {close_normDistReduced2, 1'h0}; // @[AddRecFN.scala 81:53]
  wire [117:0] _GEN_10 = {{63'd0}, close_sigSum}; // @[AddRecFN.scala 82:38]
  wire [117:0] _close_sigOut_T = _GEN_10 << close_nearNormDist; // @[AddRecFN.scala 82:38]
  wire [118:0] _close_sigOut_T_1 = {_close_sigOut_T, 1'h0}; // @[AddRecFN.scala 82:59]
  wire [55:0] close_sigOut = _close_sigOut_T_1[55:0]; // @[AddRecFN.scala 82:63]
  wire  close_totalCancellation = ~(|close_sigOut[55:54]); // @[AddRecFN.scala 83:35]
  wire  close_notTotalCancellation_signOut = io_a_sign ^ _close_sigSum_T; // @[AddRecFN.scala 84:56]
  wire  far_signOut = _modNatAlignDist_T ? effSignB : io_a_sign; // @[AddRecFN.scala 87:26]
  wire [53:0] _far_sigLarger_T_1 = _modNatAlignDist_T ? io_b_sig : io_a_sig; // @[AddRecFN.scala 88:29]
  wire [52:0] far_sigLarger = _far_sigLarger_T_1[52:0]; // @[AddRecFN.scala 88:66]
  wire [53:0] _far_sigSmaller_T_1 = _modNatAlignDist_T ? io_a_sig : io_b_sig; // @[AddRecFN.scala 89:29]
  wire [52:0] far_sigSmaller = _far_sigSmaller_T_1[52:0]; // @[AddRecFN.scala 89:66]
  wire [57:0] _far_mainAlignedSigSmaller_T = {far_sigSmaller, 5'h0}; // @[AddRecFN.scala 90:52]
  wire [57:0] far_mainAlignedSigSmaller = _far_mainAlignedSigSmaller_T >> alignDist; // @[AddRecFN.scala 90:56]
  wire [54:0] _far_reduced4SigSmaller_T = {far_sigSmaller, 2'h0}; // @[AddRecFN.scala 91:60]
  wire  far_reduced4SigSmaller_reducedVec_0 = |_far_reduced4SigSmaller_T[3:0]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_1 = |_far_reduced4SigSmaller_T[7:4]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_2 = |_far_reduced4SigSmaller_T[11:8]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_3 = |_far_reduced4SigSmaller_T[15:12]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_4 = |_far_reduced4SigSmaller_T[19:16]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_5 = |_far_reduced4SigSmaller_T[23:20]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_6 = |_far_reduced4SigSmaller_T[27:24]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_7 = |_far_reduced4SigSmaller_T[31:28]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_8 = |_far_reduced4SigSmaller_T[35:32]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_9 = |_far_reduced4SigSmaller_T[39:36]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_10 = |_far_reduced4SigSmaller_T[43:40]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_11 = |_far_reduced4SigSmaller_T[47:44]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_12 = |_far_reduced4SigSmaller_T[51:48]; // @[primitives.scala 120:54]
  wire  far_reduced4SigSmaller_reducedVec_13 = |_far_reduced4SigSmaller_T[54:52]; // @[primitives.scala 123:57]
  wire [6:0] far_reduced4SigSmaller_lo = {far_reduced4SigSmaller_reducedVec_6,far_reduced4SigSmaller_reducedVec_5,
    far_reduced4SigSmaller_reducedVec_4,far_reduced4SigSmaller_reducedVec_3,far_reduced4SigSmaller_reducedVec_2,
    far_reduced4SigSmaller_reducedVec_1,far_reduced4SigSmaller_reducedVec_0}; // @[primitives.scala 124:20]
  wire [13:0] far_reduced4SigSmaller = {far_reduced4SigSmaller_reducedVec_13,far_reduced4SigSmaller_reducedVec_12,
    far_reduced4SigSmaller_reducedVec_11,far_reduced4SigSmaller_reducedVec_10,far_reduced4SigSmaller_reducedVec_9,
    far_reduced4SigSmaller_reducedVec_8,far_reduced4SigSmaller_reducedVec_7,far_reduced4SigSmaller_lo}; // @[primitives.scala 124:20]
  wire [16:0] far_roundExtraMask_shift = 17'sh10000 >>> alignDist[5:2]; // @[primitives.scala 76:56]
  wire [7:0] _GEN_3 = {{4'd0}, far_roundExtraMask_shift[9:6]}; // @[Bitwise.scala 108:31]
  wire [7:0] _far_roundExtraMask_T_6 = _GEN_3 & 8'hf; // @[Bitwise.scala 108:31]
  wire [7:0] _far_roundExtraMask_T_8 = {far_roundExtraMask_shift[5:2], 4'h0}; // @[Bitwise.scala 108:70]
  wire [7:0] _far_roundExtraMask_T_10 = _far_roundExtraMask_T_8 & 8'hf0; // @[Bitwise.scala 108:80]
  wire [7:0] _far_roundExtraMask_T_11 = _far_roundExtraMask_T_6 | _far_roundExtraMask_T_10; // @[Bitwise.scala 108:39]
  wire [7:0] _GEN_4 = {{2'd0}, _far_roundExtraMask_T_11[7:2]}; // @[Bitwise.scala 108:31]
  wire [7:0] _far_roundExtraMask_T_16 = _GEN_4 & 8'h33; // @[Bitwise.scala 108:31]
  wire [7:0] _far_roundExtraMask_T_18 = {_far_roundExtraMask_T_11[5:0], 2'h0}; // @[Bitwise.scala 108:70]
  wire [7:0] _far_roundExtraMask_T_20 = _far_roundExtraMask_T_18 & 8'hcc; // @[Bitwise.scala 108:80]
  wire [7:0] _far_roundExtraMask_T_21 = _far_roundExtraMask_T_16 | _far_roundExtraMask_T_20; // @[Bitwise.scala 108:39]
  wire [7:0] _GEN_5 = {{1'd0}, _far_roundExtraMask_T_21[7:1]}; // @[Bitwise.scala 108:31]
  wire [7:0] _far_roundExtraMask_T_26 = _GEN_5 & 8'h55; // @[Bitwise.scala 108:31]
  wire [7:0] _far_roundExtraMask_T_28 = {_far_roundExtraMask_T_21[6:0], 1'h0}; // @[Bitwise.scala 108:70]
  wire [7:0] _far_roundExtraMask_T_30 = _far_roundExtraMask_T_28 & 8'haa; // @[Bitwise.scala 108:80]
  wire [7:0] _far_roundExtraMask_T_31 = _far_roundExtraMask_T_26 | _far_roundExtraMask_T_30; // @[Bitwise.scala 108:39]
  wire [13:0] far_roundExtraMask = {_far_roundExtraMask_T_31,far_roundExtraMask_shift[10],far_roundExtraMask_shift[11],
    far_roundExtraMask_shift[12],far_roundExtraMask_shift[13],far_roundExtraMask_shift[14],far_roundExtraMask_shift[15]}
    ; // @[Cat.scala 33:92]
  wire [13:0] _far_alignedSigSmaller_T_3 = far_reduced4SigSmaller & far_roundExtraMask; // @[AddRecFN.scala 95:76]
  wire  _far_alignedSigSmaller_T_5 = |far_mainAlignedSigSmaller[2:0] | |_far_alignedSigSmaller_T_3; // @[AddRecFN.scala 95:49]
  wire [55:0] far_alignedSigSmaller = {far_mainAlignedSigSmaller[57:3],_far_alignedSigSmaller_T_5}; // @[Cat.scala 33:92]
  wire [55:0] _far_negAlignedSigSmaller_T = ~far_alignedSigSmaller; // @[AddRecFN.scala 97:62]
  wire [56:0] _far_negAlignedSigSmaller_T_1 = {1'h1,_far_negAlignedSigSmaller_T}; // @[Cat.scala 33:92]
  wire [56:0] far_negAlignedSigSmaller = _closeSubMags_T ? _far_negAlignedSigSmaller_T_1 : {{1'd0},
    far_alignedSigSmaller}; // @[AddRecFN.scala 97:39]
  wire [55:0] _far_sigSum_T = {far_sigLarger, 3'h0}; // @[AddRecFN.scala 98:36]
  wire [56:0] _GEN_6 = {{1'd0}, _far_sigSum_T}; // @[AddRecFN.scala 98:41]
  wire [56:0] _far_sigSum_T_2 = _GEN_6 + far_negAlignedSigSmaller; // @[AddRecFN.scala 98:41]
  wire [56:0] _GEN_7 = {{56'd0}, _closeSubMags_T}; // @[AddRecFN.scala 98:68]
  wire [56:0] far_sigSum = _far_sigSum_T_2 + _GEN_7; // @[AddRecFN.scala 98:68]
  wire [55:0] _GEN_8 = {{55'd0}, far_sigSum[0]}; // @[AddRecFN.scala 99:67]
  wire [55:0] _far_sigOut_T_2 = far_sigSum[56:1] | _GEN_8; // @[AddRecFN.scala 99:67]
  wire [56:0] _far_sigOut_T_3 = _closeSubMags_T ? far_sigSum : {{1'd0}, _far_sigOut_T_2}; // @[AddRecFN.scala 99:25]
  wire [55:0] far_sigOut = _far_sigOut_T_3[55:0]; // @[AddRecFN.scala 99:83]
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
  wire [12:0] _common_sExpOut_T_2 = closeSubMags | _modNatAlignDist_T ? $signed(io_b_sExp) : $signed(io_a_sExp); // @[AddRecFN.scala 116:13]
  wire [5:0] _common_sExpOut_T_3 = closeSubMags ? close_nearNormDist : {{5'd0}, _closeSubMags_T}; // @[AddRecFN.scala 117:18]
  wire [6:0] _common_sExpOut_T_4 = {1'b0,$signed(_common_sExpOut_T_3)}; // @[AddRecFN.scala 117:66]
  wire [12:0] _GEN_9 = {{6{_common_sExpOut_T_4[6]}},_common_sExpOut_T_4}; // @[AddRecFN.scala 117:13]
  wire  _io_invalidExc_T_2 = io_a_isNaN & ~io_a_sig[51]; // @[common.scala 82:46]
  wire  _io_invalidExc_T_5 = io_b_isNaN & ~io_b_sig[51]; // @[common.scala 82:46]
  assign io_invalidExc = _io_invalidExc_T_2 | _io_invalidExc_T_5 | notSigNaN_invalidExc; // @[AddRecFN.scala 121:71]
  assign io_rawOut_isNaN = io_a_isNaN | io_b_isNaN; // @[AddRecFN.scala 125:35]
  assign io_rawOut_isInf = io_a_isInf | io_b_isInf; // @[AddRecFN.scala 103:38]
  assign io_rawOut_isZero = addZeros | ~notNaN_isInfOut & closeSubMags & close_totalCancellation; // @[AddRecFN.scala 106:37]
  assign io_rawOut_sign = _notNaN_signOut_T_14 | _notNaN_signOut_T_18; // @[AddRecFN.scala 113:77]
  assign io_rawOut_sExp = $signed(_common_sExpOut_T_2) - $signed(_GEN_9); // @[AddRecFN.scala 117:13]
  assign io_rawOut_sig = closeSubMags ? close_sigOut : far_sigOut; // @[AddRecFN.scala 118:28]
endmodule
module RoundAnyRawFNToRecFN_ie11_is55_oe11_os53(
  input         io_invalidExc,
  input         io_infiniteExc,
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
  wire  notNaN_isSpecialInfOut = io_infiniteExc | io_in_isInf; // @[RoundAnyRawFNToRecFN.scala 236:49]
  wire  commonCase = ~isNaNOut & ~notNaN_isSpecialInfOut & ~io_in_isZero; // @[RoundAnyRawFNToRecFN.scala 237:61]
  wire  overflow = commonCase & common_overflow; // @[RoundAnyRawFNToRecFN.scala 238:32]
  wire  underflow = commonCase & common_underflow; // @[RoundAnyRawFNToRecFN.scala 239:32]
  wire  inexact = overflow | commonCase & common_inexact; // @[RoundAnyRawFNToRecFN.scala 240:28]
  wire  overflow_roundMagUp = _roundIncr_T | roundMagUp; // @[RoundAnyRawFNToRecFN.scala 243:60]
  wire  pegMinNonzeroMagOut = commonCase & common_totalUnderflow & (roundMagUp | roundingMode_odd); // @[RoundAnyRawFNToRecFN.scala 245:45]
  wire  pegMaxFiniteMagOut = overflow & ~overflow_roundMagUp; // @[RoundAnyRawFNToRecFN.scala 246:39]
  wire  notNaN_isInfOut = notNaN_isSpecialInfOut | overflow & overflow_roundMagUp; // @[RoundAnyRawFNToRecFN.scala 248:32]
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
  wire [3:0] _io_exceptionFlags_T_2 = {io_invalidExc,io_infiniteExc,overflow,underflow}; // @[RoundAnyRawFNToRecFN.scala 288:53]
  assign io_out = {_io_out_T,fractOut}; // @[RoundAnyRawFNToRecFN.scala 286:33]
  assign io_exceptionFlags = {_io_exceptionFlags_T_2,inexact}; // @[RoundAnyRawFNToRecFN.scala 288:66]
endmodule
module RoundRawFNToRecFN_e11_s53(
  input         io_invalidExc,
  input         io_infiniteExc,
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
  wire  roundAnyRawFNToRecFN_io_infiniteExc; // @[RoundAnyRawFNToRecFN.scala 310:15]
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
    .io_infiniteExc(roundAnyRawFNToRecFN_io_infiniteExc),
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
  assign roundAnyRawFNToRecFN_io_infiniteExc = io_infiniteExc; // @[RoundAnyRawFNToRecFN.scala 314:44]
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
  input  [64:0] io_a,
  input  [64:0] io_b,
  input  [2:0]  io_roundingMode,
  output [64:0] io_out,
  output [4:0]  io_exceptionFlags
);
  wire  addRawFN__io_subOp; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_a_isNaN; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_a_isInf; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_a_isZero; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_a_sign; // @[AddRecFN.scala 147:26]
  wire [12:0] addRawFN__io_a_sExp; // @[AddRecFN.scala 147:26]
  wire [53:0] addRawFN__io_a_sig; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_b_isNaN; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_b_isInf; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_b_isZero; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_b_sign; // @[AddRecFN.scala 147:26]
  wire [12:0] addRawFN__io_b_sExp; // @[AddRecFN.scala 147:26]
  wire [53:0] addRawFN__io_b_sig; // @[AddRecFN.scala 147:26]
  wire [2:0] addRawFN__io_roundingMode; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_invalidExc; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_rawOut_isNaN; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_rawOut_isInf; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_rawOut_isZero; // @[AddRecFN.scala 147:26]
  wire  addRawFN__io_rawOut_sign; // @[AddRecFN.scala 147:26]
  wire [12:0] addRawFN__io_rawOut_sExp; // @[AddRecFN.scala 147:26]
  wire [55:0] addRawFN__io_rawOut_sig; // @[AddRecFN.scala 147:26]
  wire  roundRawFNToRecFN_io_invalidExc; // @[AddRecFN.scala 157:15]
  wire  roundRawFNToRecFN_io_infiniteExc; // @[AddRecFN.scala 157:15]
  wire  roundRawFNToRecFN_io_in_isNaN; // @[AddRecFN.scala 157:15]
  wire  roundRawFNToRecFN_io_in_isInf; // @[AddRecFN.scala 157:15]
  wire  roundRawFNToRecFN_io_in_isZero; // @[AddRecFN.scala 157:15]
  wire  roundRawFNToRecFN_io_in_sign; // @[AddRecFN.scala 157:15]
  wire [12:0] roundRawFNToRecFN_io_in_sExp; // @[AddRecFN.scala 157:15]
  wire [55:0] roundRawFNToRecFN_io_in_sig; // @[AddRecFN.scala 157:15]
  wire [2:0] roundRawFNToRecFN_io_roundingMode; // @[AddRecFN.scala 157:15]
  wire [64:0] roundRawFNToRecFN_io_out; // @[AddRecFN.scala 157:15]
  wire [4:0] roundRawFNToRecFN_io_exceptionFlags; // @[AddRecFN.scala 157:15]
  wire [11:0] addRawFN_io_a_exp = io_a[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  addRawFN_io_a_isZero = addRawFN_io_a_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  addRawFN_io_a_isSpecial = addRawFN_io_a_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  _addRawFN_io_a_out_sig_T = ~addRawFN_io_a_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [1:0] _addRawFN_io_a_out_sig_T_1 = {1'h0,_addRawFN_io_a_out_sig_T}; // @[rawFloatFromRecFN.scala 61:32]
  wire [11:0] addRawFN_io_b_exp = io_b[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  addRawFN_io_b_isZero = addRawFN_io_b_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  addRawFN_io_b_isSpecial = addRawFN_io_b_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
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
  RoundRawFNToRecFN_e11_s53 roundRawFNToRecFN ( // @[AddRecFN.scala 157:15]
    .io_invalidExc(roundRawFNToRecFN_io_invalidExc),
    .io_infiniteExc(roundRawFNToRecFN_io_infiniteExc),
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
  assign addRawFN__io_a_isNaN = addRawFN_io_a_isSpecial & addRawFN_io_a_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  assign addRawFN__io_a_isInf = addRawFN_io_a_isSpecial & ~addRawFN_io_a_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  assign addRawFN__io_a_isZero = addRawFN_io_a_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign addRawFN__io_a_sign = io_a[64]; // @[rawFloatFromRecFN.scala 59:25]
  assign addRawFN__io_a_sExp = {1'b0,$signed(addRawFN_io_a_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  assign addRawFN__io_a_sig = {_addRawFN_io_a_out_sig_T_1,io_a[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  assign addRawFN__io_b_isNaN = addRawFN_io_b_isSpecial & addRawFN_io_b_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  assign addRawFN__io_b_isInf = addRawFN_io_b_isSpecial & ~addRawFN_io_b_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  assign addRawFN__io_b_isZero = addRawFN_io_b_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign addRawFN__io_b_sign = io_b[64]; // @[rawFloatFromRecFN.scala 59:25]
  assign addRawFN__io_b_sExp = {1'b0,$signed(addRawFN_io_b_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  assign addRawFN__io_b_sig = {_addRawFN_io_b_out_sig_T_1,io_b[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  assign addRawFN__io_roundingMode = io_roundingMode; // @[AddRecFN.scala 152:30]
  assign roundRawFNToRecFN_io_invalidExc = addRawFN__io_invalidExc; // @[AddRecFN.scala 158:39]
  assign roundRawFNToRecFN_io_infiniteExc = 1'h0; // @[AddRecFN.scala 159:39]
  assign roundRawFNToRecFN_io_in_isNaN = addRawFN__io_rawOut_isNaN; // @[AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_in_isInf = addRawFN__io_rawOut_isInf; // @[AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_in_isZero = addRawFN__io_rawOut_isZero; // @[AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_in_sign = addRawFN__io_rawOut_sign; // @[AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_in_sExp = addRawFN__io_rawOut_sExp; // @[AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_in_sig = addRawFN__io_rawOut_sig; // @[AddRecFN.scala 160:39]
  assign roundRawFNToRecFN_io_roundingMode = io_roundingMode; // @[AddRecFN.scala 161:39]
endmodule
module DivSqrtRawFN_small_e11_s53(
  input         clock,
  input         reset,
  output        io_inReady,
  input         io_inValid,
  input         io_sqrtOp,
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
  input  [2:0]  io_roundingMode,
  output        io_rawOutValid_div,
  output        io_rawOutValid_sqrt,
  output [2:0]  io_roundingModeOut,
  output        io_invalidExc,
  output        io_infiniteExc,
  output        io_rawOut_isNaN,
  output        io_rawOut_isInf,
  output        io_rawOut_isZero,
  output        io_rawOut_sign,
  output [12:0] io_rawOut_sExp,
  output [55:0] io_rawOut_sig
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [63:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [63:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [63:0] _RAND_14;
`endif // RANDOMIZE_REG_INIT
  reg [5:0] cycleNum; // @[DivSqrtRecFN_small.scala 224:33]
  reg  inReady; // @[DivSqrtRecFN_small.scala 225:33]
  reg  rawOutValid; // @[DivSqrtRecFN_small.scala 226:33]
  reg  sqrtOp_Z; // @[DivSqrtRecFN_small.scala 228:29]
  reg  majorExc_Z; // @[DivSqrtRecFN_small.scala 229:29]
  reg  isNaN_Z; // @[DivSqrtRecFN_small.scala 231:29]
  reg  isInf_Z; // @[DivSqrtRecFN_small.scala 232:29]
  reg  isZero_Z; // @[DivSqrtRecFN_small.scala 233:29]
  reg  sign_Z; // @[DivSqrtRecFN_small.scala 234:29]
  reg [12:0] sExp_Z; // @[DivSqrtRecFN_small.scala 235:29]
  reg [52:0] fractB_Z; // @[DivSqrtRecFN_small.scala 236:29]
  reg [2:0] roundingMode_Z; // @[DivSqrtRecFN_small.scala 237:29]
  reg [54:0] rem_Z; // @[DivSqrtRecFN_small.scala 243:29]
  reg  notZeroRem_Z; // @[DivSqrtRecFN_small.scala 244:29]
  reg [54:0] sigX_Z; // @[DivSqrtRecFN_small.scala 245:29]
  wire  notSigNaNIn_invalidExc_S_div = io_a_isZero & io_b_isZero | io_a_isInf & io_b_isInf; // @[DivSqrtRecFN_small.scala 254:42]
  wire  _notSigNaNIn_invalidExc_S_sqrt_T = ~io_a_isNaN; // @[DivSqrtRecFN_small.scala 256:9]
  wire  notSigNaNIn_invalidExc_S_sqrt = ~io_a_isNaN & ~io_a_isZero & io_a_sign; // @[DivSqrtRecFN_small.scala 256:43]
  wire  _majorExc_S_T_2 = io_a_isNaN & ~io_a_sig[51]; // @[common.scala 82:46]
  wire  _majorExc_S_T_3 = _majorExc_S_T_2 | notSigNaNIn_invalidExc_S_sqrt; // @[DivSqrtRecFN_small.scala 259:38]
  wire  _majorExc_S_T_9 = io_b_isNaN & ~io_b_sig[51]; // @[common.scala 82:46]
  wire  _majorExc_S_T_11 = _majorExc_S_T_2 | _majorExc_S_T_9 | notSigNaNIn_invalidExc_S_div; // @[DivSqrtRecFN_small.scala 260:66]
  wire  _majorExc_S_T_15 = _notSigNaNIn_invalidExc_S_sqrt_T & ~io_a_isInf & io_b_isZero; // @[DivSqrtRecFN_small.scala 262:51]
  wire  _majorExc_S_T_16 = _majorExc_S_T_11 | _majorExc_S_T_15; // @[DivSqrtRecFN_small.scala 261:46]
  wire  _isNaN_S_T = io_a_isNaN | notSigNaNIn_invalidExc_S_sqrt; // @[DivSqrtRecFN_small.scala 266:26]
  wire  _isNaN_S_T_2 = io_a_isNaN | io_b_isNaN | notSigNaNIn_invalidExc_S_div; // @[DivSqrtRecFN_small.scala 267:42]
  wire  _sign_S_T = ~io_sqrtOp; // @[DivSqrtRecFN_small.scala 271:33]
  wire  sign_S = io_a_sign ^ ~io_sqrtOp & io_b_sign; // @[DivSqrtRecFN_small.scala 271:30]
  wire  specialCaseA_S = io_a_isNaN | io_a_isInf | io_a_isZero; // @[DivSqrtRecFN_small.scala 273:55]
  wire  specialCaseB_S = io_b_isNaN | io_b_isInf | io_b_isZero; // @[DivSqrtRecFN_small.scala 274:55]
  wire  _normalCase_S_div_T = ~specialCaseA_S; // @[DivSqrtRecFN_small.scala 275:28]
  wire  normalCase_S_div = ~specialCaseA_S & ~specialCaseB_S; // @[DivSqrtRecFN_small.scala 275:45]
  wire  normalCase_S_sqrt = _normalCase_S_div_T & ~io_a_sign; // @[DivSqrtRecFN_small.scala 276:46]
  wire  normalCase_S = io_sqrtOp ? normalCase_S_sqrt : normalCase_S_div; // @[DivSqrtRecFN_small.scala 277:27]
  wire [10:0] _sExpQuot_S_div_T_2 = ~io_b_sExp[10:0]; // @[DivSqrtRecFN_small.scala 281:40]
  wire [11:0] _sExpQuot_S_div_T_4 = {io_b_sExp[11],_sExpQuot_S_div_T_2}; // @[DivSqrtRecFN_small.scala 281:71]
  wire [12:0] _GEN_15 = {{1{_sExpQuot_S_div_T_4[11]}},_sExpQuot_S_div_T_4}; // @[DivSqrtRecFN_small.scala 280:21]
  wire [13:0] sExpQuot_S_div = $signed(io_a_sExp) + $signed(_GEN_15); // @[DivSqrtRecFN_small.scala 280:21]
  wire [3:0] _sSatExpQuot_S_div_T_2 = 14'she00 <= $signed(sExpQuot_S_div) ? 4'h6 : sExpQuot_S_div[12:9]; // @[DivSqrtRecFN_small.scala 284:16]
  wire [12:0] sSatExpQuot_S_div = {_sSatExpQuot_S_div_T_2,sExpQuot_S_div[8:0]}; // @[DivSqrtRecFN_small.scala 289:11]
  wire  _evenSqrt_S_T_1 = ~io_a_sExp[0]; // @[DivSqrtRecFN_small.scala 291:35]
  wire  evenSqrt_S = io_sqrtOp & ~io_a_sExp[0]; // @[DivSqrtRecFN_small.scala 291:32]
  wire  oddSqrt_S = io_sqrtOp & io_a_sExp[0]; // @[DivSqrtRecFN_small.scala 292:32]
  wire  idle = cycleNum == 6'h0; // @[DivSqrtRecFN_small.scala 296:25]
  wire  entering = inReady & io_inValid; // @[DivSqrtRecFN_small.scala 297:28]
  wire  entering_normalCase = entering & normalCase_S; // @[DivSqrtRecFN_small.scala 298:40]
  wire  skipCycle2 = cycleNum == 6'h3 & sigX_Z[54]; // @[DivSqrtRecFN_small.scala 301:39]
  wire  _inReady_T_1 = entering & ~normalCase_S; // @[DivSqrtRecFN_small.scala 305:26]
  wire [5:0] _inReady_T_17 = cycleNum - 6'h1; // @[DivSqrtRecFN_small.scala 313:56]
  wire  _inReady_T_18 = _inReady_T_17 <= 6'h1; // @[DivSqrtRecFN_small.scala 317:38]
  wire  _inReady_T_19 = ~entering & ~skipCycle2 & _inReady_T_18; // @[DivSqrtRecFN_small.scala 313:16]
  wire  _inReady_T_20 = _inReady_T_1 | _inReady_T_19; // @[DivSqrtRecFN_small.scala 312:15]
  wire  _inReady_T_23 = _inReady_T_20 | skipCycle2; // @[DivSqrtRecFN_small.scala 313:95]
  wire  _rawOutValid_T_18 = _inReady_T_17 == 6'h1; // @[DivSqrtRecFN_small.scala 318:42]
  wire  _rawOutValid_T_19 = ~entering & ~skipCycle2 & _rawOutValid_T_18; // @[DivSqrtRecFN_small.scala 313:16]
  wire  _rawOutValid_T_20 = _inReady_T_1 | _rawOutValid_T_19; // @[DivSqrtRecFN_small.scala 312:15]
  wire  _rawOutValid_T_23 = _rawOutValid_T_20 | skipCycle2; // @[DivSqrtRecFN_small.scala 313:95]
  wire [5:0] _cycleNum_T_4 = io_a_sExp[0] ? 6'h35 : 6'h36; // @[DivSqrtRecFN_small.scala 308:24]
  wire [5:0] _cycleNum_T_5 = io_sqrtOp ? _cycleNum_T_4 : 6'h37; // @[DivSqrtRecFN_small.scala 307:20]
  wire [5:0] _cycleNum_T_6 = entering_normalCase ? _cycleNum_T_5 : 6'h0; // @[DivSqrtRecFN_small.scala 306:16]
  wire [5:0] _GEN_16 = {{5'd0}, _inReady_T_1}; // @[DivSqrtRecFN_small.scala 305:57]
  wire [5:0] _cycleNum_T_7 = _GEN_16 | _cycleNum_T_6; // @[DivSqrtRecFN_small.scala 305:57]
  wire [5:0] _cycleNum_T_14 = ~entering & ~skipCycle2 ? _inReady_T_17 : 6'h0; // @[DivSqrtRecFN_small.scala 313:16]
  wire [5:0] _cycleNum_T_15 = _cycleNum_T_7 | _cycleNum_T_14; // @[DivSqrtRecFN_small.scala 312:15]
  wire [5:0] _GEN_17 = {{5'd0}, skipCycle2}; // @[DivSqrtRecFN_small.scala 313:95]
  wire [5:0] _cycleNum_T_17 = _cycleNum_T_15 | _GEN_17; // @[DivSqrtRecFN_small.scala 313:95]
  wire  _GEN_0 = ~idle | entering ? _inReady_T_23 : inReady; // @[DivSqrtRecFN_small.scala 303:31 317:17 225:33]
  wire [11:0] _sExp_Z_T = io_a_sExp[12:1]; // @[DivSqrtRecFN_small.scala 335:29]
  wire [12:0] _sExp_Z_T_1 = $signed(_sExp_Z_T) + 12'sh400; // @[DivSqrtRecFN_small.scala 335:34]
  wire  _T_2 = ~inReady; // @[DivSqrtRecFN_small.scala 340:23]
  wire  _T_3 = ~inReady & sqrtOp_Z; // @[DivSqrtRecFN_small.scala 340:33]
  wire  _fractB_Z_T_1 = inReady & _sign_S_T; // @[DivSqrtRecFN_small.scala 342:25]
  wire [52:0] _fractB_Z_T_3 = {io_b_sig[51:0], 1'h0}; // @[DivSqrtRecFN_small.scala 342:90]
  wire [52:0] _fractB_Z_T_4 = inReady & _sign_S_T ? _fractB_Z_T_3 : 53'h0; // @[DivSqrtRecFN_small.scala 342:16]
  wire  _fractB_Z_T_5 = inReady & io_sqrtOp; // @[DivSqrtRecFN_small.scala 343:25]
  wire [51:0] _fractB_Z_T_8 = inReady & io_sqrtOp & io_a_sExp[0] ? 52'h8000000000000 : 52'h0; // @[DivSqrtRecFN_small.scala 343:16]
  wire [52:0] _GEN_18 = {{1'd0}, _fractB_Z_T_8}; // @[DivSqrtRecFN_small.scala 342:100]
  wire [52:0] _fractB_Z_T_9 = _fractB_Z_T_4 | _GEN_18; // @[DivSqrtRecFN_small.scala 342:100]
  wire [52:0] _fractB_Z_T_14 = _fractB_Z_T_5 & _evenSqrt_S_T_1 ? 53'h10000000000000 : 53'h0; // @[DivSqrtRecFN_small.scala 344:16]
  wire [52:0] _fractB_Z_T_15 = _fractB_Z_T_9 | _fractB_Z_T_14; // @[DivSqrtRecFN_small.scala 343:100]
  wire [51:0] _fractB_Z_T_25 = _T_2 ? fractB_Z[52:1] : 52'h0; // @[DivSqrtRecFN_small.scala 346:16]
  wire [52:0] _GEN_19 = {{1'd0}, _fractB_Z_T_25}; // @[DivSqrtRecFN_small.scala 345:100]
  wire [52:0] _fractB_Z_T_26 = _fractB_Z_T_15 | _GEN_19; // @[DivSqrtRecFN_small.scala 345:100]
  wire [54:0] _rem_T_2 = {io_a_sig, 1'h0}; // @[DivSqrtRecFN_small.scala 352:47]
  wire [54:0] _rem_T_3 = inReady & ~oddSqrt_S ? _rem_T_2 : 55'h0; // @[DivSqrtRecFN_small.scala 352:12]
  wire  _rem_T_4 = inReady & oddSqrt_S; // @[DivSqrtRecFN_small.scala 353:21]
  wire [1:0] _rem_T_7 = io_a_sig[52:51] - 2'h1; // @[DivSqrtRecFN_small.scala 354:56]
  wire [53:0] _rem_T_9 = {io_a_sig[50:0], 3'h0}; // @[DivSqrtRecFN_small.scala 355:44]
  wire [55:0] _rem_T_10 = {_rem_T_7,_rem_T_9}; // @[Cat.scala 33:92]
  wire [55:0] _rem_T_11 = inReady & oddSqrt_S ? _rem_T_10 : 56'h0; // @[DivSqrtRecFN_small.scala 353:12]
  wire [55:0] _GEN_20 = {{1'd0}, _rem_T_3}; // @[DivSqrtRecFN_small.scala 352:57]
  wire [55:0] _rem_T_12 = _GEN_20 | _rem_T_11; // @[DivSqrtRecFN_small.scala 352:57]
  wire [55:0] _rem_T_14 = {rem_Z, 1'h0}; // @[DivSqrtRecFN_small.scala 359:29]
  wire [55:0] _rem_T_15 = _T_2 ? _rem_T_14 : 56'h0; // @[DivSqrtRecFN_small.scala 359:12]
  wire [55:0] rem = _rem_T_12 | _rem_T_15; // @[DivSqrtRecFN_small.scala 358:11]
  wire [63:0] _bitMask_T = 64'h1 << cycleNum; // @[DivSqrtRecFN_small.scala 360:23]
  wire [61:0] bitMask = _bitMask_T[63:2]; // @[DivSqrtRecFN_small.scala 360:34]
  wire [54:0] _trialTerm_T_2 = {io_b_sig, 1'h0}; // @[DivSqrtRecFN_small.scala 362:48]
  wire [54:0] _trialTerm_T_3 = _fractB_Z_T_1 ? _trialTerm_T_2 : 55'h0; // @[DivSqrtRecFN_small.scala 362:12]
  wire [53:0] _trialTerm_T_5 = inReady & evenSqrt_S ? 54'h20000000000000 : 54'h0; // @[DivSqrtRecFN_small.scala 363:12]
  wire [54:0] _GEN_21 = {{1'd0}, _trialTerm_T_5}; // @[DivSqrtRecFN_small.scala 362:74]
  wire [54:0] _trialTerm_T_6 = _trialTerm_T_3 | _GEN_21; // @[DivSqrtRecFN_small.scala 362:74]
  wire [54:0] _trialTerm_T_8 = _rem_T_4 ? 55'h50000000000000 : 55'h0; // @[DivSqrtRecFN_small.scala 364:12]
  wire [54:0] _trialTerm_T_9 = _trialTerm_T_6 | _trialTerm_T_8; // @[DivSqrtRecFN_small.scala 363:74]
  wire [52:0] _trialTerm_T_11 = _T_2 ? fractB_Z : 53'h0; // @[DivSqrtRecFN_small.scala 365:12]
  wire [54:0] _GEN_22 = {{2'd0}, _trialTerm_T_11}; // @[DivSqrtRecFN_small.scala 364:74]
  wire [54:0] _trialTerm_T_12 = _trialTerm_T_9 | _GEN_22; // @[DivSqrtRecFN_small.scala 364:74]
  wire  _trialTerm_T_14 = ~sqrtOp_Z; // @[DivSqrtRecFN_small.scala 366:26]
  wire [53:0] _trialTerm_T_17 = _T_2 & ~sqrtOp_Z ? 54'h20000000000000 : 54'h0; // @[DivSqrtRecFN_small.scala 366:12]
  wire [54:0] _GEN_23 = {{1'd0}, _trialTerm_T_17}; // @[DivSqrtRecFN_small.scala 365:74]
  wire [54:0] _trialTerm_T_18 = _trialTerm_T_12 | _GEN_23; // @[DivSqrtRecFN_small.scala 365:74]
  wire [55:0] _trialTerm_T_21 = {sigX_Z, 1'h0}; // @[DivSqrtRecFN_small.scala 367:44]
  wire [55:0] _trialTerm_T_22 = _T_3 ? _trialTerm_T_21 : 56'h0; // @[DivSqrtRecFN_small.scala 367:12]
  wire [55:0] _GEN_24 = {{1'd0}, _trialTerm_T_18}; // @[DivSqrtRecFN_small.scala 366:74]
  wire [55:0] trialTerm = _GEN_24 | _trialTerm_T_22; // @[DivSqrtRecFN_small.scala 366:74]
  wire [56:0] _trialRem_T = {1'b0,$signed(rem)}; // @[DivSqrtRecFN_small.scala 368:24]
  wire [56:0] _trialRem_T_1 = {1'b0,$signed(trialTerm)}; // @[DivSqrtRecFN_small.scala 368:42]
  wire [57:0] trialRem = $signed(_trialRem_T) - $signed(_trialRem_T_1); // @[DivSqrtRecFN_small.scala 368:29]
  wire  newBit = 58'sh0 <= $signed(trialRem); // @[DivSqrtRecFN_small.scala 369:23]
  wire [57:0] _nextRem_Z_T = $signed(_trialRem_T) - $signed(_trialRem_T_1); // @[DivSqrtRecFN_small.scala 371:42]
  wire [57:0] _nextRem_Z_T_1 = newBit ? _nextRem_Z_T : {{2'd0}, rem}; // @[DivSqrtRecFN_small.scala 371:24]
  wire [54:0] nextRem_Z = _nextRem_Z_T_1[54:0]; // @[DivSqrtRecFN_small.scala 371:54]
  wire [54:0] _sigX_Z_T_2 = {newBit, 54'h0}; // @[DivSqrtRecFN_small.scala 394:50]
  wire [54:0] _sigX_Z_T_3 = _fractB_Z_T_1 ? _sigX_Z_T_2 : 55'h0; // @[DivSqrtRecFN_small.scala 394:16]
  wire [53:0] _sigX_Z_T_5 = _fractB_Z_T_5 ? 54'h20000000000000 : 54'h0; // @[DivSqrtRecFN_small.scala 395:16]
  wire [54:0] _GEN_30 = {{1'd0}, _sigX_Z_T_5}; // @[DivSqrtRecFN_small.scala 394:74]
  wire [54:0] _sigX_Z_T_6 = _sigX_Z_T_3 | _GEN_30; // @[DivSqrtRecFN_small.scala 394:74]
  wire [52:0] _sigX_Z_T_8 = {newBit, 52'h0}; // @[DivSqrtRecFN_small.scala 396:50]
  wire [52:0] _sigX_Z_T_9 = _rem_T_4 ? _sigX_Z_T_8 : 53'h0; // @[DivSqrtRecFN_small.scala 396:16]
  wire [54:0] _GEN_31 = {{2'd0}, _sigX_Z_T_9}; // @[DivSqrtRecFN_small.scala 395:74]
  wire [54:0] _sigX_Z_T_10 = _sigX_Z_T_6 | _GEN_31; // @[DivSqrtRecFN_small.scala 395:74]
  wire [54:0] _sigX_Z_T_12 = _T_2 ? sigX_Z : 55'h0; // @[DivSqrtRecFN_small.scala 397:16]
  wire [54:0] _sigX_Z_T_13 = _sigX_Z_T_10 | _sigX_Z_T_12; // @[DivSqrtRecFN_small.scala 396:74]
  wire [61:0] _sigX_Z_T_16 = _T_2 & newBit ? bitMask : 62'h0; // @[DivSqrtRecFN_small.scala 398:16]
  wire [61:0] _GEN_32 = {{7'd0}, _sigX_Z_T_13}; // @[DivSqrtRecFN_small.scala 397:74]
  wire [61:0] _sigX_Z_T_17 = _GEN_32 | _sigX_Z_T_16; // @[DivSqrtRecFN_small.scala 397:74]
  wire [61:0] _GEN_14 = entering | _T_2 ? _sigX_Z_T_17 : {{7'd0}, sigX_Z}; // @[DivSqrtRecFN_small.scala 390:34 393:16 245:29]
  wire [55:0] _GEN_33 = {{55'd0}, notZeroRem_Z}; // @[DivSqrtRecFN_small.scala 414:35]
  assign io_inReady = inReady; // @[DivSqrtRecFN_small.scala 322:16]
  assign io_rawOutValid_div = rawOutValid & _trialTerm_T_14; // @[DivSqrtRecFN_small.scala 404:40]
  assign io_rawOutValid_sqrt = rawOutValid & sqrtOp_Z; // @[DivSqrtRecFN_small.scala 405:40]
  assign io_roundingModeOut = roundingMode_Z; // @[DivSqrtRecFN_small.scala 406:25]
  assign io_invalidExc = majorExc_Z & isNaN_Z; // @[DivSqrtRecFN_small.scala 407:36]
  assign io_infiniteExc = majorExc_Z & ~isNaN_Z; // @[DivSqrtRecFN_small.scala 408:36]
  assign io_rawOut_isNaN = isNaN_Z; // @[DivSqrtRecFN_small.scala 409:22]
  assign io_rawOut_isInf = isInf_Z; // @[DivSqrtRecFN_small.scala 410:22]
  assign io_rawOut_isZero = isZero_Z; // @[DivSqrtRecFN_small.scala 411:22]
  assign io_rawOut_sign = sign_Z; // @[DivSqrtRecFN_small.scala 412:22]
  assign io_rawOut_sExp = sExp_Z; // @[DivSqrtRecFN_small.scala 413:22]
  assign io_rawOut_sig = _trialTerm_T_21 | _GEN_33; // @[DivSqrtRecFN_small.scala 414:35]
  always @(posedge clock) begin
    if (reset) begin // @[DivSqrtRecFN_small.scala 224:33]
      cycleNum <= 6'h0; // @[DivSqrtRecFN_small.scala 224:33]
    end else if (~idle | entering) begin // @[DivSqrtRecFN_small.scala 303:31]
      cycleNum <= _cycleNum_T_17; // @[DivSqrtRecFN_small.scala 319:18]
    end
    inReady <= reset | _GEN_0; // @[DivSqrtRecFN_small.scala 225:{33,33}]
    if (reset) begin // @[DivSqrtRecFN_small.scala 226:33]
      rawOutValid <= 1'h0; // @[DivSqrtRecFN_small.scala 226:33]
    end else if (~idle | entering) begin // @[DivSqrtRecFN_small.scala 303:31]
      rawOutValid <= _rawOutValid_T_23; // @[DivSqrtRecFN_small.scala 318:21]
    end
    if (entering) begin // @[DivSqrtRecFN_small.scala 326:21]
      sqrtOp_Z <= io_sqrtOp; // @[DivSqrtRecFN_small.scala 327:20]
    end
    if (entering) begin // @[DivSqrtRecFN_small.scala 326:21]
      if (io_sqrtOp) begin // @[DivSqrtRecFN_small.scala 258:12]
        majorExc_Z <= _majorExc_S_T_3;
      end else begin
        majorExc_Z <= _majorExc_S_T_16;
      end
    end
    if (entering) begin // @[DivSqrtRecFN_small.scala 326:21]
      if (io_sqrtOp) begin // @[DivSqrtRecFN_small.scala 265:12]
        isNaN_Z <= _isNaN_S_T;
      end else begin
        isNaN_Z <= _isNaN_S_T_2;
      end
    end
    if (entering) begin // @[DivSqrtRecFN_small.scala 326:21]
      if (io_sqrtOp) begin // @[DivSqrtRecFN_small.scala 269:23]
        isInf_Z <= io_a_isInf;
      end else begin
        isInf_Z <= io_a_isInf | io_b_isZero;
      end
    end
    if (entering) begin // @[DivSqrtRecFN_small.scala 326:21]
      if (io_sqrtOp) begin // @[DivSqrtRecFN_small.scala 270:23]
        isZero_Z <= io_a_isZero;
      end else begin
        isZero_Z <= io_a_isZero | io_b_isInf;
      end
    end
    if (entering) begin // @[DivSqrtRecFN_small.scala 326:21]
      sign_Z <= sign_S; // @[DivSqrtRecFN_small.scala 332:20]
    end
    if (entering) begin // @[DivSqrtRecFN_small.scala 326:21]
      if (io_sqrtOp) begin // @[DivSqrtRecFN_small.scala 334:16]
        sExp_Z <= _sExp_Z_T_1;
      end else begin
        sExp_Z <= sSatExpQuot_S_div;
      end
    end
    if (entering | ~inReady & sqrtOp_Z) begin // @[DivSqrtRecFN_small.scala 340:46]
      fractB_Z <= _fractB_Z_T_26; // @[DivSqrtRecFN_small.scala 341:18]
    end
    if (entering) begin // @[DivSqrtRecFN_small.scala 326:21]
      roundingMode_Z <= io_roundingMode; // @[DivSqrtRecFN_small.scala 338:24]
    end
    if (entering | _T_2) begin // @[DivSqrtRecFN_small.scala 390:34]
      rem_Z <= nextRem_Z; // @[DivSqrtRecFN_small.scala 392:15]
    end
    if (entering | _T_2) begin // @[DivSqrtRecFN_small.scala 390:34]
      if (inReady | newBit) begin // @[DivSqrtRecFN_small.scala 380:31]
        notZeroRem_Z <= $signed(trialRem) != 58'sh0;
      end
    end
    sigX_Z <= _GEN_14[54:0];
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  cycleNum = _RAND_0[5:0];
  _RAND_1 = {1{`RANDOM}};
  inReady = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  rawOutValid = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  sqrtOp_Z = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  majorExc_Z = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  isNaN_Z = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  isInf_Z = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  isZero_Z = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  sign_Z = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  sExp_Z = _RAND_9[12:0];
  _RAND_10 = {2{`RANDOM}};
  fractB_Z = _RAND_10[52:0];
  _RAND_11 = {1{`RANDOM}};
  roundingMode_Z = _RAND_11[2:0];
  _RAND_12 = {2{`RANDOM}};
  rem_Z = _RAND_12[54:0];
  _RAND_13 = {1{`RANDOM}};
  notZeroRem_Z = _RAND_13[0:0];
  _RAND_14 = {2{`RANDOM}};
  sigX_Z = _RAND_14[54:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module DivSqrtRecFMToRaw_small_e11_s53(
  input         clock,
  input         reset,
  output        io_inReady,
  input         io_inValid,
  input         io_sqrtOp,
  input  [64:0] io_a,
  input  [64:0] io_b,
  input  [2:0]  io_roundingMode,
  output        io_rawOutValid_div,
  output        io_rawOutValid_sqrt,
  output [2:0]  io_roundingModeOut,
  output        io_invalidExc,
  output        io_infiniteExc,
  output        io_rawOut_isNaN,
  output        io_rawOut_isInf,
  output        io_rawOut_isZero,
  output        io_rawOut_sign,
  output [12:0] io_rawOut_sExp,
  output [55:0] io_rawOut_sig
);
  wire  divSqrtRawFN__clock; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__reset; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_inReady; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_inValid; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_sqrtOp; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_a_isNaN; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_a_isInf; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_a_isZero; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_a_sign; // @[DivSqrtRecFN_small.scala 446:15]
  wire [12:0] divSqrtRawFN__io_a_sExp; // @[DivSqrtRecFN_small.scala 446:15]
  wire [53:0] divSqrtRawFN__io_a_sig; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_b_isNaN; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_b_isInf; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_b_isZero; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_b_sign; // @[DivSqrtRecFN_small.scala 446:15]
  wire [12:0] divSqrtRawFN__io_b_sExp; // @[DivSqrtRecFN_small.scala 446:15]
  wire [53:0] divSqrtRawFN__io_b_sig; // @[DivSqrtRecFN_small.scala 446:15]
  wire [2:0] divSqrtRawFN__io_roundingMode; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_rawOutValid_div; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_rawOutValid_sqrt; // @[DivSqrtRecFN_small.scala 446:15]
  wire [2:0] divSqrtRawFN__io_roundingModeOut; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_invalidExc; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_infiniteExc; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_rawOut_isNaN; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_rawOut_isInf; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_rawOut_isZero; // @[DivSqrtRecFN_small.scala 446:15]
  wire  divSqrtRawFN__io_rawOut_sign; // @[DivSqrtRecFN_small.scala 446:15]
  wire [12:0] divSqrtRawFN__io_rawOut_sExp; // @[DivSqrtRecFN_small.scala 446:15]
  wire [55:0] divSqrtRawFN__io_rawOut_sig; // @[DivSqrtRecFN_small.scala 446:15]
  wire [11:0] divSqrtRawFN_io_a_exp = io_a[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  divSqrtRawFN_io_a_isZero = divSqrtRawFN_io_a_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  divSqrtRawFN_io_a_isSpecial = divSqrtRawFN_io_a_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  _divSqrtRawFN_io_a_out_sig_T = ~divSqrtRawFN_io_a_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [1:0] _divSqrtRawFN_io_a_out_sig_T_1 = {1'h0,_divSqrtRawFN_io_a_out_sig_T}; // @[rawFloatFromRecFN.scala 61:32]
  wire [11:0] divSqrtRawFN_io_b_exp = io_b[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  divSqrtRawFN_io_b_isZero = divSqrtRawFN_io_b_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  divSqrtRawFN_io_b_isSpecial = divSqrtRawFN_io_b_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  _divSqrtRawFN_io_b_out_sig_T = ~divSqrtRawFN_io_b_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [1:0] _divSqrtRawFN_io_b_out_sig_T_1 = {1'h0,_divSqrtRawFN_io_b_out_sig_T}; // @[rawFloatFromRecFN.scala 61:32]
  DivSqrtRawFN_small_e11_s53 divSqrtRawFN_ ( // @[DivSqrtRecFN_small.scala 446:15]
    .clock(divSqrtRawFN__clock),
    .reset(divSqrtRawFN__reset),
    .io_inReady(divSqrtRawFN__io_inReady),
    .io_inValid(divSqrtRawFN__io_inValid),
    .io_sqrtOp(divSqrtRawFN__io_sqrtOp),
    .io_a_isNaN(divSqrtRawFN__io_a_isNaN),
    .io_a_isInf(divSqrtRawFN__io_a_isInf),
    .io_a_isZero(divSqrtRawFN__io_a_isZero),
    .io_a_sign(divSqrtRawFN__io_a_sign),
    .io_a_sExp(divSqrtRawFN__io_a_sExp),
    .io_a_sig(divSqrtRawFN__io_a_sig),
    .io_b_isNaN(divSqrtRawFN__io_b_isNaN),
    .io_b_isInf(divSqrtRawFN__io_b_isInf),
    .io_b_isZero(divSqrtRawFN__io_b_isZero),
    .io_b_sign(divSqrtRawFN__io_b_sign),
    .io_b_sExp(divSqrtRawFN__io_b_sExp),
    .io_b_sig(divSqrtRawFN__io_b_sig),
    .io_roundingMode(divSqrtRawFN__io_roundingMode),
    .io_rawOutValid_div(divSqrtRawFN__io_rawOutValid_div),
    .io_rawOutValid_sqrt(divSqrtRawFN__io_rawOutValid_sqrt),
    .io_roundingModeOut(divSqrtRawFN__io_roundingModeOut),
    .io_invalidExc(divSqrtRawFN__io_invalidExc),
    .io_infiniteExc(divSqrtRawFN__io_infiniteExc),
    .io_rawOut_isNaN(divSqrtRawFN__io_rawOut_isNaN),
    .io_rawOut_isInf(divSqrtRawFN__io_rawOut_isInf),
    .io_rawOut_isZero(divSqrtRawFN__io_rawOut_isZero),
    .io_rawOut_sign(divSqrtRawFN__io_rawOut_sign),
    .io_rawOut_sExp(divSqrtRawFN__io_rawOut_sExp),
    .io_rawOut_sig(divSqrtRawFN__io_rawOut_sig)
  );
  assign io_inReady = divSqrtRawFN__io_inReady; // @[DivSqrtRecFN_small.scala 448:16]
  assign io_rawOutValid_div = divSqrtRawFN__io_rawOutValid_div; // @[DivSqrtRecFN_small.scala 455:25]
  assign io_rawOutValid_sqrt = divSqrtRawFN__io_rawOutValid_sqrt; // @[DivSqrtRecFN_small.scala 456:25]
  assign io_roundingModeOut = divSqrtRawFN__io_roundingModeOut; // @[DivSqrtRecFN_small.scala 457:25]
  assign io_invalidExc = divSqrtRawFN__io_invalidExc; // @[DivSqrtRecFN_small.scala 458:25]
  assign io_infiniteExc = divSqrtRawFN__io_infiniteExc; // @[DivSqrtRecFN_small.scala 459:25]
  assign io_rawOut_isNaN = divSqrtRawFN__io_rawOut_isNaN; // @[DivSqrtRecFN_small.scala 460:25]
  assign io_rawOut_isInf = divSqrtRawFN__io_rawOut_isInf; // @[DivSqrtRecFN_small.scala 460:25]
  assign io_rawOut_isZero = divSqrtRawFN__io_rawOut_isZero; // @[DivSqrtRecFN_small.scala 460:25]
  assign io_rawOut_sign = divSqrtRawFN__io_rawOut_sign; // @[DivSqrtRecFN_small.scala 460:25]
  assign io_rawOut_sExp = divSqrtRawFN__io_rawOut_sExp; // @[DivSqrtRecFN_small.scala 460:25]
  assign io_rawOut_sig = divSqrtRawFN__io_rawOut_sig; // @[DivSqrtRecFN_small.scala 460:25]
  assign divSqrtRawFN__clock = clock;
  assign divSqrtRawFN__reset = reset;
  assign divSqrtRawFN__io_inValid = io_inValid; // @[DivSqrtRecFN_small.scala 449:34]
  assign divSqrtRawFN__io_sqrtOp = io_sqrtOp; // @[DivSqrtRecFN_small.scala 450:34]
  assign divSqrtRawFN__io_a_isNaN = divSqrtRawFN_io_a_isSpecial & divSqrtRawFN_io_a_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  assign divSqrtRawFN__io_a_isInf = divSqrtRawFN_io_a_isSpecial & ~divSqrtRawFN_io_a_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  assign divSqrtRawFN__io_a_isZero = divSqrtRawFN_io_a_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign divSqrtRawFN__io_a_sign = io_a[64]; // @[rawFloatFromRecFN.scala 59:25]
  assign divSqrtRawFN__io_a_sExp = {1'b0,$signed(divSqrtRawFN_io_a_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  assign divSqrtRawFN__io_a_sig = {_divSqrtRawFN_io_a_out_sig_T_1,io_a[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  assign divSqrtRawFN__io_b_isNaN = divSqrtRawFN_io_b_isSpecial & divSqrtRawFN_io_b_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  assign divSqrtRawFN__io_b_isInf = divSqrtRawFN_io_b_isSpecial & ~divSqrtRawFN_io_b_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  assign divSqrtRawFN__io_b_isZero = divSqrtRawFN_io_b_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign divSqrtRawFN__io_b_sign = io_b[64]; // @[rawFloatFromRecFN.scala 59:25]
  assign divSqrtRawFN__io_b_sExp = {1'b0,$signed(divSqrtRawFN_io_b_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  assign divSqrtRawFN__io_b_sig = {_divSqrtRawFN_io_b_out_sig_T_1,io_b[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
  assign divSqrtRawFN__io_roundingMode = io_roundingMode; // @[DivSqrtRecFN_small.scala 453:34]
endmodule
module DivSqrtRecFM_small_e11_s53(
  input         clock,
  input         reset,
  output        io_inReady,
  input         io_inValid,
  input         io_sqrtOp,
  input  [64:0] io_a,
  input  [64:0] io_b,
  input  [2:0]  io_roundingMode,
  output        io_outValid_div,
  output        io_outValid_sqrt,
  output [64:0] io_out,
  output [4:0]  io_exceptionFlags
);
  wire  divSqrtRecFNToRaw_clock; // @[DivSqrtRecFN_small.scala 493:15]
  wire  divSqrtRecFNToRaw_reset; // @[DivSqrtRecFN_small.scala 493:15]
  wire  divSqrtRecFNToRaw_io_inReady; // @[DivSqrtRecFN_small.scala 493:15]
  wire  divSqrtRecFNToRaw_io_inValid; // @[DivSqrtRecFN_small.scala 493:15]
  wire  divSqrtRecFNToRaw_io_sqrtOp; // @[DivSqrtRecFN_small.scala 493:15]
  wire [64:0] divSqrtRecFNToRaw_io_a; // @[DivSqrtRecFN_small.scala 493:15]
  wire [64:0] divSqrtRecFNToRaw_io_b; // @[DivSqrtRecFN_small.scala 493:15]
  wire [2:0] divSqrtRecFNToRaw_io_roundingMode; // @[DivSqrtRecFN_small.scala 493:15]
  wire  divSqrtRecFNToRaw_io_rawOutValid_div; // @[DivSqrtRecFN_small.scala 493:15]
  wire  divSqrtRecFNToRaw_io_rawOutValid_sqrt; // @[DivSqrtRecFN_small.scala 493:15]
  wire [2:0] divSqrtRecFNToRaw_io_roundingModeOut; // @[DivSqrtRecFN_small.scala 493:15]
  wire  divSqrtRecFNToRaw_io_invalidExc; // @[DivSqrtRecFN_small.scala 493:15]
  wire  divSqrtRecFNToRaw_io_infiniteExc; // @[DivSqrtRecFN_small.scala 493:15]
  wire  divSqrtRecFNToRaw_io_rawOut_isNaN; // @[DivSqrtRecFN_small.scala 493:15]
  wire  divSqrtRecFNToRaw_io_rawOut_isInf; // @[DivSqrtRecFN_small.scala 493:15]
  wire  divSqrtRecFNToRaw_io_rawOut_isZero; // @[DivSqrtRecFN_small.scala 493:15]
  wire  divSqrtRecFNToRaw_io_rawOut_sign; // @[DivSqrtRecFN_small.scala 493:15]
  wire [12:0] divSqrtRecFNToRaw_io_rawOut_sExp; // @[DivSqrtRecFN_small.scala 493:15]
  wire [55:0] divSqrtRecFNToRaw_io_rawOut_sig; // @[DivSqrtRecFN_small.scala 493:15]
  wire  roundRawFNToRecFN_io_invalidExc; // @[DivSqrtRecFN_small.scala 508:15]
  wire  roundRawFNToRecFN_io_infiniteExc; // @[DivSqrtRecFN_small.scala 508:15]
  wire  roundRawFNToRecFN_io_in_isNaN; // @[DivSqrtRecFN_small.scala 508:15]
  wire  roundRawFNToRecFN_io_in_isInf; // @[DivSqrtRecFN_small.scala 508:15]
  wire  roundRawFNToRecFN_io_in_isZero; // @[DivSqrtRecFN_small.scala 508:15]
  wire  roundRawFNToRecFN_io_in_sign; // @[DivSqrtRecFN_small.scala 508:15]
  wire [12:0] roundRawFNToRecFN_io_in_sExp; // @[DivSqrtRecFN_small.scala 508:15]
  wire [55:0] roundRawFNToRecFN_io_in_sig; // @[DivSqrtRecFN_small.scala 508:15]
  wire [2:0] roundRawFNToRecFN_io_roundingMode; // @[DivSqrtRecFN_small.scala 508:15]
  wire [64:0] roundRawFNToRecFN_io_out; // @[DivSqrtRecFN_small.scala 508:15]
  wire [4:0] roundRawFNToRecFN_io_exceptionFlags; // @[DivSqrtRecFN_small.scala 508:15]
  DivSqrtRecFMToRaw_small_e11_s53 divSqrtRecFNToRaw ( // @[DivSqrtRecFN_small.scala 493:15]
    .clock(divSqrtRecFNToRaw_clock),
    .reset(divSqrtRecFNToRaw_reset),
    .io_inReady(divSqrtRecFNToRaw_io_inReady),
    .io_inValid(divSqrtRecFNToRaw_io_inValid),
    .io_sqrtOp(divSqrtRecFNToRaw_io_sqrtOp),
    .io_a(divSqrtRecFNToRaw_io_a),
    .io_b(divSqrtRecFNToRaw_io_b),
    .io_roundingMode(divSqrtRecFNToRaw_io_roundingMode),
    .io_rawOutValid_div(divSqrtRecFNToRaw_io_rawOutValid_div),
    .io_rawOutValid_sqrt(divSqrtRecFNToRaw_io_rawOutValid_sqrt),
    .io_roundingModeOut(divSqrtRecFNToRaw_io_roundingModeOut),
    .io_invalidExc(divSqrtRecFNToRaw_io_invalidExc),
    .io_infiniteExc(divSqrtRecFNToRaw_io_infiniteExc),
    .io_rawOut_isNaN(divSqrtRecFNToRaw_io_rawOut_isNaN),
    .io_rawOut_isInf(divSqrtRecFNToRaw_io_rawOut_isInf),
    .io_rawOut_isZero(divSqrtRecFNToRaw_io_rawOut_isZero),
    .io_rawOut_sign(divSqrtRecFNToRaw_io_rawOut_sign),
    .io_rawOut_sExp(divSqrtRecFNToRaw_io_rawOut_sExp),
    .io_rawOut_sig(divSqrtRecFNToRaw_io_rawOut_sig)
  );
  RoundRawFNToRecFN_e11_s53 roundRawFNToRecFN ( // @[DivSqrtRecFN_small.scala 508:15]
    .io_invalidExc(roundRawFNToRecFN_io_invalidExc),
    .io_infiniteExc(roundRawFNToRecFN_io_infiniteExc),
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
  assign io_inReady = divSqrtRecFNToRaw_io_inReady; // @[DivSqrtRecFN_small.scala 495:16]
  assign io_outValid_div = divSqrtRecFNToRaw_io_rawOutValid_div; // @[DivSqrtRecFN_small.scala 504:22]
  assign io_outValid_sqrt = divSqrtRecFNToRaw_io_rawOutValid_sqrt; // @[DivSqrtRecFN_small.scala 505:22]
  assign io_out = roundRawFNToRecFN_io_out; // @[DivSqrtRecFN_small.scala 514:23]
  assign io_exceptionFlags = roundRawFNToRecFN_io_exceptionFlags; // @[DivSqrtRecFN_small.scala 515:23]
  assign divSqrtRecFNToRaw_clock = clock;
  assign divSqrtRecFNToRaw_reset = reset;
  assign divSqrtRecFNToRaw_io_inValid = io_inValid; // @[DivSqrtRecFN_small.scala 496:39]
  assign divSqrtRecFNToRaw_io_sqrtOp = io_sqrtOp; // @[DivSqrtRecFN_small.scala 497:39]
  assign divSqrtRecFNToRaw_io_a = io_a; // @[DivSqrtRecFN_small.scala 498:39]
  assign divSqrtRecFNToRaw_io_b = io_b; // @[DivSqrtRecFN_small.scala 499:39]
  assign divSqrtRecFNToRaw_io_roundingMode = io_roundingMode; // @[DivSqrtRecFN_small.scala 500:39]
  assign roundRawFNToRecFN_io_invalidExc = divSqrtRecFNToRaw_io_invalidExc; // @[DivSqrtRecFN_small.scala 509:39]
  assign roundRawFNToRecFN_io_infiniteExc = divSqrtRecFNToRaw_io_infiniteExc; // @[DivSqrtRecFN_small.scala 510:39]
  assign roundRawFNToRecFN_io_in_isNaN = divSqrtRecFNToRaw_io_rawOut_isNaN; // @[DivSqrtRecFN_small.scala 511:39]
  assign roundRawFNToRecFN_io_in_isInf = divSqrtRecFNToRaw_io_rawOut_isInf; // @[DivSqrtRecFN_small.scala 511:39]
  assign roundRawFNToRecFN_io_in_isZero = divSqrtRecFNToRaw_io_rawOut_isZero; // @[DivSqrtRecFN_small.scala 511:39]
  assign roundRawFNToRecFN_io_in_sign = divSqrtRecFNToRaw_io_rawOut_sign; // @[DivSqrtRecFN_small.scala 511:39]
  assign roundRawFNToRecFN_io_in_sExp = divSqrtRecFNToRaw_io_rawOut_sExp; // @[DivSqrtRecFN_small.scala 511:39]
  assign roundRawFNToRecFN_io_in_sig = divSqrtRecFNToRaw_io_rawOut_sig; // @[DivSqrtRecFN_small.scala 511:39]
  assign roundRawFNToRecFN_io_roundingMode = divSqrtRecFNToRaw_io_roundingModeOut; // @[DivSqrtRecFN_small.scala 512:39]
endmodule
module hardfloat_fp64_addsubdiv(
  input         clock,
  input         reset,
  input         io_opSel,
  input  [63:0] io_a,
  input  [63:0] io_b,
  input  [63:0] io_c,
  input  [2:0]  io_roundingMode,
  input         io_subOp,
  input         io_sqrtOp,
  output        io_outValid,
  output [63:0] io_out,
  output [4:0]  io_exceptionFlags
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  wire  add_f0_io_subOp; // @[Emithardfloat_fp64_addsubdiv.scala 42:22]
  wire [64:0] add_f0_io_a; // @[Emithardfloat_fp64_addsubdiv.scala 42:22]
  wire [64:0] add_f0_io_b; // @[Emithardfloat_fp64_addsubdiv.scala 42:22]
  wire [2:0] add_f0_io_roundingMode; // @[Emithardfloat_fp64_addsubdiv.scala 42:22]
  wire [64:0] add_f0_io_out; // @[Emithardfloat_fp64_addsubdiv.scala 42:22]
  wire [4:0] add_f0_io_exceptionFlags; // @[Emithardfloat_fp64_addsubdiv.scala 42:22]
  wire  divsqrt_f0_clock; // @[Emithardfloat_fp64_addsubdiv.scala 48:26]
  wire  divsqrt_f0_reset; // @[Emithardfloat_fp64_addsubdiv.scala 48:26]
  wire  divsqrt_f0_io_inReady; // @[Emithardfloat_fp64_addsubdiv.scala 48:26]
  wire  divsqrt_f0_io_inValid; // @[Emithardfloat_fp64_addsubdiv.scala 48:26]
  wire  divsqrt_f0_io_sqrtOp; // @[Emithardfloat_fp64_addsubdiv.scala 48:26]
  wire [64:0] divsqrt_f0_io_a; // @[Emithardfloat_fp64_addsubdiv.scala 48:26]
  wire [64:0] divsqrt_f0_io_b; // @[Emithardfloat_fp64_addsubdiv.scala 48:26]
  wire [2:0] divsqrt_f0_io_roundingMode; // @[Emithardfloat_fp64_addsubdiv.scala 48:26]
  wire  divsqrt_f0_io_outValid_div; // @[Emithardfloat_fp64_addsubdiv.scala 48:26]
  wire  divsqrt_f0_io_outValid_sqrt; // @[Emithardfloat_fp64_addsubdiv.scala 48:26]
  wire [64:0] divsqrt_f0_io_out; // @[Emithardfloat_fp64_addsubdiv.scala 48:26]
  wire [4:0] divsqrt_f0_io_exceptionFlags; // @[Emithardfloat_fp64_addsubdiv.scala 48:26]
  wire  roundingMatches_0 = 3'h0 == io_roundingMode; // @[Emithardfloat_fp64_addsubdiv.scala 22:47]
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
  wire [114:0] _GEN_7 = {{63'd0}, fmt0_recA_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [114:0] _fmt0_recA_rawIn_subnormFract_T = _GEN_7 << fmt0_recA_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [51:0] fmt0_recA_rawIn_subnormFract = {_fmt0_recA_rawIn_subnormFract_T[50:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [11:0] _GEN_13 = {{6'd0}, fmt0_recA_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _fmt0_recA_rawIn_adjustedExp_T = _GEN_13 ^ 12'hfff; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _fmt0_recA_rawIn_adjustedExp_T_1 = fmt0_recA_rawIn_isZeroExpIn ? _fmt0_recA_rawIn_adjustedExp_T : {{1
    'd0}, fmt0_recA_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _fmt0_recA_rawIn_adjustedExp_T_2 = fmt0_recA_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [10:0] _GEN_14 = {{9'd0}, _fmt0_recA_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [10:0] _fmt0_recA_rawIn_adjustedExp_T_3 = 11'h400 | _GEN_14; // @[rawFloatFromFN.scala 58:9]
  wire [11:0] _GEN_15 = {{1'd0}, _fmt0_recA_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [11:0] fmt0_recA_rawIn_adjustedExp = _fmt0_recA_rawIn_adjustedExp_T_1 + _GEN_15; // @[rawFloatFromFN.scala 57:9]
  wire  fmt0_recA_rawIn_isZero = fmt0_recA_rawIn_isZeroExpIn & fmt0_recA_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  fmt0_recA_rawIn_isSpecial = fmt0_recA_rawIn_adjustedExp[11:10] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  fmt0_recA_rawIn__isNaN = fmt0_recA_rawIn_isSpecial & ~fmt0_recA_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [12:0] fmt0_recA_rawIn__sExp = {1'b0,$signed(fmt0_recA_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _fmt0_recA_rawIn_out_sig_T = ~fmt0_recA_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [51:0] _fmt0_recA_rawIn_out_sig_T_2 = fmt0_recA_rawIn_isZeroExpIn ? fmt0_recA_rawIn_subnormFract :
    fmt0_recA_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [53:0] fmt0_recA_rawIn__sig = {1'h0,_fmt0_recA_rawIn_out_sig_T,_fmt0_recA_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _fmt0_recA_T_2 = fmt0_recA_rawIn_isZero ? 3'h0 : fmt0_recA_rawIn__sExp[11:9]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_16 = {{2'd0}, fmt0_recA_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _fmt0_recA_T_4 = _fmt0_recA_T_2 | _GEN_16; // @[recFNFromFN.scala 48:76]
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
  wire [114:0] _GEN_8 = {{63'd0}, fmt0_recB_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [114:0] _fmt0_recB_rawIn_subnormFract_T = _GEN_8 << fmt0_recB_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [51:0] fmt0_recB_rawIn_subnormFract = {_fmt0_recB_rawIn_subnormFract_T[50:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [11:0] _GEN_17 = {{6'd0}, fmt0_recB_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _fmt0_recB_rawIn_adjustedExp_T = _GEN_17 ^ 12'hfff; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _fmt0_recB_rawIn_adjustedExp_T_1 = fmt0_recB_rawIn_isZeroExpIn ? _fmt0_recB_rawIn_adjustedExp_T : {{1
    'd0}, fmt0_recB_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _fmt0_recB_rawIn_adjustedExp_T_2 = fmt0_recB_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [10:0] _GEN_18 = {{9'd0}, _fmt0_recB_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [10:0] _fmt0_recB_rawIn_adjustedExp_T_3 = 11'h400 | _GEN_18; // @[rawFloatFromFN.scala 58:9]
  wire [11:0] _GEN_19 = {{1'd0}, _fmt0_recB_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [11:0] fmt0_recB_rawIn_adjustedExp = _fmt0_recB_rawIn_adjustedExp_T_1 + _GEN_19; // @[rawFloatFromFN.scala 57:9]
  wire  fmt0_recB_rawIn_isZero = fmt0_recB_rawIn_isZeroExpIn & fmt0_recB_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  fmt0_recB_rawIn_isSpecial = fmt0_recB_rawIn_adjustedExp[11:10] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  fmt0_recB_rawIn__isNaN = fmt0_recB_rawIn_isSpecial & ~fmt0_recB_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [12:0] fmt0_recB_rawIn__sExp = {1'b0,$signed(fmt0_recB_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _fmt0_recB_rawIn_out_sig_T = ~fmt0_recB_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [51:0] _fmt0_recB_rawIn_out_sig_T_2 = fmt0_recB_rawIn_isZeroExpIn ? fmt0_recB_rawIn_subnormFract :
    fmt0_recB_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [53:0] fmt0_recB_rawIn__sig = {1'h0,_fmt0_recB_rawIn_out_sig_T,_fmt0_recB_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _fmt0_recB_T_2 = fmt0_recB_rawIn_isZero ? 3'h0 : fmt0_recB_rawIn__sExp[11:9]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_20 = {{2'd0}, fmt0_recB_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _fmt0_recB_T_4 = _fmt0_recB_T_2 | _GEN_20; // @[recFNFromFN.scala 48:76]
  wire [12:0] _fmt0_recB_T_7 = {fmt0_recB_rawIn_sign,_fmt0_recB_T_4,fmt0_recB_rawIn__sExp[8:0]}; // @[recFNFromFN.scala 49:45]
  wire  divOutValid = divsqrt_f0_io_outValid_div | divsqrt_f0_io_outValid_sqrt; // @[Emithardfloat_fp64_addsubdiv.scala 56:48]
  reg  busy; // @[Emithardfloat_fp64_addsubdiv.scala 61:21]
  wire  divFire = io_opSel & ~busy & divsqrt_f0_io_inReady; // @[Emithardfloat_fp64_addsubdiv.scala 71:53]
  wire  _GEN_0 = divFire | busy; // @[Emithardfloat_fp64_addsubdiv.scala 61:21 73:{23,30}]
  wire  _GEN_2 = io_opSel & divFire; // @[Emithardfloat_fp64_addsubdiv.scala 63:20 72:19 49:27]
  wire [64:0] _GEN_4 = io_opSel ? divsqrt_f0_io_out : 65'h0; // @[Emithardfloat_fp64_addsubdiv.scala 63:20 74:16 57:27]
  wire [4:0] _GEN_5 = io_opSel ? divsqrt_f0_io_exceptionFlags : 5'h0; // @[Emithardfloat_fp64_addsubdiv.scala 63:20 75:16 59:27]
  wire  _GEN_6 = io_opSel & divOutValid; // @[Emithardfloat_fp64_addsubdiv.scala 63:20 76:18 60:29]
  wire [64:0] outRec = ~io_opSel ? add_f0_io_out : _GEN_4; // @[Emithardfloat_fp64_addsubdiv.scala 63:20 65:16]
  wire  recNonZero = |outRec; // @[Emithardfloat_fp64_addsubdiv.scala 81:27]
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
  AddRecFN add_f0 ( // @[Emithardfloat_fp64_addsubdiv.scala 42:22]
    .io_subOp(add_f0_io_subOp),
    .io_a(add_f0_io_a),
    .io_b(add_f0_io_b),
    .io_roundingMode(add_f0_io_roundingMode),
    .io_out(add_f0_io_out),
    .io_exceptionFlags(add_f0_io_exceptionFlags)
  );
  DivSqrtRecFM_small_e11_s53 divsqrt_f0 ( // @[Emithardfloat_fp64_addsubdiv.scala 48:26]
    .clock(divsqrt_f0_clock),
    .reset(divsqrt_f0_reset),
    .io_inReady(divsqrt_f0_io_inReady),
    .io_inValid(divsqrt_f0_io_inValid),
    .io_sqrtOp(divsqrt_f0_io_sqrtOp),
    .io_a(divsqrt_f0_io_a),
    .io_b(divsqrt_f0_io_b),
    .io_roundingMode(divsqrt_f0_io_roundingMode),
    .io_outValid_div(divsqrt_f0_io_outValid_div),
    .io_outValid_sqrt(divsqrt_f0_io_outValid_sqrt),
    .io_out(divsqrt_f0_io_out),
    .io_exceptionFlags(divsqrt_f0_io_exceptionFlags)
  );
  assign io_outValid = ~io_opSel | _GEN_6; // @[Emithardfloat_fp64_addsubdiv.scala 63:20 68:18]
  assign io_out = recNonZero ? outIeee : 64'h0; // @[Emithardfloat_fp64_addsubdiv.scala 84:16]
  assign io_exceptionFlags = ~io_opSel ? add_f0_io_exceptionFlags : _GEN_5; // @[Emithardfloat_fp64_addsubdiv.scala 63:20 66:16]
  assign add_f0_io_subOp = io_subOp; // @[Emithardfloat_fp64_addsubdiv.scala 45:19 63:20 67:25]
  assign add_f0_io_a = {_fmt0_recA_T_7,fmt0_recA_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign add_f0_io_b = {_fmt0_recB_T_7,fmt0_recB_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign add_f0_io_roundingMode = roundingMatches_0 ? io_roundingMode : 3'h0; // @[Emithardfloat_fp64_addsubdiv.scala 24:25]
  assign divsqrt_f0_clock = clock;
  assign divsqrt_f0_reset = reset;
  assign divsqrt_f0_io_inValid = ~io_opSel ? 1'h0 : _GEN_2; // @[Emithardfloat_fp64_addsubdiv.scala 63:20 49:27]
  assign divsqrt_f0_io_sqrtOp = io_sqrtOp; // @[Emithardfloat_fp64_addsubdiv.scala 55:24]
  assign divsqrt_f0_io_a = {_fmt0_recA_T_7,fmt0_recA_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign divsqrt_f0_io_b = {_fmt0_recB_T_7,fmt0_recB_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign divsqrt_f0_io_roundingMode = roundingMatches_0 ? io_roundingMode : 3'h0; // @[Emithardfloat_fp64_addsubdiv.scala 24:25]
  always @(posedge clock) begin
    if (reset) begin // @[Emithardfloat_fp64_addsubdiv.scala 61:21]
      busy <= 1'h0; // @[Emithardfloat_fp64_addsubdiv.scala 61:21]
    end else if (!(~io_opSel)) begin // @[Emithardfloat_fp64_addsubdiv.scala 63:20]
      if (io_opSel) begin // @[Emithardfloat_fp64_addsubdiv.scala 63:20]
        if (divOutValid) begin // @[Emithardfloat_fp64_addsubdiv.scala 77:27]
          busy <= 1'h0; // @[Emithardfloat_fp64_addsubdiv.scala 77:34]
        end else begin
          busy <= _GEN_0;
        end
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  busy = _RAND_0[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
