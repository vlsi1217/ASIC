module Up_Down_Implicit1 (count, up_dwn, clock, reset_);
  output	[2: 0] 	count;
  input 	[1: 0] 	up_dwn;
  input 			clock, reset_;

  reg 	[2: 0] 	count;

  always @  (negedge clock or negedge reset_) 
    if (reset_ == 0) 			count <= 3'b0; else
      if (up_dwn == 2'b00 || up_dwn == 2'b11) count <= count; else
        if (up_dwn == 2'b01) 			count <= count + 1; else
          if (up_dwn == 2'b10) 		count <= count -1;

endmodule

