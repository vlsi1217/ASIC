<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1252">
<META NAME="Generator" CONTENT="Microsoft Word 97">
<TITLE>The RISC8 Verilog core</TITLE>
</HEAD>
<BODY LINK="#0000ff" VLINK="#800080">

<B><FONT FACE="Arial" SIZE=5><P ALIGN="CENTER">RISC8 Core</P>
</FONT><FONT FACE="Arial"><P ALIGN="CENTER">Version 1.0</P>
</B></FONT><FONT FACE="Times"><P ALIGN="CENTER">Tom Coonan</P>
<P ALIGN="CENTER">tcoonan@mindspring.com</P>
</FONT><FONT SIZE=2><P ALIGN="JUSTIFY">1&#9;Introduction&#9;</FONT><A HREF="#_Toc469736944">*</A> </P>
<FONT SIZE=2><P>2&#9;Quick Start&#9;</FONT><A HREF="#_Toc469736945">*</A></P>
<FONT SIZE=2><P>3&#9;System Architecture&#9;</FONT><A HREF="#_Toc469736946">*</A></P>
<FONT SIZE=2><P>4&#9;Compatibility with Microchip 16C57 Devices&#9;</FONT><A HREF="#_Toc469736947">*</A></P>
<FONT SIZE=2><P>5&#9;Module Hierarchy&#9;</FONT><A HREF="#_Toc469736948">*</A></P>
<FONT SIZE=2><P>6&#9;Synthesis&#9;</FONT><A HREF="#_Toc469736949">*</A></P>
<FONT SIZE=2><P>7&#9;CPU Module&#9;</FONT><A HREF="#_Toc469736950">*</A></P>
<FONT SIZE=2><P>8&#9;Memory Interfaces&#9;</FONT><A HREF="#_Toc469736951">*</A></P>
<FONT SIZE=2><P>9&#9;ALU&#9;</FONT><A HREF="#_Toc469736952">*</A></P>
<FONT SIZE=2><P>10&#9;Instruction Decoder&#9;</FONT><A HREF="#_Toc469736953">*</A></P>
<FONT SIZE=2><P>11&#9;Register File&#9;</FONT><A HREF="#_Toc469736954">*</A></P>
<FONT SIZE=2><P>12&#9;Firmware Development&#9;</FONT><A HREF="#_Toc469736955">*</A></P>
<FONT SIZE=2><P>13&#9;Expansion&#9;</FONT><A HREF="#_Toc469736956">*</A></P>
<FONT SIZE=2><P>14&#9;Test Programs&#9;</FONT><A HREF="#_Toc469736957">*</A></P>
<FONT SIZE=2><P>15&#9;Bugs&#9;</FONT><A HREF="#_Toc469736958">*</A></P>
<B><FONT FACE="Arial" SIZE=4><P>&nbsp;</P>
<P><A NAME="_Toc469736944">1&#9;Introduction</A></P>
</B></FONT><FONT SIZE=2><P>The Free-RISC8 is a Verilog implementation of a simple 8-bit processor. The RISC8 is binary code compatible with the Microchip 16C57 processor. Code may be developed and debugged using tools available from a number of 3<SUP>rd</SUP> Party tool developers. Programs existing for the 16C57 may be ported to the RISC8 for use in an FPGA, etc.</P>
<P>The design is synthesizable and has been used by various people in the past within ASICs as well as FPGAs. The package consists of the following Verilog and C files:</P></FONT>
<TABLE BORDER CELLSPACING=1 CELLPADDING=7 WIDTH=547>
<TR><TD WIDTH="14%" VALIGN="TOP">
<P ALIGN="CENTER"><B><I><FONT SIZE=2>File</B></I></FONT></TD>
<TD WIDTH="86%" VALIGN="TOP">
<B><I><FONT SIZE=2><P ALIGN="CENTER">Description</B></I></FONT></TD>
</TR>
<TR><TD WIDTH="14%" VALIGN="TOP">
<FONT SIZE=2><P>test.v</FONT></TD>
<TD WIDTH="86%" VALIGN="TOP">
<FONT SIZE=2><P>Top-level testbench, including the behavioral Verilog program memory</FONT></TD>
</TR>
<TR><TD WIDTH="14%" VALIGN="TOP">
<FONT SIZE=2><P>cpu.v</FONT></TD>
<TD WIDTH="86%" VALIGN="TOP">
<FONT SIZE=2><P>Top-level synthesizable module.</FONT></TD>
</TR>
<TR><TD WIDTH="14%" VALIGN="TOP">
<FONT SIZE=2><P>idec.v</FONT></TD>
<TD WIDTH="86%" VALIGN="TOP">
<FONT SIZE=2><P>The Instruction Decoder. This module is instanced underneath the cpu module.</FONT></TD>
</TR>
<TR><TD WIDTH="14%" VALIGN="TOP">
<FONT SIZE=2><P>alu.v</FONT></TD>
<TD WIDTH="86%" VALIGN="TOP">
<FONT SIZE=2><P>The ALU. This module is instanced underneath the cpu module.</FONT></TD>
</TR>
<TR><TD WIDTH="14%" VALIGN="TOP">
<FONT SIZE=2><P>regs.v</FONT></TD>
<TD WIDTH="86%" VALIGN="TOP">
<FONT SIZE=2><P>The Register File. This module is instanced underneath the cpu module.</FONT></TD>
</TR>
<TR><TD WIDTH="14%" VALIGN="TOP">
<FONT SIZE=2><P>exp.v</FONT></TD>
<TD WIDTH="86%" VALIGN="TOP">
<FONT SIZE=2><P>Optional Expansion Module. This is an example module that shows how an expansion circuit is added onto the design. The module supplied with this release implements a very simple DDS (Direct Digital Synthesis) circuit that is used for the DDS demo.</FONT></TD>
</TR>
<TR><TD WIDTH="14%" VALIGN="TOP">
<FONT SIZE=2><P>dram.v</FONT></TD>
<TD WIDTH="86%" VALIGN="TOP">
<FONT SIZE=2><P>Memory model for Register File ‘D’ata memory (it’s a Synchronous RAM)</FONT></TD>
</TR>
<TR><TD WIDTH="14%" VALIGN="TOP">
<FONT SIZE=2><P>pram.v</FONT></TD>
<TD WIDTH="86%" VALIGN="TOP">
<FONT SIZE=2><P>Memory model for Program Memory ‘P’ata memory (it’s a Synchronous RAM)</FONT></TD>
</TR>
<TR><TD WIDTH="14%" VALIGN="TOP">
<FONT SIZE=2><P>hex2v.c,</P>
<P>hex2v.exe</FONT></TD>
<TD WIDTH="86%" VALIGN="TOP">
<FONT SIZE=2><P>A C program that translates Intel HEX format data into the Verilog $readmemh compatible .ROM file.</FONT></TD>
</TR>
<TR><TD WIDTH="14%" VALIGN="TOP">
<FONT SIZE=2><P>basic.asm, basic.hex,</P>
<P>basic.rom</FONT></TD>
<TD WIDTH="86%" VALIGN="TOP">
<FONT SIZE=2><P>The "Basic Confidence" test program which exercises all the instructions.</FONT></TD>
</TR>
<TR><TD WIDTH="14%" VALIGN="TOP">
<FONT SIZE=2><P>dds.asm,</P>
<P>dds.hex,</P>
<P>dds.rom</FONT></TD>
<TD WIDTH="86%" VALIGN="TOP">
<FONT SIZE=2><P>A demo that uses the DDS circuit. The demo outputs an FSK "burst".</FONT></TD>
</TR>
<TR><TD WIDTH="14%" VALIGN="TOP">
<FONT SIZE=2><P>runit</FONT></TD>
<TD WIDTH="86%" VALIGN="TOP">
<FONT SIZE=2><P>A script containing the Verilog command line required.</FONT></TD>
</TR>
<TR><TD WIDTH="14%" VALIGN="TOP">
<FONT SIZE=2><P>risc8.pdf</FONT></TD>
<TD WIDTH="86%" VALIGN="TOP">
<FONT SIZE=2><P>This file.</FONT></TD>
</TR>
</TABLE>

