`timescale 1 ns / 10 ps
module NRZ_2_Manchester_Mealy ( B_out, B_in, clock, reset );
input  B_in, clock, reset;
output B_out;
    wire \next_state<1> , \next_state<0> , \state<1> , \state<0> , n82, n83, 
        n84, n85, n86, n87, n88, n89;
    buff101 U28 ( .A1(n85), .O(n82) );
    invf101 U29 ( .A1(n89), .O(n83) );
    buff101 U30 ( .A1(\state<0> ), .O(n84) );
    blf00101 U31 ( .A1(n87), .B2(n82), .C2(n86), .O(\next_state<1> ) );
    blf00101 U32 ( .A1(n87), .B2(B_in), .C2(n85), .O(\next_state<0> ) );
    blf00001 U33 ( .A1(n83), .B2(n86), .C2(n88), .O(B_out) );
    invf101 U34 ( .A1(n84), .O(n88) );
    invf101 U35 ( .A1(B_in), .O(n86) );
    nanf251 U36 ( .A1(n82), .B2(\state<0> ), .O(n87) );
    aoif2201 U37 ( .A1(n89), .B1(n88), .C2(\state<1> ), .D2(n84), .O(n85) );
    invf101 U38 ( .A1(\state<1> ), .O(n89) );
    dfrf301 M0 /*\state_reg<1>*/  ( .DATA1(\next_state<1> ), .CLK2(clock), .RST3(
        reset), .Q(\state<1> ) );
    dfrf301 M1 /*\state_reg<0> */ ( .DATA1(\next_state<0> ), .CLK2(clock), .RST3(
        reset), .Q(\state<0> ) );
endmodule

