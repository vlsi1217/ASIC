module encoder8x3(in,out);
input  [7:0]  in;
output [2:0]  out;
reg    [2:0]  out;
always @(in)
 case(in)
  8'b0000_0001:out=0;
  8'b0000_0010:out=1;
  8'b0000_0100:out=2;
  8'b0000_1000:out=3;
  8'b0001_0000:out=4;
  8'b0010_0000:out=5;
  8'b0100_0000:out=6;
  8'b1000_0000:out=7;
  endcase
  
 endmodule
  
  