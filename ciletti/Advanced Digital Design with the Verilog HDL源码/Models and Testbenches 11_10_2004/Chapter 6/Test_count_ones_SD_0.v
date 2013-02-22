module t_count_ones_SD();


parameter	counter_size	= 3;
parameter	word_size	= 4;

wire 		[counter_size -1 : 0]	bit_count;
wire					start, done;
reg 		[word_size-1: 0] 		data;
reg 					clk, reset;

count_ones_SD M0 (bit_count, start, done, data, clk, reset);

initial #500 $finish;
initial fork
reset = 1;
#10 reset = 0;
join
/*initial begin
#75 reset = 1;
#10 reset = 0;
end
initial begin
#120 reset = 1;
#10 reset = 0;
end*/

initial begin
#300 reset = 1;
#10 reset = 0;
end

initial begin
clk = 0;
forever #5 clk = ~clk;
end
initial begin
#10 data = 4'hf;
#60 data = 4'ha;
#60 data = 4'h5;
#60 data = 4'hb;
#60 data = 4'h9;
#60 data = 4'h0;
#60 data = 4'hc;

#60 data = 4'hd;
#60 data = 4'h7;
end

endmodule

