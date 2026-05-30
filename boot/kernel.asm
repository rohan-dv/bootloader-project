[org 0x9000]
bits 16

start:
    mov si, msg
    call print_string

hang:
    jmp hang

print_string:
.loop:
    lodsb
    cmp al, 0
    je .done

    mov ah, 0x0E
    int 0x10
    jmp .loop

.done:
    ret

msg db 'Tiny Kernel loaded successfully!', 0
