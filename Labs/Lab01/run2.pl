#!/usr/bin/perl
($#ARGV >= 2 ) or die "Need the module name, cycle time, and result name as parameters -- can follow with debug or synthesis";
open(f,">",$ARGV[2]);
printf f "Starting the run of the circ homework 2 assignment file %s cycle time %s\n",$ARGV[0],$ARGV[1] or die "\n\n\n\nFAILED --- didn't write\n\n\n";
$deb = 0;
$deb = 1 if ($#ARGV >=3 && $ARGV[3] == "debug");
printf f "Simulation run on %s", `date`;
printf f "%s on %s\n", $ENV{"USER"}, $ENV{"HOSTNAME"};
open(vf,">","vcs_files.f");
printf vf "tbc.v\n%s.v\n", $ARGV[0];
printf vf "DW02_mult_3_stage.v\n" if (-e "DW02_mult_3_stage.v");
printf vf "DW02_mult_2_stage.v\n" if (-e "DW02_mult_2_stage.v");
close(vf);
open(tf,">","tbc.v");
printf tf '//
// A simple test bench for the circle module
//
`timescale 1ns/10ps

module tbc;
';
printf tf "reg debug=1;\n" if($deb == 1);
printf tf "reg debug=0;\n" if($deb != 1); 
print tf '
reg clk,reset;
reg [23:0] X,R;
reg pushin;
wire pushout;
wire [23:0] Y;
reg [23:0] fifo[0:256];
integer fh,ft;

reg [160:0] crc[0:3];
integer fbt[0:3];


circ c(clk,reset,pushin,X,R,pushout,Y);


initial begin
  clk=0;
  forever begin
';
printf tf "	#%f;\n", $ARGV[1]*3.00;
printf tf '    clk=~clk;
  end

end

initial begin
  fh=0;
  ft=0;
  reset=1;
  #1;
  if(debug) begin
    $dumpfile("tbc.dump");
    $dumpvars(0,tbc);
  end
  #58;
  reset=0;
end

initial begin

        crc[0]=148991;
	crc[1]=2238967;
	crc[2]=19991;
	crc[3]=22279991;
	fbt[0]=18;
	fbt[1]=39;
	fbt[2]=60;
	fbt[3]=101;
	#1;
end
//
function [31:0] scrc;
input [1:0] wh;
reg [160:0] wcrc;
reg top;
integer i;
begin
	wcrc=crc[wh];
	for(i=0; i < 67; i=i+1) begin
	  top=wcrc[160];
	  wcrc= { wcrc[159:0],top };
	  if(top) begin
	    wcrc[fbt[wh]]=~wcrc[fbt[wh]];
	  end
	end
	crc[wh]=wcrc;
	scrc=wcrc[63:32];
end

endfunction
//
//
//
function [7:0] R8;
input [1:0] wh;
reg[31:0] wr;
begin
	wr = scrc(wh);
	wr=wr >> wr[31:29];
	R8=wr[7:0];
end
endfunction

function [23:0] R24;
input [1:0] wh;
reg [31:0] wr;
begin
	wr = scrc(wh);
	wr = { wr[31:24],wr[7:0],wr[15],wr[18],wr[14:9]};
	R24 = wr[23:0];
end
endfunction

function [2:0] R3;
input [1:0] wh;
reg [31:0] wr;
begin
  wr=scrc(wh);
  R3={wr[19],wr[22],wr[5]};
end
endfunction

function R1;
input [1:0] wh;
reg [31:0] wr;
begin
	wr = scrc(wh);
	R1 = wr[15+wh];
end
endfunction


integer waitc=0;

always @(negedge(clk)) begin
  #0.1;
  if(pushout===1) begin
    if(fh==ft) begin
      $display("You pushed when I expected nothing");
      #5;
      $finish;
    end
    if(Y===fifo[ft]) begin
      ft=ft+1;
      if(ft > 255) ft=0;
      waitc=0;
    end else begin
      $display("Error Expected %x got %x simulation terminated",fifo[ft],Y);
      #5;
      $finish;
    end
  end else begin
    waitc=waitc+1;
    if(waitc > 110) begin
      $display("Error --- waited 100 clocks for an output, no push seen");
      #5;
      $finish;
    end
  end
end

function [23:0] sqrt;
input [47:0] vin;
reg [47:0] diff;
reg [24:0] res,rv;
integer ix;
begin
 res=0;
 rv=0;
 diff=vin;
 for(ix=0; ix < 24; ix=ix+1) begin 
   rv = { rv[22:0], diff[47:46] };
   diff={ diff[45:0],2\'b0};
   if( { res[22:0],2\'b1 } <= rv ) begin
     rv=rv - { res[22:0],2\'b1 };
     res = { res[23:0],1\'b1 };
   end else res= { res[23:0],1\'b0 };
 end
 sqrt=res;
end
endfunction

task calcres;
reg [47:0] x2,r2,diff;
reg [23:0] expected;
begin
 x2=X*X;
 r2=R*R;
 diff=r2-x2;
 expected=sqrt(diff);
 fifo[fh]=expected;
 fh=fh+1;
 if(fh > 255) fh=0;
 if(fh==ft) begin
   $display("FIFO overrun --- simulation aborted");
   #5;
   $finish;
 end
end
endtask

integer wx;
initial begin
  X=0;
  R=0;
  pushin=0;
  #8;
  while(reset) @(negedge(clk));	// wait for the clock
  @(negedge(clk));
  #1;		// and one more...
  if(debug) $display("Starting basic cases with push always on");
  for(X=0; X<1000; X=X+3) begin
    for(R=X; R<1000; R=R+5) begin
      pushin=1;

      #1;
      @(negedge(clk));
      #1;
      calcres();
    end
  end
  if(debug) $display("starting basic cases with push on and off");
  for(X=0; X<100; X=X+3) begin
    for(R=X; R<100; R=R+5) begin
      pushin=0;
      while(R3(R%4)>3) @(negedge(clk));
      #1;
      pushin=1;
      #1;
      @(negedge(clk));
      #1;
      calcres();
    end
  end
  pushin=0;
  if(debug) $display("starting random test cases");
  for(wx=0; wx < 10000; wx=wx+1) begin
    R=R24(0);
    X=R24(1);
    if(X>R) begin
      if(R==0) X=0; else X= X%R;
    end
    pushin=0;
    if(R3(3)>4) pushin=1;
    #1;
    @(negedge(clk));
    #1;
    if(pushin) calcres();
  end
  $display("Simulation worked");
  $finish;
end



endmodule
';
close(tf);
$tbsum=`md5sum run2.pl`;
chomp($tbsum);
printf f "script md5sum ".$tbsum."\n";


system("vcs +v2k -f vcs_files.f")==0 or die "\n\n\n\nFAILED --- vcs compile failed (Verilog problem)";
printf f "VCS finished\n";
system("rm simres");
system("./simv | tee simres")==0 or die "\n\n\n\n\nFAILED --- simulation failed (Logic problem)";
printf f "simv finished\n";
system("grep -i 'simulation worked' simres")==0 or die "\n\n\n\nFAILED --- vcs simulation didn't get correct results";
printf f " vcs simulation OK\n";
system("rm simres");
system("rm synres.txt");
system("rm -rf simv csrc");
system("rm a.out");
system("iverilog -f vcs_files.f")==0 or die "\n\n\n\n\nFAILED iverilog compile";
system("./a.out | tee simres")==0 or die "\n\n\n\n\n\FAILED iverilog simulation";
system("grep -i 'simulation worked' simres")==0 or die "\n\n\n\nFAILED --- iverilog simulation didn't get correct results";
printf f " iverilog simulation OK\n";
system("rm simres");
system("rm synres.txt");
system("rm a.out");
system("rm gatesim.res");
system("ncverilog +sv +libext+.tsbvlibp +access+r -y /apps/toshiba/sjsu/verilog/tc240c -f vcs_files.f | tee simres")==0 or die "\n\n\n\nFAILED --- Gate level simulation failed";
system("grep -i 'simulation worked' simres")==0 or die "\n\n\n\nFAILED --- ncverilog simulation didn't get correct results\n\n";
printf f " ncverilog simulation OK\n";
system("rm simres");
open(sf,">","synthesis.script") or die "\n\n\nFAILED --- Couldn't open the synthesis script for editing\n";
printf sf "set link_library {/apps/toshiba/sjsu/synopsys/tc240c/tc240c.db_NOMIN25 /apps/synopsys/C-2009.06-SP2/libraries/syn/dw02.sldb /apps/synopsys/C-2009.06-SP2/libraries/syn/dw01.sldb }
set target_library {/apps/toshiba/sjsu/synopsys/tc240c/tc240c.db_NOMIN25}\n";
printf sf "read_verilog ./%s.v\n",$ARGV[0];
printf sf "check_design\n";
printf sf "create_clock clk -name clk -period %f\n",$ARGV[1];
printf sf "set_propagated_clock clk
set_clock_uncertainty 0.25 clk
set_propagated_clock clk
set_dont_touch_network clk
set_fix_hold clk
set_dont_use tc240c/CFDN2QXL
set_dont_use tc240c/CFDN2XL
set_dont_use tc240c/CFDN2X1
set_dont_use tc240c/CFDN3X4
set_dont_use tc240c/CFDN2X4
set_dont_use tc240c/CFDN2QX4
set_dont_use tc240c/CFDN3QX4
set_dont_use tc240c/CFDN3QX1
set_dont_use tc240c/CFDN3QXL
set_dont_use tc240c/CFDN2QX1
set_register_type -exact -flip_flop tc240c/CFDN2X2
set_input_delay .2 [get_ports pushin] -clock clk -clock_fall
set_input_delay .2 [get_ports Xin] -clock clk -clock_fall
set_input_delay .2 [get_ports Rin] -clock clk -clock_fall
set_output_delay 2 [get_ports Yout] -clock clk -clock_fall
set_output_delay 2 [get_ports pushout] -clock clk -clock_fall
set_max_area 10000
compile -map_effort medium
update_timing
report -cell
report_timing -max_paths 10
write -format verilog -output circ_gates.v
write_sdc circ_gates.sdc
quit
";
close(sf);
`rm -rf ~/synopsys_cache*`;
`rm -rf ~/.synopsys*`;
system("dc_shell -xg -f synthesis.script | tee synres.txt")==0 or die "\n\n\n\nFAILED --- synthesis failed";
printf f "synthesis ran\n";
system("grep '(MET)' synres.txt")==0 or die "\n\n\n\nFAILED --- Didn't find timing met condition";
system("grep -i error synres.txt")!=0 or die "\n\n\n\nFAILED --- synthesis contained errors";
system("grep -i latch synres.txt")!=0 or die "\n\n\n\nFAILED --- synthesis created latches";
system("grep -i violated synres.txt")!=0 or die "\n\n\n\nFAILED --- synthesis violated timing";
$tline = `grep Total synres.txt`;
chomp($tline);
@gates = split(" ",$tline);
$size = @gates[3];
printf f "Total gates %s\n", $size;
#die "\n\n\nFAILED --- Number of gates too small, check warinings\n\n" if ($size < 5000.0);
printf f "Design synthesized OK\n";
system("rm command.log");
system("rm default.svf");
print "\n\nSynthesis results are in file synres.txt\n";
system("rm gatesim.res");
system("ncverilog +sv +libext+.tsbvlibp +access+r -y /apps/toshiba/sjsu/verilog/tc240c tbc.v circ_gates.v | tee gatesim.res")==0 or die "\n\n\n\nFAILED --- Gate level simulation failed";
system("grep -i 'simulation worked' gatesim.res")==0 or die "\n\n\n\nFAILED --- gate level simulation\n\n";
$aline = `/sbin/ifconfig | grep Bcast`;
chomp($aline);
@astuff = split(" ",$aline);
printf f "%s\n",@astuff[1];
$md5 = `cat $ARGV[2] run2.pl | md5sum`;
chomp($md5);
printf f "%s %s %s\n", $md5 , $ENV{"USER"}, $ENV{"HOSTNAME"};
printf f "Completed %s", `date`;
close f;
print "Successful Completion of HW run\n";
printf "Run summary file is %s\n",$ARGV[2];
