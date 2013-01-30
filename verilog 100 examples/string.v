//
// Demonstrate how to display strings for a particular signal.
// This allows you to see a text string for a bus, which at times, might
// help out in debugging.  This is not intended for synthesis, of course.
// Keep these funny "string" signals seperate so we can disable them
// at synthesis time and so they never impact the circuit.
//
//
module test;

// Declare a register with enough bits for the ASCII string.
// synopsys translate_off
reg [9*8-1:0] string_signal; // **** FOR TESTING
// synopsys translate_on

// Here's the *real* circuit signal
reg [3:0] shift_register;

reg clk, reset;

// Here's the real circuit
always @(posedge clk)
   if (reset) shift_register <= 4'b0001;
   else       shift_register <= {shift_register[2:0], shift_register[3]};

// Now we assign to our string signal based on the real signal.
// Disable this code when synthesizing.
//   
// synopsys translate_off
always @(shift_register)
   case (shift_register)
      4'b0001: string_signal <= "BIT  ZERO";
      4'b0010: string_signal <= "BIT   ONE";
      4'b0100: string_signal <= "BIT   TWO";
      4'b1000: string_signal <= "BIT THREE";
      default: string_signal <= "?????????";                  
   endcase
// synopsys translate_on

initial begin
   clk =  0;
   forever begin
      #10 clk = ~clk;
   end
end

initial begin
   reset = 0;
   #2 reset = 1;  
   #13 reset = 0;
   #200;
   $finish;
end

// Generate VCD file for viewing.
//
// Once we are in the Waveform Viewer, just set the format of 'string_signal'
// to ASCII!
//
initial begin
   $dumpfile ("test_string_signal.vcd");
   $dumpvars (0,test);   
end

   
endmodule
