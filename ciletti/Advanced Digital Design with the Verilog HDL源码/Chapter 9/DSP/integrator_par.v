module Integrator_Par (data_out, data_in, hold, clock, reset);
parameter	word_length = 8;
output		[word_length-1: 0] data_out;
input		[word_length-1: 0] data_in;
input		hold, clock, reset;
reg		data_out;

always @ (posedge clock) begin
  if (reset) data_out <= 0;
  else if (hold) data_out <= data_out;
  else data_out <= data_out + data_in;
end
endmodule

