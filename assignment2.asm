%macro rw 3
	mov rax,%1
	mov rdi,01
	mov rsi,%2
	mov rdx,%3
	syscall
%endmacro rw

section .data
msg1 db "Enter string="
msg2 db "Length="

section .bss
len resb 1
stri resb 15

section .text
global _start
_start:

rw 01,msg1,13
rw 00,stri,15


cmp al,09h
jle next
add al,07h
next: add al,30h
mov byte[len],al

rw 01,msg2,7
rw 01,len,01

mov rax,60
mov rdi,0
syscall

