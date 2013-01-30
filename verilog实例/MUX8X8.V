module mux8x8(a,b,out);
parameter size=8,longsize=16;
input [size-1:0]a,b;
output [longsize-1:0]out;

reg  [size-1:0]opa,opb;
reg  [longsize:1]result ;
reg  [size:0]n;
reg  [longsize-1:0]out;

always  @(a or b)
     begin
     n=0;
     out=0;
      for(n=1;n<=size;n=n+1)
        if(opb[n])
           result=result+(opa<<(n-1));
           
      out=result;
       end
endmodule
       
 