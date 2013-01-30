# Harvey Mudd College VLSI MIPS Project
# Nathaniel Pinckney
# Spring, 2007
#
# Test 021
#
# Created: 2/11/07
#
#   Tests basic read/write functionality of instruction cache
#   and write buffer.
#
# Basically the same as test 20, except it swaps the caches.
#

.set noreorder

# Start code 0xBFC00000
main:   
swapon: # swap the cache
	mfc0 $8, $12
	li  $9, 1
	sll $9,$9,17
	or $9,$8,$9
	mtc0  $9, $12
	nop
	nop
	nop

	# Uncached test.
	lui $7, 0xBFC0
	ori $7, $7, 0x0200 # uncached
	
	lui $8, 0x8000 
        lui $9, 0x4000 
	lui $10, 0x1000
	lui $11, 0x0e00
	lui $12, 0x00a0
	lui $13, 0x000d

	sw $8, 0($7) 
	sw $9, 4($7) 
	sw $10, 8($7) 
	sw $11, 12($7) 
	sw $12, 16($7) 
	sw $13, 20($7)

	lw $8, 20($7)
	lw $9, 16($7)
	lw $10, 12($7)
	lw $11, 8($7)
	lw $12, 4($7)
	lw $13, 0($7)

	or $14, $0, $8
	or $14, $14, $9
	or $14, $14, $10
	or $14, $14, $11
	or $14, $14, $12
	or $14, $14, $13

	# Cached test
	li $7, 0x0200 # cached
	
	li $8, 0x8000 
	li $8, 0x8000 
        li $9, 0x3000 
	li $10, 0x0800
	li $11, 0x0400
	li $12, 0x0200
	li $13, 0x00e0

	sw $8, 0($7) 
	sw $9, 4($7) 
	sw $10, 8($7) 
	sw $11, 12($7) 
	sw $12, 16($7) 
	sw $13, 20($7)

	lw $8, 20($7)
	lw $9, 16($7)
	lw $10, 12($7)
	lw $11, 8($7)
	lw $12, 4($7)
	lw $13, 0($7)

	or $14, $14, $8
	or $14, $14, $9
	or $14, $14, $10
	or $14, $14, $11
	or $14, $14, $12
	or $14, $14, $13

	# Quick read/write test uncached.
	lui $7, 0xBFC0
	ori $7, $7, 0x0200 # uncached
	li $8, 0x000f
	sw $8, 0($7)
	lw $8, 0($7)
	or $14,$14,$8

	sw $14, 0($0)  # should spell 0xdeadbeef

swapoff: # swap the cache
	mfc0 $8, $12
	li  $9, 1
	sll $9,$9,17
	not $9,$9
	and $9,$8,$9
	mtc0  $9, $12
	nop
	nop
	nop

end:    beq   $0, $0, end       # loop forever
        nop
	nop



