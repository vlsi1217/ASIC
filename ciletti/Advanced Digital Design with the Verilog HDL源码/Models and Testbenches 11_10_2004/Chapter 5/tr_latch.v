module tr_latch (q_out, enable, data);
  output q_out;
  input enable, data;
  reg q_out;

  always @  (enable or data)
    begin 
      if (enable) q_out = data;	 
    end
endmodule

