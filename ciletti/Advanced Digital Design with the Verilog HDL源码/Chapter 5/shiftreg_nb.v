module shiftreg_nb (A, E, clk, rst);
  output 	A;
  input	E;
  input 	clk, rst;
  reg	A, B, C, D;


  always @ (posedge clk or posedge rst) begin
    if (rst) begin A <= 0; B <= 0; C <= 0; D <= 0; end
      else begin
        A <= B; 		//	D <= E;
        B <= C;		//	C <= D;
        C <= D;		//	B <= D;
        D <= E;		//	A <= B;
      end
  end
endmodule

