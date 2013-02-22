module NRZI_Mealy (B_out, B_in, clk, rst);
output 		B_out;
input 		B_in, clk, rst;
reg	[2: 0]	state, next_state;
reg		B_out;
parameter 	S_0 = 0;
parameter	S_1 = 1;
parameter	S_2 = 2;
parameter	S_3 = 3;
parameter	S_4 = 4;

always @ (posedge clk or posedge rst)
if (rst) state <= S_0; else state <= next_state;

always @ (state or B_in) begin
//B_out = 0;
case (state) 
S_0:	if (B_in == 0) begin next_state = S_1; B_out = 0; end
	else begin next_state = S_3; B_out = 1; end

S_1:	begin B_out = 0; if (B_in == 0)next_state = S_2; else next_state = S_4; end

S_2:  begin B_out = 0; next_state = S_1; end
 
S_3:	begin B_out = 1; if (B_in == 0) next_state = S_4; else next_state = S_2; end

S_4:	begin B_out = 1; next_state = S_3; end

default:	next_state = S_0;
endcase
end
endmodule

module NRZI_Moore (B_out, B_in, clk, rst);
output 		B_out;
input 		B_in, clk, rst;
reg	[1: 0]	state, next_state;
reg		B_out;
parameter 	S_0 = 0;
parameter	S_1 = 1;
parameter	S_2 = 2;

always @ (posedge clk or posedge rst)
if (rst) state <= S_0; else state <= next_state;

always @ (state or B_in) begin
B_out = 0;
case (state) 
S_0:	begin B_out = 0; if(B_in == 0) next_state = S_1; 
	else next_state = S_1; end

S_1:	begin B_out = 0; if (B_in == 0) next_state = S_1; 
	else next_state = S_2; end

S_2:	begin B_out = 1; if (B_in == 0) next_state = S_2;
	else next_state = S_1; end
default:  next_state = S_0;
endcase
end
endmodule

module t_NRZI ();
wire 	B_out_Mealy, B_out_Moore;
reg	B_in, clk, clk_2, rst;
NRZI_Mealy M0 (B_out_Mealy, B_in, ~clk_2, rst);
NRZI_Moore M1 (B_out_Moore, B_in, clk, rst);

initial #200 $finish;
initial begin clk = 0; forever #4 clk = ~clk; end
initial begin clk_2 = 0; forever #2 clk_2 = ~clk_2; end
initial begin #1 rst = 1; #2 rst = 0; end
initial fork
#0  B_in =0;
#8 B_in = 1;
#32 B_in = 0;
#48 B_in = 1;
#56 B_in = 0;
join
endmodule

