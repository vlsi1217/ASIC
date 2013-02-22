module Add_rca_4 (sum, c_out, a, b, c_in);
  output [3: 0] 	sum;
  output 	c_out;
  input 	[3: 0] 	a, b;
  input 		c_in;
  wire 		c_in2, c_in3, c_in4;

  Add_full M1 (sum[0], 	c_in2,	a[0], b[0], c_in);
  Add_full M2 (sum[1], 	c_in3, 	a[1], b[1], c_in2);
  Add_full M3 (sum[2], 	c_in4, 	a[2], b[2], c_in3);
  Add_full M4 (sum[3], 	c_out, 	a[3], b[3], c_in4);
endmodule 

module Add_full (sum, c_out, a, b, c_in);
  output 	sum, c_out;
  input 		a, b, c_in;
  wire 		w1, w2, w3, w4;

  Add_half 		M1 (w1, w2, a, b);
  Add_half 		M2 (sum, w3, w1, c_in);
  or	 	#1 	M3 (c_out, w2, w3);
endmodule
 
module Add_half (sum, c_out, a, b);
  output 	sum, c_out;
  input 		a, b;
  wire 		c_out_bar;

  xor 		#1 	M1 (sum, a, b);  
  and 		#1 	M2 (c_out, a, b);
endmodule


module t_Add_rca_4_Unit_Delay ( );
  wire	[3: 0] 	sum;
  wire 		c_out;
  reg 	[3: 0] 	a, b;
  reg 		c_in;

  Add_rca_4 M1 (sum, c_out, a, b, c_in);		// UUT

  initial begin					// Time Out
    #100 $finish;
  end

  initial begin					// Stimulus patterns
    #5 a = 0; b = 0; c_in = 0;
    #10 b = 15; 					// Default Decimal value
    #10 a = 4'b0001;				// Optional sized value
    #10 b = 0;
  end
endmodule

