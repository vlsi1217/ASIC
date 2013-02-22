module Seq_Rec_3_1s_Mealy (D_out, D_in, En, clk, reset);  	   
  output 		D_out;					 
  input 		D_in, En;
  input 		clk, reset;

  parameter 	S_idle =	0;			// Binary code
  parameter 	S_0 = 	1;
  parameter 	S_1 = 	2;
  parameter 	S_2 = 	3;
  reg		[1: 0] 	state, next_state;
   					 
  always @ (negedge clk) 
    if (reset == 1) state <= S_idle; else state <= next_state;

  always @ (state or D_in) begin
    case (state) 					// Partially decoded

      S_idle:	if ((En == 1) && (D_in == 1))	next_state = S_1; else 
                    	if ((En  == 1) && (D_in == 0)) 	next_state = S_0;	
		else 				next_state = S_idle;

      S_0:		if (D_in == 0) 			next_state = S_0; else 
		if (D_in == 1) 			next_state = S_1; 
		else 				next_state = S_idle;

      S_1:		if (D_in == 0) 			next_state = S_0; else 
		if (D_in == 1) 			next_state = S_2; 	
		else 				next_state = S_idle;

      S_2:		if (D_in == 0) 			next_state = S_0; else  
		if (D_in == 1) 			next_state = S_2;	
		else 				next_state = S_idle;

      default:   					next_state = S_idle;  
    endcase
  end

  assign D_out = ((state == S_2) && (D_in == 1 ));	// Mealy output
endmodule


module t_Seq_Rec_3_1s ();
  reg D_in_NRZ, D_in_RZ, En, clk, reset;  
	   
  wire Mealy_NRZ;
  wire Mealy_RZ;
 

  Seq_Rec_3_1s_Mealy M0 (Mealy_NRZ, D_in_NRZ, En, clk, reset);  	   
  Seq_Rec_3_1s_Mealy M1 (Mealy_RZ, D_in_RZ, En, clk, reset);  	   
 

  initial #275 $finish;

  initial begin #5 reset = 1; #1 reset = 0; end
  initial begin
    clk = 0; forever #10 clk = ~clk;  
  end
  initial begin
    #5 En = 1;
   #50 En = 0;
  end

  initial fork 
    begin #10 D_in_NRZ = 0;    #25 D_in_NRZ = 1;    #80 D_in_NRZ = 0; end
    begin #135 D_in_NRZ = 1; #40 D_in_NRZ = 0; end
    begin #195 D_in_NRZ = 1'bx; #60 D_in_NRZ = 0; end
   join

  initial fork
    #10 D_in_RZ = 0;    
    #35 D_in_RZ = 1;    #45 D_in_RZ = 0; 
    #55 D_in_RZ = 1;    #65 D_in_RZ = 0;
    #75 D_in_RZ = 1;    #85 D_in_RZ = 0; 
    #95 D_in_RZ = 1;    #105 D_in_RZ = 0; 
    #135 D_in_RZ = 1; #145 D_in_RZ = 0; #155 D_in_RZ = 1; #165 D_in_RZ = 0; 
    #195 D_in_RZ = 1'bx; #250 D_in_RZ = 0; 
  join
endmodule

