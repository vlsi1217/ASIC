module ripple_counter (count, toggle, clock, reset,);   
  output 		[3: 0] 	count;
  input 			toggle, clock, reset; 
  reg		[3: 0] 	count;
  wire 			c0, c1, c2;

  assign c0 = count[0];
  assign c1 = count[1];
  assign c2 = count[2];
 
  always @  (posedge reset or posedge clock)
    if (reset == 1'b1) count[0] <= 1'b0; else 
      if (toggle == 1'b1) count[0] <= ~count[0];

  always @  (posedge reset or negedge c0)
    if (reset == 1'b1) count[1] <= 1'b0; else 
      if (toggle == 1'b1) count[1] <= ~count[1];

  always @  (posedge reset or negedge c1)
    if (reset == 1'b1) count[2] <= 1'b0; else 
      if (toggle == 1'b1) count[2] <= ~count[2];

  always @  (posedge reset or negedge c2)
    if (reset == 1'b1) count[3] <= 1'b0; else 
      if (toggle == 1'b1) count[3] <= ~count[3];
endmodule

