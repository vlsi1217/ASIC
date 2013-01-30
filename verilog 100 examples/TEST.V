//////////////////////////////////////////////////////////////
////////Module name :test                                                          /////////////
////////Function          :used to test the sequence_detect.v/////////////
////////Author              :Xiaoming Chen                                     /////////////
////////Date                  :18/12/2002                                         /////////////
//////////////////////////////////////////////////////////////

`include "sequence_dectect.v"
`timescale 1ns/100ps
module   test;
reg                      clk,rst;
reg      [63:0]     data;
wire                    out_signal,current_bit;

assign current_bit=data[63];

initial
        begin
        clk<=0;
        rst<=1;
        #2 rst<=0;
        #30 rst<=1;
        data=64'b1101_1101_1101_0111_0111_0101_1100_0101_1101_1011_0001_0000_1011_1010_1100_0101;
        end
        
always #10 clk=~clk;
always@(posedge clk)
        data<={data[62:0],data[63]};
 sequence_dectect m(current_bit,out_signal,clk,rst);
        
endmodule