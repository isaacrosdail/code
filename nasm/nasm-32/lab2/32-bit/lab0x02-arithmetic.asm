
section .data ;; Initialized data

    x   dd  0x2a            ;; 42 in hex
    y   dd  1001
    z   dd  -88             
    a   dd  0x0eeeeeee      ;; Large hex integer
    b   dd  0x01010101      ;; ??
    alpha   dw  0xFFFF
    beta    dw  0x7FFF

section .bss
    this resd 1     ;; Reserves a 4 byte chunk of memory
    that resb 4     ;; Reserves 4 1 byte chunks of memory

section .text
    global _start

_start:
    ;; Examining the difference between mov x and mov [x] into a register
    mov ecx, x
    mov eax, [x]    ;; Refers to data at address x 
                    ;; By default, the no. of bytes copied matches the register (4 bytes for standard x86 registers)
    mov ebx, [y]
    add eax, ebx    ;; Adds value of ebx to eax, storing it in eax (Note: desination of operation is listed first)
    add eax, [z]    ;; Adds data at z to eax, storing result in eax
    add eax, [ecx]
    
    mov [this], eax ;; Copies our result in eax to memory location at address "this"                
    ;;add [ecx], 4    ;; add 4 to the number stored at memory location given by address in ECX
    add dword [ecx], 4 ;; Adds integer '4' to the values 
    add ecx, 4      ;; what will ECX be the address of right now?
    
    ;;sub [ecx], 1001      ;; increment the data at location given by address in ECX
    sub dword [ecx], 1001
    
    mov edx, ecx
    xor edx, edx    ;; Efficient way to zero a register, as it doesn't involve transferring from memory
    inc edx
    inc edx
    dec edx 
    
    add word [ecx], 17  ;; add 17 to 2 bytes starting @ locECX
    mov word [ecx+2], 43
    
    mov eax, 0xFFFFFFFF
    mov ebx, 0x12345678
    xor eax, ebx
    mov ecx, 0x00FF00FF
    and ecx, eax
    mov edx, 0x0000FFFF
    or  edx, eax
    
    ;; AX is a partial register, the lower half of EAX
    mov AX, [alpha]
    mov BX, [beta]
    add BX, 1
    add AX, BX
    shl AX, 6
    shl BX, 16
    
    ;; shifts
    mov edx, 1
    shl edx, 3
    add edx, 1
    shl edx, 3
    add edx, 1
    shr edx, 2
    add edx, 1

;; Exit the program   
    mov eax, 1      ;; Prepare for sys_ext call
    mov ebx, 0      ;; Return 0
    int 0x80        ;; Triggers system call
