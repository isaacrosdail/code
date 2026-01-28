
section .data
	msgA db "What is recursion?", 0x0A
    msgAlen equ $ - msgA
    
section .text
    global _start       ;; Global makes linker aware of labels

_start:
    mov eax, 4          ;; "write"
    mov ebx, 1          ;; "stdout"
    mov ecx, msgA       ;; address of msgA
    mov edx, msgAlen
    int 0x80            ;; Trigger interrupt
    
    jmp _start          ;; Return to start continually loop

;; Exit process, which is never reached here   
    mov eax, 1  ; 1 is code for sys_exit() system
    mov ebx, 0  ; Return code '0' in EBX, same as return 0 from main() in C
    int 0x80    ; Trigger exit()
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
