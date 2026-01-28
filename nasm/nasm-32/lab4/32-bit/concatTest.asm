;; Definitions
    SYS_READ equ 3
    SYS_WRITE equ 4
    STDIN equ 0
    STDOUT equ 1
    SYS_EXIT equ 1
    
section .data
    output db "You typed in: ", 0
    NEWLINE_BUF db 0x0A
    
section .bss
    
    inBuff resb 1024
    inBuff_Size equ $ - inBuff

section .text
    global _start
    
_start:
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, inBuff
    mov edx, inBuff_Size
    int 0x80
    
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, output
    mov edx, 14
    int 0x80
    
    ;; Print input
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, inBuff
    mov edx, inBuff_Size
    int 0x80
    
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1
    int 0x80
    
    ;; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
