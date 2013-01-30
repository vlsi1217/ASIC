//
// Copyright (c) 1999 Thomas Coonan (tcoonan@mindspring.com)
//
//    This source code is free software; you can redistribute it
//    and/or modify it in source code form under the terms of the GNU
//    General Public License as published by the Free Software
//    Foundation; either version 2 of the License, or (at your option)
//    any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program; if not, write to the Free Software
//    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
//

// Intel HEX to Verilog converter.
//
// Usage:
//    hex2v <file>
//
// You probably want to simply redirect the output into a file.
//
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Input and Output file streams.
FILE *fpi;

// Well.. Let's read stuff in completely before outputting.. Programs
// should be pretty small..
//
#define MAX_MEMORY_SIZE  1024
struct {
   unsigned int  nAddress;
   unsigned int  byData;
} Memory[MAX_MEMORY_SIZE];

char szLine[80];
unsigned int  start_address, address, ndata_bytes, ndata_words;
unsigned int  data;
unsigned int  nMemoryCount;

int main (int argc, char *argv[])
{
   int  i;

   if (argc != 2) {
      printf ("\nThe Synthetic PIC --- Intel HEX File to Verilog memory file");
      printf ("\nUsage: hex2verilog <infile>");
      printf ("\n");
      return 0;
   }


   // Open input HEX file
   fpi=fopen(argv[1], "r");
   if (!fpi) {
      printf("\nCan't open input file %s.\n", argv[1]);
      return 1;
   }

   // Read in the HEX file
   //
   // !! Note, that things are a little strange for us, because the PIC is
   //    a 12-bit instruction, addresses are 16-bit, and the hex format is
   //    8-bit oriented!!
   //
   nMemoryCount = 0;
   while (!feof(fpi)) {
      // Get one Intel HEX line
      fgets (szLine, 80, fpi);
      if (strlen(szLine) >= 10) {
         // This is the PIC, with its 12-bit "words".  We're interested in these
         // words and not the bytes.  Read 4 hex digits at a time for each
         // address.
         //
         sscanf (&szLine[1], "%2x%4x", &ndata_bytes, &start_address);
         if (start_address >= 0 && start_address <= 20000 && ndata_bytes > 0) {
            // Suck up data bytes starting at 9th byte.
            i = 9;

            // Words.. not bytes..
            ndata_words   = ndata_bytes/2;
            start_address = start_address/2;

            // Spit out all the data that is supposed to be on this line.
            for (address = start_address; address < start_address + ndata_words; address++) {
               // Scan out 4 hex digits for a word.  This will be one address.
               sscanf (&szLine[i], "%04x", &data);

               // Need to swap bytes...
               data = ((data >> 8) & 0x00ff) | ((data << 8) & 0xff00);
               i += 4;

               // Store in our memory buffer
               Memory[nMemoryCount].nAddress = address;
               Memory[nMemoryCount].byData   = data;
               nMemoryCount++;
            }
         }
      }
   }
   fclose (fpi);

   // Now output the Verilog $readmemh format!
   //
   for (i = 0; i < nMemoryCount; i++) {
      printf ("\n@%03X %03X", Memory[i].nAddress, Memory[i].byData);
   }
   printf ("\n");

}
