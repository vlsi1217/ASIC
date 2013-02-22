module Latch_Rbar_CA (q_out, data_in, enable, reset);
  output q_out;
  input data_in, enable, reset;
  assign q_out = !reset ? 0 : enable ? data_in : q_out;
endmodule


module t_Latch_Rbar_CA();
wire q_out;
reg data_in, enable, reset_bar;
Latch_Rbar_CA M1 (q_out, data_in, enable, reset_bar);

initial #100 $finish;
initial begin 
#5 reset_bar = 0;
#17 reset_bar = 1;
#35 reset_bar = 0;
#14 reset_bar = 1;
end

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