<FONT SIZE=2><P>&nbsp;</P>
</FONT><B><FONT FACE="Arial" SIZE=4><P><A NAME="_Toc469736945">2&#9;Quick Start</A></P>
</B></FONT><FONT SIZE=2><P>Extract all the files from the supplied ZIP into a new directory. Once all the files have been extracted from the archive, invoke your Verilog simulator specifying all the Verilog files (the ‘runit’ script is what I happen to use). The "Basic Confidence" simulation is initially configured within the test.v testbench. This test verifies that the core is able to reset and run all the RISC8 instructions. The following output is an example of what you should see:</P>
<SAMP><P>&gt;runit</P>
<P>Host command: /tools/cadence99/tools/verilog/bin/verilog.exe</P>
<P>Command arguments:</P>
<P>test.v</P>
<P>cpu.v</P>
<P>alu.v</P>
<P>regs.v</P>
<P>idec.v</P>
<P>exp.v</P>
<P>dram.v</P>
<P>pram.v</P>
<P>VERILOG-XL 2.8.p001 log file created Dec 13, 1999 16:09:07</P>
<P>VERILOG-XL 2.8.p001 Dec 13, 1999 16:09:07</P>
<P>[... SNIP all the Verilog informative output ...]</P>
<P>Compiling source file "test.v"</P>
<P>Compiling source file "cpu.v"</P>
<P>Compiling source file "alu.v"</P>
<P>Compiling source file "regs.v"</P>
<P>Compiling source file "idec.v"</P>
<P>Compiling source file "exp.v"</P>
<P>Compiling source file "dram.v"</P>
<P>Compiling source file "pram.v"</P>
<P>Highest level modules:</P>
<P>test</P>
<P>Reading in SIN data for example DDS in EXP.V from sindata.hex</P>
<P>Free-RISC8. Version 1.0</P>
<P>Free-RISC8 1.0. This is the BASIC CONFIDENCE TEST.</P>
<P>Loading program memory with basic.rom</P>
<P>MONITOR_OUTPUT_SIGNATURE: Expected output observed on PORTB: 00</P>
<P>MONITOR_PORTC: Port C changes to: 00</P>
<P>MONITOR_PORTB: Port B changes to: 00</P>
<P>End RESET.</P>
<P>MONITOR_OUTPUT_SIGNATURE: Expected output observed on PORTB: 01</P>
<P>MONITOR_PORTB: Port B changes to: 01</P>
<P>MONITOR_OUTPUT_SIGNATURE: Expected output observed on PORTB: 02</P>
<P>MONITOR_PORTB: Port B changes to: 02</P>
<P>MONITOR_OUTPUT_SIGNATURE: Expected output observed on PORTB: 03</P>
<P>MONITOR_PORTB: Port B changes to: 03</P>
<P>MONITOR_OUTPUT_SIGNATURE: Expected output observed on PORTB: 04</P>
<P>MONITOR_PORTB: Port B changes to: 04</P>
<P>MONITOR_OUTPUT_SIGNATURE: Expected output observed on PORTB: 05</P>
<P>MONITOR_PORTB: Port B changes to: 05</P>
<P>MONITOR_OUTPUT_SIGNATURE: Expected output observed on PORTB: 06</P>
<P>MONITOR_PORTB: Port B changes to: 06</P>
<P>MONITOR_OUTPUT_SIGNATURE: Expected output observed on PORTB: 07</P>
<P>MONITOR_PORTB: Port B changes to: 07</P>
<P>MONITOR_OUTPUT_SIGNATURE: Expected output observed on PORTB: 08</P>
<P>MONITOR_PORTB: Port B changes to: 08</P>
<P>Done monitoring for output signature. 9 Matches, 0 Mismatches.</P>
<P>SUCCESS.</P>
<P>End of simulation signalled. Killing simulation in a moment.</P>
<P>L232 "test.v": $finish at simulation time 2641100</P>
</FONT><PRE>0 simulation events (use +profile or +listcounts option to count)</PRE>
<FONT SIZE=2><P>CPU time: 0.4 secs to compile + 0.1 secs to link + 1.7 secs in simulation</P>
<P>End of VERILOG-XL 2.8.p001 Dec 13, 1999 16:09:10</P>
</SAMP><P>&nbsp;</P>
</FONT><B><FONT FACE="Arial" SIZE=4><P><A NAME="_Toc469736946">3&#9;System Architecture</A></P>
</B></FONT><FONT SIZE=2><P>Click here to see the System Diagram for the RISC8 core </FONT><A HREF="risc8.gif">risc8.gif</A><FONT SIZE=2>. Module boundaries are bolded with the Verilog filename indicated.</P>
<P>The RISC8 is a Harvard Architecture and is binary code compatible with the Microchip 16C57. Instructions are 12-bits wide and the data path is 8-bits wide. There are up to 72 data words and up to 2048 program words. It has an accumulator-based instruction set (33 instructions). The W register is the accumulator. The Program Counter (PC) and two Stack registers allow 2 levels of subroutines (this could be easily expanded). The RISC8 pipelines its Fetch and Execute. The Register File uses a banking scheme and an Indirect Addressing mode. The core’s Register File is implemented as a flip-flop based Register File. The Program memory (PRAM) is a separate memory from the Register File and is outside the core. The PRAM is currently a simple Verilog memory array residing in test.v. The core is synchronous with one clock and has one synchronous reset. It is scan-insertion friendly.</P>
<P>There are many good books and WWW information that detail the 16C57 architecture and instruction set. Please refer to these for more information. One place to start would certinaly be the Microchip site at </FONT><A HREF="http://www.microchip.com/">www.microchip.com</A><FONT SIZE=2>. Other 3<SUP>rd</SUP> party tools and several good exist detailing how code can be written for the RISC8 (e.g. 16C57).</P>
<P>The ALU is very simple and includes the minimal set of 8-bit operations (ADD, SUB, OR, AND, XOR, ROTATE, etc.). The Instruction Decoder is a purely combinatorial look-up table that supplies key control signals. The basic 16C57 I/O Ports exist, but full bi-directional control is not automatically available (this could be implemented if truly desired in a core).</P>
<P>No interrupts are supported in the 16C5X family and are not offered in the RISC8. Instructions execute in one cycle with the exception of branching instructions requiring 2 cycles (when branches are actually taken). An argument often cited for the lack of interrupts is that the fast one-cycle execution and bit test instructions allows for very fast polling, and therefore reduces the need for interrupts.</P>
<P>Little debug is built into the core itself. Off-the-shelf development environments offer very good debugging capabilities including integrated Assemblers, simulator and debuggers with breakpoints, etc. Once a rough cut at the firmware is done in such a tool, then the Verilog simulator and waveform viewers allow further debugging with the core. The test.v module provides some limited debugging such as printing out changes to I/O ports, displaying updates to Register File locations, etc.</P>
<P>Expansion is done through an expansion bus on the main cpu.v module interface. The bus provides a basic address, read, write data in and out set of signals. The module exp.v shows one simple expansion circuit. If several expansion modules must coexist using this bus, then they must work out their own muxing scheme to drive expdin into the core. See the section on ‘Expansion’ for more details.&nbsp;</P>
</FONT><B><FONT FACE="Arial" SIZE=4><P><A NAME="_Toc469736947">4&#9;Compatibility with Microchip 16C57 Devices</A></P>
</B></FONT><FONT SIZE=2><P>The RISC8 can execute binary code compatible with the 16C57. Several flavors of 16C5X exist with different amounts of addressable memory, and different numbers of I/O pins. The Verilog core can be changed to correspond with any number of these I/O combinations or memory combinations.</P>
<P>The following features or characteristic differ:</P></FONT>
<TABLE BORDER CELLSPACING=1 CELLPADDING=7 WIDTH=589>
<TR><TD WIDTH="23%" VALIGN="TOP">
<P ALIGN="CENTER"><B><FONT SIZE=2>Feature</B></FONT></TD>
<TD WIDTH="32%" VALIGN="TOP">
<B><FONT SIZE=2><P ALIGN="CENTER">Microchip 16C57</B></FONT></TD>
<TD WIDTH="45%" VALIGN="TOP">
<B><FONT SIZE=2><P ALIGN="CENTER">RISC8</B></FONT></TD>
</TR>
<TR><TD WIDTH="23%" VALIGN="TOP">
<FONT SIZE=2><P>Oscillator</FONT></TD>
<TD WIDTH="32%" VALIGN="TOP">
<FONT SIZE=2><P>Has several oscillator options.</FONT></TD>
<TD WIDTH="45%" VALIGN="TOP">
<FONT SIZE=2><P>Only has simple, direct clock input.</FONT></TD>
</TR>
<TR><TD WIDTH="23%" VALIGN="TOP">
<FONT SIZE=2><P>Clocking</FONT></TD>
<TD WIDTH="32%" VALIGN="TOP">
<FONT SIZE=2><P>Internally uses a 4-phase clock</FONT></TD>
<TD WIDTH="45%" VALIGN="TOP">
<FONT SIZE=2><P>One phase clock.</FONT></TD>
</TR>
<TR><TD WIDTH="23%" VALIGN="TOP">
<FONT SIZE=2><P>Reset</FONT></TD>
<TD WIDTH="32%" VALIGN="TOP">
<FONT SIZE=2><P>The 16C57 uses an active low MRST and a power-up circuit. Some 16C57s have brownout.</FONT></TD>
<TD WIDTH="45%" VALIGN="TOP">
<FONT SIZE=2><P>Simple active HIGH reset.</FONT></TD>
</TR>
<TR><TD WIDTH="23%" VALIGN="TOP">
<FONT SIZE=2><P>Sleep</FONT></TD>
<TD WIDTH="32%" VALIGN="TOP">
<FONT SIZE=2><P>Has sleep instruction and circuitry.</FONT></TD>
<TD WIDTH="45%" VALIGN="TOP">
<FONT SIZE=2><P>None. Sleep instruction will be ignored.</FONT></TD>
</TR>
<TR><TD WIDTH="23%" VALIGN="TOP">
<FONT SIZE=2><P>Tristatable ports</FONT></TD>
<TD WIDTH="32%" VALIGN="TOP">
<FONT SIZE=2><P>Has bi-directional ports with the TRIS instruction to program direction.</FONT></TD>
<TD WIDTH="45%" VALIGN="TOP">
<FONT SIZE=2><P>No actual tristates on buffers. Must wire as needed. Currently set up with PORTA as input and PORTB and PORTC as outputs. The TRIS instruction DOES actually load a TRISA, TRISB and TRISC registers, but these registers don’t connect to anything at this time. May be used for debug purposes.</FONT></TD>
</TR>
<TR><TD WIDTH="23%" VALIGN="TOP">
<FONT SIZE=2><P>Watchdog Timer</FONT></TD>
<TD WIDTH="32%" VALIGN="TOP">
<FONT SIZE=2><P>WDT circuit</FONT></TD>
<TD WIDTH="45%" VALIGN="TOP">
<FONT SIZE=2><P>None.</FONT></TD>
</TR>
<TR><TD WIDTH="23%" VALIGN="TOP">
<FONT SIZE=2><P>Timer0</FONT></TD>
<TD WIDTH="32%" VALIGN="TOP">
<FONT SIZE=2><P>Free-running or external source</FONT></TD>
<TD WIDTH="45%" VALIGN="TOP">
<FONT SIZE=2><P>Only clocked by internal clock. Uses the 3 prescaler bits in OPTION register.</FONT></TD>
</TR>
<TR><TD WIDTH="23%" VALIGN="TOP">
<FONT SIZE=2><P>OPTION register and instruction</FONT></TD>
<TD WIDTH="32%" VALIGN="TOP">
<FONT SIZE=2><P>16C57 uses it</FONT></TD>
<TD WIDTH="45%" VALIGN="TOP">
<FONT SIZE=2><P>Only the bits associated with TIMER0 do anything.</FONT></TD>
</TR>
</TABLE>

