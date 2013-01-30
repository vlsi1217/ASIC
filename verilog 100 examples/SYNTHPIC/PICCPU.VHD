--*** SYNTHETIC PIC V1.1 ***
--
--		    SYNTHETIC PIC GENERAL PUBLIC LICENSE
--		       Version 1, March 1996
--
-- Copyright (C) 1996. Thomas A. Coonan. All Rights Reserved.
--						     356 Dixie Court, Lawrenceville, GA 30245, USA
--						     email: tcoonan@mindspring.com
--
-- Everyone is permitted to copy and distribute verbatim copies
-- of the Synthetic PIC package, but changing it is not allowed
-- for commercial purposes without the written consent of the author.
-- The Synthetic PIC may be used freely for all educational and
-- evaluation purposes.
--
-- BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
-- FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
-- OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
-- PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
-- OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
-- MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
-- TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
-- PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
-- REPAIR OR CORRECTION.
--
-- If you like the Synthetic PIC, please express your satisfaction with a
-- donation, especially if your purposes are commercial: send me and this
-- project what you feel the Synthetic PIC has been worth to you.  Your
-- donations will help to support the development of more useful software
-- to be distributed on the same basis as this software.  As a registered
-- user, you will receive future updates, fixes, and other additional
-- software and documention related to the project.
--
--			Thomas A. Coonan
--

-- Entity:	PICCPU

-- VIEWLOGIC library, suitable for both simulation and synthesis.
--
library synth;
use synth.stdsynth.ALL;

entity PICCPU is
  port (
	 -- Oscillator input.  This will be divided into the 4 phases inside the model
	 Clk   : in   vlbit;

	 -- Reset
	 MRST  : in vlbit;

	 -- *** partially implemented.. TRIS is not implemented. *YOU* must figure out
	 -- what kind of I/O configuration you want ahead of time.  Stay tuned for
	 -- improvements on this.  Better yet, tell me a good way to handle I/O!
	 --
	 -- Current I/O Configuration is:
	 --    PortA   All Inputs
	 --    PortB   All Output
	 --    PortC   All Output
	 PortA : in  vlbit_1d(7 downto 0);
	 PortB : out vlbit_1d(7 downto 0);
	 PortC : out vlbit_1d(7 downto 0));
end PICCPU;

-- To understand this model, I suggest the following key steps.
--    1) Study the PIC Data sheet's INSTRUCTION SET SUMMARY and the
--       PIC Data Sheet's PIC16C5X SERIES BLOCK DIAGRAM.
--    2) Considering the BLOCK DIAGRAM, consider one level deeper by
--       considering the ALU as having a MUX into its A and B inputs.
--       Also, consider what ALU operations would be considered per
--       PIC instruction.  I discuss this more below..
--
-- I use a lot of Concurrent assignments, which I find easier to treat
-- in a data-driven manner, plus I hope synthesize more efficiently..
--

architecture first of PICCPU is

-- Instantiate subcomponents
--

-- This is the internal register bank.
--
component PICREGS
  port (
	 Clk		:	in  vlbit;

	 WriteEnable    :       in vlbit;

	 -- File Select
	 FSel    :  in vlbit_1d(4 downto 0);

	 -- Input busses
	 Din    :  in  vlbit_1d(7 downto 0);

	 -- Output busses
	 Dout   :  out vlbit_1d(7 downto 0));
end component;

-- And this, is the ALU
--
component PICALU
  port (
	 Op   :  in vlbit_1d(3 downto 0);

	 A    :  in vlbit_1d(7 downto 0);
	 B    :  in vlbit_1d(7 downto 0);
	 Q    :  out vlbit_1d(7 downto 0);

	 CIN   :  in vlbit;
	 COUT :  out vlbit;
	 ZERO :  out vlbit);
end component;

-- This is the Program ROM.  The ROM must be encoded with the program to be run.
--
component PICROM
  port (
	 Addr    : in   vlbit_1d(10 downto 0);
	 Data    : out  vlbit_1d(11 downto 0));
end component;

signal RomAddr  : vlbit_1d(10 downto 0);
signal RomData  : vlbit_1d(11 downto 0);

