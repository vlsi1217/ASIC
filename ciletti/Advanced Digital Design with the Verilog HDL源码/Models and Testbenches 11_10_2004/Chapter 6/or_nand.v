module or_nand (y, enable, x1, x2, x3, x4);
  output y;
  input 	enable, x1, x2, x3, x4;

  assign y = ~(enable & (x1 | x2) & (x3 | x4));
endmodule

