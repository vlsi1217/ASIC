//
// This is a simple memory model for the fifo homework
//
`timescale 1ns/10ps


module mem1k(clk,addrin,datain,write,addrout,dataout);
input clk,write;
input [9:0] addrin,addrout;
input [44:0] datain;
output [44:0] dataout;
reg writechk;
reg [44:0] md[0:1023];
reg [244:0] mdout;


always @(posedge(clk)) begin
  writechk=write;
  #0.1;
  if(writechk != write) $display("Not enough hold time on memory write");
  if(write) begin
   md[addrin]=datain; 
  end
end

assign dataout=mdout;

always @(*) begin
 #0.2
 mdout <= #1 md[addrout];
end

endmodule
