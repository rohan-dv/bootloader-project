[BITS 16]
[ORG 0x7C00]

start:
    ; Initialize stack
    cli                 ; disable interrupts
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti                 ; enable interrupts

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
    mov ah, 0x00
    int 0x16

    cmp al, 13
    je handle_enter

    cmp al, 8
    je handle_backspace

    mov ah, 0x0E
    int 0x10
    jmp keyboard_loop


handle_enter:
    mov ah, 0x0E

    mov al, 0x0D
    int 0x10

    mov al, 0x0A
    int 0x10

    jmp keyboard_loop


handle_backspace:
    mov ah, 0x0E

    mov al, 8
    int 0x10

    mov al, ' '
    int 0x10

    mov al, 8
    int 0x10

    jmp keyboard_loop


message db "Welcome to RohanOS! Type something:", 0

times 510-($-$$) db 0
dw 0xAA55
