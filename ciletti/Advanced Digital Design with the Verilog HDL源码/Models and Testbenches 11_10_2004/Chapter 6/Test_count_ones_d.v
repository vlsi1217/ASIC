module t_count_ones_d ();

  parameter 				data_width = 4;
  parameter 				count_width = 3;
  wire 		[count_width-1:0] 		bit_count;
  reg 		[data_width-1:0] 		data;
  reg 					clk, reset;
 
count_ones_d M0 (bit_count, data, clk, reset);

initial #500 $finish;
initial fork
reset = 1;
#10 reset = 0;
#180 reset = 1;
#190 reset = 0;
join

initial begin
clk = 0;
forever #5 clk = ~clk;
end

initial begin
#5 data = 4'hf;
#55 data = 4'h3; 
#60 data = 4'h5;
#60 data = 4'hb;
#60 data = 4'h9;
#60 data = 4'h0;
#60 data = 4'hc;

#60 data = 4'hd;
#60 data = 4'h7;

end


endmodule

