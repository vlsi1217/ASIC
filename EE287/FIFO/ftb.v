//
// This is a simple test bench for the fifo
//
// Author: Morris Jones
// San Jose State University
//
//

`timescale 1ns/10ps


module ftb(clk,reset,push,dataout,full,pull,datain,empty,sid0);
input clk;
output reset,push;
output [44:0] dataout;
input full;
output pull;
input [4:0] datain;
input empty;
input [31:0] sid0;

reg [160:0] crc[0:3];
integer fbt[0:3];
reg rst;
integer numout;
reg pu,pl;
reg [44:0] dout;

reg [4:0] dback[0:8000*9];
integer wp,rp;
reg run;	// is it running yet...
reg filling;	// we are going to fill it up...
integer amtout;	// amount we have sent out
integer amtback;// amount we have read in...


assign push=pu;
assign pull=pl;
assign dataout=dout;
assign reset=rst;


integer ixi;
integer xyx;
initial begin
	rst=1;
	run=0;
	filling=1;
	numout=0;	// amount out in target fifo
	amtout=0;	// total sent
	wp=0;
	rp=0;
	#1;	// some delay so the student id is in the thing
        for(ixi=0; ixi < (sid0 %31); ixi=ixi+1) xyx=$random;
	@(posedge(clk));
	@(posedge(clk));
	@(posedge(clk));
	#1;
	rst=0;
	@(posedge(clk));
	run=1;
end

//

//
//
//
function [7:0] R8;
input [1:0] wh;
reg[31:0] wr;
begin
	wr = $random;
	wr=wr >> wr[31:29];
	R8=wr[7:0];
end
endfunction

function [23:0] R24;
input [1:0] wh;
reg [31:0] wr;
begin
	wr = $random;
	wr = { wr[31:24],wr[7:0],wr[15],wr[18],wr[14:9]};
	R24 = wr[23:0];
end
endfunction

function R1;
input [1:0] wh;
reg [31:0] wr;
begin
	wr = $random;
	R1 = wr[15+wh];
end
endfunction

task pushback;
input [4:0] din;
begin
	if(wp+1 == rp) begin
	  $display("You overran the internal read back morris");
	  $finish(7);
	end
	dback[wp]=din;
	numout=numout+1;
	wp = wp+1;
	if(wp > 8000*9-1) wp=0;
end
endtask

function [4:0] getback;
input junk;

begin
	if(rp==wp) begin
	  $display("You pulled an empty dback ... Shame on you Morris");
	  $finish(7);
	end
	getback=dback[rp];
	amtback = amtback + 1;
	rp = rp + 1;
	if(rp > 8000*9-1) rp = 0;
end
endfunction

//
//
// This reads back data from the target FIFO.  It compares it to what is in the dback FIFO
//
//
integer sanity;
reg [4:0] dfifo;
initial begin
	#10;
	pl=0;
	amtback=0;
	while(filling) begin
	  @(posedge(clk));
	end
	sanity=1000;
	while(1) begin
          @(posedge(clk));
          #0.1;	// check the hold time
          if(pl ===1 && empty !== 1) begin
		if(wp==rp) begin
		  $display("FAILED --- The FIFO should be empty, and the empty signal is not 1");
                  $finish(7);
		end
		dfifo=getback(0);
		if(dfifo !== datain) begin
		  $display("FAILED --- Expected %x and received %x",dfifo,datain);
                  #10;
	          $finish(7);
	        end
		sanity=1000;	
          end else begin
	    if(pl === 1) begin
		sanity=sanity-1;
		if(sanity < 0) begin
		  $display("FAILED --- I pulled a thousand times, and you didn't give any data");
		  $finish(7);
                end
            end
          end
	  #1;
	  pl=R1(2);
	end	
end


//
//
// sends data to the thing (Oh what fun)
//
//
integer wait_a_while;
integer pitem;
reg [44:0] accreg;
integer dcnt;
initial begin
	pu=0;
        pitem=0;
        accreg=0;
        amtout=0;
	#10
	while(!run) begin
	  @(posedge(clk));
	end
	wait_a_while=50;
	while(wait_a_while > 0) begin
	  @(posedge(clk));
	  wait_a_while=wait_a_while-1;
	end
	accreg = {$random,$random};
	dout = accreg;
	#1;
	while(amtout < 2000*9) begin
	  @(posedge(clk));
	  #0.1;
	  if(pu == 1 && full == 0) begin
	    amtout = amtout+9;
            pitem=pitem+9;
            for(dcnt=0; dcnt < 9; dcnt=dcnt+1) begin
              pushback(accreg);
              accreg = accreg >> 5;
            end
	  end else if(pu == 1 && full==1 && amtout < 1020*9) begin
            $display("\n\n\nYou said you are full, and I think you should have room\n%d segments transferred\n",amtout);
            $finish(7);
          end
          #0.9;
	  accreg={$random,$random};
	  dout = accreg;
 
	  if(amtout > 500*9) begin 
		pu= R1(0);
                if( pu == 0) dout = {$random,$random};
	  end else pu=1;
	  #2;
           
 	  if(full) filling=0;
	end
	if(filling) begin $display("I never saw the full signal"); $finish(8); end
	@(posedge(clk));
        #1;
	pu=0;
	#3;
	$display("Finished fill to the FIFO");
	while( numout > amtback ) begin
	  @(posedge(clk));
	  #1;
	end
	@(posedge(clk));
	@(posedge(clk));
	#1;
	if(!empty) begin
	  $display("Fifo should be empty, and it isn't");
	  $finish;
	end
	while(amtout < 2000*9) begin
	  @(posedge(clk));
	  #0.1;
	  if(pu == 1 && full == 0) begin
	    amtout = amtout+9;
            pitem=pitem+9;
            for(dcnt=0; dcnt < 9; dcnt=dcnt+1) begin
              pushback(accreg);
              accreg = accreg >> 5;
            end
	  end else if(pu == 1 && full==1 && amtout < 1020*9) begin
            $display("\n\n\nYou said you are full, and I think you should have room\n%d segments transferred\n",amtout);
            $finish(7);
          end
          #0.9;
	  accreg={$random,$random};
	  dout = accreg;
 
	  if(amtout > 500*9) begin 
		pu= R1(0);
                if( pu == 0) dout = {$random,$random};
	  end else pu=1;
	  #2;
           
 	  if(full) filling=0;
	end
	if(filling) begin $display("I never saw the full signal"); $finish(8); end
	@(posedge(clk));
        #1;
	pu=0;
	#3;
	$display("Finished sending to the FIFO");
	while( numout > amtback ) begin
	  @(posedge(clk));
	  #1;
	end
	@(posedge(clk));
	@(posedge(clk));
	#1;
	if(!empty) begin
	  $display("Fifo should be empty, and it isn't");
	  $finish;
	end
	$display("Simulation completed OK");
	$finish;
end

endmodule
