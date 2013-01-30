			 ;
			 ; MPASM Source code used for testing the Synthetic PIC
			 ;
			 ; TEST5:  Test of PC and Instruction fetch cycle
			 ;
			 list  p=16C54,r=DECIMAL
R10       equ   10

			 org     0x1FF       ; Reset Vector
			 goto    Start       ; Go back to the beginning

			 org     0x000       ; The main line code starts here
Start:	 movlw   5           ;
			 movwf   R10         ;
Loop:		 movlw   3
			 movlw   4
			 movlw   5
			 decfsz  R10         ;
			 goto    Loop        ;
			 movlw   6        ;
			 movlw   7        ;
			 movlw   8        ;
			 goto    done        ;
			 org     0x18
done
			 goto    done
			 end
