;; Definitions    
    SYS_READ equ 3
    SYS_WRITE equ 4
    STDIN equ 0
    STDOUT equ 1
    SYS_EXIT equ 1

section .data

section .bss

section .text
    global _start

_start:
    push 1  ;; End of stack marker value

;; Store input text
input_loop:
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, inBuff
    mov edx, inBuff_Size
    int 0x80
    
    cmp eax, 0
    jle check_stack_not_empty
    
    mov [inputByteCount], eax
    xor esi, esi
    
byte_loop:
    mov AL, [inBuff + esi]
    inc esi
    
    ;; If (
    cmp AL, '('
    je open_klammern
    
    ;; If )
    cmp AL, ')'
    je close_klammern
    
    ;; If counter reached
    cmp esi, [inputByteCount]
    
