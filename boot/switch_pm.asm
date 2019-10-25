[bits 16]
switch_to_pm:
    mov ah, 0
    int 0x10
    int 0x16
  
    cli 
    lgdt [gdt_descriptor] 


    mov eax, cr0
    or eax, 0x1 
    ; mov bx, Hey
    ; call print
    ; mov ax, 0
    ; int 0x16
    ; mov ah, 0
    ; int 0x10
    ; int 0x16
    mov cr0, eax
    ; mov ebx, 0xb8000
    ; mov al, '!'
    ; mov ah, 0x0F
    ; mov [ebx], ax
    jmp CODE_SEG:init_pm 

Hey:
    db "Hey", 0
[bits 32]
init_pm: 

    mov ebx, 0xb8000
    mov al, '!'
    mov ah, 0x0F
    mov [ebx], ax

    mov ax, DATA_SEG 
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 
    mov esp, ebp


    call BEGIN_PM 
