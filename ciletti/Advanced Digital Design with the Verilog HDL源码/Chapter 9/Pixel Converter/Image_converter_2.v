module Image_Converter_2( 
  HTPV_Row_1, HTPV_Row_2, HTPV_Row_3, 	 
  HTPV_Row_4, HTPV_Row_5, HTPV_Row_6, 
Done,
pixel_1,    pixel_2,  pixel_3,   pixel_4,   pixel_5,   pixel_6,   pixel_7,   pixel_8,
pixel_9,   pixel_10, pixel_11, pixel_12, pixel_13, pixel_14, pixel_15, pixel_16,
pixel_17, pixel_18, pixel_19, pixel_20, pixel_21, pixel_22, pixel_23, pixel_24,
pixel_25, pixel_26, pixel_27, pixel_28, pixel_29, pixel_30, pixel_31, pixel_32,
pixel_33, pixel_34, pixel_35, pixel_36, pixel_37, pixel_38, pixel_39, pixel_40,
pixel_41, pixel_42, pixel_43, pixel_44, pixel_45, pixel_46, pixel_47, pixel_48,
Go, clk, reset);

output 	[1: 8]	HTPV_Row_1, HTPV_Row_2, HTPV_Row_3,
		HTPV_Row_4, HTPV_Row_5, HTPV_Row_6; 
output		Done;
input [7: 0]	pixel_1,  pixel_2,  pixel_3,  pixel_4,  pixel_5,  pixel_6,  pixel_7,  pixel_8;
input	[7: 0]	pixel_9,  pixel_10, pixel_11, pixel_12, pixel_13, pixel_14, pixel_15, pixel_16;
input	[7: 0]	pixel_17, pixel_18, pixel_19, pixel_20, pixel_21, pixel_22, pixel_23, pixel_24;
input	[7: 0]	pixel_25, pixel_26, pixel_27, pixel_28, pixel_29, pixel_30, pixel_31, pixel_32;
input	[7: 0]	pixel_33, pixel_34, pixel_35, pixel_36, pixel_37, pixel_38, pixel_39, pixel_40;
input	[7: 0]	pixel_41, pixel_42, pixel_43, pixel_44, pixel_45, pixel_46, pixel_47, pixel_48;
input	Go, clk, reset;
wire	[23: 0]	index;
wire		Ld_image, Ld_values;

wire	[7: 0]	PP_1_Err_1, PP_1_Err_2, PP_1_Err_3, PP_1_Err_4, PP_1_PV, 
		PP_2_Err_1, PP_2_Err_2, PP_2_Err_3, PP_2_Err_4, PP_2_PV, 
		PP_3_Err_1, PP_3_Err_2, PP_3_Err_3, PP_3_Err_4, PP_3_PV, 
		PP_4_Err_1, PP_4_Err_2, PP_4_Err_3, PP_4_Err_4, PP_4_PV;

wire	[7: 0]	PP_1_Err_0, PP_2_Err_0, PP_3_Err_0, PP_4_Err_0;
wire		PP_1_HTPV, PP_2_HTPV, PP_3_HTPV, PP_4_HTPV;

wire	[7: 0] 	Err_1, Err_2, Err_3, Err_4, PV;

PP_Control_Unit M0 (index, Ld_image, Ld_values, Done, Go, clk, reset);

PP_Datapath_Unit M1 (PP_1_Err_0, PP_1_HTPV, PP_1_Err_1, PP_1_Err_2, PP_1_Err_3, PP_1_Err_4, PP_1_PV);
PP_Datapath_Unit M2 (PP_2_Err_0, PP_2_HTPV, PP_2_Err_1, PP_2_Err_2, PP_2_Err_3, PP_2_Err_4, PP_2_PV);
PP_Datapath_Unit M3 (PP_3_Err_0, PP_3_HTPV, PP_3_Err_1, PP_3_Err_2, PP_3_Err_3, PP_3_Err_4, PP_3_PV);
PP_Datapath_Unit M4 (PP_4_Err_0, PP_4_HTPV, PP_4_Err_1, PP_4_Err_2, PP_4_Err_3, PP_4_Err_4, PP_4_PV);

