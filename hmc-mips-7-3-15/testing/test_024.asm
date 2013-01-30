# Harvey Mudd College VLSI MIPS Project
# Nathaniel Pinckney
# Spring, 2007
#
# Test 024
#
# Created: 2/11/07
#
#   Tests byteen functionality, cached writes, for
#  both caches.
#
#  same as 22 except reverse endian (now big endian)

.set noreorder

# Start code 0xBFC00000
main:   

reon: # turn reverse endian
	mfc0 $8, $12
	li  $9, 1
	sll $9,$9,25
	or $9,$8,$9
	mtc0  $9, $12
	nop
	nop
	nop

	li $8, 0x200
	li $9, 0xde
	sb $9, 0($8)
	li $9, 0xad
	sb $9, 1($8)

	li $8, 0x200
	li $9, 0xbe
	sb $9, 2($8)
	li $9, 0xef
	sb $9, 3($8)

	lhu $13,0($8)
	sll $13,16

reoff: 
	mfc0 $8, $12
	li  $9, 1
	sll $9,$9,25
	not $9,$9
	and $9,$8,$9
	mtc0  $9, $12
	nop
	nop
	nop

	li $8, 0x200
	lhu $12, 0($8)
	or $12,$12,$13
	sw $12, 0($0)  # should spell 0xdeadbeef

end:    beq   $0, $0, end       # loop forever
        nop
	nop



