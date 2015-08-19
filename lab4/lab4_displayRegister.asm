;------------------------------------------
; Author : Meet P Shah
; Email  : meetshah1995@ee.iitb.ac.in
;------------------------------------------


LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 00H
LJMP MAIN

;---------------SUBROUTINE TO CONVERT BYTE TO ASCII---------------------------------------------
ORG 200h

largedelay:
USING 0
PUSH AR3
PUSH AR4
PUSH AR5
CLR A
MOV A,#0AH
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
POP AR5
POP AR4
POP AR3
RET

ASCIICONV: 
Using 0
PUSH 2
PUSH 3

MOV R2,A
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

MOV A,R3            ;DIGIT TO ASCII
ADD A,#30h
POP 3
POP 2
RET

ALPHA2:
MOV A,R3
ADD A,#37h          ;ALPHABET TO ASCII
POP 3
POP 2
RET

start:
 PUSH 7
 PUSH 6
 PUSH 5
 PUSH 4
 PUSH 3
 PUSH 2
 PUSH 1
 PUSH 0
 PUSH 0F0H
 PUSH 0E0H

 mov P2,#00h    
 mov P1,#00h
 ;initial delay for lcd power up

 lcall delay

 lcall lcd_init      ;initialise LCD

 lcall delay
 lcall delay
 lcall delay
 lcall delay

;===================================================
; Column 1
;===================================================
 mov a,#80h ;Put cursor on first row,5 column
 lcall lcd_command  ;send command to LCD
 lcall delay

 MOV A, #41H
 lcall lcd_senddata
 
 MOV A, #42H
 lcall lcd_senddata
 
 MOV A, #50H
 lcall lcd_senddata
 
 MOV A, #53H
 lcall lcd_senddata
 
 MOV A, #57H
 lcall lcd_senddata
 
 MOV A, #3DH
 lcall lcd_senddata

 MOV A, #20H
 lcall lcd_senddata

  POP Acc
 lcall ASCIICONV
 lcall lcd_senddata
 MOV A,B
 lcall lcd_senddata
 
 MOV A, #20H
 lcall lcd_senddata
 
 POP Acc
 lcall ASCIICONV
 lcall lcd_senddata
 MOV A,B
 lcall lcd_senddata

 MOV A, #20H
 lcall lcd_senddata
 
 MOV A,PSW 
 lcall ASCIICONV
 lcall lcd_senddata
 MOV A,B
 lcall lcd_senddata

 MOV A,#20H
 lcall lcd_senddata

 MOV A,#20H
 lcall lcd_senddata
 
;===================================================
; Column 2 
;===================================================

 mov a,#0C0h     ;Put cursor on second row,3 column
 lcall lcd_command
 lcall delay

  MOV A, #52H
 lcall lcd_senddata
 
 MOV A, #30H
 lcall lcd_senddata
 
 MOV A, #31H
 lcall lcd_senddata
 
 MOV A, #32H
 lcall lcd_senddata
 
 MOV A, #20H
 lcall lcd_senddata
 
 MOV A, #3DH
 lcall lcd_senddata
 
 MOV A, #20H
 lcall lcd_senddata
 
  POP Acc
 lcall ASCIICONV
 lcall lcd_senddata
 MOV A,B
 lcall lcd_senddata
 
 MOV A, #20H
 lcall lcd_senddata
 
 POP Acc
 lcall ASCIICONV
 lcall lcd_senddata
 MOV A,B
 lcall lcd_senddata

 MOV A, #20H
 lcall lcd_senddata
 
  POP Acc
 lcall ASCIICONV
 lcall lcd_senddata
 MOV A,B
 lcall lcd_senddata

 MOV A,#20H
 lcall lcd_senddata
 
;===================================================
; Column 3 
;===================================================

         lcall largedelay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
         lcall delay
         clr   LCD_en
		 lcall delay
		 lcall delay
		 lcall delay
		 
 mov a,#80h     ;Put cursor on second row,3 column
 lcall lcd_command
 lcall delay

 MOV A, #52H
 lcall lcd_senddata
 
 MOV A, #33H
 lcall lcd_senddata
 
 MOV A, #34H
 lcall lcd_senddata
 
 MOV A, #35H
 lcall lcd_senddata
 
 MOV A, #20H
 lcall lcd_senddata
 
 MOV A, #3DH
 lcall lcd_senddata
 
 MOV A, #20H
 lcall lcd_senddata
 
 POP Acc
 lcall ASCIICONV
 lcall lcd_senddata
 MOV A,B
 lcall lcd_senddata
 
 MOV A, #20H
 lcall lcd_senddata
 
 POP Acc
 lcall ASCIICONV
 lcall lcd_senddata
 MOV A,B
 lcall lcd_senddata

 MOV A, #20H
 lcall lcd_senddata
 
 POP Acc
 lcall ASCIICONV
 lcall lcd_senddata
 MOV A,B
 lcall lcd_senddata

 MOV A,#20H
 lcall lcd_senddata
 
;===================================================
; Column 4 
;===================================================
 mov a,#0C0h     ;Put cursor on second row,3 column
 lcall lcd_command
 lcall delay

 MOV A, #52H
 lcall lcd_senddata
 
 MOV A, #36H
 lcall lcd_senddata
 
 MOV A, #37H
 lcall lcd_senddata
 
 MOV A, #53H
 lcall lcd_senddata
 
 MOV A, #50H
 lcall lcd_senddata
 
 MOV A, #3DH
 lcall lcd_senddata
 
 MOV A, #20H
 lcall lcd_senddata
 
 POP Acc
 lcall ASCIICONV
 lcall lcd_senddata
 MOV A,B
 lcall lcd_senddata
 
 MOV A, #20H
 lcall lcd_senddata
 
 POP Acc
 lcall ASCIICONV
 lcall lcd_senddata
 MOV A,B
 lcall lcd_senddata

 MOV A, #20H
 lcall lcd_senddata
 
 MOV A,SP
 lcall ASCIICONV
 lcall lcd_senddata
 MOV A,B
 lcall lcd_senddata

 MOV A,#20H
 lcall lcd_senddata

;===================================================
 ret

;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
         lcall delay
         clr   LCD_en
         lcall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
         lcall delay
         clr   LCD_en
         
         lcall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
         lcall delay
         clr   LCD_en
         
         lcall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
         lcall delay
         clr   LCD_en

         lcall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
         lcall delay
         clr   LCD_en
         lcall delay
    
         ret  
;-----------------------data sending routine-------------------------------------            
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
         lcall delay
         clr   LCD_en
         lcall delay
         lcall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
         clr   a                 ;clear Accumulator for any previous data
         mov  a,@R0         ;load the first character in accumulator
         jz    exit              ;go to exit if zero
         lcall lcd_senddata      ;send first char
         inc   R0              ;increment data pointer
         sjmp  LCD_sendstring    ;jump back to send the next character
exit:
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:   
         PUSH 0
         PUSH 1
         mov r0,#1
loop2:   mov r1,#255
loop1:   djnz r1, loop1
         djnz r0,loop2
         POP 1
         POP 0
         ret
         
MAIN:
MOV SP,#0CFH
MOV A, #69H
MOV B, #0D0H
MOV R0, #3CH
MOV R1, #34H
MOV R2, #23H
MOV R3, #46H
MOV R4, #54H
MOV R5, #6CH
MOV R6, #0CAH
MOV R7, #48H
LCALL start
    
FIN: SJMP FIN
END