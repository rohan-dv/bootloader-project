[BITS 16]
[ORG 0x7C00]

start:
    ; Print welcome message
    mov si, message

print_loop:
    lodsb
    cmp al, 0
    je keyboard_loop

    mov ah, 0x0E
    int 0x10
    jmp print_loop


keyboard_loop:
    ; Wait for key press
    mov ah, 0x00
    int 0x16

    ; Print pressed key
    mov ah, 0x0E
    int 0x10

    ; Keep listening forever
    jmp keyboard_loop


message db "Welcome to RohanOS! Type something: ", 0

times 510-($-$$) db 0
dw 0xAA55
