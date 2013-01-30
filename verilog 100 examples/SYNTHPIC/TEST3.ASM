			 ;
			 ; MPASM Source code used for testing the Synthetic PIC
			 ;
			 ; TEST3:  Test of Subroutine calling.
			 ;         You can use MPSIM to see what PIC *should* be doing and
			 ;         then comapre with VHDL simulation.
			 ;
			 list  p=16C54,r=HEX

R10       equ   0x0A

			 org   0x1FF         ; Reset Vector
			 goto  Start         ; Go back to the beginning

			 org   0x000         ; The main line code starts here
Start

			 movlw   0x05        ;
			 movwf   R10         ; R10 should be 0x05
			 call    plus3       ; R10 should be 0x08, W should be 0x33
			 call    plus3       ; R10 should be 0x0B, W should be 0x33
			 call    plus6       ; R10 should be 0x11, W should be 0x66
			 goto    Start       ;

			 ; one call to this function should add 3 to R10
			 org     0x10
plus3
			 movlw   3
			 addwf   R10
			 retlw   0x33


			 ; This subroutine calls plus3, so it tests depth
			 org     0x14
plus6
			 call    plus3       ;
			 call    plus3       ;
			 retlw   0x66

			 end

