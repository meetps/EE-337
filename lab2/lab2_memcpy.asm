ORG 0000H

LJMP MAIN

ORG 100H

;-----------------------------------------
; Sub Routine to copy cons. memory units
;-----------------------------------------
memcpy :
USING 0
PUSH AR0
PUSH AR1
PUSH AR2
PUSH AR3

MOV R0, 51H		; read A from 51H
MOV R1, 52H		; read B from 52H
MOV R2, 50H		; read N from 50H
CLR C
MOV A,R0
SUBB A,R1

JC overlapCopy

copyLoop :      ; copy N locations consecutively from A to B
		   MOV A,@R0
		   MOV @R1,A
		   INC R0
		   INC R1
		   DJNZ R2, copyLoop


POP AR0
POP AR1
POP AR2
POP AR3
RET

overlapCopy :
			MOV A,R0
			ADD A,R2
			MOV R0,A
			MOV A,R1
			ADD A,R2
			MOV R1,A
			DEC R1
			DEC R0
overlapCopyLoop :
			MOV A,@R0
		   MOV @R1,A
		   DEC R0
		   DEC R1
		   DJNZ R2, overlapCopyLoop
		   
POP AR0
POP AR1
POP AR2
POP AR3

RET

MAIN :

MOV 60H,#01H
MOV 61H,#02H
MOV 62H,#03H
MOV 63H,#04H
MOV 64H,#05H
MOV 65H,#06H
MOV 66H,#07H
MOV 67H,#08H

MOV 50H,#08;------------------------N elements of Array A to be copied in Array B
MOV 51H,#60H;------------------------Array A start location
MOV 52H,#5AH;------------------------Array B start location
LCALL memcpy;-----------------------Copy block of memory to other location
END


