module count_ones_SM (bit_count, busy, done, data, start, clk, reset);
  parameter				counter_size = 3;
  parameter				word_size = 4;

  output 		[counter_size -1 : 0]	bit_count;
  output					busy, done;
  input 		[word_size-1: 0] 		data;
  input 					start, clk, reset;
  wire					load_temp, shift_add, clear;
  wire					temp_0, temp_gt_1;

  controller M0 (load_temp, shift_add, clear, busy, done, start, temp_gt_1, clk, reset);
  datapath M1 (temp_gt_1, temp_0, data, load_temp, shift_add, clk, reset);
  bit_counter_unit M2 (bit_count, temp_0, clear, clk, reset);

endmodule

module controller (load_temp, shift_add, clear, busy, done, start, temp_gt_1, clk, reset);
  parameter				state_size = 2;
  parameter				S_idle = 0;
  parameter				S_counting = 1;
  parameter				S_waiting = 2;

  output					load_temp, shift_add, clear, busy, done;
  input 					start, temp_gt_1, clk, reset;

  reg					bit_count;
  reg 	[state_size-1 : 0]			state, next_state;
  reg					load_temp, shift_add, busy, done, clear;

  always @ (state or start or temp_gt_1) begin
    load_temp = 0;
    shift_add = 0;
    done = 0;
    busy = 0;
    clear = 0;
    next_state = S_idle;

    case (state)
      S_idle:	if (start) begin next_state = S_counting; load_temp = 1; end
		  
      S_counting:	begin busy = 1; if (temp_gt_1) begin next_state = S_counting;
    		  shift_add = 1; end 
		else begin next_state = S_waiting; shift_add = 1;  end
		end

      S_waiting:	begin 
		  done = 1;
		  if (start) begin next_state = S_counting; load_temp = 1; clear = 1; end 
		    else next_state = S_waiting;
		end

      default:	begin clear = 1; next_state = S_idle; end
    endcase
  end

  always @ (posedge clk) // state transitions
    if (reset)  
      state <= S_idle;
    else state <= next_state;
endmodule

module datapath (temp_gt_1, temp_0, data, load_temp, shift_add, clk, reset);
  parameter				word_size = 4;
  output					temp_gt_1, temp_0;
  input 		[word_size-1: 0] 		data;
  input 					load_temp, shift_add, clk, reset;

   reg		[word_size-1: 0] 		temp;
  wire					temp_gt_1 = (temp > 1);
  wire					temp_0 = temp[0];	

  always @ (posedge clk) 		// state and register transfers
    if (reset)  begin
      temp <= 0; end
    else begin
      if (load_temp) temp <= data;
      if (shift_add) begin temp <= temp >> 1; end
    end
endmodule

module bit_counter_unit (bit_count, temp_0, clear, clk, reset);
  parameter				counter_size = 3;
  output 		[counter_size -1 : 0]	bit_count;
  input					temp_0;
  input					clear, clk, reset;
  reg 					bit_count;

  always @ (posedge clk) 		// state and register transfers
    if (reset || clear)  
      bit_count <= 0;
    else bit_count <= bit_count + temp_0;
endmodule
