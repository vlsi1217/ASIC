/*  Harvey Mudd College VLSI MIPS Project
 * Carl Nygaard
 * Spring, 2007
 *
 * Test 016
 *
 * Created: 1/30/07
 *
 *   Multiple/Divide test
 */

#include <limits.h>

//  In order to run the first function, first initialize stack pointer
asm("li $sp,0x200");

void test_016()
{
  int num = 311;
  int div = 71;
  int i;
  int res = num / div; // res = 4
  res += num % div;    // res += 27 = 31
  res *= 5; // 155
  div *= 2; // 142
  res %= 156; // 155
  res *= div; // 22010
  res /= 10;  // 2201
}
        
