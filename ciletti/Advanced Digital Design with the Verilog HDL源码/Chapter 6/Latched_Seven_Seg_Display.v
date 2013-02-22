module Latched_Seven_Seg_Display 
  (Display_L, Display_R, Blanking, Enable, clock, reset);
  output	[6: 0]	Display_L, Display_R;
  input	 	Blanking, Enable, clock, reset;
  reg		[6: 0]	Display_L, Display_R;
  reg		[3: 0]	count;
  //			      abc_defg
  parameter 	BLANK	= 7'b111_1111;
  parameter	ZERO	= 7'b000_0001;		// h01
  parameter	ONE	= 7'b100_1111;		// h4f
  parameter	TWO	= 7'b001_0010;		// h12
  parameter	THREE	= 7'b000_0110;		// h06
  parameter	FOUR	= 7'b100_1100; 		// h4c
  parameter	FIVE	= 7'b010_0100;		// h24
  parameter	SIX	= 7'b010_0000; 		// h20
  parameter	SEVEN	= 7'b000_1111;		// h0f
  parameter	EIGHT	= 7'b000_0000;		// h00
  parameter	NINE	= 7'b000_0100; 		// h04

  always @ (posedge clock)
    if (reset) count <= 0;
    else if (Enable) count <= count +1;

  always @ (count or Blanking)
    if (Blanking) begin Display_L = BLANK; Display_R = BLANK; end  else 
      case (count)
        0:		begin Display_L = ZERO; Display_R = ZERO; end
        2:		begin Display_L = ZERO; Display_R = TWO; end
        4:		begin Display_L = ZERO; Display_R = FOUR; end
        6:		begin Display_L = ZERO; Display_R = SIX; end
        8:		begin Display_L = ZERO; Display_R = EIGHT; end
        10:		begin Display_L = ONE; Display_R = ZERO; end
        12:		begin Display_L = ONE; Display_R = TWO; end
        14:		begin Display_L = ONE; Display_R = FOUR; end
        //default:	begin Display_L = BLANK; Display_R = BLANK; end
    endcase
		endmodule

