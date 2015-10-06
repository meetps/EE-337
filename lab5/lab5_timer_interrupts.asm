ORG 0000H
LJMP MAIN

ORG 000BH 		;ISR address for Timer 0
INC R0 			;To keep the count of no. of times timer as overflown
RETI

ORG 200H

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

MAIN :
	LCALL lcd_init
	BACK: 
		LCALL DISPLAY_MSG1
		; LCALL START_TIMER
		; LCALL DISPLAY_MSG2
		SJMP BACK
	
	HERE: SJMP HERE
	END

DISPLAY_MSG1:
    MOV R0, #0C0H
    MOV @R0, #50H
    INC R0
    MOV @R0, #52H
    INC R0
    MOV @R0, #45H
    INC R0
    MOV @R0, #53H 
    INC R0
    MOV @R0, #53H 
    INC R0
    MOV @R0, #20H 
    INC R0
    MOV @R0, #53H 
    INC R0
    MOV @R0, #57H   
    INC R0
    MOV @R0, #49H 
    INC R0
    MOV @R0, #54H 
    INC R0
    MOV @R0, #43H 
    INC R0
    MOV @R0, #48H 
    INC R0
    MOV @R0, #20H 
    INC R0
    MOV @R0, #53H
    INC R0
    MOV @R0, #57H
    INC R0
    MOV @R0, #31H	

 	mov a,#81h		 ;Put cursor on second row,3 column
 	acall lcd_command
 	acall delay
 	acall delay
 	acall delay
 	mov R0, #0C0H
 	acall lcd_sendstring
 	
 	MOV R0, #0C0H
    MOV @R0, #20H
    INC R0
    MOV @R0, #41H
    INC R0
    MOV @R0, #53H 
    INC R0
    MOV @R0, #20H
    INC R0
    MOV @R0, #20H 
    INC R0
    MOV @R0, #4CH 
    INC R0
    MOV @R0, #45H   
    INC R0
    MOV @R0, #44H 
    INC R0
    MOV @R0, #20H 
    INC R0
    MOV @R0, #20H 
    INC R0
    MOV @R0, #47H 
    INC R0
    MOV @R0, #4CH 
    INC R0
    MOV @R0, #4FH 
    INC R0
    MOV @R0, #57H
    INC R0
    MOV @R0, #53H
    INC R0
    MOV @R0, #20H

 	mov a,#0C0h		 ;Put cursor on second row,3 column
 	acall lcd_command
 	acall delay
 	acall delay
 	acall delay
 	mov R0, #0C0H
 	acall lcd_sendstring

 	ret


; START_TIMER:
; 	-Configures TMOD,(for 16 bit mode)
; 	-Set IE correctly and actions on timer overflow should be
; 	written in Interrupt Service Routine address.
; 	-Switches on LED
; 	-Starts Timer (Set TR0)
; 	-Wait for switch to go off.
; 	-Clear TR0 to stop timer.

; DISPLAY_MSG2 :
; 	-Displays second msg