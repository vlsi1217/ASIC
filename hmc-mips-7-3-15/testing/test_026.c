/*
 * test_026.c
 *
 * Author: Matt McKnett
 * Date: 2/20/2007
 * 
 * This program will demonstrate some simple C language functions
 * on the mips
 */

asm("li $sp,0x200");  // Initialize the stack pointer.

void test_026()
{
	int success = 0;
	int result = 0;
	
	// Note: function calls do not work properly with this compiler.
	//result = helper_026();
	
	int add = 6+8;
	int mult = 7*2;
	result = mult/add;

	// Fail if helper did not change result.
	if(result == 0)
		success = 0;
	else
		success = 1;

	// Loop forever
	while(1);  
}

