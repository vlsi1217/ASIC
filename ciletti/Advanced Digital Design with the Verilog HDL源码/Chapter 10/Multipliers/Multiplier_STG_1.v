module Multiplier_STG_1 (product, Ready, word1, word2, Start, clock, reset);
  parameter 				L_word = 4;
  output 		[2*L_word -1: 0] 		product;
  output 					Ready;
  input 		[L_word -1: 0] 		word1, word2;
  input 					Start, clock, reset;
  wire					m0, Empty, Load_words, Shift, Add_shift;
  wire					Ready;

  Datapath M1 
    (product, m0, Empty, word1, word2, Ready, Start, Load_words, Shift, Add_shift, clock, reset);

  Controller M2 (Load_words, Shift, Add_shift, Ready, m0, Empty, Start, clock, reset);
endmodule

module Controller (Load_words, Shift, Add_shift, Ready, m0, Empty, Start, clock, reset);
  parameter 			L_word = 4;
  parameter			L_state = 3;
  output 				Load_words, Shift, Add_shift, Ready;
  input 				Empty;
  input 				m0, Start, clock, reset;

  reg 		[L_state -1: 0] 	state, next_state;
  parameter 			S_idle = 0, S_1 = 1, S_2 = 2, S_3 = 3, S_4 = 4, S_5 = 5;
  reg 				Load_words, Shift, Add_shift;

  wire 				Ready =  ((state == S_idle) && !reset) || (state == S_5);

  always @ (posedge clock or posedge reset)  	// State transitions
    if (reset) state <= S_idle; else state <= next_state; 

  always @ (state or Start or m0 or Empty) begin 	// Next state and control logic
    Load_words = 0;  Shift = 0; Add_shift = 0; 
    case (state)
      S_idle: 	if (Start && Empty) next_state = S_5; 
else if (Start) begin Load_words = 1; next_state = S_1; end 
		else next_state =  S_idle;  
      S_1:		begin if (m0) Add_shift = 1; else Shift = 1; next_state = S_2; end 
      S_2:		begin if (m0) Add_shift = 1; else Shift = 1; next_state = S_3; end 
      S_3:		begin if (m0) Add_shift = 1; else Shift = 1; next_state = S_4; end 
      S_4:		begin if (m0) Add_shift = 1; else Shift = 1; next_state = S_5; end 
      S_5:		if (Empty) next_state = S_5; 
else if (Start) begin Load_words = 1; next_state = S_1; end 
else next_state = S_5;
      default:	next_state = S_idle;
    endcase
  end
endmodule

module Datapath (product, m0, Empty, word1, word2, Ready, 
  Start, Load_words, Shift, Add_shift, clock, reset);
  parameter 				L_word = 4;
  output 		[2*L_word -1: 0] 		product;
  output 					m0, Empty;
  input 		[L_word -1: 0] 		word1, word2;
  input 					Ready, Start, Load_words, Shift;
  input					Add_shift, clock, reset;
  reg 		[2*L_word -1: 0] 		product, multiplicand;
  reg 		[L_word -1: 0]  		multiplier;
  wire 					m0 = multiplier[0];
  wire 					Empty = (~|word1)|| (~|word2);

  // Register/Datapath Operations

 always @ (posedge clock or posedge reset) begin
    if (reset) begin multiplier <= 0; multiplicand <= 0; product <= 0; end
    else if (Start && Empty && Ready) product <= 0; 
    else if (Load_words)  begin 
      multiplicand <= word1;
      multiplier <= word2; 
      product <= 0; 
    end
    else if (Shift) begin 
      multiplier <= multiplier >> 1; 
      multiplicand <= multiplicand << 1; 
    end
    else if (Add_shift) begin 
        product <= product + multiplicand; 
        multiplier <= multiplier >> 1; 
        multiplicand <= multiplicand << 1; 
    end 
  end
endmodule

module test_Multiplier_STG_1 ();
  parameter 			L_word = 4;    
  wire 		[2*L_word -1: 0] 	product;		 
  wire 				Ready;
  integer 			word1, word2;     // multiplicand, multiplier
  reg 				Start, clock, reset;

  Multiplier_STG_1 M1 (product, Ready, word1, word2, Start, clock, reset);

  // Exhaustive Testbench
  reg 		[2*L_word -1: 0] 	expected_value;		 
  reg 				code_error;

  initial #80000 $finish;		// Timeout

  always @ (posedge clock)  // Compare product with expected value
    if (Start) begin  
      #5 expected_value = 0;  
      expected_value = word2 * word1;
       // expected_value = word2 * word1 + 1; // Use to check error detection
      code_error = 0; 
    end 
    else begin 
      code_error = (M1.M2.state == M1.M2.S_5) ? |(expected_value ^ product) : 0;
    end  

  initial begin clock = 0; forever #10 clock = ~clock; end
  initial begin	 
    #2 reset = 1;
    #15 reset = 0;
  end
initial begin #42695 Start = 1; #20 Start = 0; end
  initial begin #5 Start = 1; #10 Start = 15; end	// Test for reset override
  initial begin	// Exhaustive patterns
    for (word1 = 0; word1 <= 15; word1 = word1 +1) begin
    for (word2 = 0; word2 <= 15; word2 = word2 +1) begin
      Start = 0; #40 Start = 1;
      #20 Start = 0; 
      #200;
    end  // word2
    #140;
    end  //word1
  end // initial
endmodule


