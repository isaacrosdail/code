; 31.05.25

; Move val 42 into EAX register
mov 42, eax

; Add contents of ebx to eax
mov eax, ebx

; Compare eax with the value of 10
cmp eax, 10   ; here, if eax is 20, it would result in... "greater than" right?

; unconditional jump to label called "loop_start"
jmp loop_start

; jump to "done" if prev comparison was equal (ZF=1)
jz done

; Subtract 5 from EAX
sub eax, 5

; Move contents of memory address [EBX] into EAX
mov eax, [ebx]

; Store EAX into the memory location pointed to by ECX
mov [ecx], eax

; Increment EAX by 1 (use the increment instruction)
inc eax

; Push EAX onto the stack
push eax

; Pop the top of stack into EBX
pop ebx

; Call a function at label "my_function"
call my_function

; Return from a function
oof dont remember this one
A: ret

; Jump to "error_handler" if the carry flag is set
jc error_handler

; Zero out the EAX register (most efficient way)
xor eax ; cant remember! but i DO remember that mov eax, 0 is slow because it involves moving from memory, which you typically ideally wanna minimize!
A: xor eax, eax     ; XOR register with itself = 0, super fast!
                    ; this is cause XOR results in 0 for bits that match :P

; Multiply EAX by 2 using a shift operation
sl? eax, 2      ; haha dont remember by bit calcs
A: shl eax, 1   ; shift left by 1 bit (multiply by 2)

; EAX contains 12. Multiply by 8 using shifts
shl eax, 3      ; If shifting by 1 left INCREASES value by a factor of 2, then we need 2^3 right?

; EAX contains 32. Divide by 4 using shifts
shr eax, 2      ; So divide is the other direction, and we need 2^2 = 4 times less right??

; EAX contains 0x0F (15). What's the result after: shl eax, 4
240?            ; So we're moving left (Multiplying) by 2^4 = 16 right? So we'd have 15*16 = 240?

--------- ALL THREE OF THE ONES ABOVE WERE RIGHT -- LETS GOOOOOO!!!!! --------------

; You want to check if EAX is even or odd using bit operations
; (Hint: what's special about the least significant bit?)
Wouldnt we do something like shifting right by 1 and check the bit that fell off? 
if it was 1 -> that means even cause 2^1 = 2
if it was 0 -> that means odd cause  2^0 = 1 right?

; Extract just the lower 8 bits of EAX (like casting to byte)
I remember this is important when handling divisions/remainders! Not sure how!





