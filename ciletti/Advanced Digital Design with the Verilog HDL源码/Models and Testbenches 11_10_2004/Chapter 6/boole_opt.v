module boole_opt     (y_out1, y_out2, a, b, c, d, e);
 output 		y_out1, y_out2;
  input 		a, b, c, d, e;

  and 		(y1, a, c);
  and 		(y2, a, d);
  and 		(y3, a, e);
  or 		(y4, y1, y2);
  or 		(y_out1, y3, y4);
  and 		(y5, b, c);
  and 		(y6, b, d);
  and 		(y7, b, e);
  or 		(y8, y5, y6);
  or 		(y_out2, y7, y8);
endmodule

