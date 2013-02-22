module FIFO_Buffer (	
  Data_out, 			// Data path from FIFO
  stack_full,			// Status flags
  stack_almost_full,	
  stack_half_full,
  stack_almost_empty,
  stack_empty, 		 
  Data_in, 			// Data path into FIFO
  write_to_stack, 			// Flag controlling a write to the stack
  read_from_stack,		// Flag controlling a read from the stack
  clk, rst 		 
  );
  parameter stack_width = 32; 	// Width of stack and data paths
  parameter stack_height = 8; 	// Height of stack (in # of words)
  parameter stack_ptr_width = 3;   	// Width of pointer to address stack    
  parameter  AE_level = 2;		// almost empty level
  parameter  AF_level = 6;		// Almost full level
  parameter  HF_level = 4;		// Half full level
  output 	[stack_width -1: 0] 	Data_out;

  output 				stack_full, stack_almost_full, stack_half_full;
  output				stack_almost_empty, stack_empty;
  input 	[stack_width -1: 0] 	Data_in;
  input 				write_to_stack, read_from_stack;
  input 				clk, rst;

  reg 	[ stack_ptr_width -1: 0]  	read_ptr, write_ptr;  // Addresses for 
						   // reading and writing
  reg 	[ stack_ptr_width: 0]  	ptr_gap;	  	   // Gap between ptrs
  reg 	[stack_width -1: 0] 	Data_out;
  reg 	[stack_width -1: 0] 	stack [stack_height -1 : 0]; // memory array
 
// Stack status signals
  assign stack_full = (ptr_gap == stack_height);
  assign stack_almost_full = (ptr_gap == AF_level);
  assign stack_half_full = (ptr_gap == HF_level);
  assign stack_almost_empty = (ptr_gap == AE_level);
  assign stack_empty = (ptr_gap == 0); 

  always @ (posedge clk or posedge rst)  
    if (rst) begin
      Data_out <= 0;
      read_ptr <= 0;
      write_ptr <= 0;
      ptr_gap <= 0; 
    end
    else if (write_to_stack && (!stack_full) && (!read_from_stack)) begin
      stack [write_ptr] <= Data_in;
      write_ptr <= write_ptr + 1;	 
      ptr_gap <= ptr_gap + 1;  
    end
    else if ((!write_to_stack) && (!stack_empty) && read_from_stack) begin
      Data_out <= stack [read_ptr];
      read_ptr <= read_ptr + 1;
      ptr_gap <= ptr_gap - 1;
    end
    else if (write_to_stack && read_from_stack && stack_empty) begin
      stack [write_ptr] <= Data_in;
      write_ptr <= write_ptr + 1;
      ptr_gap <= ptr_gap + 1;
    end
    else if (write_to_stack && read_from_stack && stack_full) begin
      Data_out <= stack [read_ptr];
      read_ptr <= read_ptr + 1;
      ptr_gap <= ptr_gap - 1;
    end
    else if (write_to_stack && read_from_stack 
      && (!stack_full) && (!stack_empty)) begin
      Data_out <= stack [read_ptr];
      stack [write_ptr] <= Data_in;
      read_ptr <= read_ptr + 1;
      write_ptr <= write_ptr + 1;
    end
endmodule