Pixel_Memory_Unit M5 (	HTPV_Row_1, HTPV_Row_2, HTPV_Row_3, 
			HTPV_Row_4, HTPV_Row_5, HTPV_Row_6,

			PP_1_Err_1, PP_1_Err_2, PP_1_Err_3, PP_1_Err_4, PP_1_PV, 
			PP_2_Err_1, PP_2_Err_2, PP_2_Err_3, PP_2_Err_4, PP_2_PV, 
			PP_3_Err_1, PP_3_Err_2, PP_3_Err_3, PP_3_Err_4, PP_3_PV, 
			PP_4_Err_1, PP_4_Err_2, PP_4_Err_3, PP_4_Err_4, PP_4_PV, 
			PP_1_Err_0, PP_2_Err_0, PP_3_Err_0, PP_4_Err_0,
			PP_1_HTPV, PP_2_HTPV, PP_3_HTPV, PP_4_HTPV,

			pixel_1, pixel_2, pixel_3, pixel_4, pixel_5, pixel_6, pixel_7, pixel_8,
			pixel_9, pixel_10, pixel_11, pixel_12, pixel_13, pixel_14, pixel_15, pixel_16,
			pixel_17, pixel_18, pixel_19, pixel_20, pixel_21, pixel_22, pixel_23, pixel_24,
			pixel_25, pixel_26, pixel_27, pixel_28, pixel_29, pixel_30, pixel_31, pixel_32, 
			pixel_33, pixel_34, pixel_35, pixel_36, pixel_37, pixel_38, pixel_39, pixel_40,
			pixel_41, pixel_42, pixel_43, pixel_44, pixel_45, pixel_46, pixel_47, pixel_48,

			index, Ld_image, Ld_values, Go, clk);
endmodule

module PP_Control_Unit (index, Ld_image, Ld_values, Done, Go, clk, reset);
  output	[23: 0]	index;
  output		Ld_image, Ld_values, Done;
  input		Go, clk, reset;
  reg	[5:0]	state, next_state;
  reg		Ld_image, Ld_values, Done, index;
  parameter S_idle = 0;
  parameter S_1 = 1, S_2 = 2, S_3 = 3, S_4 = 4, S_5 = 5, S_6 = 6, S_7 = 7, S_8 = 8;
  parameter S_9 = 9, S_10 = 10, S_11 = 11, S_12 = 12, S_13 = 13, S_14 = 14, S_15 = 15, S_16 = 16;
  parameter S_17 = 17, S_18 = 18, S_19 = 19, S_20 = 20, S_21 = 21, S_22 = 22, S_23 = 23, S_24 = 24;
  parameter S_25 = 25, S_26 = 26, S_27 = 27, S_28 = 28, S_29 = 29, S_30 = 30, S_31 = 31, S_32 = 32;
  parameter S_33 = 33, S_34 = 34, S_35 = 35, S_36 = 36, S_37 = 37, S_38 = 38, S_39 = 39, S_40 = 40;
  parameter S_41 = 41, S_42 = 42, S_43 = 43, S_44 = 44, S_45 = 45, S_46 = 46, S_47 = 47, S_48 = 48;

  always @ (posedge clk) if (reset) state <= S_idle; else state <= next_state;

  always @  (state or Go) begin
    Ld_values = 0;  next_state = state;
    if ((state == S_idle) && Go) next_state = S_1; 
    else if ((state > 0) && (state < 18)) begin next_state = state+1; Ld_values = 1; end
    else if (state == S_18) begin next_state = S_idle; Ld_values = 1; end
  end

 always @  (state or Go) begin
  Done = 0; index = 0; Ld_image = 0;
 case (state) 
    S_idle:	begin	index = {{6'd0}, {6'd0}, {6'd0}, {6'd0}};Done = 1; if (Go) Ld_image = 1;end
    S_1:			index = {{6'd1}, {6'd0}, {6'd0}, {6'd0}};
    S_2:			index = {{6'd2}, {6'd0}, {6'd0}, {6'd0}};
    S_3:			index = {{6'd3}, {6'd9}, {6'd0}, {6'd0}};
    S_4:			index = {{6'd4}, {6'd10}, {6'd0}, {6'd0}};
    S_5:			index = {{6'd5}, {6'd11}, {6'd17}, {6'd0}};		 
    S_6:			index = {{6'd6}, {6'd12}, {6'd18}, {6'd0}};	 
    S_7:			index = {{6'd7}, {6'd13}, {6'd19}, {6'd25}};	 
    S_8:			index = {{6'd8}, {6'd14}, {6'd20}, {6'd26}};
    S_9:			index = {{6'd15}, {6'd21}, {6'd27}, {6'd33}};
    S_10:			index = {{6'd16}, {6'd22}, {6'd28}, {6'd34}};
    S_11:			index = {{6'd23}, {6'd29}, {6'd35}, {6'd41}};
    S_12:			index = {{6'd24}, {6'd30}, {6'd36}, {6'd42}};
    S_13:			index = {{6'd0}, {6'd31}, {6'd37}, {6'd43}};
    S_14:			index = {{6'd0}, {6'd32}, {6'd38}, {6'd44}};
    S_15:			index = {{6'd0}, {6'd0}, {6'd39}, {6'd45}};
    S_16:			index = {{6'd0}, {6'd0}, {6'd40}, {6'd46}};
    S_17:			index = {{6'd0}, {6'd0}, {6'd0}, {6'd47}};
    S_18:			index = {{6'd0}, {6'd0}, {6'd0}, {6'd48}};
  endcase
