module df_behav (q, q_bar, data, set, reset, clk);
input 		data, set, clk, reset;
  output 		q, q_bar;
  reg 		q;

  assign q_bar = ~ q;

  always @  (posedge clk)  // Flip-flop with synchronous set/reset
  begin
    if (reset == 0) q <= 0; 
      else if (set ==0) q <= 1;
        else q <= data; 
  end
endmodule 

