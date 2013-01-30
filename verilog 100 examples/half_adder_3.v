module half_adder(a,b,out,carry);
input a,b;
output out,carry;
xor n1(out,a,b);
and n2(carry,a,b);
endmodule