# Harvey Mudd College VLSI MIPS Project
# Carl Nygaard
# Spring, 2007
#
# Test 008
#
# Created: 1/7/07
#
#   Tests load commands

.set noreorder

main:   addi $4, $0, 0x18        # $4 = 0x18
        addi $5, $0, 0           # $5 = 0
        lui  $3, 0x1234          #
        ori  $3, $3, 0xabcd      # $3 = 0x1234abcd
        sw   $3, 0($4)           # Store 0x1234abcd in 0x18
        lw   $6, 0($4)           # load $6 = 0x1234abcd
        nop                      # load delay slot
        bne  $6, $3, b1          # if ($6 == $3)
        nop                      #   //branch delay
        addi $5, $5, 1           #   ++$5 = 1 = b1
b1:     lh   $6, 0($4)           # $6 = 0xffffabcd
        lui  $7, 0xffff          # $7 = 0xffff0000
        or   $7, $7, $3          # $7 = 0xffffabcd
        bne  $7, $6, b2          # if ($6 == $7)
        nop                      #   //branch delay
        addi $5, $5, 2           #   ++$5 = = 3 = b11
b2:     lb   $6, 1($4)           # load $6 = 0xffffffab = -85
        addi $7, $0, -85         # $7 = -85
        bne  $7, $6, b3          # if ($6 == $7)
        nop                      #   //branch delay
        addi $5, $5, 4           #   ++$5 = 7 = b111
b3:     lbu  $6, 1($4)           # load $6 = 0x000000ab
        addi $7, $0, 0xab        # $7 = 0xab
        bne  $7, $6, b4          # if ($6 == $7)
        nop                      #   //branch delay
        addi $5, $5, 8           #   ++$5 = 0xf = b1111
b4:     lhu  $6, 2($4)           # load $6 = 0x00001234
        addi $7, $0, 0x1234      # $7 = 0x1234
        bne  $7, $6, b5          # if ($6 == $7)
        nop                      #   //branch delay
        addi $5, $5, 16          #   ++$5 = 0x1f = b11111
b5:     sw   $5, 0($4)           # Store 0x1f in 0x18 (test checks this)
loop:   beq  $0, $0, loop        # Infinite Loop
        nop
