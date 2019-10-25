[org 0x7c00]
KERNEL_OFFSET equ 0x1000 

    mov [BOOT_DRIVE], dl 
    mov bp, 0x9000
    mov sp, bp
    ;call print_string1
    call start1

start2:

    mov bp, 0x9000
    mov sp, bp

    call disk_load
    call switch_to_pm
    mov ah, 0
    int 0x10
    mov ax, 0
    int 0x16
    jmp $


%include "boot/print.asm"
%include "boot/print_hex.asm"
%include "boot/disk.asm"
%include "boot/gdt.asm"
%include "boot/32bit_print.asm"
%include "boot/switch_pm.asm"


start_os_intro db 'Welcome to DarkraiOS!',0
press_key db '>> Press any key <<',0

;HELLO:
 ;   db 'Hi, this is the bootloader. Sorry for the text above.', 0\

[bits 16]
;print_string1:
 ;   mov bx, HELLO
  ;  call print
   ; mov ax,0x00
    ;int 0x16
    ;ret
load_kernel:

                        
    
    mov bx, KERNEL_OFFSET 
    mov dh, 1 
    ; mov si,[BOOT_DRIVE]   
    ; call print_string
    ; mov ax, 0x00
    ; int 0x16
    mov dl, [BOOT_DRIVE]
    jmp start2 


start1:


	mov ax, 0x0          
	mov ds, ax           
	mov es, ax           
	mov bx,0x8000
	mov ah,0 ;clearScreen 
	int 0x10       
	mov ah,02 ;big font
    int 0x10
    ; ;call print_string1
	;Position
	mov ah,0x02         
	mov bh,0x00         
	mov dh,0x06         
	mov dl,0x09  
    int 0x10
    ;mov bx, HELLO
    ;call print                 
	; mov si, start_os_intro    
    ; call print_string    
    mov ax, 0x00
    int 0x16
               	    

	;New Position
	mov ah,0x02
	mov bh,0x00
	mov dh,0x10
	mov dl,0x0a
	int 0x10
	mov si, press_key                    
	call print_string       
	mov ax,0x00         
	int 0x16            

    mov ah, 0x02                    
	mov al, 1                       
	mov dl, 0x00 ;load from hard drive                    
	mov ch, 0                       
	mov dh, 0                       
	mov cl, 2                      
	mov bx, Stage_2             
	int 0x13                      
    jmp Stage_2

print_string:
	mov ah, 0x0E            
.next_char:
	lodsb   			 
	cmp al, 0             		 
	je .done_print		    	 
	int 0x10                	 
	jmp .next_char   	 
.done_print:
	ret  

	;Load Second Sector Strin

    
[bits 32]
BEGIN_PM:

    mov ebx, start_os_intro
    call print_string_pm
    call KERNEL_OFFSET 
    jmp $ 


BOOT_DRIVE db 0 

times 510 - ($-$$) db 0
dw 0xaa55

[bits 16]

Stage_2 :

    
	mov al,2 ;change font             
	mov ah,0 ;clear screen             
	int 0x10               
	;call print_string
	mov cx,0 ;counter                

	;Position
	mov ah,0x02
	mov bh,0x00
	mov dh,0x00
	mov dl,0x00
	int 0x10
	mov si,name_label              
	call print_string               
	
	;Position 2
	mov ah,0x02
	mov bh,0x00
	mov dh,0x02
	mov dl,0x00
	int 0x10
	mov si, enter_username          
	call print_string 


getUserinput:
	mov ax,0x00             
	int 0x16		        
	cmp ah,0x1C ;Enter          
	je .exitinput

	cmp ah,0x01 ;Escape            
	je skip_Login

	mov ah,0x0E ;Display Input char         
	int 0x10
	jmp getUserinput   

.exitinput:
	hlt
	
	;Position 2
	mov ah,0x02
	mov bh,0x00
	mov dh,0x03
	mov dl,0x00
	int 0x10
	mov si, enter_password               
	call print_string

getPassinput:
	mov ax,0x00
	int 0x16
	cmp ah,0x1C
	je .exitinput ;Enter
	cmp ah,0x01
	je skip_Login ;Skip / Escape

	jmp getPassinput

.exitinput:
	hlt

	;Center Position

	mov ah,0x02
	mov bh,0x00
	mov dh,0x08
	mov dl,0x12
	int 0x10
	mov si, text		
	call print_string
	
	;Next Line
	mov ah,0x02
	mov bh,0x00
	mov dh,0x9
	mov dl,0x8
	int 0x10
	mov si, info		
	call print_string
	
	mov ah,0x02
	mov bh,0x00
	mov dh,0x11
	mov dl,0x11
	int 0x10
	mov si, press_key_2		
	call print_string
	mov ah,0x00
	int 0x16

skip_Login:
	
	mov ah, 0x03                    
	mov al, 1
	mov dl, 0x00
	mov ch, 0
	mov dh, 0
	mov cl, 3                       
	mov bx, load_kernel 
	int 0x13
	jmp load_kernel

enter_username db 'Username >>> ',0
enter_password db 'Password >>> ',0
text db 'Welcome to our Operating System', 0
info db 10, 'Created By - Aditya, Anshuman, Anup, Ayush & Ujjawal',13,0
press_key_2 db 10,'Press any key to get back to Home Screen',0
name_label db 'Enter Login Details:', 0	

	times (1024 - ($-$$)) db 0x00