<FONT SIZE=2><P>&nbsp;</P>
</FONT><B><FONT FACE="Arial" SIZE=4><P><A NAME="_Toc469736948">5&#9;Module Hierarchy</A></P>
</B></FONT><FONT SIZE=2><P>The hierarchy is as follows:</P></FONT>
<TABLE BORDER CELLSPACING=1 CELLPADDING=5 WIDTH=571>
<TR><TD WIDTH="31%" VALIGN="TOP" COLSPAN=3>
<P ALIGN="CENTER"><B>Verilog file/module</B></TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="59%" VALIGN="TOP">
<H5>Description</H5></TD>
</TR>
<TR><TD WIDTH="10%" VALIGN="TOP">
<B><P>test.v</B></TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="59%" VALIGN="TOP">
<P>Testbench. Includes the program ROM. <U>NOT</U> synthesizable..</TD>
</TR>
<TR><TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<B><P>cpu.v</B></TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="59%" VALIGN="TOP">
<P>Top-level cpu module. Synthesizable.</TD>
</TR>
<TR><TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<B><P>idec.v</B></TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="59%" VALIGN="TOP">
<DL>
<DT>Instruction Decoder. Synthesizable.</DT>
</DL></TD>
</TR>
<TR><TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<B><P>alu.v</B></TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="59%" VALIGN="TOP">
<P>ALU. Synthesizable.</TD>
</TR>
<TR><TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<B><P>regs.v</B></TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="59%" VALIGN="TOP">
<P>Register File interface. Synthesizable.</TD>
</TR>
<TR><TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<B><P>dram.v</B></TD>
<TD WIDTH="59%" VALIGN="TOP">
<P>Memory model, Synchronous 72x8 RAM. Can be synthesizable if a simpler flip-flop memory is desired.</TD>
</TR>
<TR><TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<B><P>pram.v&#9;</B></TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="59%" VALIGN="TOP">
<P>Memory model, Synchronous 2048x12 RAM. Can be synthesizable if a simpler flip-flop memory is desired.</TD>
</TR>
<TR><TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<B><P>exp.v</B></TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="59%" VALIGN="TOP">
<P>Example expansion module (a DDS for DDS demo).</TD>
</TR>
</TABLE>

