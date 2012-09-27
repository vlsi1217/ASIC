// This module calculates the positive circle coordinate Y given X
// with a radius of R
// It is not very well written, but this provides students with
// an opportunity to improve the design :-)
//
// Equation is that of a circle X^2 + Y^2 = R^2
// module calculates Y=sqrt(R^2-X^2)
// It performs no rounding...
// X and Y are both positive. (Only works in quadrant 1)
// 
`timescale 1ns/10ps


module circ(clk, reset, pushin, Xin, Rin, pushout, Yout);
input clk,reset,pushin;
input [23:0] Xin,Rin;
output pushout;
output [23:0] Yout;

reg [23:0] Xl,Rl;
reg V1;

reg [47:0] X2,R2,diff,Diff;
reg V2;
reg V3;
reg [24:0] res;
reg [24:0] rv;


always @(negedge(clk) or posedge(reset)) begin
  if(reset) begin
    V1<=0;
    Xl<=0;
    Rl<=0;
  end else begin
    V1<= #1 pushin;
    Xl<= #1 Xin;
    Rl<= #1 Rin;
  end
end

always @(negedge(clk) or posedge(reset)) begin
  if(reset) begin
    V2 <= 0;
    X2 <= 0;
    R2 <= 0;

  end else begin
    V2 <= #1 V1;
    X2 <= #1 Xl*Xl;
    R2 <= #1 Rl*Rl;
  end

end

always @(negedge(clk) or posedge(reset)) begin
 if(reset) begin
  V3 <= 0;
  diff <= 0;
 end else begin
  V3 <= #1 V2;
  Diff <= #1 R2-X2;
 end

end

integer ix;
always @(*) begin
 res=0;
 rv=0;
 diff=Diff;
 for(ix=0; ix < 24; ix=ix+1) begin 
   rv = { rv[22:0], diff[47:46] };
   diff={ diff[45:0],2'b0};
   if( { res[22:0],2'b1 } <= rv ) begin
     rv=rv - { res[22:0],2'b1 };
     res = { res[23:0],1'b1 };
   end else res= { res[23:0],1'b0 };
 end
end

assign pushout=V3;
assign Yout = res[23:0];

endmodule
