# Harvey Mudd College VLSI MIPS Project
# Matt Totino
# Spring, 2007
#
# Test 014
#
# Created: 1/28/07
#
#   Tests overflow limits

.set noreorder

# Start code 0x1FC00000
main:   addi  $6, $0, 0		# start overflow count at 0
	lui   $2, 0x8000        # $2 = 0x80000000 (largest negative number)
        addi  $3, $0, -1        # $3 = -1
	lui   $8, 0x7FFF	# (setting up operands)
	addi  $8, $8, 0x7FFF	# 
	addi  $8, $8, 0x7FFF	# 
	addi  $8, $8, 1		# $8 = 0x7FFFFFFF (largest positive number)
	addi  $9, $0, 1		# $9 = 1
				# done setting up operands 

				# test addi
        addi  $4, $2, -1        # $4 = 0x80000000 - 1 (cause overflow exception)
                                # exceptions = 1
	addi  $4, $8, 1         # $4 = 0x7FFFFFFF + 1 (cause overflow exception)
                                # exceptions = 2
	addi  $4, $3, 1	  	# $4 = -1 + 1 = 0 (ok)

				# test add
	add   $4, $2, $3	# $4 = 0x80000000 - 1 (cause overflow exception)
                                # exceptions = 3
	add   $4, $8, $9	# $4 = 0x7FFFFFFF + 1 (cause overflow exception)
  				# exceptions = 4
	add   $4, $3, $9  	# $4 = -1 + 1 = 0 (ok)

				# test sub
	sub   $4, $2, $9	# $4 = 0x80000000 - 1 (cause overflow exception)
				# exceptions = 5
	sub   $4, $8, $3	# $4 = 0x7FFFFFFF -(-1) (cause overflow exception)
				# exceptions = 6
	sub   $4, $3, $9	# $4 = -1 - 1 (ok)

				# test addu
	addu  $4, $3, $9	# $4 = 0xFFFFFFFF + 1 (ok)
				# test subu
	subu  $4, $0, $8	# $4 = 0 - 1 (ok)
				# test addiu
	addiu $4, $3, 1		# $4 = 0xFFFFFFFF + 1 (ok)
	nop

        sw    $6, 4($0)         # should write #overflows (6) to address 0x4
end:    beq   $0, $0, end       # loop forever
        nop

nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop
nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop
nop;nop;

# Start exception code at 0x1FC00100 (0x100 compiled) at the earliest
except: mfc0  $4, $13           # get the cause register
        mfc0  $7, $14           # get the exception address
	nop
        andi  $4, 0xff          # mask out the exception code
        srl   $4, $4, 2         # align the exception code
        addi  $5, $0, 12        # $5 = 12
	bne   $4, $5, end	# fail if exception code is not 12

	addi  $7, $7, 4         # Point to one past the errant instruction
                                # (to avoid an infinite exception loop)
	addi  $6, $6, 1		# add 1 to overflow count
        nop
        nop # something is weird here, so adding nops
        nop
        nop
        nop
        jr    $7                # Resume
        rfe                     # BDS
