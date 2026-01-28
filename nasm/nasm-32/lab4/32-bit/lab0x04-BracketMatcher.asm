
;; Definitions
    SYS_READ equ 3
    SYS_WRITE equ 4
    STDIN equ 0
    STDOUT equ 1
    SYS_EXIT equ 1
    
section .data
    NEWLINE_BUF db 0x0A
    parentheses db ")'."
    curly db "}'."
    bracket db "]'."
    
    ;; Success Message
    msg_success db "All brackets are balanced."
    ;; Mismatch Messages
    error_mismatch_parentheses db "Expected a ')' but got a '"
    error_mismatch_curly db "Expected a '}' but got a '"
    error_mismatch_bracket db "Expected a ']' but got a '"
    mismatchLen equ $ - error_mismatch_parentheses
    ;; Failure to Match Messages
    error_matchfail_parentheses db "Input ended with an unmatched open '('."
    error_matchfail_bracket db "Input ended with an unmatched open '['."
    error_matchfail_curly db "Input ended with an unmatched open '{'."
    ;; Unmatched Open Symbol Messages
    parentheses_no_open db "Found a ')' but there was no open '(' for it to match."
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

;; Loop to store input text
input_loop:
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, inBuff
    mov edx, inBuff_Size
    int 0x80

    cmp eax, 0                  ;; Check & Jump if sys_read is empty
    jle check_stack_not_empty
    
    sub eax, 1
    mov [inputByteCount], eax   ;; Store input byte count
    xor esi, esi                ;; Reset loop counter

;; Loop to check symbols
check_loop:
    mov AL, [inBuff + esi]      ;; Grab next byte to compare
        
    ;; Check for end of string
    cmp esi, [inputByteCount]
    je check_stack_not_empty
    
    cmp AL, 0x27                ;; If single quote
    je single_quotes

    cmp AL, '"'                 ;; If double quote
    je double_quotes    
        
    ;; OPENING SYMBOLS
    cmp AL, '('
    je open_symbol
    cmp AL, '{'
    je open_symbol
    cmp AL, '['
    je open_symbol
        
    ;; CLOSING SYMBOLS
    cmp AL, ')'
    je close_parentheses
    cmp AL, '}'
    je close_curly  
    cmp AL, ']'
    je close_bracket
       
    ;; Else, keep going
    jmp next
    
single_quotes:
    inc esi                     ;; Increment counter
    mov AL, [inBuff + esi]      ;; Grab next byte to compare

    ;; Break loop upon second single quote
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
    inc esi                     ;; Increment counter
    mov AL, [inBuff + esi]      ;; Grab next byte to compare
       
    ;; Break loop upon second double quote
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
    inc esi
    jmp check_loop
    
close_parentheses:
    pop AX ;; pop top of stack to AX
    ;; If something like ()}
    cmp AL, 1
    je error_no_open
    ;; If something like (]
    cmp AL, '('    ;; compare to open parentheses
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

mismatch:
    cmp AL, '('
    je expected_parentheses
    cmp AL, '{'
    je expected_curly
    cmp AL, '['
    je expected_bracket
        
expected_parentheses:
        
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, error_mismatch_parentheses
    mov edx, 26
    int 0x80
        
    cmp byte [inBuff + esi], ']'
    je found_close_bracket
    cmp byte [inBuff + esi], '}'
    je found_close_curly

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
    mov ecx, parentheses
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
    mov ecx, parentheses_no_open
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
    pop BX
    cmp BL, 1
    je success     ;; If it's not 1 -> stack is not empty
    cmp AL, 1
    je success
    jmp unmatched

;; Unmatched open symbol errors
unmatched:
    cmp BL, '{'
    je curly_unmatched
    cmp BL, '('
    je parentheses_unmatched
    cmp BL, '['
    je bracket_unmatched
parentheses_unmatched:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, error_matchfail_parentheses
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
    
;; End of input while inside quotation
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

;; Exit the program
_exit:
    mov eax, SYS_EXIT
    mov ebx, 0
    int 0x80
