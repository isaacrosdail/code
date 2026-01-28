section .data ;; initialize data
    error db "Sorry, I can only build a triangle from a single character!!", 10, 0

    check db "Check printing", 0

    ;; added newline character definition
    newline db 0x0A
        
section .bss ;; uninitialized, allocated memory

    BUF_SIZE equ 1024
    inputBuffer resb 1024

    inputByteCount resd 1

section .text

    extern _start

_start:
    mov BH, 0     ; initialize row counter to 0
    mov DL, 0
    mov eax, SYS_READ   ;; sys read stores in ecx(everytime)
    mov ebx, FD_STDIN
    mov ecx, inputBuffer
    mov edx, BUF_SIZE
    
    int 0x80
    
    
    cmp BYTE [ecx+2], 0
    jne incorrect
    
    mov esi, 0      ;; xor esi, esi
                    ;; more efficient way to set esi to 0
    jmp row_loop
    
incorrect:
    
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov edx, BUF_SIZE
    mov ecx, error
    
    int 0x80
      

row_loop:    

    mov edi, 0          ;; xor edi, edi 
    
    ;; This was commented out
    cmp esi, 42
    ;; Also need this
    jg done
    column_loop:
    
        ;; cmp edi, esi
        ;; jge end_of_row_loop
       
        cmp edi, esi
        je end_of_row_loop
        
        mov eax, SYS_WRITE
        mov ebx, FD_STDOUT
        ;; mov edx, BUF_SIZE
        ;; mov ecx, inputBuffer
        mov ecx, inputBuffer
        mov edx, 1
        int 0x80
        
        inc edi
        jmp column_loop
        
    end_of_row_loop:
    
    ;; need to print a newline character when our column is complete
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, newline
    mov edx, 1
    int 0x80
    
    inc esi
    jmp row_loop
done:
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov edx, BUF_SIZE
    mov ecx, check
    int 0x80
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov eax, 1 ;; prep for sys exit call
    mov ebx, 0  ;; return 0 "sucess"
    int 0x80
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SYS_READ equ 3
SYS_WRITE equ 4
SYS_EXIT equ 1
FD_STDIN equ 0
FD_STDOUT equ 1
FD_STDERR equ 2
