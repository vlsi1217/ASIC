module t_ASIC_with_TAP ();				// Testbench
  parameter			size = 4;
  parameter			BSC_Reg_size = 14;
  parameter			IR_Reg_size = 3;  parameter 			N_ASIC_Patterns = 8;
  parameter 			N_TAP_Instructions = 8;
  parameter			Pause_Time = 40;
  parameter			End_of_Test = 1500;
  parameter			time_1 = 350, time_2 = 550;

  wire		[size -1: 0] 	sum;
  wire		[size -1: 0] 	sum_fr_ASIC = M0.BSC_Interface [13: 10];

  wire				c_out;
  wire				c_out_fr_ASIC = M0.BSC_Interface [9];
  reg		[size -1: 0]	a, b;
  reg				c_in;
  wire		[size -1: 0]	a_to_ASIC = M0.BSC_Interface [8: 5];
  wire		[size -1: 0]	b_to_ASIC = M0.BSC_Interface [4: 1];
  wire				c_in_to_ASIC = M0.BSC_Interface [0];

  reg 	TMS, TCK;
  wire 	TDI;
  wire 	TDO;
  reg	load_TDI_Generator;
  reg	Error, strobe;
  integer	pattern_ptr;
  reg	[BSC_Reg_size -1: 0] 	Array_of_ASIC_Test_Patterns [0: N_ASIC_Patterns -1];
  reg	[IR_Reg_size -1: 0] 	Array_of_TAP_Instructions [0: N_TAP_Instructions -1];
  reg	[BSC_Reg_size -1: 0]	Pattern_Register;		// Size to maximum TDR
  reg	enable_bypass_pattern;

  ASIC_with_TAP M0 (sum, c_out, a, b, c_in, TDO, TDI, TMS, TCK);

  TDI_Generator M1(
    .to_TDI (TDI),
    .scan_pattern (Pattern_Register),
    .load (load_TDI_Generator),
    .enable_bypass_pattern (enable_bypass_pattern), 
    .TCK (TCK));
 
  TDO_Monitor M3 (
    .to_TDI (TDI), 
    .from_TDO (TDO), 
    .strobe (strobe),
    .TCK (TCK));

  initial #End_of_Test $finish;

  initial begin TCK = 0; forever #5 TCK = ~TCK; end	 
 
  /*  Summary of  a basic test plan for ASIC_with TAP

  Verify default to bypass instruction
  Verify bypass register action: Scan 10 cycles, with pause before exiting
  Verify pull up action on TMS and TDI
  Reset  to S_Reset after five assertions of TMS
  Boundary scan in, pause, update, return to S_Run_Idle
  Boundary scan in, pause, resume scan in, pause, update, return to S_Run_Idle
  Instruction scan in, pause, update, return to S_Run_Idle
  Instruction scan in, pause, resume scan in, pause, update, return to S_Run_Idle
  */
// TEST PATTERNS 
// External I/O for normal operation

  initial fork
   // {a, b, c_in} = 9'b0;
  {a, b, c_in} = 9'b_1010_0101_0;  // sum = F, c_out = 0, a = A, b = 5, c_in = 0 
  join

/*  Option to force error to test fault detection

  initial begin :Force_Error
  force M0.BSC_Interface [13: 10] = 4'b0;
  end
*/

  initial begin 		// Test sequence: Scan, pause, return to S_Run_Idle
    strobe  = 0;
    Declare_Array_of_TAP_Instructions;
    Declare_Array_of_ASIC_Test_Patterns;
    Wait_to_enter_S_Reset;

// Test for power-up and default to BYPASS instruction (all 1s in IR), with default path 
// through the Bypass Register, with BSC register remaining in wakeup state (all x).
// ASIC test pattern is scanned serially, entering at TDI, passing through the bypass register,
// and exiting at TDO.  The BSC register and the IR are not changed.

     pattern_ptr = 0; 
     Load_ASIC_Test_Pattern;	
     Go_to_S_Run_Idle;
     Go_to_S_Select_DR;
     Go_to_S_Capture_DR; 
     Go_to_S_Shift_DR;
     enable_bypass_pattern = 1;
     Scan_Ten_Cycles; 
     enable_bypass_pattern = 0;
     Go_to_S_Exit1_DR;
     Go_to_S_Pause_DR;
     Pause;
     Go_to_S_Exit2_DR;
     /*
    Go_to_S_Shift_DR;
     Load_ASIC_Test_Pattern;		// option to re-load same pattern and scan again
     enable_bypass_pattern = 1;
     Scan_Ten_Cycles; 
     enable_bypass_pattern = 0;
     Go_to_S_Exit1_DR;
     Go_to_S_Pause_DR;
     Pause;
     Go_to_S_Exit2_DR; 
    */
     Go_to_S_Update_DR;	
     Go_to_S_Run_Idle;
  end

// Test to load instruction register with INTEST instruction

   initial #time_1 begin
    pattern_ptr = 3; 
    strobe = 0;
    Load_TAP_Instruction;	
    Go_to_S_Run_Idle;
    Go_to_S_Select_DR;
    Go_to_S_Select_IR;
    Go_to_S_Capture_IR;			// Capture dummy data (3'b011)
     repeat (IR_Reg_size) Go_to_S_Shift_IR;
    Go_to_S_Exit1_IR;
    Go_to_S_Pause_IR;
    Pause;
    Go_to_S_Exit2_IR;
    Go_to_S_Update_IR;
    Go_to_S_Run_Idle;
  end
  

