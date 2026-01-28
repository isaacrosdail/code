;; .bss: Uninitialized data (variables)

section .data
    ;; Initialized data, messages, with newline (0x0A) after each
	msgA db "And it's whispered that soon, if we all call the tune", 0x0A, \
	        "Then the piper will lead us to reason", 0x0A, \
	        "And a new day will dawn for those who stand", 0x20, 0x6c, 0x6f, 0x6e, 0x67, 10, \
	        "And the forests will echo with laughter", ".", 0x0A
    ;; "equ $ -": "msgAlen equals current location counter minus location counter of msgA"
    msgAlen equ $ - msgA
    msgB db "Are we human, or are we dancer?", 0x0A
    msgBlen equ $ - msgB
    msgC db "", 0x0A
    msgClen equ $ - msgC
    
section .text
    global _start   ; Global makes linker aware of labels
    
_start:
;; Copying data required for interrupt from one place to another with mov
    mov eax, 4          ;; Copies integer '4' to EAX (denotes "write")
    mov ebx, 1          ;; Copies integer '1' to EBX (denotes "stdout")
    mov ecx, msgA       ;; Copies the address denoted by label msgA to ECX
                        ;; Interrupt reads ECX for start address for "write"
    mov edx, msgAlen    ;; Copies '181' to EDX (denotes number of bytes)
                        ;; Needs to know how many bytes to write
    int 0x80            ;; Triggers interrupt of type 0x80
    
    ;; Printing the second message
    ;; Challenge: Setup another "write" to print msgB
    mov eax, 4
    mov ebx, 1
    mov ecx, msgB
    mov edx, msgBlen
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, msgC
    mov edx, msgClen
    int 0x80
    
;; System calls: Request for OS to do stuff, needed as OS controls access to hardware.
;; Usually made via library functions, like <printf>
;; Exiting Stuff ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov eax, 1  ; 1 is code for sys_exit() system
    mov ebx, 0  ; 0 in EBX is the return code - indicating successful execution/completion
                ; equivalent to return 0 from main() in C
    int 0x80    ; Trigger exit() sys_call from EAX
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