end
endmodule

module PP_Datapath_Unit (Err_0, HTPV, Err_1, Err_2, Err_3, Err_4, PV);
// hard-wired for 8 x 6 array

  output	[7:0]	Err_0;
  output		HTPV;
  input	[7:0] 	Err_1, Err_2, Err_3, Err_4, PV;

 wire	[9: 0]	CPV, CPV_round, E_av;
 
// Weights for the average error; choose for compatibility with divide-by-16 (>> 4)

parameter	w1 = 2, w2 = 8, w3 = 4, w4 = 2;
 parameter Threshold = 128;

 assign   E_av = (w1 * Err_1 + w2 * Err_2 + w3 * Err_3 + w4 * Err_4 ) >> 4;
 assign	CPV = PV + E_av;
 assign	CPV_round = (CPV < Threshold) ? 0: 255;  
 assign	HTPV = (CPV_round == 0) ? 0: 1;
 assign	Err_0  = CPV - CPV_round;

endmodule

module Pixel_Memory_Unit (
			HTPV_Row_1, HTPV_Row_2, HTPV_Row_3, 
			HTPV_Row_4, HTPV_Row_5, HTPV_Row_6,

			PP_1_Err_1, PP_1_Err_2, PP_1_Err_3, PP_1_Err_4, PP_1_PV, 
			PP_2_Err_1, PP_2_Err_2, PP_2_Err_3, PP_2_Err_4, PP_2_PV, 
			PP_3_Err_1, PP_3_Err_2, PP_3_Err_3, PP_3_Err_4, PP_3_PV, 
			PP_4_Err_1, PP_4_Err_2, PP_4_Err_3, PP_4_Err_4, PP_4_PV, 
			PP_1_Err_0, PP_2_Err_0, PP_3_Err_0, PP_4_Err_0,
			PP_1_HTPV, PP_2_HTPV, PP_3_HTPV, PP_4_HTPV,

			pixel_1, pixel_2, pixel_3, pixel_4, pixel_5, pixel_6, pixel_7, pixel_8,
			pixel_9, pixel_10, pixel_11, pixel_12, pixel_13, pixel_14, pixel_15, pixel_16,
			pixel_17, pixel_18, pixel_19, pixel_20, pixel_21, pixel_22, pixel_23, pixel_24,
			pixel_25, pixel_26, pixel_27, pixel_28, pixel_29, pixel_30, pixel_31, pixel_32, 
			pixel_33, pixel_34, pixel_35, pixel_36, pixel_37, pixel_38, pixel_39, pixel_40,
			pixel_41, pixel_42, pixel_43, pixel_44, pixel_45, pixel_46, pixel_47, pixel_48,

			index, Ld_image, Ld_values, Go, clk);

output 	[1: 8] 		HTPV_Row_1, HTPV_Row_2, HTPV_Row_3, 
			HTPV_Row_4, HTPV_Row_5, HTPV_Row_6; 

output	[7:0]		PP_1_Err_1, PP_1_Err_2, PP_1_Err_3, PP_1_Err_4, PP_1_PV, 
			PP_2_Err_1, PP_2_Err_2, PP_2_Err_3, PP_2_Err_4, PP_2_PV, 
			PP_3_Err_1, PP_3_Err_2, PP_3_Err_3, PP_3_Err_4, PP_3_PV, 
			PP_4_Err_1, PP_4_Err_2, PP_4_Err_3, PP_4_Err_4, PP_4_PV;