-- Clock Phases
signal Q1 : vlbit := '0';
signal Q2 : vlbit := '0';
signal Q3 : vlbit := '0';
signal Q4 : vlbit := '0';

-- This should be set to the ROM location where our restart vector is.
--
constant RESET_VECTOR : vlbit_1d(10 downto 0) := "11111111111";

-- Special internal registers
--
signal INST : vlbit_1d(11 downto 0)   := "000000000000";
signal PC   : vlbit_1d(10 downto 0)   := "00000000000";
signal W    : vlbit_1d(7  downto 0)   := "00000000";
signal STATUS  : vlbit_1d(7 downto 0) := "00000000";

signal STACKLEVEL  :  vlbit_1d(1 downto 0) := "00";
signal STACK1  : vlbit_1d(10 downto 0) := "00000000000";
signal STACK2  : vlbit_1d(10 downto 0) := "00000000000";

signal RTCC  : vlbit_1d(7 downto 0);
signal FSR   : vlbit_1d(7 downto 0);

-- Input signals leading into the W register
signal WIN    : vlbit_1d(7  downto 0);

-- These will be driven by an incrementer and +2 incrementer attached
-- to the PC outputs
--
signal PCPLUS1  : vlbit_1d(11 downto 0);

-- Derive special sub signals from INST register
signal K      : vlbit_1d(7 downto 0);
signal FSEL   : vlbit_1d(4 downto 0);
signal LONGK  : vlbit_1d(8 downto 0);
signal D      : vlbit;
signal B      : vlbit_1d(2 downto 0);

-- Signals for output ports, which are regsitered.  For input ports, we'll
-- simply sample the ports directly.
-- signal PortARegister : vlbit_1d(7 downto 0);  -- An input in this configuration
signal PortBRegister : vlbit_1d(7 downto 0);
signal PortCRegister : vlbit_1d(7 downto 0);


-- There will be a signal for every instruction/opcode.  These signals
-- will be decoded from the INST register.
--
-- Byte-Oriented File Register Operations
signal OPCODE_NOP    : vlbit;
signal OPCODE_MOVWF  : vlbit;
signal OPCODE_CLRW   : vlbit;
signal OPCODE_CLRF   : vlbit;
signal OPCODE_SUBWF  : vlbit;
signal OPCODE_DECF   : vlbit;
signal OPCODE_IORWF  : vlbit;
signal OPCODE_ANDWF  : vlbit;
signal OPCODE_XORWF  : vlbit;
signal OPCODE_ADDWF  : vlbit;
signal OPCODE_MOVF  : vlbit;
signal OPCODE_COMF  : vlbit;
signal OPCODE_INCF  : vlbit;
signal OPCODE_DECFSZ  : vlbit;
signal OPCODE_RRF  : vlbit;
signal OPCODE_RLF  : vlbit;
signal OPCODE_SWAPF  : vlbit;
signal OPCODE_INCFSZ  : vlbit;

-- Bit-Oriented File Register Operations
signal OPCODE_BCF  : vlbit;
signal OPCODE_BSF  : vlbit;
signal OPCODE_BTFSC  : vlbit;
signal OPCODE_BTFSS  : vlbit;

-- Literal and Control Operations
signal OPCODE_OPTION  : vlbit;
signal OPCODE_SLEEP  : vlbit;
signal OPCODE_CLRWDT  : vlbit;
signal OPCODE_TRIS  : vlbit;
signal OPCODE_RETLW  : vlbit;
signal OPCODE_CALL  : vlbit;
signal OPCODE_GOTO  : vlbit;
signal OPCODE_MOVLW  : vlbit;
signal OPCODE_IORLW  : vlbit;
signal OPCODE_ANDLW  : vlbit;
signal OPCODE_XORLW  : vlbit;

-- Signal true whenever a K operand is used.  Conveniently, this
-- is any instruction with MSB set.
--
signal OPCODE_USE_K_OPERAND  : vlbit;

