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

ORG 50H
start:
 mov P2,#00h
 mov P1,#00h
 ;initial delay for lcd power up

 acall delay
 acall delay

 acall lcd_init      ;initialise LCD

 acall delay
 acall delay
 acall delay
 mov a,#81h	;Put cursor on first row,5 column
 acall lcd_command	;send command to LCD
 acall delay

 ;-- display “EE 337 - Lab 2” on the LCD
 MOV A, #45H
 acall lcd_senddata
 MOV A, #45H
 acall lcd_senddata
 MOV A, #20H
 acall lcd_senddata
 MOV A, #33H
 acall lcd_senddata
 MOV A, #33H
 acall lcd_senddata
 MOV A, #37H
 acall lcd_senddata
 MOV A, #20H
 acall lcd_senddata
 MOV A, #2DH
 acall lcd_senddata
 MOV A, #20H
 acall lcd_senddata
 MOV A, #4CH
 acall lcd_senddata
 MOV A, #61H
 acall lcd_senddata
 MOV A, #62H
 acall lcd_senddata
 MOV A, #20H
 acall lcd_senddata
 MOV A, #32H
 acall lcd_senddata

 mov a,#0C0h	 ;Put cursor on second row,3 column
 acall lcd_command
 acall delay
 mov   R0, #0C0H
 acall lcd_sendstring
 ret

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
         mov  a,@R0         ;load the first character in accumulator
         jz    exit              ;go to exit if zero
         acall lcd_senddata      ;send first char
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
    MOV R0, #0C0H
    MOV @R0, #20H
    INC R0
    MOV @R0, #20H
    INC R0
    MOV @R0, #20H
    INC R0
    MOV @R0, #4DH ;M
    INC R0
    MOV @R0, #45H ;E
    INC R0
    MOV @R0, #45H ;E
    INC R0
    MOV @R0, #54H ;T
    INC R0
    MOV @R0, #20H   
    INC R0
    MOV @R0, #20H 
    INC R0
    MOV @R0, #53H ;S
    INC R0
    MOV @R0, #48H ;H
    INC R0
    MOV @R0, #41H ;A
    INC R0
    MOV @R0, #48H ;H
    INC R0
    MOV @R0, #20H
    INC R0
    MOV @R0, #20H
    INC R0
    MOV @R0, #20H
    LCALL start
    
FIN: SJMP FIN
END