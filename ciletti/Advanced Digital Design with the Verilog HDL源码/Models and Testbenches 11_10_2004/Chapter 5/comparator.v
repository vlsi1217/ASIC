module comparator (a_gt_b, a_lt_b, a_eq_b, a, b);  // Alternative algorithm
 parameter 	size = 2;
  output 				a_gt_b, a_lt_b, a_eq_b;
  input 		[size: 1] 		a, b;
  reg 				a_gt_b, a_lt_b, a_eq_b;
  integer				k;

  always @  ( a or b) begin: compare_loop
    for (k = size; k > 0; k = k-1) begin
        if (a[k] != b[k]) begin        
          a_gt_b = a[k];
          a_lt_b = ~a[k];
          a_eq_b = 0;
        disable compare_loop;
      end		// if
    end		// for loop
    a_gt_b = 0;
    a_lt_b = 0;
    a_eq_b = 1;
  end		// compare_loop
endmodule

