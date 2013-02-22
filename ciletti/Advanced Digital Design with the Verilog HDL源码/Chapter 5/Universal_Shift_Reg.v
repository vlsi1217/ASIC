module Universal_Shift_Reg   (Data_Out, MSB_Out, LSB_Out, Data_In, 
   MSB_In, LSB_In, s1, s0, clk, rst);
  output	[3: 0] 	Data_Out;
  output 			MSB_Out, LSB_Out;
  input 	[3: 0] 	Data_In;
  input 			MSB_In, LSB_In;
  input 			s1, s0, clk, rst;
  reg 	[3: 0]	Data_Out;	// 5-10-2004

  assign MSB_Out = Data_Out[3];
  assign LSB_Out = Data_Out[0];

  always @ (posedge clk) begin
    if (rst) Data_Out <= 0; 
    else  case ({s1, s0})
      0:	Data_Out <= Data_Out;				// Hold
      1:	Data_Out <= {MSB_In, Data_Out[3:1]};	// Serial shift from MSB
      2:	Data_Out <= {Data_Out[2: 0], LSB_In};  	// Serial shift from LSB
      3:	Data_Out <= Data_In;  				// Parallel Load
    endcase
  end
endmodule

