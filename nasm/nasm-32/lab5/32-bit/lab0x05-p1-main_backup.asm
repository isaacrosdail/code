;; Main Assembly language program to test library functions
section .data
    newline db 0x0A
    
    prompt_search db "Please enter the character you wish to be replaced:", 0x0A
    prompt_search_size equ $ - prompt_search
    
    prompt_replace db "Please enter the character you'd like it replaced with:", 0x0A
    prompt_replace_size equ $ - prompt_replace
    
    prompt_text db "Please enter a line of text to parse/replace:", 0x0A
    prompt_text_size equ $ - prompt_text
    
    bytes_replaced db " characters were replaced.", 0x0A
    bytes_replaced_size equ $ - bytes_replaced
    
section .bss
    textPtr resb 1024
    textPtr_size equ $ - textPtr
    
    length resb 1024
        
    searchChar resb 1024
    searchChar_size equ $ - searchChar
    
    repChar resb 1024
    repChar_size equ $ - repChar
    
section .text
    global _start
    extern _replaceChar
    
_start:
    ;; Prompt user for desired searchChar
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, prompt_search
    mov edx, prompt_search_size
    int 0x80
    ;; Store searchChar
    mov eax, SYS_READ        
    mov ebx, STDIN
    mov ecx, searchChar
    mov edx, searchChar_size
    int 0x80
    ;; Prompt user for desired repChar
    mov eax, SYS_WRITE            
    mov ebx, STDOUT
    mov ecx, prompt_replace
    mov edx, prompt_replace_size
    int 0x80
    ;; Store repChar
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, repChar
    mov edx, repChar_size
    int 0x80
    ;; Prompt user to enter a line of text
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, prompt_text
    mov edx, prompt_text_size
    int 0x80
    
textPtr_loop:
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, textPtr
    mov edx, textPtr_size
    int 0x80
    
    ;; Check for empty input
    mov [length], eax
    cmp eax, 1
    jle exit_textPtr_loop

    ;; Push necessary values onto stack
    lea eax, [repChar]      ;; Value for repChar
    push dword [eax]
    lea eax, [searchChar]   ;; Value for searchChar
    push dword [eax]
    lea eax, [length]       ;; Value for length
    push dword [eax]
    lea eax, [textPtr]        ;; Value for textPtr address
    push eax
    
    ;; Call function
    call _replaceChar
    
    
    
    ;; Print out new altered line, then newline
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, textPtr
    mov edx, [length]
    int 0x80
    mov eax, SYS_WRITE         
    mov ebx, STDOUT
    mov ecx, newline
    mov edx, 1
    int 0x80
    
    jmp textPtr_loop
    
    
exit_textPtr_loop:
    mov eax, SYS_EXIT       ;; Exit the program
    mov ebx, 0
    int 0x80
    
;; DEFINITIONS
    SYS_READ equ 3
    SYS_WRITE equ 4
    STDIN equ 0
    STDOUT equ 1
    SYS_EXIT equ 1
