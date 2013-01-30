module decoder(out,in);
output    [7:0] out;
input     [2:0]  in;
assign  out=1'b1<<in;
endmodule