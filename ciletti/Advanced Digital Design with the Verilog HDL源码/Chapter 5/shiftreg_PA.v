module shiftreg_PA (E, A, B, C, D, clk, rst);
  output 	A;
   input	E;
   input 	clk, rst;
   reg	A, B, C, D;
  always @ (posedge clk or posedge rst) begin
   if (reset) begin A = 0; B = 0; C = 0; D = 0; end
  else begin
    A = B;
    B = C; 
    C = D;
    D = E; 	
  end	
  end
endmodule

