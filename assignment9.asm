;perform overlapped  block transfer with string instruction


 section .data

 	array db 10h,20h,30h,40h,50h
 	msg1: db 'Before overlapped :',0xa
	len1: equ $-msg1

 	msg2: db 'After overlapped(using string instruction) :',0xa
 	len2: equ $-msg2

        msg3: db ' ',0xa
 	len3: equ $-msg3
     
        msg4: db ' : '
	len4: equ $-msg4
       
     
        count db 0
        count1 db 0
        count2 db 0
        count3 db 0
        count4  db 0
        count5  db 0
 section .bss
  	addr resb 16
        num1 resb 2
       

%macro print 2      pranavdeshpande108@gmail.com
mov rax,01
mov rdi,01
mov rsi,%1
mov rdx,%2
syscall
%endmacro


 section .text
 global _start


 _start:
 	;*************** print address and acutal number from array ******************
 	;print msg    
 	print msg1,len1

 	xor rsi,rsi		;clear rsi pointer

 	mov rsi,array		;point rsi to array
 	mov byte[count],05	;set counter as 5

     up:mov rbx,rsi	;move contern of rsi to rbx
 	push rsi		;stored rsi address to stack
        mov rdi,addr	;point rdi to addr buffer
 	call HtoA1		;print address(16 digit)
 	pop rsi


 	mov dl,[rsi]		;print number (2 digit)
 	push rsi
        mov rdi,num1
	call HtoA2
 	pop rsi

	 inc rsi

	 dec byte[count]
	 jnz up

 ;****************moving array element to to after 10 position***************    
        mov rsi,array
        mov rdi,array+03h
	mov byte[count3],05h

 loop10:mov dl,00h
 	movsb
        dec byte[count3]
        jnz loop10
  ;**************** after 3 position(actual overlapping)*************** 
        xor rsi,rsi

        mov rsi,arrayh	  ;overlapping on position 3
    ;    mov rdi,array+03h	;to print all content [3(before)+5(after)]=10
 	mov byte[count5],05h    ;moving 5 digit

 loop11:mov dl,byte[rdi]
        mov byte[rsi],dl
        inc rsi
        inc rdi
        dec byte[count5]
        jnz loop11
	
        print msg1,len2
	

        xor rsi,rsi
        mov rsi,array
        mov byte[count4],08h

   up10:mov rbx,rsi
 	push rsi
        mov rdi,addr
 	call HtoA1
 	pop rsi

	mov dl,[rsi]
 	push rsi
        mov rdi,num1
 	call HtoA2
 	pop rsi

	inc rsi

	dec byte[count4]
 	jnz up10
               

        mov rax,60
	mov rdi,0
	syscall 


;*************** print procedure for address **************
   HtoA1:mov byte[count1],16
    dup1:rol rbx,4
        mov al,bl
        and al,0fh
    	cmp al,09
 	jg p3
 	add al,30h
 	jmp p4
    p3: add al,37h
    p4: mov [rdi],al
        inc rdi
        dec byte[count1]
        jnz dup1

 
	 print addr,16
	 print msg4,len4

 	 ret

;*************** print procedure for data **************
   HtoA2: mov byte[count2],02
   dup2: rol dl,04
	 mov al,dl
	 and al,0fh
	 cmp al,09h
	 jg p31
	 add al,30h
	 jmp p41

   p31:  add al,37h
   p41:  mov [rdi],al
   
        inc rdi
        dec byte[count2]
        jnz dup2
        
        print num1,02
        print msg3,len3

        ret





;******output*******
;nasm -f elf64 over.asm
;ld -o a over.o
; ./a
;Before overlapped :
;000000000060029C : 10
;000000000060029D : 20
;000000000060029E : 30
;000000000060029F : 40
;00000000006002A0 : 50
;After overlapped (using string instruction) :
;000000000060029C : 10
;000000000060029D : 20
;000000000060029E : 30
;000000000060029F : 10
;00000000006002A0 : 20
;00000000006002A1 : 30
;00000000006002A2 : 40
;00000000006002A3 : 50









;perform nonoverlapped  block transfer with string instruction
 section .data
	 array db 10h,20h,30h,40h,50h
        msg1: db 'Before overlapped :',0xa
 	len1: equ $-msg1

	msg2: db 'After overlapped :',0xa
 	len2: equ $-msg2

        msg3: db ' ',0xa
	len3: equ $-msg3
     
        msg4: db ' : '
	len4: equ $-msg4
    
        count db 0
        count1 db 0
        count2 db 0
        count3 db 0
        count4  db 0
 
 section .bss
	 addr resb 16
         num1 resb 2
       
	%macro print 2
	mov rax,01
	mov rdi,01
	mov rsi,%1
	mov rdx,%2
	syscall
	%endmacro
 section .text
 global _start
 _start:print msg1,len2             ;print msg
        xor rsi,rsi                 ;clear rsi

        mov rsi,array               ;point rsi to array
        mov byte[count],05          ;counter

    up: mov rbx,rsi                  ;copy address -> rbx
        push rsi                      
        mov rdi,addr                ;point rdi to addr variable
        call HtoA1                  ;call h-A proc to print 64bit address
        pop rsi

        mov dl,[rsi]                ;copy actual number-> dl 
        push rsi
        mov rdi,num1                ;point rdi to num variable
        call HtoA2                  ;copy H-A proc to print 8 bit number
        pop rsi

        inc rsi

        dec byte[count]
        jnz up

     
        mov rsi,array
        mov rdi,array+5h
        mov byte[count3],05h

       loop10:  movsb                     ;copy content of address pointed by rsi to memory location pointed by rdi
        dec byte[count3]
        jnz loop10

        print msg2,len2
        
        mov rsi,array
        mov byte[count4],0Ah

   

   up10:mov rbx,rsi
        push rsi
        mov rdi,addr
        call HtoA1
        pop rsi

        mov dl,[rsi]
        push rsi
        mov rdi,num1
        call HtoA2
        pop rsi

        inc rsi

        dec byte[count4]
        jnz up10
               

        mov rax,60
        mov rdi,0
        syscall 
;*********************** HtoA1 ************************
   HtoA1:mov byte[count1],16
   dup1:rol rbx,4
 	mov al,bl
	 and al,0fh
	 cmp al,09
	 jg p3
	 add al,30h
	 jmp p4
     p3: add al,37h
      p4:mov [rdi],al
	 inc rdi
        dec byte[count1]
        jnz dup1
    
        print addr,16
        print msg4,len4

	ret
**************************HtoA2*************
HtoA2:   mov byte[count2],02
dup2:    rol dl,04
	 mov al,dl
	 and al,0fh
	 cmp al,09h
	 jg p31
	 add al,30h
 	 jmp p41

    p31: add al,37h
     p41:mov [rdi],al

         inc rdi
        dec byte[count2]
        jnz dup2
     
        print num1,02
        print msg3,len3
         
        ret

;*****************************************************
;************output*********
;nasm -f elf64 w_over.asm
;ld -o w_over w_over.o
; ./w_over
;Before overlapped :
;0000000000600264 : 10
;0000000000600265 : 20
;0000000000600266 : 30
;0000000000600267 : 40
;0000000000600268 : 50
;After overlapped :
;0000000000600264 : 10
;0000000000600265 : 20
;0000000000600266 : 30
;0000000000600267 : 40
;0000000000600268 : 50
;0000000000600269 : 10
;000000000060026A : 20
;000000000060026B : 30
;000000000060026C : 40
;000000000060026D : 50
