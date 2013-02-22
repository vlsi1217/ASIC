module count_ones_a (bit_count, data, clk, reset);
  parameter 				data_width = 4;
  parameter 				count_width = 3;
  output 		[count_width-1:0] 		bit_count;
  input 		[data_width-1:0] 		data;
  input 					clk, reset;
  reg 		[count_width-1:0] 		count, bit_count, index;
  reg 		[data_width-1:0] 		temp;
	
  always @ (posedge clk)
    if (reset) begin count = 0; bit_count = 0; end
    else begin
      count = 0;
      bit_count = 0;
      temp = data;
      for (index = 0; index < data_width; index = index + 1) begin
        count = count + temp[0];
        temp = temp >> 1;
      end
      bit_count = count; 
    end
endmodule

