'timesclae 1ns/1ps
module decoder3x8(a,b,c,en,z);

    input a,b,c,en;
    output [0:7] z;
    wire nota,notb,notc;
    
    assign #1  nota = ~a;
    assign #1  notb = ~b;
    assign #1  notc = ~c;
    assign #2  z[0] = nota & notb & notc & en;
    assign #2  z[1] = a    & notb & notc & en;
    assign #2  z[2] = nota & b    & notc & en;
    assign #2  z[3] = a    & b    & notc & en;
    assign #2  z[4] = nota & notb & c    & en;
    assign #2  z[5] = a    & notb & c    & en;
    assign #2  z[6] = nota & b    & c    & en;
    assign #2  z[7] = a    & b    & c    & en;
    
endmodule