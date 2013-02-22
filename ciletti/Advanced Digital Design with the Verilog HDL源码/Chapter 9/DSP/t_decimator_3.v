module t_decimator_3 ();
  parameter 	word_length = 8;
  parameter 	latency = 4;
  wire		[(word_length*latency) -1: 0] 	data_out;
  reg		[word_length-1:0]			data_in;
  reg						hold;
  reg						load;
  reg						clock;
  reg						reset;


decimator_3 M1 (data_out, data_in, hold, load, clock, reset);

initial #500 $finish;
initial begin reset = 1; #10 reset = 0; end
initial begin clock = 0; forever #5 clock = ~clock; end
initial data_in = 8'h00;

always #50 forever begin @ (negedge clock) data_in = 8'hff; @(negedge clock) data_in = 8'h00; end

initial fork
#0  begin load = 0; hold = 0; end
#50 forever begin
#0 load = 0; 
#0 hold = 1;
@ (negedge clock) load = 0;
repeat (3) @(negedge clock);
hold = 0;
load = 1; 
@ (negedge clock);
end
join
 endmodule