input	[7: 0]	PP_1_Err_0, PP_2_Err_0, PP_3_Err_0, PP_4_Err_0;
input	PP_1_HTPV, PP_2_HTPV, PP_3_HTPV, PP_4_HTPV;

input 	[7: 0]	pixel_1,    pixel_2,  pixel_3,   pixel_4,   pixel_5,   pixel_6,   pixel_7,   pixel_8;
input	[7: 0]	pixel_9,   pixel_10, pixel_11, pixel_12, pixel_13, pixel_14, pixel_15, pixel_16;
input	[7: 0]	pixel_17, pixel_18, pixel_19, pixel_20, pixel_21, pixel_22, pixel_23, pixel_24;
input	[7: 0]	pixel_25, pixel_26, pixel_27, pixel_28, pixel_29, pixel_30, pixel_31, pixel_32;
input	[7: 0]	pixel_33, pixel_34, pixel_35, pixel_36, pixel_37, pixel_38, pixel_39, pixel_40;
input	[7: 0]	pixel_41, pixel_42, pixel_43, pixel_44, pixel_45, pixel_46, pixel_47, pixel_48;

input	[23:0] index;
input	Ld_image, Ld_values, Go, clk;

reg 	[7: 0] PV_Row_1 	[1: 8];	reg 	[7: 0] PV_Row_2 	[1: 8];	reg 	[7: 0] PV_Row_3 	[1: 8];	
reg 	[7: 0] PV_Row_4 	[1: 8];	reg 	[7: 0] PV_Row_5 	[1: 8];	reg 	[7: 0] PV_Row_6 	[1: 8];

reg 	HTPV_Row_1, HTPV_Row_2, HTPV_Row_3, HTPV_Row_4, HTPV_Row_5,  HTPV_Row_6; 	 

reg	[7: 0] Err_Row_0 [0: 9];	reg	[7: 0] Err_Row_1 [0: 9];	reg	[7: 0] Err_Row_2 [0: 9];
reg	[7: 0] Err_Row_3 [0: 9];	reg	[7: 0] Err_Row_4 [0: 9];	reg	[7: 0] Err_Row_5 [0: 9];
reg	[7: 0] Err_Row_6 [0: 9];

reg	PP_1_Err_4, PP_1_Err_3, PP_1_Err_2, PP_1_Err_1, PP_1_PV,
	PP_2_Err_4, PP_2_Err_3, PP_2_Err_2, PP_2_Err_1, PP_2_PV, 
	PP_3_Err_4, PP_3_Err_3, PP_3_Err_2, PP_3_Err_1, PP_3_PV, 
	PP_4_Err_4, PP_4_Err_3, PP_4_Err_2, PP_4_Err_1, PP_4_PV;

wire	[5:0]	index_1 = index [23: 18],
		index_2 = index [17: 12],
		index_3 = index [11: 6],
		index_4 = index [5: 0];

 always @ (index_1) begin
case (index_1)
1, 2, 3, 4, 5, 6, 7, 8: 	begin 	
			PP_1_Err_1 = Err_Row_1[index_1-1]; 	PP_1_Err_2 = Err_Row_0[index_1-1];
			PP_1_Err_3 = Err_Row_0[index_1]; 	PP_1_Err_4 = Err_Row_0[index_1+1];
			PP_1_PV = PV_Row_1[index_1]; 
			end

15, 16:			begin 	
			PP_1_Err_1 = Err_Row_2[index_1-1-8]; 	PP_1_Err_2 = Err_Row_1[index_1-1-8];
			PP_1_Err_3 = Err_Row_1[index_1-8]; 	PP_1_Err_4 = Err_Row_1[index_1+1-8];
			PP_1_PV = PV_Row_2[index_1-8]; 
			end

 23, 24: 			begin 	
			PP_1_Err_1 = Err_Row_3[index_1-1-16]; 	PP_1_Err_2 = Err_Row_2[index_1-1-16];
			PP_1_Err_3 = Err_Row_2[index_1-16]; 	PP_1_Err_4 = Err_Row_2[index_1+1-16];
			PP_1_PV = PV_Row_3[index_1-16]; 
			end

