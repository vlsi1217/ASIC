module Latch_Rbar_CA (q_out, data_in, enable, reset);
  output 		q_out;
  input 		data_in, enable, reset;

  assign q_out = !reset ? 0 : enable ? data_in : q_out;
endmodule

