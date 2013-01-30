/*
  Very simple example of PLI calls to do some C reading from files.
  Can jazz this basic scheme up as needed.
*/

#include <stdio.h>
#include "pliread.h"

#include "/tools/vcs5.1/ieee_headers/acc_user.h"
#include "/tools/vcs5.1/ieee_headers/vcsuser.h"

/*
   *** PLI Interface

   $pliopen  (<filename>, <handle>)
   $pliread  (<handle>, <format string>, <register>)
   $pliclose (<handle>)

*/

/* Internal data structures. */
#define MAX_FILES (10)
static FILE *	fptab[MAX_FILES] 	= {0,0,0,0,0,0,0,0,0,0};

/* Debug.. */
#define PLIREAD_VERBOSE (0)

int pliopen_call ()
{
   int		i;
   char *	filename;
   FILE *	fp;
   
   /* Get the filename and attempt to open it and get a file pointer. */
   filename = tf_getcstringp(1);
   fp = fopen (filename, "r");
   if (!fp) {
      printf ("\nPLIOPEN: Error opening file %s!", filename);
      return 1;
   }
   
   /* We need to return a handle.  Find first non-zero handle. */
   for (i = 0; i < MAX_FILES; i++) {
      if (fptab[i] == 0) {
         /* Found one. */
         fptab[i] = fp;
         
         /* Stick this integer handle into 2nd argument */
         tf_putp (2, i);
         return 1;
      }
   }
   
   if (PLIREAD_VERBOSE)
      printf ("\nPLIOPEN: Successfully opened file %s with handle of %d.", filename, i);
   return 0;
}

int pliread_call ()
{
   char		line[200];
   int		fhandle;
   char *	fmt;
   int		value;
   FILE *	fp;
   
   /* Get the handle */
   fhandle = tf_getp (1);
   
   /* Check it out first */
   if (fhandle < 0 || fhandle >= MAX_FILES) {
      printf ("\nPLIREAD: Invalid file handle.  Aborting read.");
      return 1;
   }
   
   /* Handle is used to look up actual FILE pointer */
   fp = fptab[fhandle];
   if (fp == 0) {
      printf ("\nPLIREAD: File appears to be closed.  Aborting read.");
      return 1;
   }
   
   /* OK.  Try and read a line, check for EOFs.. */
   if (!feof(fp)) {
      fgets (line, sizeof(line), fp);
      if (!feof(fp)) {
         if (strlen(line) > 0) {
            /* Got a promising line.  Get format string from user */
            fmt = tf_getcstringp(2);
            if (PLIREAD_VERBOSE)
               printf ("\nPLIREAD: Using format string of <%s>.", fmt);
               
            /* Here is the actual read */
            sscanf (line, fmt, &value);
            if (PLIREAD_VERBOSE)
               printf ("\nPLIREAD: Read integer value of %d (0x%X).", value, value);
               
            /* That's it.  Stick value back into caller's 3rd argument */
            tf_putp(3, value);
         }
      }
   }
   return 0;
}

int pliclose_call ()
{
   int		fhandle;
   
   /* Get handle from 1st argument */
   fhandle = tf_getp(1);
   
   /* Check it out a little bit */
   if (fhandle < 0 || fhandle >= MAX_FILES) {
      printf ("\nPLICLOSE: Error, invalid file handle %d.", fhandle);
      return 1;
   }
   
   /* Close the file.  Get actual FILE pointer from our little local table. */
   fclose (fptab[fhandle]);
   
   /* Clear our table entry so we can reuse */
   fptab[fhandle] = 0;
   return 0;
}
