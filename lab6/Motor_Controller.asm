PWM EQU P0.0
LED EQU P1.4

; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable
	


	
ORG 0000H
LJMP MAIN

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
         using 0
		 push ar0
		 push ar1
         mov r0,#1
loop4:	 mov r1,#255
loop3:	 djnz r1, loop3
		 djnz r0,loop4
		 pop ar1
		 pop ar0
		 ret


DISPLAYASCII:;SUB ROUTINE FOR DISPLAYING HEX VALUE FROM ACCUMULATOR 
	  PUSH ACC
	  PUSH B
	  PUSH PSW	
	  LCALL ASCIICONV
	  ACALL LCD_SENDDATA
	  ACALL DELAY
	  MOV A,B
	  ACALL LCD_SENDDATA
	  ACALL DELAY
	  
	  POP PSW
	  POP B
	  POP ACC
	  RET


;-------------------------------------hex to ascii routine-------------------------------------------			   
ASCIICONV: 
using 0
push ar2
push ar3
MOV R2,A
ANL A,#0Fh
MOV R3,A
SUBB A,#0Ah  ;CHECK IF NIBBLE IS DIGIT OR ALPHABET
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
SUBB A,#0Ah
JNC ALPHA2 

MOV A,R3			;DIGIT TO ASCII
ADD A,#30h
pop ar3
pop ar2
RET	

ALPHA2:MOV A,R3
ADD A,#37h           ;ALPHABET TO ASCII
pop ar3
pop ar2
RET
		       
	   

ORG 400H
MY_STRING1:
    DB   "IN RPM    ", 00H

DISPLAY_MSG:
	PUSH ACC
	MOV A,#80H		 
	ACALL lcd_command	
	ACALL DELAY
	MOV   DPTR,#MY_STRING1   ;IN RPM
	ACALL lcd_sendstring   
	ACALL DELAY
    POP ACC
	RET



;ORG 000BH 	;ISR address for Timer 0
;SJMP NEXT
;RETI

DDELAY:;2MS
                 
    CLR TF0
	MOV TMOD,#51H        ;timer 16bit
    MOV TL0,#60H   ;2MS;4000MACHINE CYCLES       
	MOV TH0,#0F0H
	;SETB EA
	;SETB ET0
	SETB TR0              ;start timer
	JNB  TF0,$          ;jump if tfo is set
		;HERE: SJMP HERE
		;NEXT:
	CLR  TR0              ;stop timer

	RET
	
DELAYBYTIMER:;PWM
    USING 0
	PUSH ACC
	PUSH 2
	PUSH 3

	
	MOV 3,#33
	MOV P1, #0FH
	NOP
	MOV A,P1

	MOV 4,A
	
	LOOP2:
	MOV A,4
	MOV 2,A
	
	SETB PWM        ;turn on led
	SETB LED
	SJMP CHECK
	LOOP:
	LCALL DDELAY       ;2KMs delay
	DJNZ 2,LOOP
	CHECK: CJNE R2,#0, LOOP
	
	CLR PSW.7
	MOV B, #15
	MOV A,4
	XCH A,B
	SUBB A,B
	MOV 2,A
	
	CLR PWM
	CLR LED
	SJMP CHECK1
	LOOP1:
	LCALL DDELAY       ;30Ms - 2KMS delay
	DJNZ 2,LOOP1
	CHECK1: CJNE R2,#0, LOOP1
	DJNZ 3H, LOOP2
	

	POP 3
	POP 2
	POP ACC
	RET
	
MAIN:
	LCALL lcd_init
	LCALL DISPLAY_MSG
    AGAIN: 
	;MOV 7,#0
	MOV TL1,#00
	SETB TR1
	LCALL DELAYBYTIMER
	CLR TR1
	MOV A,#0C0H		 
	ACALL lcd_command
	MOV A,4
	;MOV B, #60
	;MUL AB
	LCALL DISPLAYASCII
	
	MOV A,TL1
	MOV B, #2
	MUL AB
	MOV 1,A
	MOV 0,B
	MOV A,#0C3H		 
	ACALL lcd_command
	MOV A,0
	LCALL ASCIICONV
	MOV A,B
	ACALL LCD_SENDDATA
	MOV A,1
	LCALL DISPLAYASCII

	
	SJMP AGAIN
END