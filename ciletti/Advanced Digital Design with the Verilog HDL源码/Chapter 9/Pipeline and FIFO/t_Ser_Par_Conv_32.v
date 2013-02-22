module t_Ser_Par_Conv_32 ();
wire [31:0] Data_out;
wire Shft, write;
reg Data_in;
reg	En, clk, rst;


initial #1000 $finish;
initial begin clk = 0; forever #5 clk = ~clk; end
initial begin rst = 1; #10 rst = 0; end
initial begin #10 En = 0; #10 En = 1; #30 En = 0; end
initial begin Data_in = 1; forever #10 Data_in = ~Data_in; end
initial begin #500 En = 1; end

Ser_Par_Conv_32 M0 (Data_out, write, Data_in, En, clk, rst);

endmodule
