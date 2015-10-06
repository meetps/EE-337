org 000h
ljmp main

org 000Bh
push acc
push psw
inc r6           ;Used to measure 30ms (i.e. r6 =15)
pop psw
pop acc
reti

org 0200h

conv2cpl2:      ;to store 2's complement corresponding to 2ms delay (#3E8h)
push acc
mov a,#0E8h
cpl a
add a,#01
mov TL0,a
mov a,#03h
cpl a
addc a,#00h
mov TH0,a
pop acc
ret

delay2:                  ;2ms delay
setb TR0
setb TF0
again: jb TF0,again     
clr TF0
clr TR0
ret

start:

mov TMOD,#01h                 ;Set 16 bit counting mode for T0
setb IE.7                    ;enable interrupts
loop:
mov P1,#0Fh
mov a,P1
anl a,#0Fh
mov b,#02
mul ab                       ;multiply input by 2, this should be the delay in ms
;we need to repeat a*2ms
;mov a,#08
mov r5,#33                    ;Repeat 30ms delay 33 times ~0.99sec
 do:
  setb ET0                    ;enable interrupt for T0 overflow
  mov r1,a
  jz again2
  mov r6,#00h
  rep:
  acall conv2cpl2
  mov P1,#80h                 ;glow LED
  acall delay2
  djnz r1,rep            ;Keep LED glowing for k*2ms
  cjne a,#30,offled
  sjmp rst 
  offled:
   mov P1,#00h
   again2: 
   acall delay2
   acall conv2cpl2
   cjne r6,#0Fh,again2
   clr TR0                     ;stop timer
  rst:
  djnz r5,do
  sjmp loop
 
org 900h

main:
lcall start

END
