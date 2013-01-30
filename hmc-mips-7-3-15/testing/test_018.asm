# Harvey Mudd College VLSI MIPS Project
# Matt Totino
# Spring, 2007
#
# Test 018
#
# Created: 2/9/07
#
#   Test exceptions for bad fetch addresses (ie bad PC jumps)
#   Sucessfully corrects misaligned PC but doesn't 
#   prevent silly (misaligned) jumps (I don't think the HW exists for that)

.set noreorder

# Start code 0x1FC00000
main:   addi  $6, $0, 0		# start overflow count at 0
	lui   $4, 0xbfc0	# sets up base address		
        addi  $3, $4, 0x0013	# $3 = 0x0013 
        jr    $3		# jump PC to (not valid)
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

        sw    $6, 4($0)         # should write #exceptions (1) to address 0x4           
end:    beq   $0, $0, end       # loop forever
        nop

nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop
nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop
nop;nop;nop;nop;nop;nop

# Start exception code at 0x1FC00100 (0x100 compiled) at the earliest
except: mfc0  $4, $13           # get the cause register
        mfc0  $7, $14           # get the exception address
        andi  $4, 0xff          # mask out the exception code
        srl   $4, $4, 2         # align the exception code

	addi  $7, $7, 4         # Point to one past the errant instruction
                                # (to avoid an infinite exception loop)
	addi  $6, $6, 1		# add 1 to exception count
	lui   $5, 0xffff	# create upper mask
	addi  $5, 0xfffc	# finish mask
	and   $7, $7, $5	# zeros lowest 2 bits of $7
				# PC should now properly be a multiple of 4
        nop
        nop # something is weird here, so adding nops
        nop
        nop
        nop
	nop
	nop
        nop
        jr    $7                # Resume
        rfe                     # BDS
