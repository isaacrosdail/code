
section .data
    newline db 0x0A
    
section .bss
    BUF_SIZE equ 1024           ;; size of input buffer
    inputBuffer resb BUF_SIZE   ;; input buffer
        
    inputByteCount resd 1       ;; variable for saving input btye count
    outputBuffer resd 1         ;; defines an output buffer, same size as input buffer

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
    
    ;; Strategy B: Loop to print 1 line at a time
    
    mov esi, [inputByteCount]   ;; using ESI for input characterPosition variable
    sub esi, 2                  ;; starting inputCharacterPosition at inputByteCount-1 (last char before newline)
    
    mov edi, 0                  ;; using EDI for output characterPosition, starts at 0 and goes up
reverse_buffer_loop:
    ;; sys write not needed in this loop for reverse B, unlike in reverse A
    ;; we're going to copy from one place to another, not print
    
    mov AL, [inputBuffer + esi] ;; copy the byte into 1-byte half-half register AL
    mov [outputBuffer + edi], AL    ;; copy the byte in AL to  the address in output buffer it needs to go to
    
    inc edi                     ;; inc the output (reverse) buffer offset (character position) counting up from 0
    dec esi                     ;; dec characterPosition (because reverse)
    cmp esi, 0
    jl end_reverse_buffer_loop  ;; you could avoid the compare and us JS (jump, if sign, negative)
    jmp reverse_buffer_loop
    
end_reverse_buffer_loop:
    ;; need to deal with newline character
    
    mov AL, [inputBuffer + edi] ;; after the above loop, EDI will be inputByteCount-1, the position of the newline
    mov [outputBuffer + edi], AL

    mov eax, SYS_WRITE          ;; prints the newline char
    mov ebx, FD_STDOUT
    mov ecx, outputBuffer       ;; printing from the output buffer now, whole line at a time
    mov edx, [inputByteCount]   ;; printing same number of bytes as we read in
    int 0x80                    ;; trigger sys_write
    
    ;; jump back & repeat (but exit if we reach end of file)
    jmp reverse_loop

end_reverse_loop:               ;; similar to a "break"
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
    mov eax, 1      ;;Prep for sys_ext call
    mov ebx, 0      ;;Return "success"
    int 0x80        ;;Trigger the system call
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Define symbols

    SYS_READ    equ 3
    SYS_WRITE   equ 4
    SYS_EXIT    equ 1
    FD_STDIN    equ 0
    FD_STDOUT   equ 1
    FD_STDERR   equ 2
