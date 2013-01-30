// multdiv.v
// David_Harris at hmc dot edu 1/2/07
// Cassie Chou cassiepchou at gmail dot com 3/8/07
// Carl Nygaard carlpny at gmail dot com 3/8/07
//
// An ALU-based multiplier and divider
// handling signed and unsigned operands
//
// Apply inputs and assert start for one cycle.
// Outputs are in prodh and prodl when run becomes low for a cycle
//  Mult: {PRODH, PRODL} = X * Y
//  Div:  PRODH = X % Y ; PRODL = X/Y
//
// The unit has a 2N-bit product register, an N-bit Y register.
// Initially, Y is loaded in the Y register, X is loaded in PRODL,
// and PRODH is cleared.  The unit also has an N-bit ALU and an
// Y mux.  On each cycle, the unit chooses {2Y, Y, 0, -Y, -2Y}, adds
// it to a shifted PRODH, and puts the result back in PRODH.
//
// Keep two more significant bits for PRODH.  One is because 2Y may be
// N+1 bits.  The second is to gracefully handle the sign.
// 
// The multiplier uses Radix 4 Booth's algorithm to handle signed and unsigned
// operands.  It chooses the X multiple based on the 3 lsbs of PRODL.
// After each step, it right-shifts by 2.  At the end, 
//
// The divider left-shifts the two registers by 1 on each cycle.  It 
// subtracts Y from PRODH.  If the result is positive, it is kept and
// the quotient bit is set to 1; otherwise the result is discarded.
//
// Signed division is a tricky case.  To handle it, X and Y are
// made positive, then the sign of the quotient and remainder are adjusted
// at the end:
//
//  Negate quotient if signs of divisor (X) and dividend (Y) disagree 
//  Set sign of remainder so that it agrees with dividend 
//  Examples: 
//  13 / 5 = 2 with remainder of 3 
//  (-13) / 5 = -2 with remainder of 3 
//  13 / (-5) = -2 with remainder of -3 
//  (-13) / (-5) = 2 with remainder of -3 


////////////////////////////////////////////////////////////////////////////////
// Module: multdiv
// 
// This module is the top level for the multiply/divide unit.
// It contains a controller and datapath to perform signed and
// unsigned multiplication and division (mult when multdivb = 1).
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

module multdiv(input         ph1, ph2,
               input         reset,
               input         start,
               input         muldivb,
               input         signedop,
               input  [31:0] x,
               input  [31:0] y,
               output [31:0] prodh,
               output [31:0] prodl,
               output        run);

  wire done, init, muldivbsaved, signedopsaved;
  wire qi, srchinv;
  wire yzero;
  wire [1:0] prodhsel, prodlsel;
  wire [1:0] srchsel;
  wire [1:0] prodhextra;
  wire [2:0] ysel;
  wire [31:0] ysaved, prodlsh, nextprodl;
  wire [33:0] srch1, srch, prodhsh, nextprodh, yy, srchplusyy;

  // control logic
  mdcontroller mdcont(ph1, ph2, reset, start, run, done, init, muldivb, 
                      signedop, prodl[1:0], x[31], y[31], ysaved[31], srch1[31],
                      srchplusyy[33], yzero, ysel, srchsel, srchinv, prodhsel, 
                      prodlsel, qi, muldivbsaved, signedopsaved);

  // Y register and Booth mux
  flopenr        yreg(ph1, ph2, reset, start, y, ysaved);
  boothsel       ybooth(ysaved, ysel, signedopsaved, yy, cin);
  zerodetect     yzdetect(ysaved, yzero);

  // PRODH
  // keep one extrsrc/multdiv.va bit in high part to accomdate 2x Booth multiples and another
  // bit to keep sign
  shl1r2   #(34) prodhshlr(muldivbsaved, {prodhextra, prodh}, 
                           {2{prodhextra[1]}}, prodl[31], prodhsh);
  mux3     #(34) srchmux(prodhsh, {prodhextra, prodh}, {2'b0, prodl}, 
                         srchsel, srch1);  // only necessary for signed division
  xor2     #(34) srchxor(srch1, {34{srchinv}}, srch); // only necessary for 
                                                      // signed division
  adderc   #(34) addh(srch, yy, cin, srchplusyy, cout);
  mux3     #(34) prodhmux(prodhsh, srchplusyy, {prodhextra, prodh}, prodhsel, 
                          nextprodh); // d2 for signed division only
  flopenr  #(34) prodhreg(ph1, ph2, init, run, nextprodh, {prodhextra, prodh});

  // PRODL
  shl1r2         prodlshlr(muldivbsaved, prodl, prodh[1:0], qi, prodlsh);
  mux4           prodlmux(prodlsh, srchplusyy[31:0], prodl, x, prodlsel, 
                          nextprodl); // d1 and d2 for signed division only
  flopenr        prodlreg(ph1, ph2, reset, run, nextprodl, 
                          prodl); // probably doesnt' need reset
