
;; Definitions
    SYS_READ equ 3
    SYS_WRITE equ 4
    STDIN equ 0
    STDOUT equ 1
    SYS_EXIT equ 1
    
section .data
    fail_klammern db "Invalid. ')' expected."
    error_STACK_NOT_EMPTY db "Input ended with open '('"
section .bss
    inBuff resb 1024
    outBuff resb 1024
    
    inBuff_Size equ $ - inBuff
    outBuff_Size equ $ - inBuff
    
    inputByteCount resb 4
section .text
    global _start

_start:
    push 1  ;; end of stack marker value
;; Loop to store input text
input_loop:
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, inBuff
    mov edx, inBuff_Size
    int 0x80

    cmp eax, 0  ;; check whether SYS_READ buffer is empty -> no more text
    jle check_stack_not_empty ;; jump if empty
    
    mov [inputByteCount], eax   ;; Store input byte count
    
    ;; Reset counter for loop
    pre_byte_loop:
        xor esi, esi
    ;; Loop to check symbols
    byte_loop:
        mov AL, [inBuff + esi]  ;; next byte to compare
        
        inc esi     ;; increment counter POTENTIALLY MOVE ELSEWHERE?
        
        ;; If (
        cmp AL, '('
        je open_klammern
        ;; If )
        cmp AL, ')'
        je close_klammern
        
        ;; If text, keep going
        cmp esi, [inputByteCount]   ;; check if we've reached end of inBuff?
        je exit_input_loop
        jmp byte_loop
         
    open_klammern:
        push dword [inBuff + esi] ;; push ( to stack
        ;; inc esi
        jmp byte_loop
        
    close_klammern:
        pop ebx ;; pop top of stack to ebx
        cmp ebx, '('    ;; compare to open klammern
        je byte_loop    ;; if pass, keep going
        jmp klammern_fail
        
    klammern_fail:
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, fail_klammern
        mov edx, 22
        int 0x80
check_stack_not_empty:
    pop ebx ;;pop stack to ebx register
    cmp ebx, 1
    jne exit_input_loop     ;; if it's not 1 -> stack is not empty
    
error_stack_not_empty:

    mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, error_STACK_NOT_EMPTY
        mov edx, 25
        int 0x80

exit_input_loop:

;; Exit the program
_exit:
    mov eax, SYS_EXIT
    mov ebx, 0
    int 0x80
