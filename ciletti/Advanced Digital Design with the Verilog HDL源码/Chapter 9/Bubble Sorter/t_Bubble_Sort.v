module t_Bubble_Sort ();
  wire [3:0]  	A1, A2, A3, A4, A5, A6, A7, A8;
  reg		En, Ld, clk, rst;
 
  Bubble_Sort M0 (A1, A2, A3, A4, A5, A6, A7, A8,En, Ld, clk, rst);


  initial #1000 $finish;
  initial begin clk = 0; forever #5 clk = ~clk; end
  initial fork
        rst = 1;
   #20 rst = 0;
   #30 Ld = 1;
   #40 Ld = 0;
   #60 En = 1;
   #70 En = 0;
   #450 rst = 1;
   #470 rst = 0;

   #500 Ld = 1;
   #510 Ld = 0;
  join

  initial fork 
    #10 En = 1;
    #20 En = 0;
    #500 En = 1;
  join
endmodule