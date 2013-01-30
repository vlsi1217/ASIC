;
        LIST    p=16C57 ; PIC16C57 is the target processor


;
; PIC Core Verification Program
;
; BASIC.ASM
;
; Basic Confidence Test.
;
; Output an incrementing pattern to PORTB as each test passes.
; Each test will output its number onto PORTB when it 
; sucessfully completes, e.g. TEST4 will write a H'04'.
; If it detects a failure, it will instead write a H'Fn', 
; e.g. TEST4 will write a H'F4' onto PORTB.  The tests
; will keep running even if an individual test fails.
;
INDF	equ	H'00'	; Magic register that uses INDIRECT register
TIMER0	equ	H'01'	; Timer register
STATUS  equ     H'03'	; STATUS register F3
FSR	equ	H'04'	; INDIRECT Pointer Register
porta   equ     H'05'	; I/O register F5
portb   equ     H'06'	; I/O register F6
portc   equ     H'07'	; I/O register F7
x       equ     H'0A'   ; Our general variable
y       equ     H'0B'   ; Another variable..

CARRY   equ     H'00'	; Carry bit in STATUS register
ZERO    equ     H'02'	; Zero bit in STATUS register
W	equ	H'00'	; W indicator for many instruction (not the address!)

; These are some locations used for the Bank and Indirection tests
varb0	equ	H'1A'	; This is in upper part of Bank0
varb1	equ	H'3A'	; This is in upper part of Bank1
varb2	equ	H'5A'	; This is in upper part of Bank2
varb3	equ	H'7A'	; This is in upper part of Bank3

;
; ************  Start Up Code  **************
start:
	; Set up TRIS registers
	movlw	H'ff'
	tris	porta	; PORTA is Input
	clrw
	tris	portb	; PORTB is Output
	tris	portc	; PORTC is Output
	movwf	portb		; PORTB <= 00

	; Start at begining...
	goto	test1

; *** TEST1 ***
; Test increment and decrement
test1:
	movlw	H'FD'		; W <= FD
	movwf	x		; X <= FD
	incf	x, f		; X <= FE
	incf	x, f		; X <= FF
	incf	x, f		; X <= 00
	incf	x, f		; X <= 01
	decf	x, f		; X <= 00
	decf	x, f		; X <= FF
	decf	x, f		; X <= FE
	movf	x, W		; W <= FE
	xorlw	H'FE'		; Does W == FE?
	btfss	STATUS, ZERO
	goto	fail1
	goto	pass1
fail1	movlw	H'F1'
	movwf	portb		; PORTB <= F1
	goto	test2	
pass1	movlw	H'01'
	movwf	portb		; PORTB <= 01
	goto	test2	

; *** TEST2 ***
; Test Add and Subtract
test2:
	clrf	x		; x <= 0
	movlw	H'A0'		; w <= A0
	addwf	x, f		; x <= A0
	addwf	x, f		; x <= 40
	btfss	STATUS, CARRY	; carry should be set, if not then FAIL
	goto	fail2
	addwf	x, f		; x <= E0
	btfsc	STATUS, CARRY	; carry should be clear, if not then FAIL
	goto	fail2
	movf	x, W		; W <= E0
	xorlw	H'E0'		; Does W == E0?
	btfss	STATUS, ZERO
	goto	fail2

	movlw	H'30'
	subwf	x, f		; x <= B0
	subwf	x, f		; x <= 80
	btfss	STATUS, CARRY	; borrow should be clear, if not then FAIL
	goto	fail2
	subwf	x, f		; x <= 50
	subwf	x, f		; x <= 20
	subwf	x, f		; x <= F0
	btfsc	STATUS, CARRY	; borrow should be set, if not then FAIL
	goto	fail2
	movf	x, W		; W <= F0
	xorlw	H'F0'		; Does W == F0?
	btfss	STATUS, ZERO
	goto	fail2
	goto	pass2
fail2	movlw	H'F2'
	movwf	portb		; PORTB <= F2
	goto	test3	
pass2	movlw	H'02'
	movwf	portb		; PORTB <= 02
	goto	test3	

