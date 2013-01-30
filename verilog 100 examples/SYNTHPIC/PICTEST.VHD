--*** SYNTHETIC PIC V1.1 ***
--
-- VHDL
--
-- Entity:	PICTEST
--	Purpose: This is a simple VHDL behavioral wrapper for testing the Synthetic PIC.
--          All this entity does is instantiate the PICCPU and supply the clock
--          and reset signals.  This is where one might create a much more
--          elaborate VHDL Test Bench, perhaps, simulating the external circuit
--          around the core and even the external real-world signals.

entity PICTEST is end PICTEST;

architecture Behavioral of PICTEST is

component PICCPU
  port (
	 -- Oscillator input.  This will be divided by 4 inside
	 Clk   : in   vlbit;

	 -- Reset
	 MRST  : in vlbit;

	 -- Note the hard configuration
	 PortA : in  vlbit_1d(7 downto 0);
	 PortB : out vlbit_1d(7 downto 0);
	 PortC : out vlbit_1d(7 downto 0));
end component;

-- Interface to the PICCPU
signal TEST_Clk    : vlbit := '0';
signal TEST_MRST   : vlbit := '0';
signal TEST_PortA  : vlbit_1d (7 downto 0) := "00000000";  -- eg. an input!
signal TEST_PortB  : vlbit_1d (7 downto 0);
signal TEST_PortC  : vlbit_1d (7 downto 0);

begin
	-- Instantiate one PICCPU to be tested.
	PICCPU1  :  PICCPU port map (TEST_Clk, TEST_MRST, TEST_PortA, TEST_PortB, TEST_PortC);

	-- Drive ENABLE and DIRECTION Port input bits (this is for testing TEST6.ASM, but
	--    won't interfere with other testing)
	TEST_PortA  <= "00000011" after 5 us, "00000010" after 30 us, "00000011" after 60 us;

	TEST_Clk  <= NOT TEST_Clk after 55 ns;

	-- *** Note, the MRST is active Low.  Assert it for at least one full cycle ***
	TEST_MRST <= '1', '0' after 5 ns, '1' after 800 ns;
end Behavioral;

