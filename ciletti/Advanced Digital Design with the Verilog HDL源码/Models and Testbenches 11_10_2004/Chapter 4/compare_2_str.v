
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


