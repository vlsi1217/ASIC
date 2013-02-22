module add_16_pipe (c_out, sum, a, b, c_in, clock);
  parameter	size 	= 16;
  parameter	half	= size / 2;
  parameter	double	= 2 * size;
  parameter	triple	= 3 * half;
  parameter	size1 = half -1;		// 7
  parameter	size2 = size -1;    		// 15
  parameter	size3 = half + 1;		// 9	
  parameter 	R1 = 1;			// 1
  parameter	L1 = half;
  parameter	R2 = size3;
  parameter	L2 = size;
  parameter	R3 = size + 1;
  parameter	L3 = size + half;
  parameter	R4 = double - half +1;
  parameter	L4 = double;

  input 	[size2: 0]	a, b;
  input 			c_in, clock;
  output	[size2: 0]	sum;
  output			c_out;

  reg 	[double: 0]	IR;
  reg 	[triple: 0]	PR;
  reg	[size: 0]		OR;

  assign {c_out, sum} = OR;

  always @ (posedge clock) begin

    // Load input register

    IR[0] <= c_in;

    IR[L1:R1] <= a[size1: 0];
    IR[L2:R2] <= b[size1: 0];

    IR[L3:R3] <= a[size2: half];
    IR[L4:R4] <= b[size2: half];
    
  // Load pipeline register

     PR[L3: R3] <=IR[L4: R4];
     PR[L2: R2] <=IR[L3: R3];
     PR[half: 0] <= IR[L2:R2] + IR[L1:R1] + IR[0];
     OR <= {{1'b0,PR[L3: R3]} + {1'b0,PR[L2: R2]} + PR[half], PR[size1: 0]};
  end
endmodule
