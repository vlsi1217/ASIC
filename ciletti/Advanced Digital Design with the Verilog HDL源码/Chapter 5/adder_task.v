module adder_task (c_out, sum, c_in, data_a, data_b, clk, reset,);
  output 		[3: 0] 	sum;
  output			c_out;
  input 		[3: 0] 	data_a, data_b;
  input 			clk, reset;
  input			c_in;
  
  reg			sum;
  reg			c_out;

  always @  (posedge clk or posedge reset)
    if (reset) 	{c_out, sum} <= 0; else 
    add_values (c_out, sum, data_a, data_b, c_in);

  task add_values;
    output	[3: 0] 	sum;
    output		c_out;
    input 		[3: 0] 	data_a, data_b;
    input 			c_in;
 
    begin
      {c_out, sum} <= data_a + (data_b + c_in);
    end
  endtask
endmodule

