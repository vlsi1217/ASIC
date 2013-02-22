module Multiplier_Booth_STG_0 (product, Ready, word1, word2, Start, clock, reset);
  parameter 				L_word = 4;
  parameter				L_BRC = 2;
  parameter				All_Ones = {L_word {1'b1}};
  parameter				All_Zeros = {L_word {1'b0}};
  output 		[2*L_word -1: 0] 		product;
  output 					Ready;
  input 		[L_word -1: 0] 		word1, word2;
  input 					Start, clock, reset;
  wire					m0, Load_words, Shift, Add, Sub, Ready;
  wire 		[L_BRC -1: 0] 		BRC;

  Datapath_Booth_STG_0  M1 (product, m0, word1, word2, Load_words, 
    Shift, Add, Sub, clock, reset);

  Controller_Booth_STG_0  M2 (Load_words, Shift, Add, Sub, 
    Ready, m0, Start, clock, reset);
endmodule

module Controller_Booth_STG_0 (Load_words, Shift, Add, Sub, 
  Ready, m0, Start, clock, reset);
  parameter 			L_word = 4;
  parameter			L_state = 4;
  parameter			L_BRC = 2;
  output 				Load_words, Shift, Add, Sub, Ready;
  input 				Start, clock, reset;
  input 				m0;
  reg 		[L_state -1: 0] 	state, next_state;
  parameter 			S_idle = 0, S_1 = 1, S_2 = 2, S_3 = 3;
  parameter			S_4 = 4, S_5 = 5, S_6 = 6, S_7 = 7, S_8 = 8;
  reg 				Load_words, Shift, Add, Sub;
  wire 				Ready = (state == S_8);
  reg 				m0_del;
  wire 		[L_BRC -1: 0] 	BRC = {m0, m0_del};		// Booth recoding bits

// Necessary to reset m0_del when Load_words is asserted, otherwise it would start with residual value

always @ (posedge clock or posedge reset) 
  if (reset) m0_del <= 0; else if (Load_words) m0_del <= 0; else m0_del <= m0;

  always @ (posedge clock or posedge reset)  
    if (reset) state <= S_idle; else state <= next_state; 

  always @ (state or Start or BRC) begin 	// Next state and control logic
    Load_words = 0;  Shift = 0; Add = 0; Sub = 0;
    case (state)
      S_idle: 	if (Start) begin Load_words = 1; next_state = S_1; end 
		else next_state =  S_idle;  

      S_1:	if ((BRC == 0) || (BRC == 3)) begin Shift = 1; next_state = S_3;  end 
        		else if (BRC == 1) begin Add = 1; next_state = S_2; end 
		else if (BRC == 2) begin Sub = 1; next_state = S_2; end

      S_3:	if ((BRC == 0) || (BRC == 3)) begin Shift = 1; next_state = S_5;  end 
        		else if (BRC == 1) begin Add = 1; next_state = S_4; end 
		else if (BRC == 2) begin Sub = 1; next_state = S_4; end

      S_5:	if ((BRC == 0) || (BRC == 3)) begin Shift = 1; next_state = S_7; end 
        		else if (BRC == 1) begin Add = 1; next_state = S_6; end 
		else if (BRC == 2) begin Sub = 1; next_state = S_6; end

      S_7:	if ((BRC == 0) || (BRC == 3)) begin Shift = 1; next_state = S_8;  end 
        		else if (BRC == 1) begin Add = 1; next_state = S_8; end 
		else if (BRC == 2) begin Sub = 1; next_state = S_8; end

      S_2:	begin Shift = 1; next_state = S_3; end
      S_4:	begin Shift = 1; next_state = S_5; end
      S_6:	begin Shift = 1; next_state = S_7; end

      S_8:	if (Start) begin Load_words = 1; next_state = S_1; end 
		else next_state =  S_8;

      default:	next_state = S_idle;
    endcase
  end
endmodule

module Datapath_Booth_STG_0  (product, m0, word1, word2, Load_words, 
  Shift, Add, Sub, clock, reset);
  parameter 				L_word = 4;
  output 		[2*L_word -1: 0] 		product;
  output 					m0;
  input 		[L_word -1: 0] 		word1, word2;
  input 					Load_words, Shift, Add, Sub, clock, reset;
  reg 		[2*L_word -1: 0] 		product, multiplicand;
  reg 		[L_word -1: 0]  		multiplier;
  wire 					m0 = multiplier[0];
  parameter				All_Ones = {L_word {1'b1}};
  parameter				All_Zeros = {L_word {1'b0}};

  // Datapath Operations

  always @ (posedge clock or posedge reset) begin
    if (reset) begin multiplier <= 0; multiplicand <= 0; product <= 0; end
    else if (Load_words)  begin 
      if (word1[L_word -1] == 0) multiplicand <= word1; 	// Check sign bit
      else multiplicand <= {All_Ones, word1[L_word -1:0]};
      multiplier <= word2; 
      product <= 0;  
    end
    else if (Shift) begin 
      multiplier <= multiplier >> 1;   
      multiplicand <= multiplicand << 1; 
    end
    else if (Add) begin product <= product + multiplicand; 
 end

    else if (Sub) begin product <= product - multiplicand; 
 end
  end
endmodule
 
module test_Multiplier_STG_0 ();
  parameter 				L_word = 4;    
  wire 	[2*L_word -1: 0] 		product;		 
  wire 					Ready;
  integer 					word1, word2;     // multiplicand, multiplier
  reg 					Start, clock, reset;
  reg 	[L_word-1:0] 		mag_1, mag_2;

  Multiplier_Booth_STG_0 M1 (product, Ready, word1, word2, Start, clock, reset);

  // Exhaustive Testbench
  reg 		[2*L_word -1: 0] 		expected_value, expected_mag;		 
  reg 					code_error;
  parameter				All_Ones = {L_word {1'b1}};
  parameter				All_Zeros = {L_word {1'b0}};

  initial #80000 $finish;			// Timeout

// Error detection 

always @ (posedge clock)  // Compare product with expected value
    if (Start) begin  
      expected_value = 0;  
      case({word1[L_word -1], word2[L_word -1]})
        0: begin 	expected_value = word1 * word2; expected_mag = expected_value; end
        1: begin 	expected_value = word1*  {All_Ones,word2[L_word -1:0]}; 
            		expected_mag = 1+ ~(expected_value); end
        2: begin	expected_value = {All_Ones, word1[L_word -1:0]} *word2;
            		expected_mag = 1+ ~(expected_value); end 
        3: begin 	expected_value = 
              		({All_Zeros,~word2[L_word -1:0]}+1) * ({All_Zeros,~word1[L_word -1:0]}+1);
              		expected_mag = expected_value; end
      endcase

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

initial begin	// Exhaustive patterns
    #100 
    for (word1 = All_Zeros; word1 <= 15; word1 = word1 +1) begin
      if (word1[L_word -1] == 0) mag_1 = word1; 
      else begin mag_1 = word1[L_word -1:0];
        mag_1 = 1+ ~mag_1; end
      for (word2 = All_Zeros; word2 <= 15; word2 = word2 +1) begin
        if (word2[L_word -1] == 0) mag_2 = word2;  
        else begin mag_2 = word2[L_word -1:0]; mag_2 = 1+ ~mag_2; end
        Start = 0; #40 Start = 1;
        #20 Start = 0; 
        #200;
    end  // word2
    #140;
    end  //word1
end
endmodule

