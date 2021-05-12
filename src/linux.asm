MAX_ARG     equ     6 ; define o numero maximo de argumentos que o programa pode receber

SECTION     .data
err_msg_max    db      "Limite de argumentos excedidos", 10
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
    je      SemArgumentos                   ; sem argumentos de entrada
    cmp     dword [ebp + 4], MAX_ARG        ; checar o total de argumentos de entrada
    ja      MuitosArgumentos                ; se o total for maior que MAX_ARG mostrar erro e encerrar
   
    mov     ebx, 3

ProximoArgumento:  
    mov     edi, dword [ebp + 4 * ebx]
    test    edi, edi
    jz      Exit

    call    TamanhoString
    push    edx                             ; salvar o tamanho da string para o inverso

    mov     ecx, dword [ebp + 4 * ebx]
    call    MostraArgumentos                ; imprimir argumento
    
    ; Nova linha
    push    ebx ; Insere elemento na pilha pra poder usar o ebx e nao da seg fault
    mov     eax, 0x4
	mov     ebx, 0x1
	mov     ecx, NEWLINE
	mov     edx, LENGTH
	int     0x80
    pop     ebx ; remove o elemento da pilha pra poder voltar a posicao anterior do ponteiro

    pop     edi                             ; passa o tamanho da string para edi
    mov     esi, dword [ebp + 4 * ebx]
    inc     ebx
    jmp     ProximoArgumento

SemArgumentos:
   ; Nao ha argumentos entao finaliza
    jmp     Exit

MostraArgumentos:
    push    ebx
    mov     eax, 4 ; codigo para a chamada do sistema para escrita
    mov     ebx, 1 ; codigo da chamada do sistema para executar o stdout
    int     80H 
    pop     ebx
    ret

TamanhoString:
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

MuitosArgumentos:
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
