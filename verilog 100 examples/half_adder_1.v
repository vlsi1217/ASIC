module half_adder(a,b,out,carry);
input a,b;
output out,carry;
assign {carry,out}=a+b;
endmodule