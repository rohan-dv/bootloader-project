BITS 16
ORG 0x7C00

start:
    ; initialize segment registers
    mov ax, 0
    mov ds, ax
    mov es, ax

    ; print startup message
    mov si, welcome_msg
    call print_string

main_loop:
    ; show prompt
    mov si, prompt
    call print_string

    ; start storing input from beginning of buffer
    mov di, input_buffer

read_input:
    ; wait for key press
    mov ah, 0
    int 0x16

    ; Enter key
    cmp al, 13
    je enter_pressed

    ; Backspace key
    cmp al, 8
    je backspace_pressed

    ; store typed character
    mov [di], al
    inc di

    ; print typed character
    mov ah, 0x0E
    int 0x10

    jmp read_input

backspace_pressed:
    ; avoid deleting beyond start of buffer
    cmp di, input_buffer
    je read_input

    dec di

    ; erase character from screen
    mov ah, 0x0E

    mov al, 8
    int 0x10

    mov al, ' '
    int 0x10

    mov al, 8
    int 0x10

    jmp read_input

enter_pressed:
    ; add null terminator to end input string
    mov byte [di], 0

    ; move to next line
    mov ah, 0x0E

    mov al, 13
    int 0x10

    mov al, 10
    int 0x10

    ; check entered command
    call process_command

    jmp main_loop


process_command:
    ; check for "help"
    mov si, input_buffer
    mov di, help_cmd
    call compare_strings
    cmp ax, 1
    je help_found

    ; check for "clear"
    mov si, input_buffer
    mov di, clear_cmd
    call compare_strings
    cmp ax, 1
    je clear_found

    ; check for "reboot"
    mov si, input_buffer
    mov di, reboot_cmd
    call compare_strings
    cmp ax, 1
    je reboot_found

    ; check for "echo ..."
    mov si, input_buffer
    mov di, echo_cmd
    call starts_with
    cmp ax, 1
    je echo_found

    jmp unknown


help_found:
    mov si, help_message
    call print_string
    ret


clear_found:
    ; clear screen by resetting video mode
    mov ax, 0x0003
    int 0x10
    ret


reboot_found:
    ; reboot system using BIOS interrupt
    int 0x19
    ret


echo_found:
    ; skip "echo "
    mov si, input_buffer
    add si, 5

    ; print remaining text
    call print_string

    ; newline
    mov ah, 0x0E

    mov al, 13
    int 0x10

    mov al, 10
    int 0x10

    ret


unknown:
    mov si, unknown_message
    call print_string
    ret


compare_strings:
.compare_loop:
    mov al, [si]
    mov bl, [di]

    ; stop if characters don't match
    cmp al, bl
    jne .not_equal

    ; both ended -> equal
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


starts_with:
.loop:
    ; end of prefix means success
    mov al, [di]
    cmp al, 0
    je .match

    mov al, [si]
    mov bl, [di]

    ; mismatch
    cmp al, bl
    jne .fail

    inc si
    inc di
    jmp .loop

.match:
    mov ax, 1
    ret

.fail:
    mov ax, 0
    ret


print_string:
    mov ah, 0x0E

.print_loop:
    ; load next character
    lodsb

    ; stop at null terminator
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
echo_cmd db "echo ",0

help_message db "Commands: help clear reboot echo",13,10,0
unknown_message db "Unknown command",13,10,0

; stores user input
input_buffer times 64 db 0

; fill remaining bytes and add boot signature
times 510-($-$$) db 0
dw 0xAA55
