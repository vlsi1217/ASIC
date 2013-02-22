module mux_reg (y, a, b, c, d, select, clock);
output 	[7: 0] 	y;
  input 	[7: 0] 	a, b, c, d;
  input	[1: 0] 	select;
  input		clock;
  reg 	[7: 0] 	y;

always @ (posedge clock)
  case (select)
      0: y <= a;	// non-blocking
      1: y <= b;         
      2: y <= c;
      3: y <= d;
      default y <= 8'bx;
    endcase
endmodule