<B><FONT FACE="Arial" SIZE=4><P><A NAME="_Toc469736949"></P>
<P>6&#9;Synthesis</A></P>
</B></FONT><FONT SIZE=2><P>Four core modules (cpu, idec, alu and regs) are directly synthesizable. Special consideration is required for the two RAMs. The design should be fully testable using Full Scan, except potentially for the memories. There are no intentional latches or tristates in the design. The main clock is the only clock in the design. The main reset line does not go through any additional gating or logic.</P>
<P>Memories require special consideration. Specific FPGA and ASIC technologies have specific RAM cells and techniques. The pram.v and dram.v modules may be thought of as "wrappers" inside of which the technology specific RAM details are implemented.</P>
<P>The Register File memory is represented in the Verilog lowest-level module, dram.v. This module is a memory model for a synchronous RAM. This module is intended as the default behavioral memory model and includes // synopsys translate_off directives. The module is synthesizable, however, should a flip-flop based Register File be desired. The Register File memory must implement a read/modify/write behavior. Writes should be registered (synchronous) but reads must be immediate (asynchronous). This behavior is required due to instructions that must must read/modify/write file registers within a single instruction, for example;</P>
<P>&#9;incf&#9;12, f&#9;; This instruction increments the file register at location 12</P>
<P>Many FPGA and ASIC technologies provide this type of memory.</P>
<P>The Program memory may be implemented as a ROM if desired, since it is not written to by the RISC8. Alternatively, an ASIC or FPGA implementation may want to implement this as a RAM for booting code. Small programs could actually be implemented as a logic-based CASE statement and synthesized. This is left up to the implementor. The testbench utilizes a simple register array and $readmemh calls load this "memory" from the ".rom" file.</P>
<P>&nbsp;</P>
</FONT><B><FONT FACE="Arial" SIZE=4><P><A NAME="_Toc469736950">7&#9;CPU Module</A></P>
</B></FONT><FONT SIZE=2><P>The CPU module is the top-level synthesizable module. This is where all the special registers are implemented such as the INST, W, STACK1, STACK2 and the PC. Program Flow control is implemented here. All the internal busses and multiplexors are also implemented here. All I/O occurs here. Any special circuitry such as the Timer or custom circuitry is implemented in this module.</P>
<P>The RISC8 has 3 major ways it changes program flow; 1) a GOTO instruction, a 2) CALL subroutine instruction and 3) Conditional SKIP instructions. </P>
<P>GOTO instructions encode the destination address in literal field of the instruction. Subroutines are done in hardware using explicit STACK registers (versus a software stack and Stack Pointer registers). This is partly the result of the Harvard architecture and the strict separation of program and data spaces. Skip instructions are conditional and usually involve a bit test on a register. </P>
<P>Whenever a branch is taken, the Fetch/Execute pipeline must be "stalled". Normally, the next instruction is always being fetched while the current instruction is executed. When a branch is taken, then the upcoming instruction is actually invalid. The RISC8 rectifies this situation by forcing a NOP instruction into the INST register on the instruction following a branch. This same trick is done in the core. The NOP instruction is, conveniently, 0x0000. Forcing a NOP instruction is done by simply anding the output of the INST register with zeros whenever a branch is detected. The core’s internal SKIP signal is asserted whenever a branch is detected and the NOP is to be forced.</P>
<P>Another artifact of the Fetch/Execute pipeline is the reset vector. The reset vector (the first address fetched and executed) is the last address in the code space. The PC is loaded, on reset, with the reset vector (e.g. 0x1FF) and a NOP is forced as the first instruction. In this way, the first address that is actually Fetched is 0x000 (e.g. 0x1FF + 1) where the program must begin. The core may be reset at any time by asserting the reset input for at least one clk edge. </P>
</FONT><B><FONT FACE="Arial" SIZE=4><P><A NAME="_Toc469736951">8&#9;Memory Interfaces</A></P>
</B></FONT><FONT SIZE=2><P>The interface to program memory is straight-forward in terms of the core itself. An 11-bit address is output and a 12-bit data input is expected. This read is synchronous. The program memory (PRAM) itself is modeled in pram.v which is a very simple synchronous ram model. The PRAM is outside the core (inside test.v but outside cpu.v).</P>
<P>The Register File interface is a synchronous interface with clk and reset inputs. Addressing inputs include a 2-bit <B>bank</B> and 5-bit <B>location</B> input. <B>Read</B> and <B>write</B> enable signals are inputs and there are two separate 8-bit data busses for input and output. The regs.v module performs the address logic where some words are mirrored into a common set of addresses. Beneath regs.v is the actual synchronous RAM model in dram.v. This module is similar to pram.v and is a simple synchronous RAM model.</P>
</FONT><B><FONT FACE="Arial" SIZE=4><P><A NAME="_Toc469736952">9&#9;ALU</A></P>
</B></FONT><FONT SIZE=2><P>The ALU is implemented in the alu.v file. The ALU is purely combinatorial. It has 2 8-bit data inputs, A and B as well as a single-bit CON Carry in input. A 4-bit operand input selects the ALU operation. It has an 8-bit data output and a single-bit carry output and also a single-bit zero output. The ALU does not select the appropriate source for its inputs nor does it decide when status flags are updated. This is done at the higher level by the Instruction Decoder and the CPU module.</P>
<P>The ALU supports the following operands.</P></FONT>
<TABLE BORDER CELLSPACING=1 CELLPADDING=7 WIDTH=590>
<TR><TD WIDTH="20%" VALIGN="TOP">
<P ALIGN="CENTER"><B><FONT SIZE=2>ALU Operand Select Code</B></FONT></TD>
<TD WIDTH="13%" VALIGN="TOP">
<B><FONT SIZE=2><P ALIGN="CENTER">Operation</B></FONT></TD>
<TD WIDTH="67%" VALIGN="TOP">
<B><FONT SIZE=2><P ALIGN="CENTER">Description</B></FONT></TD>
</TR>
<TR><TD WIDTH="20%" VALIGN="TOP">
<FONT SIZE=2><P>0000</FONT></TD>
<TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P>ADD</FONT></TD>
<TD WIDTH="67%" VALIGN="TOP">
<FONT SIZE=2><P>A + B (The 16C5X does NOT add with carry input)</FONT></TD>
</TR>
<TR><TD WIDTH="20%" VALIGN="TOP">
<FONT SIZE=2><P>1000</FONT></TD>
<TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P>SUB</FONT></TD>
<TD WIDTH="67%" VALIGN="TOP">
<FONT SIZE=2><P>A - B (The 16C5X does NOT subtract with borrow input)</FONT></TD>
</TR>
<TR><TD WIDTH="20%" VALIGN="TOP">
<FONT SIZE=2><P>0001</FONT></TD>
<TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P>AND</FONT></TD>
<TD WIDTH="67%" VALIGN="TOP">
<FONT SIZE=2><P>A AND B</FONT></TD>
</TR>
<TR><TD WIDTH="20%" VALIGN="TOP">
<FONT SIZE=2><P>0010</FONT></TD>
<TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P>OR</FONT></TD>
<TD WIDTH="67%" VALIGN="TOP">
<FONT SIZE=2><P>A OR B</FONT></TD>
</TR>
<TR><TD WIDTH="20%" VALIGN="TOP">
<FONT SIZE=2><P>0011</FONT></TD>
<TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P>XOR</FONT></TD>
<TD WIDTH="67%" VALIGN="TOP">
<FONT SIZE=2><P>A XOR B</FONT></TD>
</TR>
<TR><TD WIDTH="20%" VALIGN="TOP">
<FONT SIZE=2><P>0100</FONT></TD>
<TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P>COM</FONT></TD>
<TD WIDTH="67%" VALIGN="TOP">
<FONT SIZE=2><P>NOT A</FONT></TD>
</TR>
<TR><TD WIDTH="20%" VALIGN="TOP">
<FONT SIZE=2><P>0101</FONT></TD>
<TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P>ROR</FONT></TD>
<TD WIDTH="67%" VALIGN="TOP">
<FONT SIZE=2><P>{A[0], A[7:1]}</FONT></TD>
</TR>
<TR><TD WIDTH="20%" VALIGN="TOP">
<FONT SIZE=2><P>0110</FONT></TD>
<TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P>ROL</FONT></TD>
<TD WIDTH="67%" VALIGN="TOP">
<FONT SIZE=2><P>{A[6:0], A[7]}</FONT></TD>
</TR>
<TR><TD WIDTH="20%" VALIGN="TOP">
<FONT SIZE=2><P>0111</FONT></TD>
<TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P>SWAP</FONT></TD>
<TD WIDTH="67%" VALIGN="TOP">
<FONT SIZE=2><P>{A[3:0], A[7:4]}</FONT></TD>
</TR>
</TABLE>

