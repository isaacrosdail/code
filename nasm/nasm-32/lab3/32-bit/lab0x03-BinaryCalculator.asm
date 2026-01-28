;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Definitions
    SYS_READ equ 3
    SYS_WRITE equ 4
    STDIN equ 0
    STDOUT equ 1
    SYS_EXIT equ 1
    
section .data
    NEWLINE_BUF db 0x0A
    EQUALS db "="
    NEGATIVE_SIGN db "-"
    GOODBYE db "Sign-ing off!"
    ERROR db "Invalid character(s)"
    ERROR_OVERFLOW db "Overflow"
    
section .bss
    INPUT_BUFFER resb 1024                  ;; '+110'
    IN_BUF_SIZE equ $ - INPUT_BUFFER        ;; '4'
    numberOfDigits resb 4                   ;; '3'
    binary resb 4
    running_total resb 4
    temp_binary resb 4
    
    sameSign resb 4
    binaryNeg resb 4
    totalNeg resb 4
    
    digitPower resb 4
    OUTPUT_BUFFER resb 8
    OUT_BUF_SIZE equ $ - OUTPUT_BUFFER
    
section .text
    global _start
    
_start:    
    ;; Start with result of 0
    mov byte [binary], 0
    ;; Set initial states of input and running_total
    mov byte [binaryNeg], 0
    mov byte [totalNeg], 0
    mov byte [sameSign], 0
    
input_loop:
    ;; Read ASCII input and save it in a buffer
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, INPUT_BUFFER
    mov edx, IN_BUF_SIZE
    int 0x80

    ;; Get the length to know position of last digit
    mov [numberOfDigits], eax           ;; store input length
    sub byte [numberOfDigits], 2        ;; Number of binary digits
    
    ;; Counter for conversion loop
    mov ebx, 1
    ;; Not needed?
    xor AL, AL
    
    ;; Check if input is negative
    cmp byte [INPUT_BUFFER + ebx], '-'
    jne check_same_sign

shift_start_for_negative:
    inc ebx
    sub byte [numberOfDigits], 1

set_binaryNEG:

    mov byte [binaryNeg], 1
    
setbinaryNEG_minus:    
check_same_sign:
    ;; Check if signs are the same
    mov AL, [binaryNeg]
    cmp byte [totalNeg], AL
    jne convert_ascii
    
    mov byte [sameSign], 1

convert_ascii:
    ;; Reset counter for conversion loop
    xor AL, AL
    
;; ASCII --> BINARY Conversion (left to right)
convert_ascii_loop:
    cmp byte [INPUT_BUFFER + ebx], '1'
    je one_bit
    cmp byte [INPUT_BUFFER + ebx], '0'
    je zero_bit
    
    jmp check_sign
    
one_bit:
    shl AL, 1
    inc AL
    mov [binary], AL
    jmp dec_ascii_loop
zero_bit:
    shl AL, 1
    mov [binary], AL
    jmp dec_ascii_loop
dec_ascii_loop:
    inc ebx
    jmp convert_ascii_loop

check_sign:
    
    mov AL, [binary]
    mov BH, [INPUT_BUFFER]
    
    cmp byte [sameSign], 1
    jne diff_sign_operations
        
    jmp same_sign_operations

same_sign_operations:
    
    cmp BH, '+'
    je _ADD
    cmp BH, '-'
    je _MINUS
    cmp BH, '*'
    je _MULT
    cmp BH, '/'
    je _DIV
    cmp BH, '%'
    je _MODULO
    cmp BH, 'c'
    je _CLEAR
    cmp BH, 'x'
    je _EXIT
    
    jmp _ERROR

diff_sign_operations:
    
    cmp BH, '+'
    je _NEG_MINUS
    cmp BH, '-'
    je _ADD
    cmp BH, '*'
    je _MULT
    cmp BH, '/'
    je _DIV
    cmp BH, '%'
    je _MODULO
    cmp BH, 'c'
    je _CLEAR
    cmp BH, 'x'
    je _EXIT
    
    jmp _ERROR
    
