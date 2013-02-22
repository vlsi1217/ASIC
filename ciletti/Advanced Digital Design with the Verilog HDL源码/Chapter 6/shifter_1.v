module shifter_1 (sig_d, new_signal, Data_in, clock, reset);
  output 		sig_d, new_signal;
  input 		Data_in, clock, reset;
  
  reg 		sig_a, sig_b, sig_c, sig_d, new_signal;

  always @  (posedge reset or posedge clock)
    begin if (reset == 1'b1)
      begin
        sig_a <= 0;
        sig_b <= 0;
        sig_c <= 0;
        sig_d <= 0;
        new_signal <= 0;
      end
    else
      begin 
        sig_a <= Data_in;
        sig_b <= sig_a;
        sig_c <= sig_b;
        sig_d <= sig_c;
        new_signal <= (~ sig_a) & sig_b;
      end
  end  
endmodule

