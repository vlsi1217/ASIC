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

module idec (
	inst,
	aluasel,
	alubsel,
	aluop,
	wwe,
	fwe,
	zwe,
	cwe,
	bdpol,
	option,
	tris
);

input  [11:0]	inst;

output [1:0]	aluasel;
output [1:0]	alubsel;
output [3:0]	aluop;
output		wwe;
output		fwe;
output		zwe;
output		cwe;
output		bdpol;
output		option;
output		tris;

reg [14:0] decodes;

// For reference, the ALU Op codes are:
//
//   ADD  0000
//   SUB  1000
//   AND  0001
//   OR   0010
//   XOR  0011
//   COM  0100
//   ROR  0101
//   ROL  0110
//   SWAP 0111

assign {	aluasel,	// Select source for ALU A input. 00=W, 01=SBUS, 10=K, 11=BD
		alubsel,	// Select source for ALU B input. 00=W, 01=SBUS, 10=K, 11="1"
		aluop,		// ALU Operation (see comments above for these codes)
		wwe,		// W register Write Enable
		fwe,		// File Register Write Enable
		zwe,		// Status register Z bit update
		cwe,		// Status register Z bit update
		bdpol,		// Polarity on bit decode vector (0=no inversion, 1=invert)
		tris,		// Instruction is an TRIS instruction
		option		// Instruction is an OPTION instruction
	} = decodes;

// This is a large combinatorial decoder.
// I use the casex statement.

