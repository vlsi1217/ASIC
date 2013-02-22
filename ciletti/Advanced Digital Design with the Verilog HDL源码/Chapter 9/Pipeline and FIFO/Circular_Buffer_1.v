module Circular_Buffer_1 (cell_3, cell_2, cell_1, cell_0, Data_in, clock, reset);
  parameter 	buff_size = 4;
  parameter 	word_size = 8;
  output		[word_size-1: 0]	cell_3, cell_2, cell_1, cell_0;
  input		[word_size-1: 0] Data_in;
  input		clock, reset;
  reg			[word_size-1: 0] Buff_Array [buff_size-1: 0];
  assign		cell_3 = Buff_Array[3], cell_2 = Buff_Array[2];
  assign		cell_1 = Buff_Array[1], cell_0 = Buff_Array[0];
  integer 		k;

  always @ (posedge clock) begin
    if (reset == 1) for (k = 0; k <= buff_size-1; k = k+1)
      Buff_Array[k] <= 0;
    else for (k = 1; k <= buff_size-1; k = k+1) begin
      Buff_Array[k] <= Buff_Array[k-1];
    end
      Buff_Array[0] <= Data_in;
    end
endmodule



