# Harvey Mudd College VLSI MIPS Project
# Carl Nygaard
# Spring, 2007
#
# Test 000
#
# Created: 12/24/06
#
# Commands tested:
#   addi, add, beq, sw
#
# Expected Behavior:
#   Fibinnacci Sequence.  

# Prevent the assembler from reordering and filling in branch delay slots
.set noreorder

main:   addi $2, $0, 0          # initialize $2 = 0
        addi $3, $0, 1          # initialize $3 = 1
        addi $5, $0, 21         # initialize $5 = 21 (stopping point)
loop:   add  $4, $2, $3         # $4 <= $2 + $3
        add  $2, $3, $0         # $2 <= $3
        add  $3, $4, $0         # $3 <= $4
        beq  $4, $5, write      # when sum is 21, jump to write
        nop
        beq  $0, $0, loop       # loop (beq is easier to assemble than jump)
        nop
write:  sw   $4, 7($2)          # should write 21 @ 7 + 13 = 20 = 0x14
end:    beq  $0, $0, end        # loop forever
        nop