<FONT SIZE=2><P ALIGN="CENTER">Figure 4.1 ALU Operations</P>
<P ALIGN="CENTER">Note that an Add with carry instruction is absent. All RISC8 instructions must use this basic set of supported operations.</P>
</FONT><B><FONT FACE="Arial" SIZE=4><P><A NAME="_Toc469736953">10&#9;Instruction Decoder</A></P>
</B></FONT><FONT SIZE=2><P>Instruction Decoding is implemented in the dec.v Verilog module. It is purely combinatorial. It is specifically implemented as a large Verilog <B>casex</B> statement; one or two case clauses per instruction (many instructions are broken into the d=0 and d=1 cases). Its outputs is a set of decodes used for various control purposes described below.</P>
<P>An instruction begins to be executed once it is registered into the INST register. This occurs every cycle, except when a branch is taken (more on this later). The RISC8 has 33 instructions. The Instruction in the INST register is 12-bits wide. Several fields are frequently defined in instructions, including the F, K and B fields. These subfields are created in the core from the original 12 INST register bits. The Instruction Set summary figure from the 16C57 data sheet follows for reference:</P>
<P>&nbsp;</P>
<P>Each instruction implies a particular set of control signals for controlling, ALU source inputs, PC updating, Status register write enables, Register File addresses, etc. These control signals are encoded in one place in the module, idec.v. This module produces 15 control outputs.</P>
<P>The Instruction Decoder controls what goes into the ALU and what operation the ALU performs. The ALU has two input ports; A and B. The A and B inputs are in turn driven by multiplexors which select from either W, SBUS, K or the BD vector for ALUA, or from W, SBUS, K or the literal 00000001. Almost all data that will be written back to the register file goes through the ALU. Frequently, particular ALU operations all the transfer of data. Use these ALU "tricks" allows us to minimize the number of buses in the design. For example, to clear a register, the W register is XORed with itself in order to obtain 00000000. Likewise, another trick is to OR data with itself in order to simply "copy" the data through the ALU.</P>
<P>Status flags such as the Z and C bits (Zero and Carry out) are updated depending on the instruction. For each instruction, an enable signal must be generated. Likewise, enables for writing to the W and the Register File must be generated. Table 5.1 specifies all the Instruction Decoder control signals per instruction. This table is similarly implemented the Instruction Decoder module (idec.v).</P></FONT>
<TABLE BORDER CELLSPACING=1 CELLPADDING=7 WIDTH=607>
<TR><TD WIDTH="17%" VALIGN="TOP">
<P><B><FONT SIZE=1>Instruction</B></FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<B><FONT SIZE=1><P>ALU A Source</B></FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<B><FONT SIZE=1><P>ALU B Source</B></FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<B><FONT SIZE=1><P>ALU Operand</B></FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<B><FONT SIZE=1><P>Output of ALU</B></FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<B><FONT SIZE=1><P>WWE </B></FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<B><FONT SIZE=1><P>FWE</B></FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<B><FONT SIZE=1><P>ZWE</B></FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<B><FONT SIZE=1><P>CWE</B></FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<B><FONT SIZE=1><P>BDPOL</B></FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<I><FONT SIZE=1><P>Byte-Oriented File Register Operations</I></FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="8%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="16%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="8%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="7%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="7%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="7%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>NOP</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>MOVWF</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>OR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>CLRW</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>XOR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>CLRF</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>XOR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>SUBWF (d=0)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>SUB</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F - W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>SUBWF (d=1)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>SUB</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F - W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>DECF (d=0)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>SUB</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F - 1</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>DECF(d=1)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>SUB</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F - 1</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>IORWF (d=0)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>OR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>W | F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>IORWF(d=1)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>OR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>W | F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>ANDWF (d=0)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>AND</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>W &amp; F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>ANDWF(d=1)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>AND</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>W &amp; F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>XORWF (d=0)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>XOR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>W ^ F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>XORWF(d=1)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>XOR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>W ^ F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>ADDWF (d=0)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>ADD</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>W + F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>ADDWF(d=1)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>ADD</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>W + F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>MOVF (d=0)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>OR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>MOVF(d=1)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>OR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>COMF (d=0)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>NOT</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>~F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>COMF(d=1)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>NOT</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>~F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>INCF (d=0)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>ADD</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F + 1</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>INCF(d=1)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>ADD</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F + 1</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>DECFSZ (d=0)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>SUB</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F - 1</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>DECFSZ(d=1)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>SUB</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F - 1</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>RRF (d=0)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>ROR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>{C, F[7:1]}</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>RRF(d=1)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>ROR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>{C, F[7:1]}</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>RLF (d=0)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>ROL</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>{F[6:0], C}</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>RLF(d=1)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>ROL</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>{F[6:0], C}</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>SWAPF (d=0)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>SWAP</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>{F[3:0], F[7:4]}</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>SWAPF(d=1)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>SWAP</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>{F[3:0], F[7:4]}</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>INCFSZ (d=0)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>ADD</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F + 1</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>INCFSZ (d=1)</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>ADD</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F + 1</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<I><FONT SIZE=1><P>Bit-Oriented File Register Operations</I></FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="8%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="16%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="8%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="7%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="7%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="7%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>BCF</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>K</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>BCLR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F &amp; (~(1 &lt;&lt; K))</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>BSF</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>K</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>BSET</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F | ~(1 &lt;&lt; K)</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>BTFSC</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>K</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>BTST</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F &amp; (1 &lt;&lt; K)</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>BTFSS</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>F</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>K</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>BTST</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>F &amp; (1 &lt;&lt; K)</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<I><FONT SIZE=1><P>Literal and Control Operations</I></FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="8%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="16%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="8%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="7%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="7%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="7%" VALIGN="TOP">
<P>&nbsp;</TD>
<TD WIDTH="10%" VALIGN="TOP">
<P>&nbsp;</TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>OPTION</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>OR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>SLEEP</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>CLRWDT</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>TRIS</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>OR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>RETLW</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>K</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>K</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>OR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>K</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>CALL</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>GOTO</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>X</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>MOVLW</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>K</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>K</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>OR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>K</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>IORLW</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>K</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>OR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>K | W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>ANDLW</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>K</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>AND</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>K &amp; W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
<TR><TD WIDTH="17%" VALIGN="TOP">
<FONT SIZE=1><P>XORLW</FONT></TD>
<TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=1><P>W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>K</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>XOR</FONT></TD>
<TD WIDTH="16%" VALIGN="TOP">
<FONT SIZE=1><P>K ^ W</FONT></TD>
<TD WIDTH="8%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>1</FONT></TD>
<TD WIDTH="7%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
<TD WIDTH="10%" VALIGN="TOP">
<FONT SIZE=1><P>0</FONT></TD>
</TR>
</TABLE>

