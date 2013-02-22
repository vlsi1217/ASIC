//Verilog HDL 1st Ed. Page 22

/*
Time: 11:00 pm Feb 21, 2013 
Addr: SJ apt 32
Proj: verilog review, learn the verilog, testbench, gtkwave
Engr: Tony Z
*/

module T_FF_tb;

reg clk;
reg reset;
wire [3:0] q;

//instantiate the design block
ripple_carry_counter r1(q, clk, reset);

//control the clk signal that drives the design block. Cycle time = 10
initial 
	clk = 1'b0; //set clk to 0
always 
	#5 clk = ~clk; //toggle clk every 5 time units

//control the reset signal that drives the design block
//reset stays up from 0 to 15 and from 195 to 205.
initial begin
	$dumpfile ("T_FF_tb.vcd");
	$dumpvars (0, T_FF_tb);
	$monitor($time, ", clock = %b, Output q = %d", clk, q);
	reset = 1'b1;
	#15 reset = 1'b0;
	#180 reset = 1'b1;
	#10 reset = 1'b0;
	#20 $finish; //terminate the simulation
end


//Monitor the outputs
//initial 
// 	$monitor($time, " Output q = %d",   q);
endmodule 
