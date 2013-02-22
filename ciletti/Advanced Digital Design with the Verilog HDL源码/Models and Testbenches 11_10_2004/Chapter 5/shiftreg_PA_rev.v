module shiftreg_PA_rev (A, E, clk, rst);
  output 	A;
  input	E;
  input 	clk, rst;
  reg	A, B, C, D;

  always @ (posedge clk or posedge rst) begin
    if (rst) begin A = 0; B = 0; C = 0; D = 0; end
    else begin
      D = E; 	
      C = D;		
      B = C;	
      A = B;		
    end
  end
endmodule

