/*
   Example of how you might begin to create a C model for something
   within a larger Verilog simulation.  Look at mypli.v while looking at this.
*/

#include <stdio.h>
#include "mypli.h"

#include "/tools/vcs5.1/ieee_headers/acc_user.h"
#include "/tools/vcs5.1/ieee_headers/vcsuser.h"

/*
   *** PLI Interface

   $mypli_reset     -   Reset this model
   $mypli_cycle     -   Run the model one cycle
   $mypli_getcount  -  Retrieve the counter value

*/

/* Internal data structures. */
unsigned long	counter;
int		modulo;

/*
   Reset the model.  It's OK to call this for more than one cycle.
*/
int mypli_reset_call ()
{
   
   printf ("\nMYPLI: Initializing model data..\n");
   counter = 0;
   modulo  = 16;
   return 0;
}

/*
   Advance the model one cycle/clock.  In this case, it simply advances our counter.
*/
int mypli_cycle_call ()
{
   counter = (counter + 1) % modulo;
   return 0;
}

/*
   Set the current calue of the modulo used to wrap the counter.  1st argument to PLI call should be the modulo value.
*/
int mypli_setmodulo_call ()
{
   modulo = tf_getp (1);
   printf ("\nMYPLI_GETCOUNT: Set modulo to %d\n", modulo);
   return 0;
}

/*
   Get the current calue of the counter.  1st argument to PLI call should be the receiving register.
*/
int mypli_getcount_call ()
{
   /* printf ("\nMYPLI_GETCOUNT: ... 'tf_getp(1)' = %x", tf_getp(1)); */
   tf_putp (1, counter);
   return 0;
}
