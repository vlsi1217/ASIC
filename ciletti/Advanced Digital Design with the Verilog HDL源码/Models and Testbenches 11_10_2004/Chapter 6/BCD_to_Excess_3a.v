module BCD_2_Excess_3 (B_out, B_in, clk, reset);
input  B_in, clk, reset;
output B_out;
reg q0, q1, q2;
wire w1, w2, w3, w4, B1, B2;
wire [2:0] state = {q2, q1, q0};

always @ (posedge clk or negedge reset) begin
if (reset == 0) q0 <= 0; else q0 <= ~q1;
end

always @ (posedge clk or negedge reset) begin
if (reset == 0) q1 <= 0; else q1 <= q0;
end

always @ (posedge clk or negedge reset) begin
if (reset == 0) q2 <= 0; else q2 <= w4;
end
nand #1(w4, w1, w2, w3);
nand #1(w1, q0, q1, q2);
nand #1(w2, q0, ~q2, ~B_in);
nand #1(w3, ~q0, ~q1, B_in);
nand #1(B1, B_in, q2);
nand #1(B2, ~B_in, ~q2);
nand #1(B_out, B1, B2);
endmodule

module Test_BCD_2_Excess_3 ();
reg  B_in, reset;
wire B_out;
defparam M2.half_cycle = 50;
BCD_2_Excess_3 M1 (B_out, B_in, clk, reset);
Clock_Gen M2 (clk);

initial begin #1000 $finish; end

initial begin
#10 reset = 0;  #90 reset = 1;
end

initial begin
#0 B_in = 0;
#100 B_in = 0;
#100 B_in = 0;
#100 B_in = 1;
#100 B_in = 0;
end

endmodule
