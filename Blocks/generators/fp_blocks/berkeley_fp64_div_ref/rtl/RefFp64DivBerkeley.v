module DivSqrtRawFN_small_e11_s53(
  input         clock,
  input         reset,
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
  wire  entering_normalCase = inReady & normalCase_S; // @[DivSqrtRecFN_small.scala 298:40]
  wire  skipCycle2 = cycleNum == 6'h3 & sigX_Z[54]; // @[DivSqrtRecFN_small.scala 301:39]
  wire  _inReady_T_1 = inReady & ~normalCase_S; // @[DivSqrtRecFN_small.scala 305:26]
  wire  _inReady_T_12 = ~inReady; // @[DivSqrtRecFN_small.scala 313:17]
  wire [5:0] _inReady_T_17 = cycleNum - 6'h1; // @[DivSqrtRecFN_small.scala 313:56]
  wire  _inReady_T_18 = _inReady_T_17 <= 6'h1; // @[DivSqrtRecFN_small.scala 317:38]
  wire  _inReady_T_19 = ~inReady & ~skipCycle2 & _inReady_T_18; // @[DivSqrtRecFN_small.scala 313:16]
  wire  _inReady_T_20 = _inReady_T_1 | _inReady_T_19; // @[DivSqrtRecFN_small.scala 312:15]
  wire  _inReady_T_23 = _inReady_T_20 | skipCycle2; // @[DivSqrtRecFN_small.scala 313:95]
  wire  _rawOutValid_T_18 = _inReady_T_17 == 6'h1; // @[DivSqrtRecFN_small.scala 318:42]
  wire  _rawOutValid_T_19 = ~inReady & ~skipCycle2 & _rawOutValid_T_18; // @[DivSqrtRecFN_small.scala 313:16]
  wire  _rawOutValid_T_20 = _inReady_T_1 | _rawOutValid_T_19; // @[DivSqrtRecFN_small.scala 312:15]
  wire  _rawOutValid_T_23 = _rawOutValid_T_20 | skipCycle2; // @[DivSqrtRecFN_small.scala 313:95]
  wire [5:0] _cycleNum_T_4 = io_a_sExp[0] ? 6'h35 : 6'h36; // @[DivSqrtRecFN_small.scala 308:24]
  wire [5:0] _cycleNum_T_5 = io_sqrtOp ? _cycleNum_T_4 : 6'h37; // @[DivSqrtRecFN_small.scala 307:20]
  wire [5:0] _cycleNum_T_6 = entering_normalCase ? _cycleNum_T_5 : 6'h0; // @[DivSqrtRecFN_small.scala 306:16]
  wire [5:0] _GEN_16 = {{5'd0}, _inReady_T_1}; // @[DivSqrtRecFN_small.scala 305:57]
  wire [5:0] _cycleNum_T_7 = _GEN_16 | _cycleNum_T_6; // @[DivSqrtRecFN_small.scala 305:57]
  wire [5:0] _cycleNum_T_14 = ~inReady & ~skipCycle2 ? _inReady_T_17 : 6'h0; // @[DivSqrtRecFN_small.scala 313:16]
  wire [5:0] _cycleNum_T_15 = _cycleNum_T_7 | _cycleNum_T_14; // @[DivSqrtRecFN_small.scala 312:15]
  wire [5:0] _GEN_17 = {{5'd0}, skipCycle2}; // @[DivSqrtRecFN_small.scala 313:95]
  wire [5:0] _cycleNum_T_17 = _cycleNum_T_15 | _GEN_17; // @[DivSqrtRecFN_small.scala 313:95]
  wire  _GEN_0 = ~idle | inReady ? _inReady_T_23 : inReady; // @[DivSqrtRecFN_small.scala 303:31 317:17 225:33]
  wire [11:0] _sExp_Z_T = io_a_sExp[12:1]; // @[DivSqrtRecFN_small.scala 335:29]
  wire [12:0] _sExp_Z_T_1 = $signed(_sExp_Z_T) + 12'sh400; // @[DivSqrtRecFN_small.scala 335:34]
  wire  _T_3 = _inReady_T_12 & sqrtOp_Z; // @[DivSqrtRecFN_small.scala 340:33]
  wire  _fractB_Z_T_1 = inReady & _sign_S_T; // @[DivSqrtRecFN_small.scala 342:25]
  wire [52:0] _fractB_Z_T_3 = {io_b_sig[51:0], 1'h0}; // @[DivSqrtRecFN_small.scala 342:90]
  wire [52:0] _fractB_Z_T_4 = inReady & _sign_S_T ? _fractB_Z_T_3 : 53'h0; // @[DivSqrtRecFN_small.scala 342:16]
  wire  _fractB_Z_T_5 = inReady & io_sqrtOp; // @[DivSqrtRecFN_small.scala 343:25]
  wire [51:0] _fractB_Z_T_8 = inReady & io_sqrtOp & io_a_sExp[0] ? 52'h8000000000000 : 52'h0; // @[DivSqrtRecFN_small.scala 343:16]
  wire [52:0] _GEN_18 = {{1'd0}, _fractB_Z_T_8}; // @[DivSqrtRecFN_small.scala 342:100]
  wire [52:0] _fractB_Z_T_9 = _fractB_Z_T_4 | _GEN_18; // @[DivSqrtRecFN_small.scala 342:100]
  wire [52:0] _fractB_Z_T_14 = _fractB_Z_T_5 & _evenSqrt_S_T_1 ? 53'h10000000000000 : 53'h0; // @[DivSqrtRecFN_small.scala 344:16]
  wire [52:0] _fractB_Z_T_15 = _fractB_Z_T_9 | _fractB_Z_T_14; // @[DivSqrtRecFN_small.scala 343:100]
  wire [51:0] _fractB_Z_T_25 = _inReady_T_12 ? fractB_Z[52:1] : 52'h0; // @[DivSqrtRecFN_small.scala 346:16]
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
  wire [55:0] _rem_T_15 = _inReady_T_12 ? _rem_T_14 : 56'h0; // @[DivSqrtRecFN_small.scala 359:12]
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
  wire [52:0] _trialTerm_T_11 = _inReady_T_12 ? fractB_Z : 53'h0; // @[DivSqrtRecFN_small.scala 365:12]
  wire [54:0] _GEN_22 = {{2'd0}, _trialTerm_T_11}; // @[DivSqrtRecFN_small.scala 364:74]
  wire [54:0] _trialTerm_T_12 = _trialTerm_T_9 | _GEN_22; // @[DivSqrtRecFN_small.scala 364:74]
  wire  _trialTerm_T_14 = ~sqrtOp_Z; // @[DivSqrtRecFN_small.scala 366:26]
  wire [53:0] _trialTerm_T_17 = _inReady_T_12 & ~sqrtOp_Z ? 54'h20000000000000 : 54'h0; // @[DivSqrtRecFN_small.scala 366:12]
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
  wire [54:0] _sigX_Z_T_12 = _inReady_T_12 ? sigX_Z : 55'h0; // @[DivSqrtRecFN_small.scala 397:16]
  wire [54:0] _sigX_Z_T_13 = _sigX_Z_T_10 | _sigX_Z_T_12; // @[DivSqrtRecFN_small.scala 396:74]
  wire [61:0] _sigX_Z_T_16 = _inReady_T_12 & newBit ? bitMask : 62'h0; // @[DivSqrtRecFN_small.scala 398:16]
  wire [61:0] _GEN_32 = {{7'd0}, _sigX_Z_T_13}; // @[DivSqrtRecFN_small.scala 397:74]
  wire [61:0] _sigX_Z_T_17 = _GEN_32 | _sigX_Z_T_16; // @[DivSqrtRecFN_small.scala 397:74]
  wire [61:0] _GEN_14 = inReady | _inReady_T_12 ? _sigX_Z_T_17 : {{7'd0}, sigX_Z}; // @[DivSqrtRecFN_small.scala 390:34 393:16 245:29]
  wire [55:0] _GEN_33 = {{55'd0}, notZeroRem_Z}; // @[DivSqrtRecFN_small.scala 414:35]
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
    end else if (~idle | inReady) begin // @[DivSqrtRecFN_small.scala 303:31]
      cycleNum <= _cycleNum_T_17; // @[DivSqrtRecFN_small.scala 319:18]
    end
    inReady <= reset | _GEN_0; // @[DivSqrtRecFN_small.scala 225:{33,33}]
    if (reset) begin // @[DivSqrtRecFN_small.scala 226:33]
      rawOutValid <= 1'h0; // @[DivSqrtRecFN_small.scala 226:33]
    end else if (~idle | inReady) begin // @[DivSqrtRecFN_small.scala 303:31]
      rawOutValid <= _rawOutValid_T_23; // @[DivSqrtRecFN_small.scala 318:21]
    end
    if (inReady) begin // @[DivSqrtRecFN_small.scala 326:21]
      sqrtOp_Z <= io_sqrtOp; // @[DivSqrtRecFN_small.scala 327:20]
    end
    if (inReady) begin // @[DivSqrtRecFN_small.scala 326:21]
      if (io_sqrtOp) begin // @[DivSqrtRecFN_small.scala 258:12]
        majorExc_Z <= _majorExc_S_T_3;
      end else begin
        majorExc_Z <= _majorExc_S_T_16;
      end
    end
    if (inReady) begin // @[DivSqrtRecFN_small.scala 326:21]
      if (io_sqrtOp) begin // @[DivSqrtRecFN_small.scala 265:12]
        isNaN_Z <= _isNaN_S_T;
      end else begin
        isNaN_Z <= _isNaN_S_T_2;
      end
    end
    if (inReady) begin // @[DivSqrtRecFN_small.scala 326:21]
      if (io_sqrtOp) begin // @[DivSqrtRecFN_small.scala 269:23]
        isInf_Z <= io_a_isInf;
      end else begin
        isInf_Z <= io_a_isInf | io_b_isZero;
      end
    end
    if (inReady) begin // @[DivSqrtRecFN_small.scala 326:21]
      if (io_sqrtOp) begin // @[DivSqrtRecFN_small.scala 270:23]
        isZero_Z <= io_a_isZero;
      end else begin
        isZero_Z <= io_a_isZero | io_b_isInf;
      end
    end
    if (inReady) begin // @[DivSqrtRecFN_small.scala 326:21]
      sign_Z <= sign_S; // @[DivSqrtRecFN_small.scala 332:20]
    end
    if (inReady) begin // @[DivSqrtRecFN_small.scala 326:21]
      if (io_sqrtOp) begin // @[DivSqrtRecFN_small.scala 334:16]
        sExp_Z <= _sExp_Z_T_1;
      end else begin
        sExp_Z <= sSatExpQuot_S_div;
      end
    end
    if (inReady | _inReady_T_12 & sqrtOp_Z) begin // @[DivSqrtRecFN_small.scala 340:46]
      fractB_Z <= _fractB_Z_T_26; // @[DivSqrtRecFN_small.scala 341:18]
    end
    if (inReady) begin // @[DivSqrtRecFN_small.scala 326:21]
      roundingMode_Z <= io_roundingMode; // @[DivSqrtRecFN_small.scala 338:24]
    end
    if (inReady | _inReady_T_12) begin // @[DivSqrtRecFN_small.scala 390:34]
      rem_Z <= nextRem_Z; // @[DivSqrtRecFN_small.scala 392:15]
    end
    if (inReady | _inReady_T_12) begin // @[DivSqrtRecFN_small.scala 390:34]
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
module DivSqrtRecFM_small_e11_s53(
  input         clock,
  input         reset,
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
  assign io_outValid_div = divSqrtRecFNToRaw_io_rawOutValid_div; // @[DivSqrtRecFN_small.scala 504:22]
  assign io_outValid_sqrt = divSqrtRecFNToRaw_io_rawOutValid_sqrt; // @[DivSqrtRecFN_small.scala 505:22]
  assign io_out = roundRawFNToRecFN_io_out; // @[DivSqrtRecFN_small.scala 514:23]
  assign io_exceptionFlags = roundRawFNToRecFN_io_exceptionFlags; // @[DivSqrtRecFN_small.scala 515:23]
  assign divSqrtRecFNToRaw_clock = clock;
  assign divSqrtRecFNToRaw_reset = reset;
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
module RefFp64DivBerkeley(
  input         clock,
  input         reset,
  input         io_opSel,
  input  [63:0] io_a,
  input  [63:0] io_b,
  input  [63:0] io_c,
  input  [2:0]  io_roundingMode,
  input         io_sqrtOp,
  output        io_outValid,
  output [63:0] io_out,
  output [4:0]  io_exceptionFlags
);
  wire  div_clock; // @[<console> 16:19]
  wire  div_reset; // @[<console> 16:19]
  wire  div_io_sqrtOp; // @[<console> 16:19]
  wire [64:0] div_io_a; // @[<console> 16:19]
  wire [64:0] div_io_b; // @[<console> 16:19]
  wire [2:0] div_io_roundingMode; // @[<console> 16:19]
  wire  div_io_outValid_div; // @[<console> 16:19]
  wire  div_io_outValid_sqrt; // @[<console> 16:19]
  wire [64:0] div_io_out; // @[<console> 16:19]
  wire [4:0] div_io_exceptionFlags; // @[<console> 16:19]
  wire  recA_rawIn_sign = io_a[63]; // @[rawFloatFromFN.scala 44:18]
  wire [10:0] recA_rawIn_expIn = io_a[62:52]; // @[rawFloatFromFN.scala 45:19]
  wire [51:0] recA_rawIn_fractIn = io_a[51:0]; // @[rawFloatFromFN.scala 46:21]
  wire  recA_rawIn_isZeroExpIn = recA_rawIn_expIn == 11'h0; // @[rawFloatFromFN.scala 48:30]
  wire  recA_rawIn_isZeroFractIn = recA_rawIn_fractIn == 52'h0; // @[rawFloatFromFN.scala 49:34]
  wire [5:0] _recA_rawIn_normDist_T_52 = recA_rawIn_fractIn[1] ? 6'h32 : 6'h33; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_53 = recA_rawIn_fractIn[2] ? 6'h31 : _recA_rawIn_normDist_T_52; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_54 = recA_rawIn_fractIn[3] ? 6'h30 : _recA_rawIn_normDist_T_53; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_55 = recA_rawIn_fractIn[4] ? 6'h2f : _recA_rawIn_normDist_T_54; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_56 = recA_rawIn_fractIn[5] ? 6'h2e : _recA_rawIn_normDist_T_55; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_57 = recA_rawIn_fractIn[6] ? 6'h2d : _recA_rawIn_normDist_T_56; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_58 = recA_rawIn_fractIn[7] ? 6'h2c : _recA_rawIn_normDist_T_57; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_59 = recA_rawIn_fractIn[8] ? 6'h2b : _recA_rawIn_normDist_T_58; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_60 = recA_rawIn_fractIn[9] ? 6'h2a : _recA_rawIn_normDist_T_59; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_61 = recA_rawIn_fractIn[10] ? 6'h29 : _recA_rawIn_normDist_T_60; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_62 = recA_rawIn_fractIn[11] ? 6'h28 : _recA_rawIn_normDist_T_61; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_63 = recA_rawIn_fractIn[12] ? 6'h27 : _recA_rawIn_normDist_T_62; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_64 = recA_rawIn_fractIn[13] ? 6'h26 : _recA_rawIn_normDist_T_63; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_65 = recA_rawIn_fractIn[14] ? 6'h25 : _recA_rawIn_normDist_T_64; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_66 = recA_rawIn_fractIn[15] ? 6'h24 : _recA_rawIn_normDist_T_65; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_67 = recA_rawIn_fractIn[16] ? 6'h23 : _recA_rawIn_normDist_T_66; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_68 = recA_rawIn_fractIn[17] ? 6'h22 : _recA_rawIn_normDist_T_67; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_69 = recA_rawIn_fractIn[18] ? 6'h21 : _recA_rawIn_normDist_T_68; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_70 = recA_rawIn_fractIn[19] ? 6'h20 : _recA_rawIn_normDist_T_69; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_71 = recA_rawIn_fractIn[20] ? 6'h1f : _recA_rawIn_normDist_T_70; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_72 = recA_rawIn_fractIn[21] ? 6'h1e : _recA_rawIn_normDist_T_71; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_73 = recA_rawIn_fractIn[22] ? 6'h1d : _recA_rawIn_normDist_T_72; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_74 = recA_rawIn_fractIn[23] ? 6'h1c : _recA_rawIn_normDist_T_73; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_75 = recA_rawIn_fractIn[24] ? 6'h1b : _recA_rawIn_normDist_T_74; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_76 = recA_rawIn_fractIn[25] ? 6'h1a : _recA_rawIn_normDist_T_75; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_77 = recA_rawIn_fractIn[26] ? 6'h19 : _recA_rawIn_normDist_T_76; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_78 = recA_rawIn_fractIn[27] ? 6'h18 : _recA_rawIn_normDist_T_77; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_79 = recA_rawIn_fractIn[28] ? 6'h17 : _recA_rawIn_normDist_T_78; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_80 = recA_rawIn_fractIn[29] ? 6'h16 : _recA_rawIn_normDist_T_79; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_81 = recA_rawIn_fractIn[30] ? 6'h15 : _recA_rawIn_normDist_T_80; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_82 = recA_rawIn_fractIn[31] ? 6'h14 : _recA_rawIn_normDist_T_81; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_83 = recA_rawIn_fractIn[32] ? 6'h13 : _recA_rawIn_normDist_T_82; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_84 = recA_rawIn_fractIn[33] ? 6'h12 : _recA_rawIn_normDist_T_83; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_85 = recA_rawIn_fractIn[34] ? 6'h11 : _recA_rawIn_normDist_T_84; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_86 = recA_rawIn_fractIn[35] ? 6'h10 : _recA_rawIn_normDist_T_85; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_87 = recA_rawIn_fractIn[36] ? 6'hf : _recA_rawIn_normDist_T_86; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_88 = recA_rawIn_fractIn[37] ? 6'he : _recA_rawIn_normDist_T_87; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_89 = recA_rawIn_fractIn[38] ? 6'hd : _recA_rawIn_normDist_T_88; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_90 = recA_rawIn_fractIn[39] ? 6'hc : _recA_rawIn_normDist_T_89; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_91 = recA_rawIn_fractIn[40] ? 6'hb : _recA_rawIn_normDist_T_90; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_92 = recA_rawIn_fractIn[41] ? 6'ha : _recA_rawIn_normDist_T_91; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_93 = recA_rawIn_fractIn[42] ? 6'h9 : _recA_rawIn_normDist_T_92; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_94 = recA_rawIn_fractIn[43] ? 6'h8 : _recA_rawIn_normDist_T_93; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_95 = recA_rawIn_fractIn[44] ? 6'h7 : _recA_rawIn_normDist_T_94; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_96 = recA_rawIn_fractIn[45] ? 6'h6 : _recA_rawIn_normDist_T_95; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_97 = recA_rawIn_fractIn[46] ? 6'h5 : _recA_rawIn_normDist_T_96; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_98 = recA_rawIn_fractIn[47] ? 6'h4 : _recA_rawIn_normDist_T_97; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_99 = recA_rawIn_fractIn[48] ? 6'h3 : _recA_rawIn_normDist_T_98; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_100 = recA_rawIn_fractIn[49] ? 6'h2 : _recA_rawIn_normDist_T_99; // @[Mux.scala 47:70]
  wire [5:0] _recA_rawIn_normDist_T_101 = recA_rawIn_fractIn[50] ? 6'h1 : _recA_rawIn_normDist_T_100; // @[Mux.scala 47:70]
  wire [5:0] recA_rawIn_normDist = recA_rawIn_fractIn[51] ? 6'h0 : _recA_rawIn_normDist_T_101; // @[Mux.scala 47:70]
  wire [114:0] _GEN_8 = {{63'd0}, recA_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [114:0] _recA_rawIn_subnormFract_T = _GEN_8 << recA_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [51:0] recA_rawIn_subnormFract = {_recA_rawIn_subnormFract_T[50:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [11:0] _GEN_0 = {{6'd0}, recA_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _recA_rawIn_adjustedExp_T = _GEN_0 ^ 12'hfff; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _recA_rawIn_adjustedExp_T_1 = recA_rawIn_isZeroExpIn ? _recA_rawIn_adjustedExp_T : {{1'd0},
    recA_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _recA_rawIn_adjustedExp_T_2 = recA_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [10:0] _GEN_1 = {{9'd0}, _recA_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [10:0] _recA_rawIn_adjustedExp_T_3 = 11'h400 | _GEN_1; // @[rawFloatFromFN.scala 58:9]
  wire [11:0] _GEN_2 = {{1'd0}, _recA_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [11:0] recA_rawIn_adjustedExp = _recA_rawIn_adjustedExp_T_1 + _GEN_2; // @[rawFloatFromFN.scala 57:9]
  wire  recA_rawIn_isZero = recA_rawIn_isZeroExpIn & recA_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  recA_rawIn_isSpecial = recA_rawIn_adjustedExp[11:10] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  recA_rawIn__isNaN = recA_rawIn_isSpecial & ~recA_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [12:0] recA_rawIn__sExp = {1'b0,$signed(recA_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _recA_rawIn_out_sig_T = ~recA_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [51:0] _recA_rawIn_out_sig_T_2 = recA_rawIn_isZeroExpIn ? recA_rawIn_subnormFract : recA_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [53:0] recA_rawIn__sig = {1'h0,_recA_rawIn_out_sig_T,_recA_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _recA_T_1 = recA_rawIn_isZero ? 3'h0 : recA_rawIn__sExp[11:9]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_3 = {{2'd0}, recA_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _recA_T_3 = _recA_T_1 | _GEN_3; // @[recFNFromFN.scala 48:76]
  wire [12:0] _recA_T_6 = {recA_rawIn_sign,_recA_T_3,recA_rawIn__sExp[8:0]}; // @[recFNFromFN.scala 49:45]
  wire  recB_rawIn_sign = io_b[63]; // @[rawFloatFromFN.scala 44:18]
  wire [10:0] recB_rawIn_expIn = io_b[62:52]; // @[rawFloatFromFN.scala 45:19]
  wire [51:0] recB_rawIn_fractIn = io_b[51:0]; // @[rawFloatFromFN.scala 46:21]
  wire  recB_rawIn_isZeroExpIn = recB_rawIn_expIn == 11'h0; // @[rawFloatFromFN.scala 48:30]
  wire  recB_rawIn_isZeroFractIn = recB_rawIn_fractIn == 52'h0; // @[rawFloatFromFN.scala 49:34]
  wire [5:0] _recB_rawIn_normDist_T_52 = recB_rawIn_fractIn[1] ? 6'h32 : 6'h33; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_53 = recB_rawIn_fractIn[2] ? 6'h31 : _recB_rawIn_normDist_T_52; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_54 = recB_rawIn_fractIn[3] ? 6'h30 : _recB_rawIn_normDist_T_53; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_55 = recB_rawIn_fractIn[4] ? 6'h2f : _recB_rawIn_normDist_T_54; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_56 = recB_rawIn_fractIn[5] ? 6'h2e : _recB_rawIn_normDist_T_55; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_57 = recB_rawIn_fractIn[6] ? 6'h2d : _recB_rawIn_normDist_T_56; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_58 = recB_rawIn_fractIn[7] ? 6'h2c : _recB_rawIn_normDist_T_57; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_59 = recB_rawIn_fractIn[8] ? 6'h2b : _recB_rawIn_normDist_T_58; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_60 = recB_rawIn_fractIn[9] ? 6'h2a : _recB_rawIn_normDist_T_59; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_61 = recB_rawIn_fractIn[10] ? 6'h29 : _recB_rawIn_normDist_T_60; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_62 = recB_rawIn_fractIn[11] ? 6'h28 : _recB_rawIn_normDist_T_61; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_63 = recB_rawIn_fractIn[12] ? 6'h27 : _recB_rawIn_normDist_T_62; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_64 = recB_rawIn_fractIn[13] ? 6'h26 : _recB_rawIn_normDist_T_63; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_65 = recB_rawIn_fractIn[14] ? 6'h25 : _recB_rawIn_normDist_T_64; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_66 = recB_rawIn_fractIn[15] ? 6'h24 : _recB_rawIn_normDist_T_65; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_67 = recB_rawIn_fractIn[16] ? 6'h23 : _recB_rawIn_normDist_T_66; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_68 = recB_rawIn_fractIn[17] ? 6'h22 : _recB_rawIn_normDist_T_67; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_69 = recB_rawIn_fractIn[18] ? 6'h21 : _recB_rawIn_normDist_T_68; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_70 = recB_rawIn_fractIn[19] ? 6'h20 : _recB_rawIn_normDist_T_69; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_71 = recB_rawIn_fractIn[20] ? 6'h1f : _recB_rawIn_normDist_T_70; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_72 = recB_rawIn_fractIn[21] ? 6'h1e : _recB_rawIn_normDist_T_71; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_73 = recB_rawIn_fractIn[22] ? 6'h1d : _recB_rawIn_normDist_T_72; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_74 = recB_rawIn_fractIn[23] ? 6'h1c : _recB_rawIn_normDist_T_73; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_75 = recB_rawIn_fractIn[24] ? 6'h1b : _recB_rawIn_normDist_T_74; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_76 = recB_rawIn_fractIn[25] ? 6'h1a : _recB_rawIn_normDist_T_75; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_77 = recB_rawIn_fractIn[26] ? 6'h19 : _recB_rawIn_normDist_T_76; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_78 = recB_rawIn_fractIn[27] ? 6'h18 : _recB_rawIn_normDist_T_77; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_79 = recB_rawIn_fractIn[28] ? 6'h17 : _recB_rawIn_normDist_T_78; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_80 = recB_rawIn_fractIn[29] ? 6'h16 : _recB_rawIn_normDist_T_79; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_81 = recB_rawIn_fractIn[30] ? 6'h15 : _recB_rawIn_normDist_T_80; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_82 = recB_rawIn_fractIn[31] ? 6'h14 : _recB_rawIn_normDist_T_81; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_83 = recB_rawIn_fractIn[32] ? 6'h13 : _recB_rawIn_normDist_T_82; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_84 = recB_rawIn_fractIn[33] ? 6'h12 : _recB_rawIn_normDist_T_83; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_85 = recB_rawIn_fractIn[34] ? 6'h11 : _recB_rawIn_normDist_T_84; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_86 = recB_rawIn_fractIn[35] ? 6'h10 : _recB_rawIn_normDist_T_85; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_87 = recB_rawIn_fractIn[36] ? 6'hf : _recB_rawIn_normDist_T_86; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_88 = recB_rawIn_fractIn[37] ? 6'he : _recB_rawIn_normDist_T_87; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_89 = recB_rawIn_fractIn[38] ? 6'hd : _recB_rawIn_normDist_T_88; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_90 = recB_rawIn_fractIn[39] ? 6'hc : _recB_rawIn_normDist_T_89; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_91 = recB_rawIn_fractIn[40] ? 6'hb : _recB_rawIn_normDist_T_90; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_92 = recB_rawIn_fractIn[41] ? 6'ha : _recB_rawIn_normDist_T_91; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_93 = recB_rawIn_fractIn[42] ? 6'h9 : _recB_rawIn_normDist_T_92; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_94 = recB_rawIn_fractIn[43] ? 6'h8 : _recB_rawIn_normDist_T_93; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_95 = recB_rawIn_fractIn[44] ? 6'h7 : _recB_rawIn_normDist_T_94; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_96 = recB_rawIn_fractIn[45] ? 6'h6 : _recB_rawIn_normDist_T_95; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_97 = recB_rawIn_fractIn[46] ? 6'h5 : _recB_rawIn_normDist_T_96; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_98 = recB_rawIn_fractIn[47] ? 6'h4 : _recB_rawIn_normDist_T_97; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_99 = recB_rawIn_fractIn[48] ? 6'h3 : _recB_rawIn_normDist_T_98; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_100 = recB_rawIn_fractIn[49] ? 6'h2 : _recB_rawIn_normDist_T_99; // @[Mux.scala 47:70]
  wire [5:0] _recB_rawIn_normDist_T_101 = recB_rawIn_fractIn[50] ? 6'h1 : _recB_rawIn_normDist_T_100; // @[Mux.scala 47:70]
  wire [5:0] recB_rawIn_normDist = recB_rawIn_fractIn[51] ? 6'h0 : _recB_rawIn_normDist_T_101; // @[Mux.scala 47:70]
  wire [114:0] _GEN_9 = {{63'd0}, recB_rawIn_fractIn}; // @[rawFloatFromFN.scala 52:33]
  wire [114:0] _recB_rawIn_subnormFract_T = _GEN_9 << recB_rawIn_normDist; // @[rawFloatFromFN.scala 52:33]
  wire [51:0] recB_rawIn_subnormFract = {_recB_rawIn_subnormFract_T[50:0], 1'h0}; // @[rawFloatFromFN.scala 52:64]
  wire [11:0] _GEN_4 = {{6'd0}, recB_rawIn_normDist}; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _recB_rawIn_adjustedExp_T = _GEN_4 ^ 12'hfff; // @[rawFloatFromFN.scala 55:18]
  wire [11:0] _recB_rawIn_adjustedExp_T_1 = recB_rawIn_isZeroExpIn ? _recB_rawIn_adjustedExp_T : {{1'd0},
    recB_rawIn_expIn}; // @[rawFloatFromFN.scala 54:10]
  wire [1:0] _recB_rawIn_adjustedExp_T_2 = recB_rawIn_isZeroExpIn ? 2'h2 : 2'h1; // @[rawFloatFromFN.scala 58:14]
  wire [10:0] _GEN_5 = {{9'd0}, _recB_rawIn_adjustedExp_T_2}; // @[rawFloatFromFN.scala 58:9]
  wire [10:0] _recB_rawIn_adjustedExp_T_3 = 11'h400 | _GEN_5; // @[rawFloatFromFN.scala 58:9]
  wire [11:0] _GEN_6 = {{1'd0}, _recB_rawIn_adjustedExp_T_3}; // @[rawFloatFromFN.scala 57:9]
  wire [11:0] recB_rawIn_adjustedExp = _recB_rawIn_adjustedExp_T_1 + _GEN_6; // @[rawFloatFromFN.scala 57:9]
  wire  recB_rawIn_isZero = recB_rawIn_isZeroExpIn & recB_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 60:30]
  wire  recB_rawIn_isSpecial = recB_rawIn_adjustedExp[11:10] == 2'h3; // @[rawFloatFromFN.scala 61:57]
  wire  recB_rawIn__isNaN = recB_rawIn_isSpecial & ~recB_rawIn_isZeroFractIn; // @[rawFloatFromFN.scala 64:28]
  wire [12:0] recB_rawIn__sExp = {1'b0,$signed(recB_rawIn_adjustedExp)}; // @[rawFloatFromFN.scala 68:42]
  wire  _recB_rawIn_out_sig_T = ~recB_rawIn_isZero; // @[rawFloatFromFN.scala 70:19]
  wire [51:0] _recB_rawIn_out_sig_T_2 = recB_rawIn_isZeroExpIn ? recB_rawIn_subnormFract : recB_rawIn_fractIn; // @[rawFloatFromFN.scala 70:33]
  wire [53:0] recB_rawIn__sig = {1'h0,_recB_rawIn_out_sig_T,_recB_rawIn_out_sig_T_2}; // @[rawFloatFromFN.scala 70:27]
  wire [2:0] _recB_T_1 = recB_rawIn_isZero ? 3'h0 : recB_rawIn__sExp[11:9]; // @[recFNFromFN.scala 48:15]
  wire [2:0] _GEN_7 = {{2'd0}, recB_rawIn__isNaN}; // @[recFNFromFN.scala 48:76]
  wire [2:0] _recB_T_3 = _recB_T_1 | _GEN_7; // @[recFNFromFN.scala 48:76]
  wire [12:0] _recB_T_6 = {recB_rawIn_sign,_recB_T_3,recB_rawIn__sExp[8:0]}; // @[recFNFromFN.scala 49:45]
  wire [11:0] outIeee_rawIn_exp = div_io_out[63:52]; // @[rawFloatFromRecFN.scala 51:21]
  wire  outIeee_rawIn_isZero = outIeee_rawIn_exp[11:9] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  outIeee_rawIn_isSpecial = outIeee_rawIn_exp[11:10] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  outIeee_rawIn__isNaN = outIeee_rawIn_isSpecial & outIeee_rawIn_exp[9]; // @[rawFloatFromRecFN.scala 56:33]
  wire  outIeee_rawIn__isInf = outIeee_rawIn_isSpecial & ~outIeee_rawIn_exp[9]; // @[rawFloatFromRecFN.scala 57:33]
  wire  outIeee_rawIn__sign = div_io_out[64]; // @[rawFloatFromRecFN.scala 59:25]
  wire [12:0] outIeee_rawIn__sExp = {1'b0,$signed(outIeee_rawIn_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _outIeee_rawIn_out_sig_T = ~outIeee_rawIn_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [53:0] outIeee_rawIn__sig = {1'h0,_outIeee_rawIn_out_sig_T,div_io_out[51:0]}; // @[rawFloatFromRecFN.scala 61:44]
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
  wire [11:0] outIeee_hi = {outIeee_rawIn__sign,outIeee_expOut}; // @[Cat.scala 33:92]
  DivSqrtRecFM_small_e11_s53 div ( // @[<console> 16:19]
    .clock(div_clock),
    .reset(div_reset),
    .io_sqrtOp(div_io_sqrtOp),
    .io_a(div_io_a),
    .io_b(div_io_b),
    .io_roundingMode(div_io_roundingMode),
    .io_outValid_div(div_io_outValid_div),
    .io_outValid_sqrt(div_io_outValid_sqrt),
    .io_out(div_io_out),
    .io_exceptionFlags(div_io_exceptionFlags)
  );
  assign io_outValid = div_io_outValid_div | div_io_outValid_sqrt; // @[<console> 28:38]
  assign io_out = {outIeee_hi,outIeee_fractOut}; // @[Cat.scala 33:92]
  assign io_exceptionFlags = div_io_exceptionFlags; // @[<console> 27:21]
  assign div_clock = clock;
  assign div_reset = reset;
  assign div_io_sqrtOp = io_sqrtOp; // @[<console> 18:17]
  assign div_io_a = {_recA_T_6,recA_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign div_io_b = {_recB_T_6,recB_rawIn__sig[51:0]}; // @[recFNFromFN.scala 50:41]
  assign div_io_roundingMode = io_roundingMode; // @[<console> 21:23]
endmodule
