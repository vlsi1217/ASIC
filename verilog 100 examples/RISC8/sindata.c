#include <stdio.h>
#include <math.h>

// Generate a Verilog format memory table of SIN data for use
// in the DDS example.  Output a complete cycle.  Several defines
// are available to control ranges, etc. output 2s complement.

// How many data points?
const int N = 1024;

// How many bits wide?
const int W = 8;

// PI
const double PI = 3.1415927;

int main () 
{
   double	angle, sinval;
   int		addr, data;
   int  	span;
   
   span  = 1 << W;
   angle = 0;
   for (addr = 0; addr < N; addr++) {
      sinval = span/2 + (span/2 * sin(angle));
      data   = (int)sinval;
      printf ("\n@%03X %02X", addr, data);
      angle = angle + 2*PI/N;
      //printf ("\n... angle=%f, sinval=%f", angle, sinval);
   }
   printf ("\n");   
}
