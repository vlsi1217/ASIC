
/*
time: Mar 6, 5:31pm;
ref: http://electrosofts.com/verilog/fifo.html;
proj: EE287 HW, FIFO with 1k MEM
*/

//`define BUF_WIDTH 3    // MEM1k = 1k -> BUF_WIDTH = 10, no. of bits to be used in pointer
`timescale 1ns/10ps

module fifo (clk,reset,push,full,din,pull,empty,dout,addrin,mdin,write,addrout,mdout);

parameter dout_width=5;
parameter stack_width=45;
parameter stack_height=1024;
parameter stack_ptr_width=10;
input clk, reset, push, pull;
input [44:0] din, mdout;
output full, empty;
output write;
output [9:0] addrin, addrout;
output [44:0] mdin;
output [4:0] dout;

//pointers for reading and writing
reg [stack_ptr_width-1:0] read_ptr,write_ptr;
//reg [stack_ptr_width:0]   ptr_diff;  //ptr gap size, should use height, not width

reg [44:0] mdin_reg,mdout_reg;
reg [4:0] dout_reg;
reg empty_reg, full_reg;
//reg counter;  //9-1 = 8 times to fully pullout the 45bits
//reg [stack_width-1:0] stack[stack_height-1:0]; //mem1k
reg [stack_width-1:0] temp;  //tempary variable to store readed mdout
reg [10:0]    fifo_counter; //ptr_diff
real	cnt;//45->5 counter
reg [9:0] addrin_reg, addrout_reg;

//assign mdin = din;
//assign temp = mdout;   //temp is to store 45 bits and send to dout 5bits/pulse
assign write = (push && !full && !pull && !cnt)?1:0;
assign dout = dout_reg;
assign full = full_reg;
assign empty = empty_reg;
assign addrin = addrin_reg;
assign addrout = addrout_reg;
assign mdin = mdin_reg;

always @( posedge clk or posedge reset)
begin
   if( reset ) begin
     temp <= 0;
     read_ptr <= #1 0;
     write_ptr <= #1 0;
     addrin_reg<= #1 0;
     addrout_reg<= #1 0;
     pull_cnt <= #1 0;
//    ptr_diff <= #1 0;
//    cnt <=#1 9;
   end else begin
    if( pull && !empty ) begin
       temp <= mdout;
       //cnt <= cnt -1 ;
    end else begin
       temp <= temp;
       //cnt <= cnt;
    end
   end
end

//assign fifo_counter = ptr_diff;
always @(fifo_counter)
begin
   empty_reg = (fifo_counter==0)?1:0;
   full_reg = (fifo_counter== stack_height)?1:0;
end

always @(posedge clk or posedge reset)
begin
   if( reset )
       fifo_counter <= 0;
   else if( (!full && push) && ( !empty && pull ) )
       fifo_counter <= fifo_counter;
   else if( !full && push )
       fifo_counter <= fifo_counter + 1;
   else if( !empty && pull )  //it is different than usual one
       fifo_counter <= fifo_counter - 1;
   else
       fifo_counter <= fifo_counter;
end

//mimic FSM_UCB CS150
always @ (posedge clk) begin
  if (reset) cnt <= 9;
  else 
    if (cnt && pull) begin 
      cnt <=#1 cnt -1;
    end else begin 
      cnt <= #1 cnt;
    end 
// waiting for the nine pulse
//always @ (posedge clk) begin
always@(*) begin
	//if (cnt != 0 && pull) begin
	  case (cnt)
      0: dout_reg <= #1 5'bxxxxx;
	    1: dout_reg <= #1 temp[4:0];
		  2: dout_reg <= #1 temp[9:5];
		  3: dout_reg <= #1 temp[14:10];
		  4: dout_reg <= #1 temp[19:15];
	    5: dout_reg <= #1 temp[24:20];
		  6: dout_reg <= #1 temp[29:25];
		  7: dout_reg <= #1 temp[34:30];
		  8: dout_reg <= #1 temp[39:35];
		  9: dout_reg <= #1 temp[44:40];
	  	default : $display("Error in cnt");
   	  endcase
   end
end

// mdout value
always@(posedge clk or posedge reset)
begin
   if( reset ) begin
      mdout_reg <= 0;
   end else begin
   if( pull && !empty) 
      mdout_reg <= mdout; 
    end else
      mdout_reg <= mdout_reg;
    end
   end
end

end else begin
    if( pull && !empty ) begin
       temp <= mdout;
       //cnt <= cnt -1 ;
    end else begin
       temp <= temp;
       //cnt <= cnt;
    end
   
////////////////////////////////////////////////////
//writing part
////////////////////////////////////////////////////
// mdin value
always @(posedge clk)
begin
   if (reset) 
      mdin_reg <= 0;
   if( push && !full ) begin
      mdin_reg <= din;
   end else begin
      mdin_reg <= mdin_reg;
   end
end

//pointer
always@(posedge clk or posedge reset)
begin
   if( reset ) begin
      write_ptr <= 0;
   //   read_ptr <= 0;
   end else begin
   if( !full && push ) write_ptr <= write_ptr + 1;
      else  write_ptr <= write_ptr;
   end
     /* if( !empty && pull )   read_ptr <= read_ptr + 1;
          else read_ptr <= read_ptr;
   end
   */
end

//address
always@(posedge clk or posedge reset)
begin
   if( reset ) 
    addrin_reg <= 0;
  /*if (pull && !empty && !push) begin
    addrout_reg = read_ptr;
    //temp = mdout[addrout_reg];
    */
  else 
   if(push && !full && !pull) begin 
    addrin_reg <= write_ptr;
  end
end

endmodule

/*
//pull counter
//////////////////////////////////////////////////////////
always @ (*) begin
  if (pull) pull_cnt = pull_cnt+1; 
  else pull_cnt = pull_cnt;
end
//////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////
//
//when (!pull && cnt = 9), I always store the next value from MEM to FIFO
//to get rid of the lag!!! 
//////////////////////////////////////////////////////////
always @ (*)
begin
  if (pull_cnt) begin
    //read_ptr = 0;
  //  mdout_reg = mdout;
  //end else begin
  if( pull ) read_ptr = read_ptr + 1;
    else read_ptr = read_ptr;
  end
end

//////////////////////////////////////////////////////////
*/