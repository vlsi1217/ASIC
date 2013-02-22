module priority (Code, valid_data, Data);
  output 		[2: 0] 	Code;
  output 			valid_data;
  input 		[7: 0] 	Data;
  reg 		[2: 0] 	Code;
 
  assign 		valid_data = |Data; // "reduction or" operator

  always @  (Data)
    begin
      if (Data[7]) Code = 7; else
      if (Data[6]) Code = 6; else
      if (Data[5]) Code = 5; else
      if (Data[4]) Code = 4; else
      if (Data[3]) Code = 3; else
      if (Data[2]) Code = 2; else
      if (Data[1]) Code = 1; else
      if (Data[0]) Code = 0; else
                        Code = 3'bx;
    end

/*// Alternative description is given below

always @  (Data)
  casex (Data)
       8'b1xxxxxxx 	: Code = 7;  
       8'b01xxxxxx 	: Code = 6;  
       8'b001xxxxx 	: Code = 5;  
       8'b0001xxxx 	: Code = 4;  
       8'b00001xxx 	: Code = 3;  
       8'b000001xx  : Code = 2;  
       8'b0000001x 	: Code = 1;  
       8'b00000001	: Code = 0;  
       default 	: Code = 3'bx;
  endcase
*/
endmodule

