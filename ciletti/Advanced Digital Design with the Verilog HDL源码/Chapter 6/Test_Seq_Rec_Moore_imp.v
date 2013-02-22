module test_seq_detectors ();
  reg 	D_in, clock, reset;			 
  wire 	D_out;		 			
  wire	flag;


  Seq_Rec_Moore_imp M0 (D_out, D_in, clock, reset);

  initial begin clock = 0; forever #50 clock = ~clock; end
  initial #2000 $finish;

initial fork
    #0 reset = 0; 
    #15 reset = 1;
    #90 reset = 0;
    #1000 reset =1; 
    #1200 reset = 0; 
    #1500 reset = 1;
join 


/*initial begin
    #25 reset = 1;
    #200 reset = 0;#500 reset = 1; #100 reset = 0;
    #400 reset = 1; #150 reset = 0;

  end
  initial begin
  #0 D_in = 0;
  #300 D_in = 1;
  #300 D_in = 0;//#500 D_in = 0; 
  #300 D_in = 1; //#100 D_in = 1; 
  #100 D_in = 0;
  #200 D_in = 1;
  end
*/
 

initial fork
  #0 D_in = 0;
  #300 D_in = 1;
  #600 D_in = 0;
  #900 D_in = 1;
  #1000 D_in = 0;
  #1400 D_in = 1;
join 

endmodule

