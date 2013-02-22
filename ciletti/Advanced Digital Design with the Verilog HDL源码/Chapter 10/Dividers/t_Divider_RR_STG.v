module test_Divider_RR_STG ();
  parameter 			L_divn = 8;
  parameter 			L_divr = 4;
  parameter 			word_1_max = 255;
  parameter 			word_1_min = 1;
  parameter 			word_2_max = 15;
  parameter 			word_2_min = 1;
  parameter 			max_time = 850000;
  parameter 			half_cycle = 10;
  parameter 			start_duration = 20;
  parameter 			start_offset = 30;
  parameter 			delay_for_exhaustive_patterns = 490;
  parameter 			reset_offset = 50;
  parameter 			reset_toggle = 5;
  parameter 			reset_duration = 20;
  parameter 			word_2_delay = 20;
  wire			[L_divn -1: 0] 	quotient;
  wire 			[L_divr-1:0] 	remainder;
  wire 			Ready, Div_zero;
  integer 			word1;		// dividend
  integer 			word2;		// divisor
  reg 			Start, clock, reset;
  reg 			[L_divn-1: 0] 	expected_value;
  reg 			[L_divr-1:0] 	expected_remainder;		 
  wire 			quotient_error, rem_error;
  integer 			k, m;

  // probes
  wire 	[L_divr-1:0] 	Left_bits = M1.dividend[L_divn-1: L_divn -L_divr];
  wire	[L_divr: 0]	difference = M1.comparison;
  wire	[L_divr: 0]	recover = M1.L_divr - M1.num_shift_divisor +1 ;

  Divider_RR_STG M1 (quotient, remainder, Ready, Error, word1, word2, Start, clock, reset);

  initial #max_time $finish;
  initial begin clock = 0; forever #half_cycle clock = ~clock; end

  initial begin expected_value = 0; expected_remainder = 0;
    forever @ (negedge Ready)  begin    // Form expected values
      #2 if (word2 != 0) begin expected_value = word1 / word2; expected_remainder = word1 % word2; end
    end
  end
    

  assign quotient_error = (!reset && Ready) ? |(expected_value ^ quotient): 0;
  assign rem_error = (!reset && Ready) ? |(expected_remainder ^ remainder): 0;

  initial begin	// Test for divide by zero detection
    #2 reset = 1;
    #15 reset = 0; Start = 0;
    #10 Start = 1; #5 Start = 0;		
  end

  initial begin 	// Test for recovery from error state on reset and running reset
    #reset_offset reset = 1; #reset_toggle Start = 1; #reset_toggle reset = 0;
    word1 = 0; 
    word2 = 1; 
    while (word2 <= word_2_max) #20 word2 = word2 +1;
     #start_duration Start = 0; 
  end		 
  initial begin 	// Exhaustive patterns
    #delay_for_exhaustive_patterns  
    word1 = word_1_min; while (word1 <= word_1_max) begin			
    word2 = 1; while (word2 <= 15) begin
    #0 Start = 0; 
    #start_offset Start = 1;
    #start_duration Start = 0; 
    @ (posedge Ready) #0;
    word2 = word2 + 1; end  	// divisor pattern
    word1 = word1 + 1; end 		//  dividend pattern
  end 		 
endmodule
