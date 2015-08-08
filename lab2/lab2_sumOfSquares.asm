ORG 0000H

LJMP MAIN

ORG 100H

;-----------------------------------------
; Sub Routine to store squareSum to memory
;-----------------------------------------
sumOfSquares :
USING 0
PUSH AR0
PUSH AR1
PUSH AR2
PUSH AR3

MOV R0,51H    ; read P from 51H
MOV R2,50H	  ; read N fron 50H
MOV R3,#01H
MOV @R0,#01
DEC R2
; get sumOfSquares till i < N using Dynamic Programming
squareStoreLoop :
		   CLR A			;Clearing A
		   INC R3			;Increasing i
		   MOV A,R3		
		   MOV B,R3		
		   MUL AB			;Squaring i
		   MOV R4,A		;Moving Sqaure to R4
		   MOV A,@R0  ;Moving Previous Sum to A 
		   ADD A,R4       
		   INC R0
		   MOV @R0,A  ;store in i from P to P + N -1
		   DJNZ R2, squareStoreLoop
POP AR0
POP AR1
POP AR2
POP AR3

RET

MAIN :
MOV 50H,#08;------------------------N memory locations of Array A
MOV 51H,#60H;------------------------Array A start location
LCALL sumOfSquares;-----------------Write at memory location
END