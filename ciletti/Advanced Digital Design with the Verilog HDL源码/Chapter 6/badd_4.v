module badd_4 (Sum, C_out, A, B, C_in);
  output 	[3: 0] 	Sum;
  output 		C_out;
  input 	[3: 0] 	A, B;
  input 		C_in;

  assign {C_out, Sum} = A + B + C_in;
endmodule

