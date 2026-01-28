;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Input file like this:
;; ABCDE
;; FGHIJKLMNOPQR
;; STUVWYXZ
;; Should produce output like this:
;; 41 42 43 44 45 0A 46 47
;; 48 49 4A 4B 4C 4D 4E 4F
;; 50 51 52 53 54 0A 55 56
;; 57 58 59 5A 5B 5C 0A

;; Essentially, we're taking ASCII input and outputting the equivalent HEX version
;; So, ASCII 'A' is '41' in hex. The '0A' here are the 'newline'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; uppercase 'A': binary --> 0100 0001 --> hex 41
;; 'If you have 4 and you add it to the Hex code of ASCII '0', you'll get the ASCII code of the character 4'
;; So,  ASCII code of '4' () + ASCII code of '0' (48)
;;                     4              +           48     =    52 (ASCII code of '4')
;; As long as the number is 0-9, we add it to 48 to get the ASCII code

;; DEFINITIONS
    BYTES_PER_LINE equ 8 ;; how many hex bytes to print for each row of output
    SYS_READ equ 3
    SYS_WRITE equ 4
    STDIN equ 0
    STDOUT equ 1
    SYS_EXIT equ 1
    
section .data
    NEWLINE_BUF db 0x0A    ;; output buffer for just a newline character
    
section .bss
    INPUT_BUFFER resb 1024    ;;1KB input buffer
    IN_BUF_SIZE equ $ - INPUT_BUFFER
    inputByteCount resb 4  ;; 'reserve 4 bytes for 32-bit int' use 32-bit integers unless you have a good reason not to
    OUTPUT_BUFFER resb 3  ;; output buffer big enough for just 2 hex digits and a space
    
section .text
    global _start
_start:
    
    ;; Line loop -- repeat for each line (buffer) of text
line_loop:
    mov eax, SYS_READ   ;; read a line/buffer of input
    mov ebx, STDIN
    mov ecx, INPUT_BUFFER
    mov edx, IN_BUF_SIZE
    int 0x80            ;; trigger the sys_read setup above
    
    cmp eax, 0          ;; basically checks whether the SYS_READ buffer is empty (i.e., no more text to read)
                        ;; then exits the loop
    jle exit_line_loop  ;; jumps if <= 0
    
    mov [inputByteCount], eax   ;; Save the input byte count
    
    ;; Byte loop within the above line loop -- repeat for each input byte in the input buffer
    
    xor esi, esi    ;; initialize ESI to 0 with xor to use ESI as byte offset 
                    ;; (track where we are in the current line)
byte_loop:
    ;; Convert the current byte to Hex, then put it in the output buffer
    ;; Address INPUT_BUFFER is going to be the starting byte address of our buffer of input bytes
    ;; So our position in the current line will be ---> INPUT_BUFFER + our offset (ESI count!)
    mov AL, [INPUT_BUFFER + esi]    ;; Copying the next byte to convert into AL register
                                    ;; We need to look at two 4-bit chunks (aka nibbles) of this byte
                                    ;; Each hex digit corresponds to a 4-bit chunk of a byte
                                    ;; So, we need to break this down into two 4-bit nibbles
    mov AH, AL                      ;; Make a copy of the byte -- use AL for one nibble, and AH for the other nibble
    AND AL, 0x0F                    ;; Masking register AL to get the low order nibble
                                    ;; 0x0F = 0000 1111
                                    ;; When a bit is AND'ed with 0, it is always zero
                                    ;; When a bit is AND'ed with 1, it is the same
                                    ;; So, here if we AND the binary for A (0100 0001), we get (0000 0001)
                                    ;; This let's us then cut off the first nibble and leaves us with the last :P
    shr AH, 4                       ;; Shifting register AH 4 bits to the right to get the higher order nibble
    
    ;; Now we need to get the ASCII codes for these hex digits (if AL contains '3', we need the ASCII for numeral 3)
    cmp AL, 10                      ;; check if the nibble is < 10
    jae low_nibble_hex_AtoF                    ;; jump if in range 10-15 for hex digit A-F
    ;; hex 0-9
    add AL, '0'                     ;; add ASCII code of character '0' to the nibble value
                                    ;; single character inside single quotes is NOT text, represents the number 48
                                    ;; So, '0' is treated as the ASCII for 0
                                    ;; Same as 48, same as 0x30, same as 0011000
    jmp low_nibble_skip_AtoF  
