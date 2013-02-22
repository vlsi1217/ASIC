// 1-30-2000


// Verified for all possible combinations (+ and -) for multiplicand and multiplier.

// change size of product register
/* Does not consider odd number of bits in a word
*/ 

`define		All_Ones 		8'b1111_1111
`define		All_Zeros 		8'b0000_0000

module Multiplier_Radix_4_STG_0 (product, Ready, word1, word2, Start, clock, reset);
  parameter 				L_word = 8;


  output 		[2*L_word -1: 0] 		product;
  output 					Ready;
  input 		[L_word -1: 0] 		word1, word2;
  input 					Start, clock, reset;
  wire					Load_words, Shift, Add_sub, Ready;
  wire 		[2:0] 			BPEB;

Datapath_Radix_4_STG_0 M1 
  (product, BPEB, word1, word2, Load_words, Shift_1, Shift_2, Add, Sub, clock, reset);  

Controller_Radix_4_STG_0 M2 
  (Load_words, Shift_1, Shift_2, Add, Sub, Ready, BPEB, Start, clock, reset);

endmodule

module Controller_Radix_4_STG_0 
  (Load_words, Shift_1, Shift_2, Add, Sub, Ready, BPEB, Start, clock, reset);
  parameter 			L_word = 8;
  output 				Load_words, Shift_1, Shift_2, Add, Sub, Ready;
  input 				Start, clock, reset;
  input		[2:0]		BPEB;
  reg 		[4:0] 		state, next_state;
  parameter 			S_idle = 0, S_1 = 1, S_2 = 2, S_3 = 3;
  parameter			S_4 = 4, S_5 = 5, S_6 = 6, S_7 = 7, S_8 = 8;
  parameter			S_9 = 9, S_10 = 10, S_11 = 11, S_12 = 12;
  parameter			S_13 = 13, S_14 = 14, S_15 = 15;
  parameter			S_16 = 16, S_17 = 17;

  reg 				Load_words, Shift_1, Shift_2, Add, Sub;
  wire 				Ready = ((state == S_idle) && !reset) || (next_state == S_17) ;

  always @ (posedge clock or posedge reset)  
    if (reset) state <= S_idle; else state <= next_state; 

  always @ (state or Start or BPEB) begin 	// Next state and control logic
    Load_words = 0;  Shift_1 = 0; Shift_2 = 0; Add = 0; Sub = 0;
    case (state)
      S_idle: 	if (Start) begin Load_words = 1; next_state = S_1; end 
		else next_state =  S_idle;  
      S_1:		case (BPEB)
		0:	begin Shift_2 = 1; 	next_state = S_5;  end
		2: 	begin Add = 1; 		next_state = S_2; end 
		4:	begin Shift_1 = 1; 	next_state = S_3; end
		6:	begin Sub = 1; 		next_state = S_2; end
		default: 				next_state = S_idle;
		endcase  
      S_2:		begin 	Shift_2 = 1; 		next_state = S_5; end
      S_3:		begin 	Sub = 1; 		next_state = S_4; end
      S_4:		begin 	Shift_1 = 1; 		next_state = S_5; end

      S_5:		case (BPEB)
		0, 7:	begin Shift_2 = 1; 	next_state = S_9; end
		1, 2:	begin Add = 1; 		next_state = S_6; end
		3, 4:	begin Shift_1 = 1; 	next_state = S_7; end
		5, 6:	begin Sub = 1; 		next_state = S_6; end
		endcase 
      S_6:		begin 	Shift_2 = 1; 		next_state = S_9; end
      S_7:		begin 	if (BPEB[1:0] == 2'b01) Add = 1; 
else 	Sub = 1;			 next_state = S_8; end
      S_8:		begin 	Shift_1 = 1; next_state = S_9; end
      S_9:		case (BPEB)
		0, 7:	begin Shift_2 = 1; 	next_state = S_13; end
		1, 2:	begin Add = 1; 		next_state = S_10; end
		3, 4:	begin Shift_1 = 1; 	next_state = S_11; end
		5, 6:	begin Sub = 1; 		next_state = S_10; end
		endcase 
      S_10:	begin Shift_2 = 1; 		next_state = S_13; end
      S_11:	begin 	if (BPEB[1:0] == 2'b01) Add = 1; 
else 	Sub = 1; 		next_state = S_12; end 
      S_12:	begin	 Shift_1 = 1; 		next_state = S_13; end
      S_13:	case (BPEB)
		0, 7:	begin Shift_2 = 1; 	next_state = S_17; end
		1, 2:	begin Add = 1; 		next_state = S_14; end
		3, 4:	begin Shift_1 = 1; 	next_state = S_15; end
		5, 6:	begin Sub = 1; 		next_state = S_14; end
		endcase 
      S_14:	begin	 Shift_2 = 1; next_state = S_17; end
      S_15:	begin 	if (BPEB[1:0] == 2'b01) Add = 1; 
else 	Sub = 1; next_state = S_16; end
      S_16:	begin 	Shift_1 = 1; next_state = S_17; end
      S_17:	if 	(Start) begin Load_words = 1; next_state = S_1; end 
else	 next_state = S_17; 
	      default:	next_state = S_idle;
    endcase
  end
endmodule

 module Datapath_Radix_4_STG_0 
  (product, BPEB, word1, word2, Load_words, Shift_1, Shift_2, Add, Sub, clock, reset);  
  parameter 				L_word = 8;
  output 		[2*L_word -1: 0] 		product;
  output 		[2:0] 			BPEB;
  input 		[L_word -1: 0] 		word1, word2;
  input 					Load_words, Shift_1, Shift_2;
  input					Add, Sub, clock, reset;
  reg 		[2*L_word -1: 0] 		product, multiplicand;
  reg 		[L_word -1: 0]  		multiplier;
  reg					m0_del;
  wire 		[2:0]			BPEB = {multiplier[1:0], m0_del};

  // Datapath Operations
  always @ (posedge clock or posedge reset) begin
    if (reset) begin 
      multiplier <= 0; m0_del <= 0; multiplicand <= 0; product <= 0;
    end
    else if (Load_words)  begin 
      m0_del <= 0;
      if (word1[L_word -1] == 0) multiplicand <= word1; 
      else multiplicand <= {`All_Ones, word1[L_word -1:0]};
      multiplier <= word2; m0_del <= 0; product <= 0;  
    end
    else if (Shift_1) begin 
      {multiplier, m0_del} <= {multiplier, m0_del} >> 1; 
      multiplicand <= multiplicand << 1; 
    end
    else if (Shift_2) begin 
      {multiplier, m0_del} <= {multiplier, m0_del} >> 2;  
      multiplicand <= multiplicand << 2; 
    end
    else if (Add) begin product <= product + multiplicand; end
    else if (Sub) begin product <= product - multiplicand; end
  end
endmodule 

module test_Multiplier_Radix_4_STG_0 ();
  parameter 			word_size = 8;    
  wire 	[2*word_size-1:0]	product;		 
  wire 				Ready;
  integer 				word1, word2;     // multiplicand, multiplier
  reg 				Start, clock, reset;
  reg 	[word_size-1:0] 		mag_1, mag_2;

// Exhaustively test four cases (01/30/2000): 
// All positive multiplicands, all positive multipliers - passed
// All positive multiplicands, all negative multipliers - passed
// All negative multiplicands, all positive multiplers
// A// negative multiplicands, all negative multipliers

  //parameter word1_limit = 127;	// Use to verify with 8-bit datapaths.
  //parameter word2_limit = 127;	// Use to verify with 8-bit datapaths.
  parameter word2_limit = 255;	// Use to verify with 8-bit datapaths.
  parameter word1_limit = 255;	// Use to verify with 8-bit datapaths.


 // parameter stim_limit = 15;	// Use to verify with 4-bit datapaths.
  parameter word2_start = 9'd128, word1_start = 9'd128; 

  Multiplier_Radix_4_STG_0 M1 (product, Ready, word1, word2, Start, clock, reset);

  // Exhaustive Testbench
  reg 	[2*word_size-1: 0] 	expected_value, expected_mag;		 
  reg 				code_error;

// initial #4500000 $finish;		// Timeout
initial #3450000 $finish;		// Timeout

/*  Error detection for binary words (i.e. both positive)

  always @ (posedge clock)  // Compare product with expected value
    if (Start) begin  
      #5 expected_value = 0;  
      expected_value = word2 * word1;
       // expected_value = word2 * word1 + 1; // Use to check error detection
      code_error = 0; 
    end 
    else begin 
      code_error = Ready ? |(expected_value ^ product) : 0;
    end  
end
*/

// Error detection code for both negative values

always @ (negedge clock)  // Compare product with expected value0
    if (Start) begin  
      expected_value = 0;  
      case({word1[word_size-1], word2[word_size-1]})
        0: begin expected_value = word1 * word2; expected_mag = expected_value; end
        1: begin expected_value = word1*  {`All_Ones,word2[word_size-1:0]}; 
            expected_mag = 1+ ~(expected_value); end
        2: begin expected_value = {`All_Ones, word1[word_size-1:0]} *word2;
            expected_mag = 1+ ~(expected_value); end 
        3: begin expected_value = ({`All_Zeros,1+ ~word2[word_size-1:0]}) * ({`All_Zeros,1+ ~word1[word_size-1:0]});
            expected_mag = expected_value; end
      endcase

      // expected_value = (-word1) * (-word2);       // does not work
      // expected_value = word2 * word1 + 1; // Use to check error detection
      code_error = 0; 
    end 
    else begin 
      code_error = Ready ? |(expected_value ^ product) : 0;
    end  


  initial begin clock = 0; forever #10 clock = ~clock; end
  initial begin	 
    #2 reset = 1;
    #15 reset = 0;
  end


// Small sample of Booth patterns for 2's complement values ************************
/*initial begin
#100 word1 = 4'b1001; word2 = 4'b1011;  
#20 Start =1; #10 Start = 0; end
//the patterns below expose a bogus mode of operation in which Start hits at the clock (435and causes a state change, but the data operation uses the residual value of Load_words.

initial begin
#420 reset = 1; #10 reset = 0; word1 = 4'b1001; word2 = 4'b1011;  
#40 Start =1; #10 Start = 0; end

initial begin
#620 reset = 1; #10 reset = 0; word1 = 4'b1001; word2 = 4'b1011;  
#35 Start =1; #10 Start = 0; end
*/

// Booth exhaustive for mixed *+ and -  *******************************************
// Adjust parameters to control the simulation range.

initial begin  #9012 reset = 0; #20 reset = 1; #50 reset = 0; end  // Random test
initial begin	// Exhaustive patterns
    #100 
    for (word1 = word1_start; word1 <= word1_limit; word1 = word1 +1) begin
        if (word1[word_size-1] == 0) mag_1 = word1; else begin mag_1 = word1[word_size-1:0];
        mag_1 = 1+ ~mag_1; end
      for (word2 = word2_start; word2 <= word2_limit; word2 = word2 +1) begin
        if (word2[word_size-1] == 0) mag_2 = word2;  else begin mag_2 = word2[word_size-1:0];
        mag_2 = 1+ ~mag_2; end

      Start = 0; #40 Start = 1;
      #20 Start = 0; 
      #200;
    end  // word2
    #140;
    end  //word1
end


// Booth exhaustive for both negative  *******************************************
/*
initial begin	// Exhaustive patterns
    #100 
    for (word1 = 4'b1000; word1 <= 15; word1 = word1 +1) begin
        mag_1 = word1[word_size-1:0];
        mag_1 = 1+ ~mag_1;
      for (word2 = 4'b1000; word2 <= 15; word2 = word2 +1) begin
        mag_2 = word2[word_size-1:0];
        mag_2 = 1+ ~mag_2;

      Start = 0; #40 Start = 1;
      #20 Start = 0; 
      #200;
    end  // word2
    #140;
    end  //word1
end
*/
/*
  initial begin	// Exhaustive patterns for binary words

    for (word1 = 0; word1 <= 15; word1 = word1 +1) begin
    for (word2 = 0; word2 <= 15; word2 = word2 +1) begin
      Start = 0; #40 Start = 1;
      #20 Start = 0; 
      #200;
    end  // word2
    #140;
    end  //word1
  end // initial
*/
endmodule

