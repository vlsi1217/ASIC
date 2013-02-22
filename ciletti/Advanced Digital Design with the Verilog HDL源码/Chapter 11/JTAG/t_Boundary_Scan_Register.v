module t_Boundary_Scan_Register ();
parameter size = 8;
defparam		M0.size = 8;
wire 	[size -1: 0] 	data_out;
reg	[size -1: 0] 	data_in;
wire 			scan_out;
reg			scan_in;
reg			shiftDR, mode;
reg			clockDR, updateDR;
reg			system_clk;

Boundary_Scan_Register M0 (data_out, data_in, scan_out, scan_in,  shiftDR, mode, clockDR, updateDR);

initial #520 $finish;
 initial begin
data_in = 8'HAA;
scan_in = 0;
#50 scan_in = 1;
end

initial fork
mode = 0;
#350 mode = 1;
#400 mode = 0;
shiftDR = 0;
clockDR = 0;
updateDR = 0;
#50 clockDR = 1;
#60 clockDR = 0;
#90 updateDR = 1;
#100 updateDR = 0;
join

initial fork
#120 shiftDR = 1;
#130 begin repeat (8) begin #10 clockDR = 1; #10 clockDR = 0; end #5 shiftDR = 0; end
join

initial fork
updateDR = 0; 
#330 updateDR = 1;
#340 updateDR = 0;
 #440 clockDR = 1;
#450 clockDR = 0;

join

 
endmodule

