module operator_group (sum1, sum2, a, b, c, d);
  output 	[4: 0]	sum1, sum2;
  input 	[3: 0] 	a, b, c, d;
  

  assign sum1 = a + b + c + d;
  assign sum2 = (a + b) + (c + d);

endmodule