default: 			begin 	
			PP_1_Err_1 = 8'bx; 	PP_1_Err_2 = 8'bx;
			PP_1_Err_3 = 8'bx; 	PP_1_Err_4 = 8'bx;
			PP_1_PV = 8'bx; 
			end

endcase
end

always @ (index_2) begin
case (index_2)
9, 10, 11, 12, 13, 14: 	begin 	
			PP_2_Err_1 = Err_Row_2[index_2-1-8]; 	PP_2_Err_2 = Err_Row_1[index_2-1-8];
			PP_2_Err_3 = Err_Row_1[index_2-8]; 	PP_2_Err_4 = Err_Row_1[index_2+1-8];
			PP_2_PV = PV_Row_2[index_2-8]; 
			end

21, 22:			begin 	
			PP_2_Err_1 = Err_Row_3[index_2-1-16]; 	PP_2_Err_2 = Err_Row_2[index_2-1-16];
			PP_2_Err_3 = Err_Row_2[index_2-16]; 	PP_2_Err_4 = Err_Row_2[index_2+1-16];
			PP_2_PV = PV_Row_3[index_2-16]; 
			end

29, 30, 31, 32: 		begin 	
			PP_2_Err_1 = Err_Row_4[index_2-1-24]; 	PP_2_Err_2 = Err_Row_3[index_2-1-24];
			PP_2_Err_3 = Err_Row_3[index_2-24]; 	PP_2_Err_4 = Err_Row_3[index_2+1-24];
			PP_2_PV = PV_Row_4[index_2-24]; 
			end

default: 			begin 	
			PP_2_Err_1 = 8'bx; 	PP_2_Err_2 = 8'bx;
			PP_2_Err_3 = 8'bx; 	PP_2_Err_4 = 8'bx;
			PP_2_PV = 8'bx; 
			end
endcase
end

always @ (index_3) begin
case (index_3)
17, 18, 19, 20:	  	begin 	
			PP_3_Err_1 = Err_Row_3[index_3-1-16]; 	PP_3_Err_2 = Err_Row_2[index_3-1-16];
			PP_3_Err_3 = Err_Row_2[index_3-16]; 	PP_3_Err_4 = Err_Row_2[index_3+1-16];
			PP_3_PV = PV_Row_3[index_3-16]; 
			end

 27,  28:			begin	
			PP_3_Err_1 = Err_Row_4[index_3-1-24]; 	PP_3_Err_2 = Err_Row_3[index_3-1-24];
			PP_3_Err_3 = Err_Row_3[index_3-24]; 	PP_3_Err_4 = Err_Row_3[index_3+1-24];
			PP_3_PV = PV_Row_4[index_3-24]; 
			end

35, 36, 37, 38, 39, 40:	begin 	
			PP_3_Err_1 = Err_Row_5[index_3-1-32]; 	PP_3_Err_2 = Err_Row_4[index_3-1-32];
			PP_3_Err_3 = Err_Row_4[index_3-32]; 	PP_3_Err_4 = Err_Row_4[index_3+1-32];
			PP_3_PV = PV_Row_5[index_3-32]; 
			end

default: 			begin 	
			PP_3_Err_1 = 8'bx; 	PP_3_Err_2 = 8'bx;
			PP_3_Err_3 = 8'bx; 	PP_3_Err_4 = 8'bx;
			PP_3_PV = 8'bx; 
			end
endcase
end

always @ (index_4) begin
case (index_4)
25, 26:	 		begin 	
			PP_4_Err_1 = Err_Row_4[index_4-1-24]; 	PP_4_Err_2 = Err_Row_3[index_4-1-24];
			PP_4_Err_3 = Err_Row_3[index_4-24]; 	PP_4_Err_4 = Err_Row_3[index_4+1-24];
			PP_4_PV = PV_Row_4[index_4-24]; 
			end

33, 34:	 		begin 	
			PP_4_Err_1 = Err_Row_5[index_4-1-32]; 	PP_4_Err_2 = Err_Row_4[index_4-1-32];
			PP_4_Err_3 = Err_Row_4[index_4-32]; 	PP_4_Err_4 = Err_Row_4[index_4+1-32];
			PP_4_PV = PV_Row_5[index_4-32]; 
			end

