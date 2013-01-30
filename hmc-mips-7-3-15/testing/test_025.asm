# Harvey Mudd College VLSI MIPS Project
# Nathaniel Pinckney
# Spring, 2007
#
# Test 024
#
# Created: 2/11/07
#
#   Tests reading/writing to addresses with identical
# tags but different data.
#
#  

.set noreorder

# Start code 0xBFC00000
main:   
	li $8, 0x200
	lui $10, 0xdead
	
	li $9, 0x400
	li $11, 0xbeef
	
	sw $10, 0($8)
	sw $11, 0($9)
	nop
	nop
	nop
	lw $10, 0($9)
	lw $11, 0($8)
	or $10, $10, $11
	sw $10, 0($0)

end:    beq   $0, $0, end       # loop forever
        nop
	nop



