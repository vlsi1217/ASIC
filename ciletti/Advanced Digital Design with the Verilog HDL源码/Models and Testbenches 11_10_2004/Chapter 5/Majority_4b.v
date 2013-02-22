module Majority_4b (Y, A, B, C, D);
  input 	A, B, C, D;
  output	Y;
  reg 	Y;
  always @ (A or B or C or D) begin
    case ({A, B,C, D})
      7, 11, 13, 14, 15:	Y = 1;
      default		Y = 0;
    endcase
  end
endmodule



