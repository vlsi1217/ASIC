
module Comp_2_str (A_gt_B, A_lt_B, A_eq_B, A1, A0, B1, B0);
  output 	A_gt_B, A_lt_B, A_eq_B;
  input 	A1, A0, B1, B0;
  wire	w1, w2, w3, w4, w5, w6, w7;
  or 		(A_lt_B, w1, w2, w3);
  nor 	(A_gt_B, A_lt_B, A_eq_B);
  and 	(A_eq_B, w4, w5);
  and 	(w1, w6, B1);
  and 	(w2, w6, w7, B0);
  and 	(w3, w7, B0, B1);
  not 	(w6, A1);
  not 	(w7, A0);
  xnor 	(w4, A1, B1);
  xnor 	(w5, A0, B0);
endmodule

module Comp_4_str(A_gt_B, A_lt_B, A_eq_B, A3, A2, A1, A0, B3, B2, B1, B0);
output 	A_gt_B, A_lt_B, A_eq_B;
input 	A3, A2, A1, A0, B3, B2, B1, B0;
wire 		w1, w0;
Comp_2_str M1 (A_gt_B_M1, A_lt_B_M1, A_eq_B_M1, A3, A2, B3, B2);
Comp_2_str M0 (A_gt_B_M0, A_lt_B_M0, A_eq_B_M0, A1, A0, B1, B0);

or (A_gt_B, A_gt_B_M1, w1);
and (w1, A_eq_B_M1, A_gt_B_M0);

and (A_eq_B, A_eq_B_M1, A_eq_B_M0);

or (A_lt_B, A_lt_B_M1, w0);
and (w0, A_eq_B_M1, A_lt_B_M0);
endmodule

module test_Comp_4_str();

wire 	A_gt_B, A_lt_B, A_eq_B;
reg 	[4:0] A, B;			// sized to prevent loop wrap around
wire [3:0] A_bus, B_bus;
assign A_bus = A[3:0];		// display 4 bit values
assign B_bus = B[3:0];

Comp_4_str M1 (A_gt_B, A_lt_B, A_eq_B, A[3], A[2], A[1], A[0], B[3], B[2], B[1], B[0]);
initial #2000 $finish;

initial begin
#5 for (A = 0; A < 16; A = A + 1) begin 
for (B = 0; B < 16; B = B + 1)begin #5;
end
end
end
endmodule
