;; Symbol definitions
    SYS_READ    equ 3
    SYS_WRITE   equ 4
    SYS_EXIT    equ 1
    FD_STDIN    equ 0
    FD_STDOUT   equ 1
    FD_STDERR   equ 2
    
section .data
    newline db 0x0A
    
    prompt db "Enter a character to make a triangle out of:", 0x0A
    prompt_size equ $ - prompt
    accept db "Okay! Here's your triangle:", 0x0A
    accept_size equ $ - accept
    error_len db "Please enter 1 character.", 0x0A
    error_len_size equ $ - error_len
    
section .bss
    buffSize equ 1024     
    inBuff resb buffSize
    
    inputByteCount resd 1       ;; Stores input byte count
    outputBuffer resd 1         ;; Allocating memory for output buffer

section .text
    global _start
    
_start:
    ;; print prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_size
    int 0x80
    ;; read input
    mov eax, 3
    mov ebx, 0
    mov ecx, inBuff
    mov edx, buffSize 
    int 0x80
    
    dec eax
    cmp eax, 1          ;; Error if input was anything other than exactly 1 character long
    jne error_length
    
    ;; "Okay, here is your triangle!"
    mov eax, 4
    mov ebx, 1
    mov ecx, accept
    mov edx, accept_size
    int 0x80
    
    xor esi, esi        ;; Counter for no. of lines printed

triangle_loop:
    xor edi, edi        ;; Counter for line_loop
    inc esi             ;; Increment esi each line, and break when we've printed 42    
    cmp esi, 43
    je exit
    
line_loop:
    inc edi             ;; Increment counter for number of characters printed this line
    
    mov eax, 4          ;; Print entered character once
    mov ebx, 1
    mov ecx, inBuff
    mov edx, 1 
    int 0x80
    
    cmp edi, esi        ;; Check whether proper no. of characters has been printed this line
    jne line_loop
    
;; Print newline then return to triangle_loop
    call print_newline
    jmp triangle_loop
    
print_newline:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    
    ret
error_length:
    ;; Print error
    mov eax, 4
    mov ebx, 1
    mov ecx, error_len
    mov edx, error_len_size
    int 0x80
end_triangle_loop:
    call print_newline
;; Exit the program
exit:
    mov eax, 1      ;;Prep for sys_ext call
    mov ebx, 0      ;;Return "success"
    int 0x80        ;;Trigger the system call


