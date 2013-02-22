module t_count_ones_IMP ();

  parameter 					data_width = 4;
  parameter 					count_width = 3;
  wire 		[count_width-1:0] 	bit_count;
  wire						start, done;
  reg 		[data_width-1:0] 		data;
  reg							data_ready;
  reg 						clk, reset;



initial #700 $finish;
initial begin
#1 reset = 1;
#31 reset = 0;
end
initial begin
#120 reset = 1;
#10 reset = 0;
end
initial begin
clk = 0;
forever #5 clk = ~clk;
end
initial begin
#30 data_ready = 1;
#20 data_ready = 0;
#60 data_ready = 1;
#40 data_ready = 0;
#40 data_ready = 1;
#20 data_ready = 0;
#60 data_ready = 1;
end
initial begin
#5 data = 4'hf;
#55 data = 4'ha;
#60 data = 4'h5;
#60 data = 4'hb;
#60 data = 4'h9;
#60 data = 4'h0;
#60 data = 4'hc;

#60 data = 4'hd;
#60 data = 4'h7;

end
count_ones_IMP M0 (bit_count, start, done, data, data_ready, clk, reset);
endmodule

