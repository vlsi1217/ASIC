module Counter8_Prog (count, mode, direction, enable,  clk, reset);
  output	[7: 0]	count; 	   // Hardwired for demo board
  input	[1: 0] 	mode;	   // Determine pattern sequence displayed by count
  input		direction;  //  Determines movement (left/up, right/down)
  input		enable;
  input		clk, reset;
  reg 		count;
  parameter	start_count	= 1; 	// Sets initial pattern of the display to LSB of count

  // Mode of count
  parameter		binary 	= 0;
  parameter		ring1 	= 1;
  parameter		ring2	= 2; 
  parameter		jump2	= 3;

  // Direction of count
  parameter		left 	= 0;
  parameter		right 	= 1;
  parameter		up 	= 0;
  parameter		down 	= 1;

  always @ (posedge clk or posedge reset)
    if (reset ==1) count <= start_count;
    else if (enable ==1) 
      case (mode)
        ring1:	count <= ring1_count	(count, direction);
        ring2:	count <= ring2_count	(count, direction);
        jump2:	count <= jump2_count	(count, direction);
      default:	count <= binary_count	(count, direction);
    endcase

  function 	[7: 0] 	binary_count;
    input 		[7: 0] 	count;
    input			direction;
    begin 
      if (direction == up) binary_count = count +1; else binary_count = count-1;
    end
  endfunction    

  // Other functions are declared here.
endmodule