reset_totalNeg:
    mov AH, [binaryNeg]
    mov [totalNeg], AH
    jmp flip_operands

_ADD:
    
    mov AL, [binary]        ;; unnecessary?
    add AL, [running_total]
    mov [binary], AL
    jc error_overflow
    
    jmp save_result
    
flip_operands:

    mov AH, [running_total]
    mov AL, [binary]
    mov [running_total], AL
    mov [binary], AH
    
    ;; Clear register
    xor AH, AH
    
_SAMESIGN_MINUS:

    ;; Same sign addition
    cmp byte [sameSign], 1
    je _ADD
    
_NEG_MINUS:
    ;; Different sign addition
    cmp [running_total], AL
    jl reset_totalNeg

_MINUS:
    ;; Else, perform subtraction
    mov AL, [running_total]  ;; Prepare for subtraction from AL
    sub AL, [binary]        ;; Subtract input from total
    mov [binary], AL        ;; Save result to binary variable
    jmp save_result
    
_MULT:
    mul byte [running_total]
    mov [binary], AL
    
    ;; Make the result negative if the signs are not the same
    cmp byte [sameSign], 0
    jne save_result
    mov byte [totalNeg], 1
    
    jmp save_result
    
_DIV:
    mov AX, [running_total]
    div byte [binary]
    ;; Error if remainder is not 0 (i.e., result in non-integer)
    cmp AH, 0
    jne error_overflow
    
    ;; Make the result negative if the signs are not the same
    cmp byte [sameSign], 0
    jne save_result
    mov byte [totalNeg], 1
    
    ;; Else, good to continue
    mov [running_total], AL
    jmp save_result
    
_MODULO:
    mov eax, [running_total]
    div byte [binary]
    mov [binary], AH
    xor AH, AH
    mov AL, [binary]
    mov byte [totalNeg], 0
    jmp save_result
    
_CLEAR:
    xor eax, eax
    mov byte [totalNeg], 0
    mov byte [binaryNeg], 0
    mov byte [sameSign], 1
    jmp save_result

_EXIT:
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, GOODBYE
    mov edx, 13
    int 0x80
    
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1
    int 0x80
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1
    int 0x80
    
    jmp _exit

_ERROR:
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, ERROR
    mov edx, 20
    int 0x80

    jmp print_newline

error_overflow:
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, ERROR_OVERFLOW
    mov edx, 8
    int 0x80
    
    mov byte [running_total], 0
    jmp print_newline

print_newline:
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1
    int 0x80
    
    jmp input_loop

save_result:
    ;;mov AL, [result]
    mov [running_total], AL
    
;; BINARY --> ASCII (right to left)
convert_binary:
    xor esi, esi
convert_binary_loop:
    
    shl AL, 1
    jc one_bit_to_ascii
    mov byte [OUTPUT_BUFFER + esi], '0'  ;; carry is 0
    jmp after_one_bit
    
one_bit_to_ascii:
    mov byte [OUTPUT_BUFFER + esi], '1'
after_one_bit:
    inc esi
    cmp esi, 8
    jl convert_binary_loop

print_equals:
    
    ;; Overflow if carry flag
    cmp AH, 0
    jne error_overflow
    
    
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, EQUALS          
    mov edx, 1                      
    int 0x80
    
    cmp byte [totalNeg], 1
    je print_negative_sign
    
print_result:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, OUTPUT_BUFFER          
    mov edx, OUT_BUF_SIZE           
    int 0x80
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF          
    mov edx, 1                      
    int 0x80
    
    ;; Reset bool for negative input and restart input loop
    mov byte [binaryNeg], 0
    mov byte [sameSign], 0
    jmp input_loop

print_negative_sign:

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, NEGATIVE_SIGN          
    mov edx, 1          
    int 0x80
    
    jmp print_result
    

_exit:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exit the program
    mov eax, SYS_EXIT
    mov ebx, 0
    int 0x80
