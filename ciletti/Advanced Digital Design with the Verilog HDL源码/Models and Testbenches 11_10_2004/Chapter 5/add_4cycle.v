module add_4cycle (sum, data, clk, reset);
  output 		[5: 0] 	sum;
  input 		[3: 0] 	data;
  input 			clk, reset;
  reg 			sum;

always @ (posedge clk) begin:  add_loop
    if (reset) disable add_loop; 			else sum <= data;
      @ (posedge clk) if (reset) disable add_loop; 	else sum <= sum + data;
        @ (posedge clk) if (reset) disable add_loop; 	else sum <= sum + data;
          @ (posedge clk) if (reset) disable add_loop; 	else sum <= sum + data;
   end
endmodule

