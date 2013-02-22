module Divider_STG_1 (quotient, remainder, Ready, Error, word1, word2, Start, clock, reset);
  parameter 	L_divn = 8;
  parameter 	L_divr = 4;			// Choose L_divr <= L_divn
  parameter	S_idle = 0, S_Adivr = 1, S_Adivn = 2, S_div = 3, S_Err = 4;
  parameter 	L_state = 3, L_cnt = 4, Max_cnt = L_divn - L_divr;
  output 	[L_divn -1: 0] 	quotient;
  output 	[L_divn -1: 0]	remainder;
  output 				Ready, Error;
  input 	[L_divn -1: 0] 	word1;				// Datapath for dividend
  input 	[L_divr -1: 0] 	word2;				// Datapath for divisor
  input 				Start, clock, reset;
  reg 	[L_state -1: 0] 	state, next_state;
  reg 				Load_words, Subtract, Shift_dividend, Shift_divisor;
  reg		[L_divn -1: 0]	 quotient;
  reg 	[L_divn: 0] 	dividend;			// Extended dividend
  reg	[L_divr -1: 0]	divisor; 
  reg	[L_cnt -1: 0]	num_shift_dividend, num_shift_divisor;
  reg	[L_divr: 0]	comparison;
  wire	MSB_divr = divisor[L_divr -1];
  wire 	Ready =((state == S_idle) && !reset) ;
  wire	Error = (state == S_Err);
  wire	Max = (num_shift_dividend == Max_cnt + num_shift_divisor );
  wire	sign_bit = comparison[L_divr];

  always @ (state or dividend or divisor or MSB_divr)			// subtract divisor from dividend
    case (state)
      S_Adivr:	if (MSB_divr == 0) comparison 
		= dividend[L_divn: L_divn - L_divr] + {1'b1, ~(divisor << 1)} + 1'b1;
	else comparison = dividend[L_divn: L_divn - L_divr] + {1'b1, ~divisor[L_divr -1:  0]} + 1'b1; 
      default:	comparison = dividend[L_divn: L_divn - L_divr] + {1'b1, ~divisor[L_divr -1:  0]} + 1'b1;
  endcase


   	// Shift the remainder to compensate for alignment shifts 
  assign 	remainder = (dividend[L_divn -1:  L_divn -L_divr]  ) >> num_shift_divisor;

  always @ (posedge clock or posedge reset)  		// State Transitions
    if (reset) state <= S_idle; else state <= next_state; 

  // Next state and control logic

  always 
    @ (state or word1 or word2 or Start or comparison or sign_bit or Max )  begin
    Load_words = 0; Shift_dividend = 0; Shift_divisor  = 0; Subtract = 0; 
    case (state)
      S_idle: 	case (Start) 		  
  	  0:   		next_state = S_idle; 
	  1:		if (word2 == 0) next_state = S_Err; 
			else if (word1) begin next_state = S_Adivr; Load_words = 1; end
			else next_state = S_idle;
	endcase 

      S_Adivr:	case (MSB_divr)
	  0:		if (sign_bit == 0) begin
		  	  next_state = S_Adivr; Shift_divisor = 1;		// can shift divisor
			end
			else if (sign_bit == 1)  begin
		  	  next_state = S_Adivn;				// cannot shift divisor
			end	
	  1:		next_state = S_div; 
	endcase
		
      S_Adivn:	case ({Max, sign_bit})
	  2'b00: 	next_state = S_div; 
	  2'b01: 	begin next_state = S_Adivn; Shift_dividend  = 1; end

	  2'b10: 	begin  next_state = S_idle; Subtract = 1; end
	  2'b11: 	next_state = S_idle;
	endcase
		  		
       S_div:	case ({Max, sign_bit}) 
	  2'b00:	begin next_state = S_div; Subtract = 1; end
	  2'b01:	next_state = S_Adivn;				
	  2'b10:	begin next_state = S_div; Subtract = 1; end
	  2'b11:	begin next_state = S_div; Shift_dividend = 1; end
	endcase
      default:	next_state = S_Err;
    endcase
  end

always @ (posedge clock or posedge reset) begin	// Register/Datapath operations	
    if (reset) begin 
      divisor <= 0; dividend <= 0; quotient <= 0; num_shift_dividend <= 0; num_shift_divisor <= 0;
    end

    else if (Load_words == 1)  
      begin 
        dividend <= word1; 
        divisor <= word2; 
        quotient <= 0; 
        num_shift_dividend <= 0; 
        num_shift_divisor <= 0; 
    end

    else if (Shift_divisor) begin 
      divisor <= divisor << 1; 
      num_shift_divisor <= num_shift_divisor + 1; 
    end

    else if (Shift_dividend) begin
      dividend <= dividend << 1;   
      quotient <= quotient << 1;
      num_shift_dividend <= num_shift_dividend +1;
    end

    else if (Subtract) 
      begin 
        dividend [L_divn: L_divn -L_divr] <= comparison; 
        quotient[0] <= 1; 
      end
    end
endmodule

module test_Divider_STG_1 ();
  parameter L_divn = 8;
  parameter L_divr = 4;
  parameter word_1_max = 255;
  parameter word_1_min = 1;
  parameter word_2_max = 15;
  parameter word_2_min = 1;
  parameter max_time = 850000;
  parameter half_cycle = 10;
  parameter start_duration = 20;
  parameter start_offset = 30;
  parameter delay_for_exhaustive_patterns = 490;
  parameter reset_offset = 50;
  parameter reset_toggle = 5;
  parameter reset_duration = 20;
  parameter word_2_delay = 20;
  wire [L_divn -1: 0] quotient;
  wire [L_divn-1:0] remainder;
  wire Ready, Div_zero;
  integer word1;		// dividend
  integer word2;		// divisor
  reg Start, clock, reset;
  reg [L_divn-1: 0] expected_value;
  reg [L_divn-1:0] expected_remainder;		 
  wire quotient_error, rem_error;
  integer k, m;

  // probes
  wire 	[L_divr-1:0] 	Left_bits = M1.dividend[L_divn-1: L_divn -L_divr];
   
  Divider_STG_1 M1 (quotient, remainder, Ready, Error, word1, word2, Start, clock, reset);

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
    word1 = word1 + 1; end 	//  dividend pattern
  end 		 
endmodule

