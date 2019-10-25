
[org 0x7c00]
KERNEL_OFFSET equ 0x1000 

    mov [BOOT_DRIVE], dl 
    mov bp, 0x9000
    mov sp, bp
    
    call load_kernel 
    call switch_to_pm 
    jmp $ 

%include "boot/print.asm"
%include "boot/print_hex.asm"
%include "boot/disk.asm"
%include "boot/gdt.asm"
%include "boot/32bit_print.asm"
%include "boot/switch_pm.asm"

[bits 16]
load_kernel:
    
    mov bx, KERNEL_OFFSET 
    mov dh, 1 
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:

    call KERNEL_OFFSET 
    jmp $ 


BOOT_DRIVE db 0 

times 510 - ($-$$) db 0
dw 0xaa55
