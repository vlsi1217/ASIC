module top(input clk, reset, 
           output [31:0] aluout, writedata, readdata, output memwrite);

  wire [31:0] pc, instr;

  // instantiate devices to be tested
  mips dut(clk, reset, pc, instr,
           memwrite, aluout, writedata, readdata);
  imem imem(pc[7:2], instr);
  dmem dmem(clk, memwrite, aluout, 
            writedata, readdata);

endmodule
