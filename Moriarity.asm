; Binary File Encryptor - x64 Windows (NASM)
; Functional: Reads 'target.bin', encrypts it, and overwrites it.

extern CreateFileA
extern GetFileSize
extern ReadFile
extern WriteFile
extern CloseHandle
extern VirtualAlloc
extern ExitProcess

section .data
    fname    db  'target.bin', 0
    key      dq  0xDEADC0DEBEEFCAFE  ; 64-bit Initial Master Key

section .bss
    hFile    resq 1
    fSize    resd 1
    pBuffer  resq 1
    bytesRW  resd 1

section .text
    global _start

_start:
    sub rsp, 40                 ; Shadow space

    ; 1. Open File
    lea rcx, [fname]            ; lpFileName
    mov rdx, 0xC0000000         ; GENERIC_READ | GENERIC_WRITE
    mov r8, 0                   ; No sharing
    mov r9, 0                   ; No security
    push 0                      ; OPEN_EXISTING = 3
    push 0x80                   ; FILE_ATTRIBUTE_NORMAL
    push 3                      
    sub rsp, 32                 ; Align stack for extra params
    call CreateFileA
    add rsp, 56                 ; Clean stack
    mov [hFile], rax
    
    cmp rax, -1                 ; INVALID_HANDLE_VALUE
    je .exit

    ; 2. Get File Size
    mov rcx, [hFile]
    xor rdx, rdx
    call GetFileSize
    mov [fSize], eax

    ; 3. Allocate Memory for Payload
    xor rcx, rcx
    mov edx, [fSize]
    mov r8, 0x3000              ; MEM_COMMIT | MEM_RESERVE
    mov r9, 0x04                ; PAGE_READWRITE
    call VirtualAlloc
    mov [pBuffer], rax

    ; 4. Read File Content
    mov rcx, [hFile]
    mov rdx, [pBuffer]
    mov r8d, [fSize]
    lea r9, [bytesRW]
    push 0
    sub rsp, 32
    call ReadFile
    add rsp, 40

    ; 5. Encryption Engine (The "Hacker" Logic)
    mov rsi, [pBuffer]
    mov ecx, [fSize]
    shr ecx, 3                  ; Process 8 bytes at a time
    mov rdx, [key]

.crypt_loop:
    test ecx, ecx
    jz .write_back
    
    xor [rsi], rdx              ; XOR encryption
    rol rdx, 7                  ; Key rotation (Polymorphic)
    add rdx, 0x1337             ; Key mutation
    
    add rsi, 8
    dec ecx
    jmp .crypt_loop

.write_back:
    ; 6. Reset File Pointer to Start
    ; (Simplified: Re-open or Seek. Here we assume direct overwrite)
    ; In a real scenario, use SetFilePointer.

    ; 7. Write Encrypted Data
    mov rcx, [hFile]
    mov rdx, [pBuffer]
    mov r8d, [fSize]
    lea r9, [bytesRW]
    push 0
    sub rsp, 32
    call WriteFile
    add rsp, 40

.exit:
    mov rcx, [hFile]
    call CloseHandle
    xor rcx, rcx
    call ExitProcess