<FONT SIZE=2><P ALIGN="CENTER">Instruction Decoder table look-up</P>
</FONT><B><FONT FACE="Arial" SIZE=4><P><A NAME="_Toc469736954">11&#9;Register File</A></P>
</B></FONT><FONT SIZE=2><P>The Register File is implemented in the Verilog file regs.v. The Register File is somewhat more complicated than the program code memory. The program memory is outside the core, and is implemented as a simple memory. The Register File requires an input write port and an output read port. It is also partitioned into several "banks". These banks are sometimes mapped into one common set of memory words. It is also desirable to "nullify" particular locations which are used for custom peripherals (so as to not waste silicon). The module dreg.v contains all the logic that maps register addresses (which includes banks and offsets) to physical RAM addresses. Beneath this module is the generic memory model (dram.v). Table 6. shows ...</P></FONT>
<TABLE BORDER CELLSPACING=1 CELLPADDING=7 WIDTH=547>
<TR><TD WIDTH="28%" VALIGN="TOP" COLSPAN=2>
<P ALIGN="CENTER"><B><FONT SIZE=2>File Register</B></FONT></TD>
<TD WIDTH="24%" VALIGN="TOP" ROWSPAN=2>
<B><FONT SIZE=2><P ALIGN="CENTER">Final RAM Address</B></FONT></TD>
<TD WIDTH="48%" VALIGN="TOP" ROWSPAN=2>
<B><FONT SIZE=2><P ALIGN="CENTER">Description</B></FONT></TD>
</TR>
<TR><TD WIDTH="13%" VALIGN="TOP">
<B><FONT SIZE=2><P ALIGN="CENTER">FSR[6:5]</B></FONT></TD>
<TD WIDTH="15%" VALIGN="TOP">
<B><FONT SIZE=2><P ALIGN="CENTER">f[4:0]</B></FONT></TD>
</TR>
<TR><TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">00</FONT></TD>
<TD WIDTH="15%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">0x00 – 0x07</FONT></TD>
<TD WIDTH="24%" VALIGN="TOP">
<FONT SIZE=2><P>N/A</FONT></TD>
<TD WIDTH="48%" VALIGN="TOP">
<FONT SIZE=2><P>Special Purpose Registers (8)</FONT></TD>
</TR>
<TR><TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">00</FONT></TD>
<TD WIDTH="15%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">0x08 – 0x0F</FONT></TD>
<TD WIDTH="24%" VALIGN="TOP">
<FONT SIZE=2><P>0x00 – 0x07</FONT></TD>
<TD WIDTH="48%" VALIGN="TOP">
<FONT SIZE=2><P>Common Registers (8)</FONT></TD>
</TR>
<TR><TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">00</FONT></TD>
<TD WIDTH="15%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">0x10 – 0x1F</FONT></TD>
<TD WIDTH="24%" VALIGN="TOP">
<FONT SIZE=2><P>0x08 – 0x17</FONT></TD>
<TD WIDTH="48%" VALIGN="TOP">
<FONT SIZE=2><P>Bank #0 Registers (16)</FONT></TD>
</TR>
<TR><TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">01</FONT></TD>
<TD WIDTH="15%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">0x00 – 0x07</FONT></TD>
<TD WIDTH="24%" VALIGN="TOP">
<FONT SIZE=2><P>N/A</FONT></TD>
<TD WIDTH="48%" VALIGN="TOP">
<FONT SIZE=2><P>Special Purpose Registers (8 mirrored)</FONT></TD>
</TR>
<TR><TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">01</FONT></TD>
<TD WIDTH="15%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">0x08 – 0x0F</FONT></TD>
<TD WIDTH="24%" VALIGN="TOP">
<FONT SIZE=2><P>0x00 – 0x07</FONT></TD>
<TD WIDTH="48%" VALIGN="TOP">
<FONT SIZE=2><P>Common Registers (8 mirrored)</FONT></TD>
</TR>
<TR><TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">01</FONT></TD>
<TD WIDTH="15%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">0x10 – 0x1F</FONT></TD>
<TD WIDTH="24%" VALIGN="TOP">
<FONT SIZE=2><P>0x18 – 0x2F</FONT></TD>
<TD WIDTH="48%" VALIGN="TOP">
<FONT SIZE=2><P>Bank #1 Registers (16)</FONT></TD>
</TR>
<TR><TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">10</FONT></TD>
<TD WIDTH="15%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">0x00 – 0x07</FONT></TD>
<TD WIDTH="24%" VALIGN="TOP">
<FONT SIZE=2><P>N/A</FONT></TD>
<TD WIDTH="48%" VALIGN="TOP">
<FONT SIZE=2><P>Special Purpose Registers (8 mirrored)</FONT></TD>
</TR>
<TR><TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">10</FONT></TD>
<TD WIDTH="15%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">0x08 – 0x0F</FONT></TD>
<TD WIDTH="24%" VALIGN="TOP">
<FONT SIZE=2><P>0x00 – 0x07</FONT></TD>
<TD WIDTH="48%" VALIGN="TOP">
<FONT SIZE=2><P>Common Registers (8 mirrored)</FONT></TD>
</TR>
<TR><TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">10</FONT></TD>
<TD WIDTH="15%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">0x10 – 0x1F</FONT></TD>
<TD WIDTH="24%" VALIGN="TOP">
<FONT SIZE=2><P>0x30 – 0x47</FONT></TD>
<TD WIDTH="48%" VALIGN="TOP">
<FONT SIZE=2><P>Bank #2 Registers (16 mirrored)</FONT></TD>
</TR>
<TR><TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">11</FONT></TD>
<TD WIDTH="15%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">0x00 – 0x07</FONT></TD>
<TD WIDTH="24%" VALIGN="TOP">
<FONT SIZE=2><P>N/A</FONT></TD>
<TD WIDTH="48%" VALIGN="TOP">
<FONT SIZE=2><P>Special Purpose Registers (8 mirrored)</FONT></TD>
</TR>
<TR><TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">11</FONT></TD>
<TD WIDTH="15%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">0x08 – 0x0F</FONT></TD>
<TD WIDTH="24%" VALIGN="TOP">
<FONT SIZE=2><P>0x00 – 0x07</FONT></TD>
<TD WIDTH="48%" VALIGN="TOP">
<FONT SIZE=2><P>Common Registers (8 mirrored)</FONT></TD>
</TR>
<TR><TD WIDTH="13%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">11</FONT></TD>
<TD WIDTH="15%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="JUSTIFY">0x10 – 0x1F</FONT></TD>
<TD WIDTH="24%" VALIGN="TOP">
<FONT SIZE=2><P>0x48 – 0x5F</FONT></TD>
<TD WIDTH="48%" VALIGN="TOP">
<FONT SIZE=2><P>Bank #3 Registers (16 mirrored)</FONT></TD>
</TR>
</TABLE>

