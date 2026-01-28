
section .data
        
    
section .bss    

    BUF_SIZE equ 1024           ;; size of input buffer
    inputBuffer resb BUF_SIZE   ;; input buffer
    
    inputByteCount resd 1       ;; variable for saving input btye count

section .text

    extern _start
    
_start:


reverse_loop:
    
    mov eax, SYS_READ           ;; setup sys_read
    mov ebx, FD_STDIN   
    mov ecx, inputBuffer   
    mov edx, BUF_SIZE   
    int 0x80            
    mov [inputByteCount], eax   ;; save byte count of the read
    
    cmp dword [inputByteCount], 0  ;; break if end of file
    jle end_reverse_loop
    
    ;; Strategy A: Loop to print 1 char at a time
    ;; First char to print is last char read (except newline char)
    ;; so its position will be inputByteCount-2 (newline will be at inputByteCount-1) *-1/-2 to avoid index0 problems
    mov esi, [inputByteCount]   ;; using ESI for characterPosition variable
    sub esi, 2                  ;; starting characterPosition at inputByteCount-1 (last char before newline)
    
single_char_loop:
    mov eax, SYS_WRITE      ;; prints a single char (reverse order)
    mov ebx, FD_STDOUT
    mov ecx, inputBuffer    ;; want inputBuffer + characterPosition
    add ecx, esi            ;; add characterPosition to start address of inputBuffer
                            ;; this gives us address of the char we want to prin
    mov edx, 1              ;; only want to print 1 char at a time
    int 0x80                ;; trigger sys_write
    
    dec esi                 ;; dec characterPosition (because reverse)
    cmp esi, 0
    jl end_single_char_loop ;; you could avoid the compare and us JS (jump, if sign, negative)
    jmp single_char_loop
    
end_single_char_loop:
    
    ;; need to print newline char 
    mov esi, inputBuffer
    add esi, [inputByteCount]
    dec esi                 ;; address of newline char should be: inputBuffer + inputByteCount - 1

    mov eax, SYS_WRITE      ;; prints the newline char
    mov ebx, FD_STDOUT
    mov ecx, esi            ;; want inputBuffer + characterPosition
    mov edx, 1              ;; only want to print 1 char at a time
    int 0x80                ;; trigger sys_write
    
    ;; jump back & repeat (but exit if we reach end of file)
    jmp reverse_loop
end_reverse_loop:           ;; similar to a "break"
    
    
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
