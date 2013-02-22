module word_aligner (word_out, word_in);
  output	[7: 0]	word_out;
  input 	[7: 0]	word_in;

  assign word_out = aligned_word(word_in);

  function [7: 0] aligned_word;
    input 	[7: 0] 	word_in;	// 5-10-2004
    begin
      aligned_word = word_in;
      if (aligned_word != 0)
        while (aligned_word[7] == 0) aligned_word = aligned_word << 1;
    end
  endfunction
endmodule

