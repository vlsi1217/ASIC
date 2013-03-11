//
// This is the top level of the fifo test bench
//

`timescale 1ns/10ps


module topfifo ();

reg clk;
reg [31:0] sid0=1111;

wire reset,push,pull;
wire [44:0] din,mdin,mdout;
wire [4:0] dout;
wire full,empty;
wire [9:0] addrin,addrout;
wire write;



 ftb t(clk,reset,push,din,full,pull,dout,empty,sid0);

mem1k m(clk,addrin,mdin,write,addrout,mdout);

fifo f(clk,reset,push,full,din,pull,empty,dout,addrin,mdin,write,addrout,mdout);



initial begin
	//$dumpfile("fifo.vcd");
	//$dumpvars(3,topfifo);
	#8000000;
	$display("FAILED --- Ran out of time");
	$finish(99);
end

initial begin
	clk=0;
	#90.000000;	forever begin
	  clk=~clk;
	  #90.000000;
	end
end
endmodule
