[BITS 16]
[ORG 0x7C00]

start:
    mov si, message

print_loop:
    lodsb               ; load next character into AL
    cmp al, 0
    je halt

    mov ah, 0x0E        ; BIOS teletype function
    int 0x10            ; print character

    jmp print_loop

halt:
    jmp $

message db "Hello from Bootloader!", 0

times 510 - ($ - $$) db 0
dw 0xAA55
