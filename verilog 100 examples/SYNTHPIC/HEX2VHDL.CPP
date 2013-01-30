// *** SYNTHETIC PIC V1.0 ***
//
/*
	HEX2VHDL Converts the default HEX output of the Microchip PIC
	assembler, MPASM, into the VHDL format needed by the Synthetic PIC.
	Output is a PICROM VHDL entity.

	To use this utility, you will probably need to do the following step:
		1. Create and debug your PIC16C5X program using the standard MPASM
			and MPSIM programs.  Let's say, your program is TEST.ASM.  When you're
			done, you will have the file TEST.HEX
		2. Run this program with the command line:
				HEX2VHDL TEST
		3. You should now have the file TEST.VHD.  If you examine this file, you'll
			see that the actual VHDL entity is named PICROM.  So, copy your file
			into PICROM.VHD, eg.
				COPY TEST.VHD PICROM.VHD
		4. Now, you can recompile/analyse/synthesize your PICROM.VHD which is what
			the overal PICCPU and PICTEST VHDL models are expecting.

	You can conceivably create some BAT files that do whatever housekeeping you
	need for these files.  Perhaps, this program can be modified to offer more
	flexibility in generating entity names and file names.

	HEX2VHDL was written in Borland C++ for DOS, but is hopefully pretty vanilla..
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Input and Output file streams.
FILE *fpi, *fpo;

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
char *MakeBinaryString (unsigned int data);

char *szHelpLine = "\
\nThe Synthetic PIC --- HEX File to VHDL Memory Entity conververt.\
\nUsage: HEX2VHDL <filename> [<options>]\
\n  Input file is assumed to have the extension HEX.  \
\n  Output will go to the filename with the extension VHD\
\n\
\n  Options:\
\n     -stdlogic   Use the STD_LOGIC types (default is Viewlogic)";

char szInFilename[40];
char szOutFilename[40];

// Options variables
int bUseSTDLOGIC;

int main (int argc, char *argv[])
{
	int  i;

	if (!(argc == 2 || argc == 3)) {
		printf (szHelpLine);
		exit(1);
	}

	if ( (strcmp(argv[1], "?") == 0) ||
		  (strcmp(argv[1], "help") == 0) ||
		  (strcmp(argv[1], "-h") == 0) ||
		  (strcmp(argv[1], "-?") == 0)) {
		printf (szHelpLine);
		exit(1);
	}

	strcpy (szInFilename, argv[1]);
	if ( strstr(szInFilename, ".") == 0)
		strcat (szInFilename, ".HEX");

	strcpy (szOutFilename, argv[1]);
	strcat (szOutFilename, ".VHD");

	// Open input HEX file
	if((fpi=fopen(szInFilename, "r"))==NULL){
		printf("Can't open file %s.\n", szInFilename);
		exit(1);
	}

	// Handle any other options
	if (strcmpi(argv[2], "-stdlogic") == 0)
		bUseSTDLOGIC = 1;
	else
		bUseSTDLOGIC = 0;

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

	// Open/Create output VHDL file
	if((fpo=fopen(szOutFilename, "w"))==NULL){
		printf("Can't open VHDL file '%s'.\n", szOutFilename);
		exit(1);
	}

	// Now output the VHDL entity!
	//
	fprintf (fpo, "\n--");
	fprintf (fpo, "\n-- VHDL");
	fprintf (fpo, "\n--");
	fprintf (fpo, "\n-- Entity:	ROM");
	if (bUseSTDLOGIC) {
		fprintf (fpo, "\nlibrary ieee;");
		fprintf (fpo, "\nuse ieee.std_logic_1164.all;");

		fprintf (fpo, "\nlibrary synth;");
		fprintf (fpo, "\nuse synth.pack1164.ALL;");
	}
	else {
		fprintf (fpo, "\nlibrary synth;");
		fprintf (fpo, "\nuse synth.stdsynth.ALL;");
	}

	fprintf (fpo, "\n\nentity PICROM is");
	fprintf (fpo, "\n  port (");
	if (bUseSTDLOGIC) {
		fprintf (fpo, "\n	 Addr    : in   std_logic_vector(10 downto 0);");
		fprintf (fpo, "\n	 Data    : out  std_logic_vector(11 downto 0));");
	}
	else {
		fprintf (fpo, "\n	 Addr    : in   vlbit_1d(10 downto 0);");
		fprintf (fpo, "\n	 Data    : out  vlbit_1d(11 downto 0));");
	}

	fprintf (fpo, "\nend PICROM;");
	fprintf (fpo, "\n\n\narchitecture first of PICROM is");
	fprintf (fpo, "\nbegin");

	fprintf (fpo, "\n	Data <= ");
	for (i = 0; i < nMemoryCount; i++) {
		fprintf (fpo, "\n			  \"%s\" When v1d2int(Addr) = %05d Else",
			MakeBinaryString(Memory[i].byData)+4,    // only want 12 least significant
			Memory[i].nAddress
		);
	}

	fprintf (fpo, "\n			  \"000000000000\";");
	fprintf (fpo, "\nend first;");

	fclose (fpi);
	fclose (fpo);
}

// Return an ASCII formatted binary string of exactly 16 digits.
// eg. If the data value was 5344 decimal, then the string would be:
//    "0001010011100000"
//
// Nothin' fancy.  Always output leading zeros, not too much error checking..
//
char *MakeBinaryString (unsigned int data)
{
	static char szBinary[20];  // Statically allocated!  Caller better use immediately
	int  i;

	for (i = 0; i < 16; i++) {
		if (data & 0x8000) {
			szBinary[i] = '1';
		}
		else {
			szBinary[i] = '0';
		}
		data <<= 1;
	}

	// Zero terminate
	szBinary[i] = '\0';
	return szBinary;
}

