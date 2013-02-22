module t_Integrator_Seq ();
  parameter	word_length = 8;
  parameter	latency = 4;
  wire		[word_length -1: 0] 		data_out;
  reg		[word_length -1: 0] 		data_in;
  reg						hold, LSB_flag, clock, reset;
  wire		[word_length: 0]			pre_sum;
  wire		[word_length-1: 0]		data_out1, data_out2;

//  assign		data_out2pre_sum = M1.Shft_Reg[(word_length*latency) -1: word_length*(latency -1)];
//assign		data_out1 = M1.Shft_Reg[word_length -1: 0];

 Integrator_Seq M1 (data_out, data_in, hold, LSB_flag, clock, reset);

initial #500 $finish;
 		initial begin reset = 1;  #10 reset = 0; #510 reset = 1; #10 reset = 0; end
  		initial begin clock = 0;   forever #5 clock = ~clock; end
   		initial begin 
		#50 data_in = 1;
		#0 forever @(negedge clock) data_in = data_in + 1;
		end
initial fork

#5 hold = 1;
#50 hold = 0; 
#180 hold = 1;
#5 LSB_flag = 0;


join

endmodule


