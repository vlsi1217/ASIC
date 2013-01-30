# Harvey Mudd College VLSI MIPS Project
# Carl Nygaard
# Spring, 2007
#
# Test 002
#
# Created: 12/28/06
#
#   Tests immediate instructions, hazards, negative numbers.  

.set noreorder

main:   addiu $2, $0, -10       # $2 = -10
        addiu $3, $0, 10        # $3 = 10
        addu  $2, $2, $3        # $2 = $2 + $3 = -10 + 10 = 0
        addiu $4, $2, 100       # $4 = $2 + 100 = 0 + 10 = 100
        addiu $5, $2, -100      # $5 = $2 + -100 = -100
        slti  $3, $2, -1        # $3 = ($2 < -1) = (0 < -1) = 0
        addu  $2, $2, $3        # $2 = $2 + $3 = 0 + 0 = 0
        sltiu $3, $2, 0x7fff    # $3 = (0 < 0x7fff (unsigned)) = 1
        lui   $4, 0x70f0        # $4 = 0x70f00000
        ori   $4, $4, 0xf000    # $4 = 0x70f00000 | 0x0000f000 = 0x70f0f000
        xori  $4, $4, 0xfff0    # $4 = 0x70f0f000 ^ 0x0000fff0 = 0x70f00ff0
        # although sltiu is unsigned, normal sign extension still occurs on the
        # immediate value
        sltiu $2, $4, -1        # $2 = (0x70f00ff0 < 0xffffffff) = 1
        addu  $2, $2, $3        # $2 = $2 + $3 = 1 + 1 = 2
write:  sw   $2, 0($4)          # should write 2 to address 0x70f00ff0
end:    beq  $0, $0, end        # loop forever
        nop
