module compare(a,b,equal);

parameter size=1;
input [size-1:0]a,b;
output equal;

assign  equal=(a==b)?1:0;
endmodule
