//
// Copyright (c) 1999 Thomas Coonan (tcoonan@mindspring.com)
//
//    This source code is free software; you can redistribute it
//    and/or modify it in source code form under the terms of the GNU
//    General Public License as published by the Free Software
//    Foundation; either version 2 of the License, or (at your option)
//    any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program; if not, write to the Free Software
//    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
//
`timescale 1ns / 10ps

module test;

// For 50Mhz, period is 20ns, so set CLKHI to 10 and CLKLO to 10
parameter CLKHI = 10;
parameter CLKLO = 10;

// Define some codes for each instruction opcode.  These have nothing to do
// with the actual encoding of the instructions.  This is for display purposes.
//
parameter NOP	= 1;
parameter MOVWF	= 2;
parameter CLRW	= 3;
parameter CLRF	= 4;
parameter SUBWF	= 5;
parameter DECF	= 6;
parameter IORWF	= 7;
parameter ANDWF	= 8;
parameter XORWF	= 9;
parameter ADDWF	= 10;
parameter MOVF	= 11;
parameter COMF	= 12;
parameter INCF	= 13;
parameter DECFSZ = 14;
parameter RRF	= 15;
parameter RLF	= 16;
parameter SWAPF	= 17;
parameter INCFSZ = 18;
parameter BCF	= 19;
parameter BSF	= 20;
parameter BTFSC	= 21;
parameter BTFSS	= 22;
parameter OPTION = 23;
parameter SLEEP	= 24;
parameter CLRWDT = 25;
parameter TRIS	= 26;
parameter RETLW	= 27;
parameter CALL	= 28;
parameter GOTO	= 29;
parameter MOVLW	= 30;
parameter IORLW	= 31;
parameter ANDLW	= 32;
parameter XORLW	= 33;

// *** Basic Interface to the PICCPU
reg		clk;
reg		reset;

// Declare I/O Port connections
reg  [7:0]	porta; // INPUT
wire [7:0]	portb; // OUTPUT
wire [7:0]	portc; // OUTPUT

// Declare ROM and rom signals
wire [10:0]	pramaddr;
wire [11:0]	pramdata;

// *** Expansion Interface
wire [7:0]	expdin;
wire [7:0]	expdout;
wire [6:0]	expaddr;
wire		expread;
wire		expwrite;

// Debug output ports on the core.  These are just internal signals brought out so
// they can be observed.
//
wire [7:0]	debugw;
wire [10:0]	debugpc;
wire [11:0]	debuginst;
wire [7:0]	debugstatus;
 
// Instantiate one CPU to be tested.
cpu cpu (
   .clk		(clk),
   .reset	(reset),
   .paddr	(pramaddr),
   .pdata	(pramdata),
   .portain	(porta),
   .portbout	(portb),
   .portcout	(portc),
   .expdin	(expdin),
   .expdout	(expdout),
   .expaddr	(expaddr),
   .expread	(expread),
   .expwrite	(expwrite),
   .debugw	(debugw),
   .debugpc	(debugpc),
   .debuginst	(debuginst),
   .debugstatus	(debugstatus)
);

// Instantiate the Program RAM.
pram pram (
   .clk		(clk),
   .address	(pramaddr),
   .we		(1'b0),			// This testbench doesn't allow writing to PRAM
   .din		(12'b000000000000),	// This testbench doesn't allow writing to PRAM
   .dout	(pramdata)
);

// Output of the DDS in the Expansion module (see section on the DDS Demo in docs).
wire [7:0] dds_out;

// Instantiate one PICEXP (Expansion) module.  This one is a DDS circuit.
exp exp(
   .clk		(clk),
   .reset	(reset),
   .expdin	(expdin),
   .expdout	(expdout),
   .expaddr	(expaddr),
   .expread	(expread),
   .expwrite	(expwrite),
   .dds_out	(dds_out)
);

// This is the only initial block in the test module and this is where
// you select what test you want to do.
//
initial begin
   $display ("Free-RISC8.  Version 1.0");
   
   // Just uncomment out the test you want to run!
   
   // ** This is our top-level "Basic Confidence" test.
   basic;
   
   // ** This is the DDS example.  Make sure the DDS circuit is in the Verilog command line.
   //dds_test;
end

// Event should be emitted by any task to kill simulation.  Tasks should
// use this to close files, etc.
//
event ENDSIM;

// Capture some data
task capture_data;
   begin
      $dumpfile ("risc8.vcd");
      $dumpvars (0, test);
      @(ENDSIM);
      $dumpflush;
   end
endtask

// Reset
task reset_pic;
   begin
      reset = 1;
      #200;
      reset = 0;
      $display ("End RESET.");
   end
endtask
  
// Drive the clock input
task drive_clock;
   begin
      clk  = 0;
      forever begin
         #(CLKLO) clk = 1;
         #(CLKHI) clk = 0;
      end
   end
endtask

// *************  BASIC CONFIDENCE Test Tasks **************
//
// BASIC CONFIDENCE Test.
//
// This task will fork off all the other necessary tasks to cause reset, drive the clock, etc. etc.
//
// 
task basic;
   
   integer  num_outputs;
   integer  num_matches;
   integer  num_mismatches;
   
   begin
      $display ("Free-RISC8 1.0.  This is the BASIC CONFIDENCE TEST.");
      #1;
   
      $display ("Loading program memory with %s", "basic.rom");
      $readmemh ("basic.rom", pram.mem);

      fork
         // Capture data
         capture_data;
         
         // Run the clock
         drive_clock;
         
         // Do a reset
         reset_pic;
         
         // Monitor the number of cycles and set an absolute maximum number of cycles.
         monitor_cycles (5000);
         
         // More specific monitors
         //monitor_inst;
         monitor_portb;
         monitor_portc;
         
         // Drive PORTA with a toggling pattern.  This is for one of the subtests.
         //
         basic_drive_porta;
         
         // Monitor the counting pattern on PORTB.  This is our self-checking scheme for the test.
         // 
         begin
            // 
            num_outputs = 9;  // Expect exactly 7 changes on the PORTB (0..6).
            
            // Call the following task which will watch PORTB for the patterns.
            //
            basic_monitor_output_signature (num_outputs, num_matches, num_mismatches);
            
            // See how we did!
            repeat (2) @(posedge clk);
            $display ("Done monitoring for output signature.  %0d Matches, %0d Mismatches.", num_matches, num_mismatches);
            if (num_matches == num_outputs && num_mismatches == 0) begin
               $display ("SUCCESS.");
            end
            else begin
               $display ("Test FAILED!!");
            end
            
            // We are done.  Throw the ENDSIM event.
            ->ENDSIM;
            #0;
            $finish;
         end
         
         // Catch end of simulation event due to max number of cycles or pattern from PIC code.
         begin
            @(ENDSIM);  // Catch the event.
            
            // Got it!
            $display ("End of simulation signalled.  Killing simulation in a moment.");
            #0; // Let anything else see this event...
            $finish;
         end
      join
   end
endtask

// Monitor PORTB for an incrementing pattern.  This is how we are doing our self-checking.
// A good run will count from ZERO up to some number.
//
task basic_monitor_output_signature;
   input   num_outputs;
   output  num_matches;
   output  num_mismatches;
   
   integer  num_outputs;
   integer  num_matches;
   integer  num_mismatches;
   
   integer      i;
   reg [7:0]    expected_output;
   begin
      num_matches    = 0;
      num_mismatches = 0;
      
      expected_output = 8'h00;
      
      i = 0;
      while (i < num_outputs) begin
         // Wait for any change on output port B.
         @(portb);
         #1;  // Wait for a moment for any wiggling on different 
              // bits to seetle out, just in case there's any gate-level going on..
         if (portb == expected_output) begin
            $display ("MONITOR_OUTPUT_SIGNATURE: Expected output observed on PORTB: %h", portb);
            num_matches = num_matches + 1;
         end
         else begin
            $display ("MONITOR_OUTPUT_SIGNATURE: Unexpected output on PORTB: %h", portb);
            num_mismatches = num_mismatches + 1;
         end
            
         expected_output = expected_output + 1;
         i = i + 1;
      end
   end
endtask

task basic_drive_porta;
   begin
      forever begin
         porta = 8'h55;
         repeat (32) @(posedge clk);
         porta = 8'hAA;
         repeat (32) @(posedge clk);
      end
   end
endtask

// *************  DDS Demo Test Tasks **************
//
// DDS Test.
//
// This task will fork off all the other necessary tasks to cause reset, drive the clock, etc. etc.
//
// In a waveform viewer, check out PORTC[1:0] and also check out the 'dds_out' output.
// You should see a modulated sine wave (e.g. FSK).
//
task dds_test;
   
   begin
      $display ("Free-RISC8 1.0.  This is the DDS Demo.");
      #1;
   
      $display ("Loading program memory with %s", "dds.rom");
      $readmemh ("dds.rom", pram.mem);

      fork
         // Capture data
         capture_data;
         
         // Run the clock
         drive_clock;
         
         // Do a reset
         reset_pic;
         
         // Monitor the number of cycles and set an absolute maximum number of cycles.
         monitor_cycles (3000); // <--- this appeared about right for DDS demo to finish all bits
         
         // More specific monitors
         //monitor_inst;
         //monitor_portb;
         //monitor_portc;
         
         // Catch end of simulation event due to max number of cycles or pattern from PIC code.
         begin
            @(ENDSIM);  // Catch the event.
            
            // Got it!
            $display ("End of simulation signalled.  Killing simulation in a moment.");
            #0; // Let anything else see this event...
            $finish;
         end
      join
   end
endtask

// *****************************  Generic Tasks  **************************  //

// CYCLE monitor and end-of-simulation checker.
//
task monitor_cycles;
   input max_cycles;
   
   integer max_cycles;
   integer cycles;
   begin
      cycles = 0;
      fork
         // Count cycles.
         forever begin
            @(posedge clk);
            cycles = cycles + 1;
         end
         
         // Watch for max cycles.  If we detect max cycles then throw our testbench ENDSIM event.
         //
         begin
            wait (cycles == max_cycles);
            $display ("MAXIMUM CYCLES EXCEEDED!");
            ->ENDSIM;
         end
      join
   end
endtask

// Generic Debug Display stuff.
//
task monitor_rom;
   begin
      forever begin
         @(negedge clk);
         $display ("ROM Address = %h, Data = %h", pramaddr, pramdata);
      end
   end
endtask

task monitor_porta;
   reg [7:0] last_porta;
   begin
      forever begin
         @(negedge clk);
         if (last_porta !== porta) begin
            $display ("porta changes to: %h", porta);
            last_porta = porta;
         end
      end
   end         
endtask

task monitor_portb;
   reg [7:0] last_portb;
   begin
      forever begin
         @(negedge clk);
         if (last_portb !== portb) begin
            $display ("MONITOR_PORTB: Port B changes to: %h", portb);
            last_portb = portb;
         end
      end
   end
endtask

task monitor_portc;
   reg [7:0] last_portc;
   begin
      forever begin
         @(negedge clk);
         if (last_portc !== portc) begin
            $display ("MONITOR_PORTC: Port C changes to: %h", portc);
            last_portc = portc;
         end
      end
   end
endtask

task monitor_w;
   reg [7:0] last_w;
   begin
      forever begin
         @(negedge clk);
         if (debugw !== last_w) begin
            $display ("W = %0h", debugw);
         end
         last_w = debugw;
      end
   end
endtask

task monitor_pc;
   begin
      forever begin
         @(negedge clk);
         $display ("PC = %0h", debugpc);
      end
   end
endtask

// Monitor the INST register (e.g. the instruction) and display something
// resembling a disassembler output.  We'll use several helping tasks to
// look up an appopriate mnemonic.
//
task monitor_inst;
   reg [11:0]    last_pc;
   integer       opcode;
   reg [8*8-1:0] mnemonic;
   
   begin
      fork
         // Always keep a copy of the LAST value of the PC.  This is because
         // of our pipelining.  The PC is really one value ahead.  You really
         // want to see the address that corresponds to the instruction you
         // are looking at.
         //
         forever begin
            @(posedge clk);
            last_pc = debugpc;
         end

         begin
            #6;
            forever begin
               @(negedge clk);
               
               // OK.  We have an instruction.  Take this instruction and call some tasks
               // to help us display a pretty output line.  We will look up a nice mnemonic, etc.
               //
               lookup_opcode   (debuginst, opcode);  // Look up a simpler "opcode" number instead of the actual instruction.
               lookup_mnemonic (opcode, mnemonic);   // Look up the ASCII instruction name
               
               // Depending on the specific instruction, we want to print out different stuff.
               // We may need to print out the 'K' field for literal instructions, or the 'f' field
               // for the MOVF types of instruction, or only the address and mnemonic for
               // simple instructions like SLEEP or CLRW.
               //
               if (opcode == CLRW   || 
                   opcode == NOP    || 
                   opcode == CLRWDT ||
                   opcode == OPTION ||
                   opcode == SLEEP) begin
                  // These are instructions with no additional arguments.  Display the PC and MNEMONIC only.
                  //
                  $display ("MONITOR_INST: %h %s", last_pc, mnemonic);
               end
               else if (debuginst[11:10] == 2'b00) begin
                  // These are the instructions with a register address.  Display the 'd' and 'f' fields.
                  //
                  $display ("MONITOR_INST: %h %s %0d(0x%h), %s", 
                     last_pc, mnemonic,
                     debuginst[4:0], debuginst[4:0],
                     (debuginst[5]) ? "f" : "W"
                  );
               end
               else if (debuginst[11:10] == 2'b01) begin
                  // These are the "Bit-Oriented" instructions with a bit reference and register address.  
                  // Display the 'b' and 'f' fields.
                  //
                  $display ("MONITOR_INST: %h %s bit=%d, f=%0d(0x%h)", 
                     last_pc, mnemonic,
                     debuginst[7:5],
                     debuginst[4:0], debuginst[4:0]
                  );
               end
               else if (debuginst[11] == 1'b1) begin
                  // These are the "Literal and Control" instructions with a literal field.  Display the 'k' field.
                  //
                  $display ("MONITOR_INST: %h %s %0d(0x%h)", 
                     last_pc, mnemonic,
                     debuginst[7:0], debuginst[7:0]
                  );
               end
               else begin
                  $display ("MONITOR_INST: --- Unhandled instruction.. %h", debuginst);
               end
            end
         end
      join   
   end
endtask

// Given the actual 12-bit instruction, return the "opcode".  This is just an integer number
// to help us handle printing and such and does NOT correspond to any hardware encoding.
//
task lookup_opcode;
   input inst;
   output opcode;
   
   reg [11:0] inst;
   integer    opcode;
   begin
      casex (inst)
         12'b0000_0000_0000: opcode = NOP;
         12'b0000_001X_XXXX: opcode = MOVWF;
         12'b0000_0100_0000: opcode = CLRW;
         12'b0000_011X_XXXX: opcode = CLRF;
         12'b0000_10XX_XXXX: opcode = SUBWF;
         12'b0000_11XX_XXXX: opcode = DECF;
         12'b0001_00XX_XXXX: opcode = IORWF;
         12'b0001_01XX_XXXX: opcode = ANDWF;
         12'b0001_10XX_XXXX: opcode = XORWF;
         12'b0001_11XX_XXXX: opcode = ADDWF;
         12'b0010_00XX_XXXX: opcode = MOVF;
         12'b0010_01XX_XXXX: opcode = COMF;
         12'b0010_10XX_XXXX: opcode = INCF;
         12'b0010_11XX_XXXX: opcode = DECFSZ;
         12'b0011_00XX_XXXX: opcode = RRF;
         12'b0011_01XX_XXXX: opcode = RLF;
         12'b0011_10XX_XXXX: opcode = SWAPF;
         12'b0011_11XX_XXXX: opcode = INCFSZ;

         // *** Bit-Oriented File Register Operations
         12'b0100_XXXX_XXXX: opcode = BCF;
         12'b0101_XXXX_XXXX: opcode = BSF;
         12'b0110_XXXX_XXXX: opcode = BTFSC;
         12'b0111_XXXX_XXXX: opcode = BTFSS;

         // *** Literal and Control Operations
         12'b0000_0000_0010: opcode = OPTION;
         12'b0000_0000_0011: opcode = SLEEP;
         12'b0000_0000_0100: opcode = CLRWDT;
         12'b0000_0000_0101: opcode = TRIS;
         12'b0000_0000_0110: opcode = TRIS;
         12'b0000_0000_0111: opcode = TRIS;
         12'b1000_XXXX_XXXX: opcode = RETLW;
         12'b1001_XXXX_XXXX: opcode = CALL;
         12'b101X_XXXX_XXXX: opcode = GOTO;
         12'b1100_XXXX_XXXX: opcode = MOVLW;
         12'b1101_XXXX_XXXX: opcode = IORLW;
         12'b1110_XXXX_XXXX: opcode = ANDLW;
         12'b1111_XXXX_XXXX: opcode = XORLW;

         default:            opcode = 0;
      endcase
   end
endtask

// Given the opcode (see task 'lookup_opcode') return the ASCII string for the instruction.
//
task lookup_mnemonic;
   input opcode;
   output mnemonic;
   
   integer opcode;
   reg [8*8-1:0]  mnemonic;
   begin
      case (opcode)
         NOP:		mnemonic = "NOP     ";
         MOVWF: 	mnemonic = "MOVWF   ";
         CLRW:		mnemonic = "CLRW    ";
         CLRF:		mnemonic = "CLRF    ";
         SUBWF:		mnemonic = "SUBWF   ";
         DECF:		mnemonic = "DECF    ";
         IORWF:		mnemonic = "IORWF   ";
         ANDWF:		mnemonic = "ANDWF   ";
         XORWF:		mnemonic = "XORWF   ";
         ADDWF:		mnemonic = "ADDWF   ";
         MOVF:		mnemonic = "MOVF    ";
         COMF:		mnemonic = "COMF    ";
         INCF:		mnemonic = "INCF    ";
         DECFSZ:	mnemonic = "DECFSZ  ";
         RRF:		mnemonic = "RRF     ";
         RLF:		mnemonic = "RLF     ";
         SWAPF:		mnemonic = "SWAPF   ";
         INCFSZ:	mnemonic = "INCFSZ  ";

         // *** Bit-Oriented File Register Operations
         BCF:		mnemonic = "BCF     ";
         BSF:		mnemonic = "BSF     ";
         BTFSC:		mnemonic = "BTFSC   ";
         BTFSS:		mnemonic = "BTFSS   ";

         // *** Literal and Control Operations
         OPTION:	mnemonic = "OPTION  ";
         SLEEP:		mnemonic = "SLEEP   ";
         CLRWDT:	mnemonic = "CLRWDT  ";
         TRIS: 		mnemonic = "TRIS    ";
         RETLW:		mnemonic = "RETLW   ";
         CALL:		mnemonic = "CALL    ";
         GOTO:		mnemonic = "GOTO    ";
         MOVLW:		mnemonic = "MOVLW   ";
         IORLW:		mnemonic = "IORLW   ";
         ANDLW:		mnemonic = "ANDLW   ";
         XORLW:		mnemonic = "XORLW   ";

         default:	mnemonic = "-XXXXXX-";
      endcase
   end
endtask

endmodule

