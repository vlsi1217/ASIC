# Harvey Mudd College VLSI MIPS Project
# Carl Nygaard
# Spring, 2007
#
# Test 003
#
# Created: 1/1/07
#
# Expected Behavior:
#   Tests R-Type Arithmetic instructions (besides mult and div)  

.set noreorder

main:   addiu $2, $0, -10       # $2 = -10
        addiu $3, $0, 10        # $3 = 10 
	subu  $5, $3, $3	# $5 = 10 - 10 *added 1/25/07 to test subu
	bne   $5, $0, end	# jump out if subu didn't work, should cause fail
        addu  $2, $2, $3        # $2 = $2 + $3 = -10 + 10 = 0
        addiu $4, $0, 100       # $4 = 100
        addiu $4, $2, 100       # $4 = $2 + 100 = 0 + 10 = 100
        addiu $5, $2, -100      # $5 = $2 + -100 = -100
        slt   $3, $2, $5        # $3 = ($2 < $5) = (0 < -100) = 0
        and   $2, $2, $3        # $2 = $2 & $3 = 0 & 0 = 0
        ori   $5, $0, 0x7fff    # $5 = 0x7fff
	andi  $5, $5, 0x7fff	# $5 = 0x7fff still *added 1/25/07
        sltu  $3, $2, $5        # $3 = (0 < 0x7fff (unsigned)) = 1
        lui   $4, 0x70f0        # $4 = 0x70f00000
        ori   $5, $0, 0xf000    # $5 = 0xf000
        or    $4, $4, $5        # $4 = 0x70f00000 | 0x0000f000 = 0x70f0f000
        ori   $5, $0, 0xfff0    # $5 = 0xfff0
        xor   $4, $4, 0xfff0    # $4 = 0x70f0f000 ^ 0x0000fff0 = 0x70f00ff0
        # although sltiu is unsigned, normal sign extension still occurs on the
        # immediate value
        addi  $5, $0, -1        # $5 = 0xffffffff
        sltu  $2, $4, $5        # $2 = (0x70f00ff0 < 0xffffffff) = 1
        addu  $2, $2, $3        # $2 = $2 + $3 = 1 + 1 = 2
        nor   $4, $4, $2        # $4 = ~(0x70f00ff0 | 0x2) = 0x8f0ff00d
write:  sw    $2, 3($4)         # should write 2 to 0x8f0ff00d + 3 0x8f0ff010
end:    beq   $0, $0, end       # loop forever
        nop
