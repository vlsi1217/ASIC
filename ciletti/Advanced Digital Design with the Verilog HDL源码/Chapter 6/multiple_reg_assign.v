module  multiple_reg_assign 
  (data_out1, data_out2, data_a, data_b, data_c, data_d, sel, clk);

  output		[4: 0]	data_out1, data_out2;
  input 		[3: 0] 	data_a, data_b, data_c, data_d;
  input			clk;
 
  reg 		[4: 0]	data_out1, data_out2;
  
  always @ (posedge clk)
    begin
      data_out1 = data_a + data_b ;
      data_out2 = data_out1 + data_c;
      if (sel == 1'b0)
        data_out1 = data_out2 + data_d;
    end
endmodule 

