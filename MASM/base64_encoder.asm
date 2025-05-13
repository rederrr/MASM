DATA SEGMENT
mesg0 DB "welcome!!$"
mesg1 DB "please input strings: $"
mesg2 DB "Base64_Encode: $"
next_row DB 0dh,0ah,'$'
base64 db 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
result DB 135,?,135 DUP('$')    ;编码后132字符加2=加1$

strings label byte              ;标准输入缓冲区
    max DB 100                  ;最大可输入99个字符
    act DB ?
    inputstr DB 100 DUP('$')

DATA ENDS

CODE SEGMENT 
ASSUME DS:DATA,CS:CODE
START:
    MOV AX,DATA
    MOV DS,AX

    CALL WELCOME     
    CALL INPUT       
    CALL BASE64ENCODE
    CALL OUTPUT

    MOV AH,4CH
    INT 21H

WELCOME PROC
    MOV AH,9H
    LEA DX,mesg0            ;欢迎信息
    INT 21H
    LEA DX,next_row
    INT 21H
    RET
WELCOME ENDP

INPUT PROC
    MOV AH,9H               ;提示输入
    LEA DX,mesg1    
    INT 21H

    MOV AH,0ah              ;读取
    LEA DX,strings
    INT 21H

    MOV AH,9H
    LEA DX,next_row
    INT 21H
    RET

INPUT ENDP

BASE64ENCODE PROC
    SUB AX,AX
    MOV AL,act      
    MOV BL,3
    DIV BL                  ;将strings对3求余，商AL，余数AH
    MOV DH,AH               ;保存余数用于尾处理
    CMP AH,0
    JZ NEXT
    INC AL                  ;不是3的倍数，循环次数加1

NEXT:
    ;循环预处理
    MOV CH,AL               ;CL要用
    MOV SI,0                ;指向inputstr
    MOV DI,0                ;指向result

LOOP1:
    ;获取char1的前六位
    MOV AL,inputstr[SI]     ;SI 0 DI 0
    MOV AH,AL               ;求第二位base码用
    MOV CL,2
    SHR AL,CL               ;移位获取char1的前6位ascii码
    MOV BL,AL
    MOV BH,0                ;存入BX
    MOV DL,base64[BX]
    MOV result[DI],DL
    INC SI
    INC DI

    ;char1的后两位和char2的前四位     
    
    ;XOR ??
    MOV CL,6                ;SI 1 DI 1
    SHL AH,CL
    MOV CL,2
    SHR AH,CL               ;后两位
    MOV AL,inputstr[SI]
    MOV CL,4
    SHR AL,CL
    ADD AL,AH
    MOV BL,AL
    MOV BH,0
    MOV DL,base64[BX]
    MOV result[DI],DL
    MOV AL,inputstr[SI]     ;下一步用
    INC SI
    INC DI

    ;cher2后四位和char3前两位
    MOV CL,4                ;SI 2 DI 2
    SHL AL,CL
    MOV CL,2
    SHR AL,CL
    MOV AH,inputstr[SI]
    MOV CL,6
    SHR AH,CL
    ADD AL,AH
    MOV BL,AL
    MOV BH,0
    MOV DL,base64[BX]
    MOV result[DI],DL
    INC DI

    ;char3后六位
    MOV AL,inputstr[SI]     ;SI 2 DI 3
    MOV CL,2
    SHL AL,CL
    SHR AL,CL
    MOV BL,AL
    MOV BH,0
    MOV DL,base64[BX]
    MOV result[DI],DL
    INC SI
    INC DI

    ;判断是否全部遍历
    DEC CH
    CMP CH,0
    JNZ LOOP1

    ;尾处理：余1 2= 余2 1=
    SUB DI,2                ;仅需处理尾两位字符
    CMP DH,1
    JNZ NOT_1
    MOV AL,'='
    MOV result[DI],AL
NOT_1:                      ;余数不为1
    INC DI
    CMP DH,0
    JZ NOT_1_2
    MOV AL,'='
    MOV result[DI],AL
NOT_1_2:                    ;余数为0
    RET
BASE64ENCODE ENDP

OUTPUT PROC
    MOV AH,9H
    LEA DX,mesg2
    INT 21H
    LEA DX,result
    INT 21H
    RET
OUTPUT ENDP

CODE ENDS
END START
