module RAM_static_BD (data, CS_b, OE_b, WE_b);
  inout data;		// Bi-directional data port
  input 	CS_b;		// Active-low chip select
  input	OE_b;		// Active-low output enable
  input	WE_b;		// Active-low write enable
   wire latch_out;
  assign latch_out = ((CS_b == 0) && (WE_b == 0) && (OE_b == 1))
    		? data: latch_out;

  assign data = ((CS_b == 0) && (WE_b == 1) && (OE_b == 0)) 
    		? latch_out : 1'bz;
/*
  specify
    specparam t_C = 120;
    specparam t_AA = 120;
    specparam t_ACS = 120;
    specparam t_CLZ = 10;
    specparam t_OE = 80;
    specparam t_OLZ = 10;
    specparam t_CHZ = 10;
    specparam t_OHZ = 10;
    specparam t_OH = 10;
    specparam t_WC = 10;
    
    specparam t_CW = 70;
    specparam t_AW = 105;
    specparam t_AS = 0;
    specparam t_WP = 70;
    specparam t_WR = 0;
    specparam t_WHZ = 10;
    specparam t_DW = 35;
    specparam t_DH = 0;
    specparam t_OH = 10;

    (addr *> data) = t_AA;

  endspecify*/

endmodule


module test_RAM_static_BD ();
  // Demonstrate write / read capability.
    reg bus_driver;
    reg CS_b, WE_b, OE_b;

    wire data_bus = ((WE_b == 0) && (OE_b == 1)) ? bus_driver : 1'bz;

    RAM_static_BD M1 (data_bus, CS_b, OE_b, WE_b);

  initial #4500 $finish;
  initial begin
    CS_b = 1; bus_driver = 1; OE_b = 1;
    #500 CS_b = 0;
    #500 WE_b = 0;
    #100 bus_driver = 0;
    #100 bus_driver = 1;
    #300 WE_b = 1; #200 bus_driver = 0;
    #300 OE_b = 0; #200 OE_b = 1;  
    #200 OE_b = 0; #300 OE_b = 1; WE_b = 0; 
    #200 WE_b = 1; #200 OE_b = 0; #200 OE_b = 1;
    #500 CS_b = 1;
    #500 bus_driver = 0;
  end

  initial begin
    #3600 WE_b = 1; OE_b = 1;
    #200 WE_b = 0; OE_b = 0;
  end
endmodule

