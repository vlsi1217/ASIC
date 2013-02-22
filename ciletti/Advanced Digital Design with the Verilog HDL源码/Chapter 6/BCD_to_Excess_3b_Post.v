
module BCD_to_Excess_3b ( B_out, B_in, clk, reset_b );
input  B_in, clk, reset_b;
output B_out;
    /*wire \state<2> , \state<1> , \next_state<2> , n_270, n_262, 
        \next_state<0> , n_271, n_261, \next_state<1> , \state<0> , n_260, n90, 
        n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, 
        n104, n105, n106;*/
    invf103 U36 ( .A1(B_in), .O(n102) );
    invf103 U37 ( .A1(clk), .O(n106) );
    invf101 U38 ( .A1(n90), .O(n91) );
    invf103 U39 ( .A1(n100), .O(n_271) );
    invf103 U40 ( .A1(n92), .O(n93) );
    invf103 U41 ( .A1(n94), .O(n95) );
    invf103 U42 ( .A1(n95), .O(n96) );
    invf103 U43 ( .A1(n93), .O(n_262) );
    invf103 U44 ( .A1(\state<0> ), .O(n97) );
    blf00101 U45 ( .A1(n97), .B2(n93), .C2(n96), .O(n_261) );
    nanf251 U46 ( .A1(n98), .B2(n99), .O(n_260) );
    nanf311 U47 ( .A1(n97), .B1(n_262), .C1(n95), .O2(n100) );
    nanf311 U48 ( .A1(n91), .B1(\state<1> ), .C1(n95), .O2(n98) );
    blf00001 U49 ( .A1(n102), .B2(n97), .C2(n93), .O(n101) );
    blf00001 U50 ( .A1(B_in), .B2(n_262), .C2(n97), .O(n103) );
    oaif2201 U51 ( .A1(n103), .B1(n96), .C2(n101), .D2(\state<2> ), .O(n_270)
         );
    nanf201 U52 ( .A1(n97), .B1(n_262), .O(n104) );
    nanf201 U53 ( .A1(\state<0> ), .B1(n96), .O(n105) );
    muxf201 U54 ( .A1(n105), .B2(n104), .SEL3(n102), .O(n99) );
    dfrf311 M0 /*\state_reg<2> */ ( .DATA1(\next_state<2> ), .CLK2(n106), .RST3(reset_b
        ), .Q(\state<2> ), .Q_b(n94) );
    dfrf311 M1 /* \state_reg<1> */ ( .DATA1(\next_state<1> ), .CLK2(n106), .RST3(reset_b
        ), .Q(\state<1> ), .Q_b(n92) );
    dfrf311 M2 /* \state_reg<0> */ ( .DATA1(\next_state<0> ), .CLK2(n106), .RST3(reset_b
        ), .Q(\state<0> ), .Q_b(n90) );
    lhnf311 M3 /* \next_state_reg<1> */ ( .CLK2(n_271), .DATA1(n_261), .Q(
        \next_state<1> ) );
    lhnf311 M4 /* B_out_reg */ ( .CLK2(n_271), .DATA1(n_270), .Q(B_out) );
    lhnf311 M5 /* \next_state_reg<2> */ ( .CLK2(n_271), .DATA1(n_260), .Q(
        \next_state<2> ) );
    lhnf311 M6 /* \next_state_reg<0> */ ( .CLK2(n_271), .DATA1(n_262), .Q(
        \next_state<0> ) );
endmodule


