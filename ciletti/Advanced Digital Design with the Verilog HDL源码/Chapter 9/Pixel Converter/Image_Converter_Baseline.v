module PPDU (Err_0, HTPV, Err_1, Err_2, Err_3, Err_4, PV);  // Pixel Processor Datapath Unit
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

module Image_Converter_Baseline ( 
  HTPV_Row_1, HTPV_Row_2, HTPV_Row_3, 	 
  HTPV_Row_4, HTPV_Row_5, HTPV_Row_6, 
  pixel_1,   pixel_2,   pixel_3,   pixel_4,   pixel_5,   pixel_6,   pixel_7,   pixel_8,
  pixel_9,   pixel_10, pixel_11, pixel_12, pixel_13, pixel_14, pixel_15, pixel_16,
  pixel_17, pixel_18, pixel_19, pixel_20, pixel_21, pixel_22, pixel_23, pixel_24,
  pixel_25, pixel_26, pixel_27, pixel_28, pixel_29, pixel_30, pixel_31, pixel_32,
  pixel_33, pixel_34, pixel_35, pixel_36, pixel_37, pixel_38, pixel_39, pixel_40,
  pixel_41, pixel_42, pixel_43, pixel_44, pixel_45, pixel_46, pixel_47, pixel_48
  );

 output 	[1: 8]	HTPV_Row_1, HTPV_Row_2, HTPV_Row_3,
		HTPV_Row_4, HTPV_Row_5, HTPV_Row_6; 
  input 	[7: 0]	pixel_1,    pixel_2,  pixel_3,   pixel_4,   pixel_5,   pixel_6,   pixel_7,   pixel_8;
  input	[7: 0]	pixel_9,   pixel_10, pixel_11, pixel_12, pixel_13, pixel_14, pixel_15, pixel_16;
  input	[7: 0]	pixel_17, pixel_18, pixel_19, pixel_20, pixel_21, pixel_22, pixel_23, pixel_24;
  input	[7: 0]	pixel_25, pixel_26, pixel_27, pixel_28, pixel_29, pixel_30, pixel_31, pixel_32;
  input	[7: 0]	pixel_33, pixel_34, pixel_35, pixel_36, pixel_37, pixel_38, pixel_39, pixel_40;
  input	[7: 0]	pixel_41, pixel_42, pixel_43, pixel_44, pixel_45, pixel_46, pixel_47, pixel_48;
 
  wire 	  HTPV_Row_1, HTPV_Row_2, HTPV_Row_3;	 
  wire	  HTPV_Row_4, HTPV_Row_5, HTPV_Row_6; 	 
 
