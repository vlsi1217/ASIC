module Gap_finder(Gap, Data, clk, rst);
output 	[3: 0]	Gap;
input	[15: 0]	Data;
input 		clk, rst;

reg	[3: 0]	k, tmp, Gap;				// datapath registers
reg	[1: 0]	state, next_state;
wire		Bit = Data[k];
reg		flush_tmp, incr_tmp, store_tmp, incr_k;	// datapath controls

parameter		s_0 		= 2'b00;		// states
parameter		s_1 		= 2'b01;
parameter		s_2 		= 2'b10;
parameter		s_done 	= 2'b11;

// State transitions

always @ (posedge clk)
	// YOUR CODE (use active-high synchronous reset)

// Combinational logic for next state and outputs

always @ (state or Bit or k) begin  	// Must have k to see 16'hffff
					// Try simulating without it too
  next_state = state;			// Remain until conditions are met
  incr_k = 0; 				// Set all variables to 0 on entry 
  incr_tmp = 0;				// to avoid bogus latches
  store_tmp = 0;
  flush_tmp = 0;

  case (state)
	// YOUR CODE for next state and outputs to control the datapath
  endcase
end

// Edge-sensitive behavior (i.e.,  synchronized) for datapath operations
always @ (posedge clk)
  if (rst == 1) begin k <= 0; Gap <= 0; tmp <= 0; end
  else begin
	// YOUR CODE for register operations controlled by the state machine
 
  end 
endmodule

 module annotate_Gap_finder ();		// Annotate the clock parameters
  defparam t_Gap_finder.M2.Latency = 10;
  defparam t_Gap_finder.M2.Offset = 5;
  defparam t_Gap_finder.M2.Pulse_Width = 5;
endmodule

module t_Gap_finder  ();			 
  reg	[15: 0]	Data;
  reg 			rst;
  wire	[3: 0]	Gap;

  Gap_finder	M1 (Gap, Data, clk, rst);
  Clock_Prog 	M2 (clk);	

  initial #2200 $finish;

  initial begin 	// expect Gap = 14
    #20 rst = 1;
    #5 Data = 16'b1000_0000_0000_0001;
    #5 rst = 0;
  end

  initial begin 	// expect Gap = 0
    #200 rst = 1;
    #5 Data = 16'hffff;
    #5 rst = 0;
  end
  initial begin 	// expect gap = 0
    #400 rst = 1;
    #5 Data = 16'h0000;
    #5 rst = 0;
  end
  initial begin 	// expect gap = 0  
    #600 rst = 1;
    #5 Data = 16'hf000;
    #5 rst = 0;
  end
  initial begin 	// expect gap = 0 
    #800 rst = 1;
    #5 Data = 16'h0f00;
    #5 rst = 0;
  end
  initial begin 	// expect gap = 8 
    #1000 rst = 1;
    #5 Data = 16'hf00f;
    #5 rst = 0;
  end
  initial begin 	// expect Gap = 0
    #1200 rst = 1;
    #5 Data = 16'haaaa;
    #5 rst = 0;
  end
  initial begin 	// expect gap = 1
    #1400 rst = 1;
    #5 Data = 16'h5555;
    #5 rst = 0;
  end
  initial begin 	// expect Gap = 4 (decreasing gap size)
    #1600 rst = 1;
    #5 Data = 16'b0100_0010_0010_0101;
    #5 rst = 0;
  end
  initial begin 	// expect Gap = 4 (increasing gap size)
    #1800 rst = 1;
    #5 Data = 16'b1010_0100_0100_0010;
    #5 rst = 0;
  end
endmodule;


