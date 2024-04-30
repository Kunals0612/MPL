%macro rw 3
mov rax,%1
mov rdi,01
mov rsi,%2
mov rdx,%3
syscall
%endmacro rw

section .data
n1 dq 0Ah
n2 dq 03h
count db 03
menu db 10,13,"1.Add",10,13,"2.Sub",10,13,"3.Mul",10,13,"4.Div",10,13,"5.Exit",10,13,"Enter choice="
mlen equ $-menu
divmsg db 10,13,"Division="
dlen equ $-divmsg
mulmsg db 10,13,"Multiplication="
mullen equ $-mulmsg
addmsg db 10,13,"Addition="
alen equ $-addmsg
submsg 10,13,"Subtraction="
slen equ $-submsg

section .bss
op resb 2
resultarr resb 16
result resq 1


section .text
global _start
_start:
repeat:
rw 01,menu,mlen
rw 00,op,2
cmp byte[op],31h
jne next1
call addpro
call htoa
jmp repeat
next1:
cmp byte[op],32h
jne next2
call subpro
call htoa
jmp repeat
next2:
cmp byte[op],33h
jne next3
call mulpro
call htoa
jmp repeat
next3:
cmp byte[op],34h
jne next4
call divpro
jmp repeat

next4:
;exit
mov rax,60
mov rdi,0
syscall


addpro:
mov rax,qword[n1]
add rax,qword[n2]
mov qword[result],rax
ret

subpro:
mov rax,qword[n1]
sub rax,qword[n2]
mov qword[result],rax
ret

mulpro:
mov rax,qword[n1]
mov ecx,dword[n2]
mul ecx
mov qword[result],rax
ret

divpro:
xor rax,rax
xor rdx,rdx
xor rcx,rcx
mov rax,qword[n1]
mov ecx,dword[n2]
div ecx
mov qword[result],rax
call htoa
mov qword[result],rdx
call htoa
ret

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
