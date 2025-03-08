.global _start
.intel_syntax noprefix

.section .text

# does base^exponent (Callable)
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


# Turns a string into an int64 (Callable)
# Args 
#   rax | char* string 
#   rbx | int8 len 
# Returns
#   rax | int64 value  
StringToInt:
    # Psuedocode
    # example : 1 2 3 4 len = 4
    # total += index * 10^len-index-1
    # index++ repeat    

    # Initialize the current index (Will only use 8 bits of this value)
    mov rsi, 0

    # Initialize the return value
    mov r15, 0

    # Initialize other values
    mov rcx, 0
    mov rdx, 0

    jmp StringToInt_Loop

StringToInt_Loop:

    # Get the values from the stack

    add rax, rsi # Get the position of rax + index
    mov cl, [rax] # Copy the byte at rax into register
    sub rax, rsi # Return rax back to normal

    sub cl, '0'  # Turn into the values from 0 - 9

    # Currently using rax, rbx, cl, sil, r15 
    push rax
    push rbx 
    push rcx
    push rsi 
    push r15

    # Pow(10, len-index-1)
    mov rax, 10
    sub bl, sil 
    dec bl 
    movzx rbx, bl
    call Pow
    mov rdx, rax

    # Retrieve values
    pop r15
    pop rsi 
    pop rcx 
    pop rbx
    pop rax

    movzx rcx, cl
    imul rcx, rdx # Multiply the digit by the exponent
    add r15, rcx # Add total to return value

    inc rsi  # index++
    cmp rsi, rbx 
    je  StringToInt_Return
    jmp StringToInt_Loop
    
StringToInt_Return:
    mov rax, r15 
    ret 

loop:

    mov rax, 1
    mov rdi, 1
    lea rsi, inputBuffer
    mov rdx, 4 
    syscall

    dec r15
    cmp r15, 0
    je  exit
    jmp loop
   


_start:
    mov rax, 0
    mov rdi, 0
    lea rsi, inputBuffer  # rsi = &inputBuffer
    mov rdx, 4 
    syscall

    lea rax, inputBuffer
    mov rbx, 3
    call StringToInt
    mov r15, rax

    jmp loop

exit:
    mov rax, 60
    mov rdi, 0
    syscall

.section .bss

.section .data
inputBuffer: .skip 8 











