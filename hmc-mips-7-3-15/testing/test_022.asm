# Harvey Mudd College VLSI MIPS Project
# Nathaniel Pinckney
# Spring, 2007
#
# Test 022
#
# Created: 2/11/07
#
#   Tests byteen functionality, cached writes, for
#  both caches.
#
#  Assumes little endian

.set noreorder

# Start code 0xBFC00000
main:   
	li $8, 0x200
	li $9, 0xde
	sb $9, 3($8)
	li $9, 0xad
	sb $9, 2($8)

swapon: # swap the cache
	mfc0 $8, $12
	li  $9, 1
	sll $9,$9,17
	or $9,$8,$9
	mtc0  $9, $12
	nop
	nop
	nop

	li $8, 0x200
	li $9, 0xbe
	sb $9, 1($8)
	li $9, 0xef
	sb $9, 0($8)

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

	li $8, 0x200
	lw $12, 0($8)
	sw $12, 0($0)  # should spell 0xdeadbeef

end:    beq   $0, $0, end       # loop forever
        nop
	nop



