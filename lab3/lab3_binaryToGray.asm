ORG 0000H

LJMP MAIN

ORG 100H

;-----------------------------------------
; Sub Routine to convert bin2gray and display
;-----------------------------------------
bin2gray:
	USING 0
	PUSH AR1
	MOV A,P1 		;Read from port
	SWAP A  		;SWAP nibbles
	ANL A,#0F0H		;AND with 11110000 to remove lwr nibble
	MOV R1,A
	RR A
	ANL A,#0F0H
	XRL A,R1
	ANL A,#0F0H
	MOV P1,#00H
	MOV P1,A
	POP AR1
RET

MAIN :
MOV P1,#0FH
LCALL bin2gray ;calling the routine
END


