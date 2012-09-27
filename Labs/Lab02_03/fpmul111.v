//
// This is a simple version of a 64 bit floating point multiplier 
// used in EE287 as a homework problem, and later you will change it to 
// 32 bits and use it as part of the FFT butterfly project
// This is a reduced complexity floating point.  There is no NaN
// overflow, underflow, or infinity values processed.
// The double precision is assumed to cover all possible signal
// processing requirements by the architects.
//
// Inspired by IEEE 754-2008 (Available from the SJSU library to students)
//
// 63  62:52 51:0
// S   Exp   Fract (assumed high order 1)
// 
// Note: all zero exp and fract is a zero 
// 
//
`timescale 1ns/10ps

module fpmul(clk,reset,pushin, a,b,c,pushout,r);
input clk,reset,pushin; 	// the clock, reset, and push in
input [63:0] a,b,c;	// the a,b and c inputs
output [63:0] r;	// the results from this multiply
output pushout;		// indicates we have an answer this cycle

// Everything comes into a Flip flop, and goes out of the design
// You may pipeline more later if required...

reg [63:0] aV,bV,cV;	// the flip flop held values of a and b
reg pushinV,pushinV1;	// the pushin value latched (becomes valid)

reg sA,sB,sC;		// the signs of the a and b inputs
reg [10:0] expA, expB, expC;		// the exponents of each
reg [52:0] fractA, fractB, fractC;	// the fraction of A and B  present
reg zeroA,zeroB,zeroC;	// a zero operand (special case for later)
// result of the multiplication, rounded result, rounding constant
reg [159:0] mres,rres,rconstant;	

reg signres;		// sign of the result
reg [10:0] expres;	// the exponent result
reg [63:0] resout;	// the output value from the always block
reg [63:0] resoutV;	// the latched result

assign r=resoutV;
assign pushout=pushinV1;


// latch the inputs...

always @(posedge(clk) or posedge(reset)) begin
  if(reset) begin
    aV<= #1 0;
    bV<= #1 0;
    cV<= #1 0;
    pushinV<= #1 0;
    pushinV1 <= #1 0;
    resoutV <= #1 0;
  end else begin
    aV <= #1 a;
    bV <= #1 b;
    cV <= #1 c;
    pushinV <= #1 pushin;
    pushinV1 <= #1 pushinV;
    resoutV <= #1 resout;
  end
end
//
// give the fields a name for convience
//
always @(*) begin
  sA = aV[63];
  sB = bV[63];
  sC = cV[63];
  signres=sA^sB^sC;
  expA = aV[62:52];
  expB = bV[62:52];
  expC = cV[62:52];
  fractA = { 1'b1, aV[51:0]};
  fractB = { 1'b1, bV[51:0]};
  fractC = { 1'b1, cV[51:0]};
  zeroA = (aV[62:0]==0)?1:0;
  zeroB = (bV[62:0]==0)?1:0;
  zeroC = (cV[62:0]==0)?1:0;
  mres= fractA*fractB;
  mres= mres*fractC;
  expres = expA+expB+expC-11'd2045;
  rconstant=0;
  if (mres[158]==1) rconstant[105]=1; else if(mres[157]==1'b1) rconstant[104]=1; else rconstant[103]=1;
  rres=mres+rconstant;
  if((zeroA==1) || (zeroB==1) || (zeroC == 1)) begin // sets a zero result to a true 0
    rres = 0;
    expres = 0;
    signres=0;
    resout=64'b0;
  end else begin
    if(rres[158]==1'b1) begin
      expres=expres+1;
      resout={signres,expres,rres[157:106]};
    end else if(rres[157]==1'b0) begin // less than 1/2
      expres=expres-1;
      resout={signres,expres,rres[155:104]};
    end else begin 
      resout={signres,expres,rres[156:105]};
    end
  end
end






endmodule
