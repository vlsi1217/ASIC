module Divider_RR_STG (quotient, remainder, Ready, Error, word1, word2, Start, clock, reset);
  parameter 	L_divn = 8;
  parameter 	L_divr = 4;			// Choose L_divr <= L_divn
  parameter	S_idle = 0, S_Adivr = 1, S_ShSub = 2, S_Rec = 3, S_Err = 4;
  parameter 	L_state = 3, L_cnt = 4, Max_cnt = L_divn - L_divr;
  parameter	L_Rec_Ctr = 3;
  output 		[L_divn -1: 0] 	quotient;
  output 		[L_divr -1: 0]	remainder;
  output 				Ready, Error;
  input 		[L_divn -1: 0] 	word1;				// Datapath for dividend
  input 		[L_divr -1: 0] 	word2;				// Datapath for divisor
  input 				Start, clock, reset;
  reg 		[L_state -1: 0] 	state, next_state;
  reg 				Load_words, Subtract_and_Shift, 
				Subtract, Shift_dividend, Shift_divisor,  
				Flush_divr, Xfer_Rem;
  reg 		[L_divn+1: 0] 	dividend;			//Doubly extended dividend
  reg		[L_divr -1: 0]	divisor; 
  reg		[L_cnt -1: 0]	num_shift_dividend, num_shift_divisor;
  reg		[L_Rec_Ctr-1: 0]	Rec_Ctr;				// Recovery counter 
  reg		[L_divr: 0]	comparison;  			// includes sign_bit 
  wire		MSB_divr = divisor[L_divr -1];
  wire 		Ready =((state == S_idle) && !reset) ;
  wire		Error = (state == S_Err);
  wire		Max = (num_shift_dividend == Max_cnt + num_shift_divisor );  // needs hardware
						// initialize a counter???

always @ ( state or dividend or divisor or MSB_divr)
    case (state)

      S_ShSub:	comparison = dividend[L_divn +1: L_divn - L_divr +1] + {1'b1, ~divisor[L_divr -1:  0]} + 1'b1;

      default:	if (MSB_divr == 0) 					// Shifted divisor
  comparison = dividend[L_divn +1: L_divn - L_divr +1] + {1'b1, ~(divisor << 1)} + 1'b1;
else comparison = dividend[L_divn +1: L_divn - L_divr +1] + {1'b1, ~divisor[L_divr -1:  0]} + 1'b1; 

    endcase

  wire		sign_bit = comparison[L_divr];
  wire 		overflow = Subtract_and_Shift && ((dividend[0] == 1) || (num_shift_dividend == 0 ));
 
  assign		quotient = ((divisor == 1) && (num_shift_divisor == 0))? dividend[L_divn: 1]: 
		(num_shift_divisor == 0) ? dividend[L_divn - L_divr : 0]:
		dividend[L_divn+1: 0];

  assign 	remainder = (num_shift_divisor == 0) ? (divisor == 1) ?  0: (dividend[L_divn:  L_divn - L_divr +1]  ):
		divisor;

  always @ (posedge clock or posedge reset)  		// State Transitions
    if (reset) state <= S_idle; else state <= next_state; 

  // Next state and control logic
 
  always 
    @ (state or word1 or word2 or divisor or Start or comparison or sign_bit or Max or Rec_Ctr)  begin
    Load_words = 0; Shift_dividend = 0; Shift_divisor  = 0; 
    Subtract_and_Shift = 0; Subtract = 0; Flush_divr = 0; 
    Flush_divr = 0; Xfer_Rem = 0;
    case (state)
      S_idle: 	case (Start) 		  
  	  	  0:	next_state = S_idle; 
	  	  1:	if (word2 == 0) next_state = S_Err; 
			else if (word1) begin next_state = S_Adivr; Load_words = 1; end
			else if (sign_bit == 1) next_state = S_ShSub; 
			else next_state = S_idle;
		default:	next_state = S_Err;
		endcase 

      S_Adivr:	 if (divisor == 1) 
		  begin next_state = S_idle; end else 
		 case ({MSB_divr, sign_bit})
	  2'b00:	begin next_state = S_Adivr; Shift_divisor = 1; end		// can shift divisor
	  2'b01:	next_state = S_ShSub;					// cannot shift divisor
	  2'b10:	next_state = S_ShSub; 
	  2'b11:	next_state = S_ShSub;
	endcase
			  		
        S_ShSub:	case ({Max, sign_bit}) 
	  2'b00:	begin next_state = S_ShSub; Subtract_and_Shift = 1; end
	  2'b01:	begin next_state = S_ShSub; Shift_dividend = 1; end				
	  2'b10:	if (num_shift_divisor == 0) begin next_state = S_idle; Subtract = 1; end
		else begin next_state = S_ShSub; Subtract = 1; end
	  2'b11:	if (num_shift_divisor == 0) next_state = S_idle; 
else if (num_shift_divisor != 0) begin next_state = S_Rec; Flush_divr = 1; end
	endcase

        S_Rec:  	if (Rec_Ctr == L_divr - num_shift_divisor) begin next_state = S_idle; end
		else begin next_state = S_Rec; Xfer_Rem = 1; end
		 
      default:	next_state = S_Err;
    endcase
  end

always @ (posedge clock or posedge reset) begin	// Register/Datapath operations	
    if (reset) begin 
      divisor <= 0; dividend <= 0; 
      num_shift_dividend <= 0; num_shift_divisor <= 0;   // use to down-cnt
      Rec_Ctr <= 0;
    end

    else if (Load_words == 1)  
      begin 
        dividend[L_divn +1: 0] <= {1'b0, word1[L_divn -1: 0], 1'b0}; 
        divisor <= word2; 
        num_shift_dividend <= 0; 
        num_shift_divisor <= 0; 
        Rec_Ctr <= 0;
    end

    else if (Shift_divisor) begin 
      divisor <= divisor << 1; 
      num_shift_divisor <= num_shift_divisor + 1; 
    end

    else if (Shift_dividend) begin
      dividend <= dividend << 1;   
      num_shift_dividend <= num_shift_dividend +1;
    end

    else if (Subtract_and_Shift) 
      begin 
        dividend[L_divn + 1: 0] <= {comparison[L_divr -1: 0], dividend [L_divn -L_divr: 1], 2'b10}  ;  
        num_shift_dividend <= num_shift_dividend +1;
      end

    else if (Subtract) 
      begin 
        dividend[L_divn +1: 1] <= {comparison[L_divr: 0], dividend [L_divn -L_divr: 1]} ;  
        dividend[0] <= 1;
      end
 
    else if (Flush_divr) begin 
      Rec_Ctr <= 0;
      divisor <= 0;
    end

    else if (Xfer_Rem) begin
      divisor[Rec_Ctr] <= dividend[ L_divn  - L_divr + num_shift_divisor + 1 + Rec_Ctr];
      dividend[ L_divn  - L_divr + num_shift_divisor + 1 + Rec_Ctr] <= 0;
      Rec_Ctr <= Rec_Ctr + 1;
     end
 
  end
endmodule



