module Add_Accum_1 (accum, overflow, data, enable, clk, reset_b);
  output [3: 0]	accum;
  output 		overflow;
  input [3: 0] 	data;
  input 		enable, clk, reset_b;
  reg 		accum, overflow;

  always @ (posedge clk or negedge reset_b)
    if (reset_b == 0) begin accum <= 0; overflow <= 0; end 
    else if (enable) {overflow, accum} <= accum + data;
endmodule

