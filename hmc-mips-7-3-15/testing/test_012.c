/*  Harvey Mudd College VLSI MIPS Project
 * Carl Nygaard
 * Spring, 2007
 *
 * Test 012
 *
 * Created: 1/27/07
 *
 *   Multiply test
 */

//  In order to run the first function, first initialize stack pointer
asm("li $sp,0x200");

void test_012()
{
  int counter = 12;
  int result = 1;
  while (counter != 0)
    result *= counter--;
}
        
