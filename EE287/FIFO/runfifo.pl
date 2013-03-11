#!/usr/bin/perl
($#ARGV >= 2 ) or die "Require FIFO module name (without .v), cycle time, result name, optionally [debug] as parameters";
open(f,">",$ARGV[2]);
printf f "Starting the run of the FIFO homework assignment file %s cycle time %s\n",$ARGV[0],$ARGV[1] or die "\n\n\n\nFAILED --- didn't write\n\n\n";
printf f "2013 Spring Fifo run\n";
printf f "Homework requires 5ns cycle time\n\n" if $ARGV[1]>5;
printf f "Simulation run on %s", `date`;
printf f "%s on %s\n", $ENV{"USER"}, $ENV{"HOSTNAME"};
open(vf,">","vcs_files.f");
printf vf "topfifo.v\nftb.v\nmem1k.v\n%s.v\n", $ARGV[0];
close(vf);
open(tf,">","topfifo.v");
$debug=0;
$debug=1 if($#ARGV > 2);
my $sid = $ENV{"USER"};
$sid =~ s/[^\d]//g ;
print $sid;
printf tf "//
// This is the top level of the fifo test bench
//

`timescale 1ns/10ps


module topfifo ();

reg clk;
";
printf tf "reg [31:0] sid0=1111$sid;

wire reset,push,pull;
wire [44:0] din,mdin,mdout;
wire [4:0] dout;
wire full,empty;
wire [9:0] addrin,addrout;
wire write;

\n\n ftb t(clk,reset,push,din,full,pull,dout,empty,sid0);\n
mem1k m(clk,addrin,mdin,write,addrout,mdout);\n
fifo f(clk,reset,push,full,din,pull,empty,dout,addrin,mdin,write,addrout,mdout);\n\n
";
printf tf "
initial begin
";
printf tf "	//\$dumpfile(\"fifo.vcd\");
	//\$dumpvars(3,topfifo);
" if($debug==0);
printf tf "	\$dumpfile(\"fifo.vcd\");
	\$dumpvars(3,topfifo);
" if($debug==1);
print tf "	#8000000;
	\$display(\"FAILED --- Ran out of time\");
	\$finish(99);
end

";
printf tf "initial begin\n\tclk=0;\n";
printf tf "\t#%f;",$ARGV[1]*1.8/2;
printf tf "\tforever begin\n";
printf tf "\t  clk=~clk;\n";
printf tf "\t  #%f;\n",$ARGV[1]*1.8/2;
printf tf "\tend\n";
printf tf "end\n";
printf tf "endmodule\n";
close(tf);

system("vcs +v2k -f vcs_files.f")==0 or die "\n\n\n\nFAILED --- vcs compile failed (Verilog problem)";
printf f "VCS finished\n";
system("rm simres");
system("./simv | tee simres")==0 or die "\n\n\n\n\nFAILED --- simulation failed (Logic problem)";
printf f "simv finished\n";
system("grep -i 'Simulation completed OK' simres")==0 or die "\n\n\n\nFAILED --- simulation didn't get correct results";
printf f " simulation OK\n";
system("rm simres");
system("ncverilog +libext+.tsbvlibp +access+r -y /apps/toshiba/sjsu/verilog/tc240c topfifo.v ftb.v mem1k.v  $ARGV[0].v | tee simres")==0 or die "\n\n\n\nFAILED --- Gate level simulation failed";
printf f "ncverilog finished\n";
system("grep -i 'Simulation completed OK' simres")==0 or die "\n\n\n\nFAILED --- ncverilog simulation didn't get correct results";
printf f " ncverilog simulation OK\n";
system("rm simres");

system("rm synres.txt");
system("rm -rf simv csrc");
open(sf,">","synthesis.script") or die "\n\n\nFAILED --- Couldn't open the synthesis script for editing\n";
printf sf "set link_library {/apps/toshiba/sjsu/synopsys/tc240c/tc240c.db_NOMIN25 /apps/synopsys/C-2009.06-SP2/libraries/syn/dw02.sldb /apps/synopsys/C-2009.06-SP2/libraries/syn/dw01.sldb }
set target_library {/apps/toshiba/sjsu/synopsys/tc240c/tc240c.db_NOMIN25}\n";
printf sf "read_verilog %s.v\n",$ARGV[0];
printf sf "check_design\n";
printf sf "create_clock clk -name clk -period %f\n",$ARGV[1];
printf sf "set_propagated_clock clk
set_clock_uncertainty 0.25 clk
set_propagated_clock clk
set_max_delay 2 -from [all_inputs]
set_max_delay 2 -to [all_outputs]
set_max_delay 4.5 -from [all_inputs] -to [all_outputs]
compile -map_effort medium
update_timing
report -cell
report_timing -max_paths 10
write -format verilog -output fifo_gates.v
quit
";
close(sf);

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
die "\n\n\nFAILED --- Number of gates too small, check warinings\n\n" if ($size < 300.0);
printf f "Design synthesized OK\n";
system("rm command.log");
system("rm default.svf");
print "\n\nSynthesis results are in file synres.txt\n";
system("rm gatesim.res");
system("ncverilog +libext+.tsbvlibp +access+r -y /apps/toshiba/sjsu/verilog/tc240c topfifo.v ftb.v mem1k.v  fifo_gates.v | tee gatesim.res")==0 or die "\n\n\n\nFAILED --- Gate level simulation failed";
system("grep -i 'Simulation completed OK' gatesim.res")==0 or die "\n\n\n\nFAILED --- gate level simulation\n\n";
printf f "Gate level simulation OK\n";
$aline = `/sbin/ifconfig | grep Bcast`;
chomp($aline);
@astuff = split(" ",$aline);
printf f "%s\n",@astuff[1];
$md5 = `cat $ARGV[2] run2.pl ftb.v | md5sum`;
chomp($md5);
printf f "%s %s %s\n", $md5 , $ENV{"USER"}, $ENV{"HOSTNAME"};
printf f `ls -ln runfifo.pl`;
printf f "Completed %s", `date`;
close f;
print "Successful Completion of HW run\n";
printf "Run summary file is %s\n",$ARGV[2];
