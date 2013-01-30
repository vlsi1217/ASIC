// picdram stands for PIC "Data" RAM.
//
//
// Synchronous Data RAM, 8 bits wide, N words deep.
//
// ** Must support SYNCHRONOUS WRITEs and ASYNCHRONOUS READs **
//    This is so that we can do a Read/Modify/Write in one cycle which
//    is required to do something like this:
//
//       incf 0x20, f   // M[20] <= M[20] + 1
//       incf 0x22, f   // M[22] <= M[22] + 1
//       incf 0x18, f   // M[18] <= M[18] + 1
//
// Replace with your actual memory model..
//
module dram (
   clk,
   address,
   we,
   din,
   dout
);

input		clk;
input [6:0]	address;
input		we;
input [7:0]	din;
output [7:0]	dout;

// Number of data memory words.  This is somewhat tricky, since remember
// that lowest registers (e.g. special registers) are not really in this
// data memory at all, but are explicit registers at the top-level.  Also,
// the banking scheme has some of the other registers in each bank being
// mapped to the same physical registers.  The bottom line is that for
// the 16C57, you at most need to set this to 72.  Note we are reserving
// the last 2 words for our little "expansion circuit" so we really want
// only 70.
//

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

parameter word_depth = 70; // Maximum minus 2 words for expansion circuit demo
//parameter word_depth = 24;  // This would be like a 16C54 

// reg [6:0]	address_latched; <--- NO!  We need ASYNCHRONOUS READs

// Instantiate the memory array itself.
reg [7:0]	mem[0:word_depth-1];

// Latch address <--- NO! 
//always @(posedge clk)
//   address_latched <= address;
   
// READ
//assign dout = mem[address_latched];

// ASYNCHRONOUS READ
assign dout = mem[address];

// SYNCHRONOUS WRITE
always @(posedge clk)
   if (we) mem[address] <= din;

endmodule
