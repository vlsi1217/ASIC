 module Ser_Par_Conv_32 (Data_out, write, Data_in, En, clk, rst);
  output [31: 0] 	Data_out;
  output  	write;
  input 		Data_in;
  input		En, clk, rst;
  parameter	S_idle = 0;
  parameter	S_1 = 1;
 
  reg 		state, next_state;
  reg 	[4: 0] 	cnt;
  reg 		Data_out;
  reg 		shift, incr;

  always @ (posedge clk or posedge rst)
    if (rst) begin state <= S_idle; cnt <= 0; end
    else state <= next_state;

  always @ (state or En or write) begin
    shift = 0;
    incr = 0;
    next_state = state;
    case (state)
      S_idle:	if (En) begin next_state  = S_1; shift = 1; end
      S_1: 	if (!write) begin shift = 1; incr = 1; end 
		else if (En) begin shift = 1; incr = 1; end 
else begin next_state = S_idle; incr = 1; end 
    endcase
  end

  always @ (posedge clk or posedge rst)
    if (rst) begin cnt <= 0;  end
    else if (incr) cnt <= cnt +1;

    always @ (posedge clk or posedge rst)
      if (rst) Data_out <= 0;
      else if (shift) Data_out <= {Data_in, Data_out [31:1]};

  assign write = (cnt == 31);	 
endmodule

