
module NRZ_2_Manchester_Mealy (B_out, B_in, clock, reset_b);
  output 		B_out;
  input		B_in;
  input		clock, reset_b;
  reg [1:0]	state, next_state;
  reg		B_out;
  parameter	S_0 = 0,
		S_1 = 1,
		S_2 = 2,
dont_care_state = 2'bx,
dont_care_out = 1'bx;

  always @ (negedge clock or negedge reset_b)
   if (reset_b == 0) state <= S_0; else state <= next_state;

  always @ (state or B_in ) begin
    B_out = 0;
    case (state)						// Partially decoded
      S_0:	if (B_in == 0) next_state = S_1;  
        	else if (B_in == 1) begin next_state = S_2; B_out = 1; end
      S_1: begin next_state = S_0; B_out = 1;  end
      S_2: begin next_state = S_0;  end
      default:  begin next_state = dont_care_state; B_out = dont_care_out;  end
    endcase
  end 
endmodule 
///*
module test_SLCC ();
reg B_in, reset_b;
wire B_out, clock;

NRZ_2_Manchester_Mealy M1 (B_out, B_in, clock_2, reset_b);
Clock_1_2 M2 (clock_1, clock_2);

initial #200 $finish;

initial begin #1 reset_b = 0; #2 reset_b = 1; end
initial fork
B_in = 0;
#(M2.period_1) B_in = 1;
#(4*M2.period_1) B_in = 0;
#(6*M2.period_1) B_in = 1;
#(7*M2.period_1) B_in = 0;

join
endmodule

//*/

