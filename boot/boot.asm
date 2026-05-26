[BITS 16]
[ORG 0x7C00]

start:
    ; Set video mode (clears screen)
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    ; Print message
    mov si, message

print_loop:
    lodsb
    cmp al, 0
    je wait_for_key

    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x0A
    int 0x10

    jmp print_loop

wait_for_key:
    mov ah, 0x00
    int 0x16

halt:
    jmp $

message db "Hello from Bootloader! Press any key...", 0

times 510 - ($ - $$) db 0
dw 0xAA55
