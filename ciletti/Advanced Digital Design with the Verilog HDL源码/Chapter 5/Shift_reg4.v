module Shift_reg4 (Data_out, Data_in, clock, reset);
  output 	Data_out;
  input 		Data_in, clock, reset;
  reg 	[3: 0] 	Data_reg;

  assign 	Data_out = Data_reg[0];

  always @  (negedge reset or posedge clock)		
    begin 
      if (reset == 1'b0)  	Data_reg <= 4'b0;
      else 		Data_reg <= {Data_in, Data_reg[3:1]};
    end
endmodule

