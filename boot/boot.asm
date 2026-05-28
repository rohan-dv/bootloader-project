BITS 16
ORG 0x7C00

start:
    mov ax, 0
    mov ds, ax
    mov es, ax

    mov si, welcome_msg
    call print_string

main_loop:
    mov si, prompt
    call print_string

    mov di, input_buffer

read_input:
    mov ah, 0
    int 0x16

    cmp al, 13
    je enter_pressed

    cmp al, 8
    je backspace_pressed

    mov [di], al
    inc di

    mov ah, 0x0E
    int 0x10

    jmp read_input

backspace_pressed:
    cmp di, input_buffer
    je read_input

    dec di

    mov ah, 0x0E
    mov al, 8
    int 0x10

    mov al, ' '
    int 0x10

    mov al, 8
    int 0x10

    jmp read_input

enter_pressed:
    mov byte [di], 0

    mov ah, 0x0E
    mov al, 13
    int 0x10

    mov al, 10
    int 0x10

    jmp main_loop

print_string:
    mov ah, 0x0E

.print_loop:
    lodsb
    cmp al, 0
    je .done

    int 0x10
    jmp .print_loop

.done:
    ret

welcome_msg db "Bootloader started!",13,10,0
prompt db "> ",0

input_buffer times 64 db 0

times 510-($-$$) db 0
dw 0xAA55
