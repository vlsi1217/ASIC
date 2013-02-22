module Latch_Race_1 (D_out, D_in);
output D_out;
input D_in;
reg D_out;
reg En;

always @ (D_in) En = D_in;
always @ (D_in or En) if (En== 0) D_out = D_in;
endmodule

module Latch_Race_2 (D_out, D_in);
output D_out;
input D_in;
reg D_out;
reg En;


always @ (D_in or En) if (En== 0) D_out = D_in;
always @ (D_in) En = D_in;
endmodule

module Latch_Race_3 (D_out, D_in);
output D_out;
input D_in;
reg D_out;
wire En;


buf #1 (En, D_in);

always @ (D_in or En)
 if (En== 0) D_out = D_in;
 
endmodule

module Latch_Race_4 (D_out, D_in);
output D_out;
input D_in;
reg D_out;
wire En;


buf #1 (En, D_in);

always @ (D_in or En)
#3  if (En== 0) D_out = D_in;
 
endmodule


/*
module t_latch_Races ();
wire D_out_1, D_out_2, D_out_3, D_out_4;
reg D_in;


Latch_Race_1 M1 (D_out_1, D_in);
Latch_Race_2 M2 (D_out_2, D_in);
Latch_Race_3 M3 (D_out_3, D_in);
Latch_Race_4 M4 (D_out_4, D_in);

initial #500 $finish;
initial fork

#20 D_in = 0;
#50 D_in = 1;
#100 D_in = 0;
#200 D_in = 1;
#300 D_in = 0;
join


endmodule
*/
