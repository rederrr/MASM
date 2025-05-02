data segment
    opt_plus db '+'
    opt_minus db '-'
    opt_mul db '*'
    opt_div db '/'

    hello_msg db '!!!welcome to houzhui expression caculator!!!$'
    msg1 db 'please input houzhui expression: $'
    msg2 db 'result: $'
    msg3 db 'error expression$'
    expression db 100,?,100 dup('$')
    result dw ?
    result_str db 100,?,100 dup('$')
data ends

stack segment
    db 120 dup(?)
stack ends

code segment
    assume cs:code, ds:data, ss:stack

    welcome proc
        ; 输出欢迎信息
        lea dx, hello_msg
        mov ah, 9h
        int 21h

        ; 添加换行符
        mov ah, 02h          ; DOS 功能号：显示字符
        mov dl, 0Dh          ; 回车符 (CR)
        int 21h
        mov dl, 0Ah          ; 换行符 (LF)
        int 21h

        ; 输入表达式
        lea dx, msg1
        mov ah, 9h
        int 21h

        lea dx, expression
        mov ah, 0ah
        int 21h

        ; 添加换行符
        mov ah, 02h          ; DOS 功能号：显示字符
        mov dl, 0Dh          ; 回车符 (CR)
        int 21h
        mov dl, 0Ah          ; 换行符 (LF)
        int 21h
        ret
    welcome endp

    start:
        mov ax, data
        mov ds, ax
        mov ax,stack
        mov ss,ax
        
        ; 调用欢迎信息函数
        call welcome

        ; 显示结果:
        lea dx, expression+2
        mov ah, 9h
        int 21h
        ; 退出
        mov ah, 4ch
        int 21h
code ends
end start