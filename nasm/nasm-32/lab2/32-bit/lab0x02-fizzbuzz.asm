
section .data
	
	numLines dw 1
	numPrinted dw 5
	Z db "Z"
	nl dw 0Ah, 0Dh

section .bss

section	.text
    global  _start	
_start:                          	 	; entry point	

    mov esi, numLines
    
loop_main:


	mov eax, 4
    mov ebx, 1  
    mov ecx, Z   
    mov edx, 1
    
    int 0x80    ; "int" triggers an interrupt of type 0x80
    
    inc esi
    cmp esi, [numPrinted]
    jl loop_main
    jmp _start
	
end_loop_main:
    mov eax, 4                       	; syscall number
	mov ebx, 1                       	; stdout 	
	mov ecx, nl                      	; ptr to buffer
	mov edx, 1                       	; buffer size
	int 0x80				 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
    mov eax, 1      ;;Prep for sys_ext call
    mov ebx, 0      ;;Return "success"
    int 0x80        ;;Trigger the system call
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    SYS_READ    equ 3
    SYS_WRITE   equ 4
    SYS_EXIT    equ 1
    FD_STDIN    equ 0
    FD_STDOUT   equ 1
    FD_STDERR   equ 2
