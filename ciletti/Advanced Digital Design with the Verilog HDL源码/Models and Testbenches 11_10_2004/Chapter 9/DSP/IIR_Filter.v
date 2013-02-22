module IIR_Filter_8 (Data_out, Data_in, clock, reset);
   // Eighth-order, Generic IIR Filter
  parameter	order = 8;
  parameter	word_size_in = 8;				 	 
  parameter	word_size_out = 2*word_size_in + 2;
  output		[word_size_out -1: 0] Data_out;
  input		[word_size_in-1: 0] Data_in;
  input		clock, reset;

  parameter 	b0 = 8'd7;	// Feedforward filter coefficients
  parameter	b1 = 0;
  parameter	b2 = 0;
  parameter	b3 = 0;
  parameter	b4 = 0;
  parameter	b5 = 0;
  parameter	b6 = 0;
  parameter	b7 = 0;
  parameter	b8 = 0;
/*
  parameter 	b0 = 8'd7;	// Feedforward filter coefficients
  parameter	b1 = 8'd17;
  parameter	b2 = 8'd32;
  parameter	b3 = 8'd46;
  parameter	b4 = 8'd52;
  parameter	b5 = 8'd46;
  parameter	b6 = 8'd32;
  parameter	b7 = 8'd17;
  parameter	b8 = 8'd7;
*/

  parameter	a1 = 8'd46; 	// Feedback filter coefficients
  parameter	a2 = 8'd32;
  parameter	a3 = 8'd17;
  parameter	a4 = 8'd0;
  parameter	a5 = 8'd17;
  parameter	a6 = 8'd32;
  parameter	a7 = 8'd46;
  parameter	a8 = 8'd52;

  reg		[word_size_in-1: 0] 	Samples_in [1: order];
  reg		[word_size_in-1: 0] 	Samples_out [1: order];
  wire 		[word_size_out -1: 0] 	Data_feedforward;
  wire 		[word_size_out -1: 0] 	Data_feedback;

  integer		k;

 assign Data_feedforward =	   b0 * Data_in
				+ b1 * Samples_in[1] 
+ b2 * Samples_in[2] 
+ b3 * Samples_in[3]
+ b4 * Samples_in[4]
+ b5 * Samples_in[5]
+ b6 * Samples_in[6]
+ b7 * Samples_in[7]
+ b8 * Samples_in[8];
 
  assign Data_feedback =	  	   a1 * Samples_out [1]
				+ a2 * Samples_out [2]
				+ a3 * Samples_out [3]
				+ a4 * Samples_out [4]
+ a5 * Samples_out [5]
				+ a6 * Samples_out [6]
				+ a7 * Samples_out [7]
				+ a8 * Samples_out [8];

  assign Data_out = Data_feedforward + Data_feedback;

  always @ (posedge clock) 
    if (reset == 1) for (k = 1; k <= order; k = k+1) begin
      Samples_in [k] <= 0;
      Samples_out [k] <= 0;
    end 
    else begin
      Samples_in [1] <= Data_in;
      Samples_out [1] <= Data_out;
      for (k = 2; k <= order; k = k+1) begin 
        Samples_in [k] <= Samples_in [k-1];  
	        Samples_out [k] <= Samples_out [k-1];
	      end
    end
endmodule

