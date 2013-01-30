module mult_select(a,b,select,out);
parameter size=8;
input    [size-1:0]a,b;
input              select;
output   [size-1:0]out;
reg      [size-1:0]out;
always@(a or b or select)
  begin
       if(select)
             out=a;
        else 
             out=b;
   end
   
endmodule