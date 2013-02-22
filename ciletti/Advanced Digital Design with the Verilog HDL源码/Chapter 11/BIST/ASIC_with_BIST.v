module ASIC_with_BIST (sum, c_out, a, b, c_in, done, error, test_mode, clock, reset);
  parameter			size = 4;
  output		[size -1: 0] 	sum;		//  ASIC interface I/O
  output				c_out;
  input		[size -1: 0]	a, b;
  input				c_in;
  
  output				done, error; 	 
  input				test_mode, clock, reset;	
  wire		[size -1: 0] 	ASIC_sum;		
  wire				ASIC_c_out;
  wire		[size -1: 0]	LFSR_a, LFSR_b;
  wire				LFSR_c_in;
  wire		[size -1: 0] 	mux_a, mux_b;
  wire				mux_c_in;		
  wire 				error, enable;
  wire 		[1: size +1]	signature;

  assign 	{sum, c_out} = (test_mode) ? 'bz : {ASIC_sum, ASIC_c_out};
  assign 	{mux_a, mux_b, mux_c_in} = (enable == 0) ? {a, b, c_in} : {LFSR_a, LFSR_b, LFSR_c_in};

  ASIC M0 (
    .sum (ASIC_sum),
    .c_out (ASIC_c_out), 
    .a (mux_a),
    .b (mux_b),
    .c_in (mux_c_in));
 
  Pattern_Generator M1 (
    .a (LFSR_a),
    .b (LFSR_b),
    .c_in (LFSR_c_in),
    .enable (enable),
    .clock (clock),
    .reset (reset)
    );

  Response_Analyzer M2 (
    .MISR_Y (signature),
    . R_in ({ASIC_sum, ASIC_c_out}), 
    .enable (enable), 
    .clock (clock),
    .reset (reset));

  BIST_Control_Unit  M3 (done, error, enable, signature, test_mode, clock, reset);


endmodule

module ASIC (sum , c_out, a, b, c_in);
  parameter	size = 4;
  output		[size -1: 0]	sum;
  output				c_out;
  input		[size -1: 0]	a, b;
  input				c_in;

  assign {c_out, sum} = a + b + c_in;
endmodule

module Response_Analyzer (MISR_Y, R_in, enable, clock, reset);
  parameter			size = 5;	
  output		[1: size]		MISR_Y;
  input		[1: size]		R_in;
  input				enable, clock, reset;
  reg 		[1: size ]		MISR_Y;

  always @  (posedge clock)
    if (reset == 0) MISR_Y <= 0;
    else if (enable) begin
      MISR_Y [2: size ] <= MISR_Y [1: size -1] ^ R_in [2: size];
      MISR_Y [1] <= R_in[1] ^ MISR_Y[size] ^MISR_Y[1];
    end
endmodule

module Pattern_Generator (a, b, c_in, enable, clock, reset);
  parameter 			size = 4;
  parameter 			Length = 9;
  parameter 			initial_state = 9'b1_1111_1111;	// Arbitrary initial state
  parameter	[1: Length] 	Tap_Coefficient = 9'b1_0000_1000; 
  output 		[size -1: 0]	a, b;
  output				c_in;

  input 				enable, clock, reset;
  reg 		[1: Length] 	LFSR_Y;
  integer				k;

  assign a = LFSR_Y[2: size+1];
  assign b = LFSR_Y[size + 2: Length];
  assign c_in = LFSR_Y[1];

  always @  (posedge clock)
    if (!reset) LFSR_Y <= initial_state;	 
      else if (enable) begin
        for (k = 2; k <= Length; k = k + 1)
          LFSR_Y[k] <= Tap_Coefficient[Length-k+1] 
            ? LFSR_Y[k-1] ^ LFSR_Y[Length] : LFSR_Y[k-1];	 
          LFSR_Y[1] <= LFSR_Y[Length];
      end
 endmodule       

module BIST_Control_Unit  (done, error, enable, signature, test_mode, clock, reset);
  parameter		sig_size = 5;
  parameter		c_size = 10;
  parameter		size = 3;
  parameter 		c_max = 510;	
  parameter		stored_pattern = 5'h1a;  //  signature if fault-free
  parameter		S_idle = 0,
			S_test = 1,
			S_compare = 2,
			S_done = 3,
			S_error = 4;
  output			done, error, enable;
  input	[1: sig_size]	signature;
  input			test_mode, clock, reset;
  reg			done, error, enable;

  reg	[size -1: 0]	state, next_state;
  reg	[c_size -1: 0]	count;
  wire			match = (signature == stored_pattern);

  always @ (posedge clock) if (reset == 0) count <= 0; else if (count == c_max) count <= 0;
    else if (enable) count <= count + 1; 
  always @ (posedge clock)
    if (reset == 0) state <= S_idle;
    else state <= next_state;

always @ (state or test_mode or count or match) begin
    done = 0;
    error = 0;
    enable = 0; 
    next_state = S_error;
    case (state)
      S_idle:	if (test_mode) next_state = S_test; else next_state = S_idle;
      S_test:	begin enable = 1; if (count == c_max -1) next_state = S_compare; 
else next_state = S_test; end
      S_compare:	if (match) next_state = S_done; 
else next_state = S_error; 
      S_done:	begin done = 1; next_state = S_idle; end
      S_error:	begin done = 1; error = 1; end
    endcase
  end
endmodule


