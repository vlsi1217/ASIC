module mux_logic (y, select, sig_G, sig_max, sig_a, sig_b);
  output 		y;
  input   		select, sig_G, sig_max, sig_a, sig_b;

  assign y = (select == 1) || (sig_G ==1) || (sig_max == 0) ? sig_a : sig_b; 
		 
endmodule

