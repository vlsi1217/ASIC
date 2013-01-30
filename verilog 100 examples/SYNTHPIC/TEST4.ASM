			 ;
			 ; MPASM Source code used for testing the Synthetic PIC
			 ;
			 ; TEST4:  Test carry/borrow bit for ADD and SUB instructions
			 ;         You can use MPSIM to see what PIC *should* be doing and
			 ;         then comapre with VHDL simulation.
			 ;
			 list  p=16C54,r=HEX

R10       equ   0x0A
STATUS    equ   0x03

			 org   0x1FF         ; Reset Vector
			 goto  Start         ; Go back to the beginning

			 org   0x000         ; The main line code starts here
Start
			 ; Test basic carry
			 clrf    R10
			 movlw   0x2B        ; W   <= 2B
			 addwf   R10         ; R10 <= 2B, C should be 0
			 addwf   R10         ; add 2b, R10 <= 56, C should be 0
			 addwf   R10         ; add 2b, R10 <= 81, C should be 0
			 addwf   R10         ; add 2b, R10 <= AC, C should be 0
			 addwf   R10         ; add 2b, R10 <= D7, C should be 0
			 addwf   R10         ; add 2b, R10 <= 02, C should be 1
			 addwf   R10         ; add 2b, R10 <= 2D, C should be 0

			 ; Test basic borrow
			 bsf     STATUS, 0   ; Set borrow bit,    C should be 1
			 clrf    R10         ; R10 <= 00
			 decf    R10         ; R10 <= FF
			 movlw   0x2B        ; W   <= 2B
			 subwf   R10         ; sub 2b, R10 <= D4, C should be 1
			 subwf   R10         ; sub 2b, R10 <= A9, C should be 1
			 subwf   R10         ; sub 2b, R10 <= 7E, C should be 1
			 subwf   R10         ; sub 2b, R10 <= 53, C should be 1
			 subwf   R10         ; sub 2b, R10 <= 28, C should be 1
			 subwf   R10         ; sub 2b, R10 <= FD, C should be 0
			 subwf   R10         ; sub 2b, R10 <= D2, C should be 1
done
			 goto    done
			 end
