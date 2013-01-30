# Harvey Mudd College VLSI MIPS Project
# Thomas W. Barr, Carl Nygaard
# Spring, 2007
#
# Test 010
#
# Created: 1/20/07
#
#   Additional exception tests.
#   Just throws exceptions one after the other, and makes sure that we gather
#   the proper number of exceptions. Not terribly rigorous, but ought to be 
#   enough for now.

.set noreorder

# Start code 0x1FC00000
main:   addi $3, $0, 0
        sh $0, 3($0)             # misaligned halfword write (should fail)
        lh $4, 3($0)             # misaligned halfword write (should fail)
        
        sw $0, 2($0)             # misaligned word write
        lw $4, 2($0)             # misaligned word read
        
        sh $0, 2($0)             # halfaligned halfword write (should succeed)
        lh $4, 2($0)             # halfaligned halfword write (should succeed)
                                # beware the load delay slot!
        
        sw    $3, 0($0)         # should write 1 to address 0
end:    beq   $0, $0, end       # loop forever
        nop

nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop
nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop
nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop

# Start exception code at 0x1FC00100 (0x100 compiled) at the earliest
except: nop
        mfc0  $7, $14           # get the exception address
        addi $3, $3, 1          # increment the exception counter
        nop                     # MUST HAVE NOPS HERE - Move from cp0 takes a 
        nop                     # while, and has no hazard detection
        nop
        addi  $7, $7, 4         # Point to one past the errant instruction
        jr    $7                # Resume
        nop                     # BSD
        
