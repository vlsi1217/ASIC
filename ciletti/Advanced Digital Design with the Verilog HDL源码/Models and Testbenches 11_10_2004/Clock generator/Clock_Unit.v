module Clock_Unit (clock);
output clock;
 reg clock;
parameter delay = 0;
parameter half_cycle = 10;
initial begin
#delay clock = 0;
forever #half_cycle clock = ~clock;
end
endmodule
