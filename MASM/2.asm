DATA SEGMENT
mesg0 DB "welcome!!$"
mesg1 DB "please input Suffix expressions:$"
mesg2 DB "please input num1:$"
mesg3 DB "please input num2:$"
mesg4 DB "Illegal import!!! input again$"
next_row DB 0dh,0ah,'$'
expressions DB 50,?,50 DUP('$')
ops DB "+" , "-","*","/","(",")"
op_count EQU $ - ops

DATA ENDS

STACK SEGMENT
    DB 50H DUP(?)
STACK ENDS

CODE SEGMENT 
ASSUME DS:DATA,CS:CODE,SS:STACK
START:
    MOV AX,DATA      ;初始化寄存器
    MOV DS,AX
    MOV AX,STACK
    MOV SS,AX

    CALL WELCOME     ;欢迎

    CALL INPUT

    MOV AH,9H
    LEA DX,expressions+2
    INT 21H

    MOV AH,4CH
    INT 21H

WELCOME PROC
    MOV AH,9H        ;欢迎
    LEA DX,mesg0 
    INT 21H
    LEA DX,next_row
    INT 21H
    RET
WELCOME ENDP

INPUT PROC
    MOV AH,9H        ;提示输入
    LEA DX,mesg1    
    INT 21H

    MOV AH,0ah       ;读取
    LEA DX,expressions
    INT 21H

    MOV AH,9H
    LEA DX,next_row
    INT 21H
    RET
INPUT ENDP

CODE ENDS
END START
