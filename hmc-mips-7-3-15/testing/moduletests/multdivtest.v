// multdivtest.v
// David_Harris@hmc.edu 1/2/07
//

/////////////////////////////////////////////////////////////////////////////////
// Module: multdivtest
// 
// Test fixture for serial multiplier/divider
// Tested 20 January 2007, passed 44 test vectors for signed and unsigned
// multiplication and division.
// This unit would still benefit from rigorous corner case testing.  Generating
// the 64-bit results will take a bit of work.  Some corner cases to consider
// include:
//  0, 1, 2, 7FFFFFFF, 80000000, FFFFFFFE, FFFFFFFF, ABCDEF01, 23456789
/////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

module multdivtest();
  reg         clk;
  reg         reset;
  reg [31:0]  x, y;
  reg         multdivb, signedop;
  wire [31:0] prodh, prodl;
  wire        run, dividebyzero;

  reg [31:0]  vectornum, errors;
  reg [129:0] testvectors[10000:0];
  reg [31:0]  prodhexpected, prodlexpected;
  reg         ready;
  reg         start;
  reg         ph1, ph2;
  // generate clock to sequence tests
  always
    begin
      ph1 <= 1; # 4; ph1 <= 0; #1;
		ph2 <= 1; # 4; ph2 <= 0; #1;
    end

  // device under test
  multdiv dut(ph1, ph2, reset, start, multdivb, signedop, x, y, prodh, prodl, 
              run);

  // generate reset
  initial begin
    start = 0;
    reset = 1; #17; reset = 0;
    ready = 1;
  end

  // load testvectors
  initial
    begin
      $readmemh("testing/moduletests/md_rand_001.tv", testvectors);
      vectornum = 0;
      errors = 0;
    end

  always @(posedge ph1)
    if (ready) begin
      #1 {multdivb, signedop, x, y, prodhexpected, prodlexpected} = testvectors[vectornum];
      vectornum = vectornum+1;
      start = 1;
      ready = 0;
    end else begin
      #1 start = 0;
    end

  always @(negedge ph1)
    if (~run & ~start & ~reset) begin
      #1 ready = 1;
      if (testvectors[vectornum][0] === 1'bx) begin
        $display("Finished %d test vectors with %d errors\n", vectornum, errors);
	$stop();
      end
      if (prodh !== prodhexpected | prodl !== prodlexpected) begin
        if (multdivb)
          $display("Error on vector %d: %x * %x (signed = %d): expected (%x %x) observed (%x %x)\n",
	            vectornum-1, x, y, signedop, prodhexpected, prodlexpected, prodh, prodl);
	else
          $display("Error on vector %d: %x / %x (signed = %d): expected (%x rem %x) observed (%x rem %x)\n",
	            vectornum-1, x, y, signedop, prodlexpected, prodhexpected, prodl, prodh);
        errors = errors+1;
      end
    end

endmodule


