module TDO_Monitor (to_TDI, from_TDO, strobe, TCK);
  parameter 			BSC_Reg_size = 14;
  output				to_TDI;
  input				from_TDO, strobe, TCK;
  reg	[BSC_Reg_size -1: 0]	TDI_Reg, Pattern_Buffer_1, Pattern_Buffer_2, 
				Captured_Pattern, TDO_Reg;
  reg 				Error;
  parameter			test_width = 5;
  wire enableTDO = t_ASIC_with_TAP.M0.enableTDO;
  wire	[test_width -1: 0]		Expected_out = 
Pattern_Buffer_2 [BSC_Reg_size -1: BSC_Reg_size - test_width];

  wire	[test_width -1: 0]		ASIC_out = 
TDO_Reg [BSC_Reg_size - 1: BSC_Reg_size - test_width];

  initial 				Error = 0;

always @ (negedge enableTDO) if (strobe == 1) Error = |(Expected_out ^ ASIC_out);

  always @ (posedge TCK) if (enableTDO) begin
      Pattern_Buffer_1 <= {to_TDI, Pattern_Buffer_1 [BSC_Reg_size -1: 1]};
      Pattern_Buffer_2 <= {Pattern_Buffer_1 [0], Pattern_Buffer_2 [BSC_Reg_size -1: 1]};
      TDO_Reg <= {from_TDO, TDO_Reg [BSC_Reg_size -1: 1]};
  end  
endmodule
