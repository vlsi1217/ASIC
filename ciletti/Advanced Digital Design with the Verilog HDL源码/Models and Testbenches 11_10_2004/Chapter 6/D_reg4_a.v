module D_reg4_a  (Data_out, clock, reset, Data_in);
  output 		[3: 0] 	Data_out;
  input 		[3: 0] 	Data_in;
  input			clock, reset;
  reg 		[3: 0] 	Data_out;

  always @  (posedge clock or posedge reset)		
    begin 
      if (reset == 1'b1) Data_out <= 4'b0;
        else Data_out <= Data_in;
      end
endmodule

