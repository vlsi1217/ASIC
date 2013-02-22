module up_down_counter (Count, Data_in, load, count_up, counter_on, clk, reset);
  output	[2: 0] 	Count;
  input 			load, count_up, counter_on, clk, reset;
  input	[2: 0] 	Data_in;
  reg		[2: 0] 	Count;

  always @  (posedge reset or posedge clk) 
    if (reset == 1'b1) Count = 3'b0; else 
      if (load == 1'b1) Count = Data_in; else 
        if (counter_on == 1'b1) begin
          if (count_up   == 1'b1) Count = Count +1;
            else Count = Count -1;
      end
endmodule

