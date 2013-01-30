`include "half_adder_1.v"
module full_adder(a,b,cin,out,carry);
input a,b,cin;
output carry,out;

half_adder m1 (a,b,out1,carry1);
half_adder m2 (cin,out1,out,carry2);
or         m3 (carry,carry1,carry2);

endmodule
