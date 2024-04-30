;//Assignment 7: - Display GDT, LDT, IDT, Task Register, CPU ID
section .data
rm db 'processor is in real mode'
rm_l equ $-rm
pm db 'processor is in protected mode'
pm_l equ $-pm
g db 'GDT contents are'
g_l equ $-g
l db 'LDT contents are'
l_l equ $-l
i db 'IDT contents are'
i_l equ $-i
t db 'task register contents are'
t_l equ $-t
m db 'Machine status word'
m_l equ $-m
col db ':'
nwline db 10

section .bss
 gdt resd 1
     resw 1
ldt resw 1
idt resd 1
    resw 1
tr resw 1
cr0_data resd 1
dnum_buff resb 04

%macro disp 2
mov rax,01
mov rdi,01
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .text
global _start
_start:

smsw eax     		;reading CR0
mov [cr0_data],eax
bt eax,0
jc prmode
disp rm,rm_l			;processor in real mode
jmp next1
prmode:disp pm,pm_l		;processor in protected mode
disp nwline,1

next1:sgdt [gdt]		;stored GDT
sldt [ldt]			;stored LDT
sidt [idt]			;stored IDT
str [tr]				;stored TS
disp g,g_l
mov bx,[gdt+4]
call disp_num


mov bx,[gdt+2]
call disp_num


disp col,1
mov bx,[gdt]
call disp_num
disp nwline,1


disp l,l_l
mov bx,[ldt]
call disp_num
disp nwline,1

disp i,i_l
mov bx,[idt+4]
call disp_num


mov bx,[idt+2]
call disp_num


disp col,1
mov bx,[idt]
call disp_num
disp nwline,1

disp t,t_l
mov bx,[tr]
call disp_num 
disp nwline,1


disp m,m_l
mov bx,[cr0_data+2]
call disp_num

mov bx,[cr0_data]
call disp_num
disp nwline,1

exit:mov rax,60
        mov rdi,0
        syscall

disp_num:
mov esi,dnum_buff
mov ecx,4

up1:
rol bx,4
mov dl,bl
and dl,0fh
add dl,30h
cmp dl,39h
jbe skip1
add dl,07h

skip1:
mov [esi],dl
inc esi
loop up1


disp dnum_buff,4
ret

;//OUTPUT

;processor is in protected mode!....
;GDT contents are->00001000:007F
;LDT contents are->0000
;IDT contents are->00000000:0FFF
;Task Register contents are->0040
;Machine status word->8005FFFF











MSW - Machine Status Word (286+ only)


      |31|30-5|4|3|2|1|0|  Machine Status Word
        |   |  | | | | +---- Protection Enable (PE)
        |   |  | | | +----- Math Present (MP)
        |   |  | | +------ Emulation (EM)
        |   |  | +------- Task Switched (TS)
        |   |  +-------- Extension Type (ET)
        |   +---------- Reserved
        +------------- Paging (PG)


        Bit 0   PE      Protection Enable, switches processor between
                        protected and real mode
        Bit 1   MP      Math Present, controls function of the WAIT
                        instruction
        Bit 2   EM      Emulation, indicates whether coprocessor functions
                        are to be emulated
        Bit 3   TS      Task Switched, set and interrogated by coprocessor
                        on task switches and when interpretting coprocessor
                        instructions
        Bit 4   ET      Extension Type, indicates type of coprocessor in
                        system
        Bits 5-30       Reserved
        bit 31  PG      Paging, indicates whether the processor uses page
                        tables to translate linear addresses to physical
                        addresses

        - see   SMSW  LMSW

