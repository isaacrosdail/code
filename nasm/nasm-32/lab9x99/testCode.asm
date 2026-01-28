
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; READS LINES OVER AND OVER UNTIL A BLANK LINE IS GIVEN

;;textPtr:
;read_loop to read lines of text until the user enters a blank line, with prompt OUTSIDE loop    
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, prompt_text
    mov edx, prompt_text_size
    int 0x80
    
    xor esi, esi
read_loop:
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, input
    mov edx, input_size
    int 0x80
    
    cmp byte [input], 10
    je end_read_loop
    
    jmp read_loop
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
