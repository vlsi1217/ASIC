module count_ones_IMP (bit_count, start, done, data, data_ready, clk, reset);
  parameter	word_size	= 4;
  parameter	counter_size	= 3;
  parameter	state_size	= 2;
  output 		[counter_size -1 : 0]	bit_count;
  output					start, done;
  input 		[word_size-1:0] 		data;
  input 					data_ready, clk, reset;

  reg					bit_count;
  reg 	[state_size-1 :0]			state, next_state;
  reg					start, done, clear;
  reg	[word_size-1:0] 			temp;

  always @ (posedge clk) if (reset) 
    begin temp<= 0; bit_count <= 0; done <= 0; start <= 0; end
  else if (data_ready && data && !temp) 
    begin temp <= data; bit_count <= 0; done <= 0; start <= 1; end
  else if (data_ready && (!data) && done) 
    begin bit_count <= 0; done <= 1; end
  else if (temp == 1) 
    begin bit_count <= bit_count + temp[0]; temp <= temp >> 1; done <= 1; end
   else if (temp && !done) 
    begin start <= 0; temp <= temp >> 1; bit_count <= bit_count + temp[0]; end
endmodule

