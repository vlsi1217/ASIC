module for_and_loop_comb (out, a, b);
  output 		[3: 0] 	out;
  input 		[3: 0] 	a, b;
  

  reg 		[2: 0]	i;
  reg 		[3: 0] 	out;
  wire 		[3: 0] 	a, b;

  always @  (a or b)
    begin
      for (i = 0; i <= 3; i = i+1)
        out[i] = a[i] & b[i];
    end
endmodule