-- ALU Signals
--
signal ALUOP  : vlbit_1d(3 downto 0);
signal ALUA   : vlbit_1d(7 downto 0);
signal ALUB   : vlbit_1d(7 downto 0);
signal ALUOUT : vlbit_1d(7 downto 0);
signal ALUCIN : vlbit;
signal ALUCOUT : vlbit;
signal ALUZ   : vlbit;

-- Write enable for the actual ZERO and CARRY bits within the status register
--
signal STATUS_Z_WRITE  :  vlbit;
signal STATUS_C_WRITE  :  vlbit;

-- Signals in and out of the register file
--
-- The two are directly connected to the register file.
signal REG_FIN    : vlbit_1d(7 downto 0);
signal REG_FOUT   : vlbit_1d(7 downto 0);

-- The two are input and output of any additional multiplexors
-- and are connected to the ALU, etc.
signal FIN        : vlbit_1d(7 downto 0);
signal FOUT       : vlbit_1d(7 downto 0);

signal FWE    : vlbit;

constant  ALUOP_ADD    : vlbit_1d (3 downto 0) := "0000";
constant  ALUOP_SUB    : vlbit_1d (3 downto 0) := "0001";
constant  ALUOP_AND    : vlbit_1d (3 downto 0) := "0010";
constant  ALUOP_OR     : vlbit_1d (3 downto 0) := "0011";
constant  ALUOP_XOR    : vlbit_1d (3 downto 0) := "0100";
constant  ALUOP_COM    : vlbit_1d (3 downto 0) := "0101";
constant  ALUOP_ROR    : vlbit_1d (3 downto 0) := "0110";
constant  ALUOP_ROL    : vlbit_1d (3 downto 0) := "0111";
constant  ALUOP_SWAP   : vlbit_1d (3 downto 0) := "1000";
constant  ALUOP_BITCLR : vlbit_1d (3 downto 0) := "1001";
constant  ALUOP_BITSET : vlbit_1d (3 downto 0) := "1010";
constant  ALUOP_BITTESTCLR : vlbit_1d (3 downto 0) := "1011";
constant  ALUOP_BITTESTSET : vlbit_1d (3 downto 0) := "1100";

constant NOP     : vlbit_1d (11 downto 0) := "000000000000";
constant MOVWF   : vlbit_1d (6 downto 0)  := "0000001";
constant CLRW    : vlbit_1d (6 downto 0)  := "0000010";
constant CLRF    : vlbit_1d (6 downto 0)  := "0000011";
constant SUBWF   : vlbit_1d (5 downto 0)  := "000010";
constant DECF    : vlbit_1d (5 downto 0)  := "000011";
constant IORWF   : vlbit_1d (5 downto 0)  := "000100";

constant ANDWF   : vlbit_1d (5 downto 0) := "000101";
constant XORWF   : vlbit_1d (5 downto 0) := "000110";
constant ADDWF   : vlbit_1d (5 downto 0) := "000111";
constant MOVF    : vlbit_1d (5 downto 0) := "001000";
constant COMF    : vlbit_1d (5 downto 0) := "001001";
constant INCF    : vlbit_1d (5 downto 0) := "001010";
constant DECFSZ  : vlbit_1d (5 downto 0) := "001011";
constant RRF     : vlbit_1d (5 downto 0) := "001100";
constant RLF     : vlbit_1d (5 downto 0) := "001101";
constant SWAPF   : vlbit_1d (5 downto 0) := "001110";
constant INCFSZ  : vlbit_1d (5 downto 0) := "001111";

-- Bit-Oriented File Register Operations
constant BCF    : vlbit_1d (3 downto 0) := "0100";
constant BSF    : vlbit_1d (3 downto 0) := "0101";
constant BTFSC  : vlbit_1d (3 downto 0) := "0110";
constant BTFSS  : vlbit_1d (3 downto 0) := "0111";

