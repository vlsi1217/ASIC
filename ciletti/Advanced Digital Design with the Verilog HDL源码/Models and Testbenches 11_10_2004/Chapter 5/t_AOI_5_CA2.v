module AOI_5_CA2 (y_out, x_in1, x_in2, x_in3, x_in4, x_in5, enable);
  input 		x_in1, x_in2, x_in3, x_in4, x_in5, enable;
  output	y_out;

  wire y_out = enable ? ~((x_in1 & x_in2) | (x_in3 & x_in4 & x_in5)) : 1'bz;
	 
endmodule

