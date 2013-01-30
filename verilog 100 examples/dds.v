//
//
// This is just a little demo of DDS.  It doesn't have any cool features
// or anything..
//
module dds (
   clk,
   reset,
   
   din,
   
   dout
);

parameter	W = 12;

input		clk;	// Primary clock.
input		reset;	// Synchronous reset.
input [W-1:0]	din;	// The "phase step".
output [W-1:0]	dout;	// Output of the phase accumulator register.

reg [W-1:0]	dout;

reg [W-1:0]	accum;	// Phas Accumulator

// Just output the accumulator...
always @(accum)
   dout <= accum;

// Specify the accumulator..   
always @(posedge clk) begin
   if (reset) accum <= 0;
   else begin
      accum <= accum + din;
   end
end

endmodule

// synopsys translate_off
module ddstest;

reg		clk;
reg		reset;
reg [11:0]	din;
wire [11:0]	dout;	
reg [7:0]	cosout;	

// Instantiate the DDS with 12-bits.
//
dds #(12) dds1 (.clk(clk),  .reset(reset),  .din(din),  .dout(dout));

// Here's our Cosine lookup table.
//
reg [7:0]	costable[0:4095];  // 4KBytes.

// DDS Phase Accumulator output simply indexes into the Cos lookup table.
//
always @(dout)
   cosout <= costable[dout];

// Main test thread.
//   
initial begin
   $readmemh ("cos.hex", costable); // See the PERL program 'generate_cos_table.pl'

   din = 12'h020; // Start at 16
   #500000;
   
   din = 12'h0D0; // A little faster.. 
   #500000;
   
   din = 12'h200; // Fairly fast.
   #500000;
   
   $finish;
end

// Let's clock it at 1 MHz
initial begin
   clk = 0;
   forever begin
      #500 clk = 1;
      #500 clk = 0;
   end
end

// Reset
initial begin
   reset = 1;
   #3500 reset = 0;
end

// Generate VCD file for viewing.
initial begin
   $dumpfile ("dds.vcd");
   $dumpvars (0,ddstest);   
end
endmodule

//***  Here's the Perl program for your reference...
`ifdef WHEN_PERL_IS_A_SUBSET_OF_VERILOG
      #!/tools2/perl/bin/perl
      #
      #  Generate a file of cos data for use by a DDS simulation.
      #

      $n      = 4096;	# Number of data points
      $minval = 0;	# Smallest cos value.
      $maxval = 255;	# Largest cos value.

      $pi = 3.1415927;
      $t = 0;
      for ($i = 1; $i < $n; $i = $i + 1) {
         $value = ($maxval - $minval)/2 + (($maxval - $minval)/2)*cos($t);
         $value = int($value);
         printf "%x\n", $value;
         $t = $t + 2*$pi / $n;
      }
`endif
