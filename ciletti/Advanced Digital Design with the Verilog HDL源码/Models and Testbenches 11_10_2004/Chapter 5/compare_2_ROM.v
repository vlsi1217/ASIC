module ROM_16_x_4 (ROM_data, ROM_addr);
  output [3:0] ROM_data;
  input 	[3:0] ROM_addr;
  reg 	[3:0] ROM [15:0];
  wire [3:0] word1 = ROM[1];
  assign ROM_data = ROM[ROM_addr];
  initial begin #1  $readmemb ("ROM_Data_2bit_Comparator.txt",  ROM, 0, 15); end
endmodule


module comp_2_ROM (A_gt_B, A_lt_B, A_eq_B, A1, A0, B1, B0);
  output A_gt_B, A_lt_B, A_eq_B;
  input 	A1, A0, B1, B0;
  wire [3:0] ROM_addr, ROM_data;
 
  assign ROM_addr = {A1, A0, B1, B0};
  assign {A_gt_B, A_lt_B, A_eq_B} = ROM_data[3:1] ;
 
  ROM_16_x_4 M1 (ROM_data, ROM_addr);
endmodule


module test_comp_2_ROM();
wire 	A_gt_B, A_lt_B, A_eq_B;
reg [2:0] A, B;
  
comp_2_ROM M1 (A_gt_B, A_lt_B, A_eq_B, A[1], A[0], B[1], B[0]);


initial #2000 $finish;

initial begin
#5 for (A = 0; A < 4; A = A + 1) begin 
for (B = 0; B < 4; B = B + 1) begin #5;
end
end
end
endmodule

