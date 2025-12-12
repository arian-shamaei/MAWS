module MulAddRecFNToRaw_preMul_e5_s11(
  input  [16:0] io_a,
  input  [16:0] io_b,
  input  [16:0] io_c,
  output [10:0] io_mulAddA,
  output [10:0] io_mulAddB,
  output [21:0] io_mulAddC,
  output        io_toPostMul_isSigNaNAny,
  output        io_toPostMul_isNaNAOrB,
  output        io_toPostMul_isInfA,
  output        io_toPostMul_isZeroA,
  output        io_toPostMul_isInfB,
  output        io_toPostMul_isZeroB,
  output        io_toPostMul_signProd,
  output        io_toPostMul_isNaNC,
  output        io_toPostMul_isInfC,
  output        io_toPostMul_isZeroC,
  output [6:0]  io_toPostMul_sExpSum,
  output        io_toPostMul_doSubMags,
  output        io_toPostMul_CIsDominant,
  output [3:0]  io_toPostMul_CDom_CAlignDist,
  output [12:0] io_toPostMul_highAlignedSigC,
  output        io_toPostMul_bit0AlignedSigC
);
  wire [5:0] rawA_exp = io_a[15:10]; // @[rawFloatFromRecFN.scala 51:21]
  wire  rawA_isZero = rawA_exp[5:3] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  rawA_isSpecial = rawA_exp[5:4] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  rawA__isNaN = rawA_isSpecial & rawA_exp[3]; // @[rawFloatFromRecFN.scala 56:33]
  wire  rawA__sign = io_a[16]; // @[rawFloatFromRecFN.scala 59:25]
  wire [6:0] rawA__sExp = {1'b0,$signed(rawA_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _rawA_out_sig_T = ~rawA_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [11:0] rawA__sig = {1'h0,_rawA_out_sig_T,io_a[9:0]}; // @[rawFloatFromRecFN.scala 61:44]
  wire [5:0] rawB_exp = io_b[15:10]; // @[rawFloatFromRecFN.scala 51:21]
  wire  rawB_isZero = rawB_exp[5:3] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  rawB_isSpecial = rawB_exp[5:4] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  rawB__isNaN = rawB_isSpecial & rawB_exp[3]; // @[rawFloatFromRecFN.scala 56:33]
  wire  rawB__sign = io_b[16]; // @[rawFloatFromRecFN.scala 59:25]
  wire [6:0] rawB__sExp = {1'b0,$signed(rawB_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _rawB_out_sig_T = ~rawB_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [11:0] rawB__sig = {1'h0,_rawB_out_sig_T,io_b[9:0]}; // @[rawFloatFromRecFN.scala 61:44]
  wire [5:0] rawC_exp = io_c[15:10]; // @[rawFloatFromRecFN.scala 51:21]
  wire  rawC_isZero = rawC_exp[5:3] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  rawC_isSpecial = rawC_exp[5:4] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  rawC__isNaN = rawC_isSpecial & rawC_exp[3]; // @[rawFloatFromRecFN.scala 56:33]
  wire  rawC__sign = io_c[16]; // @[rawFloatFromRecFN.scala 59:25]
  wire [6:0] rawC__sExp = {1'b0,$signed(rawC_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _rawC_out_sig_T = ~rawC_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [11:0] rawC__sig = {1'h0,_rawC_out_sig_T,io_c[9:0]}; // @[rawFloatFromRecFN.scala 61:44]
  wire  signProd = rawA__sign ^ rawB__sign; // @[MulAddRecFN.scala 97:30]
  wire [7:0] _sExpAlignedProd_T = $signed(rawA__sExp) + $signed(rawB__sExp); // @[MulAddRecFN.scala 100:19]
  wire [7:0] sExpAlignedProd = $signed(_sExpAlignedProd_T) - 8'sh12; // @[MulAddRecFN.scala 100:32]
  wire  doSubMags = signProd ^ rawC__sign; // @[MulAddRecFN.scala 102:30]
  wire [7:0] _GEN_0 = {{1{rawC__sExp[6]}},rawC__sExp}; // @[MulAddRecFN.scala 106:42]
  wire [7:0] sNatCAlignDist = $signed(sExpAlignedProd) - $signed(_GEN_0); // @[MulAddRecFN.scala 106:42]
  wire [6:0] posNatCAlignDist = sNatCAlignDist[6:0]; // @[MulAddRecFN.scala 107:42]
  wire  isMinCAlign = rawA_isZero | rawB_isZero | $signed(sNatCAlignDist) < 8'sh0; // @[MulAddRecFN.scala 108:50]
  wire  CIsDominant = _rawC_out_sig_T & (isMinCAlign | posNatCAlignDist <= 7'hb); // @[MulAddRecFN.scala 110:23]
  wire [5:0] _CAlignDist_T_2 = posNatCAlignDist < 7'h23 ? posNatCAlignDist[5:0] : 6'h23; // @[MulAddRecFN.scala 114:16]
  wire [5:0] CAlignDist = isMinCAlign ? 6'h0 : _CAlignDist_T_2; // @[MulAddRecFN.scala 112:12]
  wire [11:0] _mainAlignedSigC_T = ~rawC__sig; // @[MulAddRecFN.scala 120:25]
  wire [11:0] _mainAlignedSigC_T_1 = doSubMags ? _mainAlignedSigC_T : rawC__sig; // @[MulAddRecFN.scala 120:13]
  wire [26:0] _mainAlignedSigC_T_3 = doSubMags ? 27'h7ffffff : 27'h0; // @[Bitwise.scala 77:12]
  wire [38:0] _mainAlignedSigC_T_5 = {_mainAlignedSigC_T_1,_mainAlignedSigC_T_3}; // @[MulAddRecFN.scala 120:94]
  wire [38:0] mainAlignedSigC = $signed(_mainAlignedSigC_T_5) >>> CAlignDist; // @[MulAddRecFN.scala 120:100]
  wire  reduced4CExtra_reducedVec_0 = |rawC__sig[3:0]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_1 = |rawC__sig[7:4]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_2 = |rawC__sig[11:8]; // @[primitives.scala 123:57]
  wire [2:0] _reduced4CExtra_T_1 = {reduced4CExtra_reducedVec_2,reduced4CExtra_reducedVec_1,reduced4CExtra_reducedVec_0}
    ; // @[primitives.scala 124:20]
  wire [16:0] reduced4CExtra_shift = 17'sh10000 >>> CAlignDist[5:2]; // @[primitives.scala 76:56]
  wire [1:0] _reduced4CExtra_T_6 = {reduced4CExtra_shift[8],reduced4CExtra_shift[9]}; // @[Cat.scala 33:92]
  wire [2:0] _GEN_1 = {{1'd0}, _reduced4CExtra_T_6}; // @[MulAddRecFN.scala 122:68]
  wire [2:0] _reduced4CExtra_T_7 = _reduced4CExtra_T_1 & _GEN_1; // @[MulAddRecFN.scala 122:68]
  wire  reduced4CExtra = |_reduced4CExtra_T_7; // @[MulAddRecFN.scala 130:11]
  wire  _alignedSigC_T_4 = &mainAlignedSigC[2:0] & ~reduced4CExtra; // @[MulAddRecFN.scala 134:44]
  wire  _alignedSigC_T_7 = |mainAlignedSigC[2:0] | reduced4CExtra; // @[MulAddRecFN.scala 135:44]
  wire  _alignedSigC_T_8 = doSubMags ? _alignedSigC_T_4 : _alignedSigC_T_7; // @[MulAddRecFN.scala 133:16]
  wire [35:0] alignedSigC_hi = mainAlignedSigC[38:3]; // @[Cat.scala 33:92]
  wire [36:0] alignedSigC = {alignedSigC_hi,_alignedSigC_T_8}; // @[Cat.scala 33:92]
  wire  _io_toPostMul_isSigNaNAny_T_2 = rawA__isNaN & ~rawA__sig[9]; // @[common.scala 82:46]
  wire  _io_toPostMul_isSigNaNAny_T_5 = rawB__isNaN & ~rawB__sig[9]; // @[common.scala 82:46]
  wire  _io_toPostMul_isSigNaNAny_T_9 = rawC__isNaN & ~rawC__sig[9]; // @[common.scala 82:46]
  wire [7:0] _io_toPostMul_sExpSum_T_2 = $signed(sExpAlignedProd) - 8'shb; // @[MulAddRecFN.scala 158:53]
  wire [7:0] _io_toPostMul_sExpSum_T_3 = CIsDominant ? $signed({{1{rawC__sExp[6]}},rawC__sExp}) : $signed(
    _io_toPostMul_sExpSum_T_2); // @[MulAddRecFN.scala 158:12]
  assign io_mulAddA = rawA__sig[10:0]; // @[MulAddRecFN.scala 141:16]
  assign io_mulAddB = rawB__sig[10:0]; // @[MulAddRecFN.scala 142:16]
  assign io_mulAddC = alignedSigC[22:1]; // @[MulAddRecFN.scala 143:30]
  assign io_toPostMul_isSigNaNAny = _io_toPostMul_isSigNaNAny_T_2 | _io_toPostMul_isSigNaNAny_T_5 |
    _io_toPostMul_isSigNaNAny_T_9; // @[MulAddRecFN.scala 146:58]
  assign io_toPostMul_isNaNAOrB = rawA__isNaN | rawB__isNaN; // @[MulAddRecFN.scala 148:42]
  assign io_toPostMul_isInfA = rawA_isSpecial & ~rawA_exp[3]; // @[rawFloatFromRecFN.scala 57:33]
  assign io_toPostMul_isZeroA = rawA_exp[5:3] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign io_toPostMul_isInfB = rawB_isSpecial & ~rawB_exp[3]; // @[rawFloatFromRecFN.scala 57:33]
  assign io_toPostMul_isZeroB = rawB_exp[5:3] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign io_toPostMul_signProd = rawA__sign ^ rawB__sign; // @[MulAddRecFN.scala 97:30]
  assign io_toPostMul_isNaNC = rawC_isSpecial & rawC_exp[3]; // @[rawFloatFromRecFN.scala 56:33]
  assign io_toPostMul_isInfC = rawC_isSpecial & ~rawC_exp[3]; // @[rawFloatFromRecFN.scala 57:33]
  assign io_toPostMul_isZeroC = rawC_exp[5:3] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign io_toPostMul_sExpSum = _io_toPostMul_sExpSum_T_3[6:0]; // @[MulAddRecFN.scala 157:28]
  assign io_toPostMul_doSubMags = signProd ^ rawC__sign; // @[MulAddRecFN.scala 102:30]
  assign io_toPostMul_CIsDominant = _rawC_out_sig_T & (isMinCAlign | posNatCAlignDist <= 7'hb); // @[MulAddRecFN.scala 110:23]
  assign io_toPostMul_CDom_CAlignDist = CAlignDist[3:0]; // @[MulAddRecFN.scala 161:47]
  assign io_toPostMul_highAlignedSigC = alignedSigC[35:23]; // @[MulAddRecFN.scala 163:20]
  assign io_toPostMul_bit0AlignedSigC = alignedSigC[0]; // @[MulAddRecFN.scala 164:48]
endmodule
module MulAddRecFNToRaw_postMul_e5_s11(
  input         io_fromPreMul_isSigNaNAny,
  input         io_fromPreMul_isNaNAOrB,
  input         io_fromPreMul_isInfA,
  input         io_fromPreMul_isZeroA,
  input         io_fromPreMul_isInfB,
  input         io_fromPreMul_isZeroB,
  input         io_fromPreMul_signProd,
  input         io_fromPreMul_isNaNC,
  input         io_fromPreMul_isInfC,
  input         io_fromPreMul_isZeroC,
  input  [6:0]  io_fromPreMul_sExpSum,
  input         io_fromPreMul_doSubMags,
  input         io_fromPreMul_CIsDominant,
  input  [3:0]  io_fromPreMul_CDom_CAlignDist,
  input  [12:0] io_fromPreMul_highAlignedSigC,
  input         io_fromPreMul_bit0AlignedSigC,
  input  [22:0] io_mulAddResult,
  input  [2:0]  io_roundingMode,
  output        io_invalidExc,
  output        io_rawOut_isNaN,
  output        io_rawOut_isInf,
  output        io_rawOut_isZero,
  output        io_rawOut_sign,
  output [6:0]  io_rawOut_sExp,
  output [13:0] io_rawOut_sig
);
  wire  roundingMode_min = io_roundingMode == 3'h2; // @[MulAddRecFN.scala 186:45]
  wire  CDom_sign = io_fromPreMul_signProd ^ io_fromPreMul_doSubMags; // @[MulAddRecFN.scala 190:42]
  wire [12:0] _sigSum_T_2 = io_fromPreMul_highAlignedSigC + 13'h1; // @[MulAddRecFN.scala 193:47]
  wire [12:0] _sigSum_T_3 = io_mulAddResult[22] ? _sigSum_T_2 : io_fromPreMul_highAlignedSigC; // @[MulAddRecFN.scala 192:16]
  wire [35:0] sigSum = {_sigSum_T_3,io_mulAddResult[21:0],io_fromPreMul_bit0AlignedSigC}; // @[Cat.scala 33:92]
  wire [1:0] _CDom_sExp_T = {1'b0,$signed(io_fromPreMul_doSubMags)}; // @[MulAddRecFN.scala 203:69]
  wire [6:0] _GEN_0 = {{5{_CDom_sExp_T[1]}},_CDom_sExp_T}; // @[MulAddRecFN.scala 203:43]
  wire [6:0] CDom_sExp = $signed(io_fromPreMul_sExpSum) - $signed(_GEN_0); // @[MulAddRecFN.scala 203:43]
  wire [23:0] _CDom_absSigSum_T_1 = ~sigSum[35:12]; // @[MulAddRecFN.scala 206:13]
  wire [23:0] _CDom_absSigSum_T_5 = {1'h0,io_fromPreMul_highAlignedSigC[12:11],sigSum[33:13]}; // @[MulAddRecFN.scala 209:71]
  wire [23:0] CDom_absSigSum = io_fromPreMul_doSubMags ? _CDom_absSigSum_T_1 : _CDom_absSigSum_T_5; // @[MulAddRecFN.scala 205:12]
  wire [10:0] _CDom_absSigSumExtra_T_1 = ~sigSum[11:1]; // @[MulAddRecFN.scala 215:14]
  wire  _CDom_absSigSumExtra_T_2 = |_CDom_absSigSumExtra_T_1; // @[MulAddRecFN.scala 215:36]
  wire  _CDom_absSigSumExtra_T_4 = |sigSum[12:1]; // @[MulAddRecFN.scala 216:37]
  wire  CDom_absSigSumExtra = io_fromPreMul_doSubMags ? _CDom_absSigSumExtra_T_2 : _CDom_absSigSumExtra_T_4; // @[MulAddRecFN.scala 214:12]
  wire [38:0] _GEN_5 = {{15'd0}, CDom_absSigSum}; // @[MulAddRecFN.scala 219:24]
  wire [38:0] _CDom_mainSig_T = _GEN_5 << io_fromPreMul_CDom_CAlignDist; // @[MulAddRecFN.scala 219:24]
  wire [15:0] CDom_mainSig = _CDom_mainSig_T[23:8]; // @[MulAddRecFN.scala 219:56]
  wire  CDom_reduced4SigExtra_reducedVec_0 = |CDom_absSigSum[3:0]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_1 = |CDom_absSigSum[7:4]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_2 = |CDom_absSigSum[10:8]; // @[primitives.scala 123:57]
  wire [2:0] _CDom_reduced4SigExtra_T_2 = {CDom_reduced4SigExtra_reducedVec_2,CDom_reduced4SigExtra_reducedVec_1,
    CDom_reduced4SigExtra_reducedVec_0}; // @[primitives.scala 124:20]
  wire [1:0] _CDom_reduced4SigExtra_T_4 = ~io_fromPreMul_CDom_CAlignDist[3:2]; // @[primitives.scala 52:21]
  wire [4:0] CDom_reduced4SigExtra_shift = 5'sh10 >>> _CDom_reduced4SigExtra_T_4; // @[primitives.scala 76:56]
  wire [1:0] _CDom_reduced4SigExtra_T_8 = {CDom_reduced4SigExtra_shift[1],CDom_reduced4SigExtra_shift[2]}; // @[Cat.scala 33:92]
  wire [2:0] _GEN_1 = {{1'd0}, _CDom_reduced4SigExtra_T_8}; // @[MulAddRecFN.scala 222:72]
  wire [2:0] _CDom_reduced4SigExtra_T_9 = _CDom_reduced4SigExtra_T_2 & _GEN_1; // @[MulAddRecFN.scala 222:72]
  wire  CDom_reduced4SigExtra = |_CDom_reduced4SigExtra_T_9; // @[MulAddRecFN.scala 223:73]
  wire  _CDom_sig_T_4 = |CDom_mainSig[2:0] | CDom_reduced4SigExtra | CDom_absSigSumExtra; // @[MulAddRecFN.scala 226:61]
  wire [13:0] CDom_sig = {CDom_mainSig[15:3],_CDom_sig_T_4}; // @[Cat.scala 33:92]
  wire  notCDom_signSigSum = sigSum[25]; // @[MulAddRecFN.scala 232:36]
  wire [24:0] _notCDom_absSigSum_T_1 = ~sigSum[24:0]; // @[MulAddRecFN.scala 235:13]
  wire [24:0] _GEN_2 = {{24'd0}, io_fromPreMul_doSubMags}; // @[MulAddRecFN.scala 236:41]
  wire [24:0] _notCDom_absSigSum_T_4 = sigSum[24:0] + _GEN_2; // @[MulAddRecFN.scala 236:41]
  wire [24:0] notCDom_absSigSum = notCDom_signSigSum ? _notCDom_absSigSum_T_1 : _notCDom_absSigSum_T_4; // @[MulAddRecFN.scala 234:12]
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
  wire  notCDom_reduced2AbsSigSum_reducedVec_12 = |notCDom_absSigSum[24]; // @[primitives.scala 106:57]
  wire [5:0] notCDom_reduced2AbsSigSum_lo = {notCDom_reduced2AbsSigSum_reducedVec_5,
    notCDom_reduced2AbsSigSum_reducedVec_4,notCDom_reduced2AbsSigSum_reducedVec_3,notCDom_reduced2AbsSigSum_reducedVec_2
    ,notCDom_reduced2AbsSigSum_reducedVec_1,notCDom_reduced2AbsSigSum_reducedVec_0}; // @[primitives.scala 107:20]
  wire [12:0] notCDom_reduced2AbsSigSum = {notCDom_reduced2AbsSigSum_reducedVec_12,
    notCDom_reduced2AbsSigSum_reducedVec_11,notCDom_reduced2AbsSigSum_reducedVec_10,
    notCDom_reduced2AbsSigSum_reducedVec_9,notCDom_reduced2AbsSigSum_reducedVec_8,notCDom_reduced2AbsSigSum_reducedVec_7
    ,notCDom_reduced2AbsSigSum_reducedVec_6,notCDom_reduced2AbsSigSum_lo}; // @[primitives.scala 107:20]
  wire [3:0] _notCDom_normDistReduced2_T_13 = notCDom_reduced2AbsSigSum[1] ? 4'hb : 4'hc; // @[Mux.scala 47:70]
  wire [3:0] _notCDom_normDistReduced2_T_14 = notCDom_reduced2AbsSigSum[2] ? 4'ha : _notCDom_normDistReduced2_T_13; // @[Mux.scala 47:70]
  wire [3:0] _notCDom_normDistReduced2_T_15 = notCDom_reduced2AbsSigSum[3] ? 4'h9 : _notCDom_normDistReduced2_T_14; // @[Mux.scala 47:70]
  wire [3:0] _notCDom_normDistReduced2_T_16 = notCDom_reduced2AbsSigSum[4] ? 4'h8 : _notCDom_normDistReduced2_T_15; // @[Mux.scala 47:70]
  wire [3:0] _notCDom_normDistReduced2_T_17 = notCDom_reduced2AbsSigSum[5] ? 4'h7 : _notCDom_normDistReduced2_T_16; // @[Mux.scala 47:70]
  wire [3:0] _notCDom_normDistReduced2_T_18 = notCDom_reduced2AbsSigSum[6] ? 4'h6 : _notCDom_normDistReduced2_T_17; // @[Mux.scala 47:70]
  wire [3:0] _notCDom_normDistReduced2_T_19 = notCDom_reduced2AbsSigSum[7] ? 4'h5 : _notCDom_normDistReduced2_T_18; // @[Mux.scala 47:70]
  wire [3:0] _notCDom_normDistReduced2_T_20 = notCDom_reduced2AbsSigSum[8] ? 4'h4 : _notCDom_normDistReduced2_T_19; // @[Mux.scala 47:70]
  wire [3:0] _notCDom_normDistReduced2_T_21 = notCDom_reduced2AbsSigSum[9] ? 4'h3 : _notCDom_normDistReduced2_T_20; // @[Mux.scala 47:70]
  wire [3:0] _notCDom_normDistReduced2_T_22 = notCDom_reduced2AbsSigSum[10] ? 4'h2 : _notCDom_normDistReduced2_T_21; // @[Mux.scala 47:70]
  wire [3:0] _notCDom_normDistReduced2_T_23 = notCDom_reduced2AbsSigSum[11] ? 4'h1 : _notCDom_normDistReduced2_T_22; // @[Mux.scala 47:70]
  wire [3:0] notCDom_normDistReduced2 = notCDom_reduced2AbsSigSum[12] ? 4'h0 : _notCDom_normDistReduced2_T_23; // @[Mux.scala 47:70]
  wire [4:0] notCDom_nearNormDist = {notCDom_normDistReduced2, 1'h0}; // @[MulAddRecFN.scala 240:56]
  wire [5:0] _notCDom_sExp_T = {1'b0,$signed(notCDom_nearNormDist)}; // @[MulAddRecFN.scala 241:76]
  wire [6:0] _GEN_3 = {{1{_notCDom_sExp_T[5]}},_notCDom_sExp_T}; // @[MulAddRecFN.scala 241:46]
  wire [6:0] notCDom_sExp = $signed(io_fromPreMul_sExpSum) - $signed(_GEN_3); // @[MulAddRecFN.scala 241:46]
  wire [55:0] _GEN_6 = {{31'd0}, notCDom_absSigSum}; // @[MulAddRecFN.scala 243:27]
  wire [55:0] _notCDom_mainSig_T = _GEN_6 << notCDom_nearNormDist; // @[MulAddRecFN.scala 243:27]
  wire [15:0] notCDom_mainSig = _notCDom_mainSig_T[25:10]; // @[MulAddRecFN.scala 243:50]
  wire [6:0] _notCDom_reduced4SigExtra_T_1 = {notCDom_reduced2AbsSigSum[5:0], 1'h0}; // @[MulAddRecFN.scala 247:55]
  wire  notCDom_reduced4SigExtra_reducedVec_0 = |_notCDom_reduced4SigExtra_T_1[1:0]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_1 = |_notCDom_reduced4SigExtra_T_1[3:2]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_2 = |_notCDom_reduced4SigExtra_T_1[5:4]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_3 = |_notCDom_reduced4SigExtra_T_1[6]; // @[primitives.scala 106:57]
  wire [3:0] _notCDom_reduced4SigExtra_T_2 = {notCDom_reduced4SigExtra_reducedVec_3,
    notCDom_reduced4SigExtra_reducedVec_2,notCDom_reduced4SigExtra_reducedVec_1,notCDom_reduced4SigExtra_reducedVec_0}; // @[primitives.scala 107:20]
  wire [2:0] _notCDom_reduced4SigExtra_T_4 = ~notCDom_normDistReduced2[3:1]; // @[primitives.scala 52:21]
  wire [8:0] notCDom_reduced4SigExtra_shift = 9'sh100 >>> _notCDom_reduced4SigExtra_T_4; // @[primitives.scala 76:56]
  wire [2:0] _notCDom_reduced4SigExtra_T_11 = {notCDom_reduced4SigExtra_shift[1],notCDom_reduced4SigExtra_shift[2],
    notCDom_reduced4SigExtra_shift[3]}; // @[Cat.scala 33:92]
  wire [3:0] _GEN_4 = {{1'd0}, _notCDom_reduced4SigExtra_T_11}; // @[MulAddRecFN.scala 247:78]
  wire [3:0] _notCDom_reduced4SigExtra_T_12 = _notCDom_reduced4SigExtra_T_2 & _GEN_4; // @[MulAddRecFN.scala 247:78]
  wire  notCDom_reduced4SigExtra = |_notCDom_reduced4SigExtra_T_12; // @[MulAddRecFN.scala 249:11]
  wire  _notCDom_sig_T_3 = |notCDom_mainSig[2:0] | notCDom_reduced4SigExtra; // @[MulAddRecFN.scala 252:39]
  wire [13:0] notCDom_sig = {notCDom_mainSig[15:3],_notCDom_sig_T_3}; // @[Cat.scala 33:92]
  wire  notCDom_completeCancellation = notCDom_sig[13:12] == 2'h0; // @[MulAddRecFN.scala 255:50]
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
module MulAddRecFN_e5_s11(
  input  [16:0] io_a,
  input  [16:0] io_b,
  input  [16:0] io_c,
  input  [2:0]  io_roundingMode,
  output [16:0] io_out,
  output [4:0]  io_exceptionFlags
);
  wire [16:0] mulAddRecFNToRaw_preMul_io_a; // @[MulAddRecFN.scala 317:15]
  wire [16:0] mulAddRecFNToRaw_preMul_io_b; // @[MulAddRecFN.scala 317:15]
  wire [16:0] mulAddRecFNToRaw_preMul_io_c; // @[MulAddRecFN.scala 317:15]
  wire [10:0] mulAddRecFNToRaw_preMul_io_mulAddA; // @[MulAddRecFN.scala 317:15]
  wire [10:0] mulAddRecFNToRaw_preMul_io_mulAddB; // @[MulAddRecFN.scala 317:15]
  wire [21:0] mulAddRecFNToRaw_preMul_io_mulAddC; // @[MulAddRecFN.scala 317:15]
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
  wire [6:0] mulAddRecFNToRaw_preMul_io_toPostMul_sExpSum; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_doSubMags; // @[MulAddRecFN.scala 317:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_CIsDominant; // @[MulAddRecFN.scala 317:15]
  wire [3:0] mulAddRecFNToRaw_preMul_io_toPostMul_CDom_CAlignDist; // @[MulAddRecFN.scala 317:15]
  wire [12:0] mulAddRecFNToRaw_preMul_io_toPostMul_highAlignedSigC; // @[MulAddRecFN.scala 317:15]
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
  wire [6:0] mulAddRecFNToRaw_postMul_io_fromPreMul_sExpSum; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_doSubMags; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_CIsDominant; // @[MulAddRecFN.scala 319:15]
  wire [3:0] mulAddRecFNToRaw_postMul_io_fromPreMul_CDom_CAlignDist; // @[MulAddRecFN.scala 319:15]
  wire [12:0] mulAddRecFNToRaw_postMul_io_fromPreMul_highAlignedSigC; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_bit0AlignedSigC; // @[MulAddRecFN.scala 319:15]
  wire [22:0] mulAddRecFNToRaw_postMul_io_mulAddResult; // @[MulAddRecFN.scala 319:15]
  wire [2:0] mulAddRecFNToRaw_postMul_io_roundingMode; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_invalidExc; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_rawOut_isNaN; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_rawOut_isInf; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_rawOut_isZero; // @[MulAddRecFN.scala 319:15]
  wire  mulAddRecFNToRaw_postMul_io_rawOut_sign; // @[MulAddRecFN.scala 319:15]
  wire [6:0] mulAddRecFNToRaw_postMul_io_rawOut_sExp; // @[MulAddRecFN.scala 319:15]
  wire [13:0] mulAddRecFNToRaw_postMul_io_rawOut_sig; // @[MulAddRecFN.scala 319:15]
  wire  roundRawFNToRecFN_io_invalidExc; // @[MulAddRecFN.scala 339:15]
  wire  roundRawFNToRecFN_io_in_isNaN; // @[MulAddRecFN.scala 339:15]
  wire  roundRawFNToRecFN_io_in_isInf; // @[MulAddRecFN.scala 339:15]
  wire  roundRawFNToRecFN_io_in_isZero; // @[MulAddRecFN.scala 339:15]
  wire  roundRawFNToRecFN_io_in_sign; // @[MulAddRecFN.scala 339:15]
  wire [6:0] roundRawFNToRecFN_io_in_sExp; // @[MulAddRecFN.scala 339:15]
  wire [13:0] roundRawFNToRecFN_io_in_sig; // @[MulAddRecFN.scala 339:15]
  wire [2:0] roundRawFNToRecFN_io_roundingMode; // @[MulAddRecFN.scala 339:15]
  wire [16:0] roundRawFNToRecFN_io_out; // @[MulAddRecFN.scala 339:15]
  wire [4:0] roundRawFNToRecFN_io_exceptionFlags; // @[MulAddRecFN.scala 339:15]
  wire [21:0] _mulAddResult_T = mulAddRecFNToRaw_preMul_io_mulAddA * mulAddRecFNToRaw_preMul_io_mulAddB; // @[MulAddRecFN.scala 327:45]
  MulAddRecFNToRaw_preMul_e5_s11 mulAddRecFNToRaw_preMul ( // @[MulAddRecFN.scala 317:15]
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
  MulAddRecFNToRaw_postMul_e5_s11 mulAddRecFNToRaw_postMul ( // @[MulAddRecFN.scala 319:15]
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
  RoundRawFNToRecFN_e5_s11 roundRawFNToRecFN ( // @[MulAddRecFN.scala 339:15]
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
endmodule
module MulFullRawFN(
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
  output        io_invalidExc,
  output        io_rawOut_isNaN,
  output        io_rawOut_isInf,
  output        io_rawOut_isZero,
  output        io_rawOut_sign,
  output [6:0]  io_rawOut_sExp,
  output [21:0] io_rawOut_sig
);
  wire  notSigNaN_invalidExc = io_a_isInf & io_b_isZero | io_a_isZero & io_b_isInf; // @[MulRecFN.scala 58:60]
  wire [6:0] _common_sExpOut_T_2 = $signed(io_a_sExp) + $signed(io_b_sExp); // @[MulRecFN.scala 62:36]
  wire [23:0] _common_sigOut_T = io_a_sig * io_b_sig; // @[MulRecFN.scala 63:35]
  wire  _io_invalidExc_T_2 = io_a_isNaN & ~io_a_sig[9]; // @[common.scala 82:46]
  wire  _io_invalidExc_T_5 = io_b_isNaN & ~io_b_sig[9]; // @[common.scala 82:46]
  assign io_invalidExc = _io_invalidExc_T_2 | _io_invalidExc_T_5 | notSigNaN_invalidExc; // @[MulRecFN.scala 66:71]
  assign io_rawOut_isNaN = io_a_isNaN | io_b_isNaN; // @[MulRecFN.scala 70:35]
  assign io_rawOut_isInf = io_a_isInf | io_b_isInf; // @[MulRecFN.scala 59:38]
  assign io_rawOut_isZero = io_a_isZero | io_b_isZero; // @[MulRecFN.scala 60:40]
  assign io_rawOut_sign = io_a_sign ^ io_b_sign; // @[MulRecFN.scala 61:36]
  assign io_rawOut_sExp = $signed(_common_sExpOut_T_2) - 7'sh20; // @[MulRecFN.scala 62:48]
  assign io_rawOut_sig = _common_sigOut_T[21:0]; // @[MulRecFN.scala 63:46]
endmodule
module MulRawFN(
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
  output        io_invalidExc,
  output        io_rawOut_isNaN,
  output        io_rawOut_isInf,
  output        io_rawOut_isZero,
  output        io_rawOut_sign,
  output [6:0]  io_rawOut_sExp,
  output [13:0] io_rawOut_sig
);
  wire  mulFullRaw_io_a_isNaN; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_a_isInf; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_a_isZero; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_a_sign; // @[MulRecFN.scala 84:28]
  wire [6:0] mulFullRaw_io_a_sExp; // @[MulRecFN.scala 84:28]
  wire [11:0] mulFullRaw_io_a_sig; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_isNaN; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_isInf; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_isZero; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_b_sign; // @[MulRecFN.scala 84:28]
  wire [6:0] mulFullRaw_io_b_sExp; // @[MulRecFN.scala 84:28]
  wire [11:0] mulFullRaw_io_b_sig; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_invalidExc; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_isNaN; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_isInf; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_isZero; // @[MulRecFN.scala 84:28]
  wire  mulFullRaw_io_rawOut_sign; // @[MulRecFN.scala 84:28]
  wire [6:0] mulFullRaw_io_rawOut_sExp; // @[MulRecFN.scala 84:28]
  wire [21:0] mulFullRaw_io_rawOut_sig; // @[MulRecFN.scala 84:28]
  wire  _io_rawOut_sig_T_2 = |mulFullRaw_io_rawOut_sig[8:0]; // @[MulRecFN.scala 93:55]
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
  assign io_rawOut_sig = {mulFullRaw_io_rawOut_sig[21:9],_io_rawOut_sig_T_2}; // @[Cat.scala 33:92]
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
module MulRecFN(
  input  [16:0] io_a,
  input  [16:0] io_b,
  input  [2:0]  io_roundingMode,
  output [16:0] io_out,
  output [4:0]  io_exceptionFlags
);
  wire  mulRawFN__io_a_isNaN; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_a_isInf; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_a_isZero; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_a_sign; // @[MulRecFN.scala 113:26]
  wire [6:0] mulRawFN__io_a_sExp; // @[MulRecFN.scala 113:26]
  wire [11:0] mulRawFN__io_a_sig; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_b_isNaN; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_b_isInf; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_b_isZero; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_b_sign; // @[MulRecFN.scala 113:26]
  wire [6:0] mulRawFN__io_b_sExp; // @[MulRecFN.scala 113:26]
  wire [11:0] mulRawFN__io_b_sig; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_invalidExc; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_rawOut_isNaN; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_rawOut_isInf; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_rawOut_isZero; // @[MulRecFN.scala 113:26]
  wire  mulRawFN__io_rawOut_sign; // @[MulRecFN.scala 113:26]
  wire [6:0] mulRawFN__io_rawOut_sExp; // @[MulRecFN.scala 113:26]
  wire [13:0] mulRawFN__io_rawOut_sig; // @[MulRecFN.scala 113:26]
  wire  roundRawFNToRecFN_io_invalidExc; // @[MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_isNaN; // @[MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_isInf; // @[MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_isZero; // @[MulRecFN.scala 121:15]
  wire  roundRawFNToRecFN_io_in_sign; // @[MulRecFN.scala 121:15]
  wire [6:0] roundRawFNToRecFN_io_in_sExp; // @[MulRecFN.scala 121:15]
  wire [13:0] roundRawFNToRecFN_io_in_sig; // @[MulRecFN.scala 121:15]
  wire [2:0] roundRawFNToRecFN_io_roundingMode; // @[MulRecFN.scala 121:15]
  wire [16:0] roundRawFNToRecFN_io_out; // @[MulRecFN.scala 121:15]
  wire [4:0] roundRawFNToRecFN_io_exceptionFlags; // @[MulRecFN.scala 121:15]
  wire [5:0] mulRawFN_io_a_exp = io_a[15:10]; // @[rawFloatFromRecFN.scala 51:21]
  wire  mulRawFN_io_a_isZero = mulRawFN_io_a_exp[5:3] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  mulRawFN_io_a_isSpecial = mulRawFN_io_a_exp[5:4] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  _mulRawFN_io_a_out_sig_T = ~mulRawFN_io_a_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [1:0] _mulRawFN_io_a_out_sig_T_1 = {1'h0,_mulRawFN_io_a_out_sig_T}; // @[rawFloatFromRecFN.scala 61:32]
  wire [5:0] mulRawFN_io_b_exp = io_b[15:10]; // @[rawFloatFromRecFN.scala 51:21]
  wire  mulRawFN_io_b_isZero = mulRawFN_io_b_exp[5:3] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  mulRawFN_io_b_isSpecial = mulRawFN_io_b_exp[5:4] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
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
  RoundRawFNToRecFN_e5_s11 roundRawFNToRecFN ( // @[MulRecFN.scala 121:15]
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
  assign mulRawFN__io_a_isNaN = mulRawFN_io_a_isSpecial & mulRawFN_io_a_exp[3]; // @[rawFloatFromRecFN.scala 56:33]
  assign mulRawFN__io_a_isInf = mulRawFN_io_a_isSpecial & ~mulRawFN_io_a_exp[3]; // @[rawFloatFromRecFN.scala 57:33]
  assign mulRawFN__io_a_isZero = mulRawFN_io_a_exp[5:3] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign mulRawFN__io_a_sign = io_a[16]; // @[rawFloatFromRecFN.scala 59:25]
  assign mulRawFN__io_a_sExp = {1'b0,$signed(mulRawFN_io_a_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  assign mulRawFN__io_a_sig = {_mulRawFN_io_a_out_sig_T_1,io_a[9:0]}; // @[rawFloatFromRecFN.scala 61:44]
  assign mulRawFN__io_b_isNaN = mulRawFN_io_b_isSpecial & mulRawFN_io_b_exp[3]; // @[rawFloatFromRecFN.scala 56:33]
  assign mulRawFN__io_b_isInf = mulRawFN_io_b_isSpecial & ~mulRawFN_io_b_exp[3]; // @[rawFloatFromRecFN.scala 57:33]
  assign mulRawFN__io_b_isZero = mulRawFN_io_b_exp[5:3] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign mulRawFN__io_b_sign = io_b[16]; // @[rawFloatFromRecFN.scala 59:25]
  assign mulRawFN__io_b_sExp = {1'b0,$signed(mulRawFN_io_b_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  assign mulRawFN__io_b_sig = {_mulRawFN_io_b_out_sig_T_1,io_b[9:0]}; // @[rawFloatFromRecFN.scala 61:44]
  assign roundRawFNToRecFN_io_invalidExc = mulRawFN__io_invalidExc; // @[MulRecFN.scala 122:39]
  assign roundRawFNToRecFN_io_in_isNaN = mulRawFN__io_rawOut_isNaN; // @[MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_isInf = mulRawFN__io_rawOut_isInf; // @[MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_isZero = mulRawFN__io_rawOut_isZero; // @[MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_sign = mulRawFN__io_rawOut_sign; // @[MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_sExp = mulRawFN__io_rawOut_sExp; // @[MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_in_sig = mulRawFN__io_rawOut_sig; // @[MulRecFN.scala 124:39]
  assign roundRawFNToRecFN_io_roundingMode = io_roundingMode; // @[MulRecFN.scala 125:39]
endmodule
module ieee_fp16_mul(
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
  wire [16:0] fma_f0_io_a; // @[Emitieee_fp16_mul.scala 39:22]
  wire [16:0] fma_f0_io_b; // @[Emitieee_fp16_mul.scala 39:22]
  wire [16:0] fma_f0_io_c; // @[Emitieee_fp16_mul.scala 39:22]
  wire [2:0] fma_f0_io_roundingMode; // @[Emitieee_fp16_mul.scala 39:22]
  wire [16:0] fma_f0_io_out; // @[Emitieee_fp16_mul.scala 39:22]
  wire [4:0] fma_f0_io_exceptionFlags; // @[Emitieee_fp16_mul.scala 39:22]
  wire [16:0] mul_f0_io_a; // @[Emitieee_fp16_mul.scala 46:22]
  wire [16:0] mul_f0_io_b; // @[Emitieee_fp16_mul.scala 46:22]
  wire [2:0] mul_f0_io_roundingMode; // @[Emitieee_fp16_mul.scala 46:22]
  wire [16:0] mul_f0_io_out; // @[Emitieee_fp16_mul.scala 46:22]
  wire [4:0] mul_f0_io_exceptionFlags; // @[Emitieee_fp16_mul.scala 46:22]
  wire  roundingMatches_0 = 3'h0 == io_roundingMode; // @[Emitieee_fp16_mul.scala 19:47]
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
  wire [24:0] _GEN_2 = {{15'd0}, fmt0_recA_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [24:0] _fmt0_recA_rawIn_subnormFract_T = _GEN_2 << fmt0_recA_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [9:0] fmt0_recA_rawIn_subnormFract = {_fmt0_recA_rawIn_subnormFract_T[8:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [5:0] _GEN_4 = {{2'd0}, fmt0_recA_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [5:0] _fmt0_recA_rawIn_adjustedExp_T = _GEN_4 ^ 6'h3f; // @[rawFloatFromFN.scala 55:18]
  wire [5:0] _fmt0_recA_rawIn_adjustedExp_T_1 = fmt0_recA_rawIn_isZeroExpIn ? _fmt0_recA_rawIn_adjustedExp_T : {{1'd0},
    fmt0_recA_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _fmt0_recA_rawIn_adjustedExp_T_2 = fmt0_recA_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [4:0] _GEN_5 = {{3'd0}, _fmt0_recA_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [4:0] _fmt0_recA_rawIn_adjustedExp_T_3 = 5'h10 | _GEN_5; // @[rawFloatFromFN.scala 58:9]
  wire [5:0] _GEN_6 = {{1'd0}, _fmt0_recA_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [5:0] fmt0_recA_rawIn_adjustedExp = _fmt0_recA_rawIn_adjustedExp_T_1 + _GEN_6; // @[rawFloatFromFN.scala 57:9]
  wire  fmt0_recA_rawIn_isZero = fmt0_recA_rawIn_isZeroExpIn & fmt0_recA_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  fmt0_recA_rawIn_isSpecial = fmt0_recA_rawIn_adjustedExp[5:4] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  fmt0_recA_rawIn__isNaN = fmt0_recA_rawIn_isSpecial & ~fmt0_recA_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [6:0] fmt0_recA_rawIn__sExp = {1'b0,$signed(fmt0_recA_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _fmt0_recA_rawIn_out_sig_T = ~fmt0_recA_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [9:0] _fmt0_recA_rawIn_out_sig_T_2 = fmt0_recA_rawIn_isZeroExpIn ? fmt0_recA_rawIn_subnormFract :
    fmt0_recA_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [11:0] fmt0_recA_rawIn__sig = {1'h0,_fmt0_recA_rawIn_out_sig_T,_fmt0_recA_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _fmt0_recA_T_2 = fmt0_recA_rawIn_isZero ? 3'h0 : fmt0_recA_rawIn__sExp[5:3]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_7 = {{2'd0}, fmt0_recA_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _fmt0_recA_T_4 = _fmt0_recA_T_2 | _GEN_7; // @[recFNFromFN.scala 48:76]
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
  wire [24:0] _GEN_3 = {{15'd0}, fmt0_recB_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [24:0] _fmt0_recB_rawIn_subnormFract_T = _GEN_3 << fmt0_recB_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [9:0] fmt0_recB_rawIn_subnormFract = {_fmt0_recB_rawIn_subnormFract_T[8:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [5:0] _GEN_8 = {{2'd0}, fmt0_recB_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [5:0] _fmt0_recB_rawIn_adjustedExp_T = _GEN_8 ^ 6'h3f; // @[rawFloatFromFN.scala 55:18]
  wire [5:0] _fmt0_recB_rawIn_adjustedExp_T_1 = fmt0_recB_rawIn_isZeroExpIn ? _fmt0_recB_rawIn_adjustedExp_T : {{1'd0},
    fmt0_recB_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _fmt0_recB_rawIn_adjustedExp_T_2 = fmt0_recB_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [4:0] _GEN_9 = {{3'd0}, _fmt0_recB_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [4:0] _fmt0_recB_rawIn_adjustedExp_T_3 = 5'h10 | _GEN_9; // @[rawFloatFromFN.scala 58:9]
  wire [5:0] _GEN_10 = {{1'd0}, _fmt0_recB_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [5:0] fmt0_recB_rawIn_adjustedExp = _fmt0_recB_rawIn_adjustedExp_T_1 + _GEN_10; // @[rawFloatFromFN.scala 57:9]
  wire  fmt0_recB_rawIn_isZero = fmt0_recB_rawIn_isZeroExpIn & fmt0_recB_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  fmt0_recB_rawIn_isSpecial = fmt0_recB_rawIn_adjustedExp[5:4] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  fmt0_recB_rawIn__isNaN = fmt0_recB_rawIn_isSpecial & ~fmt0_recB_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [6:0] fmt0_recB_rawIn__sExp = {1'b0,$signed(fmt0_recB_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _fmt0_recB_rawIn_out_sig_T = ~fmt0_recB_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [9:0] _fmt0_recB_rawIn_out_sig_T_2 = fmt0_recB_rawIn_isZeroExpIn ? fmt0_recB_rawIn_subnormFract :
    fmt0_recB_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [11:0] fmt0_recB_rawIn__sig = {1'h0,_fmt0_recB_rawIn_out_sig_T,_fmt0_recB_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _fmt0_recB_T_2 = fmt0_recB_rawIn_isZero ? 3'h0 : fmt0_recB_rawIn__sExp[5:3]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_11 = {{2'd0}, fmt0_recB_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _fmt0_recB_T_4 = _fmt0_recB_T_2 | _GEN_11; // @[recFNFromFN.scala 48:76]
  wire [6:0] _fmt0_recB_T_7 = {fmt0_recB_rawIn_sign,_fmt0_recB_T_4,fmt0_recB_rawIn__sExp[2:0]}; // @[recFNFromFN.scala 49:45]
  wire  fmt0_recC_rawIn_sign = io_c[15]; // @[rawFloatFromFN.scala 44:18]
  wire [4:0] fmt0_recC_rawIn_expIn = io_c[14:10]; // @[rawFloatFromFN.scala 45:19]
  wire [9:0] fmt0_recC_rawIn_fractIn = io_c[9:0]; // @[rawFloatFromFN.scala 46:21]
  wire  fmt0_recC_rawIn_isZeroExpIn = fmt0_recC_rawIn_expIn == 5'h0; // @[rawFloatFromFN.scala 48:30]
  wire  fmt0_recC_rawIn_isZeroFractIn = fmt0_recC_rawIn_fractIn == 10'h0; // @[rawFloatFromFN.scala 49:34]
  wire [3:0] _fmt0_recC_rawIn_normDist_T_10 = fmt0_recC_rawIn_fractIn[1] ? 4'h8 : 4'h9; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recC_rawIn_normDist_T_11 = fmt0_recC_rawIn_fractIn[2] ? 4'h7 : _fmt0_recC_rawIn_normDist_T_10; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recC_rawIn_normDist_T_12 = fmt0_recC_rawIn_fractIn[3] ? 4'h6 : _fmt0_recC_rawIn_normDist_T_11; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recC_rawIn_normDist_T_13 = fmt0_recC_rawIn_fractIn[4] ? 4'h5 : _fmt0_recC_rawIn_normDist_T_12; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recC_rawIn_normDist_T_14 = fmt0_recC_rawIn_fractIn[5] ? 4'h4 : _fmt0_recC_rawIn_normDist_T_13; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recC_rawIn_normDist_T_15 = fmt0_recC_rawIn_fractIn[6] ? 4'h3 : _fmt0_recC_rawIn_normDist_T_14; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recC_rawIn_normDist_T_16 = fmt0_recC_rawIn_fractIn[7] ? 4'h2 : _fmt0_recC_rawIn_normDist_T_15; // @[Mux.scala 47:70]
  wire [3:0] _fmt0_recC_rawIn_normDist_T_17 = fmt0_recC_rawIn_fractIn[8] ? 4'h1 : _fmt0_recC_rawIn_normDist_T_16; // @[Mux.scala 47:70]
  wire [3:0] fmt0_recC_rawIn_normDist = fmt0_recC_rawIn_fractIn[9] ? 4'h0 : _fmt0_recC_rawIn_normDist_T_17; // @[Mux.scala 47:70]
  wire [24:0] _GEN_16 = {{15'd0}, fmt0_recC_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [24:0] _fmt0_recC_rawIn_subnormFract_T = _GEN_16 << fmt0_recC_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [9:0] fmt0_recC_rawIn_subnormFract = {_fmt0_recC_rawIn_subnormFract_T[8:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [5:0] _GEN_12 = {{2'd0}, fmt0_recC_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [5:0] _fmt0_recC_rawIn_adjustedExp_T = _GEN_12 ^ 6'h3f; // @[rawFloatFromFN.scala 55:18]
  wire [5:0] _fmt0_recC_rawIn_adjustedExp_T_1 = fmt0_recC_rawIn_isZeroExpIn ? _fmt0_recC_rawIn_adjustedExp_T : {{1'd0},
    fmt0_recC_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _fmt0_recC_rawIn_adjustedExp_T_2 = fmt0_recC_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [4:0] _GEN_13 = {{3'd0}, _fmt0_recC_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [4:0] _fmt0_recC_rawIn_adjustedExp_T_3 = 5'h10 | _GEN_13; // @[rawFloatFromFN.scala 58:9]
  wire [5:0] _GEN_14 = {{1'd0}, _fmt0_recC_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [5:0] fmt0_recC_rawIn_adjustedExp = _fmt0_recC_rawIn_adjustedExp_T_1 + _GEN_14; // @[rawFloatFromFN.scala 57:9]
  wire  fmt0_recC_rawIn_isZero = fmt0_recC_rawIn_isZeroExpIn & fmt0_recC_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  fmt0_recC_rawIn_isSpecial = fmt0_recC_rawIn_adjustedExp[5:4] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  fmt0_recC_rawIn__isNaN = fmt0_recC_rawIn_isSpecial & ~fmt0_recC_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [6:0] fmt0_recC_rawIn__sExp = {1'b0,$signed(fmt0_recC_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _fmt0_recC_rawIn_out_sig_T = ~fmt0_recC_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [9:0] _fmt0_recC_rawIn_out_sig_T_2 = fmt0_recC_rawIn_isZeroExpIn ? fmt0_recC_rawIn_subnormFract :
    fmt0_recC_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [11:0] fmt0_recC_rawIn__sig = {1'h0,_fmt0_recC_rawIn_out_sig_T,_fmt0_recC_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _fmt0_recC_T_2 = fmt0_recC_rawIn_isZero ? 3'h0 : fmt0_recC_rawIn__sExp[5:3]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_15 = {{2'd0}, fmt0_recC_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _fmt0_recC_T_4 = _fmt0_recC_T_2 | _GEN_15; // @[recFNFromFN.scala 48:76]
  wire [6:0] _fmt0_recC_T_7 = {fmt0_recC_rawIn_sign,_fmt0_recC_T_4,fmt0_recC_rawIn__sExp[2:0]}; // @[recFNFromFN.scala 49:45]
  wire [16:0] _GEN_0 = io_opSel ? mul_f0_io_out : 17'h0; // @[Emitieee_fp16_mul.scala 55:20 61:16 51:27]
  wire [4:0] _GEN_1 = io_opSel ? mul_f0_io_exceptionFlags : 5'h0; // @[Emitieee_fp16_mul.scala 55:20 62:16 53:27]
  wire [16:0] outRec = ~io_opSel ? fma_f0_io_out : _GEN_0; // @[Emitieee_fp16_mul.scala 55:20 57:16]
  wire  recNonZero = |outRec; // @[Emitieee_fp16_mul.scala 66:27]
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
  MulAddRecFN_e5_s11 fma_f0 ( // @[Emitieee_fp16_mul.scala 39:22]
    .io_a(fma_f0_io_a),
    .io_b(fma_f0_io_b),
    .io_c(fma_f0_io_c),
    .io_roundingMode(fma_f0_io_roundingMode),
    .io_out(fma_f0_io_out),
    .io_exceptionFlags(fma_f0_io_exceptionFlags)
  );
  MulRecFN mul_f0 ( // @[Emitieee_fp16_mul.scala 46:22]
    .io_a(mul_f0_io_a),
    .io_b(mul_f0_io_b),
    .io_roundingMode(mul_f0_io_roundingMode),
    .io_out(mul_f0_io_out),
    .io_exceptionFlags(mul_f0_io_exceptionFlags)
  );
  assign io_out = recNonZero ? outIeee : 16'h0; // @[Emitieee_fp16_mul.scala 69:16]
  assign io_exceptionFlags = ~io_opSel ? fma_f0_io_exceptionFlags : _GEN_1; // @[Emitieee_fp16_mul.scala 55:20 58:16]
  assign fma_f0_io_a = {_fmt0_recA_T_7,fmt0_recA_rawIn__sig[9:0]}; // @[recFNFromFN.scala 50:41]
  assign fma_f0_io_b = {_fmt0_recB_T_7,fmt0_recB_rawIn__sig[9:0]}; // @[recFNFromFN.scala 50:41]
  assign fma_f0_io_c = {_fmt0_recC_T_7,fmt0_recC_rawIn__sig[9:0]}; // @[recFNFromFN.scala 50:41]
  assign fma_f0_io_roundingMode = roundingMatches_0 ? io_roundingMode : 3'h0; // @[Emitieee_fp16_mul.scala 21:25]
  assign mul_f0_io_a = {_fmt0_recA_T_7,fmt0_recA_rawIn__sig[9:0]}; // @[recFNFromFN.scala 50:41]
  assign mul_f0_io_b = {_fmt0_recB_T_7,fmt0_recB_rawIn__sig[9:0]}; // @[recFNFromFN.scala 50:41]
  assign mul_f0_io_roundingMode = roundingMatches_0 ? io_roundingMode : 3'h0; // @[Emitieee_fp16_mul.scala 21:25]
endmodule
