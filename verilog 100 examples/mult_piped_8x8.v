`timescale 1ns/1ps
module mult_piped_8x8_2sC(a,b,clk,reset,y);

input [7:0]a,b;
input clk,reset;
output [15:0] y;

reg[7:0] aR [8:0];
reg[7:0] bR [8:0];
reg[15:0]yR [8:0];

always@(posedge clk)
        begin
          aR[7]  =  aR[6];
          bR[7]  =  bR[6];
          yR[7]  =  yR[6];
          aR[6]  =  aR[5];
          bR[6]  =  bR[5];
          yR[6]  =  yR[5];
          aR[5]  =  aR[4];
          bR[5]  =  bR[4];
          yR[5]  =  yR[4];
          aR[4]  =  aR[3];
          bR[4]  =  bR[3];
          yR[4]  =  yR[3];
          aR[3]  =  aR[2];
          bR[3]  =  bR[2];
          yR[3]  =  yR[2];
          aR[2]  =  aR[1];
          bR[2]  =  bR[1];
          yR[2]  =  yR[1];
          aR[1]  =  aR[0];
          bR[1]  =  bR[0];
          yR[1]  =  yR[0];
          //muliply result  (a*b) appears after +clk
          
          aR[0]  =a;
          bR[0]  =b;
          yR[0]  =multiply_8x8_2sC (aR[0],bR[0]);
          
          end
          
          
          function[15:0] multiply_8x8_2sC;
          input [7:0] a,b;
          reg   [7:0] a_mag,b_mag;
          reg   [14:0] Y_mag;
          reg   [14:0] Y_neg;
          
          begin
               case (a[7])
                    0:a_mag  =   a[6:0];
                    1:a_mag  =128-a[6:0];
               endcase
               
               case  (b[7])
                    0:b_mag  =  b[6:0];
                    1:b_mag  =128-b[6:0];
                endcase
                
                
                
                Y_mag=a_mag*b_mag;
                if((a[7]^b[7])&(Y_mag!=0))
                      begin
                      Y_neg=32768-Y_mag[13:0];
                      multiply_8x8_2sC={1'b1,Y_neg};
                      end
                 
                 else
                      multiply_8x8_2sC=Y_mag;
            end
            endfunction
            
            
            assign  y=yR[7];
          endmodule
          
                     
         
          