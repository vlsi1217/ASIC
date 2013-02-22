module Multiplier_ASM_0 (product, Ready, word1, word2, Start, clock, reset);
  parameter 				L_word = 4;
  output 		[2*L_word -1: 0] 		product;
  output					Ready;
  input 		[L_word -1: 0] 		word1, word2;
  input 					Start, clock, reset;
  reg 		[1:0] 			state, next_state;
  reg 		[2*L_word -1: 0] 		multiplicand;	 
  reg 		[L_word -1: 0] 		multiplier;
  reg 					product;
  reg					Flush, Load_words, Shift, Add;
  parameter				S_idle = 0, S_shifting = 1, S_adding = 2, S_done = 3;

  wire 		Empty = ((word1 == 0) || (word2 == 0)); 
  wire		Ready = ((state == S_idle) && !reset) || (state == S_done);

  always @ (posedge clock or posedge reset)  	// State transitions
    if (reset) state <= S_idle; else state <= next_state; 

  // Combinational logic for ASM-based controller

  always @ (state or Start or Empty or multiplier) begin 
    Flush = 0; Load_words = 0; Shift = 0; Add = 0;
    case (state)
      S_idle: 	if (!Start) next_state = S_idle;
else if (Start && !Empty) 
begin Load_words = 1; next_state = S_shifting; end 
else if (Start && Empty) begin Flush = 1; next_state = S_done; end

      S_shifting: 	if (multiplier == 1) begin Add = 1;  next_state = S_done; end 
else if (multiplier[0]) begin Add = 1; next_state = S_adding; end
else begin Shift = 1; next_state = S_shifting; end 

      S_adding: 	begin Shift = 1; next_state = S_shifting; end

      S_done:	begin if (Start == 0) next_state = S_done; else if (Empty) 
		  begin Flush = 1; next_state = S_done; end else 
    begin Load_words = 1; next_state = S_shifting; end
end
      default: 	next_state = S_idle; 
    endcase
  end

// Register/Datapath Operations

  always @ (posedge clock or posedge reset) begin
    if (reset) begin multiplier <= 0; multiplicand <= 0; product <= 0; end
    else if (Flush) 
      product <= 0;
    else if (Load_words == 1)  begin 
        multiplicand <= word1; 
        multiplier <= word2; 
        product <= 0;
    end
    else if (Shift) begin 
      multiplicand <= multiplicand << 1; 
      multiplier <= multiplier >> 1; 
    end
    else if (Add) product <= product + multiplicand;
  end 
endmodule
 
 
module test_Multiplier_ASM_0 ();  //  CHECK THIS OUT
  parameter 			word_size = 4;    
  wire 	[2*word_size-1: 0] 	product;		 
  wire 				Ready;
  integer 			word1, word2;     // multiplicand, multiplier
  reg 				Start, clock, reset;

  Multiplier_ASM_0 M1 (product, Ready, word1, word2, Start, clock, reset);

// Exhaustive Testbench
  reg 	[2*word_size-1: 0] 	expected_value;		 
  reg 				code_error;

  initial #80000 $finish;		// Timeout

  always @ (posedge clock)  // Compare product with expected value
    if (Start) begin  
      #5 expected_value <= 0;  
      expected_value <= word2 * word1;
       // expected_value <= word2 * word1 + 1; // Use to check error detection
      code_error <= 0; 
    end 
    else begin 
      code_error <= (M1.state == M1.S_done)? |(expected_value ^ product) : 0;
    end  

  initial begin clock <= 0; forever #10 clock <= ~clock; end
  initial begin	// Exhaustive patterns 
    #2 reset <= 1;
    #15 reset <= 0;
  end
  initial begin
    for (word1 = 0; word1 <= 15; word1 = word1 +1) begin
    for (word2 = 0; word2 <= 15; word2 = word2 +1) begin
      Start <= 0; #40 Start <= 1;
      #20 Start <= 0; 
      #200;
    end  // word2
    #140;
    end  //word1
  end // initial
endmodule

