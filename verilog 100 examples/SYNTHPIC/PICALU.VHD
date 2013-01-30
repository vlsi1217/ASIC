--*** SYNTHETIC PIC V1.0 ***
--
-- VHDL
--
-- Entity:	ALU
--
--	Purpose: This is a synthesizable ALU for the Synthetic PIC.  It is a tad
--          specific to the PIC with some of the ALU ops such as SWAP and
--          BITTESTing.
--
--          This entity is purely combinatorial.
--
-- See licencing agreement in the file PICCPU.VHD
--
-- VIEWLOGIC libraries suitable for both simulation and for synthesis.
--
library synth;
use synth.stdsynth.ALL;

entity PICALU is
  port (

	 -- Operation will depend on the PIC Instruction opcode.
	 Op   :  in vlbit_1d(3 downto 0);

	 -- Main 8-bit inputs and output
	 A    :  in vlbit_1d(7 downto 0);
	 B    :  in vlbit_1d(7 downto 0);
	 Q    :  out vlbit_1d(7 downto 0);

	 -- Carries and zero out
	 CIN  :  in vlbit;
	 COUT :  out vlbit;
	 ZERO :  out vlbit);
end PICALU;


architecture first of PICALU is

constant  ALUOP_ADD        : vlbit_1d (3 downto 0)     := "0000";
constant  ALUOP_SUB        : vlbit_1d (3 downto 0)     := "0001";
constant  ALUOP_AND        : vlbit_1d (3 downto 0)     := "0010";
constant  ALUOP_OR         : vlbit_1d (3 downto 0)     := "0011";
constant  ALUOP_XOR        : vlbit_1d (3 downto 0)     := "0100";
constant  ALUOP_COM        : vlbit_1d (3 downto 0)     := "0101";
constant  ALUOP_ROR        : vlbit_1d (3 downto 0)     := "0110";
constant  ALUOP_ROL        : vlbit_1d (3 downto 0)     := "0111";
constant  ALUOP_SWAP       : vlbit_1d (3 downto 0)     := "1000";
constant  ALUOP_BITCLR     : vlbit_1d (3 downto 0)     := "1001";
constant  ALUOP_BITSET     : vlbit_1d (3 downto 0)     := "1010";
constant  ALUOP_BITTESTCLR : vlbit_1d (3 downto 0)     := "1011";
constant  ALUOP_BITTESTSET : vlbit_1d (3 downto 0)     := "1100";

-- This will help us decide when to raise the Z flag.
constant  ZEROBYTE : vlbit_1d (7 downto 0) := "00000000";

-- B_2SC is the 2s Complement (i.e. negative) of B.  We'll use this
-- for our SUB operation, rather than use the sub2c built-in, which
-- didn't work quite right...
--
signal B_2SC       : vlbit_1d (8 downto 0);

-- LONGQ is simply the 8-bit Q output with the additional carry out MSB that
-- results from Adds and Subtracts, as well as rotates.
-- Typically, just think of LONGQ(8) as being the carryout signal
--
signal LONGQ       : vlbit_1d (8 downto 0);

-- The BITDECODER simply decodes out the encoded B field in many PIC instructions.
-- This decoded vector is then used for masking and such.
--
signal BITDECODER  : vlbit_1d (7 downto 0);
signal BITTEST     : vlbit_1d (7 downto 0);

begin

	-- Q output is the 8-bit output without the carry out
	--
	Q  <= LONGQ(7 downto 0);

	-- Now.. The Z flag will also represent how the BIT Testing operations
	--       turn out.  For the bit testing ops, the ZERO won't ultimately
	--       affect the STATUS register.
	--
	ZERO <= '1' When LONGQ(7 downto 0) = ZEROBYTE	else
			  '1' When (BITTEST /= ZEROBYTE) AND (Op = ALUOP_BITTESTSET) else
			  '1' When (BITTEST  = ZEROBYTE) AND (Op = ALUOP_BITTESTCLR) else
			  '0';

	-- Eg. Negative B
	--
	B_2SC <= addum (NOT B, "1");

	-- Carry out is the MSB of the Long Q vector.
	--
	COUT <= LONGQ(8);

	-- Here's the main ALU datapath.
	--
	LONGQ <= addum (A(7 downto 0), B(7 downto 0))     When Op = ALUOP_ADD Else
				addum (A(7 downto 0), B_2SC(7 downto 0)) When Op = ALUOP_SUB Else
				"0" & (A AND B)                          When Op = ALUOP_AND Else
				"0" & (A OR  B)                          When Op = ALUOP_OR Else
				"0" & (A XOR B)                          When Op = ALUOP_XOR Else
				"0" & (NOT   A)                          When Op = ALUOP_COM Else
				A(0)& CIN & A(7 downto 1)                When Op = ALUOP_ROR Else
				A & CIN                                  When Op = ALUOP_ROL Else
				"0" &	A(3 downto 0) & A(7 downto 4)      When Op = ALUOP_SWAP Else
				"0" & ((NOT BITDECODER) AND A)           When Op = ALUOP_BITCLR Else
				"0" & (BITDECODER OR A)                  When Op = ALUOP_BITSET Else
				"0" & A;

	-- This is where we expand (eg. decode) the PIC Instruction "b" field.
	-- The decoded value becomes the mask used for the logical comparison.
	--
	BITDECODER <= "00000001" When v1d2int(B(7 downto 5)) = 0 Else
					  "00000010" When v1d2int(B(7 downto 5)) = 1 Else
					  "00000100" When v1d2int(B(7 downto 5)) = 2 Else
					  "00001000" When v1d2int(B(7 downto 5)) = 3 Else
					  "00010000" When v1d2int(B(7 downto 5)) = 4 Else
					  "00100000" When v1d2int(B(7 downto 5)) = 5 Else
					  "01000000" When v1d2int(B(7 downto 5)) = 6 Else
					  "10000000" When v1d2int(B(7 downto 5)) = 7 Else
					  "00000000";

	-- Used for the BITTESTSET and BITTESTCLR operations.
	--
	BITTEST    <= BITDECODER AND A;
end first;
