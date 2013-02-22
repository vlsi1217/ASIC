module count_ones_SD_0 (bit_count, start, done, data, clk, reset);
// This model differs form the one in the text.  Here, Start is an output.
  parameter 	data_width = 4;
  parameter 	count_width = 3;
  output 		[count_width-1:0] 		bit_count;
  output					start, done;
  input 		[data_width-1:0] 		data;
  input 					clk, reset;
  reg 		[count_width-1:0] 		count, bit_count, index;
  reg 		[data_width-1:0] 		temp;
  reg					done, start;
	

  always      @ (posedge clk) begin: bit_counter
    if (reset) begin count = 0; bit_count = 0; done = 0; start = 0; end
    else begin
      done = 0;
      count = 0;
      bit_count = 0;
      start = 1;
      temp = data;
      for (index = 0; index < data_width; index = index + 1) begin: for_loop
        @ (posedge clk) 		// Synchronize
          if (reset) begin 
            count = 0; 
            bit_count = 0; 
            done = 0; start = 0;
            disable bit_counter; end 
          else begin 
            start = 0;  //done = 0;
            count = count + temp[0];
            temp = temp >> 1;
          end
end
        @ (posedge clk) // Required for synchronization
          if (reset) begin  count = 0; bit_count = 0; done = 0; start = 0;
            disable bit_counter; end 
          else begin 
            bit_count = count; 
            done = 1; 
			 end
 		  end
      //end // for_loop
    end  // bit_counter
  //end  //machine
endmodule

