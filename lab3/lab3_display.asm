ORG 0000H

LJMP MAIN

ORG 100H

;-----------------------------------------
; Sub Routine to generate delay of (d/2)s
;-----------------------------------------
delay :
CLR A
MOV A,4FH ; get D from 4FH
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
RET

;-----------------------------------------
; Sub Routine to display LSB to P1
;-----------------------------------------
display :
USING 0
PUSH AR1
PUSH AR0
MOV R1,50H	  ; read fron 50H
MOV R0,51H    ; read from 51H
readLoop : MOV A,@R0 ; read from P to P+N -1 
           SWAP A
		   ANL A,#0F0H
		   MOV P1,A  ; display last 4 bits
           ;MOV 4FH,#02 ; Setting D =2 for 1s delay
		   LCALL delay      ; delay 1s
		   INC R0
		   DJNZ R1, readLoop
POP AR1
POP AR0
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

MOV 50H,#07;------------------------N memory locations of Array B
MOV 51H,#60H;------------------------Array B start location
MOV 4FH,#02H;------------------------User defined delay value
LCALL display;----------------------Display the last four bits of elements on LEDs
END