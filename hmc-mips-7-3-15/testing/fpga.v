//------------------------------------------------
// fpgabench.v
// tbarr@cs.hmc.edu 5 February 2007
// FPGA Testbench for MIPS processor
//------------------------------------------------

`timescale 1 ns / 1 ps

// this module simulates everything going on in the FPGA. it should be the
// top level synth'd.

module fpga(input ph1, ph2, reset,
                 output  [3:0] outputleds);
                 
        wire [7:0] interrupts;
        
        wire [31:0] writedata, dataadr;
        wire memwrite;
        
        reg [2:0] status;
        
        assign interrupts = 8'b00000000;
        assign outputleds = {status, 1'b1};
        
        top cpu(ph1, ph2, reset, interrupts, writedata, dataadr, memwrite);
        
          always@(posedge ph2) //formerly negedge clk, changed to work w/ 2-phase clock
            begin
              status[2] = 1;
              if (reset) 
                begin
                  status[2] = 0;
                  status[1] = 0;
                  status[0] = 0;
                end

            if(memwrite) begin
              if(dataadr === 32'h14 & writedata === 21) begin
                status[1] = 1;
              end else begin
                status[0] = 1;
              end
            end
    end
endmodule
