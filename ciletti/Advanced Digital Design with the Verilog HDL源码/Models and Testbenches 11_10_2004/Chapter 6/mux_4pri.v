module mux_4pri (y, a, b, c, d, sel_a, sel_b, sel_c);
 output 	y;
 input 	a, b, c, d, sel_a, sel_b, sel_c; 
 reg 	y;

    always @  (sel_a or sel_b or sel_c or a or b or c or d)
      begin
        if 	(sel_a == 1) 		y = a; else 
        if 	(sel_b == 0)		y = b; else
        if  	(sel_c == 1)		y = c; else
 	 			y = d;
      end  
endmodule

