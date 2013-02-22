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
module test_Add_Accum_both ();
  wire [3: 0] 	accum_1, accum_2;
  wire 		overflow_1, overflow_2;
  reg [3: 0] 	data;
  reg 		enable, clk, reset_b;

  Add_Accum_1 M1 (accum_1, overflow_1, data, enable, clk, reset_b);
  Add_Accum_2 M2 (accum_2, overflow_2, data, enable, clk, reset_b);


    initial #350 $finish;
    initial begin
      clk = 0;
      forever #5 clk = ~clk;
    end

  initial begin
    #1 reset_b = 0;
    #1 reset_b = 1;
    #250 reset_b = 0;
    #10 reset_b = 1;
  end

  initial begin
    data = 5; 
  end

initial begin
    #7 enable = 1;
    #250 enable = 0;
  end

endmodule


