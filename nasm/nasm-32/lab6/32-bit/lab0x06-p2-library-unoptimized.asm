;;	.file	"lab0x06-p2-library.c"
;;	.intel_syntax noprefix
;;	.text
;;	.globl	sumOfSumsAtoB
;;	.type	sumOfSumsAtoB, @function

section .text
    global sumOfSumsAtoB_tweaked

sumOfSumsAtoB_tweaked:
	push ebp
	mov	ebp, esp
	sub	esp, 16
	mov	eax, DWORD  [ebp+8]
	mov	DWORD [ebp-12], eax
	mov	DWORD [ebp-8], 0
	mov	DWORD [ebp-4], 0
	jmp	.L2
.L3:
	mov	eax, DWORD  [ebp-12]
	add	DWORD  [ebp-8], eax
	mov	eax, DWORD  [ebp-8]
	add	DWORD  [ebp-4], eax
	add	DWORD  [ebp-12], 1
.L2:
	mov	eax, DWORD  [ebp-12]
	cmp	eax, DWORD  [ebp+12]
	jle	.L3
	mov	eax, DWORD  [ebp-4]
	leave
	ret
