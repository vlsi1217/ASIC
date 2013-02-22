module t_integrator_1 ();
  parameter word_length = 8;
  wire 	[word_length-1:0]		data_out;
  reg	[word_length-1:0]		data_in;
  reg 				hold;		// Active high
  reg				clock;		// Positive edge  
  reg				reset;		// Active high

 Integrator_Par M1 (data_out, data_in, hold, clock, reset);

  initial #500 $finish;
  initial begin reset = 1;  #10 reset = 0; #210 reset = 1; #10 reset = 0; end
  initial begin clock = 0;   forever #5 clock = ~clock; end

  initial fork
    #10 hold =1; 
    #30 hold = 0; 
    #60 hold = 1; 
    #150 hold = 0;


  join

initial fork
    #10 data_in = 8;
    #30 data_in = 47;
    #60 data_in = 8'hff;
    #90 data_in = 8'haa;
    #120 data_in = 8'h55;
    #150 data_in = 1;
   
join
endmodule

