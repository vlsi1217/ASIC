module BCD_to_Excess_3c (B_out, B_in, clk, reset_b);
  output		B_out;
  input		B_in, clk, reset_b;
  parameter 	S_0 = 3'b000, 		// State assignment
		S_1 = 3'b001, 
		S_2 = 3'b101, 
		S_3 = 3'b111,
		S_4 = 3'b011, 
		S_5 = 3'b110, 
		S_6 = 3'b010,
		dont_care_state = 3'bx,
		dont_care_out = 1'bx;

  reg	[2:0]	state, next_state;
  reg		B_out;

  always @ (posedge clk or negedge reset_b) 
    if (reset_b == 0) state <= S_0; else state <= next_state;

  always @ (state or B_in) begin
    B_out = 0;
    case (state)
      S_0:	if (B_in == 0) begin next_state = S_1; B_out = 1; end
	else if (B_in == 1) begin next_state = S_2; end

      S_1: if (B_in == 0) begin next_state = S_3; B_out = 1; end
	else if (B_in == 1) begin next_state = S_4; end

      S_2: begin next_state = S_4; B_out = B_in; end

      S_3: begin next_state = S_5; B_out = B_in; end

      S_4: if (B_in == 0) begin next_state = S_5; B_out = 1; end
	else if (B_in == 1) begin next_state = S_6; end

      S_5:	begin next_state = S_0; B_out = B_in; end

      S_6:	begin next_state = S_0; B_out = 1; end
      /*  Omitted for BCD_to_Excess_3b version
          Included for BCD_to_Excess_3c version*/
      default: begin next_state = dont_care_state; B_out = dont_care_out; end
     // */  
    endcase
  end
endmodule

module test_BCD_to_Excess_3c ();
  wire	B_out, clk;
  reg	B_in, reset_b;
  defparam M2.half_cycle = 50;

BCD_to_Excess_3c M1 (B_out, B_in, clk, reset_b);
Clock_Gen M2 (clk);

initial begin #1000 $finish; end

initial begin
#10 reset_b = 0;  #90 reset_b = 1;
end

initial begin
#0 B_in = 0;
#100 B_in = 0;
#100 B_in = 0;
#100 B_in = 1;
#100 B_in = 0;
end

endmodule

