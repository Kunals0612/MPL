
;Write X86 ALP to find, a) Number of Blank spaces 
;                 	   b) Number of lines 
;                            c) Occurrence of a particular character. 
; 			Accept the data from the text file.
;The text file has to be accessed during Program_1 execution ;and write FAR PROCEDURES 
; in Program_2 for the rest of the processing. 
;Use of PUBLIC and EXTERN directives is mandatory. 

;************* p1.asm file ***********************
section .data
global msg6,len6,scount,ncount,occcount,new,new_len
fname: db 'abc.txt',0
msg: db "File opened successfully",0x0A
len: equ $-msg
msg1: db "File closed successfully",0x0A
len1: equ $-msg1
msg2: db "Error in opening file",0x0A
len2: equ $-msg2
msg3: db "Spaces:",0x0A
len3: equ $-msg3
msg4: db "NewLines:",0x0A
len4: equ $-msg4
msg5: db "Enter character:",0x0A
len5: equ $-msg5
msg6: db "No of occurances:",0x0A
len6: equ $-msg6
new: db "",0x0A
new_len: equ $-new
scount: db 0
ncount: db 0
ccount: db 0
chacount: db 0
section .bss
global cnt,cnt2,cnt3,buffer
fd: resb 17
buffer: resb 200
buf_len: resb 17
cnt: resb 2
cnt2: resb 2
cnt3: resb 2
occr: resb 2
%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .text
global _start
_start:

extern spaces, enters, occ
mov rax,2		;open file cursor goes in end of file
mov rdi, fname	;file name as second parameter
mov rsi,2			;0=read only,1=write only 2=read/write
mov rdx,0777		; Setting permission for read, write and execute by all
syscall
mov qword[fd],rax
BT rax,63
jc next
scall 1,1,msg,len		;File open successfully
jmp next2
next: scall 1,1,msg2,len2		;Error to open file
jmp exit
next2:scall 0,[fd],buffer, 200
mov qword[buf_len],rax
mov qword[cnt],rax
mov qword[cnt2],rax
mov qword[cnt3],rax
scall 1,1,msg3,len3       ;No of spaces
call spaces
scall 1,1,msg4,len4     ; No .of words
call enters
scall 1,1,msg5,len5        ;Enter chr for occurance
scall 0,1,occr,2               ;read chr
mov bl, byte[occr]
call occ
;jmp exit
;exit:
    scall 1,1,msg1,len1       ;file close successfuly
    mov     rax, 3	;close Fname (abc.txt)
    mov     rdi, fname
    syscall                 
 exit:mov rax,60                 ;Program end
    mov rdi,0
    syscall
;********* ***********P2 file ****************
;P2.asm
section .data
extern msg6,len6,scount,ncount,occrance,new,new_len
section .bss
extern cnt,cnt2,cnt3,scall,buffer
%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro
section .text
global main2
main2:
global spaces,enters,occ
;************checking number of spaces *************
spaces:mov rsi,buffer
up:mov al, byte[rsi]
cmp al,20H
je next3
inc rsi
dec byte[cnt]
jnz up
jmp next4
next3:inc rsi
inc byte[scount]     ;increment space count
dec byte[cnt]
jnz up

next4:add byte[scount], 30h
scall 1,1,scount, 2
scall 1,1,new,new_lenret
; ************ check new line ****************
enters:
mov rsi,buffer
up2:
mov al, byte[rsi]
cmp al,0AH          ;check enter key
je next5
inc rsi
dec byte[cnt2]
jnz up2
jmp next6
next5:inc rsi
inc byte[ncount]             ;new line counter increment
dec byte[cnt2]
jnz up2
next6:add byte[ncount], 30h
scall 1,1,ncount, 2
scall 1,1,new,new_len
ret
;*********** occurance of character *****************
occ:mov rsi,buffer
up3:mov al, byte[rsi]
cmp al,bl
je next7
inc rsi
dec byte[cnt3]
jnz up3
jmp next8
next7:inc rsi
inc byte[occrance]
dec byte[cnt3]
jnz up3
next8:add byte[occrance], 30h
scall 1,1,msg6,len6      ;No. of occurance
scall 1,1,occrance, 1
scall 1,1,new,new_len
ret
;***** ************p2.asm file end ****************
;***********Text file (abc.txt)************
;Hello
;Welcome to Pune
;This is microprocessor Lab
;***********************************
;*******output*******
; nasm -f elf64 p1 p1.asm
; nasm -f elf64 p2 p2.asm
; ld -o p p1.o p2.o
; ./p
;File opened successfully
;Spaces:6
;NewLines:3
;Enter character:e
;
No of occurances:5
;file closed successfuly
