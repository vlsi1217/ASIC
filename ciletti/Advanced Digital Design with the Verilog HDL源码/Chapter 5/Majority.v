module Majority (Y, Data);
  parameter	size = 8;
  parameter	max = 3;		
  parameter	majority = 5;
  input 		[size-1: 0]	Data;
  output				Y;
  reg 				Y;
  reg 		[max-1: 0]	count;
  integer 			k;

  always @ (Data) begin
    count = 0;
    for (k = 0; k < size; k = k + 1) begin
      if (Data[k] == 1) count = count + 1;
    end
    Y = (count >= majority);
  end
endmodule

