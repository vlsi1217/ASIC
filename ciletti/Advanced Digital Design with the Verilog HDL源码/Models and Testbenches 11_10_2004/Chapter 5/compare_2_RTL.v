module compare_2_RTL (A_lt_B, A_gt_B, A_eq_B, A1, A0, B1, B0);
  input 		A1, A0, B1, B0;
  output 		A_lt_B, A_gt_B, A_eq_B;
  reg 		A_lt_B, A_gt_B, A_eq_B;

  always @ (A0 or A1 or B0 or B1) begin
    A_lt_B = 	({A1,A0} < {B1,B0});
    A_gt_B = 	({A1,A0} > {B1,B0});
    A_eq_B = 	({A1,A0} == {B1,B0});
  end
endmodule

