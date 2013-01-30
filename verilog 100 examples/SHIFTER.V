module shifter(in,clock,reset,out);

input  in,clock,reset;
output [7:0] out;
reg    [7:0] out;

  always@(posedge clock)
     begin
          if(reset)
              out=8'b0000;
          else
              begin
                out=out<<1;
                out[0]=in;
              end
      end
endmodule
               
        