low_nibble_hex_AtoF:
    add AL, 0x37                    ;; adding the nibble value to 10 less than ASCII character 'A'   
low_nibble_skip_AtoF:
    ;; At this point we know AL contains the ASCII code to the hex digit for the lower order nibble of the byte
    ;; Now we do the same thing for the high order nible value in AH
    
    cmp AH, 10                      ;; check if the nibble is < 10
    jae high_nibble_hex_AtoF                    ;; jump if in range 10-15 for hex digit A-F
    ;; hex 0-9
    add AH, '0'                     ;; add ASCII code of character '0' to the nibble value
                                    ;; single character inside single quotes is NOT text, represents the number 48
                                    ;; So, '0' is treated as the ASCII for 0
                                    ;; Same as 48, same as 0x30, same as 0011000
    jmp high_nibble_skip_AtoF  
high_nibble_hex_AtoF:
    add AH, 0x37                    ;; adding the nibble value to 10 less than ASCII character 'A'   
high_nibble_skip_AtoF:
    ;; At this point we know AH contains the ASCII code to the hex digit for the high order nibble of the byte
    
    ;; Now we need to print those ASCII text characters for the hex digits, and a space/newline after them
    ;; sys_write needs those bytes in memory to do its thing
    ;; writing to EAX without copying AH / AL to output buffer would destroy its contents, which would be sad :(
    mov [OUTPUT_BUFFER], AH         ;; put the high order digit character in the first byte of the OUTPUT_BUFFER
    mov [OUTPUT_BUFFER + 1], AL     ;; put the low order byte in the next byte of the output_buffer
    mov byte [OUTPUT_BUFFER + 2], ' '    ;; put a 'space' ASCII code into the next byte of the output_buffer
    
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, OUTPUT_BUFFER          ;;
    mov edx, 3                      ;; doing the sys_write on 3 bytes (AH, AL, and space)
    int 0x80                        ;; trigger the sys_write
    
    inc edi                         ;; increment our 'bytes printed' counter
    inc esi                         ;; increment the byte offset counter
    
    ;; If we've done a multiple of BYTES_PER_LINE, we want to print a newline character
    cmp edi, BYTES_PER_LINE
    jne after_print_newline                   ;; nothing else to do, so we're good to go back for the next character
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1                      ;; printing the one newline character in our newline_buffer
    int 0x80                        ;; trigger that sys_write
    
    xor edi, edi                    ;; reset bytes printed counter to zero since we're moving to a new line
after_print_newline:    
    cmp esi, [inputByteCount]       ;; when esi = inputByteCount, we know we've printed the whole input line
                                    ;; ...at which point we can exit the byte loop and start a new line
    jl byte_loop
    
exit_byte_loop:                     ;; don't really need this label, but makes it clear where our byte loop exits
    jmp line_loop                   ;; we've processed all input characters from the line, so jump back up to
                                    ;; read another line of inputByteCount
    
exit_line_loop:
    
    ;; Printing the extra lines to match xxd | tail output
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1                      ;; Print one newline character in our newline_buffer
    int 0x80                        ;; Trigger sys_write
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1                      ;; Print one newline character in our newline_buffer
    int 0x80                        ;; Trigger sys_write
    
    ;; nothing left to do, so exit
    mov eax, SYS_EXIT               ;; sys_exit
    mov ebx, 0
    int 0x80
