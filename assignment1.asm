section .bss
    array resd 200
    counter resb 1

section .text
    global _start

_start:  mov rbp,array  
        mov byte[counter],05

 loop1: mov rax, 0
        mov rdi, 0
        mov rsi, rbp
        mov rdx, 17
        syscall
        
        add rbp,17
        dec byte[counter]
        jnz loop1
    
        mov rbp,array
        mov byte[counter],05

 loop2: mov rax, 1
        mov rdi, 1
        mov rsi, rbp
        mov rdx, 17
        syscall
        
        add rbp,17
        dec byte[counter]
        jnz loop2
        
        mov rax,60
        mov rdi,0
        syscall
