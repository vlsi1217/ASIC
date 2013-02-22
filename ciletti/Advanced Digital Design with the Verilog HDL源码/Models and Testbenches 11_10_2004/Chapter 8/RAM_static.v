module RAM_static (data_out, data_in, CS_b, WE_b);
  output 	data_out;
  input 	data_in;
  input 	CS_b;		// Active-low chip select control
  input	WE_b;		// Active-low write control

  wire data_out = (CS_b == 0) ? (WE_b == 0) ? data_in : data_out : 1'bz;

endmodule


module test_RAM_static ();
  wire data_out;
  reg data_in;
  reg CS_b, WE_b;

  RAM_static M1  (data_out, data_in, CS_b, WE_b);

  initial #50 $finish;
  initial begin

  CS_b = 1; data_in = 1;
  #5 CS_b = 0;
  #5 WE_b = 1;
  #5 WE_b = 0;
  #1 data_in = 0;
  #1 data_in = 1;
  #5 WE_b = 0;
  #5 WE_b = 1;
  #5 data_in = 0;
  #5 data_in = 1;
  #5 CS_b = 1;
  end
initial begin
#34 WE_b = 0;
#2  WE_b = 1;
end
endmodule

