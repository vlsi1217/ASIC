module TAP_FSM (enableTDO, TMS, TCK);
  output	enableTDO;
  input 	TMS, TCK;
  reg 	enableTDO;

  parameter	S_Reset 	= 0,
S_Run_Idle	= 1,
S_Select_DR 	= 2,
S_Capture_DR 	= 3,
S_Shift_DR 	= 4,
S_Exit1_DR 	= 5,
S_Pause_DR 	= 6,
S_Exit2_DR 	= 7,
S_Update_DR 	= 8,
S_Select_IR 	= 9,
S_Capture_IR	= 10,
S_Shift_IR 	= 11,
S_Exit1_IR 	= 12,
S_Pause_IR 	= 13,
S_Exit2_IR 	= 14,
S_Update_IR 	= 15;

  reg [3:0] state, next_state;

  pullup (TMS);	// Required by IEEE 1149.1a; ensures that an undriven input 

  always @ (negedge TCK) 
    enableTDO <=  ((state == S_Shift_DR) || (state == S_Shift_IR)) ? 1 : 0;  // Registered output enable
  
    always @ (posedge TCK ) state <= next_state;

  always @ (state or TMS) begin
   next_state = state;

    case (state)
      S_Reset:		begin  next_state = TMS ? S_Reset : S_Run_Idle;
			end
      S_Run_Idle:		if (TMS)  next_state = S_Select_DR;
			
      S_Select_DR: 	next_state = TMS ? S_Select_IR: S_Capture_DR;
      S_Capture_DR: 	next_state = TMS ? S_Exit1_DR: S_Shift_DR; 
      S_Shift_DR:		if (TMS) next_state = S_Exit1_DR;
      S_Exit1_DR:		next_state = TMS ? S_Update_DR: S_Pause_DR;
      S_Pause_DR:	if (TMS) next_state = S_Exit2_DR;
      S_Exit2_DR:		next_state = TMS ? S_Update_DR: S_Shift_DR;
      S_Update_DR:	next_state = TMS ? S_Select_DR: S_Run_Idle; 
      S_Select_IR:		next_state = TMS ? S_Reset: S_Capture_IR; 
      S_Capture_IR:	next_state = TMS ? S_Exit1_IR: S_Shift_IR; 
			
      S_Shift_IR:		begin enableTDO = 1; if (TMS) next_state = S_Exit1_IR;
			end
      S_Exit1_IR:		next_state = TMS ? S_Update_IR: S_Pause_IR; 
			
      S_Pause_IR:		if (TMS) next_state = S_Exit2_IR; 
      S_Exit2_IR:		next_state = TMS ? S_Update_IR: S_Shift_IR; 
			
      S_Update_IR:		next_state = TMS ? S_Select_DR: S_Run_Idle;
      default		next_state = S_Reset;
    endcase
  end
endmodule 
