module decimator_3 (data_out, data_in, hold, load, clock, reset);
  parameter 	word_length = 8;
  parameter 	latency = 4;
  output		[(word_length*latency) -1: 0] 	data_out;
  input		[word_length-1:0]			data_in;
  input						hold;
  input						load;
  input						clock;
  input						reset;

  reg		[(word_length*latency) -1: 0] 	Shft_Reg;	// Shift reg
  reg		[(word_length*latency) -1: 0] 	Int_Reg;	// Integrator reg
  reg		[(word_length*latency) -1: 0] 	Decim_Reg;	// Decimation reg

  always @ (posedge clock)
    if (reset) begin
      Shft_Reg <= 0;
      Int_Reg <= 0;
    end
    else if (load) begin
      Shft_Reg[(word_length * latency) -1: (word_length*(latency-1))] <= data_in;
      Int_Reg <= Shft_Reg;
    end
    else begin
      Shft_Reg <= {data_in, Shft_Reg[(word_length*latency)-1: word_length]};
      Int_Reg <= Int_Reg;
    end

  always @ (posedge clock)
    if (reset) Decim_Reg <= 0;
    else if (hold) Decim_Reg <= Decim_Reg;
    else Decim_Reg <= Int_Reg;

  assign data_out = Decim_Reg;

endmodule

