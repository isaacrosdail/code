
section .data
    
    fizz db "fizz", 4
    buzz db "buzz", 4
    Z db "Z", 4
    numZ db 1
    ;;newLine db
    
section .bss    

    BUF_SIZE equ 1024           ;; size of input buffer
    inputBuffer resb BUF_SIZE   ;; input buffer
    inputByteCount resd 1       ;; variable for saving input byte count

section .text

    extern _start
    
_start:

    ;mov esi, [numZ]  ;; line count
    ;;mov edi, 0  ;; star count
    
loop_main:
    
    mov eax, SYS_WRITE      ;; prints a single char (reverse order)
    mov ebx, FD_STDOUT
    mov ecx, Z              ;; prints Z
    add ecx, [numZ]            ;; add characterPosition to start address of inputBuffer
                            ;; this gives us address of the char we want to print
    mov edx, 1              ;; only want to print 1 char at a time
    int 0x80                ;; trigger sys_write
    
    inc esi                 ;; dec characterPosition (because reverse)
    mov [numZ], esi
    cmp esi, 0
    
    ;; prints the newline char
    mov eax, SYS_WRITE      ;; prints the newline char
    mov ebx, FD_STDOUT
    mov ecx, esi            ;; want inputBuffer + characterPosition
    mov edx, 1              ;; only want to print 1 char at a time
    int 0x80                ;; trigger sys_write   


    jl end_loop_main
    jmp loop_main

end_loop_main:
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
    mov eax, 1      ;;Prep for sys_ext call
    mov ebx, 0      ;;Return "success"
    int 0x80        ;;Trigger the system call
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; defining some symbols

    SYS_READ    equ 3
    SYS_WRITE   equ 4
    SYS_EXIT    equ 1
    FD_STDIN    equ 0
    FD_STDOUT   equ 1
    FD_STDERR   equ 2
