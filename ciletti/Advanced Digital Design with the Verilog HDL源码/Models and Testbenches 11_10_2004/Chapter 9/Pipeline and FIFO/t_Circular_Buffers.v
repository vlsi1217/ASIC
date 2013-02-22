

module t_circular_buffers ();

  parameter 	buff_size = 4;
  parameter 	word_size = 8;
  wire		[word_size-1: 0]	cell_3_1, cell_2_1, cell_1_1, cell_0_1;
  wire		[word_size-1: 0]	cell_3_2, cell_2_2, cell_1_2, cell_0_2;

  reg		[word_size-1: 0] Data_in;
  reg		clock, reset;

Circular_Buffer_1 M1 (cell_3_1, cell_2_1, cell_1_1, cell_0_1, Data_in, clock, reset);
Circular_Buffer_2 M_2 (cell_3_2, cell_2_2, cell_1_2, cell_0_2, Data_in, clock, reset);


  initial #500 $finish;
  initial begin clock = 0; forever #5 clock = ~clock; end
  initial begin reset = 1; #25 reset = 0; end
  // Changed to eliminate race with clock 12/08/2004 #25 reset = 0; end
  initial begin #10 Data_in = 1; forever begin @( negedge clock) Data_in = Data_in + 1;end end

endmodule


