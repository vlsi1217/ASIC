module Auto_LFSR_ALGO (Y, Clock, Reset);
  parameter 	Length = 8;
  parameter 	initial_state = 8'b1001_0001;
  parameter 	[1: Length] Tap_Coefficient = 8'b1100_1111;
  input 		Clock, Reset;
  output 		[1: Length] Y;
  integer		Cell_ptr;
  reg 		[1: Length] Y;	// 5-10-2004

  always @  (posedge Clock)
    begin
      if (!Reset) Y <= initial_state;		// Arbitrary initial state, 91h
      else begin for (Cell_ptr = 2; Cell_ptr <= Length; Cell_ptr = Cell_ptr +1)
        if (Tap_Coefficient [Length - Cell_ptr + 1] == 1) 			
          Y[Cell_ptr] <= Y[Cell_ptr -1]^ Y [Length];
        else
          Y[Cell_ptr] <= Y[Cell_ptr -1];
          Y[1] <= Y[Length];
      end
    end
endmodule

