module half_adder(a,b,out,carry);
input a,b;
output out,carry;
assign out=a^b;
assign carry=a&b;
endmodule
