module Add_half (sum, c_out, a, b);
  output 		sum, c_out;
  input 		a, b;
  wire 		c_bar;

  xor 	M1 (sum, a, b);  
  nand 	M2 (c_bar, a, b);
  not 	M3 (c_out, c_bar);
endmodule
module t_Add_half();
  wire 		sum, c_out;
  reg 		a, b;
 
Add_half M1 (sum, c_out, a, b);	//UUT
 initial begin				// Time Out
  #100 $finish;
  end

initial begin				// Stimulus patters
#10 a = 0; b = 0;
#10 b = 1; 
#10 a = 1;
#10 b = 0;

end
	endmodule

