/* source file: top_keypad_FIFO.v
   Top level module for the keypad FIFO.
   md ciletti 6-13-2002

*/

module TOP_Keypad_FIFO (Cathode, Col,  Left_anode, Right_anode, valid, empty, full, Row, read, clk, reset);
output	[6:0]	Cathode;
output	[3:0]	Col;
output 		Left_anode, Right_anode;
output		valid;
output		empty;
output		full;

input   [3:0]	Row;
input		read;
input		clk, reset;

wire	[3:0]	Code, Code_out;
wire 		S_Row;
wire		valid;
wire 	[6:0] 	Left_out, Right_out;
wire 		clk_slow, clk_display;
wire		read_fifo, read_synch;


Synchronizer M0 (
	.S_Row(S_Row), 
	.Row(Row), 
	.clock(clk_slow), 
	.reset(reset));

Hex_Keypad_Grayhill_072 M1(
	.Code(Code), 
	.Col(Col), 
	.Valid(valid), 
	.Row(Row), 
	.S_Row(S_Row), 
	.clock(clk_slow/**/), 
	.reset(reset));

FIFO M2 (
	.Data_out(Code_out),
	.stack_empty(empty), 
	.stack_full(full), 
	.Data_in(Code),
	.write_to_stack(valid), 
	.read_from_stack(read_fifo),
	.clk(~clk_slow), 
	.rst(reset) 
	);

Decoder_L M3 (
	.Left_out(Left_out), 
	.Right_out(Right_out), 
	.Code_in(Code_out));

Display_Mux_3_4  M5 (
	.Cathode(Cathode), 
	.Left_anode(Left_anode), 
	.Right_anode(Right_anode), 
	.Display_3(Left_out), 
	.Display_4(Right_out), 
	.sel(clk_display/**/));

Clock_Divider  #(1) M6 (			// DEFAULT WIDTH  = 24
	.clk_out(clk_slow), 		// Use 20 for slow/visible operation with hardware clock
	.clk_in(clk), 
	.reset(reset));

Clock_Divider  #(20) M7 (
	.clk_out(clk_display), 
	.clk_in(clk), 
	.reset(reset));
 
Toggle M8 (
	.toggle_out (read_fifo), 
	.toggle_in (read_synch),
	.clk(clk_slow), 
	.reset(reset));
	
Synchro_2 M9 (
	.synchro_out(read_synch),
	.synchro_in(read), 
	.clk(clk_slow), 
	.reset(reset));

endmodule

