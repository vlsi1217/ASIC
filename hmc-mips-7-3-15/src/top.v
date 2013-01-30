//------------------------------------------------
// top.v
// David_Harris@hmc.edu 9 November 2005
// npinckney@hmc.edu 12 February 2007
// Carl Nygaard carlpny at gmail dot com 2007
//
// Top level system including MIPS and memories
//------------------------------------------------

`timescale 1 ns / 1 ps

module top(input         ph1, ph2, reset,
           input  [7:0]        interrupts,
           output [31:0] writedata, dataadr, 
           output        memwrite);


  wire [31:0] memadr;
  wire [31:0] memdata;
  wire [3:0] membyteen;
  wire memrwb;
  wire memen;
  wire memdone;
  
  // These are hooks for testing
  assign memwrite = ~memrwb & memen;
  assign writedata = memdata;
  assign dataadr = memadr;
   
  // instantiate processor and memories
  topmips thechip(ph1, ph2, reset, interrupts, memadr, memdata, membyteen, memrwb, memen, memdone);
  extmem extmem(ph1, ph2, reset, memadr[14:2], memdata, membyteen, memrwb, memen, memdone);

endmodule

// topmips: this is what should be on-chip
module topmips(input         ph1, ph2, reset,
                     input  [7:0]  interrupts,
                     output [31:0] memadr,
                     inout  [31:0] memdata,
                     output [3:0] membyteen,
                     output        memrwb,
                     output        memen,
                     input         memdone);


  wire [31:0] pc, instr, readdata, writedata, dataadr;
  wire instrack, dataack;
  wire [3:0] byteen;
  wire memwrite, memtoregM, swc;
  
  assign {memadr[31:29], memadr[1:0]} = 5'b0;
  
  // instantiate processor and cache
  mips mips(ph1, ph2, reset, pc, instr, interrupts, memwrite, memtoregM, swc, byteen, dataadr, writedata, 
            readdata, instrack, dataack);
  memsys memsys(ph1, ph2, reset, pc[31:2], instr, 1'b1, instrack,
                     dataadr[31:2], writedata, byteen, readdata,
                     memwrite, memtoregM, dataack,
                     swc,
                     memadr[28:2],memdata,membyteen,
                     memrwb,memen,memdone);
endmodule


