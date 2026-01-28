; Three sections we care about: .text, .data, .bss
; .text defines a section of memory for your program which will be read only
; .data reserves memory space for read/write data, defines initialized data (like data that prints out text 
;      strings)
; .bss used to define unitialized data areas that may be used for data variables etc

section .data

    ; Storing the data for the message here by defining bytes of data, with 0x0A being the hex val for number
    ; Loaded into memory beginning with first byte of .data section
    ; db is a pseudo-command in NASM and is purely for the assembler, not the machine, & denotes what follows as bytes  of data
	msgA db "And it's whispered that soon, if we all call the tune", 0x0A, \
	        "Then the piper will lead us to reason", 0x0A, \
	        "And a new day will dawn for those who stand", 0x20, 0x6c, 0x6f, 0x6e, 0x67, 10, \
	        "And the forests will echo with laughter", ".", 0x0A
	; We can force the assembler to figure out the number of bytes of data listed after the msg label
    ; msgAlen is a symbol for a number, equ is a pseudo-command for NASM to define val of msgAlen ("equals")
    ; $ denotes the address of the next byte of data / instruction in the program       
    msgAlen equ $ - msgA
    
    msgB db "Are we human, or are we dancer?", 0x0A
    msgBlen equ $ - msgB
    
section .text

    global _start   ; Use "global" to make the linker aware of labels
    
_start: ; Colon is optional, byte can be on a different line

    ; We're moving data from one place to another with mov as setup for the int command, which halts the program
    mov eax, 4  ; Copying int 4 into EAX register, which denotes "write" when interrupt occurs
    mov ebx, 1  ; "file descriptor"? Copying int 1 into EBX register, which denotes "stdout"
    mov ecx, msgA   ; Copying the address denoted by label msgA into register ECX
                    ; Interrupt looks to ECX to find the starting address when processing the "write" command
    mov edx, msgAlen    ; Copying 181, number of bytes, into register EDX
                    ; Needs to know how many bytes to write, which we put in EDX
    int 0x80    ; "int" triggers an interrupt of type 0x80
    
    ; System calls: requests from a program to the OS to do stuff. Needed because the OS controls access to hardware.
    ; Usually system calls are made via library functions, like <printf>
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; MOST / ALL programs will need to end with the following 3 instructions!
    
    mov eax, 1  ; 1 is code for sys_exit() system
    mov ebx, 0  ; 0 in EBX is the return code - indicating successful execution/completion
                ; equivalent to return 0 from main() in C
    int 0x80    ; Trigger interrupt that will examine register EAX and execute
                ; an exit() system call
    
    
    
    
    ;; Challenge: Setup another "write" to print msgB
    mov eax, 4
    mov ebx, 1
    mov ecx, msgB
    mov edx, msgBlen
    int 0x80 ; Triggers second write command
    ;; End Challenge
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
