--!!! NOTE:
--    The HEX2VHDL utility takes the .HEX file and makes a .VHD file.
--    You must manually copy this .VHD file into the PICROM.VHD file
--    and then recompile/resynthesize the PICROM entity.  The HEX2VHDL
--    program always writes "entity PICROM is" into the VHD file
--    although, the file itself, will be the name of the original
--    ASM file except with VHD extension.
--
--
-- VHDL
--
-- Entity:	PICROM

-- VIEWLOGIC libraries suitable for both simulation and for synthesis.
--
library synth;
use synth.stdsynth.ALL;

entity PICROM is
  port (
	 Addr    : in   vlbit_1d(10 downto 0);
	 Data    : out  vlbit_1d(11 downto 0));
end PICROM;


architecture first of PICROM is
begin
	Data <= 
			  "000001101010" When v1d2int(Addr) = 00000 Else
			  "110000101011" When v1d2int(Addr) = 00001 Else
			  "000111101010" When v1d2int(Addr) = 00002 Else
			  "000111101010" When v1d2int(Addr) = 00003 Else
			  "000111101010" When v1d2int(Addr) = 00004 Else
			  "000111101010" When v1d2int(Addr) = 00005 Else
			  "000111101010" When v1d2int(Addr) = 00006 Else
			  "000111101010" When v1d2int(Addr) = 00007 Else
			  "000111101010" When v1d2int(Addr) = 00008 Else
			  "010100000011" When v1d2int(Addr) = 00009 Else
			  "000001101010" When v1d2int(Addr) = 00010 Else
			  "000011101010" When v1d2int(Addr) = 00011 Else
			  "110000101011" When v1d2int(Addr) = 00012 Else
			  "000010101010" When v1d2int(Addr) = 00013 Else
			  "000010101010" When v1d2int(Addr) = 00014 Else
			  "000010101010" When v1d2int(Addr) = 00015 Else
			  "000010101010" When v1d2int(Addr) = 00016 Else
			  "000010101010" When v1d2int(Addr) = 00017 Else
			  "000010101010" When v1d2int(Addr) = 00018 Else
			  "000010101010" When v1d2int(Addr) = 00019 Else
			  "101000010100" When v1d2int(Addr) = 00020 Else
			  "101000000000" When v1d2int(Addr) = 00511 Else
			  "000000000000";
end first;