module alu (
   op,
   a,
   b,
   y,
   cin,
   cout,
   zout
);

input  [3:0]	op;	// ALU Operation
input  [7:0]	a;	// 8-bit Input a
input  [7:0]	b;	// 8-bit Input b
output [7:0]	y;	// 8-bit Output
input		cin;
output		cout;
output		zout;
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

// Reg declarations for outputs
reg		cout;
reg		zout;
reg [7:0]	y;

// Internal declarations
reg		addercout; // Carry out straight from the adder itself.
 
parameter ALUOP_ADD  = 4'b0000;
parameter ALUOP_SUB  = 4'b1000;
parameter ALUOP_AND  = 4'b0001;
parameter ALUOP_OR   = 4'b0010;
parameter ALUOP_XOR  = 4'b0011;
parameter ALUOP_COM  = 4'b0100;
parameter ALUOP_ROR  = 4'b0101;
parameter ALUOP_ROL  = 4'b0110;
parameter ALUOP_SWAP = 4'b0111;


always @(a or b or cin or op) begin
   case (op) // synopsys parallel_case
      ALUOP_ADD:  {addercout,  y}  = a + b;
      ALUOP_SUB:  {addercout,  y}  = a - b; // Carry out is really "borrow"
      ALUOP_AND:  {addercout,  y}  = {1'b0, a & b};
      ALUOP_OR:   {addercout,  y}  = {1'b0, a | b};
      ALUOP_XOR:  {addercout,  y}  = {1'b0, a ^ b};
      ALUOP_COM:  {addercout,  y}  = {1'b0, ~a};
      ALUOP_ROR:  {addercout,  y}  = {a[0], cin, a[7:1]};
      ALUOP_ROL:  {addercout,  y}  = {a[7], a[6:0], cin};
      ALUOP_SWAP: {addercout,  y}  = {1'b0, a[3:0], a[7:4]};
      default:    {addercout,  y}  = {1'b0, 8'h00};
   endcase
end

always @(y)
   zout = (y == 8'h00);

always @(addercout or op)
   if (op == ALUOP_SUB) cout = ~addercout; // Invert adder's carry to get borrow
   else                 cout =  addercout;
      
endmodule
