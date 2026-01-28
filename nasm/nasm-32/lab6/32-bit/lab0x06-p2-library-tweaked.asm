
section .text
    global sumOfSumsAtoB_tweaked

sumOfSumsAtoB_tweaked:
	push ebp
	mov	ebp, esp
	sub	esp, 16
	mov ecx, DWORD [ebp+8]   ;; Copy A (1) into ECX (next number)
	xor eax, eax             ;; Clear EAX register
.L2:
    cmp ecx, [ebp+12]        ;; Compare new number to B (8)
    jg .L3
    add edx, ecx        ;; Add next number to previous sum
    add eax, edx        ;; Add previous sum to running total
    inc ecx             ;; Increment next number
    jmp .L2             ;; Jump to .L2 to repeat
.L3:    
    leave
    ret
