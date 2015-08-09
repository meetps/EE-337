ORG 0000H

LJMP MAIN

ORG 100H

;-----------------------------------------
; Sub Routine to generate delay of (d/2)s
;-----------------------------------------
delay :
USING 0
PUSH AR3
PUSH AR4
PUSH AR5
CLR A
MOV A,4AH ; get D from 4FH
MOV B,#0AH
MUL AB ; Mul by 10 as (d/2)s = 50*Dms     
MOV R3,A  ; Mov the loop parameter to R3
delayLoop : ; write loop to last d/2 seconds 
			MOV R4,#200
			BACK1:
			MOV R5,#0FFH	
			BACK :
			DJNZ R5, BACK
			DJNZ R4, BACK1
			DJNZ R3, delayLoop
POP AR3
POP AR4
POP AR5
RET

MAIN :

MOV 04FH,#02H
HERE: 
			CLR P1.4
			LCALL delay
			SETB P1.4
			LCALL delay
			SJMP HERE 
END