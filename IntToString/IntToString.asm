.global _start
.intel_syntax noprefix

.section .text

# Does base^exponent (Callable)
# Args 
#   rax | int64 base 
#   rbx | int8 exponent 
# Returns
#   rax | int64 
Pow:
    # Initialize rcx
    mov rcx, 1
    cmp bl, 0
    je Pow_Return  
    jmp Pow_Loop

Pow_Loop:
    imul rcx, rax
    dec bl
    cmp bl, 0
    je Pow_Return
    jmp Pow_Loop

Pow_Return:
    mov rax, rcx
    ret


# Turns integer into a string (Callable)
# Args
#   rax | int64 integer
#   rbx | char* string buffer (Length at least 20)
# Returns
IntToString:

    # Psuedocode
    # n = 0
    # x = 19
    # while x >= 0
    #   string[n] += number // 10^x
    #   n ++
    #   x --
    #   return string

    mov r15, rbx
    mov rdi, 19  # Power number (x)
    mov bl,  0   # bool value if we have passed the beginning zeros
    jmp IntToString_Divide

IntToString_Divide:
    cmp rdi, 0
    jl  IntToString_Return
    
    # Currently using rax, rbx, rdi, r15
    push rax
    push rbx
    push rdi
    push r15

    # Call 10 ^ x
    mov rax, 10
    mov rbx, rdi 
    call Pow
    mov rcx, rax  # Save the return value
    
    pop r15
    pop rdi
    pop rbx
    pop rax

    xor rdx, rdx  # Clear rdx prepare for division (Unused upper half)
    div rcx  # rdx:rax / rcx -> rax = qoutient, rdx = remainder

    cmp rax, 0
    jne IntToString_SetChar
    cmp bl, 1  # Check if we have passed the beginning zeros
    je  IntToString_SetChar

    mov rax, rdx  # Move the remainder to go back through the loop
    dec rdi
    jmp IntToString_Divide


IntToString_SetChar:
    mov bl, 1  # Set the bool value to true

    mov byte ptr [r15], '0'  # Set value to zero
    add byte ptr [r15], al   # Add to the byte with the qoutient
    inc r15

    mov rax, rdx  # Move the remainder to go back through the loop
    dec rdi
    jmp IntToString_Divide

IntToString_Return:
    ret

_start:

    mov rax, bigBoiNumber
    imul rax, 5
    mov bigBoiNumber, rax

    mov rax, bigBoiNumber
    lea rbx, outputBuffer
    call IntToString


    mov rax, 1
    mov rdi, 1
    lea rsi, outputBuffer
    mov rdx, 20 
    syscall
    jmp exit

exit:
    mov rax, 1
    mov rdi, 1
    lea rsi, newline
    mov rdx, 1
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

.section .bss

.section .data
inputBuffer: .skip 20 
bigBoiNumber: .quad 2000 
outputBuffer: .skip 20
newline: .asciz "\n"
