			 ;
			 ; MPASM Source code used for testing the Synthetic PIC
			 ;
			 ; TEST1:  Test basic data operations.
			 ;         You can use MPSIM to see what PIC *should* be doing and
			 ;         then comapre with VHDL simulation.
			 ;
			 list  p=16C54,r=HEX

R10	    equ   0x0A
R11	    equ   0x0B
R12	    equ   0x0C

			 org   0x1FF         ; Reset Vector
			 goto  Start         ; Go back to the beginning

			 org   0x000         ; The main line code starts here
			 Start
										;
										;
			 clrf    R10         ;
			 clrf    R11         ;
			 clrf    R12         ;
			 movlw   0xAA        ;
			 andlw   0xF0        ;
			 iorlw   0x0A        ;
			 xorlw   0xA5        ;
			 andlw   0xF0        ;
			 movlw   0x33        ;
			 movwf   R12         ;
			 clrw                ;
			 movf    R12, W      ;
			 movwf   R11         ;
			 comf    R11         ;
			 movf    R11, W      ;
			 incf    R10         ;
			 decf    R12         ;
			 movlw   0x07        ;
			 iorwf   R12         ;
			 movlw   0xF0        ;
			 nop                 ;
			 andwf   R10, W      ;
			 movf    R12, W      ;
			 xorwf   R11         ;
			 addwf   R10, W      ;
			 subwf   R10, W      ;
			 clrf    R12         ;
			 swapf   R10         ;
			 rrf     R10         ;
			 rlf     R10         ;
			 addwf   R11         ;
			 rrf     R11         ;
			 subwf   R11         ;
			 subwf   R11         ;
			 subwf   R11         ;
			 subwf   R11         ;
done
			 goto done
			 end


