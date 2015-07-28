;-----------------------------------------
; CodeName : 16 bit 2's complement adder 
; Author   : Meet Pragnesh Shah
; Contact  : meetshah1995@ee.iitb.ac.in
;-----------------------------------------
 
ORG 0000H

LJMP MAIN


;----------------------------------------
; 2's Complement 16 bit addition
;----------------------------------------


;R0 and R1 should contain the address of two no.s
;location given by R0:- 	MSB of 1st no.
;location given by R0+1:-	LSB of 1st no.
;location given by R1:- 	MSB of 1st no.
;location given by R1+1:-	LSB of 1st no.
;location given by R0+2:- 	CARRY	
;location given by R0+3:-	MSB OF ANS	
;location given by R0+4:- 	LSB OF ANS


ORG 100H
ADDER_16BIT:
	CLR C
	MOV A,61H ;-- push the registers which will be affected by this subroutine 
	SUBB A,71H
	MOV 64H,A
	MOV A,60H
	SUBB A,70H ;	but will be needed later 	
	MOV 63H,A
	JB PSW.2 , RETURN
	RET
	;-- perform the addition/subtraction of 2 16-bit no.s
	;-- you may use subroutine wrtten for addition of 2 8-bit no.s
	;-- remember the no.s are given in 2's complement form
	
	;-- take care when you set carry/borrow.
	
	;-- store the result at appropriate locations.

	RETURN:
	MOV 62H,#01H	;-- pop the registers
	RET

INIT:
		MOV 70H,#00H   ;-- store the numbers to be added/subtracted at appropriate location
		MOV 71H,#05H   ;-- store the numbers to be added/subtracted at appropriate location
		MOV 60H,#00H
		MOV 61H,#02H
	RET

MAIN:
		ACALL INIT
		ACALL ADDER_16BIT
		END
		