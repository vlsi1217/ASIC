module count_ones_d (bit_count, data, clk, reset);
  parameter 				data_width = 4;
  parameter 				count_width = 3;
  output 		[count_width-1:0] 		bit_count;
  input 		[data_width-1:0] 		data;
  input 					clk, reset;
  reg 		[count_width-1:0] 		count, bit_count;
  reg 		[data_width-1:0] 		temp;

  always @ (posedge clk)
    if (reset) begin count = 0; bit_count = 0; end
    else begin: bit_counter
      count = 0;
      temp = data;
      while (temp)
        @  (posedge clk) 
          if (reset) begin
            count = 2'b0;
            disable bit_counter; end 
          else begin
            count = count + temp[0];    
            temp = temp >> 1;
          end
      @  (posedge clk);
        if (reset) begin
          count = 0;
          disable bit_counter; end
        else bit_count = count;
  end
endmodule

