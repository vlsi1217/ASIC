// M.D. Ciletti 4-4-2001
// Note: Adjust stack parameters
// Note:  Model does not support simultaneous read and write, and would need
// additional logic.
// As written, ptr-diff would have two non-block assignments made to it in 
// the same clock cycle, with non-deterministic outcome.

module FIFO (			
  Data_out, 			// Data path from FIFO
  stack_empty, 			// Flag asserted high for empty stack
  stack_full, 			// Flag asserted high for full stack
  Data_in, 			// Data path into FIFO
  write_to_stack, 			// Flag controlling a write to the stack
  read_from_stack,		// Flag controlling a read from the stack
  clk, rst				// External clock and reset
 );
  parameter stack_width = 4;	 //12; 	// Width of stack and data paths
  parameter stack_height = 8; 			// Height of stack (in # of words)
  parameter stack_ptr_width = 3;    		// Width of pointer to address stack    

  output 	[stack_width -1 : 0] 	Data_out;
  output 				stack_empty, stack_full;
  input 	[stack_width -1 : 0] 	Data_in;
  input 				clk, rst;
  input 				write_to_stack, read_from_stack;

  reg 	[stack_ptr_width -1 : 0]  	read_ptr, write_ptr;  // Pointers (addresses) for
							      // reading and writing
  reg 	[stack_ptr_width : 0]  	ptr_diff;		      // Gap between ptrs

  reg 	[stack_width -1 : 0] 	Data_out;
  reg 	[stack_width -1 : 0] 	stack [stack_height -1 : 0]; // memory array
 
  assign stack_empty = (ptr_diff == 0) ? 1'b1 : 1'b0;
  assign stack_full = (ptr_diff == stack_height) ? 1'b1: 1'b0;

// check this for the need of a reset in synthesis

  always @ (posedge clk or posedge rst) begin: data_transfer
    if (rst) begin
      Data_out <= 0;
      read_ptr <= 0;
      write_ptr <= 0;
      ptr_diff <= 0;
    end
    else begin
      if ((read_from_stack) && (!stack_empty)) begin
        Data_out <= stack [read_ptr];
        read_ptr <= read_ptr + 1;
        ptr_diff <= ptr_diff -1;
      end
    else if ((write_to_stack) && (!stack_full)) begin
      stack [write_ptr] <= Data_in;
      write_ptr <= write_ptr + 1;		// Address for next clock edge
      ptr_diff <= ptr_diff + 1;
    end
    end
  end 	// data_transfer
endmodule
 /*
module t_FIFO (); 
  parameter stack_width = 4; //12;
  parameter stack_height = 16;
  parameter stack_ptr_width = 4;

  wire [stack_width -1 : 0] Data_out;
  wire stack_empty, stack_full;
  reg [stack_width -1 : 0] Data_in;
  reg clk, rst, write_to_stack, read_from_stack;
  wire 	[stack_width -1:0] 	stack0, stack1, stack2, stack3, stack4, stack5, stack6, stack7;

  assign stack0 = M1.stack[0];		// Probes of the stack
  assign stack1 = M1.stack[1];
  assign stack2 = M1.stack[2];
  assign stack3 = M1.stack[3];
  assign stack4 = M1.stack[4];
  assign stack5 = M1.stack[5];
  assign stack6 = M1.stack[6];
  assign stack7 = M1.stack[7];

  FIFO M1 (Data_out, stack_empty, stack_full, Data_in, write_to_stack, read_from_stack, clk, rst);

  always begin
    clk = 0;  #10 clk = 1; #10;
  end

  initial #1000 $stop;

  initial  begin
    #5 rst = 1; #40 rst = 0;#600 rst = 1; #40 rst = 0;
  end
  initial begin
    #5 Data_in = 12'hF;
    #80 Data_in = 12'he;
  end
  initial begin
    #75 write_to_stack = 1;  read_from_stack = 0;
    #310 write_to_stack = 0; #60 read_from_stack = 1; 
    #400 read_from_stack = 0; write_to_stack = 1;
    #100 write_to_stack = 0; read_from_stack = 1;
    #50 read_from_stack = 0;
  end
endmodule
//*/
