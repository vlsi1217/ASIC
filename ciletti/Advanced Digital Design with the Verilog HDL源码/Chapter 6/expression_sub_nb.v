module  expression_sub_nb 
  (data_out1nb, data_out2nb, data_a, data_b, data_c, data_d, sel, clk);

  output		[4: 0]	data_out1nb, data_out2nb;
  input 		[3: 0] 	data_a, data_b, data_c, data_d;
  input			sel, clk;
  reg 		[4: 0]	data_out1nb, data_out2nb;
  
  always @ (posedge clk)
    begin
      data_out2nb <= data_a + data_b + data_c;
      if (sel == 1'b0) 
        data_out1nb <= data_a + data_b + data_c + data_d;
      else
        data_out1nb <= data_a + data_b;
    end
endmodule

