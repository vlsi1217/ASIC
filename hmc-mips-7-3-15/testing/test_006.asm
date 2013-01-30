# Harvey Mudd College VLSI MIPS Project
# Carl Nygaard
# Spring, 2007
#
# Test 006
#
# Created: 1/5/07
#
#   Coprocessor 0 status register test.

.set noreorder

main:   addi  $3, $0, -1        # $3 = 0xffffffff
        mtc0  $3, $12           # set SR to all the ones we can
        nop                     # Let the assignment go through the pipeline
        nop                     # (This is acceptable, see See MIPS Run A.4.
        nop
        mfc0  $4, $12           # copy SR to $4
b8:     sw    $0, -1($4)        # should write 0 to 0x1263ff01 - 1 = 0x1263ff00
                                # (This is the value of the status register when
                                # everything that can be switch is turned on, it
                                # is subject to change though throuout
                                # development.)
end:    beq   $0, $0, end       # loop forever
        nop
