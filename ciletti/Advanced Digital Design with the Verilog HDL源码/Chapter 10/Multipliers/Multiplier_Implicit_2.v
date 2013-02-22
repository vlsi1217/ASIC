`define 		word_size 		4
module Multiplier_IMP_2 (product, Ready, Done, word1, word2, Start, clock, reset);

  parameter 				L_word = `word_size;
  output 		[2*L_word -1: 0] 		product;
  output 					Ready, Done;
  input 		[L_word -1: 0] 		word1, word2;
  input 					Start, clock, reset;
  wire 		[L_word -1:0] 		multiplier;
  wire 					Flush, Load_words, Load_multiplier,  Load_multiplicand, Shift, Add_shift;

  Datapath_Unit_IMP_2 M1 
    (
    product, multiplier, word1, word2, Flush, Load_words, Load_multiplier,  Load_multiplicand, 
    Shift, Add_shift, clock, reset
    );

  Controller_IMP_2 M2 
    (
    Ready, Flush, Load_words, Load_multiplier,  Load_multiplicand, 
    Shift, Add_shift, Done, word1, word2, multiplier, Start, clock, reset
    );
endmodule

module Controller_IMP_2  
  (
  Ready, Flush, Load_words, Load_multiplier,  Load_multiplicand, 
  Shift, Add_shift, Done, word1, word2, multiplier, Start, clock, reset
  );
  parameter 				L_word = `word_size;
  output 					Ready, Flush;
  output					Load_words, Load_multiplier,  Load_multiplicand;
  output  				Shift, Add_shift, Done;
  input 		[L_word -1:0] 		word1, word2, multiplier;
  input 					Start, clock, reset;

  reg 					Ready, Flush, Load_words, Load_multiplier,  Load_multiplicand;
  reg					Shift, Add_shift, Done;
  integer 				k;
  wire 					Empty = (word1 == 0 || word2 == 0);       

  always @ (posedge clock or posedge reset) begin: Main_Block  
		 
    if (reset) begin Clear_Regs;  disable Main_Block; end
    else if (Start != 1) begin: Idling
      Flush <= 0; Ready <= 1; 
      Load_words <= 0; Load_multiplier <= 0; Load_multiplicand <= 0; 
      Shift <= 0; Add_shift <= 0;
    end  // Idling
 
    else if (Start && Empty) begin: Early_Terminate
     Flush <= 1; Ready <= 0; Done <= 0;
      @ (posedge clock or posedge reset) 
      if (reset) begin Clear_Regs;  disable Main_Block; end
      else begin 
        Flush <= 0; Ready <= 1;  Done <= 1;
      end 
    end  // Early_Terminate

    else if (Start && (word1== 1)) begin: Load_Multiplier_Direct
      Ready <= 0; Done <= 0;
      Load_multiplier <= 1; 
      @ (posedge clock or posedge reset) 
        if (reset) begin Clear_Regs; disable Main_Block; end
        else begin Ready <= 1; Done <= 1; end
    end

    else if (Start && (word2== 1)) begin: Load_Multiplicand_Direct
      Ready <= 0; Done <= 0;
      Load_multiplicand <= 1; 
      @ (posedge clock or posedge reset) 
        if (reset) begin Clear_Regs; disable Main_Block; end
        else begin Ready <= 1; Done <= 1; end
    end

    else if (Start ) begin: Load_and_Multiply      
      Ready <= 0; Done <= 0; Flush  <= 0; Load_words <= 1;
      @ (posedge clock or posedge reset) 			 
      if (reset) begin Clear_Regs; disable Main_Block; end
      else begin: Not_Reset					 
        Load_words <= 0; 
        if (word2[0]) Add_shift <= 1; else Shift <= 1; 
        begin: Wrapper
          forever begin: Multiplier_Loop
            @ (posedge clock or posedge reset) 
              if (reset) begin Clear_Regs; disable Main_Block; end
              else begin // multiple cycles
                Shift <= 0; 
                Add_shift <= 0;  
                if (multiplier == 1) begin Done <= 1;  
                  @ (posedge clock or posedge reset) 
                  if (reset) begin Clear_Regs; disable Main_Block; end
                  else disable Wrapper;
                end
                else if (multiplier[1]) Add_shift <= 1; 
                else Shift <= 1;  // Notice use of multiplier[1]
              end // multiple cycles
          end // Multiplier_Loop
        end // Wrapper
        Ready <= 1;
      end // Not_Reset
    end  // Load_and_Multiply
  end // Main_Block
  
  task Clear_Regs;
    begin
      Flush <= 0; Ready <= 0; Done <= 0; 
      Load_words <= 0; Load_multiplier <= 0; Load_multiplicand <= 0; 
      Shift <= 0; Add_shift <= 0; 
    end
  endtask 
endmodule
module Datapath_Unit_IMP_2 
  (
   product, multiplier, word1, word2, Flush, Load_words, Load_multiplier,  Load_multiplicand, 
   Shift, Add_shift, clock, reset
  );
  parameter 			L_word = `word_size;
  output 		[2*L_word -1: 0] 	product;
  output 		[L_word -1: 0] 	multiplier;
  input 		[L_word -1: 0] 	word1, word2;
  input 				Flush, Load_words, Load_multiplier,  Load_multiplicand, Shift, Add_shift, clock, reset;
  reg 		[2*L_word -1: 0] 	product;
  reg 		[2*L_word -1: 0] 	multiplicand;
  reg 		[L_word -1: 0]  	multiplier;

// Datapath Operations
always @ (posedge clock or posedge reset) 
    if (reset) begin multiplier <= 0; multiplicand <= 0; product <= 0; end
    else begin 
      if (Flush) product <= 0;  
      else if (Load_words == 1)  begin 
        multiplicand <= word1;
        multiplier <= word2; 
        product <= 0; end
     else if (Load_multiplicand) begin
        product <= word1; end
    else if (Load_multiplier) begin
        product <= word2; end
    else if (Shift) begin 
        multiplier <= multiplier >> 1; 
        multiplicand <= multiplicand << 1; end
    else if (Add_shift) begin 
        multiplier <= multiplier >> 1; 
        multiplicand <= multiplicand << 1;    
        product <= product + multiplicand; end
    end 
endmodule 

  

module test_Multiplier_IMP_2();  //  CHECK THIS OUT
  parameter 			L_word = `word_size;    
  wire 				[2*L_word-1: 0] 	product;		 
  wire 				Ready;
  integer 				word1, word2;     // multiplicand, multiplier
  reg 				Start, clock, reset;
  reg				reset_flag;
  Multiplier_IMP_2 M1 (product, Ready, Done, word1, word2, Start, clock, reset);

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
initial begin #28800 reset =1; # 165 /*60*/
reset = 0; end		 

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


