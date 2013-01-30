			 ;
			 ; MPASM Source code used for testing the Synthetic PIC
			 ;
			 ; TEST2:  Test of bit setting and clearing,
			 ;         Increment and decrement and skipping
			 ;         You can use MPSIM to see what PIC *should* be doing and
			 ;         then comapre with VHDL simulation.
			 ;
			 list  p=16C54,r=HEX

R10	    equ   0x0A
R11	    equ   0x0B

			 org   0x1FF         ; Reset Vector
			 goto  Start         ; Go back to the beginning

			 org   0x000         ; The main line code starts here
			 Start
										;
										;
			 movlw   0xA5        ;
			 movwf   R10         ;
			 bcf     R10,5       ;
			 bsf     R10,5       ;
			 btfsc   R10,5       ;
			 btfss   R10,5       ;
			 goto    bad         ;
			 movlw   0x03        ;
			 movwf   R10         ;
			 decfsz  R10         ;
			 decfsz  R10, W      ;
			 decfsz  R10         ;
			 decfsz  R10         ;
			 goto    bad         ;
			 movlw   0xFD        ;
			 movwf   R10         ;
			 incfsz  R10         ;
			 incfsz  R10, W      ;
			 incfsz  R10         ;
			 incfsz  R10         ;
			 goto    bad         ;
			 goto    done        ;

			 org     0x18
done
			 goto    done

			 ; Jump here if skips ever act unexpectedly
			 org     0x1C
bad
			 goto    bad
			 end

