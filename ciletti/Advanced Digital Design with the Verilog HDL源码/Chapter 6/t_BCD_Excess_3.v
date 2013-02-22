`timescale 1ns / 10 ps
module test_BCD_to_Excess_3_Converter ();
  wire	B_out_b, B_out_c, clk;
  reg		B_in, reset_b;
  defparam M2.half_cycle = 50;

BCD_to_Excess_3c M1 (B_out_c, B_in, clk, reset_b);
BCD_to_Excess_3b M3 (B_out_b, B_in, clk, reset_b);
Clock_Gen M2 (clk);

initial begin #1000 $finish; end

initial begin
#10 reset_b = 0;  #90 reset_b = 1;
end

initial begin
#0 B_in = 0;
#100 B_in = 0;
#100 B_in = 0;
#100 B_in = 1;
#100 B_in = 0;
end

endmodule


