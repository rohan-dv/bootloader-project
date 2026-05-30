[org 0x9000]
bits 16

start:
    call clear_screen

    mov si, title
    call print_string
    call newline
    call newline

    mov si, prompt
    call print_string

main_loop:
    mov ah, 0
    int 0x16

    cmp al, 13
    je handle_enter

    cmp al, 8
    je handle_backspace

    mov bl, [buffer_index]
    cmp bl, 63
    je main_loop

    mov bh, 0
    mov si, buffer
    add si, bx
    mov [si], al

    inc byte [buffer_index]

    mov ah, 0x0E
    int 0x10

    jmp main_loop


handle_enter:
    mov bl, [buffer_index]
    mov bh, 0
    mov si, buffer
    add si, bx
    mov byte [si], 0

    call newline

    mov si, buffer
    mov di, help_cmd
    call compare_strings
    cmp al, 1
    je run_help

    mov si, buffer
    mov di, info_cmd
    call compare_strings
    cmp al, 1
    je run_info

    mov si, buffer
    mov di, clear_cmd
    call compare_strings
    cmp al, 1
    je run_clear

    mov si, buffer
    mov di, reboot_cmd
    call compare_strings
    cmp al, 1
    je run_reboot

    mov si, unknown_msg
    call print_string
    call newline
    jmp reset_input


run_help:
    mov si, help_msg1
    call print_string
    call newline

    mov si, help_msg2
    call print_string
    call newline

    jmp reset_input


run_info:
    mov si, info_msg1
    call print_string
    call newline

    mov si, info_msg2
    call print_string
    call newline

    mov si, info_msg3
    call print_string
    call newline

    jmp reset_input


run_clear:
    call clear_screen

    mov si, prompt
    call print_string

    jmp clear_buffer


run_reboot:
    int 0x19
    jmp $


reset_input:
    mov si, prompt
    call print_string

clear_buffer:
    mov byte [buffer_index], 0
    mov byte [buffer], 0

    jmp main_loop


handle_backspace:
    cmp byte [buffer_index], 0
    je main_loop

    dec byte [buffer_index]

    mov ah, 0x0E

    mov al, 8
    int 0x10

    mov al, ' '
    int 0x10

    mov al, 8
    int 0x10

    jmp main_loop


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


newline:
    mov ah, 0x0E

    mov al, 13
    int 0x10

    mov al, 10
    int 0x10

    ret


compare_strings:
.loop:
    mov al, [si]
    mov bl, [di]

    cmp al, bl
    jne .not_equal

    cmp al, 0
    je .equal

    inc si
    inc di
    jmp .loop

.equal:
    mov al, 1
    ret

.not_equal:
    mov al, 0
    ret


clear_screen:
    mov ax, 0x0003
    int 0x10
    ret


title db 'Tiny Kernel v1', 0
prompt db 'kernel> ', 0

help_cmd db 'help', 0
info_cmd db 'info', 0
clear_cmd db 'clear', 0
reboot_cmd db 'reboot', 0

help_msg1 db 'Commands:', 0
help_msg2 db 'help info clear reboot', 0

info_msg1 db 'Tiny Kernel v1', 0
info_msg2 db 'Architecture: x86 BIOS', 0
info_msg3 db 'Loaded by: Rohan Bootloader', 0

unknown_msg db 'Unknown command', 0

buffer times 64 db 0
buffer_index db 0
