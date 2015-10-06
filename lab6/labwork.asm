ORG 0000H
	ljmp mains
	ORG 000BH
		inc r7; holds k
		mov TH0, #0F0h
	mov TL0, #60h
		reti
	
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable	


	;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
         clr   a                 ;clear Accumulator for any previous data
         movc  a,@a+dptr         ;load the first character in accumulator
         jz    exit              ;go to exit if zero
         acall lcd_senddata      ;send first char
         inc   dptr              ;increment data pointer
         sjmp  LCD_sendstring    ;jump back to send the next character
exit:
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 
         mov r0,#1
loop2:	 mov r1,#255
loop1:	 djnz r1, loop1
		 djnz r0,loop2
		 ret
;========================================
;---------------SUBROUTINE TO CONVERT BYTE TO ASCII---------------------------------------------

ASCIICONV: MOV R2,A
ANL A,#0Fh
MOV R3,A
SUBB A,#09h  ;CHECK IF NIBBLE IS DIGIT OR ALPHABET
JNC ALPHA

MOV A,R3
ADD A,#30h   ;ADD 30H TO CONV HEX TO ASCII
MOV B,A
JMP NEXT

ALPHA: MOV A,R3  ;ADD 37H TO CONVERT ALPHABET TO ASCII
ADD A,#37h
MOV B,A

NEXT:MOV A,R2
ANL A,#0F0h          ;CHECK HIGHER NIBBLE IS DIGIT OR ALPHABET
SWAP A
MOV R3,A
SUBB A,#09h
JNC ALPHA2 

MOV A,R3			;DIGIT TO ASCII
ADD A,#30h
RET

ALPHA2:MOV A,R3
ADD A,#37h          ;ALPHABET TO ASCII
RET		
;=================DISPLAY===============================
display1:
mov r5,b
mov r4,a
mov a,#0C0h		  ;Put cursor on second row,1 column
	  acall lcd_command
	  acall delay
	  
	  mov a, p1
	  anl a,#0Fh
	  clr c
	  mov 50h,a
	  mov a,#15
	  subb a,50h
	  
	  mov b,#2
	  mul ab
	  mov b,#10
	  div ab
	  push b
	  acall ASCIICONV
	  mov a,b
	  acall lcd_senddata
	  pop b
	  
	  mov a,b
	  acall ASCIICONV
	  mov a,b
	  acall lcd_senddata
	  
		 
	  mov a,#0C3h
	  acall lcd_command
	  acall delay
	  
	  mov a, r5
	  acall ASCIICONV
	  mov a,b
	  acall lcd_senddata
	  mov a, r4
	  acall ASCIICONV
	  acall lcd_senddata
	  mov a,b
	  acall lcd_senddata
	  
	  ret
;===================MAIN================================			

main:
	mov r6,#0
	mov TH1,#0
	mov TL1,#0
	mov A,p1
	wave:
	mov p1,#0Fh
	;mov TMOD,#51h
	
	;mov IE,#82h
	
	anl A,#0Fh
	mov r7,#0
	mov TH0, #0F0h
	mov TL0, #60h
	setb TR0; for 2ms counter
	setb TR1
	wait:
	cjne A,07h,nochange
	setb p3.0
	nochange:
	cjne r7,#15, wait
	inc r6
	clr p3.0
	
	cjne r6,#33,ahead
	mov B,TL1
	mov A,#2
	mul AB
	
	push acc
	push B
	mov A, TL1
	anl A,#0F0h
	mov r4,A
	mov A,p1
	orl A,r4
	mov p1,A
	pop B
	pop acc
	
	acall display1
	sjmp main
	ahead:
	sjmp wave
ret

mains:
lcall lcd_init

mov p1,#0Fh
	mov TMOD,#51h
	
	mov IE,#82h
	  mov a,#01h
	  acall lcd_command
	  acall delay

	  mov a,#02h
	  acall lcd_command
	  acall delay

	  mov a,#80h		 ;Put cursor on first row,1 column
	  acall lcd_command	 ;send command to LCD
	  acall delay

	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay
  
acall main
here: sjmp here	


org 300h
my_string1:
         DB   "IN RPM", 00H
end
	