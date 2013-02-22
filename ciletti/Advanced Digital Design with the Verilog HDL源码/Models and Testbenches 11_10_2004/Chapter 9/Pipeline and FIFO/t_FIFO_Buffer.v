module t_FIFO_Buffer (); 	// Used to test only the FIFO, without synchronization
  parameter 			stack_width = 32;
  parameter 			stack_height = 8;
  parameter 			stack_ptr_width = 4;

  wire 	[stack_width -1: 0] 	Data_out;
  wire				write;
  wire 				stack_full, stack_almost_full, stack_half_full;
  wire				stack_almost_empty, stack_empty;
  reg 	[stack_width -1: 0] 	Data_in;
  reg 				write_to_stack, read_from_stack;
  reg 				clk, rst;
  wire	[stack_width -1: 0]	stack0, stack1, stack2, stack3, stack4, 
         				stack5, stack6, stack7;
 
  assign stack0 = M1.stack[0];	// Probes of the stack
  assign stack1 = M1.stack[1];
  assign stack2 = M1.stack[2];
  assign stack3 = M1.stack[3];
  assign stack4 = M1.stack[4];
  assign stack5 = M1.stack[5];
  assign stack6 = M1.stack[6];
  assign stack7 = M1.stack[7];

 FIFO_Buffer M1 (Data_out, stack_full, stack_almost_full, stack_half_full,
    stack_almost_empty, stack_empty, Data_in, write_to_stack, read_from_stack, 
    clk, rst);

  initial #300 $finish;
  initial begin rst = 1; #2 rst = 0; end
  initial begin clk = 0; forever #4 clk = ~clk; end	 

  // Data transitions
   initial begin Data_in = 32'hFFFF_AAAA;
     @ (posedge write_to_stack);
       repeat (24) @ (negedge clk) Data_in = ~Data_in;
   end

  // Write to FIFO
   initial fork 
    begin #8 write_to_stack = 0; end
    begin #16 write_to_stack  = 1; #140 write_to_stack = 0; end
    begin #224 write_to_stack  = 1; end
  join

  // Read from FIFO
  initial fork 
    begin #8 read_from_stack = 0; end
    begin #64 read_from_stack = 1; #40 read_from_stack = 0; end
    begin #144  read_from_stack = 1; #8 read_from_stack = 0; end
    begin #176  read_from_stack = 1; #56 read_from_stack = 0; end
  join
endmodule

