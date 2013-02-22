module find_first_one (index_value, A_word, trigger);
  output [3: 0] 	index_value;
  input 	[15: 0]	A_word;
  input 		trigger;
  reg 	[3: 0] 	index_value;
	
  always @  (trigger)
  begin: search_for_1
    index_value = 0;
    for (index_value = 0; index_value <= 15; index_value = index_value + 1)
    if (A_word[index_value] == 1) disable search_for_1;
  end
endmodule

