module ROM_BCD_to_Excess_3 (ROM_data, ROM_addr);
output 	[3:0] ROM_data;
input 	[3:0] ROM_addr;
reg 	[3:0] ROM [15:0];
assign ROM_data = ROM[ROM_addr];
//				input state output next_state
initial begin
ROM[0] = 4'b1001;	// S_0	0 000 1 001 
ROM[1] = 4'b1111;	// S_1	0 001 1 111 
ROM[2] = 4'b1000;	// S_6	0 010 1 000 
ROM[3] = 4'b1110;	// S_4	0 011 1 110
ROM[4] = 4'bxxxx;	// not used
ROM[5] = 4'b0011;	// S_2	0 101 0 011 
ROM[6] = 4'b0000;	// S_5	0 110 0 000 
ROM[7] = 4'b0110;	// S_3	0 111 0 110 

ROM[8] = 4'b0101;	// S_0	1 000 0 101 
ROM[9] = 4'b0011;	// S_1	1 001 0 011 
ROM[10] = 4'b0000;	// S_6	1 010 0 000 
ROM[11] = 4'b0010;	// S_4	1 011 0 010 
ROM[12] = 4'bxxxx;	// not used
ROM[13] = 4'b1011;	// S_2	1 101 1 011 
ROM[14] = 4'b1000;	// S_5	1 110 1 000 
ROM[15] = 4'b1110;	// S_3	1 111 1 110 

end
endmodule

module BCD_to_Excess_3_ROM (ROM_addr, B_out, ROM_data, B_in, clk, reset);
  output	[3:0] 	ROM_addr;
  output		B_out;
  input	[3:0]	 ROM_data;
  input 		B_in, clk, reset;
  
  reg	[2:0]	state;
  wire 	[2:0] 	next_state;
  wire 		B_out;

  assign next_state = ROM_data [2:0];
  assign B_out = ROM_data[3];
  assign ROM_addr = {B_in, state};

always @ (posedge clk or negedge reset) 
    if (reset == 0) state <= 0; else state <= next_state;
endmodule

module test_BCD_to_Excess_3b_Converter ();
  wire	B_out, clk;
  wire 	[3:0] ROM_addr, ROM_data;
  reg	B_in, reset;


BCD_to_Excess_3_ROM M1 (ROM_addr, B_out, ROM_data, B_in, clk, reset);
ROM_BCD_to_Excess_3 M2 (ROM_data, ROM_addr);
clock_gen M3 (clk);

initial begin #1000 $finish; end

initial begin
#10 reset = 0;  #90 reset = 1;
end

initial begin
#0 B_in = 0;
#100 B_in = 0;
#100 B_in = 0;
#100 B_in = 1;
#100 B_in = 0;
end

endmodule

