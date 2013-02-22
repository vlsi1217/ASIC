module decimator_2 (data_out, data_in, hold, clock, reset);
  parameter word_length = 8;
  output 	[word_length-1:0]		data_out;
  input	[word_length-1:0]		data_in;
  input 				hold;		// Active high
  input				clock;		// Positive edge  
  input				reset;		// Active high
  reg				data_out;
  always @ (posedge clock)
    if (reset) data_out <= 0;
    else if (hold) data_out <= data_out >> 1;
    else data_out <= data_in;
endmodule