// Load ASIC test pattern 
  initial #time_2 begin
    pattern_ptr = 0; 
    Load_ASIC_Test_Pattern;	
    Go_to_S_Run_Idle;
    Go_to_S_Select_DR;
    Go_to_S_Capture_DR;
    repeat (BSC_Reg_size) Go_to_S_Shift_DR;
    Go_to_S_Exit1_DR;
    Go_to_S_Pause_DR;
    Pause;
    Go_to_S_Exit2_DR;
     Go_to_S_Update_DR;
     Go_to_S_Run_Idle;

// Capture data and scan out while scanning in another pattern
    pattern_ptr = 2; 
    Load_ASIC_Test_Pattern;	
    Go_to_S_Select_DR;
    Go_to_S_Capture_DR;
    strobe = 1;
    repeat (BSC_Reg_size) Go_to_S_Shift_DR;
 
    Go_to_S_Exit1_DR;

    Go_to_S_Pause_DR;
    Go_to_S_Exit2_DR;
    Go_to_S_Update_DR;
     strobe = 0;
     Go_to_S_Run_Idle;
  end

/************************************** TAP CONTROLLER TASKS *************************************/
  task  Wait_to_enter_S_Reset;
    begin
     @ (negedge TCK) TMS = 1; 
  end
  endtask

  task  Reset_TAP;
    begin
      TMS = 1;
      repeat (5) @ (negedge TCK); 
    end
  endtask

task Pause;			begin #Pause_Time;		end endtask

task  Go_to_S_Reset;		begin @ (negedge TCK) TMS = 1;	end endtask
task  Go_to_S_Run_Idle;		begin @ (negedge TCK) TMS = 0;	end endtask

task  Go_to_S_Select_DR;	begin @ (negedge TCK) TMS = 1;	end endtask
task  Go_to_S_Capture_DR; 	begin @ (negedge TCK) TMS = 0;	end endtask
task  Go_to_S_Shift_DR; 		begin @ (negedge TCK) TMS = 0;	end endtask
task  Go_to_S_Exit1_DR;  	begin @ (negedge TCK) TMS = 1;	end endtask
task  Go_to_S_Pause_DR; 	begin @ (negedge TCK) TMS = 0;	end endtask
task  Go_to_S_Exit2_DR;  	begin @ (negedge TCK) TMS = 1;	end endtask
task  Go_to_S_Update_DR;	begin @ (negedge TCK) TMS = 1; end endtask

task  Go_to_S_Select_IR; 		begin @ (negedge TCK) TMS = 1;	end endtask
task  Go_to_S_Capture_IR;  	begin @ (negedge TCK) TMS = 0;	end endtask
task  Go_to_S_Shift_IR; 		begin @ (negedge TCK) TMS = 0;	end endtask
task  Go_to_S_Exit1_IR;  		begin @ (negedge TCK) TMS = 1;	end endtask
task  Go_to_S_Pause_IR;		begin @ (negedge TCK) TMS = 0;	end endtask
task  Go_to_S_Exit2_IR;  		begin @ (negedge TCK) TMS = 1;	end endtask
task  Go_to_S_Update_IR; 	begin @ (negedge TCK) TMS = 1; end endtask
task Scan_Ten_Cycles;		begin repeat (10)   begin @ (negedge TCK) TMS = 0;
				@ (posedge TCK) TMS = 1; end end endtask

/************************************** ASIC TEST PATTERNS  *************************************/
task Load_ASIC_Test_Pattern;	
  begin
    Pattern_Register = Array_of_ASIC_Test_Patterns [pattern_ptr];
    @ (negedge TCK ) load_TDI_Generator = 1;
    @ (negedge TCK) load_TDI_Generator = 0;
  end
endtask

task Declare_Array_of_ASIC_Test_Patterns;
  begin
  //s3 s2 s1 s0_ c0_a3 a2 a1 a0_b3 b2 b1 b0_c_in;

  Array_of_ASIC_Test_Patterns [0] = 14'b0100_1_1010_1010_0; 
  Array_of_ASIC_Test_Patterns [1] = 14'b0000_0_0000_0000_0; 
  Array_of_ASIC_Test_Patterns [2] = 14'b1111_1_1111_1111_1;  
  Array_of_ASIC_Test_Patterns [3] = 14'b0100_1_0101_0101_0;
end endtask

/************************************** INSTRUCTION PATTERNS *************************************/
  parameter	BYPASS		= 3'b111;	// pattern_ptr = 0
  parameter	EXTEST			= 3'b001;	// pattern_ptr = 1
  parameter	SAMPLE_PRELOAD	= 3'b010;	// pattern_ptr = 2
  parameter	INTEST			= 3'b011;	// pattern_ptr = 3
  parameter	RUNBIST		= 4'b100;	// pattern_ptr = 4
  parameter	IDCODE			= 5'b101;	// pattern_ptr = 5

task Load_TAP_Instruction;	
  begin
    Pattern_Register = Array_of_TAP_Instructions [pattern_ptr];
    @ (negedge TCK ) load_TDI_Generator = 1;
    @ (negedge TCK) load_TDI_Generator = 0;
  end
endtask

task Declare_Array_of_TAP_Instructions;
  begin
    Array_of_TAP_Instructions [0] = BYPASS;
    Array_of_TAP_Instructions [1] = EXTEST;
    Array_of_TAP_Instructions [2] = SAMPLE_PRELOAD;
    Array_of_TAP_Instructions [3] = INTEST;
    Array_of_TAP_Instructions [4] = RUNBIST;
    Array_of_TAP_Instructions [5] = IDCODE;
  end
  endtask  
endmodule



