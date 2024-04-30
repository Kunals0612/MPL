%macro rw 3
	mov rax,%1
	mov rdi,01
	mov rsi,%2
	mov rdx,%3
	syscall
%endmacro rw

section .data
arr dq 1111222222224444h, 0AAAA000088889999h, 9999444422223333h
msg db "Largest:"
count db 03
large dq 0000000000000000h

section .bss
resultarr resb 16
result resq 1

section .text
global _start
_start:


mov rbp,arr
again:
mov rax,[rbp]
cmp qword[large],rax
jg next
jmp xy
next: mov qword[large],rax
xy: 
add rbp,08h
dec byte[count]
jnz again

rw 01,msg,08

mov rax,qword[large]
mov qword[result],rax
call htoa




mov rax,60
mov rdi,0
syscall


htoa:
mov rax,qword[result]
mov byte[count],16
mov rbp, resultarr
up:
rol rax, 04
mov bl, al
and bl , 0fh
cmp bl, 09h
jle nxt
add bl,07h
nxt:
	add bl, 30h
	mov [rbp] , bl
	inc rbp
	dec byte[count]
	jnz up
rw 01,resultarr,16
ret


