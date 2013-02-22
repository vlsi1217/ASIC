//------------------------------------------------
// mipstest.v
// David_Harris@hmc.edu 23 October 2005
// Test bench for MIPS processor
//------------------------------------------------

module testbench();

  reg         clk;
  reg         reset;

  wire [31:0] aluout, writedata, readdata;
  wire memwrite;

  // instantiate device to be tested
  top dut(clk, reset, aluout, writedata, readdata, memwrite);
  
  // initialize test
  initial
    begin
      reset <= 1; # 22; reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end

  // check results
  always@(negedge clk)
    begin
      if(memwrite) begin
        if(aluout == 76 & writedata == 7)
          $display("Simulation succeeded");
        else $display("Simulation failed");
        $stop;
      end
    end
endmodule

