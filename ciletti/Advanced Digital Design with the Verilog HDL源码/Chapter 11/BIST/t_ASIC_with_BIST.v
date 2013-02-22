module t_ASIC_with_BIST ();
  parameter			size = 4;
  parameter			End_of_Test = 11000;
  wire		[size -1: 0] 	sum;		//  ASIC interface I/O
  wire				c_out;
  reg		[size -1: 0]	a, b;
  reg				c_in;
  
  wire				done, error; 		 
  reg				test_mode, clock, reset;	
  reg				Error_flag = 1;

  initial begin Error_flag = 0; forever @ (negedge clock) if ( M0.error) Error_flag = 1; end

  ASIC_with_BIST M0 (sum, c_out, a, b, c_in, done, error, test_mode, clock, reset);

  initial #End_of_Test $finish;
  initial begin clock = 0; forever #5 clock = ~clock; end

  // Declare external inputs
  initial fork
    a = 4'h5;
    b = 4'hA;
    c_in = 0;
    #500 c_in = 1;
  join

// Test power-up reset and launch of test mode
  initial fork
    #2 reset = 0; 
    #10 reset = 1;    

    #30 test_mode = 0;
    #60 test_mode = 1;
  join

// Test action of reset on-the-fly

  initial fork
    #150 reset = 0;
    #160 test_mode = 0;
  join
    
// Generate signature of fault-free circuit

  initial fork
    #180 test_mode = 1;
    #200 reset = 1;
  join

// Test for an injected fault

initial fork				
    #5350 release M0.mux_b [2] ; 
    #5360 force M0.mux_b[0] = 0; 
    #5360 begin reset = 0;  test_mode = 1; end
    #5370 reset = 1;
  join

endmodule
