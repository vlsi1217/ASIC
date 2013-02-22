`timescale  1ns / 10ps

module SRAM_with_Con (data, addr, Rdy, ADS, R_W, clk, reset);
  parameter	word_size = 8;
  parameter	addr_size = 11;

  inout 	[word_size-1: 0] data;
  input 	[addr_size-1: 0] addr;
  output 	Rdy;
  input 	ADS, R_W;
  input 	clk, reset;

  SRAM_Con M0 (Rdy, CS_b, OE_b, WE_b, ADS, R_W, clk, reset);  
  SRAM M1 (data, addr, CS_b, OE_b, WE_b);
endmodule

module SRAM_Con (Rdy, CS_b, OE_b, WE_b, ADS, R_W, clk, reset);
  output Rdy;
  output CS_b;
  output OE_b;
  output WE_b;
  input ADS;
  input R_W;
  input clk, reset;
  reg [2:0] state, next_state;
  reg CS_b, OE_b, WE_b;
  reg Rdy;

  parameter S_idle = 0;
  parameter S_Rd1 = 1;
  parameter S_Rd2 = 2;
  parameter S_Wr1 = 3;
  parameter S_Wr2 = 4;
  parameter S_Wr3 = 5;

  always @   (posedge clk)
    if (reset == 1) state <= S_idle;
    else state <= next_state;

  always @   (state or ADS or R_W) begin
    OE_b = 1;
    CS_b = 1;
    WE_b = 1;
    Rdy = 0;
    next_state = state;
    case (state)
      S_idle:	if ((ADS == 1) && (R_W == 1))   next_state = S_Rd1; 
                  	else if ((ADS == 1) && (R_W == 0)) next_state = S_Wr1;  
			
      S_Rd1:	next_state = S_Rd2;
      S_Rd2:	begin Rdy = 1; CS_b = 0; OE_b = 0; next_state = S_idle; end
      S_Wr1:	next_state = S_Wr2; 
      S_Wr2:	begin CS_b = 0; WE_b = 0; next_state = S_Wr3; end
      S_Wr3:	begin Rdy = 1; next_state = S_idle; end
      default:	begin 
   		  next_state = S_idle;
		  OE_b = 1;			// active low
    		  CS_b = 1;
    		  WE_b = 1;
		end
    endcase
  end
endmodule

module SRAM   (data, addr, CS_b, OE_b, WE_b);
  parameter		word_size = 8;
  parameter		addr_size = 11;
  parameter		mem_depth = 128;
  parameter		col_addr_size = 4;
  parameter		row_addr_size = 7;
  parameter 		Hi_Z_pattern = 8'bzzzz_zzzz;
  inout [word_size-1: 0] 	data;
  input [addr_size-1: 0] 	addr;
  input 			CS_b, OE_b, WE_b;

  reg  [word_size-1 : 0] data_int;
  reg  [word_size-1 : 0] RAM_col0 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col1 [mem_depth-1 :0];
  reg  [word_size-1 : 0] RAM_col2 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col3 [mem_depth-1 :0];
  reg  [word_size-1 : 0] RAM_col4 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col5 [mem_depth-1 :0];
  reg  [word_size-1 : 0] RAM_col6 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col7 [mem_depth-1 :0];
  reg  [word_size-1 : 0] RAM_col8 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col9 [mem_depth-1 :0];
  reg  [word_size-1 : 0] RAM_col10 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col11 [mem_depth-1 :0];
  reg  [word_size-1 : 0] RAM_col12 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col13 [mem_depth-1 :0];
  reg  [word_size-1 : 0] RAM_col14 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col15 [mem_depth-1 :0];

  wire [col_addr_size-1: 0] 		col_addr = addr[col_addr_size-1: 0]; 
  wire [row_addr_size-1: 0] 	row_addr = addr[addr_size-1: col_addr_size];

  assign data = ((CS_b == 0) && (WE_b == 1) && (OE_b == 0))
     ? data_int: Hi_Z_pattern;

  always @   (data or col_addr or row_addr or CS_b or OE_b or WE_b)
      begin
        data_int = Hi_Z_pattern;
        if ((CS_b == 0) && (WE_b == 0))	// Priority write to memory
          case (col_addr)				// column address
            0: RAM_col0[row_addr] = data;    		
            1: RAM_col1[row_addr] = data;
            2: RAM_col2[row_addr] = data;    		
            3: RAM_col3[row_addr] = data;
            4: RAM_col4[row_addr] = data;    		
            5: RAM_col5[row_addr] = data;
            6: RAM_col6[row_addr] = data;    		
            7: RAM_col7[row_addr] = data;
            8: RAM_col8[row_addr] = data;    		
            9: RAM_col9[row_addr] = data;
            10: RAM_col10[row_addr] = data; 		
            11: RAM_col11[row_addr] = data;
            12: RAM_col12[row_addr] = data; 		
            13: RAM_col13[row_addr] = data;
            14: RAM_col14[row_addr] = data; 		
            15: RAM_col15[row_addr] = data;
          endcase 

        else if ((CS_b == 0) && (WE_b == 1) && (OE_b == 0))  // Read from memory
          case (col_addr)
            0: data_int = RAM_col0[row_addr];   
            1: data_int = RAM_col1[row_addr];
            2: data_int = RAM_col2[row_addr];   
            3: data_int = RAM_col3[row_addr];
            4: data_int = RAM_col4[row_addr];   
            5: data_int = RAM_col5[row_addr];
            6: data_int = RAM_col6[row_addr];   
            7: data_int = RAM_col7[row_addr];
            8: data_int = RAM_col8[row_addr];   
            9: data_int = RAM_col9[row_addr];
            10:data_int = RAM_col10[row_addr]; 
            11:data_int = RAM_col11[row_addr];
            12:data_int = RAM_col12[row_addr]; 
            13:data_int = RAM_col13[row_addr];
            14:data_int = RAM_col14[row_addr]; 
            15:data_int = RAM_col15[row_addr];
          endcase 
      end
  ///*  Comment out of the model for a zero delay functional test.
  specify
    // Parameters for the read cycle
    specparam t_RC = 10;		// Read cycle time
    specparam t_AA = 8;		// Address access time
    specparam t_ACS = 8;		// Chip select access time
    specparam t_CLZ = 2;		// Chip select to output in low-z
    specparam t_OE = 4;		// Output enable to output valid
    specparam t_OLZ = 0;		// Output enable to output in low-z
    specparam t_CHZ = 4;		// Chip de-select to output  in hi-z
    specparam t_OHZ = 3.5;	// Output disable to output in hi-z
    specparam t_OH = 2;		// Output hold from address change

    // Parameters for the write cycle
    specparam t_WC = 7;		// Write cycle time
    specparam t_CW = 5;		// Chip select to end of write
    specparam t_AW = 5;		// Adress valid to end of write
    specparam t_AS = 0;		// Address setup time
    specparam t_WP = 5;		// Write pulse width
    specparam t_WR = 0;		// Write recovery time
    specparam t_WHZ = 3;		// Write enable to output in hi-z
    specparam t_DW = 3.5;	// Data set up time
    specparam t_DH = 0;		// Data hold time     
    specparam t_OW = 10;		// Output active from end of write

  //Module path timing specifications
    (addr *> data) = t_AA;				// Verified in simulation
    (CS_b *> data) = (t_ACS, t_ACS, t_CHZ);
    (OE_b *> data) = (t_OE, t_OE, t_OHZ);		// Verified in simulation
      
  //Timing checks (Note use of conditioned events for the address setup,
  //depending on whether the write is controlled by the WE_b or  by CS_b.

  //Width of write/read cycle
    $width (negedge addr, t_WC); 
			
  //Address valid to end of write
    
    $setup (addr, posedge WE_b &&& CS_b == 0, t_AW);	
    $setup (addr, posedge CS_b &&& WE_b == 0, t_AW);	

  //Address setup before write enabled 

    $setup (addr, negedge WE_b &&& CS_b == 0, t_AS);	 
    $setup (addr, negedge CS_b &&& WE_b == 0, t_AS);	 

  //Width of write pulse
    $width (negedge WE_b, t_WP);		

  //Data valid to end of write 
    $setup (data, posedge WE_b &&& CS_b == 0, t_DW);	
    $setup (data, posedge CS_b &&& WE_b == 0, t_DW);	


  //Data hold from end of write 
    $hold (data, posedge WE_b &&& CS_b == 0, t_DH);
    $hold (data, posedge CS_b &&& WE_b == 0, t_DH);

  //Chip sel to end of write 
    $setup (CS_b, posedge WE_b &&& CS_b == 0, t_CW);
    $width (negedge CS_b &&& WE_b == 0, t_CW);

  endspecify 
//*/
endmodule
////////////////////////////////////////////////////////////////////////////////
module test_SRAM_with_Con ();
  parameter	word_size = 8;
  parameter	addr_size = 11;
  parameter	mem_depth = 128;
  parameter	col_addr_size = 4;
  parameter	row_addr_size = 7;
  parameter 	num_col = 16;
  parameter	 initial_pattern = 8'b000_0001;
  parameter 	Hi_Z_pattern = 8'bzzzz_zzzz;
  parameter 	stop_time = 290000;
  parameter latency = 248000;
  reg 		[word_size-1: 0] data_to_memory;
  reg 		ADS, R_W, clk, reset;
  reg 		send, recv;
  integer 	col, row;
  wire 		[col_addr_size-1:0] 	col_address = col;
  wire 		[row_addr_size-1:0] 	row_address = row;
  wire 		[addr_size-1:0] 		addr = {row_address, col_address};

// Three-state, bi-directional bus

  wire [word_size-1: 0] data_bus = send? data_to_memory: Hi_Z_pattern;
  wire [word_size-1: 0] data_from_memory = recv? data_bus: Hi_Z_pattern;

  SRAM_with_Con M1 (data_bus, addr, Rdy, ADS, R_W, clk, reset);	// UUT

  initial #stop_time $finish;
  initial begin reset = 1; #1 reset = 0; end

  initial begin
    #0 clk = 0;
  forever #10 clk = ~clk;
  end

// Non-Zero delay test: Write walking ones to memory
  initial begin
    ADS = 0;
    R_W = 0;
    send = 0;
    recv = 0;
    for (col= 0; col <= num_col-1; col = col +1) begin
    data_to_memory =initial_pattern;

    for (row = 0; row <= mem_depth-1; row = row + 1) begin
      @  (negedge clk);
      @  (negedge clk);
      @  (negedge clk) ADS = 1; R_W = 0;  // writing
      @  (negedge clk) ADS = 0; 
      @  (posedge clk) send  = 1;
      // @  (posedge clk) send = 0;	// Does not work
      @   (posedge M1.M1.WE_b or posedge M1.M1.CS_b) send = 0;
      //@  (posedge clk) #1 send = 0;  //Replacing above line with this works too.
      @  (posedge clk) data_to_memory = 
       {data_to_memory[word_size-2:0],data_to_memory[word_size-1]};

      end
    end
  end

// Non-Zero delay test: Read back walking ones from memory
  initial begin
    #latency;
    ADS = 0;
    R_W = 1;
    send = 0;
    recv = 1;
    ADS = 1;
    for (col= 0; col <= num_col-1; col = col +1) begin
      for (row = 0; row <= mem_depth-1; row = row + 1) begin
        #60;
      end
    end
  end
  
 // Testbench probe to monitor write activity
  reg  [word_size-1:0] write_probe;


  always @   (posedge M1.M1.WE_b   or  posedge M1.M1.CS_b)
    case (M1.M1.col_addr)

      0: write_probe = M1.M1.RAM_col0[M1.M1.row_addr];   
      1: write_probe = M1.M1.RAM_col1[M1.M1.row_addr];
      2: write_probe = M1.M1.RAM_col2[M1.M1.row_addr];   
      3: write_probe = M1.M1.RAM_col3[M1.M1.row_addr];
      4: write_probe = M1.M1.RAM_col4[M1.M1.row_addr];   
      5: write_probe = M1.M1.RAM_col5[M1.M1.row_addr];
      6: write_probe = M1.M1.RAM_col6[M1.M1.row_addr];   
      7: write_probe = M1.M1.RAM_col7[M1.M1.row_addr];
      8: write_probe = M1.M1.RAM_col8[M1.M1.row_addr];   
      9: write_probe = M1.M1.RAM_col9[M1.M1.row_addr];
      10:write_probe = M1.M1.RAM_col10[M1.M1.row_addr]; 
      11:write_probe = M1.M1.RAM_col11[M1.M1.row_addr];
      12:write_probe = M1.M1.RAM_col12[M1.M1.row_addr]; 
      13:write_probe = M1.M1.RAM_col13[M1.M1.row_addr];
      14:write_probe = M1.M1.RAM_col14[M1.M1.row_addr]; 
      15:write_probe = M1.M1.RAM_col15[M1.M1.row_addr];
    endcase
endmodule

