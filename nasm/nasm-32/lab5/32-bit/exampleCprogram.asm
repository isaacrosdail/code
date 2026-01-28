;	.file	"exampleCprogram.c"
;	.intel_syntax noprefix
;	.text
;	.section	.rodata
;	.align 4
;.LC0:
;	.string	"\nTake the %d to the %d and get the secret word: %s\n"
;	.align 4
;.LC1:
;	.string	"and for the grins here is the thing: %d\n"
;	.text
;	.globl	fizz
;	.type	fizz, @function

;; FIZZ USED TO BE HERE
	
;	.size	fizz, .-fizz
;	.section	.rodata

;.LC2:
;	.string	"antelope"
;.LC3:
;	.string	"give me a couple numbers: "
;.LC4:
;	.string	"%d %d"
;.LC5:
;	.string	"What's the word?  "
;.LC6:
;	.string	"%s"
;	.text
;	.globl	main
;	.type	main, @function

section .data

    ;LC0 db "\nTake the %d to the %d and get the secret word: %s\n" ; This also will not quite work, as NASM does not understand \n
    LC0 db 0x0A,"Take the %d to the %d and get the secret word: %s",0x0A,0x00 ; <-- also added "null terminator"
    LC1 db "and for the grins here is the thing: %d",0x0A,0x00
    LC1_LENGTH equ $ - LC1 ; <-- why not do this?
    ;; Because this data all have 0x00 byte to indicate end of the string..code can see that instead of knowing the length of string
    ;; printf and scanf are written to look for the null terminator... as does any C function that works with strings
    
    ;.LC2 db "antelope" ---> this will not quite work -- strings in C *always* end with 0x00 byte, but not in NASM asssembly
    LC2 db "antelope", 0x00 ;; we need to add the "zero byte" or "null terminator" of the string manually
    LC3 db "give me a couple numbers:",0x00
    LC4 db "%d %d",0x00
    LC5 db "what's the word? ",0x00
    LC6 db "%s",0x00

section .text
    global _start
    extern printf
    extern __isoc99_scanf

;main:
_start:
	;lea	ecx, [esp+4]
	;and	esp, -16
	;push	DWORD [ecx-4]
	;push	ebp
	;mov	ebp, esp
	;push	ecx
	;sub	esp, 84
	;mov	eax, ecx
	;mov	eax, DWORD [eax+4]
	;mov	 [ebp-76], eax
	;mov	eax,  gs:20
	;mov	 [ebp-12], eax
	;xor	eax, eax
	;sub	esp, 4
	
	;; we can tell with the setup for calling fizz starts pushing parameters..
	;; everything above the first part of our C main, is stuff that gcc added for its own reasons
	;; if we are converting the main program to simple, plain assembly, we don't need that
	push	LC2
	push	99
	push	42
	call	fizz
	add	esp, 16
	sub	esp, 12
	push	LC3
	call	printf
	add	esp, 16
	sub	esp, 4
	lea	eax, [ebp-68]
	push	eax
	lea	eax, [ebp-72]           ;; 
	push	eax
	push	LC4
	call	__isoc99_scanf
	add	esp, 16
	sub	esp, 12
	push	LC5
	call	printf
	add	esp, 16
	sub	esp, 8
	lea	eax, [ebp-62]
	push	eax
	push	LC6
	call	__isoc99_scanf
	add	esp, 16
	mov	edx,  [ebp-68]
	mov	eax,  [ebp-72]
	sub	esp, 4
	lea	ecx, [ebp-62]
	push	ecx         ;; pushing 3 parameters on stack for call to fizz
	push	edx
	push	eax
	call	fizz
	;; this call to fizz is last step we put in our C program, so everything after this is 'cleanup' being done by gcc
	;; we don't need it, so we can just make our program exit
	;add	esp, 16
	;mov	eax, 0
	;mov	edx,  [ebp-12]
	;sub	edx,  gs:20
	;je	.L6
	;call	__stack_chk_fail
;.L6:
;	mov	ecx,  [ebp-4]
;	leave
;	lea	esp, [ecx-4]
;	ret

;; we do want to make sure we exit properly, so let's do the usual
    mov ebx, 0
    mov eax, 1
    int 0x80

	
fizz:
	push	ebp
	mov	ebp, esp
	sub	esp, 24
	mov	DWORD [ebp-16], 0
	push	DWORD [ebp+16]
	push	DWORD [ebp+12]
	push	DWORD [ebp+8]
	push	LC0
	call	printf
	add	esp, 16
	mov	DWORD [ebp-12], 0
	jmp	.L2
.L3:
	mov	edx,  [ebp-16]
	mov	eax,  [ebp+8]
	add	edx, eax
	mov	eax,  [ebp+8]
	imul	eax,  [ebp+12]
	add	eax, edx
	mov	 [ebp-16], eax
	add	DWORD [ebp-12], 1
.L2:
	cmp	DWORD [ebp-12], 9
	jle	.L3
	sub	esp, 8
	push	DWORD [ebp-16]
	push	LC1
	call	printf
	add	esp, 16
	nop
	leave
	ret
	
;	.size	main, .-main
;	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
;	.section	.note.GNU-stack,"",@progbits
