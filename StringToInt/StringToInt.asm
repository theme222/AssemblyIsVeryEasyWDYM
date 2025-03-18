.global _start
.intel_syntax noprefix

.section .text

# Turns a string into an int64 (Callable)
# Args 
#   rax | char* string 
# Returns
#   rax | int64 value  
StringToInt:
    # Psuedocode
    # total *= 10  First loop is still zero and 0 * 10 = 0
    # total += value 

    # Initialize the return value
    mov r15, 0

    jmp StringToInt_Loop

StringToInt_Loop:

    mov rcx, 0  # Clear rcx
    # Get the values from the stack
    mov cl, [rax] # Copy the byte at rax into register
    inc rax

    # Terminates the moment it finds a value that isn't a number
    cmp cl, '0'
    jl  StringToInt_Return
    cmp cl, '9'
    jg  StringToInt_Return

    sub cl, '0'  # Turn into the values from 0 - 9
    imul r15, 10  
    add r15, rcx # Add total to return value

    jmp StringToInt_Loop
    
StringToInt_Return:
    mov rax, r15 
    ret 

loop:
    mov rax, 1
    mov rdi, 1
    lea rsi, inputBuffer 
    mov rdx, 20
    syscall

    dec r15
    cmp r15, 0
    jne loop 
    jmp exit

_start:
    mov rax, 0
    mov rdi, 0
    lea rsi, inputBuffer  # rsi = &inputBuffer
    mov rdx, 8 
    syscall

    lea rax, inputBuffer
    call StringToInt
    mov r15, rax
    jmp loop

exit:
    mov rax, 1
    mov rdi, 1
    lea rsi, newline
    mov rdx, 1
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

.section .data
inputBuffer: .skip 21 
newline: .asciz "\n"
