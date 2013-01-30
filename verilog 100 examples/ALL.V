module all (a,b,y);
input    [7:0]  a,b;
output   [8:0]  y;


function [8:0]  add_It_10;
input    [7:0]  a,b;
reg      [7:0]  temp;

  begin
   if(b<10)
     temp=b;
        else
          temp=10;
            add_It_10=a+temp[3:0];
  end
endfunction


assign y=add_It_10(a,b);

endmodule