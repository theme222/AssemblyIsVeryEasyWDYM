# God help me
.global _start
.intel_syntax noprefix

.section .text
_start:
       # puts(message)
    mov rax, 1
    mov rdi, 1
    lea rsi, [message]
    mov rdx, 13
    syscall



    # return 0 
    mov rax, 60
    mov rdi, 0 
    syscall


.section .data
message: .asciz "Hello World!\n" # string message = "Hello World!\n"