// Note Left, right, and top boarders are initialized to 0 
// Errors for the core array:

  wire	[7: 0] Err_1, Err_2, Err_3, Err_4, Err_5, Err_6, Err_7, Err_8;
  wire	[7: 0] Err_9, Err_10, Err_11, Err_12, Err_13, Err_14, Err_15, Err_16;
  wire	[7: 0] Err_17, Err_18, Err_19, Err_20, Err_21, Err_22, Err_23, Err_24;
  wire	[7: 0] Err_25, Err_26, Err_27, Err_28, Err_29, Err_30, Err_31, Err_32;
  wire	[7: 0] Err_33, Err_34, Err_35, Err_36, Err_37, Err_38, Err_39, Err_40;
  wire	[7: 0] Err_41, Err_42, Err_43, Err_44, Err_45, Err_46, Err_47, Err_48;

  PPDU M1 (Err_1, HTPV_Row_1[1], 8'b0, 8'b0, 8'b0, 8'b0, pixel_1);
  PPDU M2 (Err_2, HTPV_Row_1[2], Err_1, 8'b0, 8'b0, 8'b0, pixel_2);
  PPDU M3 (Err_3, HTPV_Row_1[3], Err_2, 8'b0, 8'b0, 8'b0, pixel_3);
  PPDU M4 (Err_4, HTPV_Row_1[4], Err_3, 8'b0, 8'b0, 8'b0, pixel_4);
  PPDU M5 (Err_5, HTPV_Row_1[5], Err_4, 8'b0, 8'b0, 8'b0, pixel_5);
  PPDU M6 (Err_6, HTPV_Row_1[6], Err_5, 8'b0, 8'b0, 8'b0, pixel_6);
  PPDU M7 (Err_7, HTPV_Row_1[7], Err_6, 8'b0, 8'b0, 8'b0, pixel_7);
  PPDU M8 (Err_8, HTPV_Row_1[8], Err_7, 8'b0, 8'b0, 8'b0, pixel_8);

  PPDU M9 (Err_9, HTPV_Row_2[1], 8'b0, 8'b0, Err_1, Err_2, pixel_9);
  PPDU M10 (Err_10, HTPV_Row_2[2], Err_9, Err_1, Err_2, Err_3, pixel_10);
  PPDU M11 (Err_11, HTPV_Row_2[3], Err_10, Err_2, Err_3, Err_4, pixel_11);
  PPDU M12 (Err_12, HTPV_Row_2[4], Err_11, Err_3, Err_4, Err_5, pixel_12);
  PPDU M13 (Err_13, HTPV_Row_2[5], Err_12, Err_4, Err_5, Err_6, pixel_13);
  PPDU M14 (Err_14, HTPV_Row_2[6], Err_13, Err_5, Err_6, Err_7, pixel_14);
  PPDU M15 (Err_15, HTPV_Row_2[7], Err_14, Err_6, Err_7, Err_8, pixel_15);
  PPDU M16 (Err_16, HTPV_Row_2[8], Err_15, Err_7, Err_8, 8'b0, pixel_16);

  PPDU M17 (Err_17, HTPV_Row_3[1], 8'b0, 8'b0, Err_9, Err_10, pixel_17);
  PPDU M18 (Err_18, HTPV_Row_3[2], Err_17, Err_10, Err_11, Err_12, pixel_18);
  PPDU M19 (Err_19, HTPV_Row_3[3], Err_18, Err_11, Err_12, Err_13, pixel_19);
  PPDU M20 (Err_20, HTPV_Row_3[4], Err_19, Err_12, Err_13, Err_14, pixel_20);
  PPDU M21 (Err_21, HTPV_Row_3[5], Err_20, Err_13, Err_14, Err_15, pixel_21);
  PPDU M22 (Err_22, HTPV_Row_3[6], Err_21, Err_14, Err_15, Err_16, pixel_22);
  PPDU M23 (Err_23, HTPV_Row_3[7], Err_22, Err_15, Err_16, Err_17, pixel_23);
  PPDU M24 (Err_24, HTPV_Row_3[8], Err_23, Err_16, Err_17, 8'b0, pixel_24);

  PPDU M25 (Err_25, HTPV_Row_4[1], 8'b0, 8'b0, Err_16, Err_17, pixel_25);
  PPDU M26 (Err_26, HTPV_Row_4[2], Err_25, Err_17, Err_18, Err_19, pixel_26);
  PPDU M27 (Err_27, HTPV_Row_4[3], Err_26, Err_18, Err_19, Err_20, pixel_27);
  PPDU M28 (Err_28, HTPV_Row_4[4], Err_27, Err_19, Err_20, Err_21, pixel_28);
  PPDU M29 (Err_29, HTPV_Row_4[5], Err_28, Err_20, Err_21, Err_22, pixel_29);
  PPDU M30 (Err_30, HTPV_Row_4[6], Err_29, Err_21, Err_22, Err_23, pixel_30);
  PPDU M31 (Err_31, HTPV_Row_4[7], Err_30, Err_22, Err_23, Err_24, pixel_31);
  PPDU M32 (Err_32, HTPV_Row_4[8], Err_31, Err_23, Err_24, 8'b0, pixel_32);

  PPDU M33 (Err_33, HTPV_Row_5[1], 8'b0, 8'b0, Err_25, Err_26, pixel_33);
  PPDU M34 (Err_34, HTPV_Row_5[2], Err_33, Err_25, Err_26, Err_27, pixel_34);
  PPDU M35 (Err_35, HTPV_Row_5[3], Err_34, Err_26, Err_27, Err_28, pixel_35);
  PPDU M36 (Err_36, HTPV_Row_5[4], Err_35, Err_27, Err_28, Err_29, pixel_36);
  PPDU M37 (Err_37, HTPV_Row_5[5], Err_36, Err_28, Err_29, Err_30, pixel_37);
  PPDU M38 (Err_38, HTPV_Row_5[6], Err_37, Err_29, Err_30, Err_31, pixel_38);
  PPDU M39 (Err_39, HTPV_Row_5[7], Err_38, Err_30, Err_31, Err_32, pixel_39);
  PPDU M40 (Err_40, HTPV_Row_5[8], Err_39, Err_31, Err_32, 8'b0, pixel_40);

  PPDU M41 (Err_41, HTPV_Row_6[1], 8'b0, 8'b0, Err_33, Err_34, pixel_41);
  PPDU M42 (Err_42, HTPV_Row_6[2], Err_41, Err_33, Err_34, Err_35, pixel_42);
  PPDU M43 (Err_43, HTPV_Row_6[3], Err_42, Err_34, Err_35, Err_36, pixel_43);
  PPDU M44 (Err_44, HTPV_Row_6[4], Err_43, Err_35, Err_36, Err_37, pixel_44);
  PPDU M45 (Err_45, HTPV_Row_6[5], Err_44, Err_36, Err_37, Err_38, pixel_45);
  PPDU M46 (Err_46, HTPV_Row_6[6], Err_45, Err_37, Err_38, Err_39, pixel_46);
  PPDU M47 (Err_47, HTPV_Row_6[7], Err_46, Err_38, Err_39, Err_40, pixel_47);
  PPDU M48 (Err_48, HTPV_Row_6[8], Err_47, Err_39, Err_40, 8'b0, pixel_48);
endmodule

