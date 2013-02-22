module pipe_2stage (R0, Data, En, Ld, clock, rst);
  output	[15: 0]	R0;
  input	[7: 0]		Data;
  input 			En, Ld, clock, rst;

  reg		[1:0]		state, next_state;
  parameter		S_idle = 0;
  parameter		S_1 = 1;
  parameter		S_full = 2;
  parameter		S_wait = 3;
  reg				Ld_R0, flush_P0_P1, Ld_P0_P1;
  reg		[7: 0]		P0, P1;
  reg				R0;
   
  always @ (posedge clock)
    if (rst) state <= S_idle; else state <= next_state;

  always @ (state or Ld or En) begin
    Ld_R0 = 0; flush_P0_P1 = 0; Ld_P0_P1 = 0;
    
    case (state)
      S_idle:	if (rst) begin next_state = S_idle; flush_P0_P1 = 1; end
			else if (En) begin next_state = S_1; Ld_P0_P1 = 1; end
			else flush_P0_P1 = 1; 
      S_1:		begin next_state = S_full; Ld_P0_P1 = 1; end
      
      S_full:		if (Ld) begin 	next_state = S_idle; 
						Ld_R0 = 1; 
						flush_P0_P1 = 1; end
			else 			next_state = S_wait;

      S_wait:	if (Ld) begin 	next_state = S_idle; 
						Ld_R0 = 1; 
						flush_P0_P1 = 1; end
			
      default:	next_state = 2'bx;
    endcase
  end


  always @ (posedge clock) begin
    if (flush_P0_P1) 		begin P1 <= 0; P0 <= 0; end
    if (Ld_R0)			begin R0 <= {P1, P0}; end
    if (Ld_P0_P1)		begin P1 <= Data; P0 <= P1; end
  end
endmodule

module t_pipe_2stage ();
  wire	[ 15: 0]	R0;
  reg		[7: 0]		Data;
  reg 			En, Ld, clock, rst;


  pipe_2stage M0 (R0, Data, En, Ld, clock, rst);

  initial #500 $finish;
  initial begin clock = 0; forever #5 clock = ~clock; end
  initial begin Data = 8'H55; forever @ (negedge clock) Data = Data + 1; end
  initial fork
    #10 rst = 0;
    #20 rst = 1;
    #40 rst = 0;
    #300 rst = 1;
    #350 rst = 0;

    #20 En = 0;
    #70 En = 1;
    #80 En = 0;
    #200 En = 1;

    #20 Ld = 0;
    #140 Ld = 1;
    #150 Ld = 0;
    #400 Ld = 1;
 
join
endmodule

