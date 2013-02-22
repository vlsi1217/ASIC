module barrel_shifter (Data_out, Data_in, load, clock, reset);
  output 	[7: 0] 	Data_out;
  input 		[7: 0] 	Data_in;
  input 			load, clock, reset;
  reg 		[7: 0] 	Data_out;

  always @  (posedge reset or posedge clock)
    begin
      if (reset == 1'b1) 		Data_out <= 8'b0;  
      else if (load == 1'b1) 	Data_out <= Data_in;
      else 			Data_out <= {Data_out[6: 0], Data_out[7]};
    end 
endmodule

