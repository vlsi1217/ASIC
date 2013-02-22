module alu_with_z1 (alu_out, data_a, data_b, enable, opcode);
  input		[2: 0]	opcode;
  input		[3: 0]	data_a, data_b;
  input			enable;
  output 			alu_out;		// scalar for illustration
  reg 		[3: 0]	alu_reg;

  assign alu_out = (enable == 1) ? alu_reg : 4'bz;

  always @  (opcode or data_a or data_b)
    case (opcode)
      3'b001:	alu_reg = data_a | data_b;
      3'b010: 	alu_reg = data_a ^ data_b;
      3'b110:	alu_reg = ~data_b;
      default:	alu_reg = 4'b0;	// alu_with_z2 has default: alu_reg = 4'bx;
    endcase
endmodule

