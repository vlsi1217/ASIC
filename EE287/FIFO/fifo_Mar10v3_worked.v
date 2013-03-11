/*
time: Mar 6, 5:31pm;
ref: http://electrosofts.com/verilog/fifo.html;
proj: EE287 HW, FIFO with 1k MEM
*/

`timescale 1ns/10ps

module fifo (clk,reset,push,full,din,pull,empty,dout,addrin,mdin,write,addrout,mdout);

parameter dout_width=5;
parameter stack_width=45;
parameter stack_height=1024;
parameter stack_ptr_width=10;
input clk, reset, push, pull;
input [44:0] din, mdout;
output full, empty;
output write;
output [9:0] addrin, addrout;
output [44:0] mdin;
output [4:0] dout;

//pointers for reading and writing
reg [stack_ptr_width-1:0] read_ptr,write_ptr;
reg [3:0]	cnt;//45->5 counter

reg empty_reg,full_reg;
reg [4:0] dout_reg;
reg [11:0] fifo_counter;

assign write = (push && !full)?1:0;
assign dout = dout_reg;
assign full = full_reg;
assign empty = empty_reg;
assign addrin = write_ptr;
assign addrout = read_ptr;
assign mdin = din;

always @(fifo_counter)
begin
   empty_reg = (fifo_counter==0)?1:0;
   full_reg = (fifo_counter== stack_height)?1:0;
end

always @(posedge clk or posedge reset)
begin
   if( reset )
       fifo_counter<=#1 0;
   //else if( (!full && push) && ( !empty && pull ) )
   //    fifo_counter <=#1 fifo_counter;
   else if( !full && push )
       fifo_counter <=#1 fifo_counter + 1;
   else if( pull && !empty && cnt==9 ) 
       fifo_counter <=#1 fifo_counter - 1;
   else
       fifo_counter <=#1 fifo_counter;
end

always @(posedge clk or posedge reset)
begin
   if( reset )
       write_ptr <=#1 0;
   else if (push && !full)
   	   write_ptr <=#1 write_ptr+1;
end

always @(posedge clk or posedge reset)
begin
   if( reset )
       read_ptr <=#1 0;
   else if (pull && !empty)
   	   read_ptr <=#1 (cnt==9)?read_ptr+1:read_ptr;
end

//mimic FSM_UCB CS150
always @ (posedge clk) begin
  if (reset) cnt <=#1 0;
  else if (pull && !empty) begin 
      cnt <=#1 (cnt==9)?1:cnt+1;
    end 
end

always@(*) begin
	dout_reg = 0;
	  case (cnt)
	    1: dout_reg = mdout[4:0];
      2: dout_reg = mdout[9:5];
      3: dout_reg = mdout[14:10];
      4: dout_reg = mdout[19:15];
      5: dout_reg = mdout[24:20];
      6: dout_reg = mdout[29:25];
      7: dout_reg = mdout[34:30];
      8: dout_reg = mdout[39:35];
      9: dout_reg = mdout[44:40];
      default : dout_reg  = dout_reg;
   	  endcase
	end

endmodule