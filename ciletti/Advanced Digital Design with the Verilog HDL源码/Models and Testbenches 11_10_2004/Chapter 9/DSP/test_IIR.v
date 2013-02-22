module test_IIR_8();
   // Eigth-order, Gaussian lowpass FIR
  parameter	period = 5;
  parameter	word_size_in = 8;
  parameter word_size_out = 2*word_size_in + 2;
  wire	[word_size_out -1: 0] Data_out;
  reg		[word_size_in -1: 0] Data_in;
  reg		clock, reset;

wire [word_size_out -1: 0] Sample_in_1 = M0.Samples_in[1];
wire [word_size_out -1: 0] Sample_in_2 = M0.Samples_in[2];
wire [word_size_out -1: 0] Sample_in_3 = M0.Samples_in[3];
wire [word_size_out -1: 0] Sample_in_4 = M0.Samples_in[4];
wire [word_size_out -1: 0] Sample_in_5 = M0.Samples_in[5];
wire [word_size_out -1: 0] Sample_in_6 = M0.Samples_in[6];
wire [word_size_out -1: 0] Sample_in_7 = M0.Samples_in[7];
wire [word_size_out -1: 0] Sample_in_8 = M0.Samples_in[8];

wire [word_size_out -1: 0] Sample_out_1 = M0.Samples_out[1];
wire [word_size_out -1: 0] Sample_out_2 = M0.Samples_out[2];
wire [word_size_out -1: 0] Sample_out_3 = M0.Samples_out[3];
wire [word_size_out -1: 0] Sample_out_4 = M0.Samples_out[4];
wire [word_size_out -1: 0] Sample_out_5 = M0.Samples_out[5];
wire [word_size_out -1: 0] Sample_out_6 = M0.Samples_out[6];
wire [word_size_out -1: 0] Sample_out_7 = M0.Samples_out[7];
wire [word_size_out -1: 0] Sample_out_8 = M0.Samples_out[8];



IIR_Filter_8 M0 (Data_out, Data_in, clock, reset);


initial #110000 $finish;
initial begin #1 reset = 1; #12 reset = 0; end
initial begin clock = 0; forever begin  #period clock = ~clock; end end

initial begin Data_in = 0; #100 Data_in = 1; #10 Data_in = 0; end
// initial begin #500  Data_in = 0; #100 Data_in = 8'hff; end

 endmodule

