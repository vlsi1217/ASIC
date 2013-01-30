//------------------------------------------------
// mipspipelined.v
//
// Authors
// David Harris David_Harris at hmc dot edu 3 November 2005
// Carl Nygaard carlpny at gmail dot com 2007
// Thomas W. Barr tbarr at cs dot hmc dot edu 2007
// Matt Totino mtotino at hmc.edu 2007
// Nathaniel Pinckney npinckney at gmail dot com 2007
// Nate Schlossberg sonofernda at gmail dot com 2007
//
// Harvey Mudd College
//
// Pipelined MIPS processor
//
//------------------------------------------------

`timescale 1 ns / 1 ps

module mips(input         ph1, ph2, reset,
            output [31:0] pcF,
            input  [31:0] instrF,
            input  [7:0]  interrupts,
            output        memwriteM, memtoregM, swc,
            output [3:0]  byteenM,
            output [31:0] aluoutM, writedataM,
            input  [31:0] readdataM,
            input         instrackF, dataackM);

  wire [5:0]  opD, functD;
  wire [4:0]  rsD, rtD, rdE;
  wire        regdstE, alusrcE, 
              unsignedD, loadsignedM, rdsrcD, linkD, luiE,
              overflowableE, overflowE,
              memtoregE,  memtoregW, regwriteE, regwriteM, regwriteW,
              byteM, halfwordM,
              aeqzD, aeqbD, agtzD, altzD, mdrunE, branchD, jumpregD,
              bdsE, syscallE, breakE, riE, fpuE,
              adesableE, adelableE, adelthrownE, misalignedhE, misalignedwE;
  wire [2:0]  alushcontrolE;
  wire [1:0]  pcbranchsrcD, aluoutsrcE, pcsrcFD;
  wire        stallD, stallE, stallM, stallW, flushE, flushM;
  wire [31:0] cop0readdataE, writedataW;
  wire [31:0] pcE;
  wire [4:0]  writeregW;
  wire [1:0]  specialregsrcE, hilodisableE;
  wire        hiloaccessD, mdstartE, hilosrcE;
  // Globals
  wire        re, isc, pendingexception, activeexception;

  controller c(/* inputs */
                 /* from off chip */
                 ph1, ph2, reset, 
                 /* from datapath */
                 pendingexception, 
                 opD, functD, rsD, rtD, 
                 stallD, stallE, stallM, stallW,
                 flushE, flushM, 
                 aeqzD, aeqbD, agtzD, altzD, mdrunE,

               /* outputs (All the control signals) */
                 memtoregE, memtoregM, memtoregW, memwriteM, 
                 byteM, halfwordM, branchD,
                 alusrcE, unsignedD, loadsignedM,
                 regdstE, regwriteE, regwriteM, 
                 regwriteW, jumpD, jumpregD, overflowableE,
                 aluoutsrcE, alushcontrolE, linkD, luiE,
                 rdsrcD, pcsrcFD, pcbranchsrcD, cop0writeW, bdsE,
                 syscallE, breakE, riE, fpuE,
                 adesableE, adelableE, halfwordE, rfeE,
                 specialregsrcE, hilodisableE,
                 hiloaccessD, mdstartE, hilosrcE);

  datapath dp(/* inputs */
                /* from off chip */
                ph1, ph2, reset, instrF, 
                /* from cache */
                readdataM, instrackF, dataackM, 
                /* from controller */
                memtoregE, memtoregM, memtoregW, 
                byteM, halfwordM,
                branchD, jumpregD,
                unsignedD, loadsignedM, alusrcE, regdstE, regwriteE, 
                regwriteM, regwriteW, aluoutsrcE, luiE,
                rdsrcD, 
                specialregsrcE, hilodisableE, hiloaccessD, mdstartE, hilosrcE,
                pcsrcFD, pcbranchsrcD, alushcontrolE, 
                /* from coprocessor 0 */
                cop0readdataE, pendingexception, re, 
              /* outputs */
                /* to off chip */
                pcF, aluoutM, 
                /* to cache */
                writedataM, byteenM, 
                /* to controller */
                opD, functD, rsD, rtD, rdE, aeqzD, aeqbD, agtzD, altzD, 
                stallD, stallE, stallM, stallW, flushE, flushM, overflowE,
                mdrunE, 
                /* to coprocessor 0 */
                misalignedhE, misalignedwE, adelthrownE, pcE, 
                writedataW, writeregW, 
                /* to controller and coprocessor 0 */
                activeexception);

  coprocessor0 cop0(/* inputs */
                      /* from off chip */
                      ph1, ph2, reset, interrupts, 
                      /* from coprocessor 0 */
                      cop0writeW, overflowableE, 
                      /* from datapath */
                      rdE, writeregW, writedataW, 
                      overflowE, pcE, bdsE, activeexception,
                      adelthrownE, misalignedhE, misalignedwE,
                      /* from controller */
                      syscallE, breakE, riE, fpuE,
                      adesableE, adelableE, 
                      halfwordE, rfeE, 
                    /* outputs */
                      /* to datapath */
                      cop0readdataE, pendingexception, re, 
                      /* to cache */
                      swc, isc);
endmodule

module controller(input        ph1, ph2, reset, pendingexception,
                  input  [5:0] opD, functD,
                  input  [4:0] rsD, rtD,
                  input        stallD, stallE, stallM, stallW, flushE, flushM,
                  input        aeqzD, aeqbD, agtzD, altzD, mdrunE,
                  output       memtoregE, memtoregM, memtoregW, memwriteM,
                  output       byteM, halfwordM,
                  output       branchD, alusrcE, unsignedD, 
                  output       loadsignedM,
                  output       regdstE, regwriteE, regwriteM, regwriteW,
                  output       jumpD, jumpregD, overflowableE,
                  output [1:0] aluoutsrcE, 
                  output [2:0] alushcontrolE, 
                  output       linkD, luiE,
                  output       rdsrcD, 
                  output [1:0] pcsrcFD, pcbranchsrcD,
                  output       cop0writeW, bdsE,
                  output       syscallE, breakE, riE, fpuE,
                  output       adesableE, adelableE, halfwordE, rfeE,
                  output [1:0] specialregsrcE, hilodisableE,
                  output       hiloaccessD, mdstartE, hilosrcE);

  wire       memtoregD, memwriteD, alusrcD, mainregwrite, luiD, rtypeD,
             regdstD, regwriteD, maindecuseshifterD, maindecregdstD, 
             alushdecoverflowableD, maindecoverflowableD, overflowableD,
             useshifterD, cop0readD, cop0writeD, rfeD,
             loadsignedD, loadsignedE,
             syscallD, breakD, riD, fpuD,
             adesableD, adelableD, 
             mdstartD, hilosrcD,
             hiloreadD, hiloselD;
  wire       byteD, halfwordD, byteE;
  wire [1:0] hilodisablealushD, hilodisablealushE, specialregsrcD, aluoutsrcD;
  wire       ltD, gtD, eqD, brsrcD;
  wire [2:0] alushcontmaindecD, alushcontrolD;
  wire       memwriteE;
  wire       cop0opD, cop0writeE, cop0writeM;
  wire       bdsF, bdsD;

  assign #1 regwriteD = mainregwrite | linkD | cop0readD;
  assign #1 regdstD = maindecregdstD | cop0writeD;
  assign #1 overflowableD = maindecoverflowableD | alushdecoverflowableD;
  assign #1 bdsF = branchD | jumpD;
  // The instruction in register D needs to access/change HI or LO
  assign #1 hiloaccessD = mdstartD | hiloreadD;

  maindec md(opD, memtoregD, memwriteD, byteD, halfwordD, loadsignedD,
             alusrcD, maindecregdstD, mainregwrite, unsignedD, luiD,
             maindecuseshifterD, maindecoverflowableD, alushcontmaindecD,
             rtypeD,
             riD, fpuD, adesableD, adelableD, cop0opD);

  // Decodes most alu, shifter, and multiply/divide instructions
  alushdec  ad(functD, rtypeD, maindecuseshifterD, alushcontmaindecD, 
               useshifterD,
               alushcontrolD, alushdecoverflowableD, syscallD, breakD,
               mdstartD, hilosrcD, hiloreadD, hiloselD, 
               hilodisablealushD);

  // Choose which HI or LO register(s) should be written to
  hilocontrol hiloc(mdrunE, hilodisablealushE, hilodisableE);

  // Decodes instructions for branching
  branchdec bd(opD, rtD, functD, jumpD, branchD, ltD, gtD, eqD, brsrcD, linkD);

  // Decides the actual behavior of branching
  branchcontroller  bc(reset, pendingexception, jumpD, branchD, linkD, 
                       aeqzD, aeqbD, agtzD, altzD, 
                       ltD, gtD, eqD, brsrcD, rdsrcD, pcsrcFD, pcbranchsrcD,
                       jumpregD);
  
  // Decodes a few coprocessor 0 related instructions
  cop0dec c0dec(rsD, functD, cop0opD, cop0readD, cop0writeD, rfeD); 

  // Chooses which component is selected as aluout
  // 2'b00 for alu
  // 2'b01 for shifter
  // 2'b10 for PC+8 (branch/jump & link)
  // 2'b11 for special register
  assign #1 aluoutsrcD = {linkD | cop0readD | hiloreadD,
                          useshifterD | cop0readD | hiloreadD};

  // Choose which special register to use
  // hilosel is high when choosing LO
  // 2'b00 for cop0readD
  // 2'b01 for HI
  // 2'b10 for LO
  assign #1 specialregsrcD = {hiloreadD & hiloselD, hiloreadD & ~hiloselD};


  // pipeline registers
  flopenr #(1) regD(ph1, ph2, reset, ~stallD, {bdsF}, {bdsD});
  flopenrc #(31) regE(ph1, ph2, reset, ~stallE, flushE,
                  {memtoregD, memwriteD, alusrcD, regdstD, regwriteD, 
                  aluoutsrcD, alushcontrolD, loadsignedD, luiD, cop0writeD,
                  byteD, halfwordD, overflowableD, bdsD,
                  syscallD, breakD, riD, fpuD,
                  adesableD, adelableD, 
                  mdstartD, hilosrcD, hiloselD, hilodisablealushD, 
                  specialregsrcD, rfeD}, 
                  {memtoregE, memwriteE, alusrcE, regdstE, regwriteE,  
                  aluoutsrcE, alushcontrolE, loadsignedE, luiE, cop0writeE,
                  byteE, halfwordE, overflowableE, bdsE,
                  syscallE, breakE, riE, fpuE,
                  adesableE, adelableE, 
                  mdstartE, hilosrcE, hiloselE, hilodisablealushE, 
                  specialregsrcE, rfeE});
  flopenrc #(7) regM(ph1, ph2, reset, ~stallM, flushM,
                  {memtoregE, memwriteE, regwriteE, cop0writeE, loadsignedE,
                  byteE, halfwordE},
                  {memtoregM, memwriteM, regwriteM, cop0writeM, loadsignedM,
                  byteM, halfwordM});
  flopenr #(3) regW(ph1, ph2, reset, ~stallW,
                  {memtoregM, regwriteM, cop0writeM},
                  {memtoregW, regwriteW, cop0writeW});
endmodule

module maindec(input  [5:0] op,
               output       memtoreg, memwrite, byte, halfword, loadsignedD,
               output       alusrc,
               output       regdst, regwrite, 
               output       unsignedD, lui, useshift, overflowable,
               output [2:0] alushcontrol, 
               output       rtype, riD, fpuD,
               output       adesableD, adelableD, cop0op);

  reg [20:0] controls;
 
  assign {regwrite, /* regwrite is also enabled by branchdec and cop0dec */
          regdst,   /* regdst is also enabled by cop0dec */ 
          overflowable, /* overflowable is also enabled by alushdec */
          alusrc,
          memwrite,
          memtoreg, byte, halfword, loadsignedD,
          useshift, alushcontrol /* 3 bits */, rtype,
          unsignedD, lui, adesableD, adelableD, fpuD, riD, cop0op} = controls;

  always @ ( * )
    case(op)
      6'b000000: controls <= 21'b110000000010110000000; //R-type
      6'b000001: controls <= 21'b010000000001000000000; //Opcode 1 (branches)
      6'b100000: controls <= 21'b100101101001000000000; //LB (assume big endian)
      6'b100001: controls <= 21'b100101011001000001000; //LH
      6'b100011: controls <= 21'b100101001001000001000; //LW
      6'b100100: controls <= 21'b100101100001001000000; //LBU
      6'b100101: controls <= 21'b100101010001001000000; //LHU
      6'b101000: controls <= 21'b000110100001000000000; //SB
      6'b101001: controls <= 21'b000110010001000010000; //SH
      6'b101011: controls <= 21'b000110000001000010000; //SW
      6'b001000: controls <= 21'b101100000001000000000; //ADDI
      6'b001001: controls <= 21'b100100000001000000000; //ADDIU
      6'b001010: controls <= 21'b100100000011100000000; //SLTI
      6'b001011: controls <= 21'b100100000001100000000; //SLTIU 
      6'b001100: controls <= 21'b100100000000001000000; //ANDI
      6'b001101: controls <= 21'b100100000000101000000; //ORI
      6'b001110: controls <= 21'b100100000010001000000; //XORI
      6'b001111: controls <= 21'b100100000101001100000; //LUI
      6'b000010: controls <= 21'b000000000001000000000; //J
      6'b000011: controls <= 21'b110000000001000000000; //JAL
      6'b000100: controls <= 21'b000000000011000000000; //BEQ
      6'b000101: controls <= 21'b000000000011000000000; //BNE
      6'b000110: controls <= 21'b000000000011000000000; //BLEZ
      6'b000111: controls <= 21'b000000000011000000000; //BGTZ
      6'b010000: controls <= 21'b000000000001000000001; //MFC0, MTC0, RFE
      6'b010001: controls <= 21'b000000000000000000100; //(floating point)
      default:   controls <= 21'bxxxxxxxxxxxxxxxxxxx1x; //??? (throw exception)
    endcase
endmodule

// ALU, Shifter, and multiply/divide decoders
module alushdec(input      [5:0] funct,
                input            rtype, maindecuseshifter, 
                input      [2:0] alushmaincontrol,
                output           useshifter,
                output     [2:0] alushcontrol,
                output           overflowable, syscallD, breakD, 
                                 mdstart, hilosrc, hiloread, hilosel,
                output     [1:0] hilodisable);

  reg [12:0] functcontrol;

  mux2 #(13) alushconmux({9'b0, maindecuseshifter, alushmaincontrol}, 
                         functcontrol, rtype,
                         {overflowable, syscallD, breakD, hiloread, 
                         hilosel, hilodisable, mdstart, hilosrc, useshifter, 
                         alushcontrol});

  always @ ( * )
      case(funct)
          // ALU Ops
          6'b100000: functcontrol <= 13'b1000000000010; // ADD 
          6'b100001: functcontrol <= 13'b0000000000010; // ADDU
          6'b100010: functcontrol <= 13'b1000000000110; // SUB 
          6'b100011: functcontrol <= 13'b0000000000110; // SUBU
          6'b100100: functcontrol <= 13'b0000000000000; // AND
          6'b100101: functcontrol <= 13'b0000000000001; // OR
          6'b100110: functcontrol <= 13'b0000000000100; // XOR
          6'b100111: functcontrol <= 13'b0000000000101; // NOR
          6'b101010: functcontrol <= 13'b0000000000111; // SLT
          6'b101011: functcontrol <= 13'b0000000000011; // SLTU
                                                 
          // Shift Ops                           
          // The lower 3 bits are: {constant, left, rightassociative}
          6'b000000: functcontrol <= 13'b0000000001110; // SLL
          6'b000010: functcontrol <= 13'b0000000001100; // SRL
          6'b000011: functcontrol <= 13'b0000000001101; // SRA
          6'b000100: functcontrol <= 13'b0000000001010; // SLLV
          6'b000110: functcontrol <= 13'b0000000001000; // SRLV
          6'b000111: functcontrol <= 13'b0000000001001; // SRAV
                                                 
          // Branch Ops (These are all don't cares)
                                                 
          // Mult/div/HI/LO Ops                  
          // The lower 3 bits are {dont care, signedop, muldivb}
                                                 
          6'b010000: functcontrol <= 13'b0001000000000; // MFHI
          6'b010001: functcontrol <= 13'b0000010010000; // MTHI
          6'b010010: functcontrol <= 13'b0001100000000; // MFLO
          6'b010011: functcontrol <= 13'b0000001010000; // MTLO
                                                 
          6'b011000: functcontrol <= 13'b0000000100011; // MULT
          6'b011001: functcontrol <= 13'b0000000100001; // MULTU
          6'b011010: functcontrol <= 13'b0000000100010; // DIV
          6'b011011: functcontrol <= 13'b0000000100000; // DIVU
                                               
          // Exceptions                        
          6'b001100: functcontrol <= 13'b0100000000000; // SYSCALL
          6'b001101: functcontrol <= 13'b0010000000000; // BREAK
                                                 
          default:   functcontrol <= 13'b0000000000xxx; // ???
      endcase
endmodule

// Branch decoder
module branchdec(input  [5:0] op,
                 input  [4:0] rt,
                 input  [5:0] funct,
                 output       jump,
                 output       branch,
                 output       lt, gt, eq, src,
                 output       link);

  reg [6:0] controls;

  assign #1 {jump, branch, lt, gt, eq, src, link} = controls;

  always @ ( * )
    case(op)
      6'b000010: controls <= 7'b1011100;      // J
      6'b000011: controls <= 7'b1011101;      // JAL
      6'b000000: // R-type
        case(funct)
          6'b001000: controls <= 7'b1011110;  // JR
          6'b001001: controls <= 7'b1011111;  // JALR
          default:   controls <= 7'b0000000;  // Another R-type, no branching
        endcase
      6'b000001: // Opcode 1
        case(rt)
          5'b00000: controls <= 7'b0110000;   // BLTZ
          5'b00001: controls <= 7'b0101100;   // BGEZ
          5'b10000: controls <= 7'b0110001;   // BLTZAL
          5'b10001: controls <= 7'b0101101;   // BGEZAL
          default:  controls <= 7'bxxxxxxx;   // Unsupported instruction
        endcase
      6'b000100: controls <= 7'b0100110;      // BEQ
      6'b000101: controls <= 7'b0111010;      // BNE
      6'b000110: controls <= 7'b0110100;      // BLEZ
      6'b000111: controls <= 7'b0101000;      // BGTZ
      default:   controls <= 7'b0000000;      // All others, no branching
    endcase
endmodule

module hilocontrol(input        mdrunE,
                   input  [1:0] hilodisablealushE,
                   output [1:0] hilodisableE);

  mux2 #(2) hilodismux(hilodisablealushE, 2'b00, mdrunE, hilodisableE);

endmodule

module cop0dec(input [4:0] rs,
               input [5:0] funct,
               input       cop0op,
               output      cop0read, cop0write, rfe);

  assign #1 cop0read = (cop0op & (rs == 5'b00000));                    // MFC0
  assign #1 cop0write = (cop0op & (rs == 5'b00100));                   // MTC0
  assign #1 rfe = (cop0op & (rs == 5'b10000) & (funct == 6'b010000));  // RFE

endmodule

module datapath(input         ph1, ph2, reset,
                input  [31:0] instrF,
                input  [31:0] readdataM, 
                input         instrackF, dataackM, 
                input         memtoregE, memtoregM, memtoregW, 
                input         byteM, halfwordM,
                input         branchD, jumpregD, unsignedD, loadsignedM,
                input         alusrcE, regdstE,
                input         regwriteE, regwriteM, regwriteW, 
                input  [1:0]  aluoutsrcE, 
                input         luiE,
                input         rdsrcD, 
                input  [1:0]  specialregsrcE, hilodisableE,
                input         hiloaccessD, mdstartE, hilosrcE,
                input  [1:0]  pcsrcFD, pcbranchsrcD,
                input  [2:0]  alushcontrolE,
                input  [31:0] cop0readdataE,
                input         pendingexception, re,
                output [31:0] pcF,
                output [31:0] aluoutM, writedata2M,
                output [3:0]  byteenM, 
                output [5:0]  opD, functD,
                output [4:0]  rsD, rtD, rdE,
                output        aeqzD, aeqbD, agtzD, altzD,
                output        stallD, stallE, stallM, stallW, 
                output        flushE, flushM, overflowE,
                output        mdrunE, 
                output        misalignedhE, misalignedwE, adelthrownE,
                output [31:0] pcE,
                output [31:0] writedataW,
                output [4:0]  writeregW,
                output        activeexception);

  wire        forwardaD, forwardbD;
  wire [1:0]  forwardaE, forwardbE;
  wire        stallF, flushD;
  
 
  wire [31:0] writedataM;
  wire [31:0] readdata2M;
  wire [31:0] pcnextbrFD, pcplus4D, pcplus4F;
  wire [31:0] signimmD, signimmE;
  wire [31:0] srca2D, srcaE;
  wire [31:0] srcb2D, srcbE, srcb2E;
  wire [31:0] instrD;
  wire [31:0] aluoutE, aluoutW;
  wire [31:0] readdataW, resultW;
  wire [31:0] pcD;
  wire        adelthrownF, adelthrownD;
  wire        rsonD, rtonD, rsonE, rtonE;
  wire        rseqwrDM, rteqwrDM, rseqwrEM, rseqwrEW;
  wire        rteqwrEM, rteqwrEW, rteqrsED, rteqrtED;
  wire        rseqwrDE, rteqwrDE;
  wire [4:0]  rdD;
  
  fivebitdp fivebitdp(//inputs
                      ph1, ph2, reset,
                      stallE, stallM, stallW, flushE, flushM,
                      rsD, rtD, rdD, rdsrcD, regdstE,
                      //outputs
                      rsonD, rtonD, rsonE, rtonE,
                      rseqwrDM, rteqwrDM, rseqwrEM, rseqwrEW,
                      rteqwrEM, rteqwrEW, rteqrsED, rteqrtED,
                      rseqwrDE, rteqwrDE,
                      rdE, writeregW);
  
  // hazard detection
  hazard    h(// inputs
              ph1, ph2, reset,
                  // comparison inputs
                  rsonD, rtonD, rsonE, rtonE,
                  rseqwrDM, rteqwrDM, rseqwrEM, rseqwrEW,
                  rteqwrEM, rteqwrEW, rteqrsED, rteqrtED,
                  rseqwrDE, rteqwrDE, 
              regwriteE, regwriteM, regwriteW, 
              memtoregE, memtoregM, branchD, jumpregD,
              instrackF, dataackM, pendingexception, hiloaccessD, mdrunE,
              // outputs
              forwardaD, forwardbD, forwardaE, forwardbE,
              stallF, stallD, stallE, stallM, stallW, flushD, flushE, flushM,
              activeexception);


  fetchstage fetchstage(// inputs 
                        ph1, ph2, reset, stallF, pcsrcFD, pcnextbrFD,
                        // outputs
                        adelthrownF, pcF, pcplus4F);

  // Fetch to decode register
  flopenr #(32) r1D(ph1, ph2, reset, ~stallD, pcF, pcD);
  flopenrc #(32) r2D(ph1, ph2, reset, ~stallD, flushD, instrF, instrD);
  flopenrc #(1) r3D(ph1, ph2, reset, ~stallD, flushD, adelthrownF, adelthrownD);
  flopenr #(32) r4D(ph1, ph2, reset, ~stallD, pcplus4F, pcplus4D);

  decodestage decodestage(// inputs
                          ph1, ph2, unsignedD, 
                          instrD, pcplus4D, resultW, 
                          aluoutM, regwriteW, writeregW, forwardaD, forwardbD,
                          pcbranchsrcD,
                          // outputs
                          opD, functD, rsD, rtD, 
                          srca2D, srcb2D, signimmD, pcnextbrFD,
                          aeqbD, aeqzD, agtzD, altzD, rdD);

  // Decode to Execute stage register
  flopenrc #(32) r1E(ph1, ph2, reset, ~stallE, flushE, srca2D, srcaE); 
  flopenrc #(32) r2E(ph1, ph2, reset, ~stallE, flushE, srcb2D, srcbE); 
  flopenrc #(32) r3E(ph1, ph2, reset, ~stallE, flushE, signimmD, signimmE);
  flopenrc #(32) r9E(ph1, ph2, reset, ~stallE, flushE, pcD, pcE);
  flopenrc #(1)  r10E(ph1, ph2, reset, ~stallE, flushE, adelthrownD, 
      adelthrownE);
  
  executestage executestage(// inputs
                            ph1, ph2, reset, alusrcE, 
                            luiE, mdstartE, hilosrcE,
                            hilodisableE, specialregsrcE, aluoutsrcE,
                            forwardaE, forwardbE, 
                            alushcontrolE, 
                            srcaE, srcbE, resultW, aluoutM, signimmE, pcE,
                            cop0readdataE, 
                            // outputs
                            srcb2E, aluoutE, overflowE, misalignedwE, 
                            misalignedhE, mdrunE);

  // Execute to Memory stage register
  flopenrc #(32) r1M(ph1, ph2, reset, ~stallM, flushM, srcb2E, writedataM);
  flopenrc #(32) r2M(ph1, ph2, reset, ~stallM, flushM, aluoutE, aluoutM);
  

  memorystage memorystage(// inputs
                          byteM, halfwordM, loadsignedM, 
                          writedataM, readdataM, aluoutM, 
                          // outputs
                          writedata2M, readdata2M, byteenM,re);

  // Writeback stage
  flopenr #(32) r1W(ph1, ph2, reset, ~stallW, aluoutM, aluoutW);
  flopenr #(32) r2W(ph1, ph2, reset, ~stallW, readdata2M, readdataW);
  flopenr #(32) r4W(ph1, ph2, reset, ~stallW, writedataM, writedataW);

  mux2 #(32)  resmux(aluoutW, readdataW, memtoregW, resultW);

endmodule

module fetchstage(input             ph1, ph2, reset, stallF,
                  input  [1:0]      pcsrcFD,
                  input  [31:0]     pcnextbrFD,
                  output            adelthrownF,
                  output [31:0]     pcF, 
                  // Next Stage Outputs
                  output [31:0]     pcplus4F);

  wire [31:0] pcnextF;

  parameter RESETVECTORUNCACHED = 32'hbfc00000;
  parameter EXCEPTIONVECTORUNCACHED = 32'hbfc00100;
  // Cached exceptions are NOT supported, but if they were, this address could
  // be used as the target
  parameter EXCEPTIONVECTORCACHED = 32'h9fc00100;

  // next PC logic (operates in fetch and decode)
  mux4 #(32)  pcmux(RESETVECTORUNCACHED, EXCEPTIONVECTORUNCACHED,
                    pcplus4F, pcnextbrFD, pcsrcFD, pcnextF); 

  // Fetch stage logic
  flopen #(32) pcreg(ph1, ph2, ~stallF, pcnextF, pcF);
  adder       pcadd1(pcF, 32'b100, pcplus4F);

  // misaligned fetch error detection logic
  assign     adelthrownF = pcF[0] | pcF[1];

endmodule

module decodestage(input         ph1, ph2, unsignedD,
                   input  [31:0] instrD, pcplus4D, resultW, aluoutM, 
                   input         regwriteW, 
                   input  [4:0]  writeregW,
                   input         forwardaD, forwardbD,
                   input  [1:0]  pcbranchsrcD,
                   output [5:0]  opD, functD,
                   output [4:0]  rsD, rtD,
                   output [31:0] srca2D, srcb2D, signimmD, pcnextbrFD,
                   output        aeqbD, aeqzD, agtzD, altzD,
                         output [4:0]  rdD);

  wire [31:0] srcaD, srcbD, branchtargetD;
  

  // Instruction breakdown
  assign opD = instrD[31:26];
  assign functD = instrD[5:0];
  assign rsD = instrD[25:21];
  assign rtD = instrD[20:16];
  assign rdD = instrD[15:11];

  // register file (operates in decode and writeback)
  regfile     rf(ph1, ph2, regwriteW, rsD, rtD, writeregW,
                 resultW, srcaD, srcbD);

  // forward register file values in place of its outputs when necessary
  mux2 #(32)  forwardadmux(srcaD, aluoutM, forwardaD, srca2D);
  mux2 #(32)  forwardbdmux(srcbD, aluoutM, forwardbD, srcb2D);

  // branch selection
  signext #(16,32) se(instrD[15:0], ~unsignedD, signimmD);
  adder btadd(pcplus4D, {signimmD[29:0], 2'b00}, branchtargetD);

  // tell the controller the results of register-register and register-zero
  // comparisons so it can pick pcbranchsrcD
  eqcmp aeqbcmp(srca2D, srcb2D, aeqbD);
  eqzerocmp aeqzcmp(srca2D, aeqzD);
  gtzerocmp agtzcmp(srca2D, agtzD);
  ltzerocmp altzcmp(srca2D, altzD);

  // pick off the next branch location (the fetch stage picks between
  // pcnextbrFD, pcplus4FD, and the reset or exception addresses)
  mux3 #(32)  pcbranchmux(branchtargetD, {pcplus4D[31:28], instrD[25:0], 2'b00},
                          srca2D, pcbranchsrcD, pcnextbrFD);

  // some linking instructions only link to register $31, so we must be able to
  // switch the destination registerd between rdD and 31
  // fivebitdp

endmodule

module executestage(input         ph1, ph2, reset, alusrcE, 
                                  luiE, mdstartE, hilosrcE, 
                    input  [1:0]  hilodisableE, specialregsrcE, aluoutsrcE,
                                  forwardaE, forwardbE, 
                    input  [2:0]  alushcontrolE, 
                    
                    input  [31:0] srcaE, srcbE, resultW, aluoutM, signimmE, pcE,
                                  cop0readdataE, 
                    output [31:0] srcb2E, aluoutE,
                    
                    output        overflowE, misalignedwE, misalignedhE, 
                                  mdrunE);

  wire [31:0] srca2E, srcb3E;
  wire [31:0] aluresultE, shiftresultE, pcplus8E, specialregE, 
              hiE, loE;

  // when it becomes available, soon-to-be-in-the-register-file data is
  // forwarded from the Memory and Writeback stages
  mux3 #(32)  forwardaemux(srcaE, resultW, aluoutM, forwardaE, srca2E);
  mux3 #(32)  forwardbemux(srcbE, resultW, aluoutM, forwardbE, srcb2E);

  // immediate operations take in the sign-extended immediate value from the
  // decode stage
  mux2 #(32)  srcbmux(srcb2E, signimmE, alusrcE, srcb3E);

  alu         alu(srca2E, srcb3E, alushcontrolE, aluresultE, overflowE);
  shifter     shifter(srca2E, srcb3E, alushcontrolE, luiE, signimmE[10:6],
                      shiftresultE);

  // Multiply and divide operate separately from the main processor. mdstartE
  // launches the unit into action, driving mdrunE high.  Once it finishes, 
  // mdrunE will go low.  While mdrunE is high, the hazard unit stalls any
  // other instructions that access/use the mdunit.
  mdunit md(ph1, ph2, reset,
            srca2E, srcb3E, alushcontrolE, mdstartE, hilosrcE, hilodisableE,
            hiE, loE, mdrunE);

  // pcplus8E is needed for linking operations (the return address is one past
  // the operation executed in the branch delay slot)
  adder       pcadd2(pcE, 32'b1000, pcplus8E);

  // specialregE is choosen among several low latency registers coming from the
  // multdiv unit and coprocessor 0
  mux3 #(32)  specialregmux(cop0readdataE, hiE, loE, specialregsrcE, 
                            specialregE);

  // the grand-daddy mux that selects aluoutE -- the computational result of the
  // given instruction
  mux4 #(32)  aluoutmux(aluresultE, shiftresultE, pcplus8E, specialregE, 
                        aluoutsrcE, aluoutE);

  // all exceptions must be thrown by the end of the Executate stage, so we look
  // for memory alighment problems with the Memory stage one step ahead of time.
  assign misalignedwE = aluoutE[1] | aluoutE[0];
  assign misalignedhE = aluoutE[0];

  // pick which register results may be saved to
  // fivebitdp

endmodule

module memorystage(input         byteM, halfwordM, loadsignedM, 
                   input  [31:0] writedataM, readdataM, aluoutM, 
                   output [31:0] writedata2M, readdata2M, 
                   output [3:0]  byteenM,
                   input re);

  wire [3:0]  bytebyteenM, halfwordbyteenM;
  wire [7:0]  rbyteM;
  wire [15:0] rhalfwordM;
  wire [31:0] rbyteextM, rhalfwordextM; 
  wire [1:0] aluoutreM;

  // the lower 2 bits of the address are complemented when in reverse endian 
  // mode (reverse endian means big endian in this case)
  assign #1 aluoutreM = {2{re}} ^ aluoutM[1:0];

  // We can be writing a byte, halfword (two bytes) or word (4 bytes).
  // byteen masks which bytes will be written two, so we can just repeat each of
  // the desired output values.  Whichever location is enabled by byteen will
  // get the values.
  mux3 #(32) wdatamux(writedataM, {2{writedataM[15:0]}}, {4{writedataM[7:0]}},
                      {byteM, halfwordM}, writedata2M);

  // Byte encoding logic for store operations -- Determine the byte mask,
  // byteenM, based on the address and whether we are doing a byte, halfword, or
  // word-sized operation.  Misaligned addresses will have been caught as an
  // exception in the execute stage.
  dec2 bytebyteendec(aluoutreM[1:0], bytebyteenM);
  mux2 #(4) halfwbyteendec(4'b0011, 4'b1100, aluoutreM[1], halfwordbyteenM);
  mux3 #(4) byteenmux(4'b1111, halfwordbyteenM, bytebyteenM, 
                      {byteM, halfwordM}, byteenM);

  // load conversions -- upon reading a word from cache, we must grab the
  // appropriate portion to store to a register.

  // in the case of a load byte, we mux between the 4 available bytes
  mux4 #(8) rbytemux(readdataM[7:0], readdataM[15:8], readdataM[23:16], 
                        readdataM[31:24], aluoutreM[1:0], rbyteM);
  // a word has two halfwords
  mux2 #(16) rhalfwordmux(readdataM[15:0], readdataM[31:16], aluoutreM[1],
                          rhalfwordM);

  // if the load is signed, we must sign-extend the results
  signext #(8, 32) rbytesignext(rbyteM, loadsignedM, rbyteextM);
  signext #(16, 32) rhalfwsignext(rhalfwordM, loadsignedM, rhalfwordextM);

  mux3 #(32) readmux(readdataM, rhalfwordextM, rbyteextM, {byteM, halfwordM},
                     readdata2M);
endmodule

module coprocessor0(input             ph1, ph2, reset,
                    input      [7:0]  interrupts,
                    input             cop0writeW, overflowableE, 
                    input      [4:0]  readaddress, writeaddress,
                    input      [31:0] writecop0W,
                    input             overflowE,
                    input      [31:0] pcE,
                    input             bdsE, activeexception, adelthrownE,
                    input             misalignedhE, misalignedwE,
                    input             syscallE, breakE, riE, fpuE,
                    input             adesableE, adelableE, halfwordE, rfeE,
                    output reg [31:0] cop0readdataE, 
                    output            pendingexception, 
                    output            re, swc, isc);   // isolate cache

  wire [31:0] statusreg, causereg, epc;
  wire [7:0]  im;    // Interupt mask
  wire [4:0]  exccode;

  exceptionunit excu(ph1, ph2, reset, overflowableE, overflowE, 
                     syscallE, breakE, riE, fpuE,
                     adesableE, adelableE, adelthrownE, 
                     misalignedhE, misalignedwE,
                     halfwordE, iec, interrupts, im,
                     pendingexception, exccode);
                     
  epcunit       epcu(ph1, ph2, activeexception, bdsE, pcE, epc);
 
  statusregunit sr(ph1, ph2, reset, cop0writeW & (writeaddress == 5'b01100), 
                   activeexception, writecop0W, rfeE, statusreg, 
                   re, im, swc, isc, iec);
  causeregunit  cr(ph1, ph2, bdsE, interrupts, exccode, 
                   activeexception, /* write enable determined by exception */
                   causereg);
   
  // All cop0 registers can be copied into the register file
  always @ ( * )
    case(readaddress)
      5'b01100: cop0readdataE <= statusreg;
      5'b01101: cop0readdataE <= causereg;
      5'b01110: cop0readdataE <= epc;
      default:  cop0readdataE <= 32'hxxxxxxxx;
    endcase
endmodule 

module exceptionunit(input            ph1, ph2, reset,
                     input            overflowableE, overflowE,
                     input            syscallE, breakE, riE, fpuE,
                     input            adesableE, adelableE, adelthrownE, 
                     input            misalignedhE, misalignedwE, halfwordE,
                     input            iec, 
                     input [7:0]      interrupts, im,
                     output           pendingexception,
                     output reg [4:0] exccode);

    wire       overflow, adel, ades, interrupt;
    wire  [2:0] priencout;

    // Note that all exceptions happen during the exectute stage, and the final
    // say in whether an exception is active is set by the hazard unit as
    // "activeexception."  Also, an exception happens in the same cycle as it is
    // occurs, meaning the processor does not use a clock cycle to execute the
    // exception, rather it happens all at once (this is slow).
   
    // Various possible exception conditions
    assign overflow = overflowableE & overflowE;
    assign adel = 
       (adelableE & (!halfwordE & (misalignedhE | misalignedwE) | misalignedhE))
        | adelthrownE;
    assign ades = 
       adesableE & (!halfwordE & (misalignedhE | misalignedwE) | misalignedhE);
    assign interrupt = iec & ( |(im & interrupts));

    // Any of the folowing flags can cause an exception
    assign pendingexception = 
        |({interrupt, overflow, adel, ades, syscallE, breakE, riE, fpuE});
   
    // To pick which of the 8 possible exceptions occured, send them through
    // a priority encoder
    prienc_8  excprienc({interrupt, overflow, adel, ades, syscallE, breakE, 
                        riE, fpuE}, priencout);
                       
  // Take the results of that encoder into mux 8 to set the cause register
  always @ ( * ) 
    casex(priencout)
      3'b000 : exccode <= 5'b00001;
      3'b001 : exccode <= 5'b01100;
      3'b010 : exccode <= 5'b00100;
      3'b011 : exccode <= 5'b00101;
      3'b100 : exccode <= 5'b01000;
      3'b101 : exccode <= 5'b01001;
      3'b110 : exccode <= 5'b01010;
      3'b111 : exccode <= 5'b01011;
    endcase
endmodule

module statusregunit(input             ph1, ph2, reset, writeenable, 
                     input             activeexception, 
                     input      [31:0] writedata, 
                     input             rfeE,
                     output     [31:0] statusreg,
                     output            re, 
                     output     [7:0]  im,
                     output            swc, isc, iec);

  wire cu1, bev, ts, pe, cm, pz, kuo, ieo, kup, iep, kuc;
  wire iecenable, iecnew;
  wire [30:0]  statusreghigh;

  assign cu1 = 0; // No floating point unit
  assign pe = 0;  // No parity checking
  assign cm = 0;  // Isolated cache feature, not implemented
  assign pz = 0;  // Archaic parity feature, not implemented

  assign re  = statusreg[25];  // reverse endianness
  assign bev = statusreg[22];  // not implemented
  assign ts  = statusreg[21];  // TLB not implemented
  assign {swc, isc, im} = statusreg[17:8];


  assign {kuo, ieo, kup, iep, kuc} = 5'b0; // No user vs kernel mode
  
  // set up new value for iec.
  assign iecenable = reset | rfeE | activeexception;
  assign iecnew = reset | rfeE;
  
  assign statusreg = {statusreghigh, iec};

  // define everything but IEc here.
     // bit 28 (cu0) will not have effect since we only run in kernel mode
     // 25 is re
     // 22 and 21 are bev and ts
     // 17 to 8 are swc, isc, and im
  flopenr #(31) srhigh(ph1, ph2, reset, writeenable,
                       {2'b00, cu1, writedata[28], 2'b00, writedata[25],
                        2'b00, writedata[22:21], pe, cm, pz, writedata[17:8],
                        2'b00, kuo, ieo, kup, iep, kuc}, statusreghigh);

  // this flop cannot have a reset!
  flopen #(1) srlo(ph1, ph2, iecenable, iecnew, iec);

endmodule

module causeregunit(input             ph1, ph2, branchdelay,
                    input      [7:0]  interrupts,
                    input      [4:0]  exccode,
                    input             activeexception,
                    output     [31:0] causereg);

  // The cause register is triggered by and exception
  flopen #(32) causeregflop (ph1, ph2, activeexception,
                             {branchdelay, 15'b0, interrupts, 1'b0, exccode, 
                              2'b00}, causereg);
endmodule

// Store EPC - the program counter of and exception
module epcunit(input             ph1, ph2, activeexception, bdsE,
               input      [31:0] pcE,
               output     [31:0] epc);

  wire [31:0]   pcminus4E, epcnext;

  // If the exception occurs on an instruction in the branch delay slot of
  // another instruction, then we must point to the instruction before it.
  adder         pcadd3(pcE, 32'hfffffffc, pcminus4E);
  mux2 #(32)    epcmux(pcE, pcminus4E, bdsE, epcnext);
  flopen #(32)  epcreg(ph1, ph2, activeexception, epcnext, epc);
               
endmodule


module hazard(input            ph1, ph2, reset,
              input            rsonD, rtonD, rsonE, rtonE,
              input            rseqwrDM, rteqwrDM, rseqwrEM, rseqwrEW,
              input            rteqwrEM, rteqwrEW, rteqrsED, rteqrtED,
              input            rseqwrDE, rteqwrDE,
              input            regwriteE, regwriteM, regwriteW,
              input            memtoregE, memtoregM, 
              input            branchD, jumpregD,
              input            instrackF, dataackM, pendingexception,
              input            hiloaccessD, mdrunE,
              output           forwardaD, forwardbD,
              output     [1:0] forwardaE, forwardbE,
              output           stallF, stallD, stallE, stallM, stallW, 
              output           flushD, flushE, flushM, activeexception);

  wire lwstallD, branchstallD, instrmissF, datamissM, multdivDE;

  wire executecleared;

  // forwarding sources to D stage (branch equality)
  assign forwardaD = (rsonD & rseqwrDM & regwriteM);
  assign forwardbD = (rtonD & rteqwrDM & regwriteM);

  // forwarding sources to E stage (ALU)
  assign forwardaE[1] = (rsonE) & (rseqwrEM & regwriteM);
  assign forwardaE[0] = (rsonE) & (rseqwrEW & regwriteW) & 
                          ~forwardaE[1];
  
  assign forwardbE[1] = (rtonE) & (rteqwrEM & regwriteM);
  assign forwardbE[0] = (rtonE) & (rteqwrEW & regwriteW) 
                          & ~forwardbE[1];

  // (This stall was not implemented in R2000)
  assign #1 lwstallD = memtoregE & (rteqrsED | rteqrtED);

  // Cache miss delays
  assign #1 datamissM = ~dataackM;

  // when the instruction in the decode stage wants access to hi/lo (by means of
  // a mt/fhi/lo or another multiply or divide
  assign #1 multdivDE = hiloaccessD & mdrunE;

  // This assumes we are reading an instruction every cycle
  assign #1 instrmissF = ~instrackF;

  // A branch stall happens when a branch is dependant on data that is not yet
  // available.
  assign #1 branchstallD = (branchD | jumpregD) & 
             (regwriteE & ((rseqwrDE) | 
                          (rteqwrDE)) |
              memtoregM & ((rseqwrDM) | 
                          (rteqwrDM)));
  
  // memstallexception is true when we have an exception waiting but we are
  // still waiting for a memory miss
  assign #1 memstallexception = pendingexception & (instrmissF | datamissM);

  // If we are in a branch stall then we can't just allow an exception to take
  // place, because the exeption will be read from the execute stage (which will
  // have been flushed with zeros), so wait until the instruction in the decode
  // stage has made it to the execute stage.
  assign #1 brstallexception = pendingexception & executecleared;

  // Keep track of whether the execute stage is blank
  flopr #(1) execclearreg(ph1, ph2, reset, (flushE | executecleared) & stallD, 
                          executecleared);


  // NOTE: activeexception actually drives the true "exception" which is used
  // all over the chip and must be sent back to the coprocessor.  
  // This is likely part of the processor's critical.
  //
  // activeexception relies on the memory stage's ability to be flushed
  // eventually no matter what else is happening on the system.  Once the memory
  // stage is flushed, then eventually there will no longer be an
  // instruction stage stall (if there was one to begin with) and there
  // will also not be a branch stall.
  assign #1 activeexception = pendingexception & ~memstallexception & 
                              ~brstallexception;

  assign #1 stallD = lwstallD | branchstallD | datamissM | multdivDE
                     | instrmissF; 

  assign #1 stallF =  stallD;     // stalling D stalls F

  // E needs all the freedom it can get to let its instrucitons through.  only
  // a data miss or a pending exception held in the E stage itself can 
  // prevent instructions from continuing down the pipeline.
  assign #1 stallE = datamissM | memstallexception; 

  // The only reason to hold up Memory and Writeback are when they are waiting
  // for memory.
  assign #1 {stallM, stallW} = {2{datamissM}};

  // We kill D only when an exception is flushing the processor
  assign #1 flushD = activeexception;  // Exceptions invalidate the decode stage

  // We kill E whenever an exception being carried out or when stallD is high
  // so long as the reason we are stalling D is not related to an exception
  // held in E nor a data (not instruction) miss
  assign #1 flushE =    (~datamissM & stallD & ~memstallexception)
                      | activeexception;
 
  // Kill M so long as we aren't waiting for data memory to do something.  If
  // E is waiting for the instruction cache before it can throw an exception, we
  // need to still flush M.  Finally, once an exception really happens, we have
  // to flush M because the instruction that was in E before this is not allowed
  // to have any affect.
  assign #1 flushM = (~stallM & memstallexception) | activeexception;

endmodule

module fivebitdp(input         ph1, ph2, reset,
                 input         stallE, stallM, stallW,
                 input         flushE, flushM,
                 input  [4:0]  rsD, rtD, rdD,
                 input         rdsrcD, regdstE,
                 output        rsonD, rtonD, rsonE, rtonE, rseqwrDM, rteqwrDM, 
                               rseqwrEM, rseqwrEW, rteqwrEM, rteqwrEW, 
                               rteqrsED, rteqrtED, rseqwrDE, rteqwrDE,
                 output [4:0] rdE, writeregW);
    
  wire [4:0] rsE, rtE, rd2D;
  wire [4:0] writeregM, writeregE;
  
  //hazard 5-bit comparisons
  neqzerocmp #(5) ez1(rsD, rsonD);
  neqzerocmp #(5) ez2(rtD, rtonD);
  neqzerocmp #(5) ez3(rsE, rsonE);
  neqzerocmp #(5) ez4(rtE, rtonE);
  eqcmp #(5) e1(rsD, writeregM, rseqwrDM);
  eqcmp #(5) e2(rtD, writeregM, rteqwrDM);
  eqcmp #(5) e3(rsE, writeregM, rseqwrEM);
  eqcmp #(5) e4(rsE, writeregW, rseqwrEW);
  eqcmp #(5) e5(rtE, writeregM, rteqwrEM);
  eqcmp #(5) e6(rtE, writeregW, rteqwrEW);
  eqcmp #(5) e7(rtE, rsD, rteqrsED);
  eqcmp #(5) e8(rtE, rtD, rteqrtED);
  eqcmp #(5) e9(rsD, writeregE, rseqwrDE);
  eqcmp #(5) e0(rtD, writeregE, rteqwrDE);
  //Decode mux
  mux2 #(5)   rdmux(rdD, 5'b11111, rdsrcD, rd2D);
  //Execute mux
  mux2 #(5)   wrmux(rtE, rdE, regdstE, writeregE);
  //Decode reg flops
  flopenrc #(5)  r4E(ph1, ph2, reset, ~stallE, flushE, rsD, rsE);
  flopenrc #(5)  r5E(ph1, ph2, reset, ~stallE, flushE, rtD, rtE);
  flopenrc #(5)  r6E(ph1, ph2, reset, ~stallE, flushE, rd2D, rdE);
  //Execute reg flops
  flopenrc #(5)  r3M(ph1, ph2, reset, ~stallM, flushM, writeregE, writeregM);
  //Writeback reg flops
  flopenr #(5)  r3W(ph1, ph2, reset, ~stallW, writeregM, writeregW);
  
endmodule

module branchcontroller(input             reset, pendingexception, jump, branch,
                                          link, aeqz, aeqb, agtz, altz,
                        input             lt, gt, eq, src,
                        output            rdsrc, 
                        output      [1:0] pcsrc,
                        output      [1:0] pcbranchsrc,
                        output            jumpreg);

  // Various comparison results that warrant taking a branch
  wire abcompare = (eq & aeqb) | (~eq & ~aeqb);
  wire azcompare = (~eq & ~lt & ~gt) | (eq & aeqz) | (gt & agtz) | (lt & altz);

  // rdsrc is 1 when we need to force destination register to be 31
  assign #1 rdsrc = ((jump & ~src) | branch) & link;
  assign #1 jumpreg = jump & src;

  // pcsrc values
  // 2'b00 reset vector
  // 2'b01 exception vector
  // 2'b10 PC+4
  // 2'b11 branch
  assign #1 pcsrc = {~reset & ~pendingexception, 
                        ~reset & (pendingexception | jump 
                        | (branch & ((src & abcompare) | (~src & azcompare))))};

  // pcbranchsrc
  // 2'b00 branch to pc+4 + offset
  // 2'b01 jump to register value
  // 2'b10 jump to immediate
  assign #1 pcbranchsrc = {jump & src, jump & ~src};

endmodule
           
module alu(input      [31:0] a, b, 
           input      [2:0]  control, 
           output reg [31:0] aluresult,
           output            overflow);

  wire [31:0] b2, sum, aorb;
  wire sltSigned, sltUnsigned;

  assign #1 b2 = control[2] ? ~b:b; 
  assign #1 sum = a + b2 + control[2];
  assign #1 sltSigned = sum[31];
  // a < b in Verilog is an unsigned comparison
  assign #1 sltUnsigned = a < b;
  assign #1 aorb = a | b;

  assign #1 overflow = (a[31] == b2[31] & a[31] != sum[31]);

  // ALU Unit
  always@( * )
    case(control[2:0])
      3'b000: aluresult <= #1 a & b;      // and
      3'b001: aluresult <= #1 aorb;       // or
      3'b010: aluresult <= #1 sum;        // add
      3'b110: aluresult <= #1 sum;        // sub
      3'b111: aluresult <= #1 sltSigned;  // slt signed
      3'b011: aluresult <= #1 sltUnsigned;// slt unsigned
      3'b100: aluresult <= #1 a ^ b;      // xor
      3'b101: aluresult <= #1 ~aorb;      // nor
    endcase
endmodule

module shifter(input signed [31:0] a, b,
               input        [2:0] control,
               input              lui,
               input        [4:0] constshift,
               output       [31:0] shiftresult);

  wire [31:0] leftlogical, rightlogical, rightassociative;
  wire [4:0] shiftamount;

  assign leftlogical      = b << shiftamount;
  assign rightlogical     = b >> shiftamount;
  assign rightassociative = b >>> shiftamount;

  // The control bits are: {constant, left, rightassociative}
 
  mux3 #(5)  shamtmux(a[4:0],     // Variable shift taken from a register
                      constshift, // Shift taken from the immediate value
                      5'b10000,   // LUI always shifts by 16
                      {lui, control[2]}, shiftamount);

  mux3 #(32) shresmux(rightlogical, rightassociative, leftlogical, control[1:0],
                      shiftresult);
endmodule

module mdunit(input         ph1, ph2, reset,
              input  [31:0] srca, srcb,
              input  [2:0]  alushcontrol,
              input         mdstart, hilosrc, 
              input  [1:0]  hilodisable,
              output [31:0] hi, lo,
              output        mdrun);

  wire [31:0] prodh, prodl, hinext, lonext;

  multdiv multdiv(ph1, ph2, reset, mdstart, alushcontrol[0], alushcontrol[1],
                  srca, srcb, prodh, prodl, mdrun);
  mux2 #(32) losrcmux(prodl, srca, hilosrc, lonext);
  mux2 #(32) hisrcmux(prodh, srca, hilosrc, hinext);

  // The HI and LO registers:
  // These don't really need the reset
  flopenr #(32) loreg(ph1, ph2, reset, ~hilodisable[0], lonext, lo);
  flopenr #(32) hireg(ph1, ph2, reset, ~hilodisable[1], hinext, hi);
    
endmodule

module regfile(input         ph1, ph2, 
               input         we3, 
               input  [4:0]  ra1, ra2, wa3, 
               input  [31:0] wd3, 
               output [31:0] rd1, rd2);

  reg [31:0] rf[31:0];

  // three ported register file
  // read two ports combinationally
  // write third port on falling edge of clock
  // register 0 hardwired to 0

  always @(negedge ph1)
    if (we3) rf[wa3] <= wd3;

  assign #1 rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign #1 rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule
