`include "cla_8bits.v"
module test_cla_8bits;

reg    [7:0]   m,n;
reg            cin;
wire   [7:0]   sum;
wire           cout;

cla_8bits tt (m,n,cin,cout,sum);

initial
  begin
  
  #40
  cin=  1;
  m  =  8'b10101100;
  n  =  8'b11010101;
  
  #40
  cin=  1;
  m  =  8'b10001111;
  n=    8'b10001111;
  
  #40 
  cin=  0;
  m  =  8'b01010101;
  n  =  8'b10101010;
  
  end
  
 always@(m or n or cin)
 begin
 #20
  $display("a=%b  b=%b  cin=%b  cout=%b  sum=%b",m,n,cin,cout,sum);
  end
  endmodule

