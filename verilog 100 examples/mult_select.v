`include "oc8051_timescale.v"
// synopsys translate_on

`include "oc8051_defines.v"


module oc8051_alu_src1_sel (sel, immediate, acc, ram, ext, des);
//
// sel          (in)  select signals (from decoder, delayd one clock) [oc8051_decoder.src_sel1 -r]
// immediate    (in)  immediate operand [oc8051_immediate_sel.out1]
// acc          (in)  accomulator [oc8051_acc.data_out]
// ram          (in)  ram input [oc8051_ram_sel.out_data]
// ext          (in)  external ram input [pin]
// des          (out) output (alu sorce 1) [oc8051_alu.src1]
//


input [1:0] sel; input [7:0] immediate, acc, ram, ext;
output [7:0] des;
reg [7:0] des;

always @(sel or immediate or acc or ram or ext)
begin
  case (sel)
    `OC8051_ASS_RAM: des= ram;
    `OC8051_ASS_ACC: des= acc;
    `OC8051_ASS_XRAM: des= ext;
    `OC8051_ASS_IMM: des= immediate;
    default: des= 2'bxx;
  endcase
end

endmodule
