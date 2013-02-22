module Latch_CA (q_out, data_in, enable);
  output q_out;
  input 	data_in, enable;

  assign q_out = enable ? data_in : q_out;
endmodule


module t_Latch_CA();
wire q_out;
reg data_in, enable;
Latch_CA M1 (q_out, data_in, enable);

initial #100 $finish;

initial begin

#10 enable = 1;
#35 enable = 0;
# 22 enable = 1;
#8 enable = 0;
end
initial begin
data_in = 0;
forever begin
#4 data_in = ~data_in;
end
end




endmodule
