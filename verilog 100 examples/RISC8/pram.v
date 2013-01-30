//
// Synchornous Data RAM, 12x2048
//
// Replace with your actual memory model..
//
module pram (
   clk,
   address,
   we,
   din,
   dout
);

input		clk;
input [10:0]	address;
input		we;
input [11:0]	din;
output [11:0]	dout;

// synopsys translate_off
parameter word_depth = 2048;

reg [10:0]	address_latched;

// Instantiate the memory array itself.
reg [11:0]	mem[0:word_depth-1];

// Latch address
always @(posedge clk)
   address_latched <= address;
   
// READ
assign dout = mem[address_latched];

// WRITE
always @(posedge clk)
   if (we) mem[address] <= din;

// synopsys translate_on

endmodule
