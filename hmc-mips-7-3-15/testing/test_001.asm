# Harvey Mudd College VLSI MIPS Project
# Carl Nygaard
# Spring, 2007
#
# Test 001
#
# Created: 12/24/06
#
# Commands tested:
#   add, sub, and, or, slt, addi, lw, sw, beq, j
#
# Expected Behavior:
# If successful, it should write the value 7 to address 84
#
# Notes:
# Original code by
# David_Harris@hmc.edu 9 November 2005 
#
# npinckney@hmc.edu 9 February 2007 - Modified write addresses to not interfere with instructions.

.set noreorder

main:   addi $2, $0, 5          # initialize $2 = 5           20020005
        addi $3, $0, 12         # initialize $3 = 12          2003000c
        addi $7, $3, -9         # initialize $7 = 3           2067fff7
        or   $4, $7, $2         # $4 <= 3 or 5 = 7            00e22025
        and  $5, $3, $4         # $5 <= 12 and 7 = 4          00642824
        add  $5, $5, $4         # $5 = 4 + 7 = 11             00a42820
        beq  $5, $7, end        # shouldn't be taken          10a7000a
        nop                     # Avoid branch delay slot     00000000
        slt  $4, $3, $4         # $4 = 12 < 7 = 0             0064202a
        beq  $4, $0, around     # should be taken             10800003
        nop                     # Avoid branch slot           00000000
        addi $5, $0, 0          # shouldn't happen            20050000
around: slt  $4, $7, $2         # $4 = 3 < 5 = 1              00e2202a
        add  $7, $4, $5         # $7 = 1 + 11 = 12            00853820
        sub  $7, $7, $2         # $7 = 12 - 5 = 7             00e23822
        sw   $7, 500($3)         # [512] = 7                    ac670044
        lw   $2, 512($0)         # $2 = [512] = 7               8c020050
        j    end                # should be taken             08000014
        nop                     # Avoid branch slot           00000000
        addi $2, $0, 1          # shouldn't happen            20020001
end:    sw   $2, 516($0)         # write adr 516 = 7            ac020054
loop:   beq  $0, $0, loop       # loop forever                10000000
        nop                     # Avoid branch slot           00000000
