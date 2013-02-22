module t_Binary_Counter_Partioned_RTL ();
parameter		size = 4;
wire 	[size -1: 0]	count;
reg			enable;
reg			clk, rst;


Binary_Counter_Part_RTL M0 (count, enable, clk, rst);

initial #300 $finish;
initial begin clk = 0; forever #5 clk = ~clk; end

initial fork
#2 begin rst = 1; enable = 0; end
#10 rst = 0;
#20 enable = 1;
#180 enable = 0;
#200 enable = 1;
#220 rst = 1;
#250 rst = 0;
join
endmodule

