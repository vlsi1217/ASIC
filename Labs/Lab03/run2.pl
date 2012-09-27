#!/usr/bin/perl
($#ARGV >= 2 ) or die "Need the module name, cycle time, and result name as parameters";
open(f,">",$ARGV[2]);
printf f "Starting the run of the homework 2 assignment file %s cycle time %s\n",$ARGV[0],$ARGV[1] or die "\n\n\n\nFAILED --- didn't write\n\n\n";
$deb = 0;
$deb = 1 if ($#ARGV >=3 && $ARGV[3] == "debug");
printf f "Simulation run on %s", `date`;
printf f "Fall 2012 3 operand floating point multiplier\n";
printf f "%s on %s\n", $ENV{"USER"}, $ENV{"HOSTNAME"};
open(vf,">","vcs_files.f");
printf vf "tbmul.v\n%s.v\n", $ARGV[0];
printf vf "DW02_mult_3_stage.v\n" if (-e "DW02_mult_3_stage.v");
printf vf "DW02_mult_2_stage.v\n" if (-e "DW02_mult_2_stage.v");
close(vf);
open(tf,">","tbmul.v");
printf tf '//
// Check out a few functions
//
`timescale 1ns/10ps

module tmul ;

real a;
real b,c,z;
reg [63:0] dpfA,dpfB,dpfC;
wire [63:0] dpfZ;
integer i;
reg clk,reset;
wire pushout;
reg roundaway;
reg pushin;
reg [63:0] expectedFifo[0:127],expectedA[0:127],expectedB[0:127],
	expectedC[0:127];
reg [6:0] fhp,ftp;

fpmul f(clk,reset,pushin, dpfA,dpfB,dpfC,pushout,dpfZ);


integer delaycntr=100;

integer funNum=1123;

task pushexpected;
input [63:0] exp;
reg [6:0] fnext;
begin
  fnext=fhp+1;
  funNum=funNum*317+2917;
  if(funNum < 0) funNum=-funNum;
  if( (funNum%5)<=1) begin
    pushin=0;
    #10;
    clk=1;
    #10;
    clk=0;
  end
  while(fnext==ftp) begin
    pushin=0;
    #10;
    clk=1;
    #10;
    clk=0;
  end
  pushin=1;
  expectedFifo[fhp]=exp;
  expectedA[fhp]=dpfA;
  expectedB[fhp]=dpfB;
  expectedC[fhp]=dpfC;
  fhp=fhp+1;
  if(fhp==ftp) begin
    $display("You overran the fifo Morris");
    $finish;
  end
end
endtask

reg [63:0] absdiff;
always @(posedge(clk)) begin
  #0.01;	// check for some hold time...
  if(fhp != ftp) begin // is there some data pending
    if(pushout === 1) begin // use the === to make sure dont care is not there...
      delaycntr=100;
      absdiff=expectedFifo[ftp]-dpfZ;
      if(absdiff[63]) absdiff=-absdiff;
 
      if( (expectedFifo[ftp] != dpfZ) && (absdiff > 1) ) begin
        $display("ftp %%d, fhp %%d\n",ftp,fhp);
        $display(" Input A %%22.14e %h",$bitstoreal(expectedA[ftp]),expectedA[ftp]);
        $display(" Input B %%22.14e %h",$bitstoreal(expectedB[ftp]),expectedB[ftp]);
        $display(" Input C %%22.14e %h",$bitstoreal(expectedC[ftp]),expectedC[ftp]);
        $display("expected %%22.14e %h",$bitstoreal(expectedFifo[ftp]),expectedFifo[ftp]);
	$display("Got      %%22.14e %h",$bitstoreal(dpfZ),dpfZ);
        $display("abs diff %%h  %%h",absdiff,absdiff<2);
        $finish;
      end
      ftp=ftp+1;
    end else begin
      delaycntr=delaycntr-1;
      if(delaycntr <= 0) begin
        $display("Error --- Waited 100 clocks for an answer that never came");
        $finish;
      end
    end
  end else delaycntr=100;
end

task doCase;
reg [63:0] zrex;
begin
  dpfA=$realtobits(a);
  dpfB=$realtobits(b);
  dpfC=$realtobits(c);
  z=a*b*c;
  zrex=$realtobits(z);
  if(zrex == 64'."'".'h8000000000000000) zrex=0;
  pushexpected(zrex);
  #100;
  clk=1;
  #100;
  clk=0;
end
endtask

initial begin
';
printf tf  '$dumpfile("fpmul.vcd");
  $dumpvars(9,tmul);
' if $deb == 1;
printf tf '  fhp=0;
  ftp=0;
  clk=0;
  reset=1;
  for(i=0; i < 5; i=i+1) begin
    #100;
    clk=1;
    #100;
    clk=0;
  end
  reset=0;
  a=1.0;
  b=1.0;
  c=1.0;
  doCase;
  a=2.0;
  b=1.0;
  c=0.5;
  doCase;
  a=0.0;
  b=15.0;
  c=1.0;
  doCase;
  a=20.0;
  b=0.0;
  c=1.0;
  doCase;
  a=0.0;
  b=0.0;
  c=0.0;
  doCase;
  a=1.0;
  b=2.0;
  c=0.0;
  doCase;
  a=-10.0;
  b=0.0;
  c=3.0;
  doCase;
  a=0.0;
  b=-10.0;
  doCase;
  a=-0.0;
  b=-10.0;
  c=2.0;
  doCase;
  a=0.01;
  z=a;
  b=-0.111;
  for(i=0; i < 100; i=i+1) begin
    a=a+1.155;
    b=b-3.67;
    c=c*1.3765;
    doCase;
  end
  while(fhp != ftp) begin
    #100;
    clk=1;
    #100;
    clk=0;
  end
  $display("Simulation worked");
end


endmodule';
close(tf);
$tbsum=`md5sum run2.pl`;
chomp($tbsum);
printf f "script md5sum ".$tbsum."\n";


system("vcs +v2k -f vcs_files.f")==0 or die "\n\n\n\nFAILED --- vcs compile failed (Verilog problem)";
printf f "VCS finished\n";
system("rm simres");
system("./simv | tee simres")==0 or die "\n\n\n\n\nFAILED --- simulation failed (Logic problem)";
printf f "simv finished\n";
system("grep -i 'simulation worked' simres")==0 or die "\n\n\n\nFAILED --- simulation didn't get correct results";
printf f " simulation OK\n";
system("rm simres");
system("rm synres.txt");
system("rm -rf simv csrc");
open(sf,">","synthesis.script") or die "\n\n\nFAILED --- Couldn't open the synthesis script for editing\n";
printf sf "set link_library {/apps/toshiba/sjsu/synopsys/tc240c/tc240c.db_NOMIN25 /apps/synopsys/C-2009.06-SP2/libraries/syn/dw02.sldb /apps/synopsys/C-2009.06-SP2/libraries/syn/dw01.sldb }
set target_library {/apps/toshiba/sjsu/synopsys/tc240c/tc240c.db_NOMIN25}\n";
printf sf "read_verilog ./%s.v\n",$ARGV[0];
printf sf "check_design\n";
printf sf "create_clock clk -name clk -period %f\n",$ARGV[1];
printf sf "set_propagated_clock clk
set_clock_uncertainty 0.25 clk
set_propagated_clock clk
set_max_delay 2 -from pushin
set_max_delay 2 -from a
set_max_delay 2 -from b
set_max_delay 2 -from c
set_max_delay 2 -to r
set_max_delay 2 -to pushout
set_max_area 10000
compile -map_effort medium
update_timing
report -cell
report_timing -max_paths 10
write -format verilog -output fpmul_gates.v
write_sdc fpmul_gates.sdc
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
system("ncverilog +sv +libext+.tsbvlibp +access+r -y /apps/toshiba/sjsu/verilog/tc240c tbmul.v fpmul_gates.v | tee gatesim.res")==0 or die "\n\n\n\nFAILED --- Gate level simulation failed";
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
