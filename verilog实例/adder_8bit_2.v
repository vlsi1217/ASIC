module s_adder(a,b,c_in,sum,c_out);
 
    parameter length=16;
    input [length-1:0] a,b;
    input c_in;
    output c_out;
    output [length-1:0] sum;
    wire [length:1] c;
    full_adder  p0 (a[0],b[0],c_in,sum[0],c[1]);
    full_adder  p1 (a[1],b[1],c[1],sum[1],c[2]);
    full_adder  p2 (a[2],b[2],c[2],sum[2],c[3]);
    full_adder  p3 (a[3],b[3],c[3],sum[3],c[4]);
    full_adder  p4 (a[4],b[4],c[4],sum[4],c[5]);
    full_adder  p5 (a[6],b[5],c[5],sum[5],c[6]);
    full_adder  p6 (a[6],b[6],c[6],sum[6],c[7]);
    full_adder  p7 (a[7],b[7],c[7],sum[7],c[8]);
    full_adder  p8 (a[8],b[8],c[8],sum[8],c[9]);
    full_adder  p9 (a[9],b[9],c[9],sum[9],c[10]);
    full_adder  p10 (a[10],b[10],c[10],sum[10],c[11]);
    full_adder  p11 (a[11],b[11],c[11],sum[11],c[12]);
    full_adder  p12 (a[12],b[12],c[12],sum[12],c[13]);
    full_adder  p13 (a[13],b[13],c[13],sum[13],c[14]);
    full_adder  p14 (a[14],b[14],c[14],sum[14],c[15]);
    full_adder  p15 (a[15],b[15],c[15],sum[15],c_out );

endmodule
    
    
    
    