[BITS 16]
[ORG 0x7C00]

start:
    ; Print welcome message
    mov si, message

print_loop:
    lodsb
    cmp al, 0
    je wait_for_key

    mov ah, 0x0E
    int 0x10
    jmp print_loop

wait_for_key:
    ; Wait for key press
    mov ah, 0x00
    int 0x16

    ; Save pressed key (ASCII in AL)
    mov bl, al

    ; New line
    mov ah, 0x0E

    mov al, 0x0D
    int 0x10

    mov al, 0x0A
    int 0x10

    ; Print pressed key
    mov al, bl
    int 0x10

halt:
    jmp halt

message db "Welcome to RohanOS! Press any key:", 0

times 510-($-$$) db 0
dw 0xAA55
