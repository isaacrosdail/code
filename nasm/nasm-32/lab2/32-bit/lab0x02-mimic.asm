
section .data
        
    
section .bss    

    BUF_SIZE equ 1024   ;;equ just defines a word to mean that number (we refer to it in line 12 with resb)
                        ;;does not allocate memory
    ;; define symbol for start of input buffer
    ;; block of 1024 bytes (1K)
    ;; resb -> "reserve bytes" & is used for uninitialized blocks of memory
    inputBuffer resb BUF_SIZE
    ;; Also resw (reserve word 2bytes), resd (reserve double word, 4bytes)
    inputByteCount resd 1   ;;reserving space for one int, same as "resb 4"

section .text
    extern _start
    
_start:

mimic_loop:
    ;; read line of text from user
    ;;firstly we need system call: sys_read
    mov eax, SYS_READ ;; code for this defined below
    mov ebx, FD_STDIN   ;;file descriptor (int) to represent stdin (defined below)
    mov ecx, inputBuffer    ;;address of loc in memory where we want to store the character (bytes) that we read in
    mov edx, BUF_SIZE   ;;tells sys_read the MAX number of bytes to read & store
                        ;;sys_read can read less than max (up to a newline character typically)
                        
    int 0x80    ;;interrupt to trigger sys_read system call that we setup above
    
    ;;How do we know how many characters it can read in?
    ;;sys_calls put their return value in register EAX
    ;;sys_read returns a count of how many it read in & stored
    
    ;;;; GOOD HABIT!!
    ;; if that return val is important, save it in a variable!
    mov [inputByteCount], eax   ;;copy num of bytes the sys_read stored to a safe place :P
    ;; REMEMBER: [] are used to reference contents of a memory location, whether as source or destination
    
    ;; after sys_read, if we hit end-of-file (or an error) let's exit the loop
    cmp dword [inputByteCount], 0  ;; only works if we haven't messed with EAX since the read
                             ;; when comparing number 0 to constant number stored in memory, what size are we looking at? Hence, the "dword" specifier is needed, because neiter memory location nor constants tell us how many bytes we're working with
    jle end_mimic_loop ;; less than or equal to 0 
    
    ;; print line back out
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, inputBuffer    ;; address of where the text to print starts
                            ;; yes, we can use the address of an input buffer as address of text to output
    mov edx, [inputByteCount]   ;; eax has count from sys_read, already have the sys_write code of 4 in eax
    int 0x80    ;; trigger sys_write
    
    ;; jump back & repeat (but exit if we reach end of file)
    jmp mimic_loop
end_mimic_loop: ;; similar to a "break"
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
    mov eax, 1      ;;Prep for sys_ext call
    mov ebx, 0      ;;Return "success"
    int 0x80        ;;Trigger the system call
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; defining some symbols

    SYS_READ    equ 3
    SYS_WRITE   equ 4
    SYS_EXIT    equ 1
    FD_STDIN    equ 0
    FD_STDOUT   equ 1
    FD_STDERR   equ 2
