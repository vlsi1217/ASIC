primitive AOI_UDP (y, x_in1, x_in2, x_in3, x_in4, x_in5);
  output 	y;
  input	x_in1, x_in2, x_in3, x_in4, x_in5;
  
table
// x1 x2 x3 x4 x5
0 0 0 0 0 : 1;
0 0 0 0 1 : 1;
0 0 0 1 0 : 1;
0 0 0 1 1 : 1;
0 0 1 0 0 : 1;
0 0 1 0 1 : 1;
0 0 1 1 0 : 1;
0 0 1 1 1 : 0;
0 1 0 0 0 : 1;
0 1 0 0 1 : 1;
0 1 0 1 0 : 1;
0 1 0 1 1 : 1;
0 1 1 0 0 : 1;
0 1 1 0 1 : 1;
0 1 1 1 0 : 1;
0 1 1 1 1 : 0;
 
1 0 0 0 0 : 1;
1 0 0 0 1 : 1;
1 0 0 1 0 : 1;
1 0 0 1 1 : 1;
1 0 1 0 0 : 1;
1 0 1 0 1 : 1;
1 0 1 1 0 : 1;
1 0 1 1 1 : 0;
1 1 0 0 0 : 0;
1 1 0 0 1 : 0;
1 1 0 1 0 : 0;
1 1 0 1 1 : 0;
1 1 1 0 0 : 0; 
1 1 1 0 1 : 0;
1 1 1 1 0 : 0;
1 1 1 1 1 : 0;
endtable
endprimitive

module AOI_UDP_mod (y, x_in1, x_in2, x_in3, x_in4, x_in5);

output y;
input	x_in1, x_in2, x_in3, x_in4, x_in5;
 
AOI_UDP (y, x_in1, x_in2, x_in3, x_in4, x_in5);
endmodule


module t_AOI_UDP_mod ();
reg x_in1, x_in2, x_in3, x_in4, x_in5;
integer x_in;
wire y, error;
assign error = (y !== ~((x_in1 & x_in2) | (x_in3 & x_in4 & x_in5)));
AOI_UDP_mod M1 (y, x_in1, x_in2, x_in3, x_in4, x_in5);

initial #500 $finish;
initial 
for (x_in = 0; x_in <=31; x_in = x_in +1)
#10 {x_in1, x_in2, x_in3, x_in4, x_in5} = x_in;

endmodule
