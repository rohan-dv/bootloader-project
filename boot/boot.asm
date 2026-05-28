[org 0x7C00]
bits 16

start:
    ; setup segments
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax
    mov sp, 0x7C00

    ; welcome message
    mov si, message
    call print_string
    call newline

    ; first prompt
    mov si, prompt
    call print_string

main_loop:
    ; wait for key
    mov ah, 0
    int 0x16

    ; Enter key
    cmp al, 13
    je handle_enter

    ; Backspace key
    cmp al, 8
    je handle_backspace

    ; don't overflow buffer
    mov bl, [buffer_index]
    cmp bl, 63
    je main_loop

    ; store typed char in buffer
    mov bh, 0
    mov si, buffer
    add si, bx
    mov [si], al

    ; move index forward
    inc byte [buffer_index]

    ; print typed char
    mov ah, 0x0E
    int 0x10

    jmp main_loop


handle_enter:
    ; add string ending
    mov bl, [buffer_index]
    mov bh, 0
    mov si, buffer
    add si, bx
    mov byte [si], 0

    call newline

    ; check help
    mov si, buffer
    mov di, help_cmd
    call compare_strings

    cmp al, 1
    je run_help

    ; check clear
    mov si, buffer
    mov di, clear_cmd
    call compare_strings

    cmp al, 1
    je run_clear

    ; check echo
    mov si, buffer
    mov di, echo_cmd
    call starts_with

    cmp al, 1
    je run_echo

    ; unknown command
    mov si, unknown_text
    call print_string
    jmp reset_input


run_help:
    mov si, help_text_1
    call print_string
    call newline

    mov si, help_text_2
    call print_string
    call newline

    mov si, help_text_3
    call print_string
    call newline

    jmp reset_input


run_clear:
    call clear_screen
    jmp reset_input


run_echo:
    ; skip "echo "
    mov si, buffer
    add si, 5
    call print_string
    call newline
    jmp reset_input


reset_input:
    ; reset buffer
    mov byte [buffer_index], 0
    mov byte [buffer], 0

    ; show prompt again
    mov si, prompt
    call print_string

    jmp main_loop


handle_backspace:
    ; nothing to delete
    cmp byte [buffer_index], 0
    je main_loop

    ; move index back
    dec byte [buffer_index]

    ; remove char visually
    mov ah, 0x0E

    mov al, 8
    int 0x10

    mov al, ' '
    int 0x10

    mov al, 8
    int 0x10

    jmp main_loop


print_string:
.print_loop:
    lodsb
    cmp al, 0
    je .done

    mov ah, 0x0E
    int 0x10
    jmp .print_loop

.done:
    ret


newline:
    ; next line
    mov ah, 0x0E

    mov al, 13
    int 0x10

    mov al, 10
    int 0x10

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
    mov al, 1
    ret

.not_equal:
    mov al, 0
    ret


starts_with:
.check_loop:
    mov al, [di]

    ; reached end of command
    cmp al, 0
    je .check_space

    mov bl, [si]

    cmp al, bl
    jne .no_match

    inc si
    inc di
    jmp .check_loop

.check_space:
    ; echo must be followed by a space
    cmp byte [si], ' '
    jne .no_match

    mov al, 1
    ret

.no_match:
    mov al, 0
    ret


clear_screen:
    ; clear whole screen
    mov ax, 0x0003
    int 0x10
    ret


message db 'Simple Bootloader', 0

prompt db '> ', 0

help_cmd db 'help', 0
clear_cmd db 'clear', 0
echo_cmd db 'echo', 0

help_text_1 db 'Commands:', 0
help_text_2 db 'help clear', 0
help_text_3 db 'echo', 0

unknown_text db 'Unknown command', 0

; typed input goes here
buffer times 64 db 0

; current typing position
buffer_index db 0


times 510 - ($ - $$) db 0
dw 0xAA55
