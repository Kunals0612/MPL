; Write x86 ALP to find the factorial of a given integer number on; a command line by using recursion. 
; Explicit stack manipulation is expected in the code.

section .data
msgno: db 'Number is:',0xa
msnoSize: equ $-msgno
msgfact: db 'Factorial is:',0xa
msgfactSize: equ $-msgFact
newLine: db 10
section .bss
fact: resb 8
num: resb 2

%macro Print 2
mov rax,01
mov rdi,01
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro Stop
mov rax,60
 mov rdi,0
 syscall
%endmacro
section .txt
global _start
_start:
 pop rbx 		; Remove number of arguments  from stack
 pop rbx 		; Remove the program name from stack
 pop rbx 		; Remove the actual number whose factorial is                                                                    
                                               to be calculated (Address of number) from stack
 
 mov [num],rbx
 Print msgno,msgnoSize   ;msg :- Number is

Print [num],2            ;print number accepted from command line
  ;mov rax,1
; mov rdi,1
 ;mov rsi,[num]  
; mov rdx,2
 ;syscall
 
 
 mov rsi,[num]
 mov rcx,02
 xor rbx,rbx
 call aToH
 
 mov rax,rbx
 
 call factP

 
 mov rcx,08
 mov rdi,fact
 xor bx,bx
 mov ebx,eax
 call hToA

 Print newLine
Print msgfact, msgfactSize
 Print fact,8
Print newLine
 Stop   ;exit program

;************ recursive Factorial Procedure *************
 
factP:
            dec rbx
             cmp rbx,01
             je b1
            cmp rbx,00
             je b1
             mul rbx
             call factP
         b1:ret


;******** **** Ascii Hex -> Hex*************
aToH:
up1: rol bx,04
       mov al,[rsi]
       cmp al,39H
          jbe A2
       sub al,07H
A2: sub al,30H
       add bl,al
       inc rsi
       loop up1
        ret
;********************* Hex- Ascii Hex **************
hToA:  
d:  rol ebx,4
     mov ax,bx
    and ax,0fH 
    cm p ax,09H 
       jbe ii 
    add ax,07H
  ii: add ax,30H
     mov [rdi],ax
      inc rdi
      loop d
       ret
 



 
 
 
 ;*******output*******
 
;nasm -f elf64 ass9_rec.asm
; ld -o a ass9_rec.o
;./a  02
;02
;00000002
