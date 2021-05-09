MAX_ARG     equ     5 ; define o numero maximo de argumentos que o programa pode receber

SECTION     .data
err_msg_max    db      "Argument limit exceeded", 10
erro_msg      equ     $-err_msg_max
next_line  db      10
NEWLINE: db 0xa, 0xd
LENGTH: equ $-NEWLINE

SECTION     .text
global      _start

; Linux
_start:

; ; WINDOWS
; _WinMain@16:
    nop
    push    ebp

    mov     ebp, esp

    cmp     dword [ebp + 4], 1
    je      NoArgs                           ; no args entered
    ; uncomment the following 2 lines to limit args entered
    ; and set MAX_ARG to Total args wanted + 1
    cmp     dword [ebp + 4], MAX_ARG        ; check total args entered
    ja      TooManyArgs                     ; if total is greater than MAX_ARG, show error and quit
   
    mov     ebx, 3

DoNextArg:  
    mov     edi, dword [ebp + 4 * ebx]
    test    edi, edi
    jz      Exit

    call    GetStrlen
    push    edx                             ; save string length for reverse

    mov     ecx, dword [ebp + 4 * ebx]
    call    DisplayNorm                     ; display arg text normally
    
    ; Nova linha
    push    ebx ; Insere elemento na pilha pra poder usar o ebx e nao da seg fault
    mov eax, 0x4
	mov ebx, 0x1
	mov ecx, NEWLINE
	mov edx, LENGTH
	int 0x80
    pop     ebx ; remove o elemento da pilha pra poder voltar a posicao anterior do ponteiro

    pop     edi                             ; move string length into edi
    mov     esi, dword [ebp + 4 * ebx]
    inc     ebx                             ; step arg array index
    jmp     DoNextArg

NoArgs:
   ; No args entered,
   ; start program without args here
    jmp     Exit
DisplayNorm:
    push    ebx
    mov     eax, 4 ; codigo para a chamada do sistema para escrita
    mov     ebx, 1 ; codigo da chamada do sistema para executar o stdout
    int     80H 
    pop     ebx
    ret

GetStrlen:
    push    ebx
    xor     ecx, ecx
    not     ecx
    xor     eax, eax
    cld
    repne   scasb
    mov     byte [edi - 1], 10
    not     ecx
    pop     ebx
    lea     edx, [ecx - 1]
    ret
TooManyArgs:
    mov     eax, 4 ; codigo para a chamada do sistema para escrita
    mov     ebx, 1 ; codigo da chamada do sistema para executar o stdout
    mov     ecx, err_msg_max
    mov     edx, erro_msg
    int     80H
Exit:
    mov     esp, ebp
    pop     ebp
     
    mov     eax, 1 ; Codigo para o comando exit do programa
    xor     ebx, ebx
    int     80H
