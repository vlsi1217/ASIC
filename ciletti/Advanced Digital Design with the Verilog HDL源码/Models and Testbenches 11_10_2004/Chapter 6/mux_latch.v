module mux_latch (y_out, sel_a, sel_b, data_a, data_b);
  output 		y_out; 
  input 		sel_a, sel_b, data_a, data_b;
  reg 		y_out;

  always @ ( sel_a or sel_b or data_a or data_b)
  case ({sel_a, sel_b})
    2'b10: y_out = data_a;
    2'b01: y_out = data_b;
  endcase
endmodule

