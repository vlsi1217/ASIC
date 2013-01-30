// 
// SYNTHETIC PIC 2.0                                          4/23/98
//
//    This is a synthesizable Microchip 16C57 compatible
//    microcontroller.  This core is not intended as a high fidelity model of
//    the PIC, but simply a way to offer a simple processor core to people
//    familiar with the PIC who also have PIC tools.  
//
//    pictest.v  -   top-level testbench (NOT SYNTHESIZABLE)
//    piccpu.v   -   top-level synthesizable module
//    picregs.v  -   register file instantiated under piccpu
//    picalu.v   -   ALU instantiated under piccpu
//    picidec.v  -   Instruction Decoder instantiated under piccpu
//    hex2rom.c  -   C program used to translate MPLAB's INTEL HEX output
//                   into the Verilog $readmemh compatible file
//    test*.asm  -   (note the wildcard..) Several test programs used
//                   to help debug the verilog.  I used MPLAB and the simulator
//                   to develop these programs and get the expected results.
//                   Then, I ran them on Verilog-XL where they appeared to
//                   match.
//
//    Copyright, Tom Coonan, '97.
//    Use freely, but not for resale as is.  You may use this in your
//    own projects as desired.  Just don't try to sell it as is!
//
//

// This is an expansion module containing a Direct Digital Synthesizer (DDS).
// Simply put, it is a programmable sinewave generator.  It is used in a little
// example suggesting how a FSK modulator might be done.
//
// Address  Direction   Description
//   7E       R/W         Control:
//                           0  -  Enable.  Must set to '1' to get output.
//   7F       W           DDS Value
//
// Copyright (c) 1999 Thomas Coonan (tcoonan@mindspring.com)
//
//    This source code is free software; you can redistribute it
//    and/or modify it in source code form under the terms of the GNU
//    General Public License as published by the Free Software
//    Foundation; either version 2 of the License, or (at your option)
//    any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program; if not, write to the Free Software
//    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
//

//    
//
module exp (
   clk,
   reset,

   dds_out,
   
   expdin,
   expdout,
   expaddr,
   expread,
   expwrite
);

input		clk;
input		reset;

output [7:0]	dds_out;	// DDS output

// Expansion Interface
output [7:0]	expdin;		// TO the PIC core.
input [7:0]	expdout;	// FROM the PIC core.
input [6:0]	expaddr;	// Address
input		expread;	// Asserted (high) when PIC is reading FROM us.
input		expwrite;	// Asserted (high) when PIC is writing TO us.

// Outputs used as registers
reg [7:0]	expdin;
reg [7:0]	dds_out;

// Programmable registers
reg [7:0]	ddsstep;
reg [0:0]	ctl;

// *** DDS ***

reg [9:0]	accum;
reg [7:0]	sinout;
reg [7:0]	sin_rom [0:1023];

// Look up the SIN value.  This is usually implemented as a memory, either
// a RAM or a ROM.  It is therefore highly dependent on the particular
// technology and is not really explored in this simple example.  We will
// simply declare a big register array, and read the SIN data from a file
// at the start of the simulation.
//
initial begin
   $display ("Reading in SIN data for example DDS in EXP.V from sindata.hex");
   $readmemh ("sindata.hex", sin_rom);
end

always @(posedge clk) begin
   if (reset) begin
      accum <= 0;
   end
   else begin
      accum <= accum + ddsstep;
   end
end

always @(posedge clk) begin
   if (reset) begin
      sinout <= 0;
   end
   else begin
      sinout <= sin_rom[accum];
   end
end

always @(posedge clk) begin
   if (reset) begin
      dds_out <= 0;
   end
   else begin
      if (ctl[0]) begin
         dds_out <= sinout;
      end
      else begin
         dds_out <= 0;
      end
   end
end





// Drive the expdin bus back to the PIC.  This should just be a MUX.
// For several different expansion submodules, this would be our gateway
// MUX back to the PIC core.
//
always @(expread or expaddr) begin
   if (expread) begin
      case (expaddr)
         7'h7F:    expdin <= ddsstep;
         default:  expdin <= 0;
      endcase
   end
   else begin
      expdin <= 0;
   end
end

// 
always @(posedge clk) begin
   if (reset) begin
      ctl      <= 0;
      ddsstep  <= 0;
   end
   else begin
      if (expwrite) begin
         case (expaddr) // synopsys parallel_case
            7'h7E: ctl     <= expdout[7:0];
            7'h7F: ddsstep <= expdout[7:0];
         endcase
      end
   end
end
endmodule