; *** TEST3 ***
; Test Rotates, start with rrf
test3:	bsf	STATUS, CARRY	; CARRY <= 1
	movlw	H'A0'		; w <= A0
	movwf	x		; x <= A0 (10100000)
	rrf	x, f		; x <= D0 (11010000)
	bsf	STATUS, CARRY	; CARRY <= 1
	rrf	x, f		; x <= E8 (11101000)
	bcf	STATUS, CARRY	; CARRY <= 0
	rrf	x, f		; x <= 74 (01110100)
	bcf	STATUS, CARRY	; CARRY <= 0
	rrf	x, f		; x <= 3A (00111010)
	movf	x, W		; W <= 3A 
	xorlw	H'3A'		; Does W == 3A ?
	btfss	STATUS, ZERO
	goto	fail3
	; Do same sort of thing using rlf
	bsf	STATUS, CARRY	; CARRY <= 1
	movlw	H'A0'		; w <= A0
	movwf	x		; x <= A0 (10100000)
	rlf	x, f		; x <= 41 (01000001)
	bsf	STATUS, CARRY	; CARRY <= 1
	rlf	x, f		; x <= 83 (10000011)
	bcf	STATUS, CARRY	; CARRY <= 0
	rlf	x, f		; x <= 06 (00000110)
	bcf	STATUS, CARRY	; CARRY <= 0
	rlf	x, f		; x <= 0C (00001100)
	movf	x, W		; W <= 0C 
	xorlw	H'0C'		; Does W == 0C ?
	btfss	STATUS, ZERO
	goto	fail3
	goto	pass3
fail3	movlw	H'F3'
	movwf	portb		; PORTB <= F3
	goto	test4	
pass3	movlw	H'03'
	movwf	portb		; PORTB <= 03
	goto	test4	

; *** TEST4 ***
; Test TIMER0
;
; Option is:
;     7       6       5       4       3       2       1       0
; +---------------------------------------------------------------+
; |   x   |   x   |  T0CS |  T0SE |  PSA  |  PS2  |  PS1  |  PS0  |
; +---------------------------------------------------------------+
;    T0CS  -  0: Use chip clock as source, 1: use external pin
;    T0SE  -  Invert input when using external source
;     PSA  -  Set to '0' to use prescaler
; PS2:PS0  -  Divide by 0 up to 7
;
; To use maximum prescaler using internal clock, program
; OPTION register to:
;
; 00000111 = 7
;
test4:	movlw	H'07'		; Set TIMER0 prescaler to ...
	option
	movlw	H'FF'		; W <= FF
	movwf	x		; x <= FF
	clrf	TIMER0
test4loop:
	decf	x, f
	btfss	STATUS, ZERO
	goto	test4loop

	movf	TIMER0, W
	xorlw	H'03'		; Does W == ?
	btfss	STATUS, ZERO
	goto	fail4
	goto	pass4
fail4	movlw	H'F4'
	movwf	portb		; PORTB <= F4
	goto	test5	
pass4	movlw	H'04'
	movwf	portb		; PORTB <= 04
	goto	test5	

; *** TEST5 ***
; Test various logic instructions
test5:	clrf	x		; x <= 00
	movlw	B'00000101'	; W <= 00000101
	iorwf	x, f		; x <= 00000101
	comf	x, f		; x <= 11111010
	movlw	B'1110011'	; W <= 01110011
	andwf	x, f		; x <= 01110010
	movlw	B'11110000'	; W <= 11110000
	xorwf	x, f		; x <= 10000010
	swapf	x, f		; x <= 00101000
	
	; Check results up to now
	movfw	x		; W <= 00101000
	xorlw	B'00101000'	; Does W == 00101000
	btfss	STATUS, ZERO
	goto	fail5

	; Check some bit tests and clears.  Invert
	; all the bits of X which is now: 00101000
	bsf	x, 7
	bsf	x, 6
	bcf	x, 5
	bsf	x, 4
	bcf	x, 3
	bsf	x, 2
	bsf	x, 1
	bsf	x, 0		; x <= 11010111 
	movfw	x		; W <= 11010111
	xorlw	B'11010111'	; Does W == 11010111
	btfss	STATUS, ZERO
	goto	fail5
	goto	pass5

fail5	movlw	H'F5'
	movwf	portb		; PORTB <= F5
	goto	test6
pass5	movlw	H'05'
	movwf	portb		; PORTB <= 05
	goto	test6

; *** TEST6 ***
; Test subroutines
test6:	clrf	x		; x <= 00
	call	sub6c		; x <= 2
	call	sub6c		; x <= 4
	call	sub6c		; x <= 6
	goto	cont6
	
sub6a:	movlw	5		; ** ADD 5 TO X
	addwf	x, f
	retlw	0
sub6b:	movlw	3		; ** SUB 3 FROM X
	subwf	x, f
	retlw	0
sub6c:	call sub6a		; ** ADD 2 TO X (by call others)
	call sub6b		;
	retlw	0

cont6:	movfw	x		; W <= 6
	xorlw	6		; Does W == 6
	btfss	STATUS, ZERO
	goto	fail6
	goto	pass6

