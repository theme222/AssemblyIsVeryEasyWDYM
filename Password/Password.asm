# God help me
.global _start
.intel_syntax noprefix

.section .text

compare: 
    # bufPasswordInput: input 
    # superSecretPassword: password
    mov al, [rdi]
    mov bl, [rsi]
    
    # Compare the two values 
    cmp al, bl
    jne IncorrectPassword

    # Check if it is the end of the string
    cmp bl, 0
    je  CorrectPassword

    inc rdi 
    inc rsi 
    jmp compare

CorrectPassword: # Print secret message
    mov rax, 1
    mov rdi, 1
    lea rsi, [secretMessage]
    mov rdx, 48
    syscall 
    jmp exit 

IncorrectPassword: # Print fail message
    mov rax, 1
    mov rdi, 1
    lea rsi, [failMessage]
    mov rdx, 37
    syscall
    jmp exit
    
exit:
    # return 0 
    mov rax, 60
    mov rdi, 0 
    syscall

_start:

    # Input password
    mov rax, 0
    mov rdi, 0
    lea rsi, [bufPasswordInput] 
    mov rdx, 100
    syscall 
    
    # Get pointer to first index into rdi (input), rsi (password)
    lea rdi, [bufPasswordInput]
    lea rsi, [superSecretPassword]

    # Compare the input with the password
    jmp compare

.section .data
bufPasswordInput: .space 100, 0  # initialize a 100 character length string with the \0 value as default
superSecretPassword: .asciz "123456789\n"
secretMessage: .asciz "Yooo you got the secret message wow!!!!!!!!!!!!\n" # string message = "Hello World!\n"
failMessage: .asciz "It's so joever why you skill issue?\n" # 37


