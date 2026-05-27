[BITS 16]
[ORG 0x7C00]

start:
    ; Clear screen (80x25 text mode)
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    ; Print first message
    mov si, message
    call print_string

    ; Wait for a key press
    mov ah, 0x00
    int 0x16

    ; Save pressed key
    mov bl, al

    ; Move to next line
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10

    mov al, 0x0A
    int 0x10

    ; Print second message
    mov si, pressed_msg
    call print_string

    ; Print the pressed key
    mov ah, 0x0E
    mov al, bl
    int 0x10

halt:
    jmp $

; -------------------------
; Print string routine
; -------------------------
print_string:
.next_char:
    lodsb
    cmp al, 0
    je .done

    mov ah, 0x0E
    int 0x10
    jmp .next_char

.done:
    ret

message db "Hello from Bootloader! Press any key...", 0
pressed_msg db "You pressed: ", 0

times 510 - ($ - $$) db 0
dw 0xAA55
