module TAP_Controller 
// Revise 5-11-2004
  (reset_bar, selectIR, shiftIR, clockIR, updateIR, shiftDR, 
    clockDR, updateDR, enableTDO, TMS, TCK);
 
  output	reset_bar, selectIR, shiftIR, clockIR, updateIR;
  output 	shiftDR, clockDR, updateDR, enableTDO;
  input 	TMS, TCK;
  reg 	reset_bar, selectIR, shiftIR, shiftDR, enableTDO;
  wire	clockIR, updateIR, clockDR, updateDR;
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

  reg [3:0] 	state, next_state;

 // pullup (TMS);	// Required by IEEE 1149.1a; ensures that an undriven input 
  // pullup (TDI);	// produces a response identical to the application of a logic 1."

  always @ (negedge TCK) reset_bar <= (state == S_Reset) ? 0 : 1; // Registered active low 
   
  always @ (negedge TCK) begin
    shiftDR <= (state == S_Shift_DR) ? 1 : 0; 		// Registered select for scan mode
    shiftIR <= (state == S_Shift_IR) ? 1: 0;
// Registered output enable
    enableTDO <=  ((state == S_Shift_DR) || (state == S_Shift_IR)) ? 1 : 0;  
  end

  //  Gated clocks for capture registers 
  assign clockDR = !(((state == S_Capture_DR) || (state == S_Shift_DR)) && (TCK == 0));
  assign clockIR =   !(((state == S_Capture_IR) || (state == S_Shift_IR)) && (TCK == 0));
 
 // Gated clocks for output registers
  assign updateDR = (state == S_Update_DR)  && (TCK == 0);
  assign updateIR =   (state == S_Update_IR)  && (TCK == 0);
 
  always @ (posedge TCK ) state <= next_state;

  always @ (state or TMS) begin
    selectIR = 0;
    next_state = state;

    case (state)
      S_Reset:		begin 
			  selectIR = 1; 
			  if (TMS == 0) next_state = S_Run_Idle;
			end
      S_Run_Idle:		begin selectIR = 1; if (TMS)  next_state = S_Select_DR; end
      S_Select_DR: 	next_state = TMS ? S_Select_IR: S_Capture_DR;
      S_Capture_DR: 	begin next_state = TMS ? S_Exit1_DR: S_Shift_DR; end
      S_Shift_DR:		if (TMS) next_state = S_Exit1_DR;
      S_Exit1_DR:		next_state = TMS ? S_Update_DR: S_Pause_DR;
      S_Pause_DR:	if (TMS) next_state = S_Exit2_DR;
      S_Exit2_DR:		next_state = TMS ? S_Update_DR: S_Shift_DR;
      S_Update_DR:	begin next_state = TMS ? S_Select_DR: S_Run_Idle; end
      S_Select_IR:		begin 
			  // selectIR = 1;  // Removed 5-10-2004
			  next_state = TMS ? S_Reset: S_Capture_IR; 
			end
      S_Capture_IR:	begin 
			  selectIR = 1;
			  next_state = TMS ? S_Exit1_IR: S_Shift_IR; 
			end
      S_Shift_IR:		begin selectIR = 1; if (TMS) next_state = S_Exit1_IR;	end
      S_Exit1_IR:		begin 
			  selectIR = 1; 
			  next_state = TMS ? S_Update_IR: S_Pause_IR; 
			end
      S_Pause_IR:		begin selectIR = 1; if (TMS) next_state = S_Exit2_IR; end
      S_Exit2_IR:		begin 
			  selectIR = 1; 
			  next_state = TMS ? S_Update_IR: S_Shift_IR; 
			end
      S_Update_IR:		begin 
			 selectIR = 1; 
  			 //next_state = TMS ? S_Select_IR: S_Run_Idle; //5-10- 2004
  			 next_state = TMS ? S_Select_DR: S_Run_Idle; //5-10- 2004


end
      default		next_state = S_Reset;
    endcase
  end
endmodule

