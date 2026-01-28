
section .data
    NEWLINE_BUF db 0x0A
	msgA db "12", 0x0A
    msgAlen equ $ - msgA
    
section .text
    global _start
    
_start:
    mov esi, 1
print_loop:

    ;; Break loop when no. of times printed = length of message
    cmp esi, msgAlen
    je end_print_loop
    
    ;; Print out one instance of msgA
    mov eax, 4
    mov ebx, 1
    mov ecx, msgA
    mov edx, msgAlen    
    int 0x80
    
    ;; Increment counter for loop & jump
    inc esi
    jmp print_loop

;; Print a newline character and exit the program
end_print_loop:
    mov eax, 4
    mov ebx, 1
    mov ecx, NEWLINE_BUF
    mov edx, 1    
    int 0x80
    
    mov eax, 1  ;; sys_exit() code
    mov ebx, 0  ;; Return 0 code
    int 0x80    ; Trigger interrupt
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
