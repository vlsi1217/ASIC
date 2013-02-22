module compare_32_CA (A_gt_B, A_lt_B, A_eq_B, A, B);
  parameter 	word_size = 32;
  input 		[word_size-1: 0] 	A, B;
  output 		A_gt_B, A_lt_B, A_eq_B;

  assign 	A_gt_B = (A > B),		// Note: list of multiple assignments
	  		A_lt_B = (A < B),
	  		A_eq_B = (A == B);
endmodule

