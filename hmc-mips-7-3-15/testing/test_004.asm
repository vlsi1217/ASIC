# Harvey Mudd College VLSI MIPS Project
# Carl Nygaard
# Spring, 2007
#
# Test 004
#
# Created: 1/1/07
#
#   Tests shift operations.

.set noreorder

main:   addiu $2, $0, 0x7f      # $2 = 0x7f
        srl   $3, $2, 5         # $3 = 0x7f >> 5 = 0x03
        sllv  $2, $2, $3        # $2 = 0x7f << 3 = 0x3f8
        sll   $4, $2, 22        # $4 = 0x3f8 << 22 = 0xffc00000
        sra   $4, $4, 22        # $4 = 0xffc00000 >>> 22 = 0xffffffff
        lui   $5, 0x8000        # $5 = 0x8000000
        xor   $4, $4, $5        # $4 = 0xffffffff ^ 0x80000000 = 0x7fffffff
        ori   $5, $0, 5         # $5 = 5
        srav  $4, $4, $5        # $4 = 0x7fffffff >> 5 = 0x03ffffff
        sllv  $4, $4, $3        # $4 = 0x03ffffff << 3 = 0x1ffffff8
        srl   $3, $3, 1         # $3 = 0x03 >> 1 = 0x01
        srlv  $4, $4, $3        # $4 = 0x1ffffff8 >> 1 = 0x0ffffffc
        sw    $2, 0($4)         # should write 0x3f8 to address 0x0ffffffc
end:    beq   $0, $0, end       # loop forever
        nop
