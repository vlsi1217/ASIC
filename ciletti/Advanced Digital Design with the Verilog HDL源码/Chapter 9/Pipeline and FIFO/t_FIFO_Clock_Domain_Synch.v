module t_FIFO_Clock_Domain_Synch (); 		// Test for clock domain 
  parameter stack_width = 32;			// synchronization
  parameter stack_height = 8;
  parameter stack_ptr_width = 3;
  defparam M1.stack_width = 32;	// Override any defaults
  defparam M1.stack_height = 8;
  defparam M1.stack_ptr_width = 3;

  wire 	[stack_width -1: 0] 	Data_out, Data_32_bit;
  wire 				stack_full, stack_almost_full, stack_half_full;
  wire				stack_almost_empty, stack_empty;
  wire 				write;
  reg 			  	Data_in;
  reg 				read_from_stack;
  reg 				En;
  reg 				clk_write, clk_read, rst;
  wire	[31: 0]			stack0, stack1, stack2, stack3;
  wire	[31: 0]			stack4, stack5, stack6, stack7;

  // Probes of the stack
  assign stack0 = M1.stack[0];	assign stack1 = M1.stack[1];
  assign stack2 = M1.stack[2]; 	assign stack3 = M1.stack[3];
  assign stack4 = M1.stack[4]; 	assign stack5 = M1.stack[5];
  assign stack6 = M1.stack[6]; 	assign stack7 = M1.stack[7];
  
// 2-stage pipeline to compensate for latency at synchronizer
  reg [stack_width-1: 0] Data_1, Data_2;
  always @ (negedge clk_read) 	 
    if (rst) begin Data_2 <= 0; Data_1 <= 0; end
    else begin  Data_1 <= Data_32_bit; Data_2 <= Data_1; end 

 Ser_Par_Conv_32 M00 (Data_32_bit, write, Data_in, En, clk_write, rst);
 write_synchronizer M0 (write_synch, write, clk_read, rst);
 FIFO_Buffer M1 (Data_out, stack_full, stack_almost_full, stack_half_full,
    stack_almost_empty, stack_empty, Data_2, write_synch, read_from_stack, 
    clk_read, rst);

  initial #10000 $finish;
  initial fork rst = 1; #8 rst = 0; join
  initial begin clk_write = 0; forever #4 clk_write = ~clk_write; end  // 100 MHz clock 
  initial begin clk_read = 0; forever #3 clk_read = ~clk_read; end   // 133 MHz clock 
  initial fork #1 En = 0; #48 En = 1; #2534 En = 0; #3944 En = 1;  join
  initial fork 
    #6 read_from_stack = 0; 
    #2700 read_from_stack = 1; #2706 read_from_stack = 0; 
    #3980 read_from_stack = 1; #3986 read_from_stack = 0; 
    #6000 read_from_stack = 1; #6006 read_from_stack = 0; 
    #7776 read_from_stack = 1; #7782 read_from_stack = 0;  // Overlaps write_synch
  join
  // Serial data transitions are synchronized to the falling edge of clk_write
  initial begin // Generate data and hold
    #1 Data_in = 0;
    @ (posedge En) Data_in = 1;	// wait for enable
    @ (posedge write);
    repeat (6) begin
      repeat (16) @ (negedge clk_write) Data_in = 0;
      repeat (16) @ (negedge clk_write) Data_in = 1;
      repeat (16) @ (negedge clk_write) Data_in = 1;  
      repeat (16) @ (negedge clk_write) Data_in = 0; 
    end
  end
endmodule
