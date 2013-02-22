module Bubble_Sort (A1, A2, A3, A4, A5, A6, A7, A8,En, Ld, clk, rst);
  output [3:0]  A1, A2, A3, A4, A5, A6, A7, A8;
  input		En, Ld, clk, rst;
  parameter	N = 8;
  parameter	word_size = 4;

/*
  parameter	a1 = 5;
  parameter	a2 = 5;
  parameter	a3 = 5;
  parameter	a4 = 5;
  parameter	a5 = 5;
  parameter	a6 = 5;
  parameter	a7 = 5;
  parameter	a8 = 5;
*/
/*
  parameter	a1 = 1;
  parameter	a2 = 2;
  parameter	a3 = 3;
  parameter	a4 = 4;
  parameter	a5 = 5;
  parameter	a6 = 6;
  parameter	a7 = 7;
  parameter	a8 = 8;
*/


  parameter	a1 = 8;
  parameter	a2 = 1;
  parameter	a3 = 8;
  parameter	a4 = 1;
  parameter	a5  = 8;
  parameter	a6 = 1;
  parameter	a7 = 8;
  parameter	a8 = 1;
/*parameter	a1 = 8;
  parameter	a2 = 7;
  parameter	a3 = 6;
  parameter	a4 = 5;
  parameter	a5  = 4;
  parameter	a6 = 3;
  parameter	a7 = 2;
  parameter	a8 = 1;
*/
 
  reg 		[word_size -1: 0]		A [1: N];
  wire [3:0]	A1 = A[1];
  wire [3:0]	A2 = A[2];
  wire [3:0]	A3 = A[3];
  wire [3:0]	A4 = A[4];
  wire [3:0]	A5 = A[5];
  wire [3:0]	A6 = A[6];
  wire [3:0]	A7 = A[7];
  wire [3:0]	A8 = A[8];
  parameter	S_idle = 0;
  parameter	S_run = 1;
  reg		[3: 0]			i, j;

  wire 					gt = (A[j-1] > A[j]); 	

  reg					swap, decr_j, incr_i, set_i, set_j;
  reg					state, next_state;

  always @ (posedge clk) if (rst) state <= S_idle; else state <= next_state; 

  always @ (state or En or Ld or gt or i or j) begin
    swap = 0;
    decr_j = 0;
    incr_i = 0;
    set_j = 0;
    set_i = 0;
    case (state)
      S_idle: 	if (Ld) begin next_state = S_idle; end
		else if (En) begin next_state = S_run; if (gt) begin swap = 1; decr_j = 1; end end 
		else next_state = S_idle; 

      S_run:	if (j >= i) begin next_state = S_run; decr_j = 1; if (gt) swap = 1; end
		else if (i <= N) begin next_state = S_run; set_j = 1; incr_i = 1; end
		else begin next_state = S_idle; set_j = 1; set_i = 1; end 
		 
    endcase
  end

  always @ (posedge clk)
    if (rst) begin i <= 0; j <= 0; 
      A[1] <= 0;
      A[2] <= 0;
      A[3] <= 0;
      A[4] <= 0;
      A[5] <= 0;
      A[6] <= 0;
      A[7] <= 0; 
      A[8] <= 0;
    end
   else  if (Ld) begin i <= 2; j <= N; 
      A[1] <= a1;
      A[2] <= a2;
      A[3] <= a3;
      A[4] <= a4;
      A[5] <= a5;
      A[6] <= a6;
      A[7] <= a7; 
      A[8] <= a8;
    end
  else begin /*#1  // for display only; remove for synthesis  */
    if (swap) begin A[j] <= A[j-1]; A[j-1] <= A[j]; end
    if (decr_j) j <= j-1;
    if (incr_i) i <= i+1;
    if (set_j) j <= N;
    if (set_i) i <= 2;
  end
 endmodule
 


