module t_count_ones_c ();

  parameter 				data_width = 4;
  parameter 				count_width = 3;
  wire 		[count_width-1:0] 		bit_count;
  reg 		[data_width-1:0] 		data;
  reg 					clk, reset;
 
count_ones_c M0 (bit_count, data, clk, reset);

initial #500 $finish;
initial fork
reset = 1;	// modified 5-17-2002 for longer reset
#10 reset = 0;
#200 reset = 1;
#211 reset = 0;
join

initial begin
clk = 0;
forever #5 clk = ~clk;
end

initial begin
#10 data = 4'hf;
#40 data = 4'ha;
#40 data = 4'h5;
#40 data = 4'hb;
#40 data = 4'h9;
#40 data = 4'h0;
#40 data = 4'hc;
end
endmodule