endmodule

////////////////////////////////////////////////////////////////////////////////
// Module: mdcontroller
// 
// This module contains a counter to cycle through the steps for
// multiplication or division.  Based on the cycle and the data,
// it generates select signals for the multiplexers.  Most of
// the complexity is due to the signed division, which must 
// conditionally take the two's complement of the inputs and outputs.
////////////////////////////////////////////////////////////////////////////////

module mdcontroller(input            ph1, ph2,
                    input            reset,
                    input            start,
                    output           run,
                    output           done,
                    output           init,
                    input            muldivb,
                    input            signedop,
                    input  [1:0]     x,
                    input            xsign,
                    input            ysign,
                    input            ysavedsign,
                    input            srchsign,
                    input            addsign,
                    input            yzero,
                    output     [2:0] ysel,
                    output     [1:0] srchsel,
                    output           srchinv,
                    output     [1:0] prodhsel,
                    output     [1:0] prodlsel,
                    output           qi,
                    output           muldivbsaved, signedopsaved);

  wire [5:0] nextcount, count;
  wire       nccout, oldrun;
  wire       oldx, muldivbreg, signedopreg;
  reg [1:0] x2;
  wire        signsdisagree, ysel2b;
  reg [10:0] caseout; 
  //wire count0, count17, count32, count33, count34, count35;
  reg [6:0] countvals;

  // count and run registers
  flopenr #(6) countreg(ph1, ph2, init, run, nextcount, count);
  flopr #(1)   runreg(ph1, ph2, reset, run, oldrun);

  // remember whether we are multiplying or dividing and whether we are using
  // a signed op, the value must also be available while start is high
  flopen #(2) controlreg(ph1, ph2, start, {muldivb, signedop}, 
                         {muldivbreg, signedopreg});

  assign {muldivbsaved, signedopsaved} = start ? {muldivb, signedop}
                                               : {muldivbreg, signedopreg};

  // combinational logic for run and count
  assign init = reset | start;
  assign run = start | (oldrun & ~done);
  inc #(6) nc(count, nextcount, nccout);

  // hang onto sign for result of signed division
  flopenr #(1) signdisagreereg(ph1, ph2, reset, start, xsign ^ ysign, 
                               signsdisagree);

  // determine quotient digit
  assign qi = ~addsign; // sign of result for division

  // check for division by zero
  //assign dividebyzero = yzero & ~muldivbsaved;

  // keep previous x msb for Booth encoding
  flopr #(1) xoldreg(ph1, ph2, init, x[1], oldx);
  
  // countvals indicates bitwise whether count is equal to certain values, in
  // this order:
  // count16, count0, count17, count32, count33, count34, count35
  always @ (*) 
    case(count)
      6'b010000: countvals = 7'b1000000; // 16 is not used in the main PLA
      6'b000000: countvals = 7'b0100000; // 0
      6'b010001: countvals = 7'b0010000; // 17
      6'b100000: countvals = 7'b0001000; // 32
      6'b100001: countvals = 7'b0000100; // 33
      6'b100010: countvals = 7'b0000010; // 34
      6'b100011: countvals = 7'b0000001; // 25
      default:   countvals = 7'b0000000; // other
    endcase

  // ysel by default is 4, but the PLA's default is all zeros, so we make the
  // high bit of ysel inverting
  assign ysel[2] = ~ysel2b;
  assign {srchsel, srchinv, prodhsel, prodlsel, 
          ysel2b, ysel[1:0], done} = caseout;

  always @ ( * ) 
  casez ({muldivbsaved, signedopsaved, countvals[5:0], x2, oldx, srchsign, 
          signsdisagree, ysavedsign, qi, start})
    // MULDIVSAVED
    // if count = 17 
    16'b1?_?10000_??_?_?_?_?_?_0: caseout = 11'b00_0_01_00_000_1;
    16'b1?_?10000_??_?_?_?_?_?_1: caseout = 11'b00_0_01_11_000_1;
    // else
    16'b1?_?0????_00_0_?_?_?_?_0: caseout = 11'b00_0_01_00_000_0;
    16'b1?_?0????_00_1_?_?_?_?_0: caseout = 11'b00_0_01_00_100_0;
    16'b1?_?0????_01_0_?_?_?_?_0: caseout = 11'b00_0_01_00_100_0;
    16'b1?_?0????_01_1_?_?_?_?_0: caseout = 11'b00_0_01_00_101_0;
    16'b1?_?0????_10_0_?_?_?_?_0: caseout = 11'b00_0_01_00_111_0;
    16'b1?_?0????_10_1_?_?_?_?_0: caseout = 11'b00_0_01_00_110_0;
    16'b1?_?0????_11_0_?_?_?_?_0: caseout = 11'b00_0_01_00_110_0;
    16'b1?_?0????_11_1_?_?_?_?_0: caseout = 11'b00_0_01_00_000_0;

    16'b1?_?0????_00_0_?_?_?_?_1: caseout = 11'b00_0_01_11_000_0;    
    16'b1?_?0????_00_1_?_?_?_?_1: caseout = 11'b00_0_01_11_100_0;
    16'b1?_?0????_01_0_?_?_?_?_1: caseout = 11'b00_0_01_11_100_0;
    16'b1?_?0????_01_1_?_?_?_?_1: caseout = 11'b00_0_01_11_101_0;
    16'b1?_?0????_10_0_?_?_?_?_1: caseout = 11'b00_0_01_11_111_0;
    16'b1?_?0????_10_1_?_?_?_?_1: caseout = 11'b00_0_01_11_110_0;
    16'b1?_?0????_11_0_?_?_?_?_1: caseout = 11'b00_0_01_11_110_0;
    16'b1?_?0????_11_1_?_?_?_?_1: caseout = 11'b00_0_01_11_000_0;

    // ~MULDIVSAVED ~SIGNEDOPSAVED
    // count 32
    16'b00_??1???_??_?_?_?_?_0_0: caseout = 11'b00_0_00_00_110_1;
    16'b00_??1???_??_?_?_?_?_0_1: caseout = 11'b00_0_00_11_110_1;
    16'b00_??1???_??_?_?_?_?_1_0: caseout = 11'b00_0_01_00_110_1;
    16'b00_??1???_??_?_?_?_?_1_1: caseout = 11'b00_0_01_11_110_1;
    16'b00_??0???_??_?_?_?_?_0_0: caseout = 11'b00_0_00_00_110_0;
    16'b00_??0???_??_?_?_?_?_1_0: caseout = 11'b00_0_01_00_110_0;
    16'b00_??0???_??_?_?_?_?_0_1: caseout = 11'b00_0_00_11_110_0;
    16'b00_??0???_??_?_?_?_?_1_1: caseout = 11'b00_0_01_11_110_0;
      
    // ~MULDIVSAVED SIGNEDOPSAVED
    // count = 0   srchsign, start
    16'b01_1??000_??_?_0_?_?_?_0: caseout = 11'b10_0_10_01_000_0;       
    16'b01_1??000_??_?_1_?_?_?_0: caseout = 11'b10_1_10_01_010_0;
    16'b01_1??000_??_?_0_?_?_?_1: caseout = 11'b10_0_10_11_000_0;
    16'b01_1??000_??_?_1_?_?_?_1: caseout = 11'b10_1_10_11_010_0;
    // count = 33
    16'b01_0??100_??_?_?_0_?_?_0: caseout = 11'b10_0_10_01_000_0;
    16'b01_0??100_??_?_?_0_?_?_1: caseout = 11'b10_0_10_11_000_0;
    16'b01_0??100_??_?_?_1_?_?_0: caseout = 11'b10_1_10_01_010_0;
    16'b01_0??100_??_?_?_1_?_?_1: caseout = 11'b10_1_10_11_010_0;
    // count = 34
    16'b01_0??010_??_?_?_?_0_?_0: caseout = 11'b01_0_01_10_000_0;
    16'b01_0??010_??_?_?_?_0_?_1: caseout = 11'b01_0_01_11_000_0;
    16'b01_0??010_??_?_?_?_1_?_0: caseout = 11'b01_1_01_10_010_0;
    16'b01_0??010_??_?_?_?_1_?_1: caseout = 11'b01_1_01_11_010_0;
    // count = 35 stoppedhere
    16'b01_0??001_??_?_?_?_?_?_0: caseout = 11'b00_0_00_00_000_1;
    16'b01_0??001_??_?_?_?_?_?_1: caseout = 11'b00_0_00_11_000_1;
    // {ysavedsign, qi, start}    
    //   {srchsel, srchinv, prodhsel, prodlsel, ysel, done}              
    16'b01_0??000_??_?_?_?_0_0_0: caseout = 11'b00_0_00_00_110_0;
    16'b01_0??000_??_?_?_?_0_0_1: caseout = 11'b00_0_00_11_110_0;
    16'b01_0??000_??_?_?_?_0_1_0: caseout = 11'b00_0_01_00_110_0;
    16'b01_0??000_??_?_?_?_0_1_1: caseout = 11'b00_0_01_11_110_0;    
    16'b01_0??000_??_?_?_?_1_0_0: caseout = 11'b00_0_00_00_100_0;
    16'b01_0??000_??_?_?_?_1_0_1: caseout = 11'b00_0_00_11_100_0;
    16'b01_0??000_??_?_?_?_1_1_0: caseout = 11'b00_0_01_00_100_0;
    16'b01_0??000_??_?_?_?_1_1_1: caseout = 11'b00_0_01_11_100_0;
    // start = done
    default:                      caseout = 11'b00_0_00_00_000_0;
  endcase
  