<FONT SIZE=2><P ALIGN="CENTER">&nbsp;</P>
<P>&nbsp;At this time, the Register File contains 70 8-bit data words. The 16C57 has 72 registers. The core has 70 registers available because, at this time, there are 2 locations used for a custom peripheral. As peripherals are added in this way, locations must be taken from the memory space. </P>
<P>The 16C57 devices use a 4-phase clock derived from a external crystal. The RISC8 uses a single clock input and derives a 4 phase synchronous clock. When considering using memory hard cells, this clocking must be considered carefully. The original 16C57 utilized different clock phases to accomplish a Register File read followed by write operation. Likewise, the core uses these phases in order to perform a read and a write within a single instruction "cycle". A Register File location must be readable and writeable during one instruction cycle (e.g. Read/Modify/Write) as described earlier in the Synthesis section.</P>
</FONT><B><FONT FACE="Arial" SIZE=4><P><A NAME="_Toc469736955">12&#9;Firmware Development</A></P>
</B></FONT><FONT SIZE=2><P>An advantage to using the RISC8 over a purely home-brew processor is the wealth of existing development tools. Development is typically done both on the PC and on UNIX. Existing code development tools used to develop code for the 16C57 may be used for the RISC8. It is assumed that the development of working code should be done in one of the many high-quality assembler/debugger tools that are available from a number of 3<SUP>rd</SUP>-party vendors. Once an Intel HEX format binary file is produced, it must be converted into a format acceptable to the Verilog $readmemh format. The included C program, hex2v.c, can do this conversion. The program is a simple command-line program that accepts the Intel HEX filename as an input argument. The output is the $readmemh-compatible data and can be piped to a ".rom" file. The basic.rom and dds.rom files are included in the distribution files to enable immediate running of a simulation.</P>
<P>After the .ROM file is made, the Verilog simulation can be run;</P>
<B><P>&#9;verilog test.v cpu.v regs.v idec.v alu.v exp.v dram.v pram.v</P>
</B><P>The testbench test.v provides some limited debugging capability. Several Verilog ‘monitor’ tasks are available that will display changing register values, etc. It is expected that a waveform viewer such as CWAVES or UNDERTOW will be used for detailed debugging.</P>
<P>C compilers may also be used just as 16C57-compatible Assemblers may be used as long as they can generate the required Intel HEX format output. </P>
</FONT><B><FONT FACE="Arial" SIZE=4><P><A NAME="_Toc469736956">13&#9;Expansion</A></P>
</B></FONT><FONT SIZE=2><P>In this case, ‘Expansion’ refers to the integration of new custom modules to the system. This is done through a special set of signals in the cpu module interface. Any number of addresses in the top of the register address space may be reserved for an expansion circuit. The exp.v module provided reserves 2 such locations. The exp.v module implements a very simple DDS circuit used in the DDS demo.</P>
<P>Note that locations reserved for an expansion circuit must be decoded in the cpu.v module. Look for the block of code that drives the signal, expsel. The case statement should be modified as needed. The initial configuration is that the top 4 locations are reserved for expansion circuits. Note that these top 4 locations CAN NOT be used for normal register storage.</P>
<P>The expansion interface signals are:</P></FONT>
<TABLE BORDER CELLSPACING=1 CELLPADDING=7 WIDTH=517>
<TR><TD WIDTH="20%" VALIGN="TOP">
<P ALIGN="CENTER"><B><FONT SIZE=2>Signal</B></FONT></TD>
<TD WIDTH="80%" VALIGN="TOP">
<B><FONT SIZE=2><P ALIGN="CENTER">Description</B></FONT></TD>
</TR>
<TR><TD WIDTH="20%" VALIGN="TOP">
<FONT SIZE=2><P>expdin[7:0]</FONT></TD>
<TD WIDTH="80%" VALIGN="TOP">
<FONT SIZE=2><P>Input back to the RISC8 core. This is 8-bit data from the expansion module(s) to the core. Should be valid when expread is asserted.</FONT></TD>
</TR>
<TR><TD WIDTH="20%" VALIGN="TOP">
<FONT SIZE=2><P>expdout[7:0]</FONT></TD>
<TD WIDTH="80%" VALIGN="TOP">
<FONT SIZE=2><P>Output from the RISC8 core. This is 8-bit data to the expansion module(s) from the core. Is valid when expwrite is asserted. The expansion modules are responsible for decoding expaddr in order to know which expansion address is being written to.</FONT></TD>
</TR>
<TR><TD WIDTH="20%" VALIGN="TOP">
<FONT SIZE=2><P>expaddr[6:0]</FONT></TD>
<TD WIDTH="80%" VALIGN="TOP">
<FONT SIZE=2><P>This is the final data space address for reads or writes. It includes any indirect addressing. NOTE: within the cpu, the signal expsel must be asserted when an expansion location is being addressed versus when an ordinary Register File location is being addressed. The cpu needs to know the difference so that is controls the MUX properly.</FONT></TD>
</TR>
<TR><TD WIDTH="20%" VALIGN="TOP">
<FONT SIZE=2><P>expread</FONT></TD>
<TD WIDTH="80%" VALIGN="TOP">
<FONT SIZE=2><P>Asserted (HIGH) when the RISC8 core is reading from an expansion address.</FONT></TD>
</TR>
<TR><TD WIDTH="20%" VALIGN="TOP">
<FONT SIZE=2><P>expwrite</FONT></TD>
<TD WIDTH="80%" VALIGN="TOP">
<FONT SIZE=2><P>Asserted (HIGH) when the RISC8 core is writing to an expansion address.</FONT></TD>
</TR>
</TABLE>

