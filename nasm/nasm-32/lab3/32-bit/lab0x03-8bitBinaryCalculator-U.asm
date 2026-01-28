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
    WELCOME db "01001111 01001110"
    GOODBYE db "Bye-nary!"
    ERROR db "Invalid character(s)"
    ERROR_OVERFLOW db "Overflow"
    
section .bss
    INPUT_BUFFER resb 1024                  ;; '+110'
    IN_BUF_SIZE equ $ - INPUT_BUFFER        ;; '4'
    numberOfDigits resb 4                   ;; '3'
    result resb 4
    result_final resb 4
    digitPower resb 4
    OUTPUT_BUFFER resb 8
    OUT_BUF_SIZE equ $ - OUTPUT_BUFFER
    
section .text
    global _start
    
_start:
    
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, WELCOME          
    mov edx, 17                      
    int 0x80
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF        
    mov edx, 1                      
    int 0x80
    ;; Start with result of 0
    mov byte [result], 0
    
input_loop:
    ;; Read ASCII input and save it in a buffer
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, INPUT_BUFFER
    mov edx, IN_BUF_SIZE
    int 0x80

    ;; Get the length to know position of last digit
    mov [numberOfDigits], eax           
    sub byte [numberOfDigits], 2        ;; Number of binary digits
    
    mov ebx, 1
    xor AL, AL         ;; not needed?

;; ASCII --> BINARY
;; Left to right
convert_ascii_loop:
    cmp byte [INPUT_BUFFER + ebx], '1'
    je one_bit
    cmp byte [INPUT_BUFFER + ebx], '0'
    je zero_bit
    
    jmp arithmetic_operations
    
one_bit:
    shl AL, 1
    inc AL
    mov [result], AL
    jmp dec_ascii_loop
zero_bit:
    shl AL, 1
    mov [result], AL
    jmp dec_ascii_loop
dec_ascii_loop:
    inc ebx
    jmp convert_ascii_loop
    
    
arithmetic_operations:
    mov AL, [result]
    mov BH, [INPUT_BUFFER]
    
    cmp BH, '+'
    je _ADD    ;;;;;;;;;;;;;;;;;;;;;;; FIX
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
    
_ADD:
    
    mov AL, [result]        ;; unnecessary?
    add AL, [result_final]
    mov [result], AL
    jc error_overflow
    
    jmp save_result
    
_MINUS:
    cmp [result_final], AL  ;; running total >,<,= operand?
    jl error_overflow       ;; if less than, jump to overflow error
    
    ;; Else, perform subtraction
    mov AL, [result_final]  ;; need running total to be in AL for sub
    sub AL, [result]        ;; subtracting operand from running total
    mov [result], AL        ;; save result from AL as new result
    jmp save_result
    
_MULT:
    mul byte [result_final]
    mov [result], AL
    jmp save_result
    
_DIV:
    mov AX, [result_final]
    div byte [result]
    cmp AH, 0
    
    ;;If remainder is NOT zero
    jne error_overflow
    mov [result_final], AL
    jmp save_result
    
_MODULO:
    mov eax, [result_final]
    div byte [result]
    mov [result], AH
    xor AH, AH
    mov AL, [result]
    jmp save_result
    
_CLEAR:
    xor eax, eax
    jmp save_result

_EXIT:
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, GOODBYE
    mov edx, 9
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
    
    mov byte [result_final], 0
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
    mov [result_final], AL
    
;; BINARY --> ASCII
;; Right to left
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

print_lead_zeros:
    
    cmp byte [numberOfDigits], 8
    jge print_result


print_result:
    
    cmp AH, 0
    jne error_overflow       ;; overflow if carry flag
    
    
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, EQUALS          
    mov edx, 1                      
    int 0x80
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
    
    jmp input_loop

_exit:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exit the program
    mov eax, SYS_EXIT
    mov ebx, 0
    int 0x80
