/* Harvey Mudd CMOS VLSI class MIPS project
 * 
 * $Author: whiterook2004 $
 * Created 2/10/07 by Matt McKnett
 * 
 * $Date: 2007-02-20 17:43:35 -0800 (Tue, 20 Feb 2007) $
 * test_fp_1.c
 *
 * This program is designed to test the "soft" floating point routines
 * of GCC to ensure that code is generated properly to handle floating
 * point in software (since it is not implemented on this chip in hardware.)
 */

asm("li $sp,0xf0");

void test_fp_1()
{
	float f1 = 3.14;
	float f2 = 2.0;
	float result_add = 1;	

	result_add = f1 + f2;
}
