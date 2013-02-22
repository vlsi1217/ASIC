module hiZ (out1, out2, a, b, s0, s1);  output 	out1, out2;  input 	a, b, s0, s1;
  bufif1 (out1, a, s0);
  bufif1 (out1, b, s1);
  and 	(out2, a, b);
  or 	(out2, a, b);
endmodule
 
module test_hiZ ();
wire out1, out2;
reg a, b, s0, s1;

 hiZ M1 (out1, out2, a, b, s0, s1);
 initial #100 $finish;

  initial
    begin
       s0 = 0; s1 = 0;
      #10 s0 = 1;
      #10 s0 = 0;
      #10 s0 = 1; s1 = 1;
      #10 s1 = 0;
      #10 s1 = 1; s0 = 1;
    end

  initial
    begin
 a = 1'bx; b = 1; 
      #10 a = 0; b = 0;
      #10 a = 1'bx;
      #10 a = 0; b = 1;
      #10 a = 1;
      #10 a = 0; b = 1'bx;
      #10 a = 1'bz;

    end   
 endmodule

