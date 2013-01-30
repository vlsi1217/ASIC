;
        LIST    p=16C57 ; PIC16C57 is the target processor


;
; Free-RISC8 Demo Program
;
; DDS.ASM
;
; DDS Demo.  This program goes with the Risc8 demo where
; the EXPDDS.V is used, which is a little DDS.  When this
; expansion circuit is bolted in, this program will output
; a couple of bytes worth of bits to the DDS.  This is an
; FSK type of scheme.
;
; Don't take this demo too seriously.. This is not intended
; to be a workable FSK circuit, but just a fun demo illustrating
; the expansion capability.
;
; To use, try the following:
;    - Make sure your Verilog command line is using the DDS
;      expansion circuit.
;    - Make sure the testbench is selecting this version of
;      the machine code (just look at the main block to see
;      which task is called for the test).
;    - Run the simulation.  In a waveform viewer, look at DDS
;      output.  View it as ANALOG and you'll see the modulated
;      sine wave.  Also, look at PORTC to see the actual bits.
;
;
INDF	equ	H'00'	; Magic register that uses INDIRECT register
TIMER0	equ	H'01'	; Timer register
STATUS  equ     H'03'	; STATUS register F3
FSR	equ	H'04'	; INDIRECT Pointer Register
porta   equ     H'05'	; I/O register F5
portb   equ     H'06'	; I/O register F6
portc   equ     H'07'	; I/O register F7
DDSCTL  equ     H'7E'   ; DDS Control Register.
DDSSTEP equ     H'7F'   ; DDS Step Register.

CARRY   equ     H'00'	; Carry bit in STATUS register
ZERO    equ     H'02'	; Zero bit in STATUS register
W	equ	H'00'	; W indicator for many instruction (not the address!)

; *** DDS Variables
databyte	equ	H'08'	; Used for the data byte being sent.
cnt		equ	H'09'	; Scratch counter
baud_next	equ	H'0A'	; Next value of TIMER0 for next bit

; *** CONSTANTS ***
baud_dly	equ	H'07'	; Delay for baud timing

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

	; Set up TIMER0 as our BAUD clock
	movlw	H'03'
	option

	; Clear TIMER0, Set first baud next time
	clrf	TIMER0
	movlw	baud_dly
	movwf	baud_next

	; Enable DDS
	movlw	DDSCTL
	movwf	FSR
	movlw	H'01'
	movwf	INDF

	; Just output 3 constant bytes for now..
	movlw	H'AA'
	call	outbyte
	movlw	H'01'
	call	outbyte
	movlw	H'55'
	call	outbyte

	; That's it for this little demo!
	goto	done

outbyte:
	; Input byte is in W register
	;
	movwf	databyte	; Move W to 'a'
	movlw	8		; Output 8 bits
	movwf	cnt

outbyte_loop:

	; Always wait for next BAUD time.
	; Use TIMER0
outbyte_wait:
	movf	baud_next, W
	xorwf	TIMER0,W
	btfss	STATUS, ZERO
	goto	outbyte_wait

	; OK.  Time for another symbol.
	; Increment out 'next_baud' by the baud_delay value
	; for the next time, and then proceed to output the bit.
	;
	movlw	baud_dly
	addwf	baud_next,f
	
	; Rotate LSB into CARRY, and output
	bcf	portc, 1	; Just for debug
	bsf	portc, 1	; Just for debug
	bcf	portc, 1	; Just for debug
	rrf	databyte,f
	btfss	STATUS, CARRY
	goto	outbyte_0
	goto	outbyte_1
outbyte_0:
	call	outspace
	goto	outbyte_next
outbyte_1:
	call	outmark
	goto	outbyte_next

	; OK.  See if we're done.
outbyte_next:
	decfsz	cnt,f		; Decrement counter, we're done if zero.
	goto	outbyte_loop
	; We're done!
	retlw	0

; OUTPUT a SPACE, which is a particular frequency for the DDS	
;
outspace:
	movlw	DDSSTEP
	movwf	FSR
	movlw	H'09'
	movwf	INDF
	bcf	portc, 0	; Just for debug
	retlw	0

; OUTPUT a MARK, which is a particular frequency for the DDS	
;
outmark:
	movlw	DDSSTEP
	movwf	FSR
	movlw	H'0E'
	movwf	INDF
	bsf	portc, 0	; Just for debug
	retlw	0

done:	goto	done		; Spin forever..
	
; *** End of main code, place start vector ***
        org     D'2047'
        goto    start
;
    END


