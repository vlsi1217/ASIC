//------------------------------------------------
// imem.v
// David Harris David_Harris at hmc dot edu 3 November 2005
// Carl Nygaard carlpny at gmail dot com 2007
// Thomas W. Barr tbarr at cs dot hmc dot edu 2007
// Matt Totino mtotino at hmc.edu 2007
// Nathaniel Pinckney npinckney at gmail dot com 2007
//
// Harvey Mudd College
//
// Instruction memory used by MIPS processors
//------------------------------------------------
//
// Assumes big endian

`timescale 1 ns / 1 ps

// To become the actual external memory system.             
module extmem(input ph1, ph2,reset,
               input [12:0] adr,
               inout [31:0] data,
               input [3:0] byteen,
               input rwb, en,
               output done);

  // 0x200 = 2^10 = 1024
  reg  [31:0] RAM[8191:0];
  wire [1:0] state;
  reg [1:0] nextstate;
  wire [7:0] byte1, byte2, byte3, byte4;
  
  assign byte1 = byteen[0] ?  data[7:0] : RAM[adr][7:0];
  assign byte2 = byteen[1] ?  data[15:8] : RAM[adr][15:8];
  assign byte3 = byteen[2] ?  data[23:16] : RAM[adr][23:16];
  assign byte4 = byteen[3] ?  data[31:24] : RAM[adr][31:24];

  initial
    begin
      $readmemh("testing/test_000.dat",RAM);
      #5000;
      $readmemh("testing/test_001.dat",RAM);
      #5000;
      $readmemh("testing/test_002.dat",RAM);
      #5000;
      $readmemh("testing/test_003.dat",RAM);
      #5000;
      $readmemh("testing/test_004.dat",RAM);
      #5000;
      $readmemh("testing/test_005.dat",RAM);
      #5000;
      $readmemh("testing/test_006.dat",RAM);
      #5000;
      $readmemh("testing/test_007.dat",RAM);
      #5000;
      $readmemh("testing/test_008.dat",RAM);
      #5000;
      $readmemh("testing/test_009.dat",RAM);
      #5000;
      $readmemh("testing/test_010.dat",RAM);
      #5000;
      $readmemh("testing/test_011.dat",RAM);
      #5000;
      $readmemh("testing/test_012.dat",RAM);  // Occurs at 60 us
      #15000;
      $readmemh("testing/test_013.dat",RAM);
      #5000;
      $readmemh("testing/test_014.dat",RAM);
      #5000;
      $readmemh("testing/test_015.dat",RAM);
      #5000;
      $readmemh("testing/test_016.dat",RAM);  // Occurs at 90us
      #15000;
      $readmemh("testing/test_017.dat",RAM);  // Occurs at 105us
      #250000;
      $readmemh("testing/test_018.dat",RAM);
      #5000;
      $readmemh("testing/test_019.dat",RAM);
      #5000;
      $readmemh("testing/test_020.dat",RAM);
      #5000;
      $readmemh("testing/test_021.dat",RAM);
      #5000;
      $readmemh("testing/test_022.dat",RAM);
      #5000;
      $readmemh("testing/test_023.dat",RAM);
      #5000;
      $readmemh("testing/test_024.dat",RAM);
      #5000;
      $readmemh("testing/test_025.dat",RAM);
      #5000;
      $readmemh("testing/test_026.dat",RAM);  // Occurs at 395us
      #15000;
    end

    assign data = (rwb) ? RAM[adr] : 32'bz;
    //assign done = state[1];
    assign done = 1'b1;
    
    flopr #(2) fstate(ph1, ph2,reset,nextstate,state);

    always @(*)
    case(state)
        2'b00: if(en) nextstate <= 2'b01;
               else nextstate <= 2'b00;
        2'b01: if(en) nextstate <= 2'b10;
               else nextstate <= 2'b00;
        default: nextstate <= 2'b00;
    endcase
    
    always @(posedge ph1)
      if(~rwb) begin
          RAM[adr] <= {byte4, byte3, byte2, byte1};
      end
endmodule

