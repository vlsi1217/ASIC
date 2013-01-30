module encoder8x3(in,out);
input  [7:0] in;
output [2:0] out;
reg    [2:0] out;
reg    [2:0] i;
always @(in)
begin
  for(i=0;i<8;i=i+1)
   if(in[i])
     out=i;
end

endmodule
     
 
