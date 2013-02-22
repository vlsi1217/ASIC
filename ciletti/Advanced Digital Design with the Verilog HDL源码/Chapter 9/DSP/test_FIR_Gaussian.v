module test_FIR_Gaussian_Lowpass ();
   // Eigth-order, Gaussian lowpass FIR
  parameter	period = 5;
  parameter	word_size_in = 8;
  parameter word_size_out = 2*word_size_in + 2;
  wire	[word_size_out -1: 0] Data_out;
  reg		[word_size_in -1: 0] Data_in;
  reg		clock, reset;
  real		Data_out_unscaled;

wire [word_size_in -1: 0] Sample_1 = M0.Samples[1];
wire [word_size_in -1: 0] Sample_2 = M0.Samples[2];
wire [word_size_in -1: 0] Sample_3 = M0.Samples[3];
wire [word_size_in -1: 0] Sample_4 = M0.Samples[4];
wire [word_size_in -1: 0] Sample_5 = M0.Samples[5];
wire [word_size_in -1: 0] Sample_6 = M0.Samples[6];
wire [word_size_in -1: 0] Sample_7 = M0.Samples[7];
wire [word_size_in -1: 0] Sample_8 = M0.Samples[8];

always @(Data_out) Data_out_unscaled = Data_out / 255;

FIR_Gaussian_Lowpass M0 (Data_out, Data_in, clock, reset);


initial #3000 $finish;
initial begin #1 reset = 1; #12 reset = 0; end
initial begin clock = 0; forever begin  #period clock = ~clock; end end

initial begin Data_in = 0; #100 Data_in = 1; #10 Data_in = 0; end
initial begin #500  Data_in = 0; #100 Data_in = 8'hff; end

 endmodule

