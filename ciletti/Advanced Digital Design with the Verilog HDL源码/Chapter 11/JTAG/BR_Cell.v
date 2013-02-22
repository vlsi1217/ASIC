module  Bypass_Register(scan_out, scan_in, shiftDR, clockDR);
  output 	scan_out;
  input 		scan_in, shiftDR, clockDR;
  reg 		scan_out;

  always @ (posedge clockDR) scan_out <= scan_in & shiftDR;

endmodule 

