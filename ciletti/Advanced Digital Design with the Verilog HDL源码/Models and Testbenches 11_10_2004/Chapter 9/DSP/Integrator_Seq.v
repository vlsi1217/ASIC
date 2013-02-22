module Integrator_Seq (data_out, data_in, hold, LSB_flag, clock, reset);
  parameter	word_length = 8;
  parameter	latency = 4;
  output		[word_length -1: 0] 		data_out;
  input		[word_length -1: 0] 		data_in;
  input						hold, LSB_flag, clock, reset;
  reg		[(word_length * latency) -1: 0]	Shft_Reg;
  reg						carry;
  wire		[word_length: 0]			sum;

  always @ (posedge clock) begin
    if (reset) begin	Shft_Reg <= 0;
carry <= 0;
		    end 
		    else if (hold) begin
		      Shft_Reg <= Shft_Reg;
		      carry <= carry;
		    end
		    else begin
		      Shft_Reg <= {Shft_Reg[word_length*(latency -1) -1: 0], sum[word_length-1: 0]};
		      carry <= sum[word_length];
		    end
		  end
		
		  assign sum = data_in + Shft_Reg[(latency * word_length) -1: (latency -1)*word_length] 
		    + (carry & (~LSB_flag));

		  assign data_out = Shft_Reg[(latency * word_length) -1: (latency -1)*word_length];
		endmodule
