--*** SYNTHETIC PIC V1.1 ***
--
-- VHDL
--
-- Entity:	REGFILE
--	Purpose: This is a synthesizable Register File
--
--      Special Notes:
--           For the PIC, registers 0-7 are special registers
--           and are not part of this module; they are the special
--           PIC registers like the PC and STATUS register.
--
-- Note: This entity is most likely going to be synthesized in some other way
-- for a real ASIC or even FPGA (although it is synthesizable as is).
-- Some sort of MEMGEN program specific to the technology being used
-- can be used.
--
-- See licencing agreement in the file PICCPU.VHD
--

-- VIEWLOGIC libraries suitable for both simulation and for synthesis.
--
library synth;
use synth.stdsynth.ALL;

entity PICREGS is
  port (
	 Clk		:	in  vlbit;

	 WriteEnable    :       in vlbit;

	 -- Interface to microprogram in ROM
	 FSel    :  in vlbit_1d(4 downto 0);

	 -- Input busses
	 Din    :  in  vlbit_1d(7 downto 0);

	 -- Output busses
	 Dout    :  out vlbit_1d(7 downto 0));
end PICREGS;


architecture first of PICREGS is

-- Registers
--
-- Note: I've commented out the higher registers beyond R12 because I
--       did not reference them in my test, and they bog down my
--       synthesizer.
--
signal R8  :  vlbit_1d (7 downto 0);
signal R9  :  vlbit_1d (7 downto 0);
signal R10 :  vlbit_1d (7 downto 0);
signal R11 :  vlbit_1d (7 downto 0);
signal R12 :  vlbit_1d (7 downto 0);
-- ** Let's not synthesize any more for now..
-- signal R13 :  vlbit_1d (7 downto 0);
-- signal R14 :  vlbit_1d (7 downto 0);
-- signal R15 :  vlbit_1d (7 downto 0);
-- signal R16 :  vlbit_1d (7 downto 0);
-- signal R17 :  vlbit_1d (7 downto 0);
-- signal R18 :  vlbit_1d (7 downto 0);
-- signal R19 :  vlbit_1d (7 downto 0);
-- signal R20 :  vlbit_1d (7 downto 0);
-- signal R21 :  vlbit_1d (7 downto 0);
-- signal R22 :  vlbit_1d (7 downto 0);
-- signal R23 :  vlbit_1d (7 downto 0);
-- signal R24 :  vlbit_1d (7 downto 0);
-- signal R25 :  vlbit_1d (7 downto 0);
-- signal R26 :  vlbit_1d (7 downto 0);
-- signal R27 :  vlbit_1d (7 downto 0);
-- signal R28 :  vlbit_1d (7 downto 0);
-- signal R29 :  vlbit_1d (7 downto 0);
-- signal R30 :  vlbit_1d (7 downto 0);
-- signal R31 :  vlbit_1d (7 downto 0);

begin
	-- Concurrently always route register outputs out the register file based
	-- on the select lines.
	--
	Dout <= R8  When v1d2int(Fsel) =  8 Else
			  R9  When v1d2int(Fsel) =  9 Else
			  R10 When v1d2int(Fsel) = 10 Else
			  R11 When v1d2int(Fsel) = 11 Else
			  R12 When v1d2int(Fsel) = 12 Else
			  -- R13 When v1d2int(Fsel) = 13 Else
			  -- R14 When v1d2int(Fsel) = 14 Else
			  -- R15 When v1d2int(Fsel) = 15 Else
			  -- R16 When v1d2int(Fsel) = 16 Else
			  -- R17 When v1d2int(Fsel) = 17 Else
			  -- R18 When v1d2int(Fsel) = 18 Else
			  -- R19 When v1d2int(Fsel) = 19 Else
			  -- R20 When v1d2int(Fsel) = 20 Else
			  -- R21 When v1d2int(Fsel) = 21 Else
			  -- R22 When v1d2int(Fsel) = 22 Else
			  -- R23 When v1d2int(Fsel) = 23 Else
			  -- R24 When v1d2int(Fsel) = 24 Else
			  -- R25 When v1d2int(Fsel) = 25 Else
			  -- R26 When v1d2int(Fsel) = 26 Else
			  -- R27 When v1d2int(Fsel) = 27 Else
			  -- R28 When v1d2int(Fsel) = 28 Else
			  -- R29 When v1d2int(Fsel) = 29 Else
			  -- R30 When v1d2int(Fsel) = 30 Else
			  -- R31 When v1d2int(Fsel) = 31 Else
			  "00000000";

	-- Writes are synchronous with the clk.
	--
	DoIt: process (clk)
	begin
	if Prising(Clk) then
		if WriteEnable = '1' then
			-- Write Din into the selected register
		  case v1d2int(FSel) is
			 When 8  => R8  <= Din;
			 When 9  => R9  <= Din;
			 When 10 => R10 <= Din;
			 When 11 => R11 <= Din;
			 When 12 => R12 <= Din;
			 -- When 13 => R13 <= Din;
			 -- When 14 => R14 <= Din;
			 -- When 15 => R15 <= Din;
			 -- When 16 => R16 <= Din;
			 -- When 17 => R17 <= Din;
			 -- When 18 => R18 <= Din;
			 -- When 19 => R19 <= Din;
			 -- When 20 => R20 <= Din;
			 -- When 21 => R21 <= Din;
			 -- When 22 => R22 <= Din;
			 -- When 23 => R23 <= Din;
			 -- When 24 => R24 <= Din;
			 -- When 25 => R25 <= Din;
			 -- When 26 => R26 <= Din;
			 -- When 27 => R27 <= Din;
			 -- When 28 => R28 <= Din;
			 -- When 29 => R29 <= Din;
			 -- When 30 => R30 <= Din;
			 -- When 31 => R31 <= Din;
			 when OTHERS => NULL;
		  end case;
		end if;
	end if;
	end process DoIt;
end first;
