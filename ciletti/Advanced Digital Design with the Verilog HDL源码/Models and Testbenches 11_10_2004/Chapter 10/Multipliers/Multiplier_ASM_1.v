module Multiplier_ASM_1 (product, Ready, word1, word2, Start, clock, reset);
  parameter 	L_word = 4;		// 
  output 		[2*L_word -1: 0] 		product;
  output 					Ready;
  input 		[L_word -1: 0] 		word1, word2;
  input 					Start, clock, reset;
  reg 					state, next_state;
  reg 		[2*L_word -1: 0] 		multiplicand;	 
  reg 		[L_word -1: 0] 		multiplier;
  reg 					product, Load_words;
  reg					Flush, Shift, Add_shift;
  parameter				S_idle = 0, S_running = 1;

  wire 					Empty = (word1 == 0) || (word2 == 0);
  wire					Ready = (state == S_idle) && (!reset);

  always @ (posedge clock or posedge reset)  	// State transitions
    if (reset) state <= S_idle; else state <= next_state; 

  // Combinational logic for ASM-based controller

always @ (state or Start or Empty or multiplier) begin 
    Load_words = 0; Flush = 0; Shift = 0; Add_shift = 0; 
    case (state)
      S_idle: 	if (!Start) next_state = S_idle;
		else if  (Empty) begin next_state = S_idle; Flush = 1;  end
else begin Load_words = 1; next_state = S_running; end
 
      S_running: 	if (~|multiplier) next_state = S_idle;
		else if (multiplier == 1) 
begin Add_shift = 1; next_state = S_idle; end 
else if (multiplier[0]) begin Add_shift = 1; next_state = S_running; end
else begin Shift = 1; next_state = S_running; end 
      default: 	next_state = S_idle;
    endcase
  end

// Register/Datapath Operations

  always @ (posedge clock or posedge reset) 
    if (reset) begin multiplier <= 0; multiplicand <= 0; product <= 0; end
    else begin 
      if (Flush) product <= 0;
      else if (Load_words == 1)  begin 
        multiplicand <= word1; 
        multiplier <= word2; 
        product <= 0;
      end
      else if (Shift) begin 
        multiplicand <= multiplicand << 1; 
        multiplier <= multiplier >> 1; end
      else if (Add_shift) begin product <= product + multiplicand;
        multiplicand <= multiplicand << 1; 
        multiplier <= multiplier >> 1;
      end
    end 
endmodule

module test_Multiplier_ASM_1 ();  //  CHECK THIS OUT
  parameter 			word_size = 4;    
  wire 	[2*word_size-1: 0] 	product;		 
  wire 				Ready;
  integer 			word1, word2;     // multiplicand, multiplier
  reg 				Start, clock, reset;

  Multiplier_ASM_1 M1 (product, Ready, word1, word2, Start, clock, reset);

// Exhaustive Testbench
  reg 	[2*word_size-1: 0] 	expected_value;		 
  reg 				code_error;

  initial #80000 $finish;		// Timeout

  always @ (posedge clock)  // Compare product with expected value
    if (reset) expected_value = 0; else if (Start) begin  
      #5 expected_value <= 0;  
      expected_value <= word2 * word1;
       // expected_value <= word2 * word1 + 1; // Use to check error detection
      code_error <= 0; 
    end 
    else begin 
      code_error <= (M1.state == M1.S_idle) ? |(expected_value ^ product) : 0;
    end  

  initial begin clock <= 0; forever #10 clock <= ~clock; end
  initial begin	#2 reset <= 1;
    #15 reset <= 0;
  end
initial begin #22000 reset = 1; #900 reset = 0; end
  initial begin	// Exhaustive patterns 
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


