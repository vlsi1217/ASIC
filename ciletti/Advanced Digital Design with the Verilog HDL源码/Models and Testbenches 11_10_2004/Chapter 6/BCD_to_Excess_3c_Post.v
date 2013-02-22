
module BCD_to_Excess_3c ( B_out, B_in, clk, reset_b );
input  B_in, clk, reset_b;
output B_out;
     wire \state<2> , \state<1> , \state<0> , n80, n81, n82, n83, n84, n85, n86, 
        n87, n88, n89, n90, n91, n92, n93, n94, n95, n96;
    invf101 U28 ( .A1(n80), .O(n81) );
    invf103 U29 ( .A1(clk), .O(n93) );
    invf101 U30 ( .A1(n82), .O(n83) );
    invf103 U31 ( .A1(\state<1> ), .O(n96) );
    invf103 U32 ( .A1(n84), .O(n85) );
    invf103 U33 ( .A1(n85), .O(n89) );
    blf00101 U34 ( .A1(n87), .B2(\state<0> ), .C2(n86), .O(B_out) );
    blf00001 U35 ( .A1(\state<0> ), .B2(n96), .C2(n85), .O(n88) );
    aoif2201 U36 ( .A1(\state<1> ), .B1(n89), .C2(n96), .D2(n85), .O(n86) );
    invf101 U37 ( .A1(B_in), .O(n90) );
    aoif2201 U38 ( .A1(n90), .B1(n89), .C2(B_in), .D2(n85), .O(n87) );
    oaif2201 U39 ( .A1(B_in), .B1(\state<2> ), .C2(n96), .D2(n89), .O(n91) );
    norf201 U40 ( .A1(n81), .B1(n90), .O(n92) );
    muxf201 U41 ( .A1(n91), .B2(n92), .SEL3(n83), .O(n94) );
    invf101 U42 ( .A1(n88), .O(n95) );
    dfrf311 M0 /*\state_reg<2>*/  ( .DATA1(n94), .CLK2(n93), .RST3(reset_b), .Q(
        \state<2> ), .Q_b(n84) );
    dfrf311 M1 /*\state_reg<1> */ ( .DATA1(n95), .CLK2(n93), .RST3(reset_b), .Q(
        \state<1> ), .Q_b(n80) );
    dfrf311 M2 /* \state_reg<0> */  ( .DATA1(n96), .CLK2(n93), .RST3(reset_b), .Q(
        \state<0> ), .Q_b(n82) );
endmodule


