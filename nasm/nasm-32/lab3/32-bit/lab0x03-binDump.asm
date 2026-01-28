;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Taking ASCII input and outputting binary equivalent
;; 8 bytes wide
;; Uppercase 'A' -binary-> 01000001
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DEFINITIONS
    BYTES_PER_LINE equ 8        ;; how many bytes to print for each row of output
    SYS_READ equ 3
    SYS_WRITE equ 4
    STDIN equ 0
    STDOUT equ 1
    SYS_EXIT equ 1
    
section .data
    NEWLINE_BUF db 0x0A         ;; output buffer for newline character
    
section .bss
    INPUT_BUFFER resb 1024      ;; 1KB input buffer
    IN_BUF_SIZE equ $ - INPUT_BUFFER
    inputByteCount resb 4       ;; 'reserve 4 bytes for 32-bit int'
    OUTPUT_BUFFER resb 9        ;; sized for 8 binary digits and a space
    
section .text
    global _start
_start:
    
;; Line loop -- repeat for each line (buffer) of text
line_loop:
    mov eax, SYS_READ           ;; read a line/buffer of input
    mov ebx, STDIN
    mov ecx, INPUT_BUFFER
    mov edx, IN_BUF_SIZE
    int 0x80                    ;; Trigger SYS_READ
    
    cmp eax, 0                  ;; Checks whether SYS_READ buffer is empty (i.e., no more text to read)
    jle exit_line_loop          ;; Jumps if <= 0, exits the loop
    
    mov [inputByteCount], eax   ;; Saves byte count for input
    xor esi, esi                ;; Byte offset

byte_loop:
    ;; Position in the current line will be ---> INPUT_BUFFER + our offset (ESI count!)
    mov AL, [INPUT_BUFFER + esi]    ;; Copying next byte to convert to binary

    xor ebx, ebx                    ;; use EBX to track how many "bits in" we are
bit_loop:
    
    shl AL, 1                       ;; Shift one bit left, carry will be printed
    jc one_bit                      ;; If carry is 1
    mov byte [OUTPUT_BUFFER + ebx], '0' ;; If carry is 0
    jmp after_one_bit
    
one_bit:
    mov byte [OUTPUT_BUFFER + ebx], '1'  ;; if carry is 1, put 1 in buffer instead
after_one_bit:
    inc ebx
    cmp ebx, 8
    jl bit_loop
    
    mov byte [OUTPUT_BUFFER + 8], ' ' ;; space char after bit characters for this byte
 
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, OUTPUT_BUFFER
    mov edx, 9                      ;; Doing sys_write on 9 bytes (8 binary digits and a space)
    int 0x80                        ;; Trigger sys_write
    
    inc edi                         ;; Increment 'bytes printed' counter
    inc esi                         ;; increment the byte offset counter
    
    ;; If we've done a multiple of BYTES_PER_LINE, we want to print a newline character
    cmp edi, BYTES_PER_LINE
    jne after_print_newline         ;; Go back for next character
    
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1                      ;; Print newline character in newline_buffer
    int 0x80                        ;; Trigger sys_write
    
    xor edi, edi                    ;; Reset bytes printed counter to zero since we're moving to a new line

    inc esi                         ;; Increment "bits in" counter
    cmp esi, 8                      ;; Check whether we've reached the end of our byte
after_print_newline:    
    cmp esi, [inputByteCount]       ;; When esi = inputByteCount, we know we've printed the whole input line
                                    ;; ...at which point we can exit the byte loop and start a new line
    jl byte_loop
    
exit_byte_loop:                     ;; Label not needed, but makes it clear where our byte loop exits
    jmp line_loop                   ;; we've processed all input characters from the line, so jump back up to
                                    ;; read another line of inputByteCount
exit_line_loop:
    
    ;; Printing the extra lines to match xxd | tail output
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1                      ;; printing the one newline character in our newline_buffer
    int 0x80                        ;; trigger that sys_write
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1                      ;; printing the one newline character in our newline_buffer
    int 0x80                        ;; trigger that sys_write
    
    ;; Exit the program
    mov eax, SYS_EXIT
    mov ebx, 0
    int 0x80
