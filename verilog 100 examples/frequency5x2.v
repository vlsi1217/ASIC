///////////////////////////////////////////////////////////////////////////////
//This module is used to change the 50Mhz frequency to 20Mhz./////////////////
//Xiaoming,Chen,31,july,2002./////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps
module frequency5x2(in,out,rst);
input in,rst;
output out;   
reg out;
reg mid;
integer counter;
parameter delaytime=25;
always@(posedge rst )
 
          begin
          counter=0;
          out=0;
          mid=0;
          end
always@(posedge in)
          begin
             if(counter==4)
                begin
                mid=~mid;
                counter=0;
                end
              else
               counter=counter+1;
           end
           
  always@(negedge in)
          begin
             if(counter==4)
                begin
                mid=~mid;
                counter=0;
                end
              else
               counter=counter+1;
           end
       
always@(posedge mid )
        begin
          out=~out;
          #delaytime out=~out;
        end
always@(negedge mid)
         begin
          out=~out;
          #delaytime out=~out;
         end                                                 

endmodule

 //////test module///////////////////////////////////////////////////////
//this module is used to test module frequency5x2.v////////////////////////
 `timescale 1ns/100ps                          
    module test;
      
      reg clock,reset; 
                         
       frequency5x2 t(clock,out,reset);
       
       initial
         begin
             clock=0;
            reset=0;
            
            #10 reset=1;
         end
       always #10 clock=~clock;
   endmodule                            //generate 20Mhz waveforme square wave
               
//////////////////////////////////////////////////////////////////////////////
