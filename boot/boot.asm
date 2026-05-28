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

    call process_command
    jmp main_loop


process_command:
    ; check help
    mov si, input_buffer
    mov di, help_cmd
    call compare_strings
    cmp ax, 1
    je help_found

    ; check clear
    mov si, input_buffer
    mov di, clear_cmd
    call compare_strings
    cmp ax, 1
    je clear_found

    ; check reboot
    mov si, input_buffer
    mov di, reboot_cmd
    call compare_strings
    cmp ax, 1
    je reboot_found

    jmp unknown


help_found:
    mov si, help_message
    call print_string
    ret


clear_found:
    mov ax, 0x0003
    int 0x10
    ret


reboot_found:
    int 0x19
    ret


unknown:
    mov si, unknown_message
    call print_string
    ret


compare_strings:
.compare_loop:
    mov al, [si]
    mov bl, [di]

    cmp al, bl
    jne .not_equal

    cmp al, 0
    je .equal

    inc si
    inc di
    jmp .compare_loop

.equal:
    mov ax, 1
    ret

.not_equal:
    mov ax, 0
    ret


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

help_cmd db "help",0
clear_cmd db "clear",0
reboot_cmd db "reboot",0

help_message db "Commands: help clear reboot",13,10,0
unknown_message db "Unknown command",13,10,0

input_buffer times 64 db 0

times 510-($-$$) db 0
dw 0xAA55
