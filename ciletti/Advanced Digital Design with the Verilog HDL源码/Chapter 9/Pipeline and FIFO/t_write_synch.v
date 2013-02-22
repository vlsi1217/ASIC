module t_write_synchronizer ();
  wire		write_synch;
  reg		write_to_FIFO;
  reg		clock_100, clock_133, reset;
 
  initial #1500 $finish;
  initial fork 
    begin clock_133 = 0; forever #3 clock_133 = ~clock_133; end
   begin clock_100 = 0; forever #4 clock_100 = ~clock_100; end
   begin #5 reset = 1; #32 reset = 0; end
   begin #10 write_to_FIFO = 0; end
   #48 forever begin
    #0 write_to_FIFO = 1;
    //#4 write_to_FIFO = 1;
    #8 write_to_FIFO = 0;
    #248;
   end
   join
   

  write_synchronizer M0 (write_synch, write_to_FIFO, clock_133, reset);



endmodule


