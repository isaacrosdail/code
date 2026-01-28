
section .data
    
    fizz db "fizz", 4
    buzz db "buzz", 4
    Z db "Z", 4
    endl db 10
    
section .bss    

    BUF_SIZE equ 1024           ;; size of input buffer
    inputBuffer resb BUF_SIZE   ;; input buffer
    inputByteCount resd 1       ;; variable for saving input byte count

section .text

    extern _start
    
_start:

    mov esi, 0  ;; line count
    mov edi, 0  ;; star count
    
loop_main:
    
    inc esi
    cmp esi, 9
    jg end
    
    call print_line
    
    jmp loop_main
    
print_line:
    
    mov edi, 0; no stars, new line
    
printline_loop:

    call print_star ;;print single star char
    inc edi         ;; inc number of stars we've printed
    ;; have we printed same number of stars as we have lines?
    cmp edi, esi
    jne printline_loop
    call print_eol
    
    ret
    
print_star:
    
    mov edx, 1
    mov ecx, Z
    mov ebx, 1
    mov eax, 4
    int 0x80
    
    ret
    
print_eol:
    
    mov edx, 1
    mov ecx, endl
    mov ebx, 1
    mov eax, 4
    int 0x80
    
    ret
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
end:
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
