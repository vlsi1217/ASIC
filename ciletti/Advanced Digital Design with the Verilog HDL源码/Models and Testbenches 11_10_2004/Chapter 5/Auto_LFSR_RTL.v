module Auto_LFSR_RTL (Y, Clock, Reset);
  parameter 		Length = 8;
  parameter 		initial_state = 8'b1001_0001;	// 91h
  parameter [1: Length] 	Tap_Coefficient = 8'b1100_1111; 

  input 			Clock, Reset;
  output 	[1: Length] 	Y;
  reg	[1: Length] 	Y;

  always @  (posedge Clock)
    if (!Reset) Y <= initial_state;	// Active-low reset to initial state
      else begin
        Y[1] <= Y[8];
        Y[2] <= Tap_Coefficient[7] ? Y[1] ^ Y[8] : Y[1];
        Y[3] <= Tap_Coefficient[6] ? Y[2] ^ Y[8] : Y[2];
        Y[4] <= Tap_Coefficient[5] ? Y[3] ^ Y[8] : Y[3];
        Y[5] <= Tap_Coefficient[4] ? Y[4] ^ Y[8] : Y[4];
        Y[6] <= Tap_Coefficient[3] ? Y[5] ^ Y[8] : Y[5];
        Y[7] <= Tap_Coefficient[2] ? Y[6] ^ Y[8] : Y[6];
        Y[8] <= Tap_Coefficient[1] ? Y[7] ^ Y[8] : Y[7];
        
    end
 endmodule

