;; Define the _replaceChar and _sumListAndPrint functions
section .bss

section .text
    ;; Global makes functions visible to linked files/programs
    global _replaceChar
    global _sumAndPrintList

;; Function to replace searchChar with desired repChar
_replaceChar:
    ;; Callee setup
    push ebp            ;; Save old call frame
    mov ebp, esp        ;; Initialize new call frame
    sub esp, 120        ;; Reserve bytes needed for local variables
    push ebx            ;; Save non-volatile registers
    push esi
    push edi
    ;; Accessing desired values & pointers
    mov edx, [ebp + 8]  ;; Value for textPtr and list pointers
    mov ecx, [ebp + 12] ;; Value for length of array
    mov eax, [ebp + 16] ;; Value for searchChar
    mov ebx, [ebp + 20] ;; Value for repChar
    xor esi, esi        ;; Reset loop counter
    xor edi, edi        ;; Number of characters replaced counter counter
    
;; Loop through textPtr/list and compare characters to searchChar, replace if match
search_loop:
    cmp byte [edx], AL  ;; Compare current letter to searchChar
    je replace          ;; Jump to replace if equal
    
    inc edx             ;; Inc address for next character
    inc esi             ;; Inc counter for loop
    cmp esi, ecx        ;; If equal -> end of line/input
    je end_search_loop
    jne search_loop
    
replace:
    ;; Replace character with repChar (stored in BL register)
    mov [edx], BL       ;; Replace byte with repChar
    inc edi             ;; Increment counter for number of characters replaced
    inc edx             ;; Increment counters for memory address, loop
    inc esi
    jmp search_loop     ;; Continue search_loop
    
end_search_loop:
    mov eax, edi        ;; Copy return value to EAX register
    pop edi             ;; Restore non-volatile registers
    pop esi
    pop ebx
    add esp, 120        ;; Release local variables space from the stack
    pop ebp             ;; Restore EBP register
    ret                 ;; Return
    
_sumAndPrintList:
    push ebp            ;; Save old call frame
    mov ebp, esp        ;; Initialize new call frame
    sub esp, 120        ;; bytes needed for local variables
    push ebx            ;; Save non-volatile registers
    push esi
    push edi
    ;; Accessing desired values & pointers
    mov edx, [ebp + 8]    ;; intList address
    mov ecx, [ebp + 12]   ;; count value    
    xor esi, esi          ;; Reset loop counter
    xor edi, edi          ;; Reset sum register

;; Loop to sum list values
sum_loop:
    cmp esi, ecx            ;; Compare loop counter to number of elements in list
    je exit_sum_loop        ;; Break when equal
    add edi, [edx + 4*esi]     ;; Add value of intList[esi] to edi
    inc esi
    jmp sum_loop

exit_sum_loop:
    mov eax, edi        ;; Copy return value to EAX register
    pop edi             ;; Restore non-volatile registers
    pop esi
    ;pop ebx
    pop edx ;;OOPSIES
    add esp, 120        ;; Release local variables space from the stack
    pop ebp             ;; Restore EBP register
    ret                 ;; Return
    
    
    
    
    
    
    
    
    
    
    
    
