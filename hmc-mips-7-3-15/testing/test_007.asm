# Harvey Mudd College VLSI MIPS Project
# Carl Nygaard
# Spring, 2007
#
# Test 007
#
# Created: 1/6/07
#
#   Tests store commands

.set noreorder

main:   addi $3, $0, -1          # $3 = 0xffffffff
        addi $4, $0, 0x10        # $4 = 0x10
        sw   $3, 0($4)           # Store 0xffffffff in 0x10
        sb   $0, 1($4)           # store 0x00 in 0x11 (not aligned)
        addi $6, $0, 0x5555      # $6 = 0x5555
        sll  $6, $6, 8           # $4 = 0x00555500
        sh   $6, 2($4)           # store 0x5500 in upper two bytes of 0x10
        lw   $5, 0($4)           # load $5 = 0x550000ff
        nop                      # Load Delay Slot (Although we stall just fine)
        sw   $5, 4($4)           # Store 0x550000ff in 0x14 (test checks this)
loop:   beq  $0, $0, loop        # Infinite Loop
