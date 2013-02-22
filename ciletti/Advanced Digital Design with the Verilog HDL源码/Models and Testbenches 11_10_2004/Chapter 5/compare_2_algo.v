module compare_2_algo (A_lt_B, A_gt_B, A_eq_B, A, B);
  output 		A_lt_B, A_gt_B, A_eq_B;
  input 	[1: 0] 	A, B;
	  
  reg 		A_lt_B, A_gt_B, A_eq_B;

  always @  (A or B)   	// Level-sensitive behavior
  begin
    A_lt_B = 0;
    A_gt_B = 0;
    A_eq_B = 0;
    if (A == B) A_eq_B = 1; 	// Note: parentheses are required
    else if (A > B) 	A_gt_B = 1;
    else 	A_lt_B = 1;
  end
endmodule

