module mult16(clk,resetb,start,done,ain,bin,yout);
parameter N=16;
input             clk;
input             resetb;
input             start;
input  [N-1:0]    ain;
input  [N-1:0]    bin;
output [2*N-1:0]  yout;
output            done;
reg    [2*N-1:0]  a;
reg    [N-1:0]    b;
reg    [2*N-1:0]  yout;
reg               done;

always@(posedge clk or negedge resetb)
      begin
         if(~resetb)
            begin
              a<=0;
              b<=0;
              yout<=0;
              done<=1'b1;
             end
             
         else
             begin
                if(start)
                     begin
                       a<=ain;
                       b<=bin;
                       yout<=0;
                       done<=0;
                     end
                  
                else
                     begin
                       if(~done)
                           begin
                           if(b!=0)
                             begin
                             if(b[0])yout<=yout+a;
                                b<=b>>1;
                                a<=a<<1;
                             end
                        
                           else
                           done<=1'b1;
                           end
                     end
             end
       end
endmodule
                
                        
                
              