<FONT SIZE=2><P>Expansion circuits should use clk and reset in the normal way. Accesses are done in one cycle. The test module exp.v illustrates how to interface to the Expansion Bus, and is used in the DDS demo.</P>
</FONT><B><FONT FACE="Arial" SIZE=4><P><A NAME="_Toc469736957">14&#9;Test Programs</A></P>
</B></FONT><FONT SIZE=2><P>Two Assembler programs and HEX files are included in the package. The ‘basic’ program is a simple program that exercises all the RISC8 instructions. The testbench test.v is initially configured to run this test. A second program, DDS, is included that demonstrates a somewhat realistic program that uses the expansion capability.</P>
<P>The BASIC program runs a series of 9 subtests. All tests are self-verifying and output to PORTB a byte code indicating SUCCESS or FAIL. A companion Verilog task in test.v monitors for these codes and, if the BASIC test passes, will report success. The initial configuration of test.v should do this when it is run. See basic.asm for more details. </P>
<P>The DDS program demonstrates a simple program that also uses the exp.v expansion circuit. It will control the DDS circuit and will cause a modulated sin wave on the dds_out pin from the cpu module. If this output is observed with a waveform viewer set to an "Analog" format, the waveform is clearly seen. See dds.asm for more details.</P>
</FONT><B><FONT FACE="Arial" SIZE=4><P><A NAME="_Toc469736958">15&#9;Bugs</A></P>
</B></FONT><FONT SIZE=2><P>Following are some known bugs and deficiencies.</P></FONT>
<TABLE BORDER CELLSPACING=1 CELLPADDING=7 WIDTH=590>
<TR><TD WIDTH="9%" VALIGN="TOP">
<P ALIGN="CENTER"><B><FONT SIZE=2>Item #</B></FONT></TD>
<TD WIDTH="91%" VALIGN="TOP">
<B><FONT SIZE=2><P>Description</B></FONT></TD>
</TR>
<TR><TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="CENTER">1</FONT></TD>
<TD WIDTH="91%" VALIGN="TOP">
<FONT SIZE=2><P>The DC bit in STATUS is unimplemented and won’t work.</FONT></TD>
</TR>
<TR><TD WIDTH="9%" VALIGN="TOP">
<FONT SIZE=2><P ALIGN="CENTER">2</FONT></TD>
<TD WIDTH="91%" VALIGN="TOP">
<FONT SIZE=2><P>TRIS only seems to update the TRIS register, but doesn’t affect ports.</FONT></TD>
</TR>
</TABLE>

</BODY>
</HTML>
