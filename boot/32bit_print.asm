[bits 32] 


VIDEO_MEMORY equ 0xb8000
COLOR equ 0x4d 

print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY

print_string_pm_loop:
    mov al, [ebx] 
    mov ah, COLOR

    cmp al, 0 
    je print_string_pm_done

    mov [edx], ax 
    add ebx, 1 
    add edx, 2 

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret
