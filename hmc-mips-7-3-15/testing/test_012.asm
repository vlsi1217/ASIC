	.file	1 "test_012.c"

 # GNU C 2.7.2.3 [AL 1.1, MM 40] BSD Mips compiled by GNU C

 # Cc1 defaults:

 # Cc1 arguments (-G value = 8, Cpu = 3000, ISA = 1):
 # -quiet -dumpbase -msoft-float -Wall -o

gcc2_compiled.:
__gnu_compiled_c:
 #APP
	li $sp,0x200
 #NO_APP
	.text
	.align	2
	.globl	test_012
	.ent	test_012
test_012:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, extra= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	subu	$sp,$sp,16
	sw	$fp,8($sp)
	move	$fp,$sp
	li	$2,0x0000000c		# 12
	sw	$2,0($fp)
	li	$2,0x00000001		# 1
	sw	$2,4($fp)
$L2:
	lw	$2,0($fp)
	bne	$2,$0,$L4
	j	$L3
$L4:
	lw	$2,0($fp)
	addu	$3,$2,-1
	sw	$3,0($fp)
	lw	$3,4($fp)
	mult	$3,$2
	mflo	$4
	sw	$4,4($fp)
	j	$L2
$L3:
$L1:
	move	$sp,$fp			# sp not trusted here
	lw	$fp,8($sp)
	addu	$sp,$sp,16
	j	$31
	.end	test_012
