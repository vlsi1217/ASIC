module Instruction_Decoder (mode, select_BR, shift_BR, clock_BR, shift_BSC_Reg, clock_BSC_Reg, update_BSC_Reg, instruction, shiftDR, clockDR, updateDR);
  parameter 	IR_size 			= 3;
  output					mode, select_BR, shift_BR, clock_BR;
  output					shift_BSC_Reg, clock_BSC_Reg, update_BSC_Reg;
  input					shiftDR, clockDR, updateDR;
  input		[IR_size -1: 0]		instruction;
  parameter	BYPASS		= 3'b111;	// Required by 1149.1a
  parameter	EXTEST			= 3'b000;	// Required by 1149.1a
  parameter	SAMPLE_PRELOAD	= 3'b010;
  parameter	INTEST			= 3'b011;
  parameter	RUNBIST		= 3'b100;
  parameter	IDCODE			= 3'b101;

  reg		mode, select_BR, clock_BR, clock_BSC_Reg, update_BSC_Reg;
 
  assign 	shift_BR = shiftDR;
  assign		shift_BSC_Reg = shiftDR;

  always @ (instruction or clockDR or updateDR) begin
    mode = 0; select_BR = 0;		// default is test-data register
    clock_BR = 1; clock_BSC_Reg = 1;
    update_BSC_Reg = 0;

    case (instruction)
      EXTEST:		begin mode = 1; clock_BSC_Reg = clockDR; update_BSC_Reg = updateDR; end	
      INTEST:		begin mode = 1; clock_BSC_Reg = clockDR; update_BSC_Reg = updateDR; end	
      SAMPLE_PRELOAD:	begin  clock_BSC_Reg = clockDR; update_BSC_Reg = updateDR; end
      RUNBIST:		begin  end		
      IDCODE:		begin select_BR = 1; clock_BR = clockDR;  end 
      BYPASS:		begin select_BR = 1; clock_BR = clockDR; end	 	// 1 selects bypass reg
      default:		begin select_BR = 1; end	 				// 1 selects bypass reg

    endcase	
  end	
endmodule