41, 42, 43, 44, 
45, 46,47, 48: 		begin 	
			PP_4_Err_1 = Err_Row_6[index_4-1-40]; 	PP_4_Err_2 = Err_Row_5[index_4-1-40];
			PP_4_Err_3 = Err_Row_5[index_4-40]; 	PP_4_Err_4 = Err_Row_5[index_4+1-40];
			PP_4_PV = PV_Row_6[index_4-40]; 
			end

default: 			begin 	
			PP_4_Err_1 = 8'bx; 	PP_4_Err_2 = 8'bx;
			PP_4_Err_3 = 8'bx; 	PP_4_Err_4 = 8'bx;
			PP_4_PV = 8'bx; 
			end
endcase
end

always @ (posedge clk ) 
if (Ld_image) begin: Array_Initialization

// Initialize error at left boarder 

  Err_Row_1[0] <= 0;     Err_Row_2[0] <= 0;     Err_Row_3[0] <= 0;
  Err_Row_4[0] <= 0;     Err_Row_5[0] <= 0;     Err_Row_6[0] <= 0;

// Initialize columns in the main array

  Err_Row_1[1] <= 0;  Err_Row_2[1] <= 0;  Err_Row_3[1] <= 0;
  Err_Row_4[1] <= 0;  Err_Row_5[1] <= 0;  Err_Row_6[1] <= 0;

  Err_Row_1[2] <= 0;  Err_Row_2[2] <= 0;  Err_Row_3[2] <= 0;
  Err_Row_4[2] <= 0;  Err_Row_5[2] <= 0;  Err_Row_6[2] <= 0;

  Err_Row_1[3] <= 0;  Err_Row_2[3] <= 0;  Err_Row_3[3] <= 0;
  Err_Row_4[3] <= 0;  Err_Row_5[3] <= 0;  Err_Row_6[3] <= 0;

  Err_Row_1[4] <= 0;  Err_Row_2[4] <= 0;  Err_Row_3[4] <= 0;
  Err_Row_4[4] <= 0;  Err_Row_5[4] <= 0;  Err_Row_6[4] <= 0;

  Err_Row_1[5] <= 0;  Err_Row_2[5] <= 0;  Err_Row_3[5] <= 0;
  Err_Row_4[5] <= 0;  Err_Row_5[5] <= 0;  Err_Row_6[5] <= 0;

  Err_Row_1[6] <= 0;  Err_Row_2[6] <= 0;  Err_Row_3[6] <= 0;
  Err_Row_4[6] <= 0;  Err_Row_5[6] <= 0;  Err_Row_6[6] <= 0;

  Err_Row_1[7] <= 0;  Err_Row_2[7] <= 0;  Err_Row_3[7] <= 0;
  Err_Row_4[7] <= 0;  Err_Row_5[7] <= 0;  Err_Row_6[7] <= 0;

  Err_Row_1[8] <= 0;  Err_Row_2[8] <= 0;  Err_Row_3[8] <= 0;
  Err_Row_4[8] <= 0;  Err_Row_5[8] <= 0;  Err_Row_6[8] <= 0;

// Initalize right boarder

 Err_Row_1[9] <= 0; Err_Row_2[9] <= 0; Err_Row_3[9] <= 0;
 Err_Row_4[9] <= 0; Err_Row_5[9] <= 0; Err_Row_6[9] <= 0;

// Initialize top boarder

 Err_Row_0[0]  <= 0; Err_Row_0[1]  <= 0; Err_Row_0[2]  <= 0; Err_Row_0[3]  <= 0;
 Err_Row_0[4]  <= 0; Err_Row_0[5]  <= 0; Err_Row_0[6]  <= 0; Err_Row_0[7]  <= 0;
 Err_Row_0[8]  <= 0; Err_Row_0[9] <= 0;

// Initalize pixels in the main array

PV_Row_1[1] <= pixel_1; PV_Row_1[2] <= pixel_2; PV_Row_1[3] <= pixel_3; PV_Row_1[4] <= pixel_4;
PV_Row_1[5] <= pixel_5; PV_Row_1[6] <= pixel_6; PV_Row_1[7] <= pixel_7; PV_Row_1[8] <= pixel_8;

