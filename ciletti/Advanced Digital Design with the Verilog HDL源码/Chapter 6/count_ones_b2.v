module count_ones_b2 (bit_count, data, clk, reset);
  parameter 				data_width = 4;
  parameter 				count_width = 3;
  output 		[count_width-1: 0] 	bit_count;
  input 		[data_width-1: 0] 		data;
  input 					clk, reset;
  reg 		[count_width-1: 0] 	count, bit_count;
  reg 		[data_width-1: 0] 		temp;
  integer 				index;

  always begin: machine
    for (index = 0; index <= data_width; index = index +1)   begin
      @ (posedge clk)
        if (reset) begin bit_count = 0; disable machine; end
        else if (index == 0) begin count = 0; bit_count = 0; temp = data; end
        else if (index < data_width) begin count = count + temp[0]; temp = temp >> 1; end 
        else bit_count = count + temp[0]; 
      end
  end // machine
endmodule

