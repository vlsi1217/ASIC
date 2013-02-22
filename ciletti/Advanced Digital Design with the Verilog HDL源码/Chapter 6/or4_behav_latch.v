module or4_behav_latch (y, x_in);
  parameter 	word_length = 4;
  output 					y;
  input 		[word_length - 1: 0] 	x_in;
  reg 					y;
  integer 				k;

  always @  (x_in[3:1])
    begin: check_for_1
      y = 0;
      for (k = 0; k <= word_length -1; k = k+1)
        if (x_in[k] == 1)
          begin
            y = 1;
            disable check_for_1;
          end
    end
endmodule