PV_Row_2[1] <= pixel_9; PV_Row_2[2] <= pixel_10; PV_Row_2[3] <= pixel_11; PV_Row_2[4] <= pixel_12;
PV_Row_2[5] <= pixel_13; PV_Row_2[6] <= pixel_14; PV_Row_2[7] <= pixel_15; PV_Row_2[8] <= pixel_16;

PV_Row_3[1] <= pixel_17; PV_Row_3[2] <= pixel_18; PV_Row_3[3] <= pixel_19; PV_Row_3[4] <= pixel_20;
PV_Row_3[5] <= pixel_21; PV_Row_3[6] <= pixel_22; PV_Row_3[7] <= pixel_23; PV_Row_3[8] <= pixel_24;

PV_Row_4[1] <= pixel_25; PV_Row_4[2] <= pixel_26; PV_Row_4[3] <= pixel_27; PV_Row_4[4] <= pixel_28;
PV_Row_4[5] <= pixel_29; PV_Row_4[6] <= pixel_30; PV_Row_4[7] <= pixel_31; PV_Row_4[8] <= pixel_32;

PV_Row_5[1] <= pixel_33; PV_Row_5[2] <= pixel_34; PV_Row_5[3] <= pixel_35; PV_Row_5[4] <= pixel_36;
PV_Row_5[5] <= pixel_37; PV_Row_5[6] <= pixel_38; PV_Row_5[7] <= pixel_39; PV_Row_5[8] <= pixel_40;

PV_Row_6[1] <= pixel_41; PV_Row_6[2] <= pixel_42; PV_Row_6[3] <= pixel_43; PV_Row_6[4] <= pixel_44;
PV_Row_6[5] <= pixel_45; PV_Row_6[6] <= pixel_46; PV_Row_6[7] <= pixel_47; PV_Row_6[8] <= pixel_48;
end	// Array_Initialization

else if (Ld_values) begin: Image_Conversion		 
case (index_1)
1, 2, 3, 4, 5, 6, 7, 8: 	begin 	
			Err_Row_1[index_1] <= PP_1_Err_0; HTPV_Row_1[index_1] <= PP_1_HTPV;					end

15, 16:			begin 	
			Err_Row_2[index_1-8] <= PP_1_Err_0; HTPV_Row_2[index_1-8] <= PP_1_HTPV;	
			end

 23, 24: 			begin 
			Err_Row_3[index_1-16] <= PP_1_Err_0; HTPV_Row_3[index_1-16] <= PP_1_HTPV;	
			end
endcase

case (index_2)
9, 10, 11, 12, 13, 14: 	begin 	
			Err_Row_2[index_2 -8] <= PP_2_Err_0; HTPV_Row_2[index_2 -8] <= PP_2_HTPV;				end

21, 22:			begin 	
			Err_Row_3[index_2 -16] <= PP_2_Err_0; HTPV_Row_3[index_2 -16] <= PP_2_HTPV;	
			end

 29, 30, 31, 32:		begin 
			Err_Row_4[index_2 -24] <= PP_2_Err_0; HTPV_Row_4[index_2 -24] <= PP_2_HTPV;	
			end
endcase

case (index_3)
17, 18, 19, 20: 		begin 	
			Err_Row_3[index_3 -16] <= PP_3_Err_0; HTPV_Row_3[index_3 -16] <= PP_3_HTPV;				end

27, 28:			begin 	
			Err_Row_4[index_3 -24] <= PP_3_Err_0; HTPV_Row_4[index_3 -24] <= PP_3_HTPV;	
			end

 35, 36, 37, 38, 39, 40:	begin 
			Err_Row_5[index_3 -32] <= PP_3_Err_0; HTPV_Row_5[index_3 -32] <= PP_3_HTPV;	
			end
endcase

case (index_4)
25, 26: 			begin 	
			Err_Row_4[index_4 - 24] <= PP_4_Err_0; HTPV_Row_4[index_4 -24] <= PP_4_HTPV;				end

33, 34:			begin 	
			Err_Row_5[index_4 -32] <= PP_4_Err_0; HTPV_Row_5[index_4 -32] <= PP_4_HTPV;	
			end

 41, 42, 43, 44, 45, 46, 47, 48:
begin 
			Err_Row_6[index_4 -40] <= PP_4_Err_0; HTPV_Row_6[index_4 -40] <= PP_4_HTPV;	
			end
endcase
end		// Image_Conversion
endmodule


