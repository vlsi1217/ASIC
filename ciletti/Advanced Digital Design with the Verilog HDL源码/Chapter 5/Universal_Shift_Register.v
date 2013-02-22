module Universal_Shift_Reg   (Data_Out, MSB_Out, LSB_Out, Data_In, 
   MSB_In, LSB_In, s1, s0, clk, rst);
  output 	[3: 0] 	Data_Out;
  output 			MSB_Out, LSB_Out;
  input 	[3: 0] 	Data_In;
  input 			MSB_In, LSB_In;
  reg 	[3: 0]	Data_Out; // 10-12-2004
  input 			s1, s0, clk, rst;

  assign MSB_Out = Data_Out[3];
  assign LSB_Out = Data_Out[0];

  always @ (posedge clk) begin
    if (rst) Data_Out <= 0; 
    else  case ({s1, s0})
      0:	Data_Out <= Data_Out;	// Idle
      1:	Data_Out <= {MSB_In, Data_Out[3:1]}; // Shift right
      2:	Data_Out <= {Data_Out[2:0], LSB_In};  // Shift Left
      3:	Data_Out <= Data_In;  // Parallel Load
    endcase
end

endmodule


module t_Universal_Shift_Reg();
wire 	[3: 0] 	Data_Out;
reg 	[3: 0] 	Data_In;
wire 			MSB_Out, LSB_Out;
reg 			MSB_In, LSB_In;
reg 			s1, s0, rst;
defparam M2.half_cycle = 10;

Universal_Shift_Reg M1 (Data_Out, MSB_Out, LSB_Out, Data_In, MSB_In, LSB_In, s1, s0, clk, rst);
Clock_Gen  M2(clk);



initial #1000 $finish;
initial fork
begin #5 rst = 1; #20 rst = 0;end
begin #120 rst = 1; #20 rst = 0;end
begin #260 rst = 1; #20 rst = 0;end
begin #380 rst = 1; #20 rst = 0;end

join

initial fork
#5 fork // Verify right shift
#5 begin Data_In = 4'b1111; s0 = 0; s1 = 0; LSB_In = 1; MSB_In = 1; end
#35 s0 = 1;
join

#120 fork
begin // Verify left shift
#10 Data_In = 4'b1111; s0 = 0; s1 = 0; LSB_In = 1; MSB_In = 1; end
#35 s1 = 1;
join

#255 fork
begin // Verify load
#10 Data_In = 4'b1111; s0 = 0; s1 = 0; LSB_In = 1; MSB_In = 1; end
#35 begin s0 = 1; s1 = 1;end
join

#320 fork
begin // reset
#10 Data_In = 4'b1111; s0 = 0; s1 = 0; LSB_In = 1; MSB_In = 1; end
#35 begin s0 = 0; s1 = 0;end
join

join
endmodule
