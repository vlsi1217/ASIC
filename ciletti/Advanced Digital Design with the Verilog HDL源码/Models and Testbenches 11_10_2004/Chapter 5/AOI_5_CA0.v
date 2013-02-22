module AOI_5 _CA0 (y_out, x_in1, x_in2, x_in3, x_in4, x_in5);
  // md ciletti
  input 	x_in1, x_in2, x_in3, x_in4, x_in5;
  output	y_out;

  assign y_out = ~((x_in1 & x_in2) | (x_in3 & x_in4 & x_in5));
	 
endmodule


