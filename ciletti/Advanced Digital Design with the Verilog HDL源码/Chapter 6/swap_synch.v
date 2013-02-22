module swap_synch (set1, set2, clk, data_a, data_b); 
  output 		data_a, data_b;
  input 		clk, set1, set2, swap;
  reg 		data_a, data_b; 

  always @  (posedge clk)
    begin    
      if (set1) begin data_a <= 1; data_b <= 0; end else
        if (set2) begin data_a <= 0; data_b <= 1; end else
          else
            begin
              data_b <= data_a;
              data_a <= data_b;
            end
    end
endmodule 

