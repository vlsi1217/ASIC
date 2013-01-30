# Harvey Mudd College VLSI MIPS Project
# Nathaniel Pinckney
# Spring, 2007
#
# Test 023
#
# Created: 2/11/07
#
#   Tests cache bypassing features.
#

.set noreorder

# Start code 0xBFC00000
main:   
	li $8, 0x200
	lui $9, 0xbfc0
	ori $9, $9, 0x200
	
	lui $10, 0xdead
	li $11, 0xbee0
	sw $10, 0($8) # Write to cache
	sb $0, 0($9) # this shouldn't invalidate
	sw $11, 0($9) # Bypass cache
	lw $10, 0($8) # Load cached version
	lw $11, 0($9) # Load uncached version
	or $10, $10, $11
	
	sb $0, 0($8)
	li $11, 0x000f
	sw $11, 0($9)
	lw $12, 0($8)
	or $10, $10, $12

	sw $10, 0($0)

end:    beq   $0, $0, end       # loop forever
        nop
	nop



