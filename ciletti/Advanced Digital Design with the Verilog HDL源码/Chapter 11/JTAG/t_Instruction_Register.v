module t_Instruction_Register ();
parameter IR_size = 3;
wire 	[IR_size -1: 0]	data_out;
wire			scan_out;
reg	[IR_size -1: 0]	data_in;
reg			scan_in;
reg			shiftIR, clockIR, updateIR, reset_bar;

Instruction_Register M0 (data_out, data_in, scan_out, scan_in,  shiftIR, clockIR, updateIR, reset_bar);

initial #500 $finish;

 initial begin
data_in = 4'HA;
end

initial fork
#5 reset_bar = 0;
#10 reset_bar = 1;
join

initial begin scan_in = 1; end
initial fork
clockIR = 0;
shiftIR = 0;
#45 shiftIR = 1;		// Demonstrate scan in
#40begin repeat (IR_size) begin #10 clockIR = 1; #10 clockIR = 0; end #5 shiftIR = 0; end
join
initial begin

#100 repeat (1) begin #10 clockIR = 1; #10 clockIR = 0; end 
end


initial fork
updateIR = 0; 
#150 updateIR = 1;
#160 updateIR = 0;

#200 shiftIR = 0;
#200 clockIR = 1;		// Demonstrate parallel load
#210 clockIR = 0;
join

initial fork
#250 shiftIR = 1; 		// Demonstrate scan out
#260 begin repeat (IR_size) begin #10 clockIR = 1; #10 clockIR = 0; end end
join

endmodule
