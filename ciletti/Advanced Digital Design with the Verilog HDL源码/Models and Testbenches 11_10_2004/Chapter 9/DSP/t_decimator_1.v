module t_decimator_1 ();
  parameter word_length = 8;
  wire 	[word_length-1:0]		data_out;
  reg		[word_length-1:0]		data_in;
  reg 				hold;			// Active high
  reg				clock, clock_data;	// Positive edge  
  reg				reset;			// Active high

 decimator_1 M1 (data_out, data_in, hold, clock, reset);

  initial #500 $finish;
  initial begin reset = 1;  #10 reset = 0; end
  initial begin clock_data = 0;   forever #1 clock_data = ~clock_data; end

  initial begin #1 clock = 0;   forever #16 clock = ~clock; end

  initial fork
    #10 hold =1; 
    #30 hold = 0; 
    #90 hold = 1; 
    #150 hold = 0;
  join
  always begin
    data_in = 0;

forever @ (negedge clock_data) data_in = data_in + 1;
end
 
/*
initial fork
    #10 data_in = 8;
    #30 data_in = 47;
    #60 data_in = 8'hff;
    #90 data_in = 8'haa;
    #120 data_in = 8'h55;
join
*/
endmodule

