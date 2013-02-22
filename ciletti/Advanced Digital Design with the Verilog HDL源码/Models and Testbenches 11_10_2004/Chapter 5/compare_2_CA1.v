module compare_2_CA1 (A_lt_B, A_gt_B, A_eq_B, A, B);
  input	[1: 0] 	A, B;
  output 		A_lt_B, A_gt_B, A_eq_B;

  assign 	A_lt_B = (A < B);
  assign 	A_gt_B = (A > B);
  assign 	A_eq_B = (A == B);
endmodule

