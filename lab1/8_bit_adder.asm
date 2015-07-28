;-----------------------------------------
; CodeName : 8 bit adder and save it to memory 
; Author   : Meet Pragnesh Shah
; Contact  : meetshah1995@ee.iitb.ac.in
;-----------------------------------------
 
ORG 50H

;----------------------------------------
; Subroutine to add 8 bit numbers stored in 
; 50H , 60H and output the sum in 70H
;----------------------------------------

ADDER_8BIT:
    MOV A,50H   ; Move from 50H to Accumulator
    ADD A,60H   ; Adding the data at 60H to Accumulator 
    MOV 70H,A   ; Saving the result in 70H