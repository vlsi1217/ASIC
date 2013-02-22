module Add_full_unit_delay (sum, c_out, a, b, c_in);
  output 		sum, c_out;
  input 			a, b, c_in;
  wire 			w1, w2, w3, w4;

  Add_half_unit_delay 		M1 (w1, w2, a, b);
  Add_half_unit_delay		M2 (sum, w3, w1, c_in);
  or	 	#1 	M3 (c_out, w2, w3);
endmodule
 
module Add_half_unit_delay (sum, c_out, a, b);
  output 	sum, c_out;
  input 		a, b;
  wire 		c_out;

  xor 		#1 	M1 (sum, a, b);  
  and 		#1 	M2 (c_out, a, b);
endmodule

module t_Add_full_unit_delay ();
  wire 			sum, c_out;
  reg 			a, b, c_in;

  Add_full_unit_delay M1 (sum, c_out, a, b, c_in);

  initial #160 $finish;
  initial begin
    #10 c_in = 0;
    #10 a = 0; b = 0; 
    #10 a = 0; b = 1;
    #10 a = 1; b = 1;
    #10 a = 1; b = 0;
    #10 c_in = 1;
    #10 a = 0; b = 0; 
    #10 a = 0; b = 1;
    #10 a = 1; b = 1;
    #10 a = 1; b = 0;
  end
endmodule
  

