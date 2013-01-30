# Harvey Mudd College VLSI MIPS Project
# Carl Nygaard
# Spring, 2007
#
# Test 009
#
# Created: 1/8/07
#
#   Overflow exception test.

.set noreorder

# Start code 0x1FC00000
main:   lui   $2, 0x8000        # $2 = 0x80000000 = (largest negative number)
        lui   $3, 0x8000        # $3 = 0x80000000 = (largest negative number)
        add   $2, $2, $3        # $2 = $2 + $3 = 0 (cause overflow exception)
                                # (jump to exception code)
        sw    $4, 0($7)         # should write 12 to address 0xbfc0000c
end:    beq   $0, $0, end       # loop forever
        nop

nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop
nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop
nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop

# Start exception code 0x1FC00100
except: mfc0  $4, $13           # get the cause register
        mfc0  $7, $14           # get the exception address
        andi  $4, 0xff          # mask out the exception code
        srl   $4, $4, 2         # align the exception code
        addi  $5, $0, 12        # $5 = 12
        bne   $4, $5, end       # fail if the exception code is not 12 (stored in $4)
        addi  $7, $7, 4         # Point to one past the errant instruction
                                # (to avoid an infinite exception loop)
        nop
        nop # something is weird here, so adding nops
        nop
        nop
        nop
        nop
        jr    $7                # Resume
        nop                     # BSD
