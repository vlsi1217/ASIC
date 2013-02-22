module Auto_LFSR_Param (Y, Clock, Reset);
  parameter 		Length = 8;
  parameter 		initial_state = 8'b1001_0001;	// Arbitrary initial state
  parameter [1: Length] 	Tap_Coefficient = 8'b1100_1111; 

  input 			Clock, Reset;
  output 	[1: Length] 	Y;
  reg	[1: Length] 	Y;
  integer			k;

  always @  (posedge Clock)
    if (!Reset) Y <= initial_state;	 
      else begin
        for (k = 2; k <= Length; k = k + 1)
          Y[k] <= Tap_Coefficient[Length-k+1] ? Y[k-1] ^ Y[Length] : Y[k-1];	 
          Y[1] <= Y[Length];
      end
 endmodule

