`timescale 1 ns / 10 ps
module test_NRZ_2_Manchester_Moore ();
reg B_in, reset_b;
wire B_out, clock;

NRZ_2_Manchester_Moore M1 (B_out, B_in, clock_2, reset_b);
Clock_1_2 M2 (clock_1, clock_2);

initial #200 $finish;

initial begin #1 reset_b = 0; #2 reset_b = 1; end
initial fork
B_in = 0;
#(M2.period_1) B_in = 1;
#(4*M2.period_1) B_in = 0;
#(6*M2.period_1) B_in = 1;
#(7*M2.period_1) B_in = 0;
join
endmodule

