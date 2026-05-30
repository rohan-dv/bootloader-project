[org 0x7C00]
bits 16

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov [boot_drive], dl

menu:
    call clear

    mov si, title
    call print
    call nl

    mov si, opt1
    call print
    call nl

    mov si, opt2
    call print
    call nl

    mov si, opt3
    call print
    call nl

    mov si, sel
    call print

wait_choice:
    mov ah, 0
    int 0x16

    cmp al, '1'
    je load_shell

    cmp al, '2'
    je about

    cmp al, '3'
    je load_kernel

    jmp wait_choice

load_shell:
    mov bx, 0x8000
    mov cl, 2
    mov al, 1
    call load_sector
    jmp 0x8000

load_kernel:
    mov bx, 0x9000
    mov cl, 3
    mov al, 1
    call load_sector
    jmp 0x9000

about:
    call clear
    mov si, about_msg
    call print
    call nl

    mov si, back_msg
    call print

    mov ah, 0
    int 0x16
    jmp menu

load_sector:
    mov ah, 0x02
    mov ch, 0
    mov dh, 0
    mov dl, [boot_drive]
    int 0x13
    jc disk_error
    ret

disk_error:
    mov si, err
    call print
    jmp $

print:
.loop:
    lodsb
    cmp al, 0
    je .done
    mov ah, 0x0E
    int 0x10
    jmp .loop

.done:
    ret

nl:
    mov ah, 0x0E
    mov al, 13
    int 0x10
    mov al, 10
    int 0x10
    ret

clear:
    mov ax, 0x0003
    int 0x10
    ret

title db 'Rohan Bootloader',0
opt1 db '1 Shell',0
opt2 db '2 About',0
opt3 db '3 Kernel',0
sel db 'Select: ',0

about_msg db 'x86 BIOS bootloader',0
back_msg db 'Press any key',0
err db 'Disk error',0

boot_drive db 0

times 510 - ($ - $$) db 0
dw 0xAA55
