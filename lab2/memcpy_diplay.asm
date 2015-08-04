;-----------------------------------------
; CodeName : Memory Copy and Port Display 
; Author   : Meet Pragnesh Shah
; Contact  : meetshah1995@ee.iitb.ac.in
;-----------------------------------------

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
; Sub Routine to erase sonsecutive memory
;-----------------------------------------
zeroOut :
MOV R1, 50H   ; read fron 50H 
MOV R0, 51H   ; read from 51H
eraseLoop : MOV @R0,#00H  ; clear from P to P + N -1
			INC R0        ; increment R2
			DJNZ R1, eraseLoop ; repeat until N
RET


;-----------------------------------------
; Sub Routine to display LSB to P1
;-----------------------------------------
display :
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
RET


;-----------------------------------------
; Sub Routine to store squareSum to memory
;-----------------------------------------
sumOfSquares :
MOV R0,51H    ; read P from 51H
MOV R2,50H	  ; read N fron 50H
MOV R3,#01H
MOV @R0,#01
DEC R2
; get sumOfSquares till i 
squareStoreLoop :
		   CLR A
		   INC R3
		   MOV A,R3
		   MOV B,R3
		   MUL AB
		   MOV R4,A
		   MOV A,@R0
		   ADD A,R4
		   INC R0
		   MOV @R0,A ; store in i from P to P + N -1
		   DJNZ R2, squareStoreLoop
RET
; LabWork 



;-----------------------------------------
; Sub Routine to copy cons. memory units
;-----------------------------------------
memcpy :
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
RET

;-----------------------------------------
; Main 
;-----------------------------------------
MAIN:
MOV SP,#0CFH;-----------------------Initialize STACK POINTER
MOV 50H,#08;------------------------N memory locations of Array A
MOV 51H,#70H;------------------------Array A start location
LCALL zeroOut;----------------------Clear memory
MOV 50H,#08;------------------------N memory locations of Array B
MOV 51H,#60H;------------------------Array B start location
LCALL zeroOut;----------------------Clear memory
MOV 50H,#08;------------------------N memory locations of Array A
MOV 51H,#70H;------------------------Array A start location
LCALL sumOfSquares;-----------------Write at memory location
MOV 50H,#08;------------------------N elements of Array A to be copied in Array B
MOV 51H,#70H;------------------------Array A start location
MOV 52H,#60H;------------------------Array B start location
LCALL memcpy;-----------------------Copy block of memory to other location
MOV 50H,#08;------------------------N memory locations of Array B
MOV 51H,#60H;------------------------Array B start location
MOV 4FH,#03H;------------------------User defined delay value
LCALL display;----------------------Display the last four bits of elements on LEDs
;here:SJMP here;---------------------WHILE loop(Infinite Loop)
END
;------------------------------------END MAIN------------------------------------------- 