-- Literal and Control Operations
constant OPTION : vlbit_1d (11 downto 0) := "000000000010";
constant SLEEP  : vlbit_1d (11 downto 0) := "000000000011";
constant CLRWDT : vlbit_1d (11 downto 0) := "000000000100";
constant TRIS   : vlbit_1d (11 downto 0) := "000000000111";
constant RETLW  : vlbit_1d (3 downto 0) := "1000";
constant CALL   : vlbit_1d (3 downto 0) := "1001";
constant GOTO   : vlbit_1d (2 downto 0) := "101";
constant MOVLW  : vlbit_1d (3 downto 0) := "1100";
constant IORLW  : vlbit_1d (3 downto 0) := "1101";
constant ANDLW  : vlbit_1d (3 downto 0) := "1110";
constant XORLW  : vlbit_1d (3 downto 0) := "1111";

begin
	-- Instantiate each of our subcomponents
	--
	REGS : PICREGS port map (Q1, FWE, FSEL, REG_FIN, REG_FOUT);
	ALU  : PICALU  port map (ALUOP, ALUA, ALUB, ALUOUT, STATUS(0), ALUCOUT, ALUZ);
	ROM  : PICROM  port map (RomAddr, RomData);

	-- No additional mux input the register file.
	REG_FIN <= FIN;

	-- The FOUT is the output of the Register File plus any special register
	-- signals.  So, FOUT is the output of the MUX whose inputs are FOUT plus
	-- any other special registers inputs.
	--
	FOUT <= FSR            When (v1d2int(FSEL) = 0) Else
			  RTCC           When (v1d2int(FSEL) = 1) Else
			  PC(7 downto 0) When (v1d2int(FSEL) = 2) Else
			  STATUS         When (v1d2int(FSEL) = 3) Else
			  FSR            When (v1d2int(FSEL) = 4) Else
			  PortA          When (v1d2int(FSEL) = 5) Else  -- Can always read Port
			  PortBRegister  When (v1d2int(FSEL) = 6) Else  -- Can always read Port
			  PortCRegister  When (v1d2int(FSEL) = 7) Else  -- Can always read Port
			  REG_FOUT;


	-- I/O Ports
	PortB <= PortBRegister;
	PortC <= PortCRegister;

	-- Drive the ROM Address bus straight from the PC
	--
	RomAddr <= PC;

	-- PC Incrementor.  This doesn't mean that the PC is always incremented, just
	--                  that we do generate the signal and make it available.
	--
	PCPLUS1 <= addum (PC(10 downto 0), "00000000001");

	-- Define sub-signals out of INSTR
	--
	K     <= INST(7  downto 0);
	FSEL  <= INST(4  downto 0);
	LONGK <= INST(8  downto 0);
	D     <= INST(5);
	B     <= INST(7 downto 5);

	OPCODE_USE_K_OPERAND <= INST(11);

	-- Figure out the exact instruction.  A single bit is decoded
	-- from the INST
		  --
	OPCODE_NOP     <= '1' when INST(11 downto 0) = NOP       else '0';
	OPCODE_MOVWF   <= '1' when INST(11 downto 5) = MOVWF     else '0';
	OPCODE_CLRW    <= '1' when INST(11 downto 5) = CLRW      else '0';
	OPCODE_CLRF    <= '1' when INST(11 downto 5) = CLRF      else '0';
	OPCODE_SUBWF   <= '1' when INST(11 downto 6) = SUBWF     else '0';
	OPCODE_DECF    <= '1' when INST(11 downto 6) = DECF      else '0';

	OPCODE_ANDWF   <= '1' when INST(11 downto 6) = ANDWF     else '0';
	OPCODE_XORWF   <= '1' when INST(11 downto 6) = XORWF     else '0';
	OPCODE_ADDWF   <= '1' when INST(11 downto 6) = ADDWF     else '0';
	OPCODE_IORWF   <= '1' when INST(11 downto 6) = IORWF     else '0';
	OPCODE_MOVF    <= '1' when INST(11 downto 6) = MOVF      else '0';
	OPCODE_COMF    <= '1' when INST(11 downto 6) = COMF      else '0';
	OPCODE_INCF    <= '1' when INST(11 downto 6) = INCF      else '0';
	OPCODE_DECFSZ  <= '1' when INST(11 downto 6) = DECFSZ    else '0';
	OPCODE_RRF     <= '1' when INST(11 downto 6) = RRF       else '0';
	OPCODE_RLF     <= '1' when INST(11 downto 6) = RLF       else '0';
	OPCODE_SWAPF   <= '1' when INST(11 downto 6) = SWAPF     else '0';
	OPCODE_INCFSZ  <= '1' when INST(11 downto 6) = INCFSZ    else '0';

	-- Bit-Oriented File Register Operations
	OPCODE_BCF     <= '1' when INST(11 downto 8) = BCF      else '0';
	OPCODE_BSF     <= '1' when INST(11 downto 8) = BSF      else '0';
	OPCODE_BTFSC   <= '1' when INST(11 downto 8) = BTFSC    else '0';
	OPCODE_BTFSS   <= '1' when INST(11 downto 8) = BTFSS    else '0';

	 -- Literal and Control Operations
	OPCODE_OPTION  <= '1' when INST(11 downto 0) = OPTION   else '0';
	OPCODE_SLEEP   <= '1' when INST(11 downto 0) = SLEEP    else '0';
	OPCODE_CLRWDT  <= '1' when INST(11 downto 0) = CLRWDT   else '0';
	--*** CHECK OUT THE TRIS INSTRUCTION
	OPCODE_TRIS    <= '1' when INST(11 downto 0) = TRIS     else '0';
	OPCODE_RETLW   <= '1' when INST(11 downto 8) = RETLW    else '0';
	OPCODE_CALL    <= '1' when INST(11 downto 8) = CALL     else '0';
	OPCODE_GOTO    <= '1' when INST(11 downto 9) = GOTO     else '0';
	OPCODE_MOVLW   <= '1' when INST(11 downto 8) = MOVLW    else '0';
	OPCODE_IORLW   <= '1' when INST(11 downto 8) = IORLW    else '0';
	OPCODE_ANDLW   <= '1' when INST(11 downto 8) = ANDLW    else '0';
	OPCODE_XORLW   <= '1' when INST(11 downto 8) = XORLW    else '0';

	-- So, look at the instruction chart.  Which instructions affect the Z flag
	--
	STATUS_Z_WRITE <= '1' when ((OPCODE_CLRW  = '1') OR
										(OPCODE_CLRF  = '1')  OR
										(OPCODE_SUBWF = '1') OR
										(OPCODE_DECF  = '1')  OR
										(OPCODE_IORWF = '1') OR
										(OPCODE_ANDWF = '1') OR
										(OPCODE_XORWF = '1') OR
										(OPCODE_ADDWF = '1') OR
										(OPCODE_MOVF  = '1')  OR
										(OPCODE_COMF  = '1')  OR
										(OPCODE_INCF  = '1')  OR
										(OPCODE_IORLW = '1') OR
										(OPCODE_ANDLW = '1') OR
										(OPCODE_XORLW = '1')) Else '0';

	-- So, look at the instruction chart.  Which instructions affect the C flag
	--
	STATUS_C_WRITE <= '1' when ((OPCODE_SUBWF = '1') OR
										(OPCODE_ADDWF = '1') OR
										(OPCODE_RRF   = '1') OR
										(OPCODE_RLF   = '1')) Else '0';

	-- The input to the W register is WIN and is fed by a mux.
	-- There are only two busses that can affect a new W value; the W
	-- register itself, or the ALU output.  Now, even though there is
	-- a MOVLW instruction, the literal travels through the ALU!
	--
	WIN <= ALUOUT when ( (OPCODE_CLRW    = '1') OR
								(OPCODE_SUBWF   = '1' AND D = '0') OR
								(OPCODE_DECF    = '1' AND D = '0') OR
								(OPCODE_IORWF   = '1' AND D = '0') OR
								(OPCODE_ANDWF   = '1' AND D = '0') OR
								(OPCODE_XORWF   = '1' AND D = '0') OR
								(OPCODE_ADDWF   = '1' AND D = '0') OR
								(OPCODE_MOVF    = '1' AND D = '0') OR
								(OPCODE_COMF    = '1' AND D = '0') OR
								(OPCODE_INCF    = '1' AND D = '0') OR
								(OPCODE_DECFSZ  = '1' AND D = '0') OR
								(OPCODE_RRF     = '1' AND D = '0') OR
								(OPCODE_RLF     = '1' AND D = '0') OR
								(OPCODE_SWAPF   = '1' AND D = '0') OR
								(OPCODE_INCFSZ  = '1' AND D = '0') OR
								(OPCODE_RETLW   = '1') OR
								(OPCODE_MOVLW   = '1') OR
								(OPCODE_IORLW   = '1') OR
								(OPCODE_ANDLW   = '1') OR
								(OPCODE_XORLW   = '1'))
	  else W;

	-- The input to the Register File is FIN and is fed by a mux.
	-- The only two sources for new Register File values is either
	-- the register file itself (in other words, no change) or the
	-- output of the ALU.  Remember!  Most data gets routed through
	-- the ALU even if the ALU is not really doing anything to it.
	-- Look at the ALUOP operations per instruction to really understand
	-- this.
	--
	FIN <= ALUOUT when ( (OPCODE_CLRF    = '1')  OR
								(OPCODE_MOVWF   = '1')  OR
								(OPCODE_SUBWF   = '1' AND D = '1') OR
								(OPCODE_DECF    = '1' AND D = '1') OR
								(OPCODE_IORWF   = '1' AND D = '1') OR
								(OPCODE_ANDWF   = '1' AND D = '1') OR
								(OPCODE_XORWF   = '1' AND D = '1') OR
								(OPCODE_ADDWF   = '1' AND D = '1') OR
								(OPCODE_MOVF    = '1' AND D = '1') OR
								(OPCODE_COMF    = '1' AND D = '1') OR
								(OPCODE_INCF    = '1' AND D = '1') OR
								(OPCODE_DECFSZ  = '1' AND D = '1') OR
								(OPCODE_RRF     = '1' AND D = '1') OR
								(OPCODE_RLF     = '1' AND D = '1') OR
								(OPCODE_SWAPF   = '1' AND D = '1') OR
								(OPCODE_BCF     = '1') OR
								(OPCODE_BSF     = '1') OR
								(OPCODE_INCFSZ  = '1' AND D = '1'))
	  else FOUT;

	-- Register File write enable depends on the instruction..
	FWE <= '1' when (    (OPCODE_CLRF    = '1')  OR
								(OPCODE_MOVWF   = '1')  OR
								(OPCODE_BCF     = '1')  OR
								(OPCODE_BSF     = '1')  OR
								(OPCODE_SUBWF   = '1' AND D = '1') OR
								(OPCODE_DECF    = '1' AND D = '1') OR
								(OPCODE_IORWF   = '1' AND D = '1') OR
								(OPCODE_ANDWF   = '1' AND D = '1') OR
								(OPCODE_XORWF   = '1' AND D = '1') OR
								(OPCODE_ADDWF   = '1' AND D = '1') OR
								(OPCODE_MOVF    = '1' AND D = '1') OR
								(OPCODE_COMF    = '1' AND D = '1') OR
								(OPCODE_INCF    = '1' AND D = '1') OR
								(OPCODE_DECFSZ  = '1' AND D = '1') OR
								(OPCODE_RRF     = '1' AND D = '1') OR
								(OPCODE_RLF     = '1' AND D = '1') OR
								(OPCODE_SWAPF   = '1' AND D = '1') OR
								(OPCODE_INCFSZ  = '1' AND D = '1'))
	  else '0';



	-- The exact operation the ALU will perform is a function
	-- of the instruction.  Note that the ALU is used to do
	-- things like copying and clearing registers.  For example,
	-- clearing a register can be accomplished by XORing any
	-- two identical input into ALU and feeding the resulting
	-- zero into the destination, therefore, the CLRW instruction
	-- will force the ALU to do an XOR.
	--
	-- One way to see this, is to take the PIC instruction set table from
	-- the data book, and add 3 new columns.  First, the ALUA mux input
	-- (which can be F, K, or W), second column is the ALUB mux input
	-- (which can be F, K,, W or "00000001") and finally the third column
	-- which is the ALUOP.  For many instructions, the ALUOP is obvious.
	-- For example, for the ADDWF instruction, the ALUOP value is ALU_ADD.
	-- But for instruction like CLRW or MOVWF the ALUOP will be XOR, or OR.
	-- A little bit of Boolean Algebra will help you through this.
	--
	-- I believe that the above mechanisms are likely what is actually going
	-- on in the PIC, but since I'm not privy to their design, this is speculation.
	--
	ALUOP  <= ALUOP_SUB  when (OPCODE_SUBWF  = '1') OR
									  (OPCODE_DECF   = '1') OR
									  (OPCODE_DECFSZ = '1') else
				 ALUOP_ADD  when (OPCODE_ADDWF  = '1') OR
									  (OPCODE_INCF   = '1') OR
									  (OPCODE_INCFSZ = '1') else
				 ALUOP_OR   when (OPCODE_MOVWF  = '1') OR
									  (OPCODE_IORWF  = '1') OR
									  (OPCODE_MOVF   = '1') OR
									  (OPCODE_RETLW  = '1') OR
									  (OPCODE_MOVLW  = '1') OR
									  (OPCODE_IORLW  = '1') else
				 ALUOP_AND  when (OPCODE_ANDWF  = '1') OR
									  (OPCODE_ANDLW  = '1') else
				 ALUOP_XOR  when (OPCODE_CLRW   = '1') OR
									  (OPCODE_CLRF   = '1') OR
									  (OPCODE_XORWF  = '1') OR
									  (OPCODE_XORLW  = '1') else
				 ALUOP_COM  when (OPCODE_COMF   = '1') else
				 ALUOP_ROR  when (OPCODE_RRF    = '1') else
				 ALUOP_ROL  when (OPCODE_RLF    = '1') else
				 ALUOP_BITCLR when (OPCODE_BCF  = '1') else
				 ALUOP_BITSET when (OPCODE_BSF  = '1') else
				 ALUOP_BITTESTCLR when (OPCODE_BTFSC  = '1') else
				 ALUOP_BITTESTSET when (OPCODE_BTFSS  = '1') else
				 ALUOP_SWAP when (OPCODE_SWAPF  = '1') else
		 "1111";

	-- ALU Input port A should normally simply get the current W register.
	--
	ALUA  <= FOUT when (OPCODE_SUBWF  = '1') OR
							 (OPCODE_DECF   = '1') OR
							 (OPCODE_MOVF   = '1') OR
							 (OPCODE_COMF   = '1') OR
							 (OPCODE_INCF   = '1') OR
							 (OPCODE_DECFSZ = '1') OR
							 (OPCODE_RRF    = '1') OR
							 (OPCODE_RLF    = '1') OR
							 (OPCODE_SWAPF  = '1') OR
							 (OPCODE_INCFSZ = '1') OR
							 (OPCODE_BCF    = '1') OR
							 (OPCODE_BSF    = '1') OR
							 (OPCODE_BTFSC  = '1') OR
							 (OPCODE_BTFSS  = '1') else
				K    when (OPCODE_USE_K_OPERAND = '1')
		 else W;

	-- ALU Input port B should normally simply get the current F register file.
	--
	ALUB  <= W    when (OPCODE_MOVWF    = '1') OR
							 (OPCODE_CLRW     = '1') OR
							 (OPCODE_CLRF     = '1') OR
							 (OPCODE_SUBWF    = '1') OR
							 (OPCODE_IORLW    = '1') OR
							 (OPCODE_ANDLW    = '1') OR
							 (OPCODE_XORLW    = '1')  else
		 K         when (OPCODE_BCF      = '1') OR
							 (OPCODE_BSF      = '1') OR
							 (OPCODE_BTFSC    = '1') OR
							 (OPCODE_BTFSS    = '1') OR
							 (OPCODE_RETLW    = '1') OR
							 (OPCODE_MOVLW    = '1')  else
		"00000001" when (OPCODE_DECF     = '1') OR
							 (OPCODE_INCF     = '1') OR
							 (OPCODE_DECFSZ   = '1') OR
							 (OPCODE_INCFSZ   = '1')
		else FOUT;

	-- Process for deriving our 4 phase clock from the main clock.
	-- This is how the real PIC does it..
	--
	ClockDivider: process (Clk)
	begin
		-- *** Generate internal 4 phase clock
		if Clk'EVENT AND Clk = '1' then
			if MRST = '0' then
				Q1 <= '1';
				Q2 <= '0';
				Q3 <= '0';
				Q4 <= '0';
			else
				Q1 <= Q4;
				Q2 <= Q1;
				Q3 <= Q2;
				Q4 <= Q3;
			end if;
		end if;
	end process ClockDivider;

	-- Main Process is based on rising edge of Q1.
	--
	MainProcess: process (Q1)

	begin
		if Q1'EVENT AND Q1 = '1' then

			-- RESET!
			if MRST = '0' then
				-- Perhaps, more things need to be reset, but this is the minimum.
				PC     <= RESET_VECTOR;
				INST   <= NOP;
				STATUS <= "00000000";
			else

				-- For 2 cycle instructions, latch a NOP into INST so as not to
				-- distrurb ongoing instruction.
				if (OPCODE_GOTO   = '1') OR
					(OPCODE_RETLW  = '1') OR
					(OPCODE_CALL   = '1') OR
					(OPCODE_DECFSZ = '1' AND ALUZ = '1') OR
					(OPCODE_INCFSZ = '1' AND ALUZ = '1') OR
					(OPCODE_BTFSC  = '1' AND ALUZ = '1') OR
					(OPCODE_BTFSS  = '1' AND ALUZ = '1') OR
					(FWE = '1' AND v1d2int(FSEL) = 2)  then
					-- NOP
					INST <= NOP;
				else
					INST <= RomData;
				end if;

				-- Latch new values of registers based on MUX select lines
				W <= WIN;

				-- Handle writes to registers not actually in the REGFILE.
				-- Special functions could be added here!
				--
				if FWE = '1' then
					case v1d2int(FSEL) is
						when 0 => NULL;
						when 1 => RTCC   <= FIN;
						-- when 2 => PC(7 downto 0)     <= FIN; *** handle this below ***
						when 3 => STATUS <= FIN;
						when 4 => FSR    <= FIN;
						-- when 5 => PortA  <= FIN;  -- Let's make PortA an input !
						when 6 => PortBRegister <= FIN;
						when 7 => PortCRegister <= FIN;
						when OTHERS => NULL;
					end case;
				end if;

				-- Handle Status Flags
				if STATUS_C_WRITE = '1' then
					STATUS(0) <= ALUCOUT;
				end if;

				if STATUS_Z_WRITE = '1' then
					STATUS(2) <= ALUZ;
				end if;

				-- Handle the PC
				--
				-- GOTO instruction
				if OPCODE_GOTO = '1' then
					PC(8 downto 0) <= LONGK;

				-- CALL instruction
				elsif OPCODE_CALL = '1' then
					PC(7 downto 0) <= K;
					case v1d2int(STACKLEVEL) is
						when 0 => STACK1 <= PC;
									 STACKLEVEL <= "01";
						when 1 => STACK2 <= PC;
									 STACKLEVEL <= "10";
						when OTHERS => NULL;
					end case;

				-- RETLW instruction
				elsif OPCODE_RETLW = '1' then
					-- You can add more stack levels here!
					case v1d2int(STACKLEVEL) is
						when 1 => PC <= STACK1;
									 STACKLEVEL <= "00";
						when 2 => PC <= STACK2;
									 STACKLEVEL <= "01";
						when OTHERS => NULL;

					end case;

				-- Handle direct write to PC
				--
				elsif FWE = '1' AND v1d2int(FSEL) = 2 then
					PC(7 downto 0) <= FIN;

				-- Otherwise, just increment the PC
				else
					PC <= PCPLUS1(10 downto 0);
				end if;
			end if;
		end if;
	end process;

	-- *** NOT YET IMPLEMENTED ***
	-- *** In general, modeling of Ports is minimal. ***
	--
	-- Process for sampling input ports based on rising edge of Q2
	--SampleInputs: process (Q2)
	--
	--begin
	--	if PRising(Q2) then
	--
	--	end if;
	--end process SampleInputs;

end first;