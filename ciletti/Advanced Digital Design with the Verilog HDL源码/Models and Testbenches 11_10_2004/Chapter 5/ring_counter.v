module ring_counter (count, enable, clock, reset);
  output 		[7: 0] 	count;
  input 			enable, reset, clock;
  reg 		[7: 0] 	count;

  always @  (posedge reset or posedge clock)
    if (reset == 1'b1) 	count <= 8'b0000_0001; else 
      if (enable == 1'b1) 	count <= {count[6: 0], count[7]};	// Concatenation operator
endmodule

