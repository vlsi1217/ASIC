//------------------------------------------------
// components.v
//
// Authors
// David Harris David_Harris at hmc dot edu 3 November 2005
// Carl Nygaard carlpny at gmail dot com 2007
// Thomas W. Barr tbarr at cs dot hmc dot edu 2007
// Matt Totino mtotino at hmc.edu 2007
// Nathaniel Pinckney npinckney at gmail dot com
// Nate Schlossberg sonofernda at gmail dot com 2007
//
// Pipelined MIPS processor spare parts
//------------------------------------------------

`timescale 1 ns / 1 ps


module adder(input  [31:0] a, b,
             output [31:0] y);

  assign #1 y = a + b;
endmodule

// Adder with carry in and out
module adderc #(parameter WIDTH = 32)
             (input  [WIDTH-1:0] a, b,
              input              cin,
              output [WIDTH-1:0] y,
              output             cout);
 
  assign #1 {cout, y} = a + b + cin;
endmodule

module eqcmp #(parameter WIDTH = 32)
             (input [WIDTH-1:0] a, b,
              output            eq);

  assign #1 eq = (a == b);
endmodule

module eqzerocmp #(parameter WIDTH = 32)
                 (input [WIDTH-1:0]  a,
                  output        eq);

  assign #1 eq = (a == 0);
endmodule

module neqzerocmp #(parameter WIDTH = 32)
                 (input [WIDTH-1:0]  a,
                  output        eq);

  assign #1 eq = (a != 0);
endmodule

module gtzerocmp #(parameter WIDTH = 32)
                 (input [WIDTH-1:0] a,
                  output       eq);

  assign #1 eq = ~a[WIDTH-1] & (a[WIDTH-2:0] !== 0);
endmodule

module ltzerocmp #(parameter WIDTH = 32)
                 (input [WIDTH-1:0] a,
                  output       eq);

  assign #1 eq = a[WIDTH-1];
endmodule

module sl2(input  [31:0] a,
           output [31:0] y);

  // shift left by 2
  assign #1 y = {a[29:0], 2'b00};
endmodule

// When disabled, signext acts as a zero extender
module signext #(parameter INPUT = 16, OUTPUT = 32)
               (input  [INPUT-1:0] a,
               input  enable,
               output [OUTPUT-1:0] y);
               
  wire extension;
  
  assign #1 extension = (enable ? a[INPUT-1] : 0);
  assign #1 y = {{OUTPUT-INPUT{extension}}, a};
endmodule

// start of flops
module floprc #(parameter WIDTH = 8)
              (input                  ph1, ph2, reset, clear,
               input      [WIDTH-1:0] d, 
               output reg [WIDTH-1:0] q);

  reg [WIDTH-1:0] master;

  always @(ph2, reset, d, clear)
    if (ph2) #1 master <= reset ? 0 : (clear ? 0 : d);

  always @(ph1, master)
    if (ph1) #1 q <= master;
endmodule

module flopenrc #(parameter WIDTH = 32)
                 (input                  ph1, ph2, reset,
                  input                  en, clear,
                  input      [WIDTH-1:0] d, 
                  output reg [WIDTH-1:0] q);
 
  reg [WIDTH-1:0] master;

  always @(ph2, reset, en, d, q, clear)
    if (ph2) #1 master <= reset ? 0 : (clear ? 0 : (en ? d : q));

  always @(ph1, master)
    if (ph1) #1 q <= master;
endmodule

module flopenr #(parameter WIDTH = 32)
                (input                  ph1, ph2, reset,
                 input                  en,
                 input      [WIDTH-1:0] d, 
                 output reg [WIDTH-1:0] q);
 
  reg [WIDTH-1:0] master;

  always @(ph2, reset, en, d, q)
    if (ph2) #1 master <= reset ? 0 : (en ? d : q);

  always @(ph1, master)
    if (ph1) #1 q <= master;
endmodule

module flopen #(parameter WIDTH = 32)
               (input                  ph1,ph2,
                input                  en,
                input      [WIDTH-1:0] d, 
                output reg [WIDTH-1:0] q);
 
  reg [WIDTH-1:0] master;

  always @(ph2, en, d, q)
    if (ph2) #1 master <= en ? d : q;

  always @(ph1, master)
    if (ph1) #1 q <= master;
endmodule

module flopr #(parameter WIDTH = 32)
              (input                  ph1, ph2, reset,
               input      [WIDTH-1:0] d, 
               output reg [WIDTH-1:0] q);
 
  reg [WIDTH-1:0] master;

  always @(ph2, reset, d)
    if (ph2) #1 master <= reset ? 0 : d;

  always @(ph1, master)
    if (ph1) #1 q <= master;
endmodule
// end flops

module mux2 #(parameter WIDTH = 32)
             (input  [WIDTH-1:0] d0, d1, 
              input              s, 
              output [WIDTH-1:0] y);

  assign #1 y = s ? d1 : d0; 
endmodule

module mux3 #(parameter WIDTH = 32)
             (input  [WIDTH-1:0] d0, d1, d2,
              input  [1:0]       s, 
              output [WIDTH-1:0] y);

  assign #1 y = s[1] ? d2 : (s[0] ? d1 : d0); 
endmodule

module mux4 #(parameter WIDTH = 32)
             (input  [WIDTH-1:0] d0, d1, d2, d3,
              input  [1:0]       s, 
              output [WIDTH-1:0] y);

  assign #1 y = s[1] ? (s[0] ? d3 : d2)
                     : (s[0] ? d1 : d0); 
endmodule

module mux5 #(parameter WIDTH = 32)
             (input  [WIDTH-1:0] d0, d1, d2, d3, d4,
             input   [2:0]  s,
                output  [WIDTH-1:0] y);

  // 101 = d4; 100 = d3; 010 = d2; 001 = d1; 000 = d0

  assign #1 y = s[2] ? (s[0] ? d4 : d3)
                     : (s[1] ? d2 : (s[0] ? d1 : d0));
endmodule

// Basic one hot decoders, eg b10 -> b0100
module dec2 (input  [1:0] x,
             output [3:0] y);

  assign #1 y = (x[0] ? (x[1] ? 4'b1000 : 4'b0010)
                      : (x[1] ? 4'b0100 : 4'b0001));
endmodule

module dec1 (input        x,
             output [1:0] y);

  assign #1 y = (x ? 2'b01 : 2'b10);
  endmodule
module and2 #(parameter WIDTH = 32)
             (input  [WIDTH-1:0] a, b,
              output [WIDTH-1:0] y);

  assign #1 y = a & b;
endmodule

module xor2 #(parameter WIDTH = 32)
             (input  [WIDTH-1:0] a, b,
              output [WIDTH-1:0] y);

  assign #1 y = a ^ b;
endmodule

module inc #(parameter WIDTH = 32)
            (input  [WIDTH-1:0] a,
             output [WIDTH-1:0] y,
             output             cout);
 
  assign #1 {cout, y} = a + 1'b1;
endmodule

module zerodetect #(parameter WIDTH = 32)
             (input  [WIDTH-1:0] a,
              output             y);
 
  assign #1 y = ~|a;
endmodule

module prienc_8 (input       [7:0]  a,
                  output reg [2:0]  y);
   always @ ( * )
    casex(a)
      // rearrange to set priority.
      8'b1xxxxxxx : y <= 3'b000;
      8'b01xxxxxx : y <= 3'b001;
      8'b001xxxxx : y <= 3'b010;
      8'b0001xxxx : y <= 3'b011;
      8'b00001xxx : y <= 3'b100;
      8'b000001xx : y <= 3'b101;
      8'b0000001x : y <= 3'b110;
      8'b00000001 : y <= 3'b111;
      default    : y <= 3'bxxx;
    endcase
endmodule

module tribuf #(parameter WIDTH = 32)
               (input en,
                input [WIDTH-1:0] a,
                output [WIDTH-1:0] y);
    wire [WIDTH-1:0] highz;
    assign highz = {WIDTH{1'bz}};
    assign #1 y = en ? a : highz;        
endmodule

// Complementary mux
module cmux2 #(parameter WIDTH = 32)
             (input  [WIDTH-1:0] d0, d1, 
              input              s,
              output [WIDTH-1:0] y1,
              output [WIDTH-1:0] y2);

  assign #1 y1 = s ? d1 : d0;
  assign #1 y2 = s ? d0 : d1;
endmodule
