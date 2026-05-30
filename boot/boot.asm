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

    ; save boot drive from BIOS
    mov [boot_drive], dl

    ; loading text
    mov si, loading_msg
    call print_string

    ; read stage 2 from disk
    mov ah, 0x02        ; BIOS read sectors
    mov al, 1           ; sectors to read
    mov ch, 0           ; cylinder
    mov cl, 2           ; sector number (after boot sector)
    mov dh, 0           ; head

    mov dl, [boot_drive]
    mov bx, 0x8000      ; load address

    int 0x13
    jc disk_error

    ; jump to loaded shell
    jmp 0x0000:0x8000


disk_error:
    mov si, error_msg
    call print_string
    jmp $


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


loading_msg db 'Loading shell...', 0
error_msg db 'Disk read failed', 0

boot_drive db 0

times 510 - ($ - $$) db 0
dw 0xAA55
