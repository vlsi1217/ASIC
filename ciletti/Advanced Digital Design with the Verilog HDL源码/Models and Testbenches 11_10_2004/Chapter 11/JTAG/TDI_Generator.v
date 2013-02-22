module TDI_Generator (to_TDI, scan_pattern,  load, enable_bypass_pattern, TCK);
  parameter 			BSC_Reg_size = 14;
  output				to_TDI;
  input 	[BSC_Reg_size -1: 0]	scan_pattern;
  input				load, enable_bypass_pattern, TCK;
  reg	[BSC_Reg_size -1: 0]	TDI_Reg;
  wire				enableTDO = t_ASIC_with_TAP.M0.enableTDO;
  assign to_TDI = TDI_Reg [0];

  always @ (posedge TCK) if (load) TDI_Reg <= scan_pattern;
    else if (enableTDO || enable_bypass_pattern) 
      TDI_Reg <= TDI_Reg >> 1;

endmodule