always @(inst) begin
	casex (inst) // synopsys parallel_case
		// *** Byte-Oriented File Register Operations
		//
		//                                 A  A  ALU  W F Z C B T O
		//                                 L  L   O   W W W W D R P
		//                                 U  U   P   E E E E P I T
		//                                 A  B               O S
		//                                                    L
		12'b0000_0000_0000: decodes = 15'b00_00_0000_0_0_0_0_0_0_0; // NOP
		12'b0000_001X_XXXX: decodes = 15'b00_00_0010_0_1_0_0_0_0_0; // MOVWF
		12'b0000_0100_0000: decodes = 15'b00_00_0011_1_0_1_0_0_0_0; // CLRW
		12'b0000_011X_XXXX: decodes = 15'b00_00_0011_0_1_1_0_0_0_0; // CLRF
		12'b0000_100X_XXXX: decodes = 15'b01_00_1000_1_0_1_1_0_0_0; // SUBWF (d=0)
		12'b0000_101X_XXXX: decodes = 15'b01_00_1000_0_1_1_1_0_0_0; // SUBWF (d=1)
		12'b0000_110X_XXXX: decodes = 15'b01_11_1000_1_0_1_0_0_0_0; // DECF  (d=0)
		12'b0000_111X_XXXX: decodes = 15'b01_11_1000_0_1_1_0_0_0_0; // DECF  (d=1)
		12'b0001_000X_XXXX: decodes = 15'b00_01_0010_1_0_1_0_0_0_0; // IORWF (d=0)
		12'b0001_001X_XXXX: decodes = 15'b00_01_0010_0_1_1_0_0_0_0; // IORWF (d=1)
		12'b0001_010X_XXXX: decodes = 15'b00_01_0001_1_0_1_0_0_0_0; // ANDWF (d=0)
		12'b0001_011X_XXXX: decodes = 15'b00_01_0001_0_1_1_0_0_0_0; // ANDWF (d=1)
		12'b0001_100X_XXXX: decodes = 15'b00_01_0011_1_0_1_0_0_0_0; // XORWF (d=0)
		12'b0001_101X_XXXX: decodes = 15'b00_01_0011_0_1_1_0_0_0_0; // XORWF (d=1)
		12'b0001_110X_XXXX: decodes = 15'b00_01_0000_1_0_1_1_0_0_0; // ADDWF (d=0)
		12'b0001_111X_XXXX: decodes = 15'b00_01_0000_0_1_1_1_0_0_0; // ADDWF (d=1)
		12'b0010_000X_XXXX: decodes = 15'b01_01_0010_1_0_1_0_0_0_0; // MOVF  (d=0)
		12'b0010_001X_XXXX: decodes = 15'b01_01_0010_0_1_1_0_0_0_0; // MOVF  (d=1)
		12'b0010_010X_XXXX: decodes = 15'b01_01_0100_1_0_1_0_0_0_0; // COMF  (d=0)
		12'b0010_011X_XXXX: decodes = 15'b01_01_0100_0_1_1_0_0_0_0; // COMF  (d=1)
		12'b0010_100X_XXXX: decodes = 15'b01_11_0000_1_0_1_0_0_0_0; // INCF  (d=0)
		12'b0010_101X_XXXX: decodes = 15'b01_11_0000_0_1_1_0_0_0_0; // INCF  (d=1)
		12'b0010_110X_XXXX: decodes = 15'b01_11_1000_1_0_0_0_0_0_0; // DECFSZ(d=0)
		12'b0010_111X_XXXX: decodes = 15'b01_11_1000_0_1_0_0_0_0_0; // DECFSZ(d=1)
		12'b0011_000X_XXXX: decodes = 15'b01_01_0101_1_0_0_1_0_0_0; // RRF   (d=0)
		12'b0011_001X_XXXX: decodes = 15'b01_01_0101_0_1_0_1_0_0_0; // RRF   (d=1)
		12'b0011_010X_XXXX: decodes = 15'b01_01_0110_1_0_0_1_0_0_0; // RLF   (d=0)
		12'b0011_011X_XXXX: decodes = 15'b01_01_0110_0_1_0_1_0_0_0; // RLF   (d=1)
		12'b0011_100X_XXXX: decodes = 15'b01_01_0111_1_0_0_0_0_0_0; // SWAPF (d=0)
		12'b0011_101X_XXXX: decodes = 15'b01_01_0111_0_1_0_0_0_0_0; // SWAPF (d=1)
		12'b0011_110X_XXXX: decodes = 15'b01_11_0000_1_0_0_0_0_0_0; // INCFSZ(d=0)
		12'b0011_111X_XXXX: decodes = 15'b01_11_0000_0_1_0_0_0_0_0; // INCFSZ(d=1)

		// *** Bit-Oriented File Register Operations
                //
		//                                 A  A  ALU  W F Z C B T O
		//                                 L  L   O   W W W W D R P
		//                                 U  U   P   E E E E P I T
		//                                 A  B               O S
		//                                                    L
		12'b0100_XXXX_XXXX: decodes = 15'b11_01_0001_0_1_0_0_1_0_0; // BCF
		12'b0101_XXXX_XXXX: decodes = 15'b11_01_0010_0_1_0_0_0_0_0; // BSF
		12'b0110_XXXX_XXXX: decodes = 15'b11_01_0001_0_0_0_0_0_0_0; // BTFSC
		12'b0111_XXXX_XXXX: decodes = 15'b11_01_0001_0_0_0_0_0_0_0; // BTFSS

		// *** Literal and Control Operations
                //
		//                                 A  A  ALU  W F Z C B T O
		//                                 L  L   O   W W W W D R P
		//                                 U  U   P   E E E E P I T
		//                                 A  B               O S
		//                                                    L
		12'b0000_0000_0010: decodes = 15'b00_00_0010_0_1_0_0_0_0_1; // OPTION
		12'b0000_0000_0011: decodes = 15'b00_00_0000_0_0_0_0_0_0_0; // SLEEP
		12'b0000_0000_0100: decodes = 15'b00_00_0000_0_0_0_0_0_0_0; // CLRWDT
		12'b0000_0000_0101: decodes = 15'b00_00_0000_0_1_0_0_0_1_0; // TRIS 5
		12'b0000_0000_0110: decodes = 15'b00_00_0010_0_1_0_0_0_1_0; // TRIS 6
		12'b0000_0000_0111: decodes = 15'b00_00_0010_0_1_0_0_0_1_0; // TRIS 7
                //
		//                                 A  A  ALU  W F Z C B T O
		//                                 L  L   O   W W W W D R P
		//                                 U  U   P   E E E E P I T
		//                                 A  B               O S
		//                                                    L
		12'b1000_XXXX_XXXX: decodes = 15'b10_10_0010_1_0_0_0_0_0_0; // RETLW
		12'b1001_XXXX_XXXX: decodes = 15'b10_10_0010_0_0_0_0_0_0_0; // CALL
		12'b101X_XXXX_XXXX: decodes = 15'b10_10_0010_0_0_0_0_0_0_0; // GOTO
		12'b1100_XXXX_XXXX: decodes = 15'b10_10_0010_1_0_0_0_0_0_0; // MOVLW
		12'b1101_XXXX_XXXX: decodes = 15'b00_10_0010_1_0_1_0_0_0_0; // IORLW
		12'b1110_XXXX_XXXX: decodes = 15'b00_10_0001_1_0_1_0_0_0_0; // ANDLW
		12'b1111_XXXX_XXXX: decodes = 15'b00_10_0011_1_0_1_0_0_0_0; // XORLW

		default:
			decodes = 15'b00_00_0000_0_0_0_0_0_0_0;
	endcase
end

endmodule


