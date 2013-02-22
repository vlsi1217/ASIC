module res_share (y_out, sel, data_a, data_b, accum);
  output 		[4: 0]	y_out;
  input		[3: 0]	data_a, data_b, accum;
  input			sel;

  assign y_out = data_a + (sel ? accum : data_b);
endmodule

