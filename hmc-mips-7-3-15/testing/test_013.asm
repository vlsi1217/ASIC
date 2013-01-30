# Harvey Mudd College VLSI MIPS Project
# Thomas W. Barr, Carl Nygaard
# Spring, 2007
#
# Test 013
#
# Created: 1/20/07
#
# Interrupt testing

.set noreorder

# Start code 0x1FC00000
main:   addi  $3, $0, -1        # $3 = 0xffffffff
        mtc0  $3, $12           # set SR to all the ones we can
        addi $3, $0, 0
        nop                    # we don't really do much, we just sit around
        nop                    # waiting to be interrupted
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        
        sw    $3, 4($0)         # should write 2 to address 4
end:    beq   $0, $0, end       # loop forever
        nop

nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop
nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;
nop

# Start exception code 0x1FC00100
except: nop
        mfc0  $7, $14           # get the exception address
        addi $3, $3, 1          # increment the exception counter
        nop                     # MUST HAVE NOPS HERE - Move from cp0 takes a 
        nop                     # while, and has no hazard detection
        nop                     # we just need to make sure we don't catch
        nop                     # interrupts here
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        addi  $7, $7, 4         # Point to one past the errant instruction
        jr    $7                # Resume
        rfe                     # reenable interrupts
