module IR_Cell (data_out, scan_out, data_in, scan_in, shiftIR, reset_bar, nTRST, clockIR, updateIR);

  output 		data_out, scan_out;
  input		data_in, scan_in, shiftIR, reset_bar, nTRST, clockIR, updateIR;
  reg 		data_out, scan_out;
  parameter	SR_value = 0;
  wire 		S_R = reset_bar & nTRST;
  
  always @ (posedge clockIR) scan_out  <= shiftIR ? scan_in: data_in;
  always @ (posedge updateIR or negedge S_R)
    if (S_R == 0) data_out <= SR_value;
    else data_out <= scan_out;

endmodule

