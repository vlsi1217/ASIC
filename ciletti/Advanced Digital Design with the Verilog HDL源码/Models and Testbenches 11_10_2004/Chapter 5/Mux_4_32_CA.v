module Mux_4_32_CA (mux_out, data_3, data_2, data_1, data_0, select, enable);
	  output 		[31: 0] 	mux_out;
 	  input 		[31: 0] 	data_3, data_2, data_1, data_0;
	  input 		[1:0] 	select;
	  input 			enable;
	  wire 		[31: 0] 	mux_int;

	  assign mux_out = enable ? mux_int : 32'bz;
	  assign mux_int = (select == 0)  ? data_0 : 
(select == 1) ? data_1:	(select == 2) ? data_2:
		(select == 3) ? data_3: 32'bx;
	endmodule

