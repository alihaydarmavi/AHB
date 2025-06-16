; boot.asm – 512 byte bootloader
BITS 16
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ; mesaj göster
    mov si, boot_msg
    call print_string

    ; TFS kontrolü – Sektör 2'yi oku (LBA 1)
    mov ah, 0x02        ; disk read
    mov al, 1           ; kaç sektör: 1
    mov ch, 0           ; cylinder
    mov cl, 2           ; sector (starts from 1)
    mov dh, 0           ; head
    mov dl, 0x80        ; HDD
    mov bx, 0x8000      ; nereye: ES:BX
    int 0x13

    ; "TFS0" kontrolü
    mov si, 0x8000
    cmp dword [si], '0SFT'
    jne boot_fail

    ; shell.asm (Stage2) yükle – Sektör 3 (LBA 2)
    mov ah, 0x02
    mov al, 1
    mov cl, 3
    mov bx, 0x9000
    int 0x13

    jmp 0x0000:0x9000

boot_fail:
    mov si, fail_msg
    call print_string
    jmp $

print_string:
    mov ah, 0x0E
.next:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .next
.done:
    ret

boot_msg db "TFS Booting...", 0
fail_msg db "TFS Not Found.", 0

TIMES 510 - ($ - $$) db 0
DW 0xAA55

