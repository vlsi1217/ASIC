# Harvey Mudd College VLSI MIPS Project
# Matt Totino
# Spring, 2007
#
# Test 019
#
# Created: 2/10/07
#
#   Tests corner cases for conditional branches

.set noreorder

# Start code 0x1FC00000
main:   addi  $4, $0, 0xF	# start "counter" at F - it shouldn't change
	addi  $3, $0, -1	# $3 = -1
        addi  $2, $0, 1         # $2 = 1
				# test beq
	beq   $0, $0, aa	# jumps to aa
	nop			# filling all BDS with nops
	addi  $4, $4, 1		# increment counter - shouldn't happen
aa:	beq   $0, $2, end	# does not jump (would go to end and fail)
	nop
				# test bltz
	bltz  $3, bb		# jump
	nop
	addi  $4, $4, 1		# increment counter - shouldn't happen
bb:	bltz  $0, end		# dnj
	nop
				# test bgez
	bgez  $0, cc		# jump
	nop
	addi  $4, $4, 1		# increment counter - shouldn't happen
cc:	bgez  $3, end		# dnj
	nop
				# test bne
	bne   $0, $2, dd	# jump
	nop
	addi  $4, $4, 1		# increment counter - shouldn't happen
dd:	bne   $0, $0, end	# dnj
	nop
				# test blez
	blez  $0, ee		# jump
	nop
	addi  $4, $4, 1		# increment counter - shouldn't happen
ee:	blez  $2, end		# dnj
	nop
				# test bgtz
	bgtz  $2, ff		# jump
	nop
	addi  $4, $4, 1		# increment counter - shouldn't happen
ff:	bgtz  $0, end		# dnj
	nop
				# test bltzal
	bltzal $3, gg		# jump
	nop
	addi  $4, $4, 1		# increment counter - shouldn't happen
gg:	bltzal $0, end		# dnj
	nop
				# test bgezal
	bgezal $0, hh		# jump
	nop
	addi  $4, $4, 1		# increment counter - shouldn't happen
hh:	bgezal $3, end		# dnj
	nop
	nop
	nop

        sw    $4, 4($0)         # should write 0xF to address 0x4
end:    beq   $0, $0, end       # loop forever
        nop
	nop



