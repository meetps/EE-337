;-----------------------------------------
; CodeName : Memory Copy and Port Display 
; Author   : Meet Pragnesh Shah
; Contact  : meetshah1995@ee.iitb.ac.in
;-----------------------------------------

;-----------------------------------------
; Sub Routine to generate delay of (d/2)s
;-----------------------------------------
delay :
CLR A
MOV A,4FH ; get D from 4FH
MUL A,#10 ; Mul by 10 as (d/2)s = 50*Dms     
MOV R3,A  ; Mov the loop parameter to R3
delayLoop : ; write loop to last d/2 seconds 
			MOV R2,#200
			BACK1:
			MOV R1,#0FFH	
			BACK :
			DJNZ R1, BACK
			DJNZ R2, BACK1
			DJNZ R3, delayLoop
RET

zeroOut :
MOV R1, 50H   ; read fron 50H 
MOV R2, 51H   ; read from 51H
eraseLoop : MOV @R2,#00H  ; clear from P to P + N -1
			INC R2        ; increment R2
			DJNZ R1, eraseLoop ; repeat until N

display :
MOV R1,50H	  ; read fron 50H
MOV R2,51H    ; read from 51H
readLoop : MOV R3,@R2 ; read from P to P+N -1 
           MOV P1,R3  ; display last 4 bits
           CLR P1.0
           CLR P1.1
           CLR P1.2
           CLR P1.3
           MOV 4FH,#02 ; Setting D =2 for 1s delay
		   delay      ; delay 1s
		   INC R2
		   DJNZ R1, readLoop
RET

sumOfSquares :
MOV R1,50H	  ; read N fron 50H
MOV R2,51H    ; read P from 51H
MOV R3,#01  
; get sumOfSquares till i 
squareStoreLoop :
		   CLR A
		   MOV A,R3
		   MUl A,R3
		   MOV R3,A
		   MOV A,R2
		   ADD A,R3
		   MOV @R2,A ; store in i from P to P + N -1
		   INC R3
		   INC R2
		   DJNZ R1, squareStoreLoop
RET

; LabWork 

memcpy :
MOV R1, 50H		; read N from 50H
MOV R2, 51H		; read A from 51H
MOV R3, 52H		; read B from 52H
copyLoop :      ; copy N locations consecutively from A to B
		   MOV A,@R2
		   MOV @R3,A
		   INC R2
		   INC R3
		   DJNZ R1, memcpy

;main_lab :
; zerOut(A)
; zerOut(B)
; sumOfSquares(A)
; memcpy(A,B)
; dsiplay(B)

; return


ORG 0XXXH
MAIN:
MOV SP,#0CFH;-----------------------Initialize STACK POINTER
MOV 50H,#XX;------------------------N memory locations of Array A
MOV 51H,#XX;------------------------Array A start location
LCALL zeroOut;----------------------Clear memory
MOV 50H,#XX;------------------------N memory locations of Array B
MOV 51H,#XX;------------------------Array B start location
LCALL zeroOut;----------------------Clear memory
MOV 50H,#XX;------------------------N memory locations of Array A
MOV 51H,#XX;------------------------Array A start location
LCALL sumOfSquares;-----------------Write at memory location
MOV 50H,#XX;------------------------N elements of Array A to be copied in Array B
MOV 51H,#XX;------------------------Array A start location
MOV 52H,#XX;------------------------Array B start location
LCALL memcpy;-----------------------Copy block of memory to other location
MOV 50H,#XX;------------------------N memory locations of Array B
MOV 51H,#XX;------------------------Array B start location
MOV 4FH,#XX;------------------------User defined delay value
LCALL display;----------------------Display the last four bits of elements on LEDs
here:SJMP here;---------------------WHILE loop(Infinite Loop)
END
;------------------------------------END MAIN------------------------------------------- 