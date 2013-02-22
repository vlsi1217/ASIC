//------------------------------------------------
// mipssingle.v
// David_Harris@hmc.edu 23 October 2005
// Single-cycle MIPS processor
//------------------------------------------------

// single-cycle MIPS processor
module mips(input         clk, reset,
            output [31:0] pc,
            input  [31:0] instr,
            output        memwrite,
            output [31:0] aluout, writedata,
            input  [31:0] readdata);

  wire        memtoreg, branch,
              alusrc, regdst, regwrite, jump;
  wire [2:0]  alucontrol;

  controller c(instr[31:26], instr[5:0],
               memtoreg, memwrite, branch,
               alusrc, regdst, regwrite, jump,
               alucontrol);
  datapath dp(clk, reset, memtoreg, branch,
              alusrc, regdst, regwrite, jump,
              alucontrol,
              pc, instr,
              aluout, writedata, readdata);
endmodule

module controller(input  [5:0] op, funct,
                  output       memtoreg, memwrite,
                  output       branch, alusrc,
                  output       regdst, regwrite,
                  output       jump,
                  output [2:0] alucontrol);

  wire [1:0] aluop;

  maindec md(op, memtoreg, memwrite, branch,
             alusrc, regdst, regwrite, jump,
             aluop);
  aludec  ad(funct, aluop, alucontrol);
endmodule

module maindec(input  [5:0] op,
               output       memtoreg, memwrite,
               output       branch, alusrc,
               output       regdst, regwrite,
               output       jump,
               output [1:0] aluop);

  reg [8:0] controls;

  assign {regwrite, regdst, alusrc,
          branch, memwrite,
          memtoreg, jump, aluop} = controls;

  always @( * )
    case(op)
      6'b000000: controls <= 9'b110000010; //Rtyp
      6'b100011: controls <= 9'b101001000; //LW
      6'b101011: controls <= 9'b001010000; //SW
      6'b000100: controls <= 9'b000100001; //BEQ
      6'b001000: controls <= 9'b101000000; //ADDI
      6'b000010: controls <= 9'b000000100; //J
      default:   controls <= 9'bxxxxxxxxx; //???
    endcase
endmodule

module aludec(input      [5:0] funct,
              input      [1:0] aluop,
              output reg [2:0] alucontrol);

  always @( * )
    case(aluop)
      2'b00: alucontrol <= 3'b010;  // add
      2'b01: alucontrol <= 3'b110;  // sub
      default: case(funct)          // RTYPE
          6'b100000: alucontrol <= 3'b010; // ADD
          6'b100010: alucontrol <= 3'b110; // SUB
          6'b100100: alucontrol <= 3'b000; // AND
          6'b100101: alucontrol <= 3'b001; // OR
          6'b101010: alucontrol <= 3'b111; // SLT
          default:   alucontrol <= 3'bxxx; // ???
        endcase
    endcase
endmodule

module datapath(input         clk, reset,
                input         memtoreg, branch,
                input         alusrc, regdst,
                input         regwrite, jump,
                input  [2:0]  alucontrol,
                output [31:0] pc,
                input  [31:0] instr,
                output [31:0] aluout, writedata,
                input  [31:0] readdata);

  wire [4:0]  writereg;
  wire        zero, pcsrc;
  wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
  wire [31:0] pcjump;
  wire [31:0] immext, immextsh;
  wire [31:0] srca, srcb;
  wire [31:0] result;

  // next PC logic
  assign pcsrc = branch & zero;
  assign pcjump = {pcplus4[31:28], instr[25:0], 2'b00};

  flopr #(32) pcreg(clk, reset, pcnext, pc);
  adder       pcadd1(pc, 32'b100, pcplus4);
  sl2         immsh(immext, immextsh);
  adder       pcadd2(pcplus4, immextsh, pcbranch);
  mux2 #(32)  pcbrmux(pcplus4, pcbranch, pcsrc,
                      pcnextbr);
  mux2 #(32)  pcmux(pcnextbr, pcjump, jump,
                    pcnext);

  // register file logic
  regfile     rf(clk, regwrite, instr[25:21],
                 instr[20:16], writereg,
                 result, srca, writedata);
  mux2 #(5)   wrmux(instr[20:16], instr[15:11],
                    regdst, writereg);
  mux2 #(32)  resmux(aluout, readdata,
                     memtoreg, result);
  signext     se(instr[15:0], immext);

  // ALU logic
  mux2 #(32)  srcbmux(writedata, immext, alusrc,
                      srcb);
  alu32       alu(srca, srcb, alucontrol,
                  aluout, zero);
endmodule
