# Harvey Mudd College VLSI MIPS Project
# Matt Totino
# Spring, 2007
#
# Test 015
#
# Created: 1/28/07
#
#   Tests BDS stuff

.set noreorder

# Start code 0x1FC00000
main:   addi  $6, $0, 0		# start test count at 0
	lui   $2, 0x8000        # $2 = 0x80000000 = (largest negative number)
        addi  $3, $0, -1        # $3 = -1
	j     x			# go to x
	nop

	add   $2, $2, $3        # should not happen
w:	addi  $6, $6, 1		# $6 = 2 now
	beq   $0, $0, end	# go to end/fail - should not happen

x:	add   $2, $2, $3        # BDS: $2 = $2 + $3 = 0 (cause overflow exception)
	beq   $0, $0, w		# jump to w
	beq   $0, $0, y		# jump to y

y:	addi  $6, $6, 2		# $6 = 4 now
        sw    $6, 0($6)         # should write 4 to address 0x4
end:    beq   $0, $0, end       # loop forever
        nop

nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop
nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop
nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop

# Start exception code 0x1FC00100
except: mfc0  $4, $13           # get the cause register
        mfc0  $7, $14           # get the exception address
        nop
        nop                     # We have to wait for the mfc commands
        nop
        nop
        nop
        andi  $4, 0xff          # mask out the exception code
        srl   $4, $4, 2         # align the exception code
        addi  $5, $0, 12        # $5 = 12
	bne   $4, $5, end	# fail if ExcCodes don't match
	addi  $7, $7, 4         # Point to one past the errant instruction
                                # (to avoid an infinite exception loop)
	addi  $6, $6, 1		# add 1 to test count for successful exception
        jr    $7                # Resume
        rfe
