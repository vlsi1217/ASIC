/* source file: t_keypad_FIFO.v
Test bench for keypad FIFO unit.


Note:  Use the following source files to test the keypad FIFO.  

t_keypad_FIFO.v
top_keypad_FIFO.v
Hex_Keypad_Grayhill_072.v
FIFO.v
synchronizer.v
toggle.v
clock_divider.v
synchro_2.v
display_mux_3_4.v
row_signal.v

Note:  The clock divider instantiated within Top_keypad_FIFO produces a slow clock for the purpose of testing.  Adjust the clock divider to work with the hardware prototype. 
md ciletti rev 6-13-2002
*/

module t_TOP_Keypad_FIFO();
  
wire	[6:0]	Cathode;
wire	[3:0]	Col;
wire 		Left_anode, Right_anode;
wire		valid;
wire		empty;
wire		full;

wire [3:0]	Row;
reg		read;
reg		clock, reset;

  
  reg [15:0] 	Key;
  integer		 j, k;
  reg[39:0] 	Pressed;
  parameter		stack_width = 4;
  parameter		[39:0]Key_0 = "Key_0";
  parameter		[39:0]Key_1 = "Key_1";
  parameter		[39:0]Key_2 = "Key_2";
  parameter		[39:0]Key_3 = "Key_3";
  parameter		[39:0]Key_4 = "Key_4";
  parameter		[39:0]Key_5 = "Key_5";
  parameter		[39:0]Key_6 = "Key_6";
  parameter		[39:0]Key_7 = "Key_7";
  parameter		[39:0]Key_8 = "Key_8";
  parameter		[39:0]Key_9 = "Key_9";
  parameter		[39:0]Key_A = "Key_A";
  parameter		[39:0]Key_B = "Key_B";
  parameter		[39:0]Key_C = "Key_C";
  parameter		[39:0]Key_D = "Key_D";
  parameter		[39:0]Key_E = "Key_E";
  parameter		[39:0]Key_F = "Key_F";
  parameter		[39:0]None  = "None";		
   
  wire [stack_width -1: 0] stack0 = UUT.M2.stack[0];		// Probes of the stack
  wire [stack_width -1: 0] stack1 = UUT.M2.stack[1];
  wire [stack_width -1: 0] stack2 = UUT.M2.stack[2];
  wire [stack_width -1: 0] stack3 = UUT.M2.stack[3];
  wire [stack_width -1: 0] stack4 = UUT.M2.stack[4];
  wire [stack_width -1: 0] stack5 = UUT.M2.stack[5];
  wire [stack_width -1: 0] stack6 = UUT.M2.stack[6];
  wire [stack_width -1: 0] stack7 = UUT.M2.stack[7];

  always @ (Key) begin
    case (Key)
      16'h0000: 	Pressed = None;
      16'h0001: 	Pressed = Key_0;
      16'h0002: 	Pressed = Key_1;
      16'h0004: 	Pressed = Key_2;
      16'h0008: 	Pressed = Key_3;

      16'h0010: 	Pressed = Key_4;
      16'h0020: 	Pressed = Key_5;
      16'h0040: 	Pressed = Key_6;
      16'h0080: 	Pressed = Key_7;

      16'h0100: 	Pressed = Key_8;
      16'h0200: 	Pressed = Key_9;
      16'h0400: 	Pressed = Key_A;
      16'h0800: 	Pressed = Key_B;

      16'h1000: 	Pressed = Key_C;
      16'h2000: 	Pressed = Key_D;
      16'h4000: 	Pressed = Key_E;
      16'h8000: 	Pressed = Key_F;

      default: Pressed = None;
    endcase
  end

TOP_Keypad_FIFO UUT (Cathode, Col,  Left_anode, Right_anode, valid, empty, full, Row, read, clock, reset);

  Row_Signal M2(Row, Key, Col);

    initial #4000 $finish;
    initial begin clock = 0; forever #5 clock = ~clock; end
    initial begin reset = 1; #10 reset = 0; end
    initial  begin for (k = 0; k <= 1; k = k+1) begin Key = 0; #25 for (j = 0; 
      j <= 16; j = j+1) begin
      #67 Key[j] = 1; #160 Key = 0; end end end


     initial begin forever begin
        #307 read = 1;
        #20 read = 0;

       end
     end
 endmodule


