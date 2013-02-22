module Instruction_Register (data_out, data_in, scan_out, scan_in,  shiftIR, clockIR, updateIR, reset_bar);
parameter IR_size = 3;
output 	[IR_size -1: 0]	data_out;
output			scan_out;
input	[IR_size -1: 0]	data_in;
input			scan_in;
input			shiftIR, clockIR, updateIR, reset_bar;
reg	[IR_size -1: 0]	IR_Scan_Register, IR_Output_Register;

assign			data_out = IR_Output_Register;
assign			scan_out = IR_Scan_Register [0];

always @ (posedge clockIR) IR_Scan_Register <= shiftIR ? {scan_in, IR_Scan_Register [IR_size - 1: 1]} : data_in;
 
always @ ( posedge updateIR or negedge reset_bar)	// asynchronous required by 1140.1a.
  if (reset_bar == 0) IR_Output_Register <= ~(0);		// Fills IR with 1s for BYPASS instruction 
  else IR_Output_Register <= IR_Scan_Register;

endmodule

