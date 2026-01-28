section .text 

    global _start 

     

_start: 

   ;;; initialization... 
   mov esi, bufferAddress     ;;; use ESI to keep track of the address of first unused byte 
   mov edi, initialBufferSize ;;; use EDI to keep track of how many unused bytes are left 

_readLoop: 

   mov EDX, edi      ;;; this max size of input decreases with each line 
   mov ECX, esi      ;;; 
   mov EBX, stdin 
   mov EAX, sys_read 

   int 0x80          ;;; call the sys_read 

  

   push esi   ;;; push address of 1st byte of current line 
   push eax   ;;; push length of current lines

   add esi, eax    ;;; update the address to first byte of unused bytes in the buffer 
   sub edi, eax    ;;; update tally of remaining unused bytes in the buffer
   cmp eax, 0 

   jle _writeLoop 

   cmp edi, 0     ;;; is it possible for EDI to go below 0???? 

   jle _writeLoop 

   jmp _readLoop 

_writeLoop: 

   pop edx      ;;; pop the last size from the stack straight into EDX for sys_write 
   pop ecx      ;;; pop the last address from the stack straight into ECS for sys_write 
   mov ebx, stdout 
   mov eax, sys_write 
   int 0x080    ;;; call the sys_write 

   jmp _writeLoop
    

section .bss 

   bufferAddress resb initialBufferSize 

;;;; define symbols here 

initialBufferSize equ 1000000 
sys_read  equ 0x03 
sys_write equ 0x04 
stdin     equ 0x00
stdout    equ 0x01 
stderr    equ 0x02 
