; hello.asm — x86-64 Linux

section .data
    msg db "Hello, world!", 10  ; 0x0A works too, it's just the hex val for '10'
    len equ $ - msg   ; $ = curr loc in memory, so this line sets len to number of bytes between msg and now -> AKA: the string length

section .text
    global _start

_start:
    mov rax, 1          ; sys_write
    mov rdi, 0          ; stdout
    mov rsi, msg        ; address of message
    mov rdx, len        ; length, len+1 here is also valid lmao, just prints an extra blank space ofc
    syscall

    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; status 0
    syscall







































