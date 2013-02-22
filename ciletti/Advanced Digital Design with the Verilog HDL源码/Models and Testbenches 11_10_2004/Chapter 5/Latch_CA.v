module Latch_CA (q_out, data_in, enable);
  output 		q_out;
  input 		data_in, enable;

  assign q_out = enable ? data_in : q_out;
endmodule

