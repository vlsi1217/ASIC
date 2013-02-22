module  expression_sub 
  (data_out1, data_out2, data_a, data_b, data_c, data_d, sel, clk);

  output		[4: 0]	data_out1, data_out2;
  input 		[3: 0] 	data_a, data_b, data_c, data_d;
  input			sel, clk;
  reg 		[4: 0]	data_out1, data_out2;
  
  always @ (posedge clk)
    begin
      data_out2 = data_a + data_b + data_c;
      if (sel == 1'b0) 
        data_out1 = data_a + data_b + data_c + data_d;
      else
        data_out1 = data_a + data_b;
    end
endmodule

