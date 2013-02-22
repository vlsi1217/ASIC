module t_count_ones_SM();


parameter	counter_size	= 3;
parameter	word_size	= 4;

wire 		[counter_size -1 : 0]	bit_count;
wire					busy, done;
reg 		[word_size-1: 0] 		data;
reg 					start, clk, reset;

count_ones_SM M0 (bit_count, busy, done, data, start, clk, reset);


initial #700 $finish;
initial begin
#1 reset = 1;
#31 reset = 0;
end
initial begin
//#120 reset = 1;
//#10 reset = 0;
end
initial begin
clk = 0;
forever #5 clk = ~clk;
end
initial fork
#30 start = 1;
#40 start = 0;
#80 start = 1;
#90 start = 0;
#130 start = 1;
#140 start = 0;
#270 start = 1;
join

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

