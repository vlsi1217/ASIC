module Multiplier_IMP_1 (product, Ready, Done, word1, word2, Start, clock, reset);
  parameter 				L_word = 4;
  output 		[2*L_word -1: 0] 		product;
  output 					Ready, Done;
  input 		[L_word -1: 0] 		word1, word2;
  input 					Start, clock, reset;
  wire 		[L_word -1:0] 		multiplier;
  wire 					Flush, Load_words, Shift, Add_shift;

  Datapath_Unit_IMP_1 M1 
    (product, multiplier, word1, word2, Flush, Load_words, Shift, Add_shift, clock, reset);

  Controller_IMP_1 M2 
    (Ready, Flush, Load_words, Shift, Add_shift, Done, word1, word2, multiplier, Start, clock, reset);
endmodule

module Controller_IMP_1
  (Ready, Flush, Load_words, Shift, Add_shift, Done, word1, word2, multiplier, Start, clock, reset);
  parameter 				L_word = 4;
  parameter				L_state = 4;
  output 					Ready, Flush, Load_words, Shift, Add_shift, Done;
  input 		[L_word -1:0] 		word1, word2, multiplier;
  input 					Start, clock, reset;

  reg 		[L_state -1: 0] 		state, next_state;
  reg 					Ready, Flush, Load_words, Shift, Add_shift, Done;
  integer k;
  wire 					Empty = (word1 == 0 || word2 == 0);          
  always  begin: Main_Block  
    @ (posedge clock or posedge reset) 			 
    if (reset) begin Clear_Regs;  disable Main_Block; end

    else if (Start != 1) begin: Idling
      Flush <= 0; Ready <= 1; 
    end  // Idling

    else if (Start && Empty) begin: Early_Terminate
     Flush <= 1; Ready <= 0; Done <= 0;
      @ (posedge clock or posedge reset) 
      if (reset) begin Clear_Regs;  disable Main_Block; end
      else begin 
        Flush <= 0; Ready <= 1;  Done <= 1;
      end 
    end  // Early_Terminate

    else if (Start) begin: Load_and_Multiply      
      Ready <= 0; Flush  <= 0; Load_words <= 1; Done <= 0;Shift <= 0; 
      Add_shift <= 0; 
      @ (posedge clock or posedge reset) 			 
      if (reset) begin Clear_Regs; disable Main_Block; end
      else begin // not reset						 
        Ready <= 0;
        Load_words <= 0; 
        if (word2[0]) Add_shift <= 1; else Shift <= 1; 
        for (k = 0; k <= L_word -1; k = k+1)  	
	 	
          @ (posedge clock or posedge reset) 
          if (reset) begin Clear_Regs; disable Main_Block; end
          else begin // multiple cycles
            Shift <= 0; 
            Add_shift <= 0;  
            if (multiplier == 1) begin Ready <= 1; end
            else if (multiplier[1]) Add_shift <= 1; 
            else Shift <= 1;  // Notice use of multiplier[1]
          end // multiple cycles
           Done <=1;
        end // not reset
      end  // Load_and_Multiply
  end // Main_Block

  task Clear_Regs;
    begin
      Ready <= 0; Flush <= 0; Load_words <= 0; Done <= 0; Shift <= 0; Add_shift <= 0; 
    end
  endtask
endmodule

module Datapath_Unit_IMP_1 
  (product, multiplier, word1, word2, Flush, Load_words, Shift, Add_shift, clock, reset);
  parameter 			L_word = 4;
  output 		[2*L_word -1: 0] 	product;
  output 		[L_word -1: 0] 	multiplier;
  input 		[L_word -1: 0] 	word1, word2;
  input 				Flush, Load_words, Shift, Add_shift, clock, reset;
  reg 		[2*L_word -1: 0] 	product;
  reg 		[2*L_word -1: 0] 	multiplicand;
  reg 		[L_word -1: 0]  	multiplier;

// Datapath Operations

  always @ (posedge clock or posedge reset) begin
    if (reset) begin multiplier <= 0; multiplicand <= 0; product <= 0; end
    else begin 
      if (Flush) product <= 0;  
      else if (Load_words == 1)  begin 
        multiplicand <= word1;
        multiplier <= word2; 
        product <= 0; end
      else if (Shift) begin 
        multiplier <= multiplier >> 1; 
        multiplicand <= multiplicand << 1; end
      else if (Add_shift) begin 
        multiplier <= multiplier >> 1; 
        multiplicand <= multiplicand << 1;    
        product <= product + multiplicand; end
    end 
  end
endmodule

 
module test_Multiplier_IMP_1 ();  
  parameter 			L_word = 4;    
  wire 				[2*L_word-1: 0] 	product;		 
  wire 				Ready;
  integer 				word1, word2;     // multiplicand, multiplier
  reg 				Start, clock, reset;
  reg				reset_flag;
  Multiplier_IMP_1 M1 (product, Ready, Done, word1, word2, Start, clock, reset);

// Exhaustive Testbench
  reg 		[2*L_word-1: 0] 	expected_value;		 
  wire 				code_error;
//initial #1600 $finish;
 initial #80000 $finish;		// Timeout
assign code_error = ((!Start) && Ready && (M1.M2.Done == 1))? |(expected_value ^ product) : 0;

  always @(posedge clock or posedge reset) if (reset) reset_flag = 1; else if (Start & Ready & reset_flag && !M1.M2.Done) reset_flag <= 0;

  always @ (posedge clock or posedge reset)  // Compare product with expected value
    if (reset) expected_value = 0; else if  ((reset_flag && Start && Ready && !reset) || (Start && Ready && M1.M2.Done && !reset) ) begin  
      #1  
      expected_value = word2 * word1;
      //expected_value = word2 * word1 + 1; // Use to check error detection
  
    end 

 initial fork  begin #43600 Start =1; word2 = 9; end

# 43700 Start = 0; 
join

initial begin #15400 reset =1; # 20 reset = 0; end
initial begin #28800 reset =1; # 60 reset = 0; end
//initial begin #29850 Start = 1; #800 Start = 0; end

  //initial begin #321 Start = 1; #100 Start = 0; end

  initial begin clock <= 0; forever #10 clock <= ~clock; end
  initial begin	// Exhaustive patterns 
    #2 reset  = 1;
    #75 reset = 0;
  end
initial begin
    for (word1 = 0; word1 <= 15; word1 = word1 +1) begin
    for (word2 = 0; word2 <= 15; word2 = word2 +1) begin


   // for (word1 = 250; word1 <= 255; word1 = word1 +1) begin
//    for (word2 = 10; word2 <= 255; word2 = word2 +1) begin
      Start = 0; #40 Start= 1;
      #20 Start = 0; 
      #200;
    end  // word2
    #140;
    end  //word1
  end // initial
endmodule



