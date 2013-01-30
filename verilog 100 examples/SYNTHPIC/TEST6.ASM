			 ;
			 ; MPASM Source code used for testing the Synthetic PIC
			 ;
			 ; TEST6:  Use PortA and Port B.
			 ;         PortA has been configured as an Input and
			 ;         PortB is an output.  This is something you
			 ;         do in the VHDL itself, not with TRIS.
			 ;
			 ;         This is an UP/DOWN counter that has an enable and
          ;         a direction bit.
			 ;
			 list  p=16C54,r=DECIMAL
R10       equ     10
PortA     equ      5
PortB     equ      6

			 org     0x3FF       ; Reset Vector
			 goto    Start       ; Go back to the beginning

			 org     0x000       ; The main line code starts here
Start:	 clrf    R10         ;
Loop:		 btfss   PortA, 1    ; Test PA1 which is ENABLE
			 goto    Loop        ; PA1 is 0, so don't do anything.
			 btfss   PortA, 0    ; Test PA0.  If 1 then Count UP, else DOWN
			 goto    Down
			 goto    Up
Down:     decf    R10
			 goto    Output
Up:       incf    R10
Output:	 movf    R10, W
			 movwf   PortB
			 goto    Loop
			 end
