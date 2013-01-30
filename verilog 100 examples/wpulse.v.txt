//
// 
//  This circuit generates WE pulses.  For example, if you have a chip that
//  needs to access an asynchronous SRAM in a single cycle and you wanted
//  generate the WE pulse synchronous with your system clock.
//
//  Every clk cycle, generate an active
//  low WE pulse.  The delay from the clk rising edge to the falling edge of
//  we is based on abits setting, which affects delay taps, etc.  Likewise,
//  bbits controls the following rising edge of we.  The module contains
//  two flip flops that generate two opposite poraity toggling levels.
//  A delay chain is attached to each of these outputs.  The abits and bbits
//  get the desired tap, and the final two delayed signals are XORed together
//  to get the final we.  None of this is very tuned, you would look at your
//  cycle time and pick a delay chain that makes sense for that.  But, this
//  shows the effect.
//
//  The we pulse always occurs.  You will probably want to combine this with
//  you write_enable signal.  This sort of circuit is, of course, highly dependent
//  on post-layout timing, etc.  but that's why its programable.  You probably
//  want more taps, too..
//
//
module wpulse (
   reset,
   clk,
   abits,
   bbits,
   we
);

input		clk;
input		reset;
input [3:0]	abits; // bits to select which delay tap to use for first edge
input [3:0]	bbits; // bits to select which delay tap to use for pulse width
output		we;

reg 		p1, p2;

wire		adel1out;
wire		adel2out;
wire		adel3out;
wire		adel4out;
wire		bdel1out;
wire		bdel2out;
wire		bdel3out;
wire		bdel4out;

wire		adelout;
wire		bdelout;

// 2 flip-flops that are opposite polarity.  Each flop toggles
// every cycles.
//
always @(posedge clk)
   p1 <= (reset) | (~reset & ~p1); // reset to 1
always @(posedge clk)
   p2 <= (~reset & ~p2);  // reset to 0

// Delay chain off of the p1 flop.   
delay4 adel1 (.a(p1),		.z(adel1out));
delay4 adel2 (.a(adel1out),	.z(adel2out));
delay4 adel3 (.a(adel2out),	.z(adel3out));
delay4 adel4 (.a(adel3out),	.z(adel4out));

// Delay chain off of the p2 flop.
delay4 bdel1 (.a(p2),		.z(bdel1out));
delay4 bdel2 (.a(bdel1out),	.z(bdel2out));
delay4 bdel3 (.a(bdel2out),	.z(bdel3out));
delay4 bdel4 (.a(bdel3out),	.z(bdel4out));

// Select the tap of the p1 and p2 delay chains we want based on abits
assign adelout =	abits[3] & adel1out | 
			abits[2] & adel2out | 
			abits[1] & adel3out |
			abits[0] & adel4out;
assign bdelout =	bbits[3] & bdel1out | 
			bbits[2] & bdel2out | 
			bbits[1] & bdel3out |
			bbits[0] & bdel4out;

// Final we pulse is just the XOR of the two chains.  
assign we = adelout ^ bdelout;

endmodule

// This is our delay cell.  Pick whatever cell makes sense from your library.
module delay4 (a, z);
input a;
output z;
reg	z;
always @(a)
  z = #4 a;
endmodule

// synopsys translate_off
module testwpulse;
reg		clk;
reg		reset;
reg [3:0]	abits; // bits to select which delay tap to use for first edge
reg [3:0]	bbits; // bits to select which delay tap to use for pulse width
wire		we;

wpulse wpulse_inst (
   .reset	(reset),
   .clk		(clk),
   .abits	(abits),
   .bbits	(bbits),
   .we		(we)
);

initial begin
   abits = 4'b1000; // Shortest pulse, earliest in cycle.
   bbits = 4'b0100;
   #200;

   abits = 4'b0010; // Shortest pulse, latest in the cycle.
   bbits = 4'b0001;
   #200;

   abits = 4'b0100; // Shortest pulse, middle of the cycle.
   bbits = 4'b0010;
   #200;

   abits = 4'b1000; // Longest cycle
   bbits = 4'b0001;
   #200;

   abits = 4'b1000; // Early in cycle, but not quite the longest.
   bbits = 4'b0010;
   #200;

   $finish;
end

// Reset
initial begin
   reset = 0;
   #5 reset = 1;
   #100 reset = 0;
end
   
// Generate the 50MHz clock
initial begin
   clk = 0;
   forever begin
      #10 clk = 1;
      #10 clk = 0;
   end
end

`define WAVES
`ifdef WAVES
initial begin
   $dumpfile ("wpulse.vcd");
   $dumpvars (0,testwpulse);   
end
`endif
endmodule
// synopsys translate_on
