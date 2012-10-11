//------------------------------//
// Parameter Defination
//------------------------------//
`timescale 1ns/1ns

`define	   REGFILE_IP   1       // if the REGFILE is implemented by IPCore, then define this parameter
`define    ICACHE_IP    1       // these parameters definitions can be commented for simulation 
`define    DCACHE_IP    1
`define    DIV_IP       1
`define    MUL_IP       1
`define    DCM_IP       1

`define    DIV_SLOT     4       // how many cycles of the computation
`define    MUL_SLOT     4       // the result is available at HO & LO after #SLOT cycles

`define    ROM_KB       8       // 8  KB ROM for program
`define    RAM_KB       8       // 8  KB RAM for runtime data

`define    ProPATH      "../DataFile/test_shining_LED.bin"
								// Use this file to initiate the instruciton ROM IP
								// NOTE: this file is only applicable in bahavorial 
								// simulation WITHOUT IP cores (XX_IP is commented off)
								// If IP is active, regenerate the ICache_IP to reload
								// the new program coe file.

`define    CTRLEXE_WIDTH 12     // width of the control signal to EXE 
`define    CTRLMEM_WIDTH 8      // width of the control signal to MEM
`define    CTRLWB_WIDTH  6      // width of the control signal to WB
`define    BUS_WIDTH     32     // width of the data/address bus
`define    REG_WIDTH     5      // width of the register address
`define    OP_WIDTH      6      // width of the OP section
`define    RS_WIDTH      5      // width of the RS register address
`define    RT_WIDTH      5      // width of the RT register address
`define    RD_WIDTH      5      // width of the RD register address
`define    OFFSET_WIDTH  16     // width of the OFFSET section
`define    FUNCT_WIDTH   6      // width of the FUNCT section
`define    IMM_WIDTH     16     // width of the IMM section
`define    SHAMT_WIDTH   5      // width of the SHAMT section
`define    JMPADDR_WIDTH 26     // width of the TARGET section for J/JAL instructions     
`define    ICTRL_WIDTH   7      // width of the signal to control ALU

//----------------------------------------------------------------------------------------------------------------//
// Section 1: Define basic elements of the processor
//----------------------------------------------------------------------------------------------------------------//
//------------------------------//
// Module:      RegFile
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Aug.8
// Description: 
//------------------------------//
module RegFile (clk_s,clk_f,nrst,Ra1,Ra0,Wa,Wd,We,Rd1,Rd0);
    input  [0:0]  clk_s,clk_f,nrst;  //clk_f = fast clk; clk_s = slow clk
    input  [`REG_WIDTH-1:0]  Ra1,Ra0; //Read address
    input  [`REG_WIDTH-1:0]  Wa;      //Write address
    input  [`BUS_WIDTH-1:0]  Wd;      //Write data
    input  [0:0]             We;      //Write enable 1=write,0=read
    output [`BUS_WIDTH-1:0]  Rd1,Rd0; //Read data
    
	`ifdef REGFILE_IP
	// IP implementation
	// NOTE: If the IP core of RegFile is active, the registers at 
	// input and output of the memory device have to be valid.
	
	// FSM to synchronize the write/read cycles (write first)
	parameter [0:0] W_cycle=1'b1;
	parameter [0:0] R_cycle=1'b0;
	reg [0:0] state,next_state;
	reg [0:0] internal_we;
		// state jumping
	always@(*)
	begin
		case(state)
			W_cycle: next_state=R_cycle;
			R_cycle: next_state=W_cycle;
		endcase
	end
		// state reg
	always@(posedge clk_f)
	begin
		if (nrst==1'b0)
			state <= W_cycle;
		else
			state <= next_state;
	end
  		// output
	always@(*)
	begin
		if (state==1'b1)
			internal_we = We;
		else
			internal_we = 1'b0; // read cycle always read
	end
	
	// mux to select the input addr
	reg [`REG_WIDTH-1:0] RWaddr0,RWaddr1;
	reg [`BUS_WIDTH-1:0] Wdata1;
	
	always@(*)
	begin
		if (state==W_cycle) begin
			RWaddr0 = {`REG_WIDTH{1'b0}};
		end else begin
			RWaddr0 = Ra0;
		end
	end
	
	always@(*)
	begin
		if (state==W_cycle) begin
			if (We==1'b1)
				RWaddr1 = Wa;
			else
				RWaddr1 = {`REG_WIDTH{1'b0}};
		end else begin
			RWaddr1 = Ra1;
		end
	end
	
	always@(*)
	begin
		if (state==W_cycle && We==1'b1) begin
			Wdata1 = Wd;
		end else begin
			Wdata1 = {`BUS_WIDTH{1'b0}};
		end
	end
	
	/*// A dual-port RAM implemented with distributed memory and without registers at Input.
	RegFile_IP RegFile_IP_U (
	Ra0,
	Wd,
	RWaddr,
	clk,
	Wen,
	Rd0,
	Rd1);*/
	
	// A true dual-port RAM implemented with block memory and with registers at Input.
	wire [0:0] rst;
	assign rst = ~nrst; // postive reset
	
	RegFile_IP2 RegFile_IP2_U (
	clk_f,
	rst,
	state,//wea,
	RWaddr0,
	32'h00000000,//dina,
	Rd0,
	clk_f,
	rst,
	state,
	RWaddr1,
	Wdata1,
	Rd1);
	
	`else
	reg [`BUS_WIDTH-1:0] mem [`BUS_WIDTH-1:0]; //[bit width] var [how many]
    reg [`BUS_WIDTH-1:0] Rd0,Rd1;
	integer i;
	
	// simulation model
    always@(posedge clk_s)
    begin
        if (!nrst) begin
            for (i=0;i<`BUS_WIDTH;i=i+1)
            begin: RESET_REG
                mem[i] <= 0;
            end
        end else begin
            if (We==1)//Write first
                mem[Wa] <= Wd;
        end
		
		if (Ra0!=0)
			Rd0 <= mem[Ra0];
		else
			Rd0 <= 0;
			
		if (Ra1!=0)
			Rd1 <= mem[Ra1];
		else
			Rd1 <= 0;
    end
	`endif
endmodule
        
//------------------------------//
// Module:      Program Memory (ROM)
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Aug.8
// Description: This module is the program memory
// In this version, it is implemented by a 8KB ROM (2K*32bit)
//------------------------------//
module ProgramMEM (clk,nrst,Addr,Data);
    input  [0:0]  clk,nrst;
	input  [`BUS_WIDTH-1:0] Addr;
    output [`BUS_WIDTH-1:0] Data;
    
    `ifdef ICACHE_IP
    // IP implementation
	// A single port block ROM with register ONLY at input port
    ICache_IP ICache_IP_U (
	clk,
	Addr[12:2], // * be careful the shorter bit width *
	Data);
    `else
    // simulation model
    reg    [`BUS_WIDTH-1:0] rom [0:(`ROM_KB/4)*1024-1];
    reg    [`BUS_WIDTH-1:0] Data;
    initial $readmemb(`ProPATH,rom);
    always@(posedge clk)
	begin
		Data <= rom[Addr[12:2]]; // * be careful the shorter bit width *
    end
    `endif
endmodule

//------------------------------//
// Module:      Data Memory (RAM)
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Aug.8
// Description: This module is a data memory
// In this version, it is a 16KB RAM.
//------------------------------//
module DataMEM (clk,nrst,Addr,Wdata,Wen,Ren,Rdata);
    input  [0:0]  clk,nrst,Wen,Ren;
    input  [`BUS_WIDTH-1:0] Addr,Wdata;
    output [`BUS_WIDTH-1:0] Rdata;
    
    `ifdef DCACHE_IP
    // IP implementation
	wire [0:0] rst;
	assign rst=~nrst;
	// A single port block RAM with registers at input
	DCache_IP DCache_IP_U (
	clk,
	rst,
	Wen,
	Addr[12:2], // * be careful the shorter bit width
	Wdata,
	Rdata);
    `else
    // simulation model
    reg    [`BUS_WIDTH-1:0] ram [0:(`RAM_KB/4)*1024-1];
    reg    [`BUS_WIDTH-1:0] Rdata;
    always@(posedge clk)
    begin
        if (Wen) begin
            ram[Addr[12:2]] <= Wdata; // * be careful the shorter bit width
            Rdata 			<= {`BUS_WIDTH{1'b0}};
        end else if (Ren)
            Rdata <= ram[Addr[12:2]]; // * be careful the shorter bit width
        else
            Rdata <= {`BUS_WIDTH{1'b0}};
    end
    `endif
endmodule

//------------------------------//
// Module:      Unsigned ADD
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Aug.8
// Description: ADDU and SUBU function without overflow
//------------------------------//
module ADDU (A,B,sub,S);
// sub - if subtraction
// S   - sum

    input  [0:0] sub;
    input  [`BUS_WIDTH-1:0] A,B;
    output [`BUS_WIDTH-1:0] S;
    reg    [`BUS_WIDTH-1:0] S;
    
    always@(*)
    begin
        if (!sub) // addu
            S = A+B;
        else      // subu
            S = A-B;
    end
endmodule

//------------------------------//
// Module:      Signed ADD
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Aug.8
// Description: ADD and SUB functions with overflow (carry)
//------------------------------//
module ADD (A,B,sub,OV,S);
// OV - overflow
// S  - sum
    output [0:0] OV;
    input  [0:0] sub;
    
    input signed [`BUS_WIDTH-1:0] A,B;
    output [`BUS_WIDTH-1:0] S;
    reg    [`BUS_WIDTH-1:0] S;
    reg    [0:0]  OV;
    
    always@(*)
    begin
        if (!sub) // add
            {OV,S} = A + B;
        else
            {OV,S} = A - B;
    end
endmodule

//------------------------------//
// Module:      Constant Adder
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Feb.11
// Description: ADD constant 4
//------------------------------//
module ADD4 (Di,Do);
    input  [`BUS_WIDTH-1:0] Di;
    output [`BUS_WIDTH-1:0] Do;
    
    assign Do = Di + 4;
endmodule

//------------------------------//
// Module:      Unsigned MUL
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Aug.8
// Description: 
//------------------------------//
module MULU (clk,nrst,A,B,PH,PL);
    input  [0:0] clk,nrst;
    input  [`BUS_WIDTH-1:0] A,B;
    output [`BUS_WIDTH-1:0] PH,PL;
    
    `ifdef MUL_IP
    // IP implementation
	// 4 cycles pipeline parallel unsigned multiplier
    MULU_IP MULU_IP_U (
    clk, A, B, {PH,PL}
	);
    `else
    // simulation model
    wire   [(`BUS_WIDTH*2)*(`MUL_SLOT+1)-1:0] product;
    assign product[(`BUS_WIDTH*2)-1:0] = A * B;
    
    genvar i;
    generate
        for(i=0;i<`MUL_SLOT;i=i+1)
        begin:MULU_DFF
            DFF #(`BUS_WIDTH*2) dff_unit (clk,nrst,product[(`BUS_WIDTH*2)*i+(`BUS_WIDTH*2-1):(`BUS_WIDTH*2)*i],product[(`BUS_WIDTH*2)*(i+1)+(`BUS_WIDTH*2-1):(`BUS_WIDTH*2)*(i+1)]);
        end
    endgenerate
    
    assign {PH,PL} = product[(`BUS_WIDTH*2)*(`MUL_SLOT)+(`BUS_WIDTH*2-1):(`BUS_WIDTH*2)*(`MUL_SLOT)];
    `endif
endmodule

//------------------------------//
// Module:      Signed MUL
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Aug.8
// Description: This module needs Verilog-2001 standard compiler
//------------------------------//
module MUL (clk,nrst,A,B,PH,PL);
    input  [0:0] clk,nrst;
    input  signed [`BUS_WIDTH-1:0] A,B;
    output [`BUS_WIDTH-1:0] PH,PL;
    
    `ifdef MUL_IP
    // IP implementation
	// 4 cycles pipeline parallel signed multiplier
    MUL_IP MUL_IP_U (
	clk, A, B, {PH,PL}
	);
    `else
    // simulation model
    wire   [(`BUS_WIDTH*2)*(`MUL_SLOT+1)-1:0] product;
    assign product[(`BUS_WIDTH*2)-1:0] = A * B;
    
    genvar i;
    generate
        for(i=0;i<`MUL_SLOT;i=i+1)
        begin:MUL_DFF
            DFF #(`BUS_WIDTH*2) dff_unit (clk,nrst,product[(`BUS_WIDTH*2)*i+(`BUS_WIDTH*2-1):(`BUS_WIDTH*2)*i],product[(`BUS_WIDTH*2)*(i+1)+(`BUS_WIDTH*2-1):(`BUS_WIDTH*2)*(i+1)]);
        end
    endgenerate
    
    assign {PH,PL} = product[(`BUS_WIDTH*2)*(`MUL_SLOT)+(`BUS_WIDTH*2-1):(`BUS_WIDTH*2)*(`MUL_SLOT)];
    `endif
endmodule

//------------------------------//
// Module:      Unsigned DIVU
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Aug.8
// Description: 
//------------------------------//
module DIVU (clk,nrst,A,B,PH,PL);
    input  [0:0] clk,nrst;
    input  [`BUS_WIDTH-1:0] A,B;
    output [`BUS_WIDTH-1:0] PH,PL;    

    
    `ifdef DIV_IP
    // IP implementation
	// 4 cycle radix-2 unsigned divider
    DIVU_IP DIVU_IP_U (
     , clk, A, PL, B, PH
	);
    `else
    // simulation model
    wire   [(`BUS_WIDTH*2)*(`DIV_SLOT+1)-1:0] rem_quo;
    wire   [`BUS_WIDTH-1:0] quo,rem;
    assign quo = A / B;
    assign rem = A % B;
    assign rem_quo[(`BUS_WIDTH*2)-1:0] = {rem,quo};
    
    genvar i;
    generate
        for(i=0;i<`DIV_SLOT;i=i+1)
        begin:DIVU_DFF
            DFF #(`BUS_WIDTH*2) dff_unit (clk,nrst,rem_quo[(`BUS_WIDTH*2)*i+(`BUS_WIDTH*2-1):(`BUS_WIDTH*2)*i],rem_quo[(`BUS_WIDTH*2)*(i+1)+(`BUS_WIDTH*2-1):(`BUS_WIDTH*2)*(i+1)]);
        end
    endgenerate
    
    assign {PH,PL} = rem_quo[(`BUS_WIDTH*2)*(`DIV_SLOT)+(`BUS_WIDTH*2-1):(`BUS_WIDTH*2)*(`DIV_SLOT)];
    `endif
endmodule

//------------------------------//
// Module:      Signed DIV
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Aug.8
// Description: This module needs Verilog-2001 standard compiler
//------------------------------//
module DIV (clk,nrst,A,B,PH,PL);
    input  [0:0] clk,nrst;
    input  signed [`BUS_WIDTH-1:0] A,B;
    output [`BUS_WIDTH-1:0] PH,PL;

    `ifdef DIV_IP
    // IP implementation
	// 4 cycle radix-2 signed divider
    DIV_IP DIV_IP_U (
     , clk, A, PL, B, PH
	);
    `else
    // simulation model
    wire   [(`BUS_WIDTH*2)*(`DIV_SLOT+1)-1:0] rem_quo;
    wire   [`BUS_WIDTH-1:0] quo,rem;
    assign quo = A / B;
    assign rem = A % B;
    assign rem_quo[(`BUS_WIDTH*2)-1:0] = {rem,quo};
    
    genvar i;
    generate
        for(i=0;i<`DIV_SLOT;i=i+1)
        begin:DIV_DFF
            DFF #(`BUS_WIDTH*2) dff_unit (clk,nrst,rem_quo[(`BUS_WIDTH*2)*i+(`BUS_WIDTH*2-1):(`BUS_WIDTH*2)*i],rem_quo[(`BUS_WIDTH*2)*(i+1)+(`BUS_WIDTH*2-1):(`BUS_WIDTH*2)*(i+1)]);
        end
    endgenerate
    
    assign {PH,PL} = rem_quo[(`BUS_WIDTH*2)*(`DIV_SLOT)+(`BUS_WIDTH*2-1):(`BUS_WIDTH*2)*(`DIV_SLOT)];
    `endif
endmodule

//------------------------------//
// Module:      MUL/DIV delay line
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Aug.8
// Description: Since the MUL/DIV module
// takes multiple cycles to get the results,
// this module delay the control signals
// to control the MUL/DIV in the later cycles
//------------------------------//
module Delayline (clk,nrst,Istart,Iabort,Oupdate,Ooccupied);
    input [0:0] clk,nrst;
    input [0:0] Istart;   // start the computation
    input [0:0] Iabort;   // abort the current computation
    output[0:0] Oupdate;  // update the HI/LO reg
    output[0:0] Ooccupied;// indicates if the current unit is occupied
    
    wire  [2*(`DIV_SLOT):0] abort_reg_w;
    wire  [(`DIV_SLOT):0]   start_reg_w;
    
    assign abort_reg_w[0:0]  = Iabort;
    assign start_reg_w[0:0]  = Istart;
    
    generate
        genvar i;
        for (i=0;i<`DIV_SLOT;i=i+1)
        begin: DELAY_DFF
            DFF #(1) ABORT_REG (clk,nrst,abort_reg_w[i*2],abort_reg_w[i*2+1]);
            assign abort_reg_w[(i+1)*2] = abort_reg_w[i*2+1] | abort_reg_w[0:0];
            DFF #(1) START_REG (clk,nrst,start_reg_w[i],start_reg_w[i+1]);
        end
    endgenerate
    
    assign Oupdate   = start_reg_w[`DIV_SLOT] & ~abort_reg_w[(2*`DIV_SLOT)];
    assign Ooccupied = |start_reg_w[`DIV_SLOT-1:0];
endmodule

//------------------------------//
// Module:      Left Shift
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Jan.24
// Description: 
//------------------------------//
module SLL (shamt,Di,Do);
// shamt - shift bit
    input  [`SHAMT_WIDTH-1:0] shamt;
    input  [`BUS_WIDTH-1:0] Di;
    output [`BUS_WIDTH-1:0] Do;
    
    assign Do = Di << shamt;
endmodule
    
//------------------------------//
// Module:      Logical Right Shift
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Jan.24
// Description:
//------------------------------//
module SRL (shamt,Di,Do);
// shamt - shift bit
    input  [`SHAMT_WIDTH-1:0] shamt;
    input  [`BUS_WIDTH-1:0] Di;
    output [`BUS_WIDTH-1:0] Do;
    
    assign Do = Di >> shamt;
endmodule

//------------------------------//
// Module:      Arithmetic Right Shift
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Jan.24
// Description: This module need Verilog-2001 standard compiler
//------------------------------//
module SRA (shamt,Di,Do);
// shamt - shift bit
    input  [`SHAMT_WIDTH-1:0] shamt;
    input  [`BUS_WIDTH-1:0] Di;
    output [`BUS_WIDTH-1:0] Do;
    
    assign Do = Di >>> shamt;
endmodule

//------------------------------//
// Module:      Logic Operations
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Jan.25
// Description: 
//------------------------------//
module AND (A,B,S);
    input  [`BUS_WIDTH-1:0] A,B;
    output [`BUS_WIDTH-1:0] S;
    
    assign S = A & B;
endmodule

module OR (A,B,S);
    input  [`BUS_WIDTH-1:0] A,B;
    output [`BUS_WIDTH-1:0] S;
    
    assign S = A | B;
endmodule

module XOR (A,B,S);
    input  [`BUS_WIDTH-1:0] A,B;
    output [`BUS_WIDTH-1:0] S;
    
    assign S = A ^ B;
endmodule

module NOR (A,B,S);
    input  [`BUS_WIDTH-1:0] A,B;
    output [`BUS_WIDTH-1:0] S;
    
    assign S = ~(A | B);
endmodule

//------------------------------//
// Module:      Compare Operations
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Jan.25
// Description: Some modules need verilog-2001 compiler
//------------------------------//
module LESS (A,B,S);
// need verilog-2001
    input signed [`BUS_WIDTH-1:0] A,B;
    output [`BUS_WIDTH-1:0] S;
    reg    [`BUS_WIDTH-1:0] S;
    
    always@(*)
    begin
        if (A<B)
            S = 1;
        else
            S = 0;
    end
endmodule
    
module LESSU (A,B,S);
    input  [`BUS_WIDTH-1:0] A,B;
    output [`BUS_WIDTH-1:0] S;
    reg    [`BUS_WIDTH-1:0] S;
    
    always@(*)
    begin
        if (A<B)
            S = 1;
        else
            S = 0;
    end
endmodule

module EQUL (A,B,S);
// need verilog-2001
    input signed [`BUS_WIDTH-1:0] A,B;
    output [`BUS_WIDTH-1:0] S;
    reg    [`BUS_WIDTH-1:0] S;
    
    always@(*)
    begin
        if (A==B)
            S <= 1;
        else
            S <= 0;
    end
endmodule

module LARG (A,B,S);
// need verilog-2001
    input signed [`BUS_WIDTH-1:0] A,B;
    output [`BUS_WIDTH-1:0] S;
    reg    [`BUS_WIDTH-1:0] S;
    
    always@(*)
    begin
        if (A>B)
            S = 1;
        else
            S = 0;
    end
endmodule

//------------------------------//
// Module:      funct Control Signal Generation
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Aug.8
// Description: This module takes the 6-bit "funct" section as
//              the input, and decode it to three bunches of signals
//              When the op=0, this module is sending out the ctrl signals
// Note:
// toEXE[11]=1    -> is store instructions
// toEXE[10:9]=00 -> select (rt) for sw (default)
// toEXE[10:9]=01 -> select result for sh
// toEXE[10:9]=10 -> select result for sb        
// toEXE[8]=1     ->  mthi
// toEXE[7]=1     ->  mtlo
// toEXE[6]=1     ->  jump register (jr)
// toEXE[5]=1     ->  jump-like instruction
// toEXE[4:3]=00  ->  select (rs)
// toEXE[4:3]=01  ->  select sa
// toEXE[4:3]=10  ->  select 16
// toEXE[2:1]=00  ->  select (rt)
// toEXE[2:1]=01  ->  select imm
// toEXE[2:1]=10  ->  select 0
// toEXE[0]=0     ->  Reg_Dst = rt
// toEXE[0]=1     ->  Reg_Dst = rd
//
// toMEM[7:5]=000 ->  select MEM_R_Data (default)
// toMEM[7:5]=001 ->  select result for lhu
// toMEM[7:5]=010 ->  select result for lh
// toMEM[7:5]=011 ->  select result for lbu
// toMEM[7:5]=100 ->  select result for lb
// toMEM[4]=1  ->  is a branch instruction (include jxx and bxx)
// toMEM[3]=1  ->  MEM_Write
// toMEM[2]=1  ->  MEM_Read
// toMEM[1]=1  ->  select update PC
// toMEM[0]=1  ->  if jump-like instruction
//
// toWB[5]=1      -> REG_Write
// toWB[4:2]=000  -> select MEM_Data
// toWB[4:2]=001  -> select ALU_Res
// toWB[4:2]=010  -> select Next_PC
// toWB[4:2]=011  -> select HI
// toWB[4:2]=100  -> select LO
//------------------------------//
module FUNCtoCTRL (funct, toEXE, toMEM, toWB);
    input  [`FUNCT_WIDTH-1:0]   funct;
    output [`CTRLEXE_WIDTH-1:0] toEXE;
    output [`CTRLMEM_WIDTH-1:0] toMEM;
    output [`CTRLWB_WIDTH-1:0]  toWB;
    
    reg    [`CTRLEXE_WIDTH-1:0] toEXE;
    reg    [`CTRLMEM_WIDTH-1:0] toMEM;
    reg    [`CTRLWB_WIDTH-1:0]  toWB;
    
    // decoder
    always@(funct)
    begin
		case(funct)
            `FUNCT_WIDTH'b000000:  begin // sll rd, rt, shamnt
                        toEXE = `CTRLEXE_WIDTH'b000000001001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `FUNCT_WIDTH'b000010:  begin // srl rd, rt, shamnt
                        toEXE = `CTRLEXE_WIDTH'b000000001001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `FUNCT_WIDTH'b000011:  begin // sra rd, rt, shamnt
                        toEXE = `CTRLEXE_WIDTH'b000000001001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `FUNCT_WIDTH'b000100:  begin // sllv rd, rt, rs
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `FUNCT_WIDTH'b000110:  begin // srlv rd, rt, rs
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `FUNCT_WIDTH'b000111:  begin // srav rd, rt, rs
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `FUNCT_WIDTH'b001000:  begin // jr rs
                        toEXE = `CTRLEXE_WIDTH'b000001000000;
                        toMEM = `CTRLMEM_WIDTH'b00000010;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            `FUNCT_WIDTH'b001001:  begin // jalr rs, rd
                        toEXE = `CTRLEXE_WIDTH'b000001000001;
                        toMEM = `CTRLMEM_WIDTH'b00000010;
                        toWB  = `CTRLWB_WIDTH'b101000;
                        end
            `FUNCT_WIDTH'b010000:  begin // mfhi rd
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b101100;
                        end
            `FUNCT_WIDTH'b010001:  begin // mthi rs
                        toEXE = `CTRLEXE_WIDTH'b000100010000;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b000110;
                        end
            `FUNCT_WIDTH'b010010:  begin // mflo rd
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b110000;
                        end
            `FUNCT_WIDTH'b010011:  begin // mtlo rs
                        toEXE = `CTRLEXE_WIDTH'b000010000000;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b000101;
                        end
            `FUNCT_WIDTH'b011000:  begin // mult rs, rt
                        toEXE = `CTRLEXE_WIDTH'b000000000000;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b000111;
                        end
            `FUNCT_WIDTH'b011001:  begin // multu rs, rt
                        toEXE = `CTRLEXE_WIDTH'b000000000000;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b000111;
                        end
            `FUNCT_WIDTH'b011010:  begin // div rs, rt
                        toEXE = `CTRLEXE_WIDTH'b000000000000;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b000111;
                        end
            `FUNCT_WIDTH'b011011:  begin // divu rs, rt
                        toEXE = `CTRLEXE_WIDTH'b000000000000;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b000111;
                        end
            `FUNCT_WIDTH'b100000:  begin // add rd, rs, rt
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `FUNCT_WIDTH'b100001:  begin // addu rd, rs, rt
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `FUNCT_WIDTH'b100010:  begin // sub rd, rs, rt
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `FUNCT_WIDTH'b100011:  begin // subu rd, rs, rt
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `FUNCT_WIDTH'b100100:  begin // and rd, rs, rt
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `FUNCT_WIDTH'b100101:  begin // or rd, rs, rt
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `FUNCT_WIDTH'b100110:  begin // xor rd, rs, rt
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `FUNCT_WIDTH'b100111:  begin // nor rd, rs, rt
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `FUNCT_WIDTH'b101010:  begin // slt rd, rs, rt
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `FUNCT_WIDTH'b101011:  begin // sltu rd, rs, rt
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            default:    begin // NOTE: should not be here
                        toEXE = `CTRLEXE_WIDTH'bxxxxxxxxxxxx;
                        toMEM = `CTRLMEM_WIDTH'bxxxxxxxx;
                        toWB  = `CTRLWB_WIDTH'bxxxxxx;
                        end
        endcase
    end
endmodule

//------------------------------//
// Module:      rt Control Signal Generation
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Jan.30
// Description: This module takes the 5-bit "rt" section as
//              the input, and decode it to three bunches of signals
//              When the op=1, this module is sending out the ctrl signals
// Note:        In these four cases, the outputs are the same.
//              So we include these four cases into one case in module OPtoCTRL
//------------------------------//
module RTtoCTRL (rt, toEXE, toMEM, toWB);
    input  [`RT_WIDTH-1:0]      rt;
    output [`CTRLEXE_WIDTH-1:0] toEXE;
    output [`CTRLMEM_WIDTH-1:0] toMEM;
    output [`CTRLWB_WIDTH-1:0]  toWB;
	
    reg [`CTRLEXE_WIDTH-1:0] toEXE;
    reg [`CTRLMEM_WIDTH-1:0] toMEM;
    reg [`CTRLWB_WIDTH-1:0]  toWB;
    
    always@(rt)
    begin
        case(rt)
            `RT_WIDTH'b00000:   begin // bltz rs, label
                        toEXE = `CTRLEXE_WIDTH'b000000000100;
                        toMEM = `CTRLMEM_WIDTH'b00010000;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            `RT_WIDTH'b00001:   begin // bgez rs, label
                        toEXE = `CTRLEXE_WIDTH'b000000000100;
                        toMEM = `CTRLMEM_WIDTH'b00010000;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            `RT_WIDTH'b10001:   begin // bgezal rs, label
                        toEXE = `CTRLEXE_WIDTH'b000000000100;
                        toMEM = `CTRLMEM_WIDTH'b00010000;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            `RT_WIDTH'b10000:   begin // bltzal rs, label
                        toEXE = `CTRLEXE_WIDTH'b000000000100;
                        toMEM = `CTRLMEM_WIDTH'b00010000;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            default:    begin // NOTE: should not be here
                        toEXE = `CTRLEXE_WIDTH'bxxxxxxxxxxxx;
                        toMEM = `CTRLMEM_WIDTH'bxxxxxxxx;
                        toWB  = `CTRLWB_WIDTH'bxxxxxx;
                        end
        endcase
    end
endmodule

//------------------------------//
// Module:      OP Control Signal Generation
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Jan.30
// Description: This module takes the 6-bit "op" section as
//              the input, and decode it to three bunches of signals
//              When the op!=0, this module is sending out the ctrl signals
// Note:        when op=1, there are four instructions, we include them together in 
//              this module.
//              Insert bubble isn't supported in this module
//------------------------------//
module OPtoCTRL (op, toEXE, toMEM, toWB);
    input  [`OP_WIDTH-1:0]      op;
    output [`CTRLEXE_WIDTH-1:0] toEXE;
    output [`CTRLMEM_WIDTH-1:0] toMEM;
    output [`CTRLWB_WIDTH-1:0]  toWB;
	
    reg [`CTRLEXE_WIDTH-1:0] toEXE;
    reg [`CTRLMEM_WIDTH-1:0] toMEM;
    reg [`CTRLWB_WIDTH-1:0]  toWB;
    
    // decoder
    always@(op)
    begin
        case(op)
            `OP_WIDTH'b000000:  begin // for nothing
                        toEXE = `CTRLEXE_WIDTH'b000000000000;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b000000;
                        end
            `OP_WIDTH'b000001:  begin // for bgez,bgezal,bltz,bltzal
                        toEXE = `CTRLEXE_WIDTH'b000000000101;
                        toMEM = `CTRLMEM_WIDTH'b00010000;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            `OP_WIDTH'b000010:  begin // j target
                        toEXE = `CTRLEXE_WIDTH'b000000100000;
                        toMEM = `CTRLMEM_WIDTH'b00000001;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            `OP_WIDTH'b000011:  begin // jal target
                        toEXE = `CTRLEXE_WIDTH'b000000100000;
                        toMEM = `CTRLMEM_WIDTH'b00000001;
                        toWB  = `CTRLWB_WIDTH'b101000;
                        end
            `OP_WIDTH'b000100:  begin // beq rs, rt, label
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00010000;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            `OP_WIDTH'b000101:  begin // bne rs, rt, label
                        toEXE = `CTRLEXE_WIDTH'b000000000001;
                        toMEM = `CTRLMEM_WIDTH'b00010000;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            `OP_WIDTH'b000110:  begin // blez rs, label
                        toEXE = `CTRLEXE_WIDTH'b000000000101;
                        toMEM = `CTRLMEM_WIDTH'b00010000;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            `OP_WIDTH'b000111:  begin // bgtz rs, label
                        toEXE = `CTRLEXE_WIDTH'b000000000101;
                        toMEM = `CTRLMEM_WIDTH'b00010000;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            `OP_WIDTH'b001000:  begin // addi rt, rs, imm
                        toEXE = `CTRLEXE_WIDTH'b000000000010;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `OP_WIDTH'b001001:  begin // addiu rt, rs, imm
                        toEXE = `CTRLEXE_WIDTH'b000000000010;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `OP_WIDTH'b001010:  begin // slti rt, rs, imm
                        toEXE = `CTRLEXE_WIDTH'b000000000010;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `OP_WIDTH'b001011:  begin // sltiu rt, rs, imm
                        toEXE = `CTRLEXE_WIDTH'b000000000010;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `OP_WIDTH'b001100:  begin // andi rt, rs, imm
                        toEXE = `CTRLEXE_WIDTH'b000000000010;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `OP_WIDTH'b001101:  begin // ori rt, rs, imm
                        toEXE = `CTRLEXE_WIDTH'b000000000010;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `OP_WIDTH'b001110:  begin // xori rt, rs, imm
                        toEXE = `CTRLEXE_WIDTH'b000000000010;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `OP_WIDTH'b001111:  begin // lui rt, imm
                        toEXE = `CTRLEXE_WIDTH'b000000010010;
                        toMEM = `CTRLMEM_WIDTH'b00000000;
                        toWB  = `CTRLWB_WIDTH'b100100;
                        end
            `OP_WIDTH'b100000:  begin // lb rt, address
                        toEXE = `CTRLEXE_WIDTH'b000000000010;
                        toMEM = `CTRLMEM_WIDTH'b10000100;
                        toWB  = `CTRLWB_WIDTH'b100000;
                        end
            `OP_WIDTH'b100001:  begin // lh rt, address
                        toEXE = `CTRLEXE_WIDTH'b000000000010;
                        toMEM = `CTRLMEM_WIDTH'b01000100;
                        toWB  = `CTRLWB_WIDTH'b100000;
                        end
            `OP_WIDTH'b100010:  begin // lwl rt, address
                        toEXE = `CTRLEXE_WIDTH'b000000000010;
                        toMEM = `CTRLMEM_WIDTH'b00000100;
                        toWB  = `CTRLWB_WIDTH'b100000;
                        end
            `OP_WIDTH'b100011:  begin // lw rt, address
                        toEXE = `CTRLEXE_WIDTH'b000000000010;
                        toMEM = `CTRLMEM_WIDTH'b00000100;
                        toWB  = `CTRLWB_WIDTH'b100000;
                        end
            `OP_WIDTH'b100100:  begin // lbu rt, address
                        toEXE = `CTRLEXE_WIDTH'b000000000010;
                        toMEM = `CTRLMEM_WIDTH'b01100100;
                        toWB  = `CTRLWB_WIDTH'b100000;
                        end
            `OP_WIDTH'b100101:  begin // lhu rt, address
                        toEXE = `CTRLEXE_WIDTH'b000000000010;
                        toMEM = `CTRLMEM_WIDTH'b00100100;
                        toWB  = `CTRLWB_WIDTH'b100000;
                        end
            `OP_WIDTH'b100110:  begin // lwr rt, address
                        toEXE = `CTRLEXE_WIDTH'b000000000010;
                        toMEM = `CTRLMEM_WIDTH'b00000100;
                        toWB  = `CTRLWB_WIDTH'b100000;
                        end
            `OP_WIDTH'b101000:  begin // sb rt, address
                        toEXE = `CTRLEXE_WIDTH'b110000000010;
                        toMEM = `CTRLMEM_WIDTH'b00001000;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            `OP_WIDTH'b101001:  begin // sh rt, address
                        toEXE = `CTRLEXE_WIDTH'b101000000010;
                        toMEM = `CTRLMEM_WIDTH'b00001000;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            `OP_WIDTH'b101010:  begin // swl rt, address
                        toEXE = `CTRLEXE_WIDTH'b100000000010;
                        toMEM = `CTRLMEM_WIDTH'b00001000;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            `OP_WIDTH'b101011:  begin // sw rt, address 
                        toEXE = `CTRLEXE_WIDTH'b100000000010;
                        toMEM = `CTRLMEM_WIDTH'b00001000;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            `OP_WIDTH'b101110:  begin // swr rt, address 
                        toEXE = `CTRLEXE_WIDTH'b100000000010;
                        toMEM = `CTRLMEM_WIDTH'b00001000;
                        toWB  = `CTRLWB_WIDTH'b000100;
                        end
            default:    begin // NOTE: should not be here
                        toEXE = `CTRLEXE_WIDTH'bxxxxxxxxxxxx;
                        toMEM = `CTRLMEM_WIDTH'bxxxxxxxx;
                        toWB  = `CTRLWB_WIDTH'bxxxxxx;
                        end
        endcase
    end
endmodule            
            
//------------------------------//
// Module:      Sequential modules
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Jan.30
// Description: 
//------------------------------//
module DFF (clk,nrst,Di,Do);
	parameter BW = `BUS_WIDTH;
    input  [0:0]    clk,nrst;
    input  [BW-1:0] Di;
    output [BW-1:0] Do;
    
    reg    [BW-1:0] Do;
    
    always@(posedge clk)
    begin
        if (!nrst)
            Do <= 0;
        else
            Do <= Di;
    end
endmodule

module DFF_PC (clk,nrst,Di,Do);
    input  [0:0]    clk,nrst;
    input  [`BUS_WIDTH-1:0] Di;
    output [`BUS_WIDTH-1:0] Do;
    
    reg    [`BUS_WIDTH-1:0] Do;
    
    always@(posedge clk)
    begin
        if (!nrst)
            Do <= `BUS_WIDTH'hfffffffc;
        else
            Do <= Di;
    end
endmodule

//------------------------------//
// Module:      Clock Divider
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Aug.30
// Description: This block times the input clock period by 2
//              for the non-REGFile block
//------------------------------//
module clock_divider(clk2,nrst,clk);
	input [0:0] clk2,nrst; // quicker
	output[0:0] clk;  // 2 times slower
	
	`ifdef DCM_IP
	// connect the DCM IP
	reg [0:0] counter=0;
	always@(posedge clk2)
	begin
			counter <= counter+1;
	end
		
	assign clk = counter;
	`else
	reg [0:0] counter=0;
	always@(posedge clk2)
	begin
			counter <= counter+1;
	end
		
	assign clk = counter;
	`endif
endmodule


//------------------------------//
// Module:      Zero Checker
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Mar.11
// Description: Check if input is zero
//              Used in ALU
//------------------------------//
module checkZero (Input,Zero);
    input  [`BUS_WIDTH-1:0] Input;
    output [0:0]            Zero;
    
    reg    [0:0]  Zero;
    
    always@(*)
    begin
        if (Input==0) begin
            Zero = 1'b1;
        end else begin
            Zero = 1'b0;
        end
    end
endmodule

//------------------------------//
// Module:      Global Counter
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Sep.18
// Description: To locate the problem cycle in debugging
//------------------------------//
module GlobalCounter (clk,nrst,count);
	input [0:0] clk,nrst;
	output [`BUS_WIDTH-1:0] count;

	reg [`BUS_WIDTH-1:0] count;
	
	always@(posedge clk)
	begin
		if (nrst==1'b0)
			count <= {`BUS_WIDTH{1'b0}};
		else
			count <= count + 1;
	end
endmodule

//------------------------------//
// Module:      Selection
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.June.20
// Description: Used in ALU to select
// the needed result
//------------------------------//
module SELECTOR (Ictrl,Ir1,Ir2,Ir3,Ir4,Ir5,
                 //Ir6a,Ir6b,Ir7a,Ir7b,
                 //Ir8a,Ir8b,Ir9a,Ir9b,
                 Ir10,Ir11,Ir12,Ir13,Ir14,
                 Ir15,Ir16,Ir17,Ozero,Ores);
// The Ictrl control the mux to select the needed output.
// Ictrl[6:0]:
// Ictrl[6]  : For subtraction
// Ictrl[5]  : Control the XOR gate to do the negation. (for != or similar operation)
// Ictrl[4:0]: 1 - sll
//             2 - srl
//             3 - sra
//             4 - +
//             5 - +u (unsigned)
//             6 - *   //this does not belong to alu anymore
//             7 - *u  //this does not belong to alu anymore
//             8 - /   //this does not belong to alu anymore
//             9 - /u  //this does not belong to alu anymore
//            10 - and
//            11 - or
//            12 - xor
//            13 - nor
//            14 - <
//            15 - <u
//            16 - ==
//            17 - >
    input  [`ICTRL_WIDTH-1:0]  Ictrl;
    input  [`BUS_WIDTH-1:0] Ir1,Ir2,Ir3,Ir4,Ir5,
                  //Ir6a,Ir6b,Ir7a,Ir7b,
                  //Ir8a,Ir8b,Ir9a,Ir9b,
                  Ir10,Ir11,Ir12,Ir13,Ir14,
                  Ir15,Ir16,Ir17;
    output [0:0]  Ozero;
    output [`BUS_WIDTH-1:0] Ores;
    
    reg    [`BUS_WIDTH-1:0] res;
    
    always@(*)
    begin
        case(Ictrl[4:0]) //Ictrl[4:0]
        5'b00001: res = Ir1;
        5'b00010: res = Ir2;
        5'b00011: res = Ir3;
        5'b00100: res = Ir4;
        5'b00101: res = Ir5;
        //5'b00110: res = Ir6a;
        //5'b00111: res = Ir7a;
        //5'b01000: res = Ir8a;
        //5'b01001: res = Ir9a;
        5'b01010: res = Ir10;
        5'b01011: res = Ir11;
        5'b01100: res = Ir12;
        5'b01101: res = Ir13;
        5'b01110: res = Ir14;
        5'b01111: res = Ir15;
        5'b10000: res = Ir16;
        5'b10001: res = Ir17;
        default : res = 32'b0;
        endcase
    end
    
    // use Ictrl[5] to control the XOR for negation or similar operation
    // currently, I only negated on the lsb
    wire  [`BUS_WIDTH-1:0] res_negation;
    assign res_negation[0]              = res[0] ^ Ictrl[5];
    assign res_negation[`BUS_WIDTH-1:1] = res[31:1];
    
    checkZero zerodetect (res_negation,Ozero);
    assign Ores = res_negation;
endmodule

//------------------------------//
// Module:      Arithmetic Logic Unit
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.June.20
// Description: 
//------------------------------//
module ALU (
    Iop0,Iop1,
    Ictrl,
    Ozero,Oresult);
    input  [`BUS_WIDTH-1:0] Iop0,Iop1;
    input  [`ICTRL_WIDTH-1:0]  Ictrl;
    output [0:0]  Ozero;
    output [`BUS_WIDTH-1:0] Oresult;
    
// The Ictrl control the mux to select the needed output.
// Ictrl[6:0]:
// Ictrl[6]  : For subtraction
// Ictrl[5]  : Control the XOR gate to do the negation. (I forgot how to use it, leave it now
// Ictrl[4:0]: 1 - sll
//             2 - srl
//             3 - sra
//             4 - +
//             5 - +u (unsigned)
//             6 - *   //this does not belong to alu anymore
//             7 - *u  //this does not belong to alu anymore
//             8 - /   //this does not belong to alu anymore
//             9 - /u  //this does not belong to alu anymore
//            10 - and
//            11 - or
//            12 - xor
//            13 - nor
//            14 - <
//            15 - <u
//            16 - ==
//            17 - >
    wire [`BUS_WIDTH-1:0] result1,result2,result3,result4,result5,
                //result6_H,result6_L,result7_H,result7_L,
                //result8_H,result8_L,result9_H,result9_L,
                result10,result11,result12,result13,result14,
                result15,result16,result17;
    wire [0:0]  OV;
    wire [`BUS_WIDTH-1:0] zero;
    assign zero = {`BUS_WIDTH{1'b0}};
    
    SLL     ALU1 (Iop1[4:0],Iop0,result1);
    SRL     ALU2 (Iop1[4:0],Iop0,result2);
    SRA     ALU3 (Iop1[4:0],Iop0,result3);
    
    ADD     ALU4 (Iop1,Iop0,Ictrl[6],OV,result4);
    ADDU    ALU5 (Iop1,Iop0,Ictrl[6],result5);
    //MUL     ALU6 (Iop1,Iop0,result6_H,result6_L);
    //MULU    ALU7 (Iop1,Iop0,result7_H,result7_L);
    //DIV     ALU8 (Iop1,Iop0,result8_H,result8_L);
    //DIVU    ALU9 (Iop1,Iop0,result9_H,result9_L);
    
    AND     ALU10 (Iop1,Iop0,result10);
    OR      ALU11 (Iop1,Iop0,result11);
    XOR     ALU12 (Iop1,Iop0,result12);
    NOR     ALU13 (Iop1,Iop0,result13);
    
    LESS    ALU14 (Iop1,Iop0,result14);
    LESSU   ALU15 (Iop1,Iop0,result15);
    EQUL    ALU16 (Iop1,Iop0,result16);
    LARG    ALU17 (Iop1,Iop0,result17);
    
    SELECTOR ALU_MUX (Ictrl,
                      result1,result2,result3,result4,result5,
                      //zero,zero,zero,zero,
                      //zero,zero,zero,zero,
                      result10,result11,result12,result13,
                      result14,result15,result16,result17,
                      Ozero,Oresult);
    
endmodule



//------------------------------//
// Module:      MUL/DIV block
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.June.20
// Description: 
//------------------------------//
module MUL_DIV_BLOCK (
    clk,nrst,
    Istart,
    Iabort,
    Iop0,Iop1,
    Oresult_H,Oresult_L,
    Oupdate,
    Ooccupied);
    
    input [0:0]  clk,nrst;
    input [3:0]  Istart;    // enable the computation: 00-mul;01-unmul;10-div;11-undiv
    input [3:0]  Iabort;    // abort the current computation: 00-mul;01-unmul;10-div;11-undiv
    input [`BUS_WIDTH-1:0] Iop0,Iop1; 
    output[`BUS_WIDTH-1:0] Oresult_H,Oresult_L;
    output[0:0]  Oupdate;
    output[3:0]  Ooccupied; // computing units are occupied: 0001-mul;0010-unmul;0100-div;1000-undiv
     
    wire  [`BUS_WIDTH-1:0] signedMUL_H,signedMUL_L,unsignedMUL_H,unsignedMUL_L,
                           signedDIV_H,signedDIV_L,unsignedDIV_H,unsignedDIV_L;
    
    // 1. create MUL/DIV
    MUL     ALU6 (clk,nrst,Iop1,Iop0,signedMUL_H,signedMUL_L);
    MULU    ALU7 (clk,nrst,Iop1,Iop0,unsignedMUL_H,unsignedMUL_L);
    DIV     ALU8 (clk,nrst,Iop1,Iop0,signedDIV_H,signedDIV_L);
    DIVU    ALU9 (clk,nrst,Iop1,Iop0,unsignedDIV_H,unsignedDIV_L);
    
    // 2. create MUL/DIV delayline
    wire [1:0] Delayed_Isel_w;
    wire [0:0] update_sMUL,
               update_unsMUL,
               update_sDIV,
               update_unsDIV;
               
    Delayline Delayline_signedMUL_u   (clk,nrst,Istart[0],Iabort[0],update_sMUL  ,Ooccupied[0]);
    Delayline Delayline_unsignedMUL_u (clk,nrst,Istart[1],Iabort[1],update_unsMUL,Ooccupied[1]);
    Delayline Delayline_signedDIV_u   (clk,nrst,Istart[2],Iabort[2],update_sDIV  ,Ooccupied[2]);
    Delayline Delayline_unsignedDIV_u (clk,nrst,Istart[3],Iabort[3],update_unsDIV,Ooccupied[3]);
    
    assign Oupdate = update_sMUL | update_unsMUL | update_sDIV | update_unsDIV;
    // if update_sMUL   = 1 then Delayed_Isel_w = 00
    // if update_unsMUL = 1 then Delayed_Isel_w = 01
    // if update_sDIV   = 1 then Delayed_Isel_w = 10
    // if update_unsDIV = 1 then Delayed_Isel_w = 11
    assign Delayed_Isel_w[1] = ~update_unsMUL & ~update_sMUL;
    assign Delayed_Isel_w[0] = ~update_sDIV & ~update_sMUL;
    
    
    // 3. select the result
    reg  [`BUS_WIDTH-1:0] Oresult_H,Oresult_L;
    
    always@(*) // mux
    begin
        case(Delayed_Isel_w)
            2'b00: begin // signed mul
                Oresult_H = signedMUL_H;
                Oresult_L = signedMUL_L;
            end
            2'b01: begin // unsigned mul
                Oresult_H = unsignedMUL_H;
                Oresult_L = unsignedMUL_L;
            end
            2'b10: begin // signed div
                Oresult_H = signedDIV_H;
                Oresult_L = signedDIV_L;
            end
            2'b11: begin // unsigned div
                Oresult_H = unsignedDIV_H;
                Oresult_L = unsignedDIV_L;
            end
        endcase
    end 
endmodule

//------------------------------//
// Module:      ALU control
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Mar.11
// Description: Generate the ALU
// signal Ictrl
//------------------------------//
module ALUctrl (Iop,Ifunct,Irt,Octrl);
    input  [`OP_WIDTH-1:0] Iop,Ifunct;
    input  [`RT_WIDTH-1:0] Irt;
    output [`ICTRL_WIDTH-1:0] Octrl;
    
    reg    [`ICTRL_WIDTH-1:0] ctrl_by_funct,ctrl_by_rt,ctrl_by_op;
    reg    [`ICTRL_WIDTH-1:0] Octrl;
// The Ictrl control the mux to select the needed output.
// Ictrl[6:0]:
// Ictrl[6]  : For subtraction
// Ictrl[5]  : Control the XOR gate to do the negation. (for != or similar operation)
// Ictrl[4:0]: 0 - nothing (output 0)
//             1 - sll
//             2 - srl
//             3 - sra
//             4 - +
//             5 - +u (unsigned)
//             6 - *
//             7 - *u
//             8 - /
//             9 - /u
//            10 - and
//            11 - or
//            12 - xor
//            13 - nor
//            14 - <
//            15 - <u
//            16 - ==
//            17 - >    
    always@(*)
    begin
        case(Iop)
		`OP_WIDTH'b000010: ctrl_by_op = `ICTRL_WIDTH'b0000000; // ==
		`OP_WIDTH'b000011: ctrl_by_op = `ICTRL_WIDTH'b0000000; // ==
        `OP_WIDTH'b000100: ctrl_by_op = `ICTRL_WIDTH'b0010000; // ==
        `OP_WIDTH'b000101: ctrl_by_op = `ICTRL_WIDTH'b0110000; // !=
        `OP_WIDTH'b000110: ctrl_by_op = `ICTRL_WIDTH'b0110001; // <=
        `OP_WIDTH'b000111: ctrl_by_op = `ICTRL_WIDTH'b0010001; // >
        `OP_WIDTH'b001000: ctrl_by_op = `ICTRL_WIDTH'b0000100; // +
        `OP_WIDTH'b001001: ctrl_by_op = `ICTRL_WIDTH'b0000101; // +u
        `OP_WIDTH'b001010: ctrl_by_op = `ICTRL_WIDTH'b0001110; // <
        `OP_WIDTH'b001011: ctrl_by_op = `ICTRL_WIDTH'b0001111; // <u
        `OP_WIDTH'b001100: ctrl_by_op = `ICTRL_WIDTH'b0001010; // and
        `OP_WIDTH'b001101: ctrl_by_op = `ICTRL_WIDTH'b0001011; // or
        `OP_WIDTH'b001110: ctrl_by_op = `ICTRL_WIDTH'b0001100; // xor
        `OP_WIDTH'b001111: ctrl_by_op = `ICTRL_WIDTH'b0000001; // sll
        
        `OP_WIDTH'b100000: ctrl_by_op = `ICTRL_WIDTH'b0000100; // +
        `OP_WIDTH'b100001: ctrl_by_op = `ICTRL_WIDTH'b0000100; // +
        `OP_WIDTH'b100010: ctrl_by_op = `ICTRL_WIDTH'b0000100; // +
        `OP_WIDTH'b100011: ctrl_by_op = `ICTRL_WIDTH'b0000100; // +
        `OP_WIDTH'b100100: ctrl_by_op = `ICTRL_WIDTH'b0000100; // +
        `OP_WIDTH'b100101: ctrl_by_op = `ICTRL_WIDTH'b0000100; // +
        `OP_WIDTH'b100110: ctrl_by_op = `ICTRL_WIDTH'b0000100; // +
        `OP_WIDTH'b101000: ctrl_by_op = `ICTRL_WIDTH'b0000100; // +
        `OP_WIDTH'b101001: ctrl_by_op = `ICTRL_WIDTH'b0000100; // +
        `OP_WIDTH'b101010: ctrl_by_op = `ICTRL_WIDTH'b0000100; // +
        `OP_WIDTH'b101011: ctrl_by_op = `ICTRL_WIDTH'b0000100; // +
        `OP_WIDTH'b101110: ctrl_by_op = `ICTRL_WIDTH'b0000100; // +
        default          : ctrl_by_op = `ICTRL_WIDTH'bxxxxxxx; // default
        endcase
    end

    always@(*)
    begin
        case(Ifunct)
        `FUNCT_WIDTH'b000000: ctrl_by_funct = `ICTRL_WIDTH'b0000001; // sll
        `FUNCT_WIDTH'b000010: ctrl_by_funct = `ICTRL_WIDTH'b0000010; // srl
        `FUNCT_WIDTH'b000011: ctrl_by_funct = `ICTRL_WIDTH'b0000011; // sra
        `FUNCT_WIDTH'b000100: ctrl_by_funct = `ICTRL_WIDTH'b0000001; // sll
        `FUNCT_WIDTH'b000110: ctrl_by_funct = `ICTRL_WIDTH'b0000010; // srl
        `FUNCT_WIDTH'b000111: ctrl_by_funct = `ICTRL_WIDTH'b0000011; // sra
        `FUNCT_WIDTH'b001000: ctrl_by_funct = `ICTRL_WIDTH'b0000100; // +
        `FUNCT_WIDTH'b001001: ctrl_by_funct = `ICTRL_WIDTH'b0000100; // +
        `FUNCT_WIDTH'b011000: ctrl_by_funct = `ICTRL_WIDTH'b0000110; // *
        `FUNCT_WIDTH'b011001: ctrl_by_funct = `ICTRL_WIDTH'b0000111; // *u
        `FUNCT_WIDTH'b011010: ctrl_by_funct = `ICTRL_WIDTH'b0001000; // /
        `FUNCT_WIDTH'b011011: ctrl_by_funct = `ICTRL_WIDTH'b0001001; // /u
        `FUNCT_WIDTH'b100000: ctrl_by_funct = `ICTRL_WIDTH'b0000100; // +
        `FUNCT_WIDTH'b100001: ctrl_by_funct = `ICTRL_WIDTH'b0000101; // +u
        `FUNCT_WIDTH'b100010: ctrl_by_funct = `ICTRL_WIDTH'b1000100; // + with sub
        `FUNCT_WIDTH'b100011: ctrl_by_funct = `ICTRL_WIDTH'b1000101; // +u with sub
        `FUNCT_WIDTH'b100100: ctrl_by_funct = `ICTRL_WIDTH'b0001010; // add
        `FUNCT_WIDTH'b100101: ctrl_by_funct = `ICTRL_WIDTH'b0001011; // or
        `FUNCT_WIDTH'b100110: ctrl_by_funct = `ICTRL_WIDTH'b0001100; // xor
        `FUNCT_WIDTH'b100111: ctrl_by_funct = `ICTRL_WIDTH'b0001101; // nor
        `FUNCT_WIDTH'b101010: ctrl_by_funct = `ICTRL_WIDTH'b0001110; // <
        `FUNCT_WIDTH'b101011: ctrl_by_funct = `ICTRL_WIDTH'b0001111; // <u
        default             : ctrl_by_funct = `ICTRL_WIDTH'bxxxxxxx;
        endcase
    end
    
    always@(*)
    begin
        case(Irt)
        `RT_WIDTH'b00000: ctrl_by_rt = `ICTRL_WIDTH'b0001110; // <
        `RT_WIDTH'b00001: ctrl_by_rt = `ICTRL_WIDTH'b0101110; // >=
        `RT_WIDTH'b10000: ctrl_by_rt = `ICTRL_WIDTH'b0001110; // <
        `RT_WIDTH'b10001: ctrl_by_rt = `ICTRL_WIDTH'b0101110; // >=
        default         : ctrl_by_rt = `ICTRL_WIDTH'bxxxxxxx;
        endcase
    end
    
    always@(*)
    begin
        if (Iop == `OP_WIDTH'b000000)
            Octrl = ctrl_by_funct;
        else if (Iop == `OP_WIDTH'b000001)
            Octrl = ctrl_by_rt;
        else
            Octrl = ctrl_by_op;
    end
endmodule



//----------------------------------------------------------------------------------------------------------------//
// Section 2: Define the five pipeline stages
//----------------------------------------------------------------------------------------------------------------//
//------------------------------//
// Module:      Instruction Fetch
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.June.20
// Description: 
//------------------------------//
module IFstage (
    // control signals
    clk,nrst,stall,
    // input signals
    I_Update_PC,
    I_Target_Addr,
    // output signals
    O_Next_PC,
    O_Instruction);
    
    input  [0:0]  clk,nrst,stall;
    input  [0:0]  I_Update_PC;   // signal to update PC, used in jump instrction
    input  [`BUS_WIDTH-1:0] I_Target_Addr; // indicates the target address, used in jump instruction
    output [`BUS_WIDTH-1:0] O_Next_PC;     // address for "next instruction", used in link instruction
    output [`BUS_WIDTH-1:0] O_Instruction; // current instruction
    
    wire   [`BUS_WIDTH-1:0] curPC_r;
    wire   [`BUS_WIDTH-1:0] nextPC_w;
    reg    [`BUS_WIDTH-1:0] newPC_w;
    reg    [`BUS_WIDTH-1:0] tobeupdatePC_w;
    
    // constant adder to update PC by adding 4
    ADD4 UpdatePC (curPC_r,nextPC_w);
    
    // check if update PC by jump instruction
    always@(*)
    begin
        if (I_Update_PC==1'b1)
            newPC_w = I_Target_Addr;
        else
            newPC_w = nextPC_w;
    end
    
    // stall mux
    always@(*)
    begin
        if (stall==1'b1)
            tobeupdatePC_w = curPC_r;
        else
            tobeupdatePC_w = newPC_w;
    end
    
    // PC register
    DFF_PC PCreg     (clk,nrst,tobeupdatePC_w,curPC_r);
    
    // instruction memory
	`ifdef ICACHE_IP
	// ICache has input register, use it to replace PC, and keep PC for saving current PC.
	ProgramMEM InstructionMEM (clk,nrst,tobeupdatePC_w,O_Instruction);
	`else
    ProgramMEM InstructionMEM (clk,nrst,tobeupdatePC_w,O_Instruction);
	`endif
    
    // send out the newPC
    assign O_Next_PC = nextPC_w;
    
endmodule

//------------------------------//
// Module:      Instruction Decode
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.June.20
// Description: 
//------------------------------//
module IDstage (
    // control signals
    clk,clk2,nrst,
    // input signals
    I_Instruction,
	I_Instruction_NOREG,
    I_Next_PC,
    I_Reg_Write,
    I_Reg_Write_Addr,
    I_Reg_Write_Data,
    // output signals
    O_Immediate,
    O_rt_Addr,
    O_rs_Addr,
    O_rd_Addr,
    O_rs_Data,
    O_rt_Data,
    O_Shamt,
    O_Target_Addr,
    O_Next_PC,
    O_op,
    O_ctrl_WB,
    O_ctrl_MEM,
    O_ctrl_EXE);
    
    input  [0:0]  clk,clk2,nrst;
    input  [0:0]  I_Reg_Write;      // signal to enable write back to the reg 
    input  [`BUS_WIDTH-1:0] I_Instruction;    // current instruction
	input  [`BUS_WIDTH-1:0] I_Instruction_NOREG;    // current instruction without registers from last stage
    input  [`BUS_WIDTH-1:0] I_Next_PC;        // addr for "next instruction", used in link and branch instruction
    input  [`REG_WIDTH-1:0] I_Reg_Write_Addr; // write addr
    input  [`BUS_WIDTH-1:0] I_Reg_Write_Data; // write data
    
    output [`BUS_WIDTH-1:0]     O_Immediate;         // immediate or offset after sign extension
    output [`REG_WIDTH-1:0]     O_rt_Addr,O_rs_Addr,O_rd_Addr; // Reg addr, used in instruction write back to destination reg
    output [`BUS_WIDTH-1:0]     O_rs_Data,O_rt_Data; // Reg data, operand 1 and 0
    output [`SHAMT_WIDTH-1:0]   O_Shamt;             // shift amount, used in instruction: sll, srl and sra
    output [`JMPADDR_WIDTH-1:0] O_Target_Addr;       // target address, used in jump instruction
    output [`BUS_WIDTH-1:0]     O_Next_PC;           // address for "next instruction", used in link and branch instruction
    output [`CTRLWB_WIDTH-1:0]  O_ctrl_WB;           // ctrl signal
    output [`CTRLEXE_WIDTH-1:0] O_ctrl_EXE;          // ctrl signal
    output [`CTRLMEM_WIDTH-1:0] O_ctrl_MEM;          // ctrl signal
    output [`OP_WIDTH-1:0]      O_op;                // op segment, for alu controller
    
    wire   [`CTRLEXE_WIDTH-1:0] CTRL_toEXE_funct_w,CTRL_toEXE_rt_w,CTRL_toEXE_op_w;
    wire   [`CTRLMEM_WIDTH-1:0] CTRL_toMEM_funct_w,CTRL_toMEM_rt_w,CTRL_toMEM_op_w;
    wire   [`CTRLWB_WIDTH-1:0]  CTRL_toWB_funct_w,CTRL_toWB_rt_w,CTRL_toWB_op_w;
    reg    [0:0]  CTRL_select_FUNCtoCTRL_w,CTRL_select_RTtoCTRL_w,CTRL_select_OPtoCTRL_w;
      
    // create regfile
    wire   [`REG_WIDTH-1:0]  rs_addr_w,rt_addr_w;
    assign rs_addr_w = I_Instruction_NOREG[25:21];
    assign rt_addr_w = I_Instruction_NOREG[20:16];
    RegFile RegisterFile (clk,clk2,nrst,rs_addr_w,rt_addr_w,I_Reg_Write_Addr,I_Reg_Write_Data,I_Reg_Write,
                          O_rs_Data,O_rt_Data);
    
    // create ctrl signals
    // if OP='000000', select FUNCtoCTRL
    // if OP='000001', select RTtoCTRL
    // if OP!='000000' and OP!='000001', select OPtoCTRL
    wire   [`FUNCT_WIDTH-1:0] funct_w;
    wire   [`OP_WIDTH-1:0]    op_w;
    assign funct_w   = I_Instruction[5:0];
    assign op_w      = I_Instruction[31:26];
    FUNCtoCTRL CTRLgen_funct (funct_w, CTRL_toEXE_funct_w, CTRL_toMEM_funct_w, CTRL_toWB_funct_w);
    RTtoCTRL   CTRLgen_rt    (rt_addr_w, CTRL_toEXE_rt_w, CTRL_toMEM_rt_w, CTRL_toWB_rt_w);
    OPtoCTRL   CTRLgen_op    (op_w, CTRL_toEXE_op_w, CTRL_toMEM_op_w, CTRL_toWB_op_w);
    
    //generate the selection signal (hotone encoding)
    always@(*)
    begin
		if      (I_Instruction=={`BUS_WIDTH{1'b0}}) begin // nop
			CTRL_select_FUNCtoCTRL_w = 1'b0;              // the control signals are all zeros
            CTRL_select_RTtoCTRL_w   = 1'b0;
            CTRL_select_OPtoCTRL_w   = 1'b0;
        end
        else if (op_w==`OP_WIDTH'b000000) begin
            CTRL_select_FUNCtoCTRL_w = 1'b1;
            CTRL_select_RTtoCTRL_w   = 1'b0;
            CTRL_select_OPtoCTRL_w   = 1'b0;
        end
        else if (op_w==`OP_WIDTH'b000001) begin
            CTRL_select_FUNCtoCTRL_w = 1'b0;
            CTRL_select_RTtoCTRL_w   = 1'b1;
            CTRL_select_OPtoCTRL_w   = 1'b0;
        end else begin
            CTRL_select_FUNCtoCTRL_w = 1'b0;
            CTRL_select_RTtoCTRL_w   = 1'b0;
            CTRL_select_OPtoCTRL_w   = 1'b1;
        end
    end
    
    //create selector
    generate
        genvar i;
        for (i=0;i<`CTRLEXE_WIDTH;i=i+1)
        begin: selector_EXE
            assign O_ctrl_EXE[i]= CTRL_toEXE_funct_w[i] & CTRL_select_FUNCtoCTRL_w | 
                                  CTRL_toEXE_rt_w[i]    & CTRL_select_RTtoCTRL_w   | 
                                  CTRL_toEXE_op_w[i]    & CTRL_select_OPtoCTRL_w;
        end
    endgenerate
    
    generate
        genvar j;
        for (j=0;j<`CTRLMEM_WIDTH;j=j+1)
        begin: selector_MEM
            assign O_ctrl_MEM[j]= CTRL_toMEM_funct_w[j] & CTRL_select_FUNCtoCTRL_w | 
                                  CTRL_toMEM_rt_w[j]    & CTRL_select_RTtoCTRL_w   | 
                                  CTRL_toMEM_op_w[j]    & CTRL_select_OPtoCTRL_w;
        end
    endgenerate
    
    generate
        genvar k;
        for (k=0;k<`CTRLWB_WIDTH;k=k+1)
        begin: selector_WB
            assign O_ctrl_WB[k] = CTRL_toWB_funct_w[k] & CTRL_select_FUNCtoCTRL_w | 
                                  CTRL_toWB_rt_w[k]    & CTRL_select_RTtoCTRL_w   | 
                                  CTRL_toWB_op_w[k]    & CTRL_select_OPtoCTRL_w;
        end
    endgenerate
    
    // assign output signals
    assign O_Shamt       = I_Instruction[10:6];
    assign O_rt_Addr     = I_Instruction[20:16];
    assign O_rs_Addr     = I_Instruction[25:21];
    assign O_rd_Addr     = I_Instruction[15:11];
    assign O_Target_Addr = I_Instruction[25:0];
    assign O_Next_PC     = I_Next_PC;
    assign O_op          = I_Instruction[31:26];
    
    // sign extension
    assign O_Immediate   = {{16{I_Instruction[15]}},I_Instruction[15:0]};
    
endmodule

//------------------------------//
// Module:      Execution Stage
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.April.1
// Description: 
//------------------------------//
module EXEstage (
    // control signals
    clk,nrst,
    // input signals
        // for pipeline forwarding
    I_MULDIV_abort,
    I_select_forward_exe_rs,
    I_select_forward_exe_rt,
    I_select_forward_op1,
    I_select_forward_op0,
	I_select_forward_w_data,
    I_hi_fb,
    I_lo_fb,
    I_alu_fb,
    I_exe_fb,
    I_mem_fb,
    I_wb_fb,
        // general input signals
    I_Immediate,
    I_rt_Addr,
    I_rd_Addr,
    I_rs_Data,
    I_rt_Data,
    I_Shamt,
    I_Target_Addr,
    I_Next_PC,
    I_ctrl_WB,
    I_ctrl_MEM,
    I_ctrl_EXE,
    I_op,
    // output signals
    O_ctrl_WB,
    O_ctrl_MEM,
    O_Link_Addr,
    O_Target_Addr,
    O_Zero,
    O_ALU_Res,
    O_MEM_Write_Data,
    O_Reg_Dst,
    O_MULDIV_H,
    O_MULDIV_L,
    O_MULDIV_occupied);
    
    input [0:0]  clk,nrst;
    input [3:0]  I_MULDIV_abort;            // if flush the pipeline, this signal flush the MUL/DIV block
    input [1:0]  I_select_forward_exe_rs;   // select the feedback signals from exe_stage to rt and rs
    input [1:0]  I_select_forward_exe_rt;
    input [1:0]  I_select_forward_op1;      // select the feedback signals to op1 and op0
    input [1:0]  I_select_forward_op0;
	input [1:0]  I_select_forward_w_data;
    input [`BUS_WIDTH-1:0] I_hi_fb;         // feedback signals from EXE/MEM/WB_stage
    input [`BUS_WIDTH-1:0] I_lo_fb;
    input [`BUS_WIDTH-1:0] I_alu_fb;
    input [`BUS_WIDTH-1:0] I_exe_fb;
    input [`BUS_WIDTH-1:0] I_mem_fb;
    input [`BUS_WIDTH-1:0] I_wb_fb;
    
    input [`BUS_WIDTH-1:0] I_Immediate;     // immediate or offset after sign extension
    input [`REG_WIDTH-1:0] I_rt_Addr;
    input [`REG_WIDTH-1:0] I_rd_Addr;       // Reg address, used in instruction write back to destination reg
    input [`BUS_WIDTH-1:0] I_rs_Data;
    input [`BUS_WIDTH-1:0] I_rt_Data;       // Reg data, operand 1 and 0
    input [`SHAMT_WIDTH-1:0]  I_Shamt;      // Shift amount, used in instruction: sll, srl and sra
    input [`JMPADDR_WIDTH-1:0]I_Target_Addr;// Target address, used in jump and branch instruction
    input signed [`BUS_WIDTH-1:0] I_Next_PC;// address for "next instruction", used in link instruction
    input [`CTRLWB_WIDTH-1:0]  I_ctrl_WB;   // ctrl signal
    input [`CTRLEXE_WIDTH-1:0] I_ctrl_EXE;  // ctrl signal
    input [`CTRLMEM_WIDTH-1:0] I_ctrl_MEM;  // ctrl signal
    input [`OP_WIDTH-1:0]      I_op;        // op segment, for alu controller
    
    output [`CTRLWB_WIDTH-1:0]  O_ctrl_WB;          // ctrl signal
    output [`CTRLMEM_WIDTH-1:0] O_ctrl_MEM;         // ctrl signal
    output [`BUS_WIDTH-1:0]     O_Link_Addr;        // the return address for link instruction
    output [`BUS_WIDTH-1:0]     O_Target_Addr;      // jump and branch target address
    output [0:0]                O_Zero;             // indicates if alu_result is zero
    output [`BUS_WIDTH-1:0]     O_ALU_Res;          // alu result
    output [`BUS_WIDTH-1:0]     O_MEM_Write_Data;   // rt_data, to write data in memory
    output [`REG_WIDTH-1:0]     O_Reg_Dst;          // register destination, to write data in register
    output [`BUS_WIDTH-1:0]     O_MULDIV_H;
    output [`BUS_WIDTH-1:0]     O_MULDIV_L;         // result for MUL and DIV
    output [3:0]                O_MULDIV_occupied;  // indicates which unit is occupied
    
    // 1. Create the target address, used in j and jal and branch instructions
    wire        [`BUS_WIDTH-1:0] ADD_offseted_Addr_w;
    wire signed [`BUS_WIDTH-1:0] offset_w;
    wire        [`BUS_WIDTH-1:0] shifted_Target_w;
    wire        [`BUS_WIDTH-1:0] ALU_res_w;
    reg         [`BUS_WIDTH-1:0] O_Target_Addr;
    assign offset_w = {I_Immediate[29:0],2'b00}; // left shift two bits
    assign ADD_offseted_Addr_w  = I_Next_PC + offset_w;
    assign shifted_Target_w = {4'b0000,I_Target_Addr,2'b00};
    
	always@(*)
    begin
        if      (I_ctrl_EXE[6:5]==2'b01)
            O_Target_Addr = shifted_Target_w;
        else if (I_ctrl_EXE[6:5]==2'b00)
            O_Target_Addr = ADD_offseted_Addr_w;
        else if (I_ctrl_EXE[6:5]==2'b10)
            O_Target_Addr = ALU_res_w;
        else
            O_Target_Addr = {32{1'bx}};
    end
    
    assign O_Link_Addr = I_Next_PC;
    
    // 2. create left and right operands for ALU
    reg [`BUS_WIDTH-1:0] ID_rt_w,ID_rs_w;
    
    always@(*)
    begin
        if (I_ctrl_EXE[4:3]==2'b00)
            ID_rs_w = I_rs_Data;              // op1 = rs
        else if (I_ctrl_EXE[4:3]==2'b01)
            ID_rs_w = {{27{1'b0}},I_Shamt};   // op1 = shamt
        else if (I_ctrl_EXE[4:3]==2'b10)
            ID_rs_w = {{27{1'b0}},5'b10000};  // op1 = 16
        else
            ID_rs_w = {32{1'bx}};             // op1 = x for debug
    end
    
    always@(*)
    begin
        if (I_ctrl_EXE[2:1]==2'b00)
            ID_rt_w = I_rt_Data;              // op0 = rt
        else if (I_ctrl_EXE[2:1]==2'b01)
            ID_rt_w = I_Immediate;            // op0 = imm
        else if (I_ctrl_EXE[2:1]==2'b10)
            ID_rt_w = {32{1'b0}};             // op0 = 0
        else
            ID_rt_w = {32{1'bx}};             // op0 = x for debug
    end
    
    // 2.25. select the forwarded signals from EXE stage
    reg [`BUS_WIDTH-1:0] exe_fb_rs_w,exe_fb_rt_w;
    
    always@(*)
    begin
        case(I_select_forward_exe_rs)
            2'b00: exe_fb_rs_w = I_alu_fb;      // from alu result
            2'b01: exe_fb_rs_w = I_hi_fb;       // from hi reg
            2'b10: exe_fb_rs_w = I_lo_fb;       // from lo reg
            2'b11: exe_fb_rs_w = {32{1'bx}};    // for debugging
        endcase
    end
    
    always@(*)
    begin
        case(I_select_forward_exe_rt)
            2'b00: exe_fb_rt_w = I_alu_fb;      // from alu result
            2'b01: exe_fb_rt_w = I_hi_fb;       // from hi reg
            2'b10: exe_fb_rt_w = I_lo_fb;       // from lo reg
            2'b11: exe_fb_rt_w = {32{1'bx}};    // for debugging
        endcase
    end
    
    // 2.5. select the forwarded signals
    reg [`BUS_WIDTH-1:0] forwarded_op0_w,forwarded_op1_w;
    
    always@(*)
    begin
        case(I_select_forward_op1)
            2'b00: forwarded_op1_w = ID_rs_w;               // forwarded_op1 = op1
            2'b01: forwarded_op1_w = exe_fb_rs_w;           // forwarded_op1 = exe_fb_rs
            2'b10: forwarded_op1_w = I_mem_fb;              // forwarded_op1 = mem_fb_rs
            2'b11: forwarded_op1_w = I_wb_fb;               // forwarded_op1 = wb_fb_rs
        endcase
    end
    
    always@(*)
    begin
        case(I_select_forward_op0)
            2'b00: forwarded_op0_w = ID_rt_w;               // forwarded_op1 = op1
            2'b01: forwarded_op0_w = exe_fb_rt_w;           // forwarded_op1 = exe_fb_rt
            2'b10: forwarded_op0_w = I_mem_fb;              // forwarded_op1 = mem_fb_rt
            2'b11: forwarded_op0_w = I_wb_fb;               // forwarded_op1 = wb_fb_rt
        endcase 
    end
    
    // 3. create the register destination
    reg [`REG_WIDTH-1:0] O_Reg_Dst;
    
    always@(*) //mux
    begin
        if (I_ctrl_EXE[0]==1'b0)
            O_Reg_Dst = I_rt_Addr;
        else
            O_Reg_Dst = I_rd_Addr;
    end
    
    // 4. instance ALU
    wire [`ICTRL_WIDTH-1:0] ctrl_alu_w;
    ALUctrl alu_ctrl_U (I_op,I_Immediate[5:0],I_rt_Addr,ctrl_alu_w);
    ALU alu_U (forwarded_op0_w,forwarded_op1_w,ctrl_alu_w,O_Zero,ALU_res_w);
    assign O_ALU_Res   = ALU_res_w;
	
	// 4.1 select the O_MEM_Write_Data for store instruction
	reg [`BUS_WIDTH-1:0] forwarded_w_data_w;
	reg [`BUS_WIDTH-1:0] O_MEM_Write_Data;
	
	always@(*)
	begin
		case(I_select_forward_w_data)
			2'b00: forwarded_w_data_w = I_rt_Data;  // forwarded_w_data = (rt)
            2'b01: forwarded_w_data_w = I_alu_fb;   // forwarded_w_data = alu_fb_rt
            2'b10: forwarded_w_data_w = I_mem_fb;   // forwarded_w_data = mem_fb_rt
            2'b11: forwarded_w_data_w = I_wb_fb;    // forwarded_w_data = wb_fb_rt
        endcase 
    end
	
	always@(*)
	begin
		case(I_ctrl_EXE[10:9])
			2'b00: O_MEM_Write_Data = forwarded_w_data_w;
			2'b01: O_MEM_Write_Data = {{16{1'b0}},I_rt_Data[15:0]};
			2'b10: O_MEM_Write_Data = {{24{1'b0}},I_rt_Data[7:0]};
			default: O_MEM_Write_Data = forwarded_w_data_w;
		endcase
    end
	
    // 4.5, instance MUL and DIV
    reg  [3:0] MULDIV_start_w;
    wire [`BUS_WIDTH-1:0] new_HI_w,new_LO_w;
    wire [0:0] MUL_update_w;  
    wire [0:0] DIV_update_w;  // if DIV and MUL have different number of pipeline stages
                              // then use different to update the HI/LO Reg
                              // otherwise only MUL_update_w is used
                              // (in this version, only MUL_update_w is used)
    
    always@(*)
    begin
        case(ctrl_alu_w)
            `ICTRL_WIDTH'b0000110: MULDIV_start_w = 4'b0001; // start signed Mul
            `ICTRL_WIDTH'b0000111: MULDIV_start_w = 4'b0010; // start unsigned Mul
            `ICTRL_WIDTH'b0001000: MULDIV_start_w = 4'b0100; // start signed Div
            `ICTRL_WIDTH'b0001001: MULDIV_start_w = 4'b1000; // start unsigned Div
            default              : MULDIV_start_w = 4'b0000; // freeze
        endcase
    end
    
    MUL_DIV_BLOCK mul_div_block_U (
        clk,nrst,
        MULDIV_start_w,
        4'b0000,//I_MULDIV_abort,
        forwarded_op0_w,forwarded_op1_w,
        new_HI_w,new_LO_w,
        MUL_update_w,O_MULDIV_occupied);
        
    // 5. HI LO reg
    reg  [`BUS_WIDTH-1:0] updated_HI_w,updated_LO_w;
    wire [`BUS_WIDTH-1:0] previous_HI_r,previous_LO_r;
    
    always@(*) //mux before HI
    begin
        case({MUL_update_w,I_ctrl_EXE[8]}) //I_ctrl_EXE[8] raised by mthi
            2'b00: updated_HI_w = previous_HI_r;
            2'b01: updated_HI_w = I_rs_Data;
            2'b10: updated_HI_w = new_HI_w;
            2'b11: updated_HI_w = {32{1'bx}};  // for debugging
        endcase
    end
    
    always@(*) //mux before LO
    begin
        case({MUL_update_w,I_ctrl_EXE[7]}) //I_ctrl_EXE[7] raised by mtlo
            2'b00: updated_LO_w = previous_LO_r;
            2'b01: updated_LO_w = I_rs_Data;
            2'b10: updated_LO_w = new_LO_w;
            2'b11: updated_LO_w = {32{1'bx}};  // for debugging
        endcase
    end
    
    DFF HI (clk,nrst,updated_HI_w,previous_HI_r);
    DFF LO (clk,nrst,updated_LO_w,previous_LO_r);
    
    assign O_MULDIV_H = previous_HI_r;
    assign O_MULDIV_L = previous_LO_r;
    
    // 6. Control Signal
    assign O_ctrl_WB  = I_ctrl_WB;
    assign O_ctrl_MEM = I_ctrl_MEM;
endmodule

//------------------------------//
// Module:      Memory Access Stage
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.June.20
// Description: 
//------------------------------//
module MEMstage (
    // control signals
    clk,nrst,
    // input signals
    I_ctrl_WB,
    I_ctrl_MEM,
	I_ctrl_MEM_NOREG,
    I_Link_Addr,
    I_Target_Addr,
    I_Zero,
    I_ALU_Res,
	I_MEM_Write_Addr,
	I_MEM_Write_Addr_NOREG,
    I_MEM_Write_Data,
	I_MEM_Write_Data_NOREG,
    I_Reg_Dst,
    // output signals
    O_ctrl_WB,
    O_MEM_Read_Data,
    O_ALU_Res,
    O_Reg_Dst,
    O_Link_Addr,
    O_Target_Addr,
    O_update_PC,
	O_GPIO);
    
    input  [0:0]  clk,nrst;
    
    input  [`CTRLWB_WIDTH-1:0]   I_ctrl_WB;         // ctrl signal
    input  [`CTRLMEM_WIDTH-1:0]  I_ctrl_MEM;        // ctrl signal
	input  [`CTRLMEM_WIDTH-1:0]  I_ctrl_MEM_NOREG;  // ctrl signal without register from last stage
    input  [`BUS_WIDTH-1:0]      I_Link_Addr;       // next PC, for link instruction
    input  [`BUS_WIDTH-1:0]      I_Target_Addr;     // target address for jump and branch instruction
    input  [0:0]                 I_Zero;            // indicates if alu_result is zero
    input  [`BUS_WIDTH-1:0]      I_ALU_Res;
	input  [`BUS_WIDTH-1:0]      I_MEM_Write_Addr;
	input  [`BUS_WIDTH-1:0]      I_MEM_Write_Addr_NOREG;	
    input  [`BUS_WIDTH-1:0]      I_MEM_Write_Data;  // rt_data, to write data in memory
	input  [`BUS_WIDTH-1:0]      I_MEM_Write_Data_NOREG;
    input  [`REG_WIDTH-1:0]      I_Reg_Dst;         // register destination, to write data in register
    
    output [`CTRLWB_WIDTH-1:0]   O_ctrl_WB;         // ctrl signal
    output [`BUS_WIDTH-1:0]      O_MEM_Read_Data;   // read data from Memory
    output [`BUS_WIDTH-1:0]      O_ALU_Res;
    output [`REG_WIDTH-1:0]      O_Reg_Dst;         // destination register for write back.
    output [0:0]                 O_update_PC;       // indicates if update the PC in IFstage
    output [`BUS_WIDTH-1:0]      O_Link_Addr;       // the return address for link instruction
    output [`BUS_WIDTH-1:0]      O_Target_Addr;     // the target address for jump and branch instruction
    output [`BUS_WIDTH-1:0]      O_GPIO;            // general purpose I/O
	
    // define the memory for data
	wire [`BUS_WIDTH-1:0] MEM_R_Data;
    DataMEM datamem_U (clk,nrst,I_MEM_Write_Addr_NOREG,I_MEM_Write_Data_NOREG,I_ctrl_MEM_NOREG[3],I_ctrl_MEM_NOREG[2],MEM_R_Data);
	
	// create results for load instructions
	reg [`BUS_WIDTH-1:0] O_MEM_Read_Data;
	
	always@(*)
	begin
		case(I_ctrl_MEM[7:5])
			3'b000: O_MEM_Read_Data = MEM_R_Data; // lw
			3'b001: O_MEM_Read_Data = {{16{1'b0}},MEM_R_Data[15:0]}; //lhu
			3'b010: O_MEM_Read_Data = {{16{MEM_R_Data[15]}},MEM_R_Data[15:0]}; //lh
			3'b011: O_MEM_Read_Data = {{24{1'b0}},MEM_R_Data[7:0]}; //lbu
			3'b100: O_MEM_Read_Data = {{24{MEM_R_Data[7]}},MEM_R_Data[7:0]}; //lb
			default:O_MEM_Read_Data = MEM_R_Data;
		endcase
	end
	
	// create a Register for GPIO
	// now suppose the address of GPIO is 0x10010000
	wire [`BUS_WIDTH-1:0] pre_GPIO_REG;
	reg [`BUS_WIDTH-1:0] new_GPIO_REG;
	reg [0:0] update_GPIO_REG;
		// create update signal
	always@(*)
	begin
		if (I_MEM_Write_Addr==32'h10010000 && I_ctrl_MEM[3]==1'b1) // writing address 0x10010000
			update_GPIO_REG = 1'b1;
		else
			update_GPIO_REG = 1'b0;
	end
		// create the update mux
	always@(*)
	begin
		if (update_GPIO_REG==1'b1)
			new_GPIO_REG = I_MEM_Write_Data[7:0];
		else
			new_GPIO_REG = pre_GPIO_REG;
	end
		// create the GPIO REG
	DFF #(32) led_dff (clk,nrst,new_GPIO_REG,pre_GPIO_REG);
	assign O_GPIO = pre_GPIO_REG;
	
	
    // create the update_PC signal
    assign O_update_PC = (I_ctrl_MEM[4] & I_ALU_Res[0]) | I_ctrl_MEM[0];
    
    // assign signals
    assign O_ctrl_WB      = I_ctrl_WB;
    assign O_ALU_Res      = I_ALU_Res;
    assign O_Reg_Dst      = I_Reg_Dst;
    assign O_Link_Addr    = I_Link_Addr;
    assign O_Target_Addr  = I_Target_Addr;
endmodule

//------------------------------//
// Module:      Write back Stage
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.June.20
// Description: 
//------------------------------//
module WBstage (
    // control signals
    clk,nrst,
    // input signals
    I_ctrl_WB,
    I_MEM_Read_Data,
    I_ALU_Res,
    I_Reg_Dst,
    I_Link_addr,
	I_MULDIV_H,
    I_MULDIV_L,
    // output signals
    O_Reg_Dst,
    O_Reg_Data,
    O_Reg_W);
    
    input  [0:0]  clk,nrst;
    
    input  [`CTRLWB_WIDTH-1:0]  I_ctrl_WB;    // ctrl signal
    input  [`BUS_WIDTH-1:0] I_MEM_Read_Data;  // read data from Memory
    input  [`BUS_WIDTH-1:0] I_MULDIV_H;
    input  [`BUS_WIDTH-1:0] I_MULDIV_L;       // result direct from MUL/DIV
    input  [`BUS_WIDTH-1:0] I_ALU_Res;
    input  [`REG_WIDTH-1:0] I_Reg_Dst;        // destination register for write back.
    input  [`BUS_WIDTH-1:0] I_Link_addr;      // the return address for link instruction
    
    output [`REG_WIDTH-1:0] O_Reg_Dst;        // destination of the register data
    output [`BUS_WIDTH-1:0] O_Reg_Data;       // register data fed back to REGstage
    output [0:0]            O_Reg_W;          // write enable signal 
    
    
    // select the data to write in destination register
    reg  [`BUS_WIDTH-1:0] O_Reg_Data; // mux
    always@(*)
    begin
        case(I_ctrl_WB[4:2]) 
        3'b000 : O_Reg_Data = I_MEM_Read_Data;// from memory
        3'b001 : O_Reg_Data = I_ALU_Res; // from alu
        3'b010 : O_Reg_Data = I_Link_addr;    // save link addr to RA register
        3'b011 : O_Reg_Data = I_MULDIV_H;    // move res_H to register
        3'b100 : O_Reg_Data = I_MULDIV_L;    // move res_L to register
        default: O_Reg_Data = 32'hxxxxxxxx;   // shouldn't be here, for debuging
        endcase
    end
    
    // create the reg destination signal
    reg [`REG_WIDTH-1:0]  O_Reg_Dst; // mux
    always@(*)
    begin
        if (I_ctrl_WB[4:2]==3'b010)
            O_Reg_Dst = 5'b11111; // register RA for return address
        else
            O_Reg_Dst = I_Reg_Dst;
    end
    
    // assign signals
    assign O_Reg_W = I_ctrl_WB[5];
endmodule

//------------------------------//
// Module:      Pipeline Controller
// Company:     UoS
// Engineer:    Liu Han
// Last Update: 2012.Sep.19
// Description: 
//------------------------------//
module PipeCtrl (
    // control singals
    clk,nrst,
    // input signals
    I_IDEXE_rt_Addr,// read addr to rt
    I_IDEXE_rs_Addr,// read addr to rs
    I_IFID_rt_Addr, // read addr to rt
    I_EXE_rd_Addr,  // write REG from EXE to rd
    I_MEM_rd_Addr,  // write REG from MEM to rd
    I_WB_rd_Addr,   // write REG from WB to rd
    I_EXEMEM_Reg_Write, 
    I_MEMWB_Reg_Write,
    I_WBID_Reg_write,
    I_IDEXE_Mem_Read,
    I_UpdatePC,
	I_IDEXE_Ctrl_EXE,
    I_EXEMEM_mflo,
    I_EXEMEM_mfhi,
    I_occupied,     // if div/mul (4 units) are occupied, and the coming instruction
                    // uses the same unit, then raise stall
    // output signals
    O_stall,
    O_flush, 
    O_MULDIV_abort, // if flush, and mul/div is running (occupied), then abort it.
    O_select_forward_exe_rs,
    O_select_forward_exe_rt,
    O_select_forward_op1,
    O_select_forward_op0,
	O_select_forward_w_data
    );
    
    input [0:0] clk,nrst;
    input [`REG_WIDTH-1:0] I_IDEXE_rt_Addr;
    input [`REG_WIDTH-1:0] I_IDEXE_rs_Addr;
    input [`REG_WIDTH-1:0] I_IFID_rt_Addr;
    input [`REG_WIDTH-1:0] I_EXE_rd_Addr;
    input [`REG_WIDTH-1:0] I_MEM_rd_Addr;
    input [`REG_WIDTH-1:0] I_WB_rd_Addr;
    input [0:0] I_EXEMEM_Reg_Write;
    input [0:0] I_MEMWB_Reg_Write;
    input [0:0] I_WBID_Reg_write; 
    input [0:0] I_IDEXE_Mem_Read;
    input [0:0] I_UpdatePC;
	input [`CTRLEXE_WIDTH-1:0] I_IDEXE_Ctrl_EXE;
    
    //input [31:0] I_HI,I_LO;
    //input [31:0] I_EXE_Res;
    //input [31:0] I_MEM_Res;
    //input [31:0] I_WB_Res;
    
    input [0:0]  I_EXEMEM_mflo;
    input [0:0]  I_EXEMEM_mfhi;
    input [3:0]  I_occupied;
    
    output [4:0]  O_stall; // 5bits are for {PC/REG_IF_ID/.../REG_MEM_WB} 
    output [3:0]  O_flush; // 4bits are for {REG_IF_ID/.../REG_MEM_WB}
    output [3:0]  O_MULDIV_abort; // 4bits are for {MUL/MULU/DIV/DIVU}
    output [1:0]  O_select_forward_exe_rs;
    output [1:0]  O_select_forward_exe_rt;
    output [1:0]  O_select_forward_op1;
    output [1:0]  O_select_forward_op0;
    output [1:0]  O_select_forward_w_data;
	
    reg [4:0]  O_stall; // 5bits are for {PC/REG_IF_ID/.../REG_MEM_WB} 
    reg [3:0]  O_flush; // 4bits are for {REG_IF_ID/.../REG_MEM_WB}
    reg [3:0]  O_MULDIV_abort; // 4bits are for {MUL/MULU/DIV/DIVU}
    reg [1:0]  O_select_forward_exe_rs;
    reg [1:0]  O_select_forward_exe_rt;
    reg [1:0]  O_select_forward_op1;
    reg [1:0]  O_select_forward_op0;
	reg [1:0]  O_select_forward_w_data;
    
    // mux for selecting EXE_fb_rs
    always@(*)
    begin
        if ((I_IDEXE_rs_Addr==I_EXE_rd_Addr) && I_EXEMEM_Reg_Write==1'b1)
        begin
            O_select_forward_exe_rs = 2'b00; // select ALU_res
            //$display("forward_exe_rs = ALU_Res");
        end
        else if ((I_IDEXE_rs_Addr==I_EXE_rd_Addr) && (|I_occupied==1'b0) && I_EXEMEM_mflo==1'b1)
        begin
            O_select_forward_exe_rs = 2'b10; // select LO
            //$display("forward_exe_rs = LO");
        end
        else if ((I_IDEXE_rs_Addr==I_EXE_rd_Addr) && (|I_occupied==1'b0) && I_EXEMEM_mfhi==1'b1)
        begin
            O_select_forward_exe_rs = 2'b01; // select HI
            //$display("forward_exe_rs = HI");
        end
        else
        begin
            O_select_forward_exe_rs = 2'b00; // Default
            //$display("forward_exe_rs = ALU_Res (Default)");
        end
    end
    
    // mux for selecting EXE_fb_rt
    always@(*)
    begin
        if ((I_IDEXE_rt_Addr==I_EXE_rd_Addr) && I_EXEMEM_Reg_Write==1'b1)
        begin
            O_select_forward_exe_rt = 2'b00; // select ALU_res
            //$display("forward_exe_rt = ALU_Res");
        end
        else if ((I_IDEXE_rt_Addr==I_EXE_rd_Addr) && (|I_occupied==1'b0) && I_EXEMEM_mflo==1'b1)
        begin
            O_select_forward_exe_rt = 2'b10; // select LO
            //$display("forward_exe_rt = LO");
        end
        else if ((I_IDEXE_rt_Addr==I_EXE_rd_Addr) && (|I_occupied==1'b0) && I_EXEMEM_mfhi==1'b1)
        begin
            O_select_forward_exe_rt = 2'b01; // select HI
            //$display("forward_exe_rt = HI");
        end
        else
        begin
            O_select_forward_exe_rt = 2'b00; // Default
            //$display("forward_exe_rt = ALU_Res (Default)");
        end
    end
    
    // mux for selecting op1
    always@(*)
    begin
        if ((I_IDEXE_rs_Addr==I_EXE_rd_Addr) && (I_EXE_rd_Addr!=0) && (I_EXEMEM_Reg_Write==1'b1))
        begin
            O_select_forward_op1 = 2'b01; // select EXE_fb_rs
            //$display("forward_op1 = EXE_fb_rs");
        end
        else if ((I_IDEXE_rs_Addr==I_MEM_rd_Addr) && (I_MEM_rd_Addr!=1'b0) && (I_MEMWB_Reg_Write==1'b1))
        begin
            O_select_forward_op1 = 2'b10; // select MEM_fb_rs
            //$display("forward_op1 = MEM_fb_rs");
        end
        else if ((I_IDEXE_rs_Addr==I_WB_rd_Addr) && (I_WB_rd_Addr!=1'b0) && (I_WBID_Reg_write==1'b1))  // ?
        begin
            O_select_forward_op1 = 2'b11; // select WB_fb_rs
            //$display("forward_op1 = WB_fb_rs");
        end
        else
        begin
            O_select_forward_op1 = 2'b00; // select ID_rs
            //$display("forward_op1 = ID_rs");
        end
    end
    
    // mux for selecting op0
    always@(*)
    begin
		// I_IDEXE_Ctrl_EXE[11]==1'b0 means rt should be from the offest (for calculating address for store instructions)
		// I_IDEXE_Ctrl_EXE[0]==1'b1 means rt is not the destination of the writing register, then use it to check the dependency
		// otherwise, it's the reading register.
        if (I_IDEXE_Ctrl_EXE[11]==1'b0 && I_IDEXE_Ctrl_EXE[0]==1'b1 && (I_IDEXE_rt_Addr==I_EXE_rd_Addr) && (I_EXE_rd_Addr!=0) && (I_EXEMEM_Reg_Write==1'b1))
        begin
            O_select_forward_op0 = 2'b01; // select EXE_fb_rt
            //$display("forward_op0 = EXE_fb_rt");
        end
        else if (I_IDEXE_Ctrl_EXE[11]==1'b0 && I_IDEXE_Ctrl_EXE[0]==1'b1 && (I_IDEXE_rt_Addr==I_MEM_rd_Addr) && (I_MEM_rd_Addr!=1'b0) && (I_MEMWB_Reg_Write==1'b1))
        begin
            O_select_forward_op0 = 2'b10; // select MEM_fb_rt
            //$display("forward_op0 = MEM_fb_rt");
        end
        else if (I_IDEXE_Ctrl_EXE[11]==1'b0 && I_IDEXE_Ctrl_EXE[0]==1'b1 && (I_IDEXE_rt_Addr==I_WB_rd_Addr) && (I_WB_rd_Addr!=1'b0) && (I_WBID_Reg_write==1'b1))  // ?
        begin
            O_select_forward_op0 = 2'b11; // select WB_fb_rt
            //$display("forward_op0 = WB_fb_rt");
        end
        else
        begin
            O_select_forward_op0 = 2'b00; // select ID_rt
            //$display("forward_op0 = ID_rt");
        end
    end
	
	// mux for selecting writing data (for store instruction)
    always@(*)
    begin
        if ((I_IDEXE_rt_Addr==I_EXE_rd_Addr) && (I_EXE_rd_Addr!=0) && (I_EXEMEM_Reg_Write==1'b1))
        begin
            O_select_forward_w_data = 2'b01; // select EXE_fb_rt
            //$display("forward_op0 = EXE_fb_rt");
        end
        else if ((I_IDEXE_rt_Addr==I_MEM_rd_Addr) && (I_MEM_rd_Addr!=1'b0) && (I_MEMWB_Reg_Write==1'b1))
        begin
            O_select_forward_w_data = 2'b10; // select MEM_fb_rt
            //$display("forward_op0 = MEM_fb_rt");
        end
        else if ((I_IDEXE_rt_Addr==I_WB_rd_Addr) && (I_WB_rd_Addr!=1'b0) && (I_WBID_Reg_write==1'b1))  // ?
        begin
            O_select_forward_w_data = 2'b11; // select WB_fb_rt
            //$display("forward_op0 = WB_fb_rt");
        end
        else
        begin
            O_select_forward_w_data = 2'b00; // select ID_rt
            //$display("forward_op0 = ID_rt");
        end
    end
    
    // generate stall
    always@(*)
    begin
        if (I_IDEXE_Mem_Read==1'b1 &&
            (I_IFID_rt_Addr==I_IDEXE_rt_Addr ||
             I_IFID_rt_Addr==I_IDEXE_rs_Addr))
        begin
            O_stall = 5'b11100;
            $display("stall");
        end
        else
        begin
            O_stall = 5'b00000;
            //$display("no stall");
        end
    end
    
    // generate flush
    always@(*)
    begin
        if (I_UpdatePC==1'b1)
        begin
            O_flush = 4'b1110;
            $display("flush");
        end
        else
        begin
            O_flush = 4'b0000;
            //$display("no flush");
        end
    end
endmodule

//----------------------------------------------------------------------------------------------------------------//
// Section 3: The top level architecture
//----------------------------------------------------------------------------------------------------------------//
module IF_ID_REG (
// This is the registers between pipeline stages
    // control signals
    clk,nrst,stall,flush,   // 4
    // input signals
    I_Next_PC,              // 5
    I_Instruction,          // 6
    // outpout signals
    O_Next_PC,
    O_Instruction,
	O_Instruction_NOREG);
 
    input [0:0]  clk,nrst,stall,flush;
    input [`BUS_WIDTH-1:0]  I_Next_PC;
    input [`BUS_WIDTH-1:0]  I_Instruction;
    output [`BUS_WIDTH-1:0] O_Next_PC;
    output [`BUS_WIDTH-1:0] O_Instruction_NOREG;
	output [`BUS_WIDTH-1:0] O_Instruction;
    
    reg [`BUS_WIDTH-1:0] Next_PC_r;
    reg [`BUS_WIDTH-1:0] Instruction_r;
    
    reg [`BUS_WIDTH-1:0] Mux_Next_PC_w;
    reg [`BUS_WIDTH-1:0] Mux_Instruction_w;
    
    always@(*) // MUX
    begin
        case({stall,flush})
            2'b00: begin
                Mux_Next_PC_w       = I_Next_PC;
                Mux_Instruction_w   = I_Instruction;
            end
            2'b01: begin
                Mux_Next_PC_w       = {`BUS_WIDTH{1'b0}};
                Mux_Instruction_w   = {`BUS_WIDTH{1'b0}};
            end
            2'b10: begin
                Mux_Next_PC_w       = Next_PC_r;
                Mux_Instruction_w   = Instruction_r;
            end
            default: begin
                Mux_Next_PC_w       = {`BUS_WIDTH{1'bx}};
                Mux_Instruction_w   = {`BUS_WIDTH{1'bx}};
            end
        endcase
    end
            
    
    always@(posedge clk) // reg
    begin
        if (!nrst) begin
            Next_PC_r     <= {`BUS_WIDTH{1'b0}};
			Instruction_r <= {`BUS_WIDTH{1'b0}};
        end else begin
            Next_PC_r     <= Mux_Next_PC_w;
			Instruction_r <= Mux_Instruction_w;
        end
    end
    
    // assign output
    assign O_Next_PC = Next_PC_r;
    assign O_Instruction = Instruction_r;
	assign O_Instruction_NOREG = Mux_Instruction_w;
endmodule


module ID_EXE_REG (
// This is the registers between pipeline stages
    // control signals
    clk,nrst,stall,flush,   // 4
    // input signals
    I_Immediate,            // 5
    I_rt_Addr,              // 6
    I_rs_Addr,              // 7
    I_rd_Addr,              // 8
    I_rs_Data,              // 9
    I_rt_Data,              // 10
    I_Shamt,                // 11
    I_Target_Addr,          // 12
    I_Next_PC,              // 13
    I_op,                   // 14
    I_ctrl_WB,              // 15
    I_ctrl_MEM,             // 16
    I_ctrl_EXE,             // 17
    // output signals
    O_Immediate,
    O_rt_Addr,
    O_rs_Addr,
    O_rd_Addr,
    O_rs_Data,
    O_rt_Data,
    O_Shamt,
    O_Target_Addr,
    O_Next_PC,
    O_op,
    O_ctrl_WB,
    O_ctrl_MEM,
    O_ctrl_EXE);
    
    input [0:0]  clk,nrst,stall,flush;
    input [`BUS_WIDTH-1:0]     I_Immediate;   // immediate or offset after sign extension
    input [`REG_WIDTH-1:0]     I_rt_Addr;
    input [`REG_WIDTH-1:0]     I_rs_Addr;
    input [`REG_WIDTH-1:0]     I_rd_Addr;     // Reg addr, used in instruction write back to destination reg
    input [`BUS_WIDTH-1:0]     I_rs_Data;
    input [`BUS_WIDTH-1:0]     I_rt_Data;     // Reg data, operand 1 and 0
    input [`SHAMT_WIDTH-1:0]   I_Shamt;       // shift amount, used in instruction: sll, srl and sra
    input [`JMPADDR_WIDTH-1:0] I_Target_Addr; // target address, used in jump instruction
    input [`BUS_WIDTH-1:0]     I_Next_PC;     // address for "next instruction", used in link and branch instruction
    input [`CTRLWB_WIDTH-1:0]  I_ctrl_WB;     // ctrl signal
    input [`CTRLEXE_WIDTH-1:0] I_ctrl_EXE;    // ctrl signal
    input [`CTRLMEM_WIDTH-1:0] I_ctrl_MEM;    // ctrl signal
    input [`OP_WIDTH-1:0]      I_op;          // op segment, for alu controller
    
    output [`BUS_WIDTH-1:0]     O_Immediate;   // immediate or offset after sign extension
    output [`REG_WIDTH-1:0]     O_rt_Addr;
    output [`REG_WIDTH-1:0]     O_rs_Addr;
    output [`REG_WIDTH-1:0]     O_rd_Addr;     // Reg addr, used in instruction write back to destination reg
    output [`BUS_WIDTH-1:0]     O_rs_Data;
    output [`BUS_WIDTH-1:0]     O_rt_Data;     // Reg data, operand 1 and 0
    output [`SHAMT_WIDTH-1:0]   O_Shamt;       // shift amount, used in instruction: sll, srl and sra
    output [`JMPADDR_WIDTH-1:0] O_Target_Addr; // target address, used in jump instruction
    output [`BUS_WIDTH-1:0]     O_Next_PC;     // address for "next instruction", used in link and branch instruction
    output [`CTRLWB_WIDTH-1:0]  O_ctrl_WB;     // ctrl signal
    output [`CTRLEXE_WIDTH-1:0] O_ctrl_EXE;    // ctrl signal
    output [`CTRLMEM_WIDTH-1:0] O_ctrl_MEM;    // ctrl signal
    output [`OP_WIDTH-1:0]      O_op;          // op segment, for alu controller
    
    reg [`BUS_WIDTH-1:0]     MUX_Immediate_w;  
    reg [`REG_WIDTH-1:0]     MUX_rt_Addr_w;
    reg [`REG_WIDTH-1:0]     MUX_rs_Addr_w;
    reg [`REG_WIDTH-1:0]     MUX_rd_Addr_w;    
    reg [`BUS_WIDTH-1:0]     MUX_rs_Data_w;
    reg [`BUS_WIDTH-1:0]     MUX_rt_Data_w;    
    reg [`SHAMT_WIDTH-1:0]   MUX_Shamt_w;      
    reg [`JMPADDR_WIDTH-1:0] MUX_Target_Addr_w;
    reg [`BUS_WIDTH-1:0]     MUX_Next_PC_w;    
    reg [`CTRLWB_WIDTH-1:0]  MUX_ctrl_WB_w;    
    reg [`CTRLEXE_WIDTH-1:0] MUX_ctrl_EXE_w;   
    reg [`CTRLMEM_WIDTH-1:0] MUX_ctrl_MEM_w;   
    reg [`OP_WIDTH-1:0]      MUX_op_w;         
    
    reg [`BUS_WIDTH-1:0]      Immediate_r;  
    reg [`REG_WIDTH-1:0]      rt_Addr_r;
    reg [`REG_WIDTH-1:0]      rs_Addr_r;
    reg [`REG_WIDTH-1:0]      rd_Addr_r;    
    reg [`BUS_WIDTH-1:0]      rs_Data_r;
    reg [`BUS_WIDTH-1:0]      rt_Data_r;    
    reg [`SHAMT_WIDTH-1:0]    Shamt_r;      
    reg [`JMPADDR_WIDTH-1:0]  Target_Addr_r;
    reg [`BUS_WIDTH-1:0]      Next_PC_r;    
    reg [`CTRLWB_WIDTH-1:0]   ctrl_WB_r;    
    reg [`CTRLEXE_WIDTH-1:0]  ctrl_EXE_r;   
    reg [`CTRLMEM_WIDTH-1:0]  ctrl_MEM_r;   
    reg [`OP_WIDTH-1:0]       op_r;
    
    always@(*) // MUX
    begin
        case({stall,flush})
            2'b00: begin // transmit
                MUX_Immediate_w     = I_Immediate;  
                MUX_rt_Addr_w       = I_rt_Addr;
                MUX_rs_Addr_w       = I_rs_Addr;
                MUX_rd_Addr_w       = I_rd_Addr;    
                MUX_rs_Data_w       = I_rs_Data;
                MUX_rt_Data_w       = I_rt_Data;    
                MUX_Shamt_w         = I_Shamt;      
                MUX_Target_Addr_w   = I_Target_Addr;
                MUX_Next_PC_w       = I_Next_PC;    
                MUX_ctrl_WB_w       = I_ctrl_WB;    
                MUX_ctrl_EXE_w      = I_ctrl_EXE;   
                MUX_ctrl_MEM_w      = I_ctrl_MEM;   
                MUX_op_w            = I_op; 
            end
            2'b01: begin // flush
                MUX_Immediate_w     = {`BUS_WIDTH{1'b0}};
                MUX_rt_Addr_w       = {`RT_WIDTH{1'b0}};
                MUX_rs_Addr_w       = {`RS_WIDTH{1'b0}};
                MUX_rd_Addr_w       = {`RD_WIDTH{1'b0}};
                MUX_rs_Data_w       = {`BUS_WIDTH{1'b0}};
                MUX_rt_Data_w       = {`BUS_WIDTH{1'b0}};
                MUX_Shamt_w         = {`SHAMT_WIDTH{1'b0}};
                MUX_Target_Addr_w   = {`JMPADDR_WIDTH{1'b0}};
                MUX_Next_PC_w       = {`BUS_WIDTH{1'b0}};
                MUX_ctrl_WB_w       = {`CTRLWB_WIDTH{1'b0}};
                MUX_ctrl_EXE_w      = {`CTRLEXE_WIDTH{1'b0}};
                MUX_ctrl_MEM_w      = {`CTRLMEM_WIDTH{1'b0}};
                MUX_op_w            = {`OP_WIDTH{1'b0}};
            end
            2'b10: begin // stall
                MUX_Immediate_w     = Immediate_r;  
                MUX_rt_Addr_w       = rt_Addr_r;
                MUX_rs_Addr_w       = rt_Addr_r;    
                MUX_rd_Addr_w       = rd_Addr_r;    
                MUX_rs_Data_w       = rs_Data_r;    
                MUX_rt_Data_w       = rt_Data_r;    
                MUX_Shamt_w         = Shamt_r;      
                MUX_Target_Addr_w   = Target_Addr_r;
                MUX_Next_PC_w       = Next_PC_r;    
                MUX_ctrl_WB_w       = ctrl_WB_r;    
                MUX_ctrl_EXE_w      = ctrl_EXE_r;   
                MUX_ctrl_MEM_w      = ctrl_MEM_r;   
                MUX_op_w            = op_r; 
            end
            default: begin // na
                MUX_Immediate_w     = {`BUS_WIDTH{1'bx}};
                MUX_rt_Addr_w       = {`RT_WIDTH{1'bx}};
                MUX_rs_Addr_w       = {`RS_WIDTH{1'bx}};
                MUX_rd_Addr_w       = {`RD_WIDTH{1'bx}};
                MUX_rs_Data_w       = {`BUS_WIDTH{1'bx}};
                MUX_rt_Data_w       = {`BUS_WIDTH{1'bx}};
                MUX_Shamt_w         = {`SHAMT_WIDTH{1'bx}};
                MUX_Target_Addr_w   = {`JMPADDR_WIDTH{1'bx}};
                MUX_Next_PC_w       = {`BUS_WIDTH{1'bx}};
                MUX_ctrl_WB_w       = {`CTRLWB_WIDTH{1'bx}};
                MUX_ctrl_EXE_w      = {`CTRLEXE_WIDTH{1'bx}};
                MUX_ctrl_MEM_w      = {`CTRLMEM_WIDTH{1'bx}};
                MUX_op_w            = {`OP_WIDTH{1'bx}};
            end
        endcase
    end
    
    always@(posedge clk) // reg
    begin
        if (!nrst) begin
            Immediate_r   <= {`BUS_WIDTH{1'b0}};
            rt_Addr_r     <= {`RT_WIDTH{1'b0}};
            rs_Addr_r     <= {`RS_WIDTH{1'b0}};
            rd_Addr_r     <= {`RD_WIDTH{1'b0}};
			rs_Data_r     <= {`BUS_WIDTH{1'b0}};
            rt_Data_r     <= {`BUS_WIDTH{1'b0}};
            Shamt_r       <= {`SHAMT_WIDTH{1'b0}};
            Target_Addr_r <= {`JMPADDR_WIDTH{1'b0}};
            Next_PC_r     <= {`BUS_WIDTH{1'b0}};
            ctrl_WB_r     <= {`CTRLWB_WIDTH{1'b0}};
            ctrl_EXE_r    <= {`CTRLEXE_WIDTH{1'b0}}; 
            ctrl_MEM_r    <= {`CTRLMEM_WIDTH{1'b0}};
            op_r          <= {`OP_WIDTH{1'b0}}; 
        end else begin
            Immediate_r   <= MUX_Immediate_w;  
            rt_Addr_r     <= I_rt_Addr; // Reg them
            rs_Addr_r     <= I_rs_Addr; // but not stall and flush them
            rd_Addr_r     <= MUX_rd_Addr_w;
			rs_Data_r     <= MUX_rs_Data_w;    
            rt_Data_r     <= MUX_rt_Data_w;			
            Shamt_r       <= MUX_Shamt_w;      
            Target_Addr_r <= MUX_Target_Addr_w;
            Next_PC_r     <= MUX_Next_PC_w;    
            ctrl_WB_r     <= MUX_ctrl_WB_w;    
            ctrl_EXE_r    <= MUX_ctrl_EXE_w;   
            ctrl_MEM_r    <= MUX_ctrl_MEM_w;   
            op_r          <= MUX_op_w;   
        end
    end
	
    assign O_Immediate   = Immediate_r;       
    assign O_rt_Addr     = rt_Addr_r;
    assign O_rs_Addr     = rs_Addr_r;   
    assign O_rd_Addr     = rd_Addr_r;         
    assign O_rs_Data     = rs_Data_r;    
    assign O_rt_Data     = rt_Data_r;         
    assign O_Shamt       = Shamt_r;           
    assign O_Target_Addr = Target_Addr_r;     
    assign O_Next_PC     = Next_PC_r;         
    assign O_ctrl_WB     = ctrl_WB_r;         
    assign O_ctrl_EXE    = ctrl_EXE_r;        
    assign O_ctrl_MEM    = ctrl_MEM_r;        
    assign O_op          = op_r;           
endmodule


module EXE_MEM_REG (
// This is the registers between pipeline stages
    // control signals
    clk,nrst,stall,flush,
    // input signals
    I_ctrl_WB,
    I_ctrl_MEM,
    I_Link_Addr,
    I_Target_Addr,
    I_Zero,
    I_ALU_Res,
	I_MEM_Write_Addr,
    I_MEM_Write_Data,
    I_Reg_Dst,
    // output signals
    O_ctrl_WB,
    O_ctrl_MEM,
	O_ctrl_MEM_NOREG,
    O_Link_Addr,
    O_Target_Addr,
    O_Zero,
    O_ALU_Res,
	O_MEM_Write_Addr,
	O_MEM_Write_Addr_NOREG,
	O_MEM_Write_Data,
    O_MEM_Write_Data_NOREG,
    O_Reg_Dst);
    
    input [0:0] clk,nrst,stall,flush;
    input [`CTRLWB_WIDTH-1:0]  I_ctrl_WB;         // ctrl signal
    input [`CTRLMEM_WIDTH-1:0] I_ctrl_MEM;        // ctrl signal
    input [`BUS_WIDTH-1:0]     I_Link_Addr;       // the return address for link instruction
    input [`BUS_WIDTH-1:0]     I_Target_Addr;     // jump and branch target address
    input [0:0]                I_Zero;            // indicates if alu_result is zero
    input [`BUS_WIDTH-1:0]     I_ALU_Res;         // alu result
	input [`BUS_WIDTH-1:0]     I_MEM_Write_Addr;  // alu result, to write data in memory
    input [`BUS_WIDTH-1:0]     I_MEM_Write_Data;  // rt_data, to write data in memory
    input [`REG_WIDTH-1:0]     I_Reg_Dst;         // register destination, to write data in register
    
    output [`CTRLWB_WIDTH-1:0]  O_ctrl_WB;         // ctrl signal
    output [`CTRLMEM_WIDTH-1:0] O_ctrl_MEM;        // ctrl signal
	output [`CTRLMEM_WIDTH-1:0] O_ctrl_MEM_NOREG;  // ctrl signal without registers
    output [`BUS_WIDTH-1:0]     O_Link_Addr;       // the return address for link instruction
    output [`BUS_WIDTH-1:0]     O_Target_Addr;     // jump and branch target address
    output [0:0]                O_Zero;            // indicates if alu_result is zero
    output [`BUS_WIDTH-1:0]     O_ALU_Res;         // alu result
	output [`BUS_WIDTH-1:0]     O_MEM_Write_Addr;  // alu result, to write data in memory
	output [`BUS_WIDTH-1:0]     O_MEM_Write_Addr_NOREG;  // alu result, to write data in memory
    output [`BUS_WIDTH-1:0]     O_MEM_Write_Data;  // rt_data, to write data in memory
	output [`BUS_WIDTH-1:0]     O_MEM_Write_Data_NOREG;  // rt_data, to write data in memory
    output [`REG_WIDTH-1:0]     O_Reg_Dst;         // register destination, to write data in register
    
    reg [`CTRLWB_WIDTH-1:0]   MUX_ctrl_WB_w;        
    reg [`CTRLMEM_WIDTH-1:0]  MUX_ctrl_MEM_w;       
    reg [`BUS_WIDTH-1:0]      MUX_Link_Addr_w;      
    reg [`BUS_WIDTH-1:0]      MUX_Target_Addr_w;    
    reg [0:0]                 MUX_Zero_w;           
    reg [`BUS_WIDTH-1:0]      MUX_ALU_Res_w;   
	reg [`BUS_WIDTH-1:0]      MUX_MEM_Write_Addr_w;
    reg [`BUS_WIDTH-1:0]      MUX_MEM_Write_Data_w; 
    reg [`REG_WIDTH-1:0]      MUX_Reg_Dst_w;
    
    reg [`CTRLWB_WIDTH-1:0]   ctrl_WB_r;        
    reg [`CTRLMEM_WIDTH-1:0]  ctrl_MEM_r;       
    reg [`BUS_WIDTH-1:0]      Link_Addr_r;      
    reg [`BUS_WIDTH-1:0]      Target_Addr_r;    
    reg [0:0]                 Zero_r;           
    reg [`BUS_WIDTH-1:0]      ALU_Res_r;
	reg [`BUS_WIDTH-1:0]      MEM_Write_Addr_r;
    reg [`BUS_WIDTH-1:0]      MEM_Write_Data_r; 
    reg [`REG_WIDTH-1:0]      Reg_Dst_r;
    
    always@(*) // MUX
    begin
        case({stall,flush})
            2'b00: begin // transmit
                MUX_ctrl_WB_w         = I_ctrl_WB;        
                MUX_ctrl_MEM_w        = I_ctrl_MEM;       
                MUX_Link_Addr_w       = I_Link_Addr;      
                MUX_Target_Addr_w     = I_Target_Addr;    
                MUX_Zero_w            = I_Zero;           
                MUX_ALU_Res_w         = I_ALU_Res;
				MUX_MEM_Write_Addr_w  = I_MEM_Write_Addr;				
                MUX_MEM_Write_Data_w  = I_MEM_Write_Data; 
                MUX_Reg_Dst_w         = I_Reg_Dst;        
            end
            2'b01: begin // flush
                MUX_ctrl_WB_w         = {`CTRLWB_WIDTH{1'b0}};  
                MUX_ctrl_MEM_w        = {`CTRLMEM_WIDTH{1'b0}};  
                MUX_Link_Addr_w       = {`BUS_WIDTH{1'b0}}; 
                MUX_Target_Addr_w     = {`BUS_WIDTH{1'b0}}; 
                MUX_Zero_w            = {1{1'b0}};  
                MUX_ALU_Res_w         = {`BUS_WIDTH{1'b0}};
				MUX_MEM_Write_Addr_w  = {`BUS_WIDTH{1'b0}};
                MUX_MEM_Write_Data_w  = {`BUS_WIDTH{1'b0}}; 
                MUX_Reg_Dst_w         = {`REG_WIDTH{1'b0}};  
            end
            2'b10: begin // stall
                 MUX_ctrl_WB_w         = ctrl_WB_r;       
                 MUX_ctrl_MEM_w        = ctrl_MEM_r;      
                 MUX_Link_Addr_w       = Link_Addr_r;     
                 MUX_Target_Addr_w     = Target_Addr_r;   
                 MUX_Zero_w            = Zero_r;          
                 MUX_ALU_Res_w         = ALU_Res_r;
				 MUX_MEM_Write_Addr_w  = MEM_Write_Addr_r;
                 MUX_MEM_Write_Data_w  = MEM_Write_Data_r;
                 MUX_Reg_Dst_w         = Reg_Dst_r;       
            end
            default: begin // na
                 MUX_ctrl_WB_w         = {`CTRLWB_WIDTH{1'bx}};  
                 MUX_ctrl_MEM_w        = {`CTRLMEM_WIDTH{1'bx}};  
                 MUX_Link_Addr_w       = {`BUS_WIDTH{1'bx}}; 
                 MUX_Target_Addr_w     = {`BUS_WIDTH{1'bx}}; 
                 MUX_Zero_w            = {1{1'bx}};  
                 MUX_ALU_Res_w         = {`BUS_WIDTH{1'bx}};
				 MUX_MEM_Write_Addr_w  = {`BUS_WIDTH{1'bx}};
                 MUX_MEM_Write_Data_w  = {`BUS_WIDTH{1'bx}}; 
                 MUX_Reg_Dst_w         = {`REG_WIDTH{1'bx}};  
            end
        endcase
    end
    
    always@(posedge clk) // reg
    begin
        if (!nrst) begin
            ctrl_WB_r        <= {`CTRLWB_WIDTH{1'b0}}; 
            ctrl_MEM_r       <= {`CTRLMEM_WIDTH{1'b0}}; 
            Link_Addr_r      <= {`BUS_WIDTH{1'b0}};
            Target_Addr_r    <= {`BUS_WIDTH{1'b0}};
            Zero_r           <= {1{1'b0}}; 
            ALU_Res_r        <= {`BUS_WIDTH{1'b0}};
			MEM_Write_Addr_r <= {`BUS_WIDTH{1'b0}};
            MEM_Write_Data_r <= {`BUS_WIDTH{1'b0}};
            Reg_Dst_r        <= {`REG_WIDTH{1'b0}}; 
        end else begin
            ctrl_WB_r        <= MUX_ctrl_WB_w;       
            ctrl_MEM_r       <= MUX_ctrl_MEM_w;      
            Link_Addr_r      <= MUX_Link_Addr_w;     
            Target_Addr_r    <= MUX_Target_Addr_w;   
            Zero_r           <= MUX_Zero_w;          
            ALU_Res_r        <= MUX_ALU_Res_w;
			MEM_Write_Addr_r <= MUX_MEM_Write_Addr_w;
            MEM_Write_Data_r <= MUX_MEM_Write_Data_w;
            Reg_Dst_r        <= MUX_Reg_Dst_w;       
        end
    end
    
    assign O_ctrl_WB         = ctrl_WB_r;            
    assign O_ctrl_MEM        = ctrl_MEM_r;
	assign O_ctrl_MEM_NOREG  = MUX_ctrl_MEM_w;	
    assign O_Link_Addr       = Link_Addr_r;          
    assign O_Target_Addr     = Target_Addr_r;        
    assign O_Zero            = Zero_r;               
    assign O_ALU_Res         = ALU_Res_r;
	assign O_MEM_Write_Addr  = MEM_Write_Addr_r;
	assign O_MEM_Write_Addr_NOREG  = MUX_MEM_Write_Addr_w;
	assign O_MEM_Write_Data  = MEM_Write_Data_r;
	assign O_MEM_Write_Data_NOREG  = MUX_MEM_Write_Data_w;	
    assign O_Reg_Dst         = Reg_Dst_r;   
endmodule


module MEM_WB_REG (
// This is the registers between pipeline stages
    // control signals
    clk,nrst,stall,flush,
    // input signals
    I_ctrl_WB,
    I_MEM_Read_Data,
    I_ALU_Res,
    I_Reg_Dst,
	I_Link_Addr,
    I_update_PC,
    I_Target_Addr,
    // output signals
    O_ctrl_WB,
    O_MEM_Read_Data,
    O_ALU_Res,
    O_Reg_Dst,
    O_update_PC,
    O_Link_Addr,
    O_Target_Addr);
    
    input [0:0] clk,nrst,stall,flush;
    input [`CTRLWB_WIDTH-1:0] I_ctrl_WB;         // ctrl signal
    input [`BUS_WIDTH-1:0]    I_MEM_Read_Data;   // read data from Memory
    input [`BUS_WIDTH-1:0]    I_ALU_Res;         // result direct from ALU
    input [`REG_WIDTH-1:0]    I_Reg_Dst;         // destination register for write back.
    input [0:0]               I_update_PC;       // indicates if update the PC in IFstage
    input [`BUS_WIDTH-1:0]    I_Link_Addr;       // the return address for link instruction
    input [`BUS_WIDTH-1:0]    I_Target_Addr;     // the target address for jump and branch instruction
    
    output [`CTRLWB_WIDTH-1:0] O_ctrl_WB;         // ctrl signal
    output [`BUS_WIDTH-1:0]    O_MEM_Read_Data;   // read data from Memory
    output [`BUS_WIDTH-1:0]    O_ALU_Res;         // result direct from ALU
    output [`REG_WIDTH-1:0]    O_Reg_Dst;         // destination register for write back.
    output [0:0]               O_update_PC;       // indicates if update the PC in IFstage
    output [`BUS_WIDTH-1:0]    O_Link_Addr;       // the return address for link instruction
    output [`BUS_WIDTH-1:0]    O_Target_Addr;     // the target address for jump and branch instruction
    
    reg [`CTRLWB_WIDTH-1:0]  MUX_ctrl_WB_w;          
    reg [`BUS_WIDTH-1:0]     MUX_MEM_Read_Data_w;    
    reg [`BUS_WIDTH-1:0]     MUX_ALU_Res_w;     
    reg [`REG_WIDTH-1:0]     MUX_Reg_Dst_w;          
    reg [0:0]                MUX_update_PC_w;        
    reg [`BUS_WIDTH-1:0]     MUX_Link_Addr_w;        
    reg [`BUS_WIDTH-1:0]     MUX_Target_Addr_w;      

    reg [`CTRLWB_WIDTH-1:0]  ctrl_WB_r;        
    reg [`BUS_WIDTH-1:0]     MEM_Read_Data_r;  
    reg [`BUS_WIDTH-1:0]     ALU_Res_r;  
    reg [`REG_WIDTH-1:0]     Reg_Dst_r;        
    reg [0:0]                update_PC_r;      
    reg [`BUS_WIDTH-1:0]     Link_Addr_r;      
    reg [`BUS_WIDTH-1:0]     Target_Addr_r;    
      
    always@(*) // MUX                                      
    begin                                                  
        case({stall,flush})                               
            2'b00: begin // transmit                       
                MUX_ctrl_WB_w        = I_ctrl_WB;        
                MUX_MEM_Read_Data_w  = I_MEM_Read_Data;  
                MUX_ALU_Res_w        = I_ALU_Res;         
                MUX_Reg_Dst_w        = I_Reg_Dst;       
                MUX_update_PC_w      = I_update_PC;     
                MUX_Link_Addr_w      = I_Link_Addr;     
                MUX_Target_Addr_w    = I_Target_Addr;     
            end                                            
            2'b01: begin // flush                          
                MUX_ctrl_WB_w        = {`CTRLWB_WIDTH{1'b0}};        
                MUX_MEM_Read_Data_w  = {`BUS_WIDTH{1'b0}};       
                MUX_ALU_Res_w        = {`BUS_WIDTH{1'b0}};       
                MUX_Reg_Dst_w        = {`REG_WIDTH{1'b0}};        
                MUX_update_PC_w      = {1{1'b0}};       
                MUX_Link_Addr_w      = {`BUS_WIDTH{1'b0}};      
                MUX_Target_Addr_w    = {`BUS_WIDTH{1'b0}};            
            end                                           
            2'b10: begin // stall                         
                MUX_ctrl_WB_w        = ctrl_WB_r;      
                MUX_MEM_Read_Data_w  = MEM_Read_Data_r;
                MUX_ALU_Res_w        = ALU_Res_r; 
                MUX_Reg_Dst_w        = Reg_Dst_r;      
                MUX_update_PC_w      = update_PC_r;    
                MUX_Link_Addr_w      = Link_Addr_r;    
                MUX_Target_Addr_w    = Target_Addr_r;   
            end                                           
            default: begin // na                          
                MUX_ctrl_WB_w        = {`CTRLWB_WIDTH{1'bx}};        
                MUX_MEM_Read_Data_w  = {`BUS_WIDTH{1'bx}};       
                MUX_ALU_Res_w        = {`BUS_WIDTH{1'bx}};       
                MUX_Reg_Dst_w        = {`REG_WIDTH{1'bx}};        
                MUX_update_PC_w      = {1{1'bx}};        
                MUX_Link_Addr_w      = {`BUS_WIDTH{1'bx}};       
                MUX_Target_Addr_w    = {`BUS_WIDTH{1'bx}};       
            end                                           
        endcase                                           
    end 
             
    always@(posedge clk) // reg
    begin
        if (!nrst) begin
            ctrl_WB_r       <= {`CTRLWB_WIDTH{1'b0}};
            MEM_Read_Data_r <= {`BUS_WIDTH{1'b0}};
            ALU_Res_r       <= {`BUS_WIDTH{1'b0}};
            Reg_Dst_r       <= {`REG_WIDTH{1'b0}};
            update_PC_r     <= {1{1'b0}};
            Link_Addr_r     <= {`BUS_WIDTH{1'b0}};
            Target_Addr_r   <= {`BUS_WIDTH{1'b0}};
        end else begin
            ctrl_WB_r       <= MUX_ctrl_WB_w;       
            MEM_Read_Data_r <= MUX_MEM_Read_Data_w; 
            ALU_Res_r       <= MUX_ALU_Res_w;  
            Reg_Dst_r       <= MUX_Reg_Dst_w;       
            update_PC_r     <= MUX_update_PC_w;     
            Link_Addr_r     <= MUX_Link_Addr_w;     
            Target_Addr_r   <= MUX_Target_Addr_w;   
        end
    end
    
    assign O_ctrl_WB       =  ctrl_WB_r;            
    assign O_MEM_Read_Data =  MEM_Read_Data_r;      
    assign O_ALU_Res       =  ALU_Res_r;       
    assign O_Reg_Dst       =  Reg_Dst_r;            
    assign O_update_PC     =  MUX_update_PC_w;   // stall and flush them       
    assign O_Link_Addr     =  Link_Addr_r;        
    assign O_Target_Addr   =  MUX_Target_Addr_w; // but not reg them 
endmodule

module MIPS2K (clk2,nrst,GPIO);
    input [0:0] clk2,nrst;
	output [`BUS_WIDTH-1:0] GPIO;
	
	// create clock
	wire [0:0] clk;
	clock_divider clock_unit (clk2,nrst,clk);
	
	// create global counter
	wire [`BUS_WIDTH-1:0] count;
	GlobalCounter glocnt_unit (clk2,nrst,count);
    
    // -------- Internal Signals -------- //
    // IF stage
    wire [`BUS_WIDTH-1:0] IF2ID_Next_PC;     
    wire [`BUS_WIDTH-1:0] IF2ID_Instruction;
    wire [0:0]            MEM2IF_Reg_Update_PC;  // After the REG between pipeline stages
    wire [`BUS_WIDTH-1:0] MEM2IF_Reg_Target_Addr;
    
    wire [`BUS_WIDTH-1:0] IF2ID_Reg_Next_PC;     
    wire [`BUS_WIDTH-1:0] IF2ID_Reg_Instruction;
	wire [`BUS_WIDTH-1:0] IF2ID_Reg_Instruction_NOREG; // removed the register, since RegFile_IP includes input register
        
    wire [4:0] stall;
    wire [3:0] flush;
    
    // ID stage
    wire [0:0]                WB2ID_Write;
    wire [`REG_WIDTH-1:0]     WB2ID_Write_Addr;
    wire [`BUS_WIDTH-1:0]     WB2ID_Write_Data;
    wire [`BUS_WIDTH-1:0]     ID2EXE_Immediate; 
    wire [`REG_WIDTH-1:0]     ID2EXE_rt_Addr;
    wire [`REG_WIDTH-1:0]     ID2EXE_rs_Addr;
    wire [`REG_WIDTH-1:0]     ID2EXE_rd_Addr; 
    wire [`BUS_WIDTH-1:0]     ID2EXE_rs_Data;
    wire [`BUS_WIDTH-1:0]     ID2EXE_rt_Data; 
    wire [`SHAMT_WIDTH-1:0]   ID2EXE_Shamt;          
    wire [`JMPADDR_WIDTH-1:0] ID2EXE_Target_Addr;    
    wire [`BUS_WIDTH-1:0]     ID2EXE_Next_PC;          
    wire [`CTRLWB_WIDTH-1:0]  ID2EXE_ctrl_WB;           
    wire [`CTRLEXE_WIDTH-1:0] ID2EXE_ctrl_EXE;          
    wire [`CTRLMEM_WIDTH-1:0] ID2EXE_ctrl_MEM;          
    wire [`OP_WIDTH-1:0]      ID2EXE_op;
    
    wire [`BUS_WIDTH-1:0]     ID2EXE_Reg_Immediate; 
    wire [`REG_WIDTH-1:0]     ID2EXE_Reg_rt_Addr;
    wire [`REG_WIDTH-1:0]     ID2EXE_Reg_rs_Addr;
    wire [`REG_WIDTH-1:0]     ID2EXE_Reg_rd_Addr; 
    wire [`BUS_WIDTH-1:0]     ID2EXE_Reg_rs_Data;
    wire [`BUS_WIDTH-1:0]     ID2EXE_Reg_rt_Data; 
    wire [`SHAMT_WIDTH-1:0]   ID2EXE_Reg_Shamt;          
    wire [`JMPADDR_WIDTH-1:0] ID2EXE_Reg_Target_Addr;    
    wire [`BUS_WIDTH-1:0]     ID2EXE_Reg_Next_PC;          
    wire [`CTRLWB_WIDTH-1:0]  ID2EXE_Reg_ctrl_WB;           
    wire [`CTRLEXE_WIDTH-1:0] ID2EXE_Reg_ctrl_EXE;          
    wire [`CTRLMEM_WIDTH-1:0] ID2EXE_Reg_ctrl_MEM;          
    wire [`OP_WIDTH-1:0]      ID2EXE_Reg_op;
    
    // EXE stage
    wire [`CTRLWB_WIDTH-1:0]  EXE2MEM_ctrl_WB;    
    wire [`CTRLMEM_WIDTH-1:0] EXE2MEM_ctrl_MEM;     
    wire [`BUS_WIDTH-1:0]     EXE2MEM_Link_Addr;     
    wire [`BUS_WIDTH-1:0]     EXE2MEM_Target_Addr;     
    wire [0:0]                EXE2MEM_Zero;          
    wire [`BUS_WIDTH-1:0]     EXE2MEM_ALU_Res;
	wire [`BUS_WIDTH-1:0]     EXE2MEM_MEM_Write_Addr;
    wire [`BUS_WIDTH-1:0]     EXE2MEM_MEM_Write_Data;  
    wire [`REG_WIDTH-1:0]     EXE2MEM_Reg_Dst;        
    
    wire [`CTRLWB_WIDTH-1:0]  EXE2MEM_Reg_ctrl_WB;    
    wire [`CTRLMEM_WIDTH-1:0] EXE2MEM_Reg_ctrl_MEM;
	wire [`CTRLMEM_WIDTH-1:0] EXE2MEM_Reg_ctrl_MEM_NOREG;	// removed register, since ICache_IP includes input register
    wire [`BUS_WIDTH-1:0]     EXE2MEM_Reg_Link_Addr;     
    wire [`BUS_WIDTH-1:0]     EXE2MEM_Reg_Target_Addr;     
    wire [0:0]                EXE2MEM_Reg_Zero;          
    wire [`BUS_WIDTH-1:0]     EXE2MEM_Reg_ALU_Res;
	wire [`BUS_WIDTH-1:0]     EXE2MEM_Reg_MEM_Write_Addr;
	wire [`BUS_WIDTH-1:0]     EXE2MEM_Reg_MEM_Write_Addr_NOREG; // removed register, since ICache_IP includes input register
    wire [`BUS_WIDTH-1:0]     EXE2MEM_Reg_MEM_Write_Data;
	wire [`BUS_WIDTH-1:0]     EXE2MEM_Reg_MEM_Write_Data_NOREG; // removed register, since ICache_IP includes input register
    wire [`REG_WIDTH-1:0]     EXE2MEM_Reg_Reg_Dst;
    wire [`BUS_WIDTH-1:0]     EXE2WB_MULDIV_H;
    wire [`BUS_WIDTH-1:0]     EXE2WB_MULDIV_L;
    wire [0:0]                EXE2WB_MUL_UPDATE;
    wire [0:0]                EXE2WB_DIV_UPDATE;
    
    wire [3:0]  MULDIV_occupied;
    wire [3:0]  MULDIV_abort;
    wire [1:0]  select_forward_exe_rs;
    wire [1:0]  select_forward_exe_rt;
    wire [1:0]  select_forward_op1;
    wire [1:0]  select_forward_op0;
	wire [1:0]  select_forward_w_data;
    
    // MEM stage
    wire [`CTRLWB_WIDTH-1:0]  MEM2WB_ctrl_WB;        
    wire [`BUS_WIDTH-1:0]     MEM2WB_MEM_Read_Data;   
    wire [`BUS_WIDTH-1:0]     MEM2WB_ALU_Res;
    wire [`REG_WIDTH-1:0]     MEM2WB_Reg_Dst;                
    wire [`BUS_WIDTH-1:0]     MEM2WB_Link_Addr;
    wire [0:0]                MEM2IF_Update_PC;
    wire [`BUS_WIDTH-1:0]     MEM2IF_Target_Addr;
      
    wire [`CTRLWB_WIDTH-1:0]  MEM2WB_Reg_ctrl_WB;
    wire [`BUS_WIDTH-1:0]     MEM2WB_Reg_MEM_Read_Data;   
    wire [`BUS_WIDTH-1:0]     MEM2WB_Reg_ALU_Res;
    wire [`REG_WIDTH-1:0]     MEM2WB_Reg_Reg_Dst;                
    wire [`BUS_WIDTH-1:0]     MEM2WB_Reg_Link_Addr;
    
    // WB stage
    wire [`REG_WIDTH-1:0]     WB2ID_Reg_Write_Addr;
    wire [`BUS_WIDTH-1:0]     WB2ID_Reg_Write_Data;
    wire [0:0]                WB2ID_Reg_Write;
    
    // -------- Structural Description -------- //
    // IF stage structure
    IFstage IFstage_U (clk,nrst,stall[4],
        // input signals
        MEM2IF_Reg_Update_PC,
        MEM2IF_Reg_Target_Addr,
        // output signals
        IF2ID_Next_PC,
        IF2ID_Instruction
        );
             
    IF_ID_REG IF_ID_REG_U (clk,nrst,stall[3],flush[3],
		IF2ID_Next_PC,
		IF2ID_Instruction,
		
		IF2ID_Reg_Next_PC,
		IF2ID_Reg_Instruction,
		IF2ID_Reg_Instruction_NOREG
		);

    // ID stage            
    IDstage IDstage_U (clk,clk2,nrst,
		// input signals
		IF2ID_Reg_Instruction,
		IF2ID_Reg_Instruction_NOREG,
		IF2ID_Reg_Next_PC,
		WB2ID_Write,
		WB2ID_Write_Addr,
		WB2ID_Write_Data,
		// output signals
		ID2EXE_Immediate,
		ID2EXE_rt_Addr,
		ID2EXE_rs_Addr,
		ID2EXE_rd_Addr,
		ID2EXE_rs_Data,
		ID2EXE_rt_Data,
		ID2EXE_Shamt,
		ID2EXE_Target_Addr,
		ID2EXE_Next_PC,
		ID2EXE_op,
		ID2EXE_ctrl_WB,
		ID2EXE_ctrl_MEM,
		ID2EXE_ctrl_EXE
		);
             
    ID_EXE_REG ID_EXE_REG_U (clk,nrst,stall[2],flush[2],
		ID2EXE_Immediate,
		ID2EXE_rt_Addr,
		ID2EXE_rs_Addr,
		ID2EXE_rd_Addr,
		ID2EXE_rs_Data,
		ID2EXE_rt_Data,
		ID2EXE_Shamt,
		ID2EXE_Target_Addr,
		ID2EXE_Next_PC,
		ID2EXE_op,
		ID2EXE_ctrl_WB,
		ID2EXE_ctrl_MEM,
		ID2EXE_ctrl_EXE,
		
		ID2EXE_Reg_Immediate,
		ID2EXE_Reg_rt_Addr,
		ID2EXE_Reg_rs_Addr,
		ID2EXE_Reg_rd_Addr,
		ID2EXE_Reg_rs_Data,
		ID2EXE_Reg_rt_Data,
		ID2EXE_Reg_Shamt,
		ID2EXE_Reg_Target_Addr,
		ID2EXE_Reg_Next_PC,
		ID2EXE_Reg_op,
		ID2EXE_Reg_ctrl_WB,
		ID2EXE_Reg_ctrl_MEM,
		ID2EXE_Reg_ctrl_EXE
		);
    
    // EXE stage
    EXEstage EXEstage_U (clk,nrst,
		// input signals
		// forward signals
		MULDIV_abort,
		select_forward_exe_rs,
		select_forward_exe_rt,
		select_forward_op1,
		select_forward_op0,
		select_forward_w_data,
		EXE2WB_MULDIV_H,
		EXE2WB_MULDIV_L,
		EXE2MEM_Reg_ALU_Res,
		EXE2MEM_Reg_ALU_Res,
		MEM2WB_Reg_ALU_Res,
		WB2ID_Reg_Write_Data,
		// general input signals
		ID2EXE_Reg_Immediate,
		ID2EXE_Reg_rt_Addr,
		ID2EXE_Reg_rd_Addr,
		ID2EXE_Reg_rs_Data,
		ID2EXE_Reg_rt_Data,
		ID2EXE_Reg_Shamt,
		ID2EXE_Reg_Target_Addr,
		ID2EXE_Reg_Next_PC,
		ID2EXE_Reg_ctrl_WB,
		ID2EXE_Reg_ctrl_MEM,
		ID2EXE_Reg_ctrl_EXE,
		ID2EXE_Reg_op,
		// output signals
		EXE2MEM_ctrl_WB,
		EXE2MEM_ctrl_MEM,
		EXE2MEM_Link_Addr,
		EXE2MEM_Target_Addr,
		EXE2MEM_Zero,
		EXE2MEM_ALU_Res,
		EXE2MEM_MEM_Write_Data,
		EXE2MEM_Reg_Dst,
		EXE2WB_MULDIV_H,
		EXE2WB_MULDIV_L,
		MULDIV_occupied
		);
              
    EXE_MEM_REG EXE_MEM_REG_U (clk,nrst,stall[1],flush[1],
		EXE2MEM_ctrl_WB,
		EXE2MEM_ctrl_MEM,
		EXE2MEM_Link_Addr,
		EXE2MEM_Target_Addr,
		EXE2MEM_Zero,
		EXE2MEM_ALU_Res,
		EXE2MEM_ALU_Res,
		EXE2MEM_MEM_Write_Data,
		
		EXE2MEM_Reg_Dst,
		EXE2MEM_Reg_ctrl_WB,
		EXE2MEM_Reg_ctrl_MEM,
		EXE2MEM_Reg_ctrl_MEM_NOREG,
		EXE2MEM_Reg_Link_Addr,
		EXE2MEM_Reg_Target_Addr,
		EXE2MEM_Reg_Zero,
		EXE2MEM_Reg_ALU_Res,
		EXE2MEM_Reg_MEM_Write_Addr,
		EXE2MEM_Reg_MEM_Write_Addr_NOREG,
		EXE2MEM_Reg_MEM_Write_Data,
		EXE2MEM_Reg_MEM_Write_Data_NOREG,
		EXE2MEM_Reg_Reg_Dst
		);          
    
    PipeCtrl PipeCtrl_U (clk,nrst,
		// input signals
		ID2EXE_Reg_rt_Addr,
		ID2EXE_Reg_rs_Addr,
		ID2EXE_rt_Addr,
		EXE2MEM_Reg_Reg_Dst,
		MEM2WB_Reg_Reg_Dst,
		WB2ID_Reg_Write_Addr,
		EXE2MEM_Reg_ctrl_WB[5],
		MEM2WB_Reg_ctrl_WB[5],
		WB2ID_Reg_Write,
		ID2EXE_Reg_ctrl_MEM[2],
		MEM2IF_Update_PC,
		ID2EXE_Reg_ctrl_EXE,
		1'b0,//I_EXEMEM_mflo,
		1'b0,//I_EXEMEM_mfhi,
		MULDIV_occupied,
		// output signals
		stall,
		flush, 
		MULDIV_abort,
		select_forward_exe_rs,
		select_forward_exe_rt,
		select_forward_op1,
		select_forward_op0,
		select_forward_w_data
		);
              
    // MEM stage
    MEMstage MEMstage_U (clk,nrst,
		// input signals
		EXE2MEM_Reg_ctrl_WB,
		EXE2MEM_Reg_ctrl_MEM,
		EXE2MEM_Reg_ctrl_MEM_NOREG,
		EXE2MEM_Reg_Link_Addr,
		EXE2MEM_Reg_Target_Addr,
		EXE2MEM_Reg_Zero,
		EXE2MEM_Reg_ALU_Res,
		EXE2MEM_Reg_MEM_Write_Addr,
		EXE2MEM_Reg_MEM_Write_Addr_NOREG,
		EXE2MEM_Reg_MEM_Write_Data,
		EXE2MEM_Reg_MEM_Write_Data_NOREG,
		EXE2MEM_Reg_Reg_Dst,
		// output signals
		MEM2WB_ctrl_WB,
		MEM2WB_MEM_Read_Data,
		MEM2WB_ALU_Res,
		MEM2WB_Reg_Dst,
		MEM2WB_Link_Addr,
		MEM2IF_Target_Addr,
		MEM2IF_Update_PC,
		GPIO
		);
              
    MEM_WB_REG MEM_WB_REG_U (clk,nrst,stall[0],flush[0],
		MEM2WB_ctrl_WB,
		MEM2WB_MEM_Read_Data,
		MEM2WB_ALU_Res,
		MEM2WB_Reg_Dst,
		MEM2WB_Link_Addr,
		MEM2IF_Update_PC,
		MEM2IF_Target_Addr,
		
		MEM2WB_Reg_ctrl_WB,
		MEM2WB_Reg_MEM_Read_Data,
		MEM2WB_Reg_ALU_Res,
		MEM2WB_Reg_Reg_Dst,
		MEM2IF_Reg_Update_PC,
		MEM2WB_Reg_Link_Addr,
		MEM2IF_Reg_Target_Addr
		);
    
    // WB stage
    WBstage WBstage_U (clk,nrst,
		// input signals
		MEM2WB_Reg_ctrl_WB,
		MEM2WB_Reg_MEM_Read_Data,
		MEM2WB_Reg_ALU_Res,
		MEM2WB_Reg_Reg_Dst,
		MEM2WB_Reg_Link_Addr,
		EXE2WB_MULDIV_H,
		EXE2WB_MULDIV_L,
		// output signals
		WB2ID_Write_Addr,
		WB2ID_Write_Data,
		WB2ID_Write
		);
    
	DFF #(`REG_WIDTH) dff_wb_u0 (clk,nrst,WB2ID_Write_Addr,WB2ID_Reg_Write_Addr);
    DFF #(`BUS_WIDTH) dff_wb_u1 (clk,nrst,WB2ID_Write_Data,WB2ID_Reg_Write_Data);
    DFF #(1)          dff_wb_u2 (clk,nrst,WB2ID_Write,WB2ID_Reg_Write);
endmodule