module decoder (Data, Code);
  output 		[7: 0] Data;
  input 		[2: 0] Code;
  reg 		[7: 0] Data;

  always @  (Code)
    begin
      if (Code == 0) Data = 8'b00000001; else
      if (Code == 1) Data = 8'b00000010; else
      if (Code == 2) Data = 8'b00000100; else
      if (Code == 3) Data = 8'b00001000; else
      if (Code == 4) Data = 8'b00010000; else
      if (Code == 5) Data = 8'b00100000; else
      if (Code == 6) Data = 8'b01000000; else
      if (Code == 7) Data = 8'b10000000; else
                             Data = 8'bx;
    end
/* Alternative description is given below
always @  (Code)
  case (Code)
    0		: Data = 8'b00000001;  
    1		: Data = 8'b00000010;  
    2		: Data = 8'b00000100;  
    3		: Data = 8'b00001000;  
    4		: Data = 8'b00010000;  
    5		: Data = 8'b00100000;  
    6		: Data = 8'b01000000;  
    7		: Data = 8'b10000000;  
    default	: Data = 8'bx;
  endcase
*/
endmodule

