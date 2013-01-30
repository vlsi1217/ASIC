The Synthetic PIC
Verion 1.1


This is a VHDL synthesizable model of a simple PIC 16C5x microcontroller.
It is not, and is not intended as, a high fidelity circuit simulation.

This package includes the following files.  Note that the license agreement
is stated in the main VHDL file, PICCPU.VHD and common questions are answered
in the file SYNTHPIC.TXT

Files:
README.TXT    This file..
SYNTHPIC.TXT  Questions and Answers
PICCPU.VHD    Main processor VHDL file
PICALU.VHD    ALU for the PICCPU
PICREGS.VHD   Data memory
PICROM.VHD    Program memory (created by HEX2VHDL utility)
PICTEST.VHD   Simple test bench I used to do testing (optional)
PICTEST.CMD   My Viewlogic ViewSim command file (again, optional)
TEST1.ASM     First program I assembled and ran on it.
TEST2.ASM     Another test program..
TEST3.ASM     Yet another..
TEST4.ASM     Yet another..
TEST5.ASM     Yet another..
TEST6.ASM     Yet another..
HEX2VHDL.CPP  Utility for converting HEX file format output of MPASM into
				  the PICROM VHDL entity.
HEX2VHDL.EXE  Compiled DOS program

Questions, comments etc. can be sent to:

  Thomas A. Coonan
  356 Dixie Court
  Lawrenceville, GA 30245
  tcoonan@mindspring.com
