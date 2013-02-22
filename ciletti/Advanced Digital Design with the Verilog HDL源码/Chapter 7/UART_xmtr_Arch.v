module UART_Transmitter_Arch 
  (Serial_out, Data_Bus, Byte_ready, Load_XMT_datareg, T_byte, Clock, reset_);
  parameter	word_size = 8;			// Size of data word, e.g. 8 bits
  parameter	one_hot_count = 3;		// Number of one-hot states 
  parameter	state_count = one_hot_count;	// Number of bits in state register
  parameter	size_bit_count = 3;		// Size of the bit counter, e.g. 4 
					// Must count to word_size + 1
  parameter	idle = 3'b001;			// one-hot state encoding 
  parameter	waiting = 3'b010;
  parameter	sending = 3'b100; 
  parameter	all_ones = 9'b1_1111_1111;	// Word + 1 extra bit

  output 			Serial_out;		// Serial output to data channel
  input 	[word_size - 1 : 0] Data_Bus;		// Host data bus containing data word
  input			Byte_ready; 		// Used by host to signal ready
  input			Load_XMT_datareg;	// Used by host to load the data register
  input			T_byte;			// Used by host to signal start of transmission
  input			Clock;			// Bit clock of the transmitter
  input			reset_;			// Resets internal registers, loads the
						// XMT_shftreg with ones

  reg [word_size -1: 0] 	XMT_datareg;		// Transmit Data Register
  reg [word_size: 0] 	XMT_shftreg;		// Transmit Shift Register: {data, start bit}
  reg 			Load_XMT_shftreg;	// Flag to load the XMT_shftreg
  reg [state_count -1: 0] 	state, next_state;		// State machine controller
  reg [size_bit_count: 0] 	bit_count;		// Counts the bits that are transmitted
  reg			clear;			// Clears bit_count after last bit is sent
  reg			shift;			// Causes shift of data in XMT_shftreg
  reg			start;			// Signals start of transmission

  assign Serial_out = XMT_shftreg[0];		// LSB of shift register 

  always @ (state or Byte_ready or bit_count or T_byte) begin: Output_and_next_state
    Load_XMT_shftreg = 0;
    clear = 0;
    shift = 0;
    start = 0;
    next_state = state;
    case (state)
      idle:		if (Byte_ready == 1) begin 
	  	  Load_XMT_shftreg = 1; 
		  next_state = waiting;  		
		end 

      waiting:	if (T_byte == 1) 	begin
		  start = 1;
	  	  next_state = sending;			
		end 

      sending:	if (bit_count != word_size + 1) 
  shift = 1;
		else begin
		  clear = 1;
		  next_state = idle;
		end

      default:	next_state = idle;
    endcase
  end
 
always @ (posedge Clock or negedge reset_) begin: State_Transitions
    if (reset_ == 0)  state <= idle;  else state <= next_state;
end

  always @ (posedge Clock or negedge reset_) begin: Register_Transfers
    if (reset_ == 0) begin
      XMT_shftreg <= all_ones; 
      bit_count <= 0;
    end
    else begin
      if (Load_XMT_datareg == 1) 
          XMT_datareg <= Data_Bus;				// Get the data bus 

      if (Load_XMT_shftreg == 1) 
          XMT_shftreg <= {XMT_datareg,1'b1};  			// Load shift reg, 
							// insert stop bit 
      if (start == 1) 
          XMT_shftreg[0] <= 0; 				// Signal start of transmission

      if (clear == 1) bit_count <= 0; 
      else if (shift == 1) bit_count <= bit_count + 1;
 
      if (shift == 1) 
          XMT_shftreg <= {1'b1, XMT_shftreg[word_size:1]}; 	// Shift right, fill with 1's
     end
   end
endmodule

module Test_uart8();
  parameter word_size = 8;
  reg [word_size-1:0] Data_Bus;
  reg Byte_ready, Load_XMT_datareg, T_byte, reset_;
  wire Set_Byte_ready, Serial_out;
  wire Clock;

  reg [5:0] k;
  reg [word_size+1:0] Serial_test;

  UART_Transmitter_Arch M0 
  (Serial_out, Data_Bus, Byte_ready, Load_XMT_datareg, T_byte, Clock, reset_);

  defparam M2.Latency = 0;
  defparam M2.Offset = 5;
  defparam M2.Pulse_Width = 5;

  Clock_Prog  M2 (Clock);

  initial #200 $finish;
  initial begin #5 reset_ =0;#5 reset_ =1 ; end
  initial begin #40 Byte_ready = 1; #10 Byte_ready = 0; end
  initial begin #10 Load_XMT_datareg = 0; #10 Load_XMT_datareg = 1; #10 Load_XMT_datareg = 0; end
  initial begin #90 Load_XMT_datareg=1; #10 Load_XMT_datareg = 0;end
  initial begin #120 Load_XMT_datareg = 1; #10 Load_XMT_datareg = 0; end

always @ (posedge Clock or negedge reset_) 
  if (reset_ == 0) Serial_test <= 0; 
  else Serial_test <= {Serial_out, Serial_test[word_size+1 : 1]};

  wire [word_size-1:0] sent_word = Serial_test[word_size:1];

  initial begin 
    #80 T_byte = 1;
    forever begin 
      #10 T_byte = ~T_byte;#120T_byte = ~T_byte;
    end
   end
  
  initial begin
    #5 Data_Bus <= 8'b1010_0111;  // ha6
    #80 Data_Bus <= 8'b0001_1010; // h1a
    #40 Data_Bus <= 8'hb4;
  end
endmodule


