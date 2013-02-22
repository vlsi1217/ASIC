module asynch_df_behav (q, q_bar, data, set, clk, reset );
  input 		data, set, reset, clk;
	  output 		q, q_bar;
	  reg 		q;

	  assign q_bar = ~q;

  always @  (negedge set or negedge reset or posedge clk)
    begin
      if (reset == 0) q <= 0; 
  else if (set == 0) q <= 1; 
    else q <= data; 		// synchronized activity
     end
endmodule 

