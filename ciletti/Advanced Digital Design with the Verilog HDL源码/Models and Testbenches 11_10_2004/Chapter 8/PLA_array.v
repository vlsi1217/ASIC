module PLA_array (in0, in1, in2, in3, in4, in5, in6, in7, out0, out1, out2);
  input 			in0, in1, in2, in3, in4, in5, in6, in7;
  output 		out0, out1, out2; 
  reg  		out0, out1, out2;
  reg  	[0: 10] 	PLA_mem [0: 2];		// 3 functions of 8 variables

  initial begin
    $readmemb ("PLA_data.txt", PLA_mem);
    $async$and$array 
      (PLA_mem, {in0, in1, in2, in3, in4, in5, in6, in7}, {out0, out1, out2});
  end
endmodule

