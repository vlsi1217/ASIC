module Binary_Counter_Part_RTL_by_3 (count, enable, clk, rst);
parameter		size = 4;
output 	[size -1: 0]	count;
input			enable;
input			clk, rst;
wire			enable_DP;

Control_Unit_by_3 M0 (enable_DP, enable, clk, rst);

Datapath_Unit M1 (count, enable_DP, clk, rst);
endmodule

module Control_Unit_by_3  (enable_DP, enable, clk, rst);
  output 		enable_DP;
  input		enable;
  input		clk, rst;		// Not needed 

  reg 		enable_DP;

  always begin: Cycle_by_3
    @ (posedge clk) enable_DP  <= 0;
    if ((rst == 1) || (enable != 1)) disable Cycle_by_3; else 
      @ (posedge clk) 
         if ((rst == 1) || (enable != 1)) disable Cycle_by_3; else 
          @ (posedge clk) 
            if ((rst == 1) || (enable != 1)) disable Cycle_by_3; 
             else enable_DP <= 1;
  end // Cycle_by_3
endmodule


module Datapath_Unit (count, enable, clk, rst);
parameter	size = 4;
output 		[size-1: 0] count;
input		enable;
input		clk, rst;
reg		count;
wire		[size-1: 0] next_count;

always @ (posedge clk) if (rst == 1) count <= 0; else if (enable == 1) count <= next_count(count); 

function [size-1: 0] next_count;
input [size-1:0] count;
begin
next_count = count + 1;
end
endfunction
endmodule


