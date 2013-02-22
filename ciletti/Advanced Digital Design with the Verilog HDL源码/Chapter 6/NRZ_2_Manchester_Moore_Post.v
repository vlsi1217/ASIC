
module NRZ_2_Manchester_Moore ( B_out, B_in, clock, reset );
input  B_in, clock, reset;
output B_out;
    wire \next_state<1> , \next_state<0> , \state<0> , n82;
    invf101 U27 ( .A1(\state<0> ), .O(\next_state<0> ) );
    oaif2201 U28 ( .A1(n82), .B1(\state<0> ), .C2(B_out), .D2(\next_state<0> ), 
        .O(\next_state<1> ) );
    invf101 U29 ( .A1(B_in), .O(n82) );
    dfrf301 \state_reg<1>  ( .DATA1(\next_state<1> ), .CLK2(clock), .RST3(
        reset), .Q(B_out) );
    dfrf301 \state_reg<0>  ( .DATA1(\next_state<0> ), .CLK2(clock), .RST3(
        reset), .Q(\state<0> ) );
endmodule

