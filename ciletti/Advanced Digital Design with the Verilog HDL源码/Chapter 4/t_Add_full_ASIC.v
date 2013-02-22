`timescale 1ns / 1ps

module Add_full_ASIC (sum, c_out, a, b, c_in);
  output 		sum, c_out;
  input 			a, b, c_in;
  wire 			w1, w2, w3, w4, c_out_bar;

  Add_half_ASIC 	M1 (w1, w2, a, b);
  Add_half_ASIC 	M2 (sum, w3, w1, c_in);

  norf201 		M3 (c_out_bar, w2, w3);
  invf101 		M4 (c_out, c_out_bar);
endmodule
 

module Add_half_ASIC (sum, c_out, a, b);
  output 		sum, c_out;
  input 			a, b;
  wire 			c_out_bar;

  xorf201 		M1 (sum, a, b);  
  nanf201 		M2 (c_out_bar, a, b);
  invf101 		M3 (c_out, c_out_bar);
endmodule

module t_Add_full_ASIC ();
  wire 			sum, c_out;
  reg 			a, b, c_in;

  Add_full_ASIC M1 (sum, c_out, a, b, c_in);

  initial #100 $finish;
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
  

