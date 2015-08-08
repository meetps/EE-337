ORG 0000H

LJMP MAIN

ORG 100H

;-----------------------------------------
; Sub Routine to erase sonsecutive memory
;-----------------------------------------
zeroOut :
USING 0
PUSH AR0
PUSH AR1

MOV R1, 50H   ; read fron 50H 
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