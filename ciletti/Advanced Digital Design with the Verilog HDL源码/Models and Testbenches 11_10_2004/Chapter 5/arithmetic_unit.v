module arithmetic_unit (result_1, result_2, operand_1, operand_2,);
  output 		[4: 0] result_1;
  output		[3: 0] result_2;
  input 		[3: 0] operand_1, operand_2;
  

  assign result_1 = sum_of_operands (operand_1, operand_2);
  assign result_2 = largest_operand (operand_1, operand_2);

  function [4: 0] sum_of_operands;
    input [3: 0] operand_1, operand_2;

    sum_of_operands = operand_1 + operand_2;
  endfunction

  function [3: 0] largest_operand;
    input [3: 0] operand_1, operand_2;

    largest_operand = (operand_1 >= operand_2) ? operand_1 : operand_2;
  endfunction
endmodule

