module count_ones_SD (bit_count, done, data, start, clk, reset);
  parameter 	data_width = 4;  
  parameter 	count_width = 3;
  output 		[count_width-1:0] bit_count;
  output					done;
  input 		[data_width-1:0] 	data;
  input 					start, clk, reset;
  reg 		[count_width-1:0] count, bit_count, index;
  reg 		[data_width-1:0] 	temp;
  reg						done;
	

  always      @ (posedge clk) begin: bit_counter
    if (reset) begin count = 0; bit_count = 0; done = 0; end
    else if (start) begin
      done = 0;
      count = 0;
      bit_count = 0;
      temp = data;
      for (index = 0; index < data_width; index = index + 1) 
        @ (posedge clk) 		// Synchronize
          if (reset) begin 
            count = 0; 
            bit_count = 0; 
            done = 0;
            disable bit_counter; end 
          else begin 
            count = count + temp[0];
            temp = temp >> 1;
          end

        @ (posedge clk) // Required for final register transfer
          if (reset) begin  count = 0; bit_count = 0; done = 0;
            disable bit_counter; end 
          else begin 
            bit_count = count; 
            done = 1; 
			 end
 		  end
         end  // bit_counter
endmodule

