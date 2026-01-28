
;; Definitions
    SYS_READ equ 3
    SYS_WRITE equ 4
    STDIN equ 0
    STDOUT equ 1
    SYS_EXIT equ 1
    
section .data
    NEWLINE_BUF db 0x0A
    klammern db ")'."
    curly db "}'."
    bracket db "]'."
    
    ;; Success Message
    msg_success db "All brackets are balanced."
    ;; Mismatch Messages
    error_mismatch_klammern db "Expected a ')' but got a '"
    error_mismatch_curly db "Expected a '}' but got a '"
    error_mismatch_bracket db "Expected a ']' but got a '"
    mismatchLen equ $ - error_mismatch_klammern
    ;; Failure to Match Messages
    error_matchfail_klammern db "Input ended with an unmatched open '('."
    error_matchfail_bracket db "Input ended with an unmatched open '['."
    error_matchfail_curly db "Input ended with an unmatched open '{'."
    ;; Unmatched Open Symbol Messages
    klammern_no_open db "Found a ')' but there was no open '(' for it to match."
    bracket_no_open db "Found a ']' but there was no open '[' for it to match."
    curly_no_open db "Found a '}' but there was no open '{' for it to match."
    ;; Input Ending Inside Quotes Message
    error_end_inside_quotes db "Reached end of input inside a quotation."

section .bss
    inBuff resb 1024
    inBuff_Size equ $ - inBuff
    outBuff resb 1024
    outBuff_Size equ $ - inBuff
    
    stackVal resw 1
    inputByteCount resb 4
    
section .text
    global _start

_start:
    ;; Push end of stack marker val with padded 0s
    xor AX, AX
    mov AX, 1           ;; TWO BYTES
    push AX
    
;; Loop to store input text
input_loop:
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, inBuff
    mov edx, inBuff_Size
    int 0x80

    cmp eax, 0  ;; check whether SYS_READ buffer is empty -> no more text
    jle check_stack_not_empty ;; jump if empty
    
    sub eax, 1 ;; ??????
    mov [inputByteCount], eax   ;; Store input byte count
    
    xor esi, esi ;; Reset counter for loop

    ;; Loop to check symbols
    check_loop:
        mov AL, [inBuff + esi]  ;; next byte to compare
        
        ;; End of string
        cmp esi, [inputByteCount]
        je check_stack_not_empty
        
        ;; If single quote
        cmp AL, 0x27
        je single_quotes
        ;; If double quote
        cmp AL, '"'
        je double_quotes
        
        ;; OPENING SYMBOLS
        ;; If (
        cmp AL, '('
        je open_symbol
        ;; If {
        cmp AL, '{'
        je open_symbol
        ;; If [
        cmp AL, '['
        je open_symbol
        
        ;; CLOSING SYMBOLS
        ;; If )
        cmp AL, ')'
        je close_klammern
        ;; If }
        cmp AL, '}'
        je close_curly  
        ;; If ]
        cmp AL, ']'
        je close_bracket
        
        ;; Else, keep going
        jmp next
    
    single_quotes:
        ;; increment
        inc esi
        
        mov AL, [inBuff + esi]  ;; next byte to compare
        
        ;; Break condition
        cmp AL, 0x27
        je single_quotes_break
        ;; End of string
        cmp esi, [inputByteCount]
        je end_inside_quotes
        
        jmp single_quotes
        
    single_quotes_break:
        inc esi
        jmp check_loop
        
    double_quotes:
        ;; increment
        inc esi
        
        mov AL, [inBuff + esi]  ;; next byte to compare
        
        ;; Break condition
        cmp AL, '"'
        je double_quotes_break
        ;; End of string
        cmp esi, [inputByteCount]
        je end_inside_quotes
        
        jmp double_quotes
        
    double_quotes_break:
        inc esi
        jmp check_loop
        
    ;; Push ( to stack
    open_symbol:
        mov [stackVal], AL
        push word [stackVal]
        ;;push AL
        inc esi
        jmp check_loop
    
    closing_symbol:
        ;;pop AX
        ;;cmp AL, []
    close_klammern:
        pop AX ;; pop top of stack to AX
        ;; If something like ()}
        cmp AL, 1
        je error_no_open
        ;; If something like (]
        cmp AL, '('    ;; compare to open klammern
        jne mismatch    ;; NON MATCH ERROR
        inc esi
        jmp check_loop
    close_curly:
        pop AX ;; pop top of stack to ebx
        ;; If something like ()}
        cmp AL, 1
        je error_no_open
        ;; If something like (]
        cmp AL, '{'    ;; compare to open curly
        jne mismatch    ;; NON MATCH ERROR
        inc esi
        jmp check_loop    
    close_bracket:
        pop AX ;; pop top of stack to ebx
        ;; If something like ()}
        cmp AL, 1
        je error_no_open
        ;; If something like (]
        cmp AL, '['    ;; compare to open bracket
        jne mismatch    ;; NON MATCH ERROR
        inc esi
        jmp check_loop
                 
    ;; Encounters regular text
    next:
        inc esi
        jmp check_loop
    
    print_mismatch:
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, [outBuff]
        mov edx, outBuff_Size
        int 0x80
        ret
        ;;jmp exiting
    mismatch:
        cmp AL, '('
        je expected_klammern
        cmp AL, '{'
        je expected_curly
        cmp AL, '['
        je expected_bracket
        
    expected_klammern:
        
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, error_mismatch_klammern
        mov edx, 26
        int 0x80
        
        cmp byte [inBuff + esi], ']'
        je found_close_bracket
        cmp byte [inBuff + esi], '}'
        je found_close_curly
        
        ;;call print_mismatch
        jmp exiting
    found_close_bracket:
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, bracket
        mov edx, 3
        int 0x80
        jmp exiting
        
    found_close_curly:
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, curly
        mov edx, 3
        int 0x80
        jmp exiting
        
    found_close_paren:
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, klammern
        mov edx, 3
        int 0x80
        jmp exiting
        
    expected_curly:
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, error_mismatch_curly
        mov edx, 26
        int 0x80
        
        cmp byte [inBuff + esi], ')'
        je found_close_paren
        cmp byte [inBuff + esi], ']'
        je found_close_bracket
        
        jmp exiting
        
    expected_bracket:
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, error_mismatch_bracket
        mov edx, 26
        int 0x80
        
        cmp byte [inBuff + esi], ')'
        je found_close_paren
        cmp byte [inBuff + esi], '}'
        je found_close_curly
        
        jmp exiting

