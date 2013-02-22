module Boundary_Scan_Register (data_out, data_in, scan_out, scan_in,  shiftDR, mode, clockDR, updateDR);
parameter size = 14;
output 	[size -1: 0]	data_out;
output			scan_out;
input	[size -1: 0]	data_in;
input			scan_in;
input			shiftDR, mode, clockDR, updateDR;
reg	[size -1: 0]	BSC_Scan_Register, BSC_Output_Register;

always @ (posedge clockDR) BSC_Scan_Register <= shiftDR ? {scan_in, BSC_Scan_Register [ size -1: 1]} : data_in;
always @ (posedge updateDR) BSC_Output_Register <= BSC_Scan_Register;

assign scan_out = BSC_Scan_Register [0];
assign data_out = mode ? BSC_Output_Register : data_in;

endmodule

/*
module t_Boundary_Scan_Register ();
parameter size = 14;
wire 	[size -1: 0] 	data_out;
reg	[size -1: 0] 	data_in;
wire 			scan_out;
reg			scan_in;
reg			shiftDR, mode;
reg			clockDR, updateDR;
reg			system_clk;

Boundary_Scan_Register M0 (data_out, data_in, scan_out, scan_in,  shiftDR, mode, clockDR, updateDR);

initial #500 $finish;
initial begin system_clk = 0; forever #5 system_clk = ~system_clk; end

 initial begin
data_in = 0;
forever @ (negedge system_clk) data_in = data_in +1;
end

initial fork
mode = 0;
#375 mode = 1;
//#450 mode = 0;
join

initial fork
clockDR = 0;
shiftDR = 0;
#45 shiftDR = 1;
#40begin repeat (size) begin #10 clockDR = 1; #10 clockDR = 0; end #5 shiftDR = 0; end
join
initial begin
 #380 repeat (1) begin #10 clockDR = 1; #10 clockDR = 0; end 
end


initial fork
updateDR = 0; 
#350 updateDR = 1;
#360 updateDR = 0;
join



initial begin scan_in = 1; end
endmodule
*/
