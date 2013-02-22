module BSC_Cell 
  (data_out, scan_out, data_in, mode, scan_in, shiftDR, updateDR, clockDR);
output 	data_out;
output		scan_out;
input		data_in;
input		mode, scan_in, shiftDR, updateDR, clockDR;
reg		scan_out, update_reg;

always @ (posedge clockDR) begin
scan_out <= shiftDR ? scan_in : data_in;
end

always @ (posedge updateDR) update_reg <= scan_out;
assign data_out = mode ? update_reg : data_in;

endmodule


