module Bi_dir_bus (data_to_from_bus, send_data, rcv_data);
  inout 	[31: 0] 	data_to_from_bus;
  input  		send_data, rcv_data;
  wire	[31: 0] 	ckt_to_bus;
  wire  	[31: 0] 	data_to_from_bus, data_from_bus;   

  assign data_from_bus = (rcv_data) ? data_to_from_bus : 'bz;
  assign data_to_from_bus = (send_data) ? reg_to_bus : data_to_from_bus;

 	   
  // Behavior using data_from_bus and generating
  // ckt_to_bus goes here
    	 
endmodule

