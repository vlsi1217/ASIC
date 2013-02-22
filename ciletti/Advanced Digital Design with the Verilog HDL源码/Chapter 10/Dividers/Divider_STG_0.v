module Divider_STG_0 (quotient, remainder, Ready, Error, word1, word2, Start, clock, reset);
/* This version checks for a divide by zero, subtracts the divisor from the dividend until the dividend is less than the divisor, and counts the number of subtractions performed. The length of divisor must not exceed the length of dividend .*/ 

  parameter 				L_divn = 8;
  parameter 				L_divr = 4;		 
  parameter				S_idle = 0, S_1 = 1, S_2 = 2, S_3 = 3, S_Err = 4; 
  parameter 				L_state = 3;
  output 		[L_divn -1: 0] 	quotient;
  output 		[L_divr -1: 0]	remainder;
  output 					Ready, Error;
  input 		[L_divn -1: 0] 	word1;			// Datapath for dividend
  input 		[L_divr -1: 0] 	word2;			// Datapath for divisor
  input 					Start, clock, reset;
  reg 		[L_state -1: 0] 	state, next_state;
  reg 					Load_words, Subtract;
  reg 		[L_divn -1: 0] 	dividend;	 	 
  reg			[L_divr -1: 0]	divisor;
  reg 		[L_divn -1: 0]	quotient;
  wire 					GTE = (dividend >= divisor);	// Comparator
  wire 					Ready = ((state == S_idle) && !reset) || (state == S_3);
  wire 					Error = (state == S_Err);
  assign 	 			remainder = dividend[L_divr -1: 0];

  always @ (posedge clock or posedge reset) 
    if (reset) state <= S_idle; else state <= next_state; 		// State transitions

  always @ (state or word1 or word2 or Start or GTE ) begin 	// Next state and control logic
    Load_words = 0; Subtract = 0; 
    case (state)
      S_idle: 	case (Start) 		  
  		  0:   	next_state = S_idle; 
			  
      		  1:	if (word2 == 0) next_state = S_Err; 
			else if (word1) begin next_state = S_1; Load_words = 1; end
			else next_state = S_3;
		 endcase
	      S_1:		if (GTE) begin next_state = S_2; Subtract = 1; end
			else next_state = S_3;
                    S_2:		if (GTE) begin next_state = S_2; Subtract = 1; end 
else next_state = S_3;
      S_3: 	case (Start) 		  
  		  0:   	next_state = S_3; 
			  
      		  1:	if (word2 == 0) next_state = S_Err; 
			else if (word1 == 0) next_state = S_3;
else begin next_state = S_1; Load_words = 1; end
		endcase
      S_Err:		next_state = S_Err;
      default:	next_state = S_Err;
    endcase
  end

// Register/Datapath Operations

  always @ (posedge clock or posedge reset) begin
    if (reset) begin divisor <= 0; dividend <= 0; quotient <= 0; end
    else if (Load_words == 1)  begin 
      dividend <= word1; 
      divisor <= word2; 
      quotient <= 0; end
    else if (Subtract)  begin 
      dividend <= dividend[L_divn -1: 0] + 1'b1 + {{(L_divn -L_divr){1'b1}}, ~divisor[L_divr -1: 0]};
      quotient <= quotient + 1; end
   end
endmodule

module test_Divider_STG_0 ();
  parameter L_divn = 8;
  parameter L_divr = 4;
  wire [L_divn -1: 0] quotient;
  wire [L_divr-1:0] remainder;
  wire Ready, Div_zero;
  integer word1;		// dividend
  integer word2;		// divisor
  reg Start, clock, reset;
  reg [L_divn-1: 0] expected_value;
  reg [L_divr-1:0] expected_remainder;		 
  reg code_error;

  Divider_STG_0 M1 (quotient, remainder, Ready, Error, word1, word2, Start, clock, reset);
 
  integer k, m;

  initial #1800000 $finish;
  initial begin clock = 0; forever #10 clock = ~clock; end

// Exhaustive Test
always @ (negedge Ready) begin 
//always @ (posedge clock) 
//begin if (!reset && Start && (M1.state == M1.S_idle) || (M1.state == M1.S_3)) 
	begin  
	 #2 if (word2 != 0) begin expected_value = 0; expected_remainder = 0; code_error = 0;  end
	if (word2 != 0) begin expected_value = word1 / word2; expected_remainder = word1 % word2; end
 	end
code_error = (!reset && Ready && !Start) ? | {|(expected_value ^ quotient), |(expected_remainder ^ remainder)}: 0;
#10 code_error = 0;
end


initial begin	
// Test for divide by zero detection
#2 reset = 1;
#15 reset = 0; Start = 0;
#10 Start = 1; #5 Start = 0;		
end

initial begin 
// Test for recovery from error state on reset
#50 reset = 1; #5 Start = 1; #5 reset = 0;
word1 = 0; 
word2 = 1; 
while (word2 <= 15) #20 word2 = word2 +1;
 #20 Start = 0; 

end		// Test for recovery from running reset state

initial begin #500  // Exhaustive patterns

  	word1 = 1 /*127*/; while (word1 <= 127 /*255*/) begin			
	word2 = 1; while (word2 <= 15) begin
  		#0 Start = 0; 
		#30 Start = 1;
      	#20 Start = 0; 
      	@ (posedge Ready) #0;
		word2 = word2 + 1; end  	// word2
	word1 = word1 + 1; end 	 		//word1
end 		// initial
endmodule

