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

    ; Check Enter key (ASCII 13)
    cmp al, 13
    je handle_enter

    ; Check Backspace key (ASCII 8)
    cmp al, 8
    je handle_backspace

    ; Normal character
    mov ah, 0x0E
    int 0x10
    jmp keyboard_loop


handle_enter:
    mov ah, 0x0E

    ; carriage return
    mov al, 0x0D
    int 0x10

    ; line feed
    mov al, 0x0A
    int 0x10

    jmp keyboard_loop


handle_backspace:
    mov ah, 0x0E

    ; Move cursor back
    mov al, 8
    int 0x10

    ; Print space (erase char)
    mov al, ' '
    int 0x10

    ; Move back again
    mov al, 8
    int 0x10

    jmp keyboard_loop


message db "Welcome to RohanOS! Type something:", 0

times 510-($-$$) db 0
dw 0xAA55
