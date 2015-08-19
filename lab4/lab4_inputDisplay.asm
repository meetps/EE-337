;------------------------------------------
; Author : Meet P Shah
; Email  : meetshah1995@ee.iitb.ac.in
;------------------------------------------



; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp start

org 200h
start:;ALSO THE MAIN
      mov P2,#00h
	  mov P1,#00h
	  ;initial delay for lcd power up

;here1:setb p1.0
      acall delay
;	  clr p1.0
	  acall delay
;	  sjmp here1

      acall lcd_init      ;initialise LCD
	
	  acall delay
	  acall delay
	  acall delay
	  
	  ACALL STOREVALUES;from 40 to 4e 
	  
	  AGAIN:
	  ACALL DISPLAYARRAY;Displays array specified by P1
	  ACALL DELAY1;5s delay
	  SJMP AGAIN
	  

here: sjmp here			//stay here 
;------------------------intialising values in ram-----------------------------------------------------
STOREVALUES:
               USING 0
               PUSH ACC
			   PUSH AR0
			   PUSH AR1
			   PUSH AR2
			   PUSH AR3
			   MOV 1,#80h;array for input P1 =8
			   MOV 0,#90H;array for input P1 =9
			   MOV 2,#50h
			   MOV 3,#10h
			   AGAIN1:
			          MOV A,2
					  MOV @R1,A
					  MOV @R0,A
					  INC 1
					  INC 2
					  INC 0
					  DJNZ 3,AGAIN1
			   POP AR3
			   POP AR2
			   POP AR1
			   POP AR0
			   POP ACC
			   RET
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
loop2:	 mov r1,#255
loop1:	 djnz r1, loop1
		 djnz r0,loop2
		 pop ar1
		 pop ar0
		 ret

DELAY1:
USING 0
PUSH AR3
PUSH AR4
PUSH AR5
CLR A
;MOV A,4FH ;value of d in 04Fh
MOV A, #0AH;
MOV B,#0AH;10
MUL AB ; 10*50ms = 1/2 s 
MOV R3,A
delayLoop :
			MOV R4,#200
			BACK1: MOV R5,#0FFH	
			BACK: DJNZ R5, BACK
			DJNZ R4, BACK1
			DJNZ R3, delayLoop
POP AR5
POP AR4
POP AR3
RET   
;---------------------read switch routine------------------------------------------------------
DISPLAYARRAY:
          USING 0
		  PUSH AR0
		  PUSH AR1
		  PUSH AR2
		  PUSH AR3
          PUSH ACC
		  PUSH B
          MOV P1,#0FH;p1 as input
		  ACALL DELAY1;5s delay
		  MOV A,P1;input from p1
		  ACALL delay
		  MOV B,P1;take the final input
		  MOV 20H,B
		  CJNE A,20h,DISPLAYARRAY;check if it matches
		  SWAP A
		  MOV P1,A;display given input
		  
		  MOV 3,#02H;2 value to run this twice
		  MOV 1,A;input to R1 for indirect addressing
		  TWOTIMES:
			   MOV 2,#04H
			   MOV A,#81H;first line
			   acall lcd_command
			   LINE1:
			         MOV A,@R1
			         ACALL ASCIICONV
			         ACALL lcd_senddata;display A
			         MOV A,B
			         ACALL lcd_senddata;display B
			         MOV A,#20H
			         ACALL lcd_senddata;space
			         INC 1
			         DJNZ 2,LINE1
			   MOV 2,#04H
			   MOV A,#0C1H;second line
			   ACALL lcd_command
			   LINE2:
			         MOV A,@R1
					 ACALL ASCIICONV
					 ACALL lcd_senddata;display A
					 MOV A,B
					 ACALL lcd_senddata;display B
					 MOV A,#20h
					 ACALL lcd_senddata;space
					 INC 1
					 DJNZ 2,LINE2

			   ACALL DELAY1
			   DJNZ 3, TWOTIMES
			   POP B
			   POP ACC
			   POP AR3
			   POP AR2
			   POP AR1
			   POP AR0
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
		       
end			   
			   
		  
		  


