module clock_gen (clock);
  parameter Half_cycle = 50;
  output clock;
  reg clock;

  initial
    clock = 0;

  always
    begin
      # Half_cycle clock = ~ clock;
    end
endmodule

