module Clock_1_2 (clock_1, clock_2);
output clock_1, clock_2;
reg clock_1, clock_2;
parameter half_cycle_1 = 10;
parameter half_cycle_2 = 5;
parameter period_1 = 2*half_cycle_1;
parameter period_2 = 2*half_cycle_2;

initial begin
clock_1 = 0;
 forever  begin
#half_cycle_1 clock_1 = ~ clock_1;
end
end
initial begin
clock_2 = 0;
forever  begin
#half_cycle_2 clock_2 = ~ clock_2;
end
end

endmodule

