%macro rw 3
	mov rax,%1
	mov rdi,01
	mov rsi,%2
	mov rdx,%3
	syscall
%endmacro rw

section .data
pos db 00
ncount db 00
arr dq 1111222222224444h, 0AAAA000088889999h, 9999444422223333h
msg2 db 10,13,"Positive:"
msg1 db 10,13,"Negative:"

section .bss
count resb 01
resultarr resb 2
result resb 1

section .text
global _start
_start:

mov rbp, arr
mov byte[count],03h
xy: mov rax,[rbp]
;rcl rax,01
bt rax,63
jc next
inc byte[pos]
jmp cont
next: inc byte[ncount]
cont: 
inc rbp
dec byte[count]
jnz xy
 
rw 01,msg1,09h
mov al,byte[ncount] 	;01
mov byte[result],al
call htoa

rw 01,msg2,09h
mov al,byte[pos]
mov byte[result],al
call htoa

mov rax,60
mov rdi,0
syscall

htoa:
mov al,byte[result]
mov byte[count],2
mov rbp, resultarr
up:
rol al, 04
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
rw 01,resultarr,2
ret


