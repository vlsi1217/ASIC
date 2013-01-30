module binarytogray (clk, reset, binary_input, gray_output);
input          clk, reset;
input   [3:0]  binary_input;
output         gray_output;
reg     [3:0]  gray_output;

always @ (posedge clk or posedge reset)
if (reset)
   begin
   gray_output <= 4'b0;
   end
else begin
     gray_output[3] <= binary_input[3];
     gray_output[2] <= binary_input[3] ^ binary_input[2];
     gray_output[1] <= binary_input[2] ^ binary_input[1];
     gray_output[0] <= binary_input[1] ^ binary_input[0];
     end
endmodule
