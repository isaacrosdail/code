
section .data
    ; db = define byte. This tells NASM these are byte values
    ; msg db "Hello, world!", 10
    ; The hex on the end of the next line is " long" in ASCII
    ; 0x20 (space) 0x6c ("l") 0x6f ("o") 0x6e ("n") 0x67 ("g")

    msgA db "And it's whispered that soon, if we all call the tune", 10, \
            "Then the piper will lead us to reason", 10, \
            "And a new day will dawn for those who stand", 0x20, 108, 0x6f, 0x6e, 0x67, 10, \
            "And the forests will echo with laughter", ".", 0x0A
    lenA equ $ - msgA
    msgB db "Are we human, or are we dancer?", 10
    lenB equ $ - msgB

section .text
    global _start   ; makes linker aware of labels

_start:
    mov rax, 1    ; sys_write = 1
    mov rdi, 1    ; file descriptor = stdout
    mov rsi, msgA
    mov rdx, lenA
    syscall     ; NOTE: On syscall, rcx and r11 are destroyed! Fair warning :D

    ; Second msg!
    mov rax, 1   ; sys_write = 1
    mov rdi, 1   ; file descriptor = stdout
    mov rsi, msgB
    mov rdx, lenB
    syscall

    mov rax, 60  ; sys_exit
    ; rdi -> first argument register
    ; exit takes 1 argument, so return code 0 goes in rdi
    ; like "exit(success)" is basically what we're telling Linux
    xor rdi, rdi ; return code 0 (success)
    syscall


