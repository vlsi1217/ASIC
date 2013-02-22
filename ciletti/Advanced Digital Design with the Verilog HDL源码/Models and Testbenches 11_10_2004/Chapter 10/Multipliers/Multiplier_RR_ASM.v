module Multiplier_RR_ASM (product, Ready, word1, word2, Start, clock, reset);
  parameter 				L_word = 4;
  parameter				L_cnt = 3;
  output 	[2*L_word: 0] 		product;
  output 				Ready;
  input 		[L_word -1: 0] 		word1, word2;
  input 					Start, clock, reset;
  reg 					state, next_state;
  reg 		[L_word -1: 0] 		multiplicand;	
  reg 					product, Load_words;
  reg					Flush, Shift, Add_shift, Increment;
  reg 		[L_cnt  -1 :0] 		counter;
  parameter				S_idle = 0, S_running = 1;
  wire 					Empty = (word1 == 0) || (word2 == 0); 
  wire 					Ready = (state == S_idle) && (!reset ); 
 
// Controller

  always @ (posedge clock or posedge reset)  	// State transitions
    if (reset) state <= S_idle; else state <= next_state; 

// Combinational logic for ASM-based controller

  always @ (state or Start or Empty or product or counter) begin 	 
    Load_words = 0; Flush = 0; Shift = 0; Add_shift = 0; Increment = 0;  
    case (state)

      S_idle: 	if (!Start) next_state = S_idle;
		else if  (Empty) begin next_state = S_idle; Flush = 1;  end
else begin Load_words = 1; next_state = S_running; end

      S_running: 	if (counter == L_word) next_state = S_idle; 
		else begin 
  Increment = 1; 
  if (product[0]) begin Add_shift = 1; next_state = S_running; end
  else begin Shift = 1; next_state = S_running; end 
end

      default: 	next_state = S_idle;
    endcase
end
 
// Register/Datapath Operations

  always @ (posedge clock or posedge reset) 
    if (reset) begin multiplicand <= 0; product <= 0; counter <= 0; end
    else begin 
      if (Flush) product <= 0; 
      if (Load_words == 1)  
        begin multiplicand <= word1; product <= word2; counter <= 0; end
      if (Shift) begin product <= product >> 1; end
      if (Add_shift) begin 
        product <= {product[2*L_word: L_word] + multiplicand, product[L_word -1: 0]} >> 1;
      end
      if (Increment) counter <= counter +1;
  end 
endmodule

module test_Multiplier_RR_ASM ();
  parameter 			word_size = 4;    
  wire 	[2*word_size: 0] 	product;		 
  //wire 				Done;
  integer 			word1, word2;     // multiplicand, multiplier
  reg 				Start, clock, reset;

Multiplier_RR_ASM M1 (product, Ready, word1, word2, Start, clock, reset);

// Exhaustive Testbench
  reg 	[2*word_size: 0] expected_value;		 
  reg 				code_error;
  integer 			k, m;

  initial #80000 $finish;		// Timeout

  always @ (posedge clock)  // Compare product with expected value
    if (Start) begin  
      #5 expected_value <= 0;  
      expected_value <= word2 * word1;
       // expected_value <= word2 * word1 + 1; // Use to check error detection
      code_error <= 0; 
    end 
    else begin 
      code_error <= ((M1.state == M1.S_idle) && (expected_value != 0)) ? |(expected_value ^ product) : 0;
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


