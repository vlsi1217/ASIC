module Clock_Prog (clock);
  output clock;
  reg clock;
  parameter Latency = 100;
  parameter Pulse_Width = 50;
  parameter Offset = 50;
 
  initial begin
    #0 clock = 0;
    #Latency forever begin #Offset clock = ~clock; #Pulse_Width clock = ~clock;end

   end
endmodule
/*
module t_Clock_Prog ();
  wire clock;
initial #500 $finish;
Clock_Prog M1 (clk);
endmodule

*/
