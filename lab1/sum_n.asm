;-----------------------------------------
; CodeName : Sum of N Natural Numbers 
; Author   : Meet Pragnesh Shah
; Contact  : meetshah1995@ee.iitb.ac.in
;-----------------------------------------
 
ORG 00H

LJMP MAIN

;----------------------------------------
; Subroutine to find sum of first n
; natural numbers and store in 51H onwards
;----------------------------------------
ORG 100H
SUM_N:
	USING 0	; Assembly instruction to indicate usage of Reg Bank 0
    CLR A    ; Clear Acc
	MOV R0,#51H ; Register to Store address
    MOV R2,50H  ; Load R2 with N
    MOV R3,#00H ; Load temp Regsiter with 0
AGAIN: 
	INC R3       ; Increment R3 by 1
    ADD A,R3 ; Adding the Temp Register and Acc
    MOV @R0 ,A   ; move the Value of Acc to desired Adress
    INC R0     ; Incrementing the Address Storage Register     
    DJNZ R2,AGAIN	
	RET

ADDER_8BIT:
    MOV A,50H   ; Move from 50H to Accumulator
    ADD A,60H   ; Adding the data at 60H to Accumulator 
    MOV 70H,A   ; Saving the result in 70H
	
MAIN:
		MOV 50H,#12
		ACALL SUM_N
		END
		