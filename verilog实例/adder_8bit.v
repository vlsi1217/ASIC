module adder_8bit_1(a,b,cin,out,carry);
input     [7:0]  a,   b;
input            cin;
output    [7:0]  out;
output           carry;
reg        [7:0]  out;
reg               carry;    
always@(a or b or cin)
 {carry,out}=a+b+cin;

endmodule
