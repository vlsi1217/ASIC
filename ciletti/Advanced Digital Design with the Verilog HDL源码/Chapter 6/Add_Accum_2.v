module Add_Accum_2 (accum, overflow, data, enable, clk, reset_b);
  output [3: 0]	accum;
  output 		overflow;
  input [3: 0] 	data;
  input 		enable, clk, reset_b;
  reg 		accum;
  wire [3:0] 	sum;
  assign		{overflow, sum} = accum + data;

  always @ (posedge clk or negedge reset_b)
    if (reset_b == 0) accum <= 0; 
    else if (enable) accum <=  sum;
endmodule

