//`timescale 1ns / 1ps
module Add_rca_4 (sum, c_out, a, b, c_in);
  output 	[3: 0] 	sum;
  output 			c_out;
  input 	[3: 0] 	a, b;
  input 			c_in;
  wire 			c_in2, c_in3, c_in4;

  Add_full M1 (sum[0], 	c_in2,	a[0], b[0], c_in);
  Add_full M2 (sum[1], 	c_in3, 	a[1], b[1], c_in2);
  Add_full M3 (sum[2], 	c_in4, 	a[2], b[2], c_in3);
  Add_full M4 (sum[3], 	c_out, 	a[3], b[3], c_in4);
endmodule 

module Add_full (sum, c_out, a, b, c_in);
  output 		sum, c_out;
  input 		a, b, c_in;
  wire 		w1, w2, w3, w4, c_out_bar;

  Add_half 	M1 (w1, w2, a, b);
  Add_half 	M2 (sum, w3, w1, c_in);
  norf201 	M3 (c_out_bar, w2, w3);
  invf101 	M4 (c_out, c_out_bar);
endmodule
 
module Add_half (sum, c_out, a, b);
  output 		sum, c_out;
  input 		a, b;
  wire 		c_out_bar;

  xorf201		M1 (sum, a, b);  
  nanf201		M2 (c_out_bar, a, b);
  invf101 		M3 (c_out, c_out_bar);
endmodule

module t_Add_rca_4 ();
  wire	 [3: 0] 	sum;
  wire 			c_out;
  reg 	[3: 0] 	a, b;
  reg 			c_in;

Add_rca_4 M1 (sum, c_out, a, b, c_in);

initial #100 $finish;
initial begin

#10 a = 0; b = 0; c_in = 0;
#10 a = 15; 
#10 c_in = 1;			// Test of carry chain
#10 a = 0; b = 0;
#10 a = 14;
#10 b  = 1;			// Test of sum chain
#10 a = 15; b = 15; c_in = 0;
#10 a = 15; b = 15; c_in = 1;

end
endmodule
