[BITS 16]
[ORG 0x8000]

start:
    mov si, message

print_loop:
    lodsb
    cmp al, 0
    je halt

    mov ah, 0x0E
    int 0x10
    jmp print_loop

halt:
    jmp halt

message db "Hello from Stage 2!", 0
