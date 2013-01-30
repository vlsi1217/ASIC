// RANDOM Number generator (hardware friendly)
//
// LFSR Register for a maximal length P/N sequence of 2^32:
//
// Taken from XILINX App Note XAPP 052.
//
// Taps for 32-bit sequence are at:
//    31,21,1,0
//
// Feed XNOR of tapped bits into LSB of left-shifted register.
//
// Ideas for testing:
//
//    For example, for the 8-bit sequence,
//       1. myrand FFF >! myrand.out
//
//          This write 4096 numbers to the file.  The 256 element sequence should
//          repeat 16 times.  Confirm this by grepping for random values.
//
//       2. grep -c 0000001A myrand.out
//
//          Should print '16'.  Do this for as many values as you can think of.
//          Searching for 000000FF should yield ZERO, however.
//   For the 32-bit seqence, you don't want to generate 4 billion values.  Instead,
//   generate as many as you can (e.g. myrand 000FFFFF, which will generate 1 million).
//   Open the file in an editor, randomly pick values, and then do the grep for that
//   same value.  Grep should print exactly '1' for each such example.
// 

#include <stdio.h>

// Generate a constant array specifying where the TAPs are.
// Fill this in from some LFSR Maximal Sequence table, such
// as is found in the XILINX app note.
//
// This particular program is limitied to 32-bit sequences since we are
// using simple unsigned long int variable, but can be extended.  The XAPP
// Note's table goes up to 168 bits.
//

// TAPS.  Select the one you want.  See XAPP 052 for more possibilities.
// 
const int taps[] = {31,21,1,0,  -1}; // TAPS For 32-bit sequence.  (Use -1 to end list)
//const int taps[] = {7,5,4,3,    -1}; // TAPS For  8-bit sequence.  (Use -1 to end list)
//const int taps[] = {3,2,        -1}; // TAPS For  4-bit sequence.  (Use -1 to end list)

// Indicate width.  Specify 32 if you want 2^32 - 1 Maximal Length Sequence.
#define WIDTH 32

// XILINX App Note says to use zero.  It says that the All-1s value is the LOCK-up value
// and should never be reached.
//
#define SEED 0

int main (int argc, char *argv[])
{
   unsigned long int x;
   int i, j;
   unsigned long int masks[32];
   unsigned long int feedback;
   unsigned long int n_points;
   unsigned long int width;
   
   if (argc == 1) {
      printf ("\n");
      printf ("Usage:\n");
      printf ("   myrand <# points in hex>\n");
      printf ("\n");
      printf ("Example:\n");
      printf ("   myrand FFF     ; Generate 4096 points\n");
      printf ("\n");
      printf ("Notes:\n");
      printf ("   At this time, you must change source code for different lengths..\n");
      printf ("\n");
      printf ("Currently, Taps are:\n");
      for (j = 0; taps[j] != -1; j++) {
         printf ("%ld ", taps[j]);
      }
      printf ("\n");
      return 1;
   }
   
   // Use command line argument to specify how many points.
   //
   n_points = 0;
   sscanf (argv[1], "%lx", &n_points);
   if (n_points == 0) {
      printf ("\nERROR: Must specify (in hex) how many points!\n");
      return 1;
   }
   
   // Generate the bit masks.  Generate all 32.
   //
   for (i = 0; i < 32; i++) {
      masks[i] = 1 << i;
   }
   
   width = (1 << WIDTH) - 1;
   //printf ("width = %lx\n", width);
   
   x = SEED;
   
   // For the number of points requested..
   while (n_points--) {
      // Based on the taps array, generate each XOR term. Remember, -1 signifies the end.
      feedback = 0;
      for (j = 0; taps[j] != -1; j++) {
// FOR Debug:
//         printf ("x = %08lx, taps[j] = %ld, masks[taps[j]] = %08lx, (x & masks[taps[j]]) = %l08x\n",
//            x, taps[j], masks[taps[j]], (x & masks[taps[j]]) );
         feedback ^= (x & masks[taps[j]]) ? 0x00000001 : 0x00000000;
      }
      // Do the XNOR (so, just complement BIT 0 of our feedback term)
      feedback ^= 0x00000001;
      
      // In hardware, this'll be more straight-forward, e.g. for the 32-bit case:
      //    assign feedback = ~^{x[31],x[21],x[1],x[0]};
      //    always @(posedge clk) ... x <= {x[30:0], feedback}; 
      //
      
      // Shift X to the left.  We'll OR in our feedback term in a moment.
      x <<= 1;
      
      // OR feedback bit into bit 0.
      x |= feedback;
      
      x &= width;
      
//    printf ("%08lX %08lX\n", feedback, x);
      printf ("%08lX\n", x);
   }
}

/*
         Here's the Verilog for reference...
      // Random Number Generator, 8-bit
      //
      // See companion program myrand.c
      //
      // (to verify, do the GREP trick described in myrand.c on verilog.out)
      //
      module myrand;
      
      reg clk, reset;
      reg [7:0] x;
      wire      feedback;
      
      // Use TAPS table from XACT 052 to make whatever length sequence you need.
      assign feedback = ~^{x[7],x[5],x[4],x[3]};

      // Shift and input feedback term.  That's it!
      always @(posedge clk) begin
         if (reset) x <= 0;
         else       x <= {x[6:0], feedback};
      end
      
      // remaining code just testbench...
      initial begin
         clk = 0;
         forever begin
            #10 clk = ~clk;
         end
      end
      
      initial begin
         reset = 0;
         #1 reset = 1;
         #35 reset = 0;
      end
      
      initial begin
         @(negedge reset);
         repeat (1024) begin
            @(posedge clk) #1;
            $display ("%h", x);
         end
         $finish;
      end
      endmodule

   
      
*/