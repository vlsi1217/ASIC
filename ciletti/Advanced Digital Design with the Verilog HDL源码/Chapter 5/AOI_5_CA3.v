module AOI_5 _CA2 (y_out, x_in1, x_in2, x_in3, x_in4, x_in5, enable);
  // md ciletti
  input 	x_in1, x_in2, x_in3, x_in4, x_in5;
  output	y_out;
  wire #1 y1 = x_in1 & x_in2;
  wire #1 y2 = x_in3 & x_in4;
  wire #1 y_out = ~(y1 | y2); 
endmodule