;; DELETE????
check_empty_stack:
    pop BX ;;pop stack to ebx register
    cmp BL, 1
    jne error_no_open     ;; if it's not 1 -> stack is not empty
    cmp AL, 1
    jne error_no_open
    ret
;; If something like ()}
error_no_open:
    cmp byte [inBuff + esi], ')'
    je close_paren_no_open
    cmp byte [inBuff + esi], '}'
    je close_curly_no_open
    cmp byte [inBuff + esi], ']'
    je close_bracket_no_open

close_paren_no_open:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, klammern_no_open
    mov edx, 54
    int 0x80
    
    jmp exiting
close_curly_no_open:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, curly_no_open
    mov edx, 54
    int 0x80
    
    jmp exiting
close_bracket_no_open:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, bracket_no_open
    mov edx, 54
    int 0x80
    
    jmp exiting
check_stack_not_empty:
    pop BX ;;pop stack to ebx register
    cmp BL, 1
    je success     ;; if it's not 1 -> stack is not empty
    cmp AL, 1
    je success
    jmp unmatched
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UNMATCHED OPEN ERROR
unmatched:
    cmp BL, '{'
    je curly_unmatched
    cmp BL, '('
    je klammern_unmatched
    cmp BL, '['
    je bracket_unmatched
klammern_unmatched:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, error_matchfail_klammern
    mov edx, 39
    int 0x80    
    jmp exiting
curly_unmatched:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, error_matchfail_curly
    mov edx, 39
    int 0x80    
    jmp exiting
bracket_unmatched:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, error_matchfail_bracket
    mov edx, 39
    int 0x80    
    jmp exiting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end_inside_quotes:

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, error_end_inside_quotes
    mov edx, 40
    int 0x80
    
    jmp exiting
    
success:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg_success
    mov edx, 26
    int 0x80

exiting:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1
    int 0x80
    
exit_input_loop:

;; Exit the program
_exit:
    mov eax, SYS_EXIT
    mov ebx, 0
    int 0x80