fail6	movlw	H'F6'
	movwf	portb		; PORTB <= F6
	goto	test7
pass6	movlw	H'06'
	movwf	portb		; PORTB <= 06
	goto	test7
	
; *** TEST7 ***
; Test Register File Banks and address mapping, and Indirect Addressing.
;
; Write the values 1,2,3 and 4 into 4 different
; registers in each of the 4 banks.  Then, go back and verify.
; This will test bank logic and indirect addressing.
;

test7:	movlw	1		; W <= 1
	movwf	x		; X <= 1

	; Point to a location in upper part of Bank #0
	movlw	varb0	; Get Address
	movwf	FSR	; Set index register
	movf	x,W	; Get the 'x' value
	movwf	INDF	; Write using index
	incf	x,f	; Increment the counter

	; Point to a location in upper part of Bank #1
	movlw	varb1	; Get Address
	movwf	FSR	; Set index register
	movf	x,W	; Get the 'x' value
	movwf	INDF	; Write using index
	incf	x,f	; Increment the counter

	; Point to a location in upper part of Bank #2
	movlw	varb2	; Get Address
	movwf	FSR	; Set index register
	movf	x,W	; Get the 'x' value
	movwf	INDF	; Write using index
	incf	x,f	; Increment the counter

	; Point to a location in upper part of Bank #3
	movlw	varb3	; Get Address
	movwf	FSR	; Set index register
	movf	x,W	; Get the 'x' value
	movwf	INDF	; Write using index
	incf	x,f	; Increment the counter

	; OK.  Go back and read each count and output to PORTB
	movlw	varb0		; Get Address
	movwf	FSR		; Set index register
	movf	INDF,W		; Retrieve the 'x' value to W
	xorlw	H'01'		; Should be 1
	btfss	STATUS, ZERO	; IF yes, keep going
	goto	fail7
	movlw	varb1		; Get Address
	movwf	FSR		; Set index register
	movf	INDF,W		; Retrieve the 'x' value to W
	xorlw	H'02'		; Should be 2
	btfss	STATUS, ZERO	; IF yes, keep going
	goto	fail7
	movlw	varb2		; Get Address
	movwf	FSR		; Set index register
	movf	INDF,W		; Retrieve the 'x' value to W
	xorlw	H'03'		; Should be 3
	btfss	STATUS, ZERO	; IF yes, keep going
	goto	fail7
	movlw	varb3		; Get Address
	movwf	FSR		; Set index register
	movf	INDF,W		; Retrieve the 'x' value to W
	xorlw	H'04'		; Should be 4
	btfss	STATUS, ZERO	; IF yes, keep going
	goto	fail7

	goto	pass7

fail7	movlw	0F7h
	movwf	portb		; PORTB <= F7
	goto	test8
pass7	movlw	007h
	movwf	portb		; PORTB <= 07
	goto	test8

; *** TEST8 ***
; Quick test of PORTA input with PORTC
;
; Expect the repeating patter of H'55' and H'AA' on PORTA.
; Those inputs should remain on input for at least a dozen cycles.
; Code waits until both values are seen.  Also use TIMER0 so
; that we do not hang.  Timeout if nothing is seen after, say, about
; 64 cycles.
	
test8:	movlw	H'07'		; Set TIMER0 prescaler to ...
	option
	clrf	TIMER0

	; Look for H'55' first...
test8scan1:
	movf	porta, W	; Read PORTA
	xorlw	H'55'		; Is it H'55'?
	btfsc	STATUS, ZERO
	goto	test8scan2	; Saw the H'55'!
	movf	TIMER0,W	; Check the timer
	xorlw	H'02'
	btfsc	STATUS, ZERO
	goto	fail8		; Timeout  :-(
	goto	test8scan1	; Keep scanning

	; Now look for H'AA'...
test8scan2:
	movf	porta, W	; Read PORTA
	xorlw	H'AA'		; Is it H'AA'?
	btfsc	STATUS, ZERO
	goto	pass8		; Saw the H'AA'!
	movf	TIMER0,W	; Check the timer
	xorlw	H'04'
	btfsc	STATUS, ZERO
	goto	fail8		; Timeout  :-(
	goto	test8scan2	; Keep looking

fail8	movlw	H'F8'
	movwf	portb		; PORTB <= F8
	goto	test9
pass8	movlw	H'08'
	movwf	portb		; PORTB <= 08
	goto	test9

test9:
done:	goto	done		; Spin forever..
	
; *** End of main code, place start vector ***
        org     D'2047'
        goto    start
;
    END