always @ ( * ) 
   if (muldivbsaved && countvals[6] == 1) x2 = signedopsaved ? {2{oldx}} : 2'b0;
   else x2 = x;
   
endmodule
////////////////////////////////////////////////////////////////////////////////
// Module: shl1r2
// 
// Shift left by 1 (for divide) or right by 2 (for mult).
////////////////////////////////////////////////////////////////////////////////

module shl1r2 #(parameter WIDTH = 32)
               (input             dir,
               input  [WIDTH-1:0] a,
               input  [1:0]       inl,
               input              inr,
               output [WIDTH-1:0] y);

  // if dir == 0, shift left by 1.  Else shift right by 2
  mux2 #(WIDTH) shmux({a[WIDTH-2:0], inr}, {inl, a[WIDTH-1:2]}, dir, y);
endmodule

////////////////////////////////////////////////////////////////////////////////
// Module: boothsel
// 
// Select the appropriate second source operand based on boothsel:
//  0: Y
//  1: 2Y
//  2: -Y
//  3: -2Y
//  4: 0
//  6: 1
// The output is sign-extended to 34 bits.
////////////////////////////////////////////////////////////////////////////////

module boothsel(input  [31:0] a,
                input  [2:0]  boothsel,
                input         signedopsaved,
                output [33:0] y,
                output        cin);

  wire [33:0] yp2, yp1, ym1, ym2, yb;

  assign yp2 = {a[31] & signedopsaved, a, 1'b0};
  assign yp1 = {{2{a[31] & signedopsaved}}, a};
  assign ym1 = ~yp1;
  assign ym2 = ~yp2;

  assign cin = boothsel[1]; // carry for 2's comp if y negated

  mux4 #(34) boothmux(yp1, yp2, ym1, ym2, boothsel[1:0], yb);
  and2 #(34) boothzero(yb, ~{34{boothsel[2]}}, y);
endmodule

