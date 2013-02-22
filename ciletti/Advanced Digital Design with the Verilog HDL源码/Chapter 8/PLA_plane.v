module PLA_plane (in0, in1, in2, in3, in4, in5, in6, in7, out0, out1, out2);
  input 		in0, in1, in2, in3, in4, in5, in6, in7;
  output 		out0, out1, out2; 
  reg  		out0, out1, out2;
  reg  	[0: 3] 	PLA_mem [0:2];		// 3 functions of 4 variables
  reg  	[0: 4] 	a;
  reg  	[0: 3] 	b;

  initial begin
     
    $async$and$array 
      (PLA_mem, {in0, in1, in2, in3, in4, in5, in6, in7}, {out0, out1, out2});
    
    PLA_mem [0] = 4'b1?0?; 		// Load the personality matrix
    PLA_mem [1] = 4'b11?0;
    PLA_mem [2] = 4'b0??0;
  end
endmodule

