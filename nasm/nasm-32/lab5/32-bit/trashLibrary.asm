;; Define the _replaceChar function
section .bss

section .text
    ;; Global makes functions visible to linked files/programs
    global _replaceChar
    global _sumAndPrintList

;; Function to replace searchChar with desired repChar
_replaceChar:
;; Callee setup (1:51:33 timestamp in video)
    push ebp        ;; Save old call frame
    mov ebp, esp    ;; Initialize new call frame
    sub esp, 120     ;; bytes needed for local variables
;; Save registers not allowed to change
    push ebx
    push esi
    push edi

;; Callee does whatever it does (4:02:32 timestamp in video)
;; Moving stuff to access it :P
    mov edx, [ebp + 8]  ;; textPtr address
    mov ecx, [ebp + 12] ;; length value
    mov eax, [ebp + 16] ;; searchChar character
    mov ebx, [ebp + 20] ;; repChar character
    
    xor esi, esi    ;; Reset loop counter
    xor edi, edi    ;; counter for number of bytes replaced
    
;; Traverse input, compare to searchChar
search_loop:
    cmp byte [edx], AL  ;; Compare current letter to searchChar
    je replace          ;; Jump to replace if equal
    
    inc edx             ;; Inc address for next character
    inc esi             ;; Inc counter for loop
    
    cmp esi, ecx        ;; If equal -> end of line/input
    je end_search_loop
    jne search_loop
    
replace:
    ;; BL for repChar
    mov [edx], BL       ;; Replace byte with repChar
    inc edi             ;; Inc counter for no. of bytes replaced
    jmp search_loop
    
end_search_loop:
    ;; Put return value in eax
    mov eax, edi
    ;;CHANGE FROM ESI TO EDI MAKE SURE THIS WORKS WITH ASSEMBLY VERSION
    ;; Restore used registers
    pop edi
    pop esi
    pop ebx
    ;; Release local variables space from the stack
    add esp, 120
    ;; Restores ebp
    pop ebp
    ;; Return
    ret ;; go back to where we called the function from
    
_sumAndPrintList:
    push ebp        ;; Save old call frame
    mov ebp, esp    ;; Initialize new call frame
    sub esp, 120    ;; bytes needed for local variables
    push ebx        ;; Save registers
    push esi
    push edi

;; Moving stuff to access it :P
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
;; Put return value (sum of list) in eax
    mov eax, edi
;; Restore used registers
    pop edi
    pop esi
    pop edx
;; Release local variables space from the stack
    add esp, 120
;; Restores ebp
    pop ebp    
;; Return, go back to where we called the function from
    ret
    
    
    
    
    
    
    
