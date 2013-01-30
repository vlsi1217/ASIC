	.file	1 "test_026.c"

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
	.globl	test_026
	.ent	test_026
test_026:
	.frame	$fp,24,$31		# vars= 16, regs= 1/0, args= 0, extra= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	subu	$sp,$sp,24
	sw	$fp,16($sp)
	move	$fp,$sp
	sw	$0,0($fp)
	sw	$0,4($fp)
	li	$2,0x0000000e		# 14
	sw	$2,8($fp)
	li	$2,0x0000000e		# 14
	sw	$2,12($fp)
	lw	$2,12($fp)
	lw	$3,8($fp)
	div	$2,$2,$3
	sw	$2,4($fp)
	lw	$2,4($fp)
	bne	$2,$0,$L2
	sw	$0,0($fp)
	j	$L3
$L2:
	li	$2,0x00000001		# 1
	sw	$2,0($fp)
$L3:
	.set	noreorder
	nop
	.set	reorder
$L4:
	j	$L6
	j	$L5
$L6:
	j	$L4
$L5:
$L1:
	move	$sp,$fp			# sp not trusted here
	lw	$fp,16($sp)
	addu	$sp,$sp,24
	j	$31
	.end	test_026
