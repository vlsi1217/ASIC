//------------------------------------------------
// mem.v
// npinckney@hmc.edu  January 2007
// Memory subsystem of mips microprocessor
//
//------------------------------------------------

`timescale 1 ns / 1 ps



// Implementation of upper bit bypass here.
// Description of interface:
//
// pcF = Program counter (memory address)
// instrF = Instruction fetched (instruction data)
//
// swc = swap caches.  (0 = normal assignment, 1 = swapped)
module memsys(input ph1, ph2, reset,
                       input [31:2] pcF,
                       output [31:0] instrF,
                       input reF,
                       output instrackF,
                       
                       input [29:0] adrM, 
                       input [31:0] writedataM,
                       input [3:0] byteenM,
                       output [31:0] readdataM,
                       input memwriteM, reM,
                       output dataackM,
                       
                       input swc,
                       
                       output [26:0] memadr,
                       inout [31:0] memdata,
                       output [3:0] membyteen,
                       output memrwb,
                       output memen,
                       input memdone);

  wire enF, enM;

  wire [29:0] dadr;
  wire [31:0] ddata;
  wire [3:0] dbyteen;
  wire drwb, den, ddone;
  wire [26:0] dmemadr;
  wire [31:0] dmemdata;
  wire [3:0] dmembyteen;
  wire dmemrwb, dmemen;
  wire dmemdone;
  wire dmemdonemem;

  wire [29:0] iadr;
  wire [31:0] idata;
  wire [3:0] ibyteen;
  wire irwb, ien, idone;
  wire [26:0] imemadr;
  wire [31:0] imemdata;
  wire [3:0] imembyteen;
  wire imemrwb, imemen;
  wire imemdone;
  wire imemdonemem;

  wire [26:0] wbadr;
  wire [31:0] wbdata;
  wire [3:0] wbbyteen;
  wire wben, wbdone;
  wire [26:0] wbmemadr;
  wire [31:0] wbmemdata;
  wire [3:0] wbmembyteen;
  wire wbmemen;
  wire wbmemdone;

  wire [1:0] state;  // don,ion,wbon are decoded state.
  wire don,ion,wbon;
  
  assign enF = reF;
  assign enM = reM | memwriteM;

  // This swaps the output if swc is asserted.
  // The first is the swapped case, second is normal.
  // Inputs:
  // * I/D-cache mux *
  cmux2 #(30) adrmux(adrM,pcF[31:2],swc,dadr,iadr);
  cmux2 #(4) byteenmux(byteenM,4'b1,swc,dbyteen,ibyteen);
  cmux2 #(1) rwbmux(~memwriteM,1'b1,swc,drwb,irwb);
  cmux2 #(1) enmux(enM,enF,swc,den,ien);
  // If reading want this to be z,
  // if writing then drive with the data to write.
  tribuf #(32) ddatatri(~swc & memwriteM,writedataM,ddata);
  tribuf #(32) idatatri(swc & memwriteM,writedataM,idata);
  // I/D Outputs:
  cmux2 #(32) datamux(ddata,idata,swc,readdataM,instrF);
  cmux2 #(1) donemux(ddone,idone,swc,dataackM,instrackF);

  // * Write buffer muxes *
  tribuf #(27) wbadrd(~swc & ~dmemrwb, dmemadr, wbadr);
  tribuf #(27) wbadri(swc & ~imemrwb, imemadr, wbadr);
  tribuf #(32) wbdatad(~swc & ~dmemrwb, dmemdata, wbdata);
  tribuf #(32) wbdatai(swc & ~imemrwb, imemdata, wbdata);
  tribuf #(4) wbbyteend(~swc & ~dmemrwb, dmembyteen, wbbyteen);
  tribuf #(4) wbbyteeni(swc & ~imemrwb, imembyteen, wbbyteen);
  tribuf #(1) wbend(~swc & ~dmemrwb, dmemen, wben);
  tribuf #(1) wbeni(swc & ~imemrwb, imemen, wben);
  tribuf #(1) wbenz((swc & imemrwb) | (~swc & dmemrwb), 1'b0, wben);
  // Dones.  Intercepts and connects to write buffer
  // if appropriate.  The swc's are because only the
  // cache acting for data can write.
  mux2 #(1) dmemdonemux(dmemdonemem, wbdone, ~swc & ~dmemrwb, dmemdone);
  mux2 #(1) imemdonemux(imemdonemem, wbdone, swc & ~imemrwb, imemdone);

  // * Muxes for memory *
  // Memory adr, byteen, rwb
  mux4 #(27) memadrmux(27'b0,wbmemadr,dmemadr,imemadr,state,memadr);
  mux4 #(4) membyteenmux(4'b1,wbmembyteen,dmembyteen,imembyteen,state,membyteen);
  mux4 #(1) memrwbmux(1'b1,1'b0,1'b1,1'b1,state,memrwb);
  // Memory data
  tribuf memdatatri(wbon, wbmemdata, memdata);           // wb writes
  tribuf dmemdatatri(dmemrwb & don, memdata, dmemdata);  // data reads
  tribuf imemdatatri(imemrwb & ion, memdata, imemdata);  // instruction reads
  // Memory dones         
  mux2 #(1) wbmemdonemux(1'b0,memdone,wbon,wbmemdone);
  mux2 #(1) dmemdonememmux(1'b0,memdone,don,dmemdonemem);
  mux2 #(1) imemdonememmux(1'b0,memdone,ion,imemdonemem);
  
  cache dcache(ph1, ph2, reset, dadr, ddata, dbyteen,
                           drwb, den, ddone,
                           dmemadr,dmemdata,dmembyteen,
                           dmemrwb, dmemen,dmemdone);
                         
  cache icache(ph1, ph2, reset, iadr, idata, ibyteen,
                           irwb, ien, idone,
                           imemadr,imemdata,imembyteen,
                           imemrwb, imemen,imemdone);

  writebuffer writebuf(ph1, ph2, reset, wbadr, wbdata, wbbyteen,
                            wben, wbdone,
                            wbmemadr, wbmemdata, wbmembyteen,
                            wbmemen, wbmemdone);
  
  memsyscontroller memsysc(ph1, ph2, reset,
                           wbmemen, dmemen, imemen,
                           dmemrwb, imemrwb,
                           memdone, swc,
                           state, wbon, don, ion,
                           memen);
endmodule


module memsyscontroller(input ph1, ph2, reset,
                        input wbmemen, dmemen, imemen,
                        input dmemrwb, imemrwb,
                        input memdone, swc,
                        output [1:0] state,
                        output wbon, don, ion,
                        output memen);

  reg [1:0] nextstate;
  wire [3:0] onnext;
  
  parameter SREADY = 2'b00; // Ready state
  parameter SWB = 2'b01;  // Write buffer on
  parameter SD = 2'b10;  // Data cache on
  parameter SI = 2'b11; // Instruction cache on

  dec2 statedec(nextstate,onnext);
  flopr #(3) fon(ph1, ph2, reset, onnext[3:1], {ion,don,wbon});
  flopr #(1) fmemen(ph1, ph2, reset, (|nextstate), memen);

  flopr #(2) fstate(ph1, ph2,reset,nextstate,state);

  always @(*)
  begin
      case(state)
          SREADY: if(wbmemen)  // High priority
                       nextstate <= SWB;
                  else if(~swc & dmemen & dmemrwb)  // Med. priority
                       nextstate <= SD;
                  else if(swc & imemen & imemrwb)
                       nextstate <= SI;
                  else if(~swc & imemen & imemrwb) // Low priority
                       nextstate <= SI;
                  else if(swc & dmemen & dmemrwb)
                       nextstate <= SD;
                  else nextstate <= SREADY;
          SWB:    if(memdone) nextstate <= SREADY;
                  else nextstate <= SWB;
          SD:     if(memdone) nextstate <= SREADY;
                  else nextstate <= SD;
          SI:     if(memdone) nextstate <= SREADY;
                  else nextstate <= SI;
          default: nextstate <= SREADY;
      endcase
  end
endmodule


// cache: a 1kB cache
module cache(input ph1, ph2, reset,
             input [29:0] adr,
             inout [31:0] data,
             input [3:0] byteen,
             input rwb, en,
             output done,
             
             output [26:0] memadr, 
             inout  [31:0] memdata,
             output [3:0] membyteen,
             output memrwb,
             output memen,
             input memdone);
            
  wire [31:0] readdata;
            
  // Cache ram ports
  wire [31:0] cacheline;
  wire [19:0] tagdata;
  wire        valid;
  wire [31:0] cachelinenew;
  wire [19:0] tagdatanew;
  wire        validnew;
  wire        cacheramrwb;
            
  // Control signals
  wire bypass;
  wire waiting;
  wire reading;
            
  cacheram cacheram(ph1, ph2, adr[6:0],cacheramrwb,
                    {validnew,tagdatanew,cachelinenew},
                    {valid,tagdata,cacheline});
  cachecontroller cachec(ph1, ph2, reset, adr[29:7], en, rwb,
                         tagdata, valid, memdone, 
                         bypass, waiting, reading, done);
            
  // Cache ram controls.  Cache ram doesn't have an enable,
  // just cacheramrwb goes low for writing.
  // We write if we're using memory (waiting)
  // and not bypassing.  (Remember rwb = 0 for a write)
  assign #1 cacheramrwb = ~waiting | bypass;
  mux2 #(32) cachelinemux(data,memdata,reading,cachelinenew);
  assign #1 tagdatanew = adr[26:7];
  assign #1 validnew = ((& byteen) | reading) & memdone;  // valid if reading or writing all
                                                                    // bytes.
  // Memory controls                  
  assign #1 memadr = adr[26:0];
  mux2 #(4) membyteenmux(byteen, 4'b1, reading, membyteen);
  assign #1 memrwb = rwb;
  assign #1 memen = waiting;
            
  // Bi-directional data port
  mux2 #(32) readdatamux(cacheline, memdata, waiting, readdata);
  tribuf #(32) datatri(rwb,readdata,data);
  tribuf #(32) memdatatri(~rwb,data,memdata);
endmodule


// cachecontroller: controls the cache for reading/writing.
module cachecontroller(input ph1, ph2, reset,
              input [29:7] adr,
              input en, rwb,
              
              input [19:0] tagdata,
              input valid,
              
              input memdone,
              
              output bypass,
              output waiting,
              output reading,
              output done);

    reg [1:0] nextstate;
    wire [1:0] state;

    assign #1 bypass = adr[29] & adr[27];
    assign #1 waiting = (|state);
    assign reading = state[0];  
    assign #1 incache = (tagdata == adr[26:7]) & valid;
    assign #1 done = (incache & rwb & ~bypass) | (waiting & memdone) | ~en | reset;

    parameter SREADY = 2'b00;  // Ready
    parameter SREAD  = 2'b01;  // Read
    parameter SWRITE = 2'b10;  // Write
            
    flopr #(2) fstate(ph1, ph2,reset,nextstate,state);
          
    always @(*)
      case(state)
         SREADY:  if(~done & rwb) nextstate <= SREAD;
                  else if(~done & ~rwb) nextstate <= SWRITE;
                  else        nextstate <= SREADY;
         SREAD:   if(memdone) nextstate <= SREADY;
                  else        nextstate <= SREAD;
         SWRITE:  if(memdone) nextstate <= SREADY;
                  else        nextstate <= SWRITE;
         default: nextstate <= SREADY;
       endcase
endmodule


// 512 bytes cache memory + tag (20) [51:32] + valid (1-bit) [52]
module cacheram(input ph1, ph2,
  input [6:0] adr,
  input rwb,
  input [52:0] din,
  output [52:0] dout);
  
  reg [52:0] mem[127:0];
  
  always @(posedge ph1)
    if(~rwb) mem[adr] <= din;
    
  assign dout = mem[adr];
endmodule


// writebuffer:  The write buffer, for storing
// data to write to external memory.
module writebuffer(input ph1, ph2, reset,
                   input [26:0] adr,
                   input [31:0] data,
                   input [3:0] byteen,
                   input en,
                   output done,
                   
                   output [26:0] memadr,
                   output [31:0] memdata,
                   output [3:0] membyteen,
                   output memen,
                   input memdone);

   wire [31:0] bufdata;
   wire [26:0] bufadr;
   wire [3:0] bufbyteen;
   wire bufen[3:0];             // Flags to indicate whether buffer entries have
                                // valid data.
   
   wire [1:0] ptr,writeptr,ptrnext,writeptrnext;
   wire [3:0] ptrs,writeptrs;
   wire writeready;
   wire [1:0] junk; // This doesn't go anywhere, carryouts from the two incs
   
   assign done = ~bufen[ptr];   // If we have a free space available.
   assign writeready = (memdone | ~memen) & bufen[writeptr];
   
   inc #(2) ptrinc(ptr,ptrnext,junk[0]);
   inc #(2) writeptrinc(writeptr,writeptrnext,junk[1]);
   flopenr #(2) ptrf(ph1, ph2, reset, en & done, ptrnext, ptr);
   flopenr #(2) writeptrf(ph1, ph2, reset, writeready, writeptrnext, writeptr);
   
   assign memadr = bufadr;
   assign memdata = bufdata;
   assign membyteen = bufbyteen;
   assign memen = bufen[writeptr];
   //flopenr #(27) memadrf(ph1, ph2, reset, writeready, bufadr, memadr);
   //flopenr #(32) memdataf(ph1, ph2, reset, writeready, bufdata, memdata);
   //flopenr #(4) membyteenf(ph1, ph2, reset, writeready, bufbyteen, membyteen);
   //flopenr #(1) memenf(ph1, ph2, reset, memdone | ~memen, bufen[writeptr], memen);
  
   dec2 ptrdec(ptr,ptrs);
   dec2 writeptrdec(writeptr,writeptrs);
  
   genvar i;
   generate
     for(i = 0; i < 4; i = i + 1) begin:fbuf
       flopenr #(1) fbufen(ph1, ph2,reset,
                           ((en & done) & ptrs[i]) | ((memdone | ~memen) & writeptrs[i]), 
                           (en & done) & ptrs[i],bufen[i]);
     end
   endgenerate
   
   wbram ram(ph1,ph2,ptr,writeptr,
             ~(en & done),
             {byteen,adr,data},
             {bufbyteen,bufadr,bufdata});
endmodule

  // data (32) + adr (27) + byteen (4) = 63 bits total
module wbram(input ph1, ph2,
  input [1:0] ptr, writeptr,
  input rwb,
  input [62:0] din,
  output [62:0] dout);

  reg [62:0] mem[3:0];
  
  always @(posedge ph1)
    if(~rwb) mem[ptr] <= din;
    
  assign dout = mem[writeptr];
endmodule