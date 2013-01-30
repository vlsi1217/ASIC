module fifo(clock,reset,read,write,fifo_in,fifo_out,fifo_empty,fifo_half,fifo_full);
input              clock,reset,read,write;
input   [15:0]     fifo_in;
output  [15:0]     fifo_out;
output             fifo_empty,fifo_half,fifo_full;

reg     [15:0]     fifo_out;          
reg     [3:0]      read_ptr,write_ptr,counter;
reg     [15:0]     ram    [15:0];
wire               fifo_empty,fifo_half,fifo_full;
always@(posedge clock)
 if(reset)
  begin
  read_ptr     =0;
  write_ptr    =0;
  counter      =0;
  fifo_out     =0;
  end
 else

 case({read,write})
     2'b00:counter=counter;
     2'b01:begin
           ram[write_ptr]=fifo_in;
           counter=counter+1;
           write_ptr=(write_ptr==15)?0:write_ptr+1;
           end
     2'b10:begin
           fifo_out=ram[read_ptr];
           counter=counter-1;
           read_ptr=(read_ptr==15)?0:read_ptr+1;
           end
     2'b11:begin
           if(counter==0)
           fifo_out=fifo_in;
           else
           begin
           ram[write_ptr]=fifo_in;
           fifo_out=ram[read_ptr];
           write_ptr=(write_ptr==15)?0:write_ptr+1;
           read_ptr=(read_ptr==15)?0:read_ptr+1;
           end
           end
endcase

assign fifo_empty=(counter==0);
assign fifo_full=(counter==15);
assign fifo_half=(counter==8);

endmodule