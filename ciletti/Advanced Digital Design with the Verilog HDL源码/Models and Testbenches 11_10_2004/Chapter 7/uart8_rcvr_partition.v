// modified 3-26-2001 for blocked assignments at combinational logic.

module UART8_rcvr_partition   (RCV_datareg, read_not_ready_out, Error1, Error2, Serial_in, 
  read_not_ready_in, Sample_clk, reset_);

  // partitioned UART receiver
  // Sample_clk is 8x Bit_clk

  parameter		word_size		 = 8;	
  parameter		half_word 		= word_size / 2;	
  parameter		Num_counter_bits	= 4;	// Must hold count of word_size
  parameter		Num_state_bits 		= 2;	// Number of bits in state
  parameter		idle			= 2'b00;
  parameter		starting			= 2'b01;
  parameter		receiving		= 2'b10;

  output 	[word_size -1: 0] 	RCV_datareg;
  output 			read_not_ready_out, 	// Handshake to host processor
			Error1, 			// Host not ready error
			Error2;			// Data_in missing stop bit 

 input			Serial_in,  		// Serial data input
			Sample_clk, 		// Clock to sample serial data
			reset_, 			// Active-low reset
			read_not_ready_in;	// Status bit from host processor


  wire [Num_counter_bits -1:0] 	Sample_counter;
  wire [Num_counter_bits:0] 	Bit_counter;			 
  wire [Num_state_bits -1:0] 	state, next_state;		 
   
controller_part M2  
  (next_state, shift, load, read_not_ready_out, Error1, Error2, inc_Sample_counter, 
   inc_Bit_counter, clr_Bit_counter, clr_Sample_counter, state, Sample_counter, Bit_counter, 
   Serial_in, read_not_ready_in);

state_transition_part M1  
  (RCV_datareg, Sample_counter, Bit_counter, state, next_state, clr_Sample_counter, 
    inc_Sample_counter, clr_Bit_counter, inc_Bit_counter, shift, load, Serial_in, Sample_clk, reset_);

endmodule

module controller_part (next_state, shift, load, read_not_ready_out, Error1, Error2, inc_Sample_counter, 
  inc_Bit_counter, clr_Bit_counter, clr_Sample_counter, state, Sample_counter, Bit_counter, 
 Serial_in, read_not_ready_in);

  parameter		word_size 		= 8;	
  parameter		half_word 		= word_size / 2;	
  parameter		Num_counter_bits 	= 4;	// Must hold count of word_size
  parameter		Num_state_bits 		= 2;	// Number of bits in state
  parameter		idle			= 2'b00;
  parameter		starting			= 2'b01;
  parameter		receiving		= 2'b10;
		 
  output [Num_state_bits -1:0] next_state;
  output shift, load, inc_Sample_counter,  inc_Bit_counter, clr_Bit_counter, clr_Sample_counter;
  output read_not_ready_out, Error1, Error2;

  input [Num_state_bits -1:0] state;				
  input [Num_counter_bits -1:0] Sample_counter;
  input [Num_counter_bits:0] Bit_counter;	
  input Serial_in, read_not_ready_in;

  reg next_state;
  reg inc_Sample_counter, inc_Bit_counter, clr_Bit_counter, clr_Sample_counter;
  reg shift, load,   read_not_ready_out, Error1, Error2;

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
endmodule

module state_transition_part (RCV_datareg, Sample_counter, Bit_counter, state, next_state, clr_Sample_counter, inc_Sample_counter, clr_Bit_counter, inc_Bit_counter, shift, load, Serial_in, Sample_clk, reset_);
  parameter		word_size = 8;	
  parameter		half_word = word_size / 2;	
  parameter		Num_counter_bits = 4;	// Must hold count of word_size
  parameter		Num_state_bits = 2;	// Number of bits in state
  parameter		idle		= 2'b00;
  parameter		starting	= 2'b01;
  parameter		receiving	= 2'b10;

  output [word_size -1: 0] RCV_datareg;
  output  [Num_counter_bits -1:0] Sample_counter;
  output [Num_counter_bits:0] Bit_counter;	
  output [Num_state_bits -1:0] state;

  input [Num_state_bits -1:0] next_state;
  input Serial_in;
  input inc_Sample_counter, inc_Bit_counter, clr_Bit_counter, clr_Sample_counter, shift, load;
  input Sample_clk, reset_;
		 
  reg 			Sample_counter, Bit_counter;
  reg [word_size-1:0] 	RCV_shftreg, RCV_datareg;
  reg 			state;		 
  
 
// state_transitions_and_datapath_register_transfers
 
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




