module Image_Converter_1 ( 
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

  output		Done;
  output 	[1: 8]	HTPV_Row_1, HTPV_Row_2, HTPV_Row_3,
		HTPV_Row_4, HTPV_Row_5, HTPV_Row_6; 

  input 	[7: 0]	pixel_1,    pixel_2,  pixel_3,   pixel_4,   pixel_5,   pixel_6,   pixel_7,   pixel_8;
  input	[7: 0]	pixel_9,   pixel_10, pixel_11, pixel_12, pixel_13, pixel_14, pixel_15, pixel_16;
  input	[7: 0]	pixel_17, pixel_18, pixel_19, pixel_20, pixel_21, pixel_22, pixel_23, pixel_24;
  input	[7: 0]	pixel_25, pixel_26, pixel_27, pixel_28, pixel_29, pixel_30, pixel_31, pixel_32;
  input	[7: 0]	pixel_33, pixel_34, pixel_35, pixel_36, pixel_37, pixel_38, pixel_39, pixel_40;
  input	[7: 0]	pixel_41, pixel_42, pixel_43, pixel_44, pixel_45, pixel_46, pixel_47, pixel_48;
  input		Go, clk, reset;

  reg 	Done;
  reg 	[7: 0] 	PV_Row_1 [1: 8], PV_Row_2 [1: 8], PV_Row_3 [1: 8], 
		PV_Row_4 [1: 8], PV_Row_5 [1: 8], PV_Row_6 [1: 8];

  reg 	[1: 8]   HTPV_Row_1, HTPV_Row_2, HTPV_Row_3;	 
  reg	  	[1: 8] HTPV_Row_4, HTPV_Row_5, HTPV_Row_6; 	 
 
// Weights for the average error; choose for compatibility with divide-by-16 (>> 4)

parameter	w1 = 2, w2 = 8, w3 = 4, w4 = 2;
 
// Note Err_Row_ includes left, right, and top boarder 
// columns for initialization of the algorithm.

reg	[7: 0] Err_Row_0 [0: 9], Err_Row_1 [0: 9], Err_Row_2 [0: 9], Err_Row_3 [0: 9];
reg	[7: 0] Err_Row_4 [0: 9], Err_Row_5 [0: 9], Err_Row_6 [0: 9];
reg	[9: 0] CPV, CPV_round, E_av;
integer i;

// is wordlength adequate for E_av ?

parameter N = 6;		// rows
parameter M = 8;		// columns
parameter Threshold = 128;

always begin: wrapper_for_synthesis
@ (posedge clk) begin: pixel_converter
if (reset) begin: reset_action
  Done = 0;

// Initialize error at left boarder 

  Err_Row_1[0] = 0; Err_Row_2[0] = 0; Err_Row_3[0] = 0; Err_Row_4[0] = 0; Err_Row_5[0] = 0; Err_Row_6[0] = 0;

// Initialize columns in the main array

  Err_Row_1[1] = 0; Err_Row_2[1] = 0; Err_Row_3[1] = 0; Err_Row_4[1] = 0; Err_Row_5[1] = 0; Err_Row_6[1] = 0;
  Err_Row_1[2] = 0; Err_Row_2[2] = 0; Err_Row_3[2] = 0; Err_Row_4[2] = 0; Err_Row_5[2] = 0; Err_Row_6[2] = 0;
  Err_Row_1[3] = 0; Err_Row_2[3] = 0; Err_Row_3[3] = 0; Err_Row_4[3] = 0; Err_Row_5[3] = 0; Err_Row_6[3] = 0;
  Err_Row_1[4] = 0; Err_Row_2[4] = 0; Err_Row_3[4] = 0; Err_Row_4[4] = 0; Err_Row_5[4] = 0; Err_Row_6[4] = 0;
  Err_Row_1[5] = 0; Err_Row_2[5] = 0; Err_Row_3[5] = 0; Err_Row_4[5] = 0; Err_Row_5[5] = 0; Err_Row_6[5] = 0;
  Err_Row_1[6] = 0; Err_Row_2[6] = 0; Err_Row_3[6] = 0; Err_Row_4[6] = 0; Err_Row_5[6] = 0; Err_Row_6[6] = 0;
  Err_Row_1[7] = 0; Err_Row_2[7] = 0; Err_Row_3[7] = 0; Err_Row_4[7] = 0; Err_Row_5[7] = 0; Err_Row_6[7] = 0;
  Err_Row_1[8] = 0; Err_Row_2[8] = 0; Err_Row_3[8] = 0; Err_Row_4[8] = 0; Err_Row_5[8] = 0; Err_Row_6[8] = 0;

// Initalize right boarder

 Err_Row_1[9] = 0; Err_Row_2[9] = 0; Err_Row_3[9] = 0; 
 Err_Row_4[9] = 0; Err_Row_5[9] = 0; Err_Row_6[9] = 0;

// Initialize top boarder

 Err_Row_0[0]  = 0; Err_Row_0[1]  = 0; Err_Row_0[2]  = 0; Err_Row_0[3]  = 0; Err_Row_0[4]  = 0; 
 Err_Row_0[5]  = 0; Err_Row_0[6]  = 0; Err_Row_0[7]  = 0; Err_Row_0[8]  = 0; Err_Row_0[9] = 0;

// Initalize pixels in the main array

PV_Row_1[1] = pixel_1; PV_Row_1[2] = pixel_2; PV_Row_1[3] = pixel_3; PV_Row_1[4] = pixel_4;
PV_Row_1[5] = pixel_5; PV_Row_1[6] = pixel_6; PV_Row_1[7] = pixel_7; PV_Row_1[8] = pixel_8;

PV_Row_2[1] = pixel_9; PV_Row_2[2] = pixel_10; PV_Row_2[3] = pixel_11; PV_Row_2[4] = pixel_12;
PV_Row_2[5] = pixel_13; PV_Row_2[6] = pixel_14; PV_Row_2[7] = pixel_15; PV_Row_2[8] = pixel_16;

PV_Row_3[1] = pixel_17; PV_Row_3[2] = pixel_18; PV_Row_3[3] = pixel_19; PV_Row_3[4] = pixel_20;
PV_Row_3[5] = pixel_21; PV_Row_3[6] = pixel_22; PV_Row_3[7] = pixel_23; PV_Row_3[8] = pixel_24;

PV_Row_4[1] = pixel_25; PV_Row_4[2] = pixel_26; PV_Row_4[3] = pixel_27; PV_Row_4[4] = pixel_28;
PV_Row_4[5] = pixel_29; PV_Row_4[6] = pixel_30; PV_Row_4[7] = pixel_31; PV_Row_4[8] = pixel_32;

PV_Row_5[1] = pixel_33; PV_Row_5[2] = pixel_34; PV_Row_5[3] = pixel_35; PV_Row_5[4] = pixel_36;
PV_Row_5[5] = pixel_37; PV_Row_5[6] = pixel_38; PV_Row_5[7] = pixel_39; PV_Row_5[8] = pixel_40;

PV_Row_6[1] = pixel_41; PV_Row_6[2] = pixel_42; PV_Row_6[3] = pixel_43; PV_Row_6[4] = pixel_44;
PV_Row_6[5] = pixel_45; PV_Row_6[6] = pixel_46; PV_Row_6[7] = pixel_47; PV_Row_6[8] = pixel_48;
// initialization complete
end 	// reset_action

else begin: half_tone_calculations

// Pixels in Row 1
if (Go) begin: wrapper 
#20 for (i = 1; i <= M; i = i+1) begin: row_1_loop
E_av = (w1 * Err_Row_1[i-1] + w2 * Err_Row_0[i-1] + w3 * Err_Row_0[i] + w4 * Err_Row_0 [i+1] ) >> 4;
        CPV = PV_Row_1[i] + E_av;
        CPV_round = (CPV < Threshold) ? 0: 255;  
        HTPV_Row_1[i] = (CPV_round == 0) ? 0: 1;
            Err_Row_1[i]  = CPV - CPV_round;
//@ (posedge clk) if (reset) disable pixel_converter;
end // row_1_loop

// Pixels in Row 2
#20 for (i = 1; i <= M; i = i+1) begin: row_2_loop
E_av = (w1 * Err_Row_2[i-1] + w2 * Err_Row_1[i-1] + w3 * Err_Row_1[i] + w4 * Err_Row_1 [i+1] ) >> 4;
        CPV = PV_Row_2[i] + E_av;
        CPV_round = (CPV < Threshold) ? 0: 255;  
        HTPV_Row_2[i] = (CPV_round == 0) ? 0: 1;
        Err_Row_2[i]  = CPV - CPV_round;
//@ (posedge clk)  if (reset) disable pixel_converter;
end // row_2_loop

// Pixels in Row 3
#20 for (i = 1; i <= M; i = i+1) begin: row_3_loop
E_av = (w1 * Err_Row_3[i-1] + w2 * Err_Row_2[i-1] + w3 * Err_Row_2[i] + w4 * Err_Row_2 [i+1] ) >> 4;
        CPV = PV_Row_3[i] + E_av;
        CPV_round = (CPV < Threshold) ? 0: 255;  
        HTPV_Row_3[i] = (CPV_round == 0) ? 0: 1;
        Err_Row_3[i]  = CPV - CPV_round;
//@ (posedge clk)  if (reset) disable pixel_converter;
end // row_3_loop

// Pixels in Row 4
#20 for (i = 1; i <= M; i = i+1) begin: row_4_loop
E_av = (w1 * Err_Row_4[i-1] + w2 * Err_Row_3[i-1] + w3 * Err_Row_3[i] + w4 * Err_Row_3 [i+1] ) >> 4;
        CPV = PV_Row_4[i] + E_av;
        CPV_round = (CPV < Threshold) ? 0: 255;  
        HTPV_Row_4[i] = (CPV_round == 0) ? 0: 1;
        Err_Row_4[i]  = CPV - CPV_round;
//@ (posedge clk) if (reset) disable pixel_converter;
end // row_4_loop

// Pixels in Row 5
#20 for (i = 1; i <= M; i = i+1) begin: row_5_loop 
E_av = (w1 * Err_Row_5[i-1] + w2 * Err_Row_4[i-1] + w3 * Err_Row_4[i] + w4 * Err_Row_4 [i+1] ) >> 4;
        CPV = PV_Row_5[i] + E_av;
        CPV_round = (CPV < Threshold) ? 0: 255;  
        HTPV_Row_5[i] = (CPV_round == 0) ? 0: 1;
        Err_Row_5[i]  = CPV - CPV_round;
//@ (posedge clk) if (reset) disable pixel_converter;
end // row_5_loop

// Pixels in Row 6
#20 for (i = 1; i <= M; i = i+1) begin: row_6_loop
E_av = (w1 * Err_Row_6[i-1] + w2 * Err_Row_5[i-1] + w3 * Err_Row_5[i] + w4 * Err_Row_5 [i+1] ) >> 4;
        CPV = PV_Row_6[i] + E_av;
        CPV_round = (CPV < Threshold) ? 0: 255;  
        HTPV_Row_6[i] = (CPV_round == 0) ? 0: 1;
        Err_Row_6[i]  = CPV - CPV_round;
//@ (posedge clk)  if (reset) disable pixel_converter;
end // row_6_loop

Done = 1;
end	 // wrapper
end	 // half_tone_calculations  
end 	// pixel_converter 
end	// wrapper_for_synthesis
endmodule

