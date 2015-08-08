ORG 0000H

LJMP MAIN

ORG 100H

;----------------------------------------
; Routine to read in Port lines P1.3 - P1.0 as a sngle nibble
; Returns the nibble in lower 4 bits of the register A
;
; Ensure that the internal port latches are set high already 
; prior to calling this routine
;-----------------------------------------
readNibble:
	MOV A,P1			; read port lines P1.3 - P1.0 where slide switches are connected
	ANL A,#0FH			; retain lower nibble and mask off upper one
	RET					; Return to caller with nibble in A

;-----------------------------------------
; Sub Routine to erase sonsecutive memory
;-----------------------------------------
zeroOut :
	USING 0
	PUSH AR0
	PUSH AR1
	LCALL readNibble
	MOV R1,A 	
	MOV R0, 51H   ; read from 51H
	eraseLoop : MOV @R0,#00H  ; clear from P to P + N -1
				INC R0        ; increment R2
				DJNZ R1, eraseLoop ; repeat until N

	POP AR0
	POP AR1
	RET


MAIN :

MOV 60H,#01H
MOV 61H,#01H
MOV 62H,#01H
MOV 63H,#01H
MOV 64H,#01H
MOV 65H,#01H
MOV 66H,#01H
MOV 67H,#01H

MOV 50H,#07;------------------------N memory locations of Array A
MOV 51H,#60H;------------------------Array A start location
LCALL zeroOut;----------------------Clear memory
END