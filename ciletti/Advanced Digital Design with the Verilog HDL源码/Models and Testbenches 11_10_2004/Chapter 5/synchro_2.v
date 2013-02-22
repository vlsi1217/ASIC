module Synchro_2 (synchro_out, synchro_in, clk, reset);
  output	synchro_out;
  input		synchro_in;
  input		clk, reset;
  reg 		A_temp, synchro_out;
  
  always @ (posedge clk or posedge reset) begin   // Two stage pipeline synchronizer
    if (reset) begin A_temp <= 0; synchro_out <= 0; end
    else begin A_temp <= synchro_in; 
      synchro_out <= A_temp;
    end
 end
endmodule

