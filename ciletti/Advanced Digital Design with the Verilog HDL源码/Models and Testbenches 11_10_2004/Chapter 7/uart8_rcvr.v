// modified 3-26-2001 for blocked assignments at combinational logic.
module UART8_Receiver 
  (RCV_datareg, read_not_ready_out, Error1, Error2, Serial_in, read_not_ready_in, Sample_clk, reset_);
   // Sample_clk is 8x Bit_clk

  parameter	word_size 	= 8;	
  parameter	half_word	 = word_size / 2;	
  parameter	Num_counter_bits = 4;		// Must hold count of word_size
  parameter	Num_state_bits	 = 2;		// Number of bits in state
  parameter	idle		= 2'b00;
  parameter	starting		= 2'b01;
  parameter	receiving	= 2'b10;

  output 		[word_size-1:0] 		RCV_datareg;
  output 					read_not_ready_out, 
					Error1, Error2;
  input		Serial_in,  
		Sample_clk, 
		reset_, 
		read_not_ready_in;


  reg 					RCV_datareg;
  reg 		[word_size-1:0] 		RCV_shftreg;
  reg		[Num_counter_bits -1:0] 	Sample_counter;
  reg 		[Num_counter_bits:0] 	Bit_counter;			 
  reg 		[Num_state_bits -1:0] 	state, next_state;		 
  reg 					inc_Bit_counter, clr_Bit_counter;
  reg					inc_Sample_counter, clr_Sample_counter;
  reg					shift, load, read_not_ready_out;	  reg					Error1, Error2;

//Combinational logic for next state and conditional outputs

  always @ (state or Serial_in or read_not_ready_in or Sample_counter or Bit_counter) begin
    read_not_ready_out = 0; 
    clr_Sample_counter = 0;
    clr_Bit_counter = 0;
    inc_Sample_counter = 0;
    inc_Bit_counter = 0;
    shift = 0;
    Error1 = 0;   
    Error2 = 0;
    load = 0;
    next_state = state;

    case (state) 
      idle:		if (Serial_in == 0) next_state = starting; 
		
     starting:	if (Serial_in == 1) begin
		  next_state = idle;
    		  clr_Sample_counter = 1;
    		end else 
   			    
		if (Sample_counter == half_word -1) begin
    		  next_state = receiving;
    		  clr_Sample_counter = 1;
    		end else inc_Sample_counter = 1; 
    				
    receiving:	if (Sample_counter < word_size-1) inc_Sample_counter = 1;
		else begin 
		  clr_Sample_counter = 1;
		  if (Bit_counter != word_size)  begin
      		    shift = 1;
		    inc_Bit_counter = 1;
		  end
		  else begin
		    next_state = idle;
      		    read_not_ready_out = 1; 
		    clr_Bit_counter = 1;
      		    if (read_not_ready_in == 1) Error1 = 1; 
		    else if (Serial_in == 0) Error2 = 1;
        		    else load = 1;
		  end
		end
	default:	next_state = idle;

    endcase 
  end

 // state_transitions_and_register_transfers
 
  always @ (posedge Sample_clk) begin
    if (reset_ == 0) begin			// synchronous reset_
      state <= idle; 
      Sample_counter <= 0;
      Bit_counter <= 0;
      RCV_datareg <= 0;
      RCV_shftreg <= 0;
    end
    else begin  
      state <= next_state;

      if (clr_Sample_counter == 1) Sample_counter <= 0; 
      else if (inc_Sample_counter == 1) Sample_counter <= Sample_counter + 1;

      if (clr_Bit_counter == 1) Bit_counter <= 0; 
      else if (inc_Bit_counter == 1) Bit_counter <= Bit_counter + 1;
      if (shift == 1) RCV_shftreg <= {Serial_in, RCV_shftreg[word_size-1:1]};
      if (load == 1) RCV_datareg <= RCV_shftreg;
    end   
  end 
 endmodule


module test_UART8_receiver();
  parameter	word_size = 8;
  parameter jump = 2*word_size;
  reg Serial_in;  
  reg reset_, read_not_ready_in;
  wire [word_size - 1:0] RCV_datareg;
  wire read_not_ready_out, Error1, Error2;

  UART8_Receiver 
  M1 (RCV_datareg, read_not_ready_out, Error1, Error2, Serial_in, read_not_ready_in, Sample_clk, reset_);

defparam M2.Latency = 0;
defparam M2.Offset = 1;
defparam M2.Pulse_Width = 1;
Clock_Prog M2 (Sample_clk);
//Clock_Gen #(1) M2 (Sample_clk);

initial #400 $finish;
initial begin #2 reset_ = 0; #2 reset_ = 1;end
initial begin #4 read_not_ready_in = 0; end  // change to 1 for test
initial begin   

#2 Serial_in = 1;		// stopped		
  #4 Serial_in = 0;	// start bit
  #jump Serial_in = 1;	// word: hb5
  #jump Serial_in = 0;
  #jump Serial_in = 1;
  #jump Serial_in = 0;
  #jump Serial_in = 1;
  #jump Serial_in = 1;
  #jump Serial_in = 0;
  #jump Serial_in = 1;	//parity bit
  #jump Serial_in = 1;  // stop bit


/*

#2 Serial_in = 1;		// stopped		
  #4 Serial_in = 0;	// start bit
  #jump Serial_in = 1;	// word: h55
  #jump Serial_in = 0;
  #jump Serial_in = 1;
  #jump Serial_in = 0;
  #jump Serial_in = 1;
  #jump Serial_in = 0;
  #jump Serial_in = 1;
  #jump Serial_in = 0;	//parity bit
  #jump Serial_in = 1;  // stop bit
*/
/*
  #2 Serial_in = 1;
  #6 Serial_in = 0;
  #22 Serial_in = 1;
  #38 Serial_in = 0;
  #54 Serial_in = 1;
  #70 Serial_in = 0;
  #86 Serial_in = 1;
  #118 Serial_in = 0;
  #134 Serial_in = 1;
  //#154 Serial_in = 0;	// error - missing stop bit

  #200 Serial_in = 0;
  #300 Serial_in = 1; */


end //join
endmodule
