.global _start
.intel_syntax noprefix

.section .text
exit:
    mov rax, 1
    mov rdi, 1
    lea rsi, [newLineChar] 
    mov rdx, 1 
    syscall
    
    mov rax, 60
    mov rdi, 0
    syscall

CheckStillWorking:
    mov rax, 1
    mov rdi, 1
    lea rsi, [workingText]
    mov rdx, 22
    syscall
    ret

increment:
    mov al, [inputBuffer]
    sub al, '0'
    mov bl, [incrementVar]
    cmp al, bl 
    je  exit    

    inc byte ptr [incrementVar] 
    call CheckStillWorking
    jmp increment

_start:
    # Read shit from stdin
    mov rax, 0
    mov rdi, 0
    lea rsi, [inputBuffer]
    mov rdx, 1
    syscall

    jmp increment 

.section .data

inputBuffer: .byte 0
incrementVar: .byte 0 
newLineChar: .asciz "\n"
workingText: .asciz "Yes I'm still working\n"  # 22 values
