module Seq_Rec_3_1s_Mealy_Shft_Reg (D_out, D_in, En, clk, reset);  	   
  output 		D_out;					 
  input 		D_in, En;
  input 		clk, reset;
  parameter		Empty = 2'b00;
  reg		[1:0] 	Data;
   					 
  always @ (negedge clk) 
    if (reset == 1) Data <= Empty; else if (En  == 1) Data <= {D_in, Data[1]}; 

  assign D_out = ((Data == 2'b11) && (D_in == 1 ));	// Mealy output
endmodule

module Seq_Rec_3_1s_Moore_Shft_Reg (D_out, D_in, En, clk, reset);  	   
  output 		D_out;	
  input 		D_in, En;
  input 		clk, reset;
  parameter		Empty = 2'b00;
  reg		[2:0] 	Data;
   					 
  always @ (negedge clk) 
    if (reset == 1) Data <= Empty; else if (En == 1) Data <= {D_in, Data[2:1]}; 

  assign D_out = (Data == 3'b111);     // Moore output
endmodule

 
module t_Seq_Rec_3_1s ();
  reg D_in, En, clk, reset;  
	   
  wire D_out_Mealy;
  wire D_out_Moore;
 
  Seq_Rec_3_1s_Mealy_Shft_Reg M0 (D_out_Mealy, D_in, En, clk, reset);  	   
   Seq_Rec_3_1s_Moore_Shft_Reg M1 (D_out_Moore, D_in, En, clk, reset);  	   

  initial #275 $finish;

  initial begin #5 reset = 1; #1 reset = 0; end
  initial begin
    clk = 0; forever #10 clk = ~clk;  
  end
  initial begin
    #5 En = 1;
   //#50 En = 0;
  end
 /*
  initial fork 
    begin #10 D_in = 0;    #25 D_in = 1;    #80 D_in = 0; end
    begin #135 D_in = 1; #40 D_in = 0; end
    begin #195 D_in = 1'bx; #60 D_in = 0; end
   join
*/
  initial fork
    #10 D_in = 0;    
    #35 D_in = 1;    #45 D_in = 0; 
    #55 D_in = 1;    #65 D_in = 0;
    #75 D_in = 1;    #85 D_in = 0; 
    #95 D_in = 1;    #105 D_in = 0; 
    #135 D_in = 1; #145 D_in = 0; #155 D_in = 1; #165 D_in = 0; 
    #195 D_in = 1'bx; #250 D_in = 0; 
  join
endmodule
 
