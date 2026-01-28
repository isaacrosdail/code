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
    ERROR db "THAT NOT PEBBLE!"
    OVERFLOW_ERROR db "HURT GROG HEAD, GR!"
    GOODBYE db "Calc-u-lator!"
    WELCOME db "Time to yabba dabba dooooooo math"
    EQUALS db "="
    PEBBLE db 'o'

section .bss
    INPUT_BUFFER resb 1024
    IN_BUF_SIZE equ $ - INPUT_BUFFER
    inputByteCount resb 4
    result resb 4
    OUTPUT_BUFFER resb 9    ;; MAY NEED TO RESIZE FOR DIFFERENT INPUT LENGTHS?
    
section .text
    global _start

_start:
    ;; Print welcome message
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, WELCOME
    mov edx, 33                      
    int 0x80
    
welcome_msg:

    test AL, AL                     ;; Clear carry flag to prevent infinite ERROR loop
    mov eax, SYS_WRITE              ;; Printing newline
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1
    int 0x80
    
    jmp print_result
    
input_loop:
    xor esi, esi                    ;; reset counter for pebbles printed
    
    ;; Print newline
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1
    int 0x80
    ;; Read a line/buffer of input
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, INPUT_BUFFER
    mov edx, IN_BUF_SIZE
    int 0x80
    
    ;; Store input
    mov [inputByteCount], eax   ;; Length of input -1 = pebble count!
    sub byte [inputByteCount], 2    ;; Length of input -2 = pebble count!
    mov AH, [INPUT_BUFFER]      ;; track the operation (first in input buffer)
    
    mov ecx, 0                ;; reset counter for validation
;; Validate input
validate_loop:
    
    ;; FIX: MAKE EACH FAIL MESSAGE UNIQUE (i.e., overflow, non pebbles, etc)
    ;; Validate the rest of input to ensure they are all pebbles
    cmp ecx, [inputByteCount]       ;; check if we've reached end of input
    jge determine_operation         ;; if so, go to rest of code
    
    inc ecx
    cmp byte [INPUT_BUFFER + ecx], 'o'    ;; if not, confirm pebbles are pebbles
                                          ;; inc address counter
    je validate_loop
    jne print_ERROR

determine_operation:

    mov AL, [result]
    cmp AH, '+'
    je _PLUS
    cmp AH, '-'
    je _MINUS
    cmp AH, '*'
    je _MULT
    cmp AH, '/'
    je _DIV
    cmp AH, '%'
    je _MODULO
    cmp AH, 'c'
    je _CLEAR
    cmp AH, 'x'
    je _EXIT
    
    jmp print_ERROR
    
_PLUS:
    add AL, [inputByteCount]    ;; add input pebbles to result
    mov [result], AL
    jmp print_result
    
_MINUS:
    cmp [inputByteCount], AL    ;; Check whether we're going to go in negatives
    jg error_OVERFLOW              ;; Jump to error if so
    sub AL, [inputByteCount]    ;; sub input pebbles from result
    mov [result], AL
    jmp print_result
    
_MULT:
    mul byte [inputByteCount]
    mov [result], AL
    jmp print_result

_DIV:
    ;; Result (in EAX) divided by inputByteCount = Result (now in AL)
    mov eax, [result]
    div byte [inputByteCount]
    cmp AH, 0                   ;; Check whether remainder is zero, if not -> error
    jne error_OVERFLOW
    mov [result], AL
    jmp print_result

_MODULO:
    xor AH, AH      ;; clear AH
    mov eax, [result]
    div byte [inputByteCount]
    mov [result], AH
    jmp print_result

_CLEAR:
    mov byte [result], 0
    jmp print_result

_EXIT:
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, GOODBYE
    mov edx, 13
    int 0x80
    
    jmp exit_print_pebbles_loop

print_ERROR:
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, ERROR
    mov edx, 16
    int 0x80

    jmp welcome_msg
    
error_OVERFLOW:
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, OVERFLOW_ERROR
    mov edx, 19
    int 0x80
    
    ;; Print newline
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1
    int 0x80
    
    mov byte [result], 0
    jmp welcome_msg
    
print_result:
    ;; Print '=' sign
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, EQUALS
    mov edx, 1
    int 0x80
    
print_pebbles_loop:

    jo error_OVERFLOW                  ;; Error if overflow

    cmp byte [result], 0
    je input_loop
    
    ;; Print pebbles
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, PEBBLE
    mov edx, 1                      
    int 0x80
    
    inc esi                         ;; inc pebbles printed counter
    
    ;; Check whether we've printed all our pebbles
    cmp esi, [result]
    jge input_loop
    ;;jge exit_print_pebbles_loop
    jmp print_pebbles_loop

exit_print_pebbles_loop:
    ;; Print newline
    mov eax, SYS_WRITE              ;; Printing first byte to screen
    mov ebx, STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1
    int 0x80
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exit the program
    mov eax, SYS_EXIT
    mov ebx, 0
    int 0x80
