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
    jl  IntToString_Finalize
    
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

IntToString_Finalize:
    cmp bl, 1
    je  IntToString_Return 
    mov byte ptr [r15], '0'  # Helps with the edge case of passing through zero 
    jmp IntToString_Return

IntToString_Return:
    ret


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


_start:

    # input first value
    mov rax, 0
    mov rdi, 0
    lea rsi, inputBuffer1 
    mov rdx, 20 
    syscall

    # input operator (+, -, *, /) value
    mov rax, 0
    mov rdi, 0
    lea rsi, operatorBuffer 
    mov rdx, 2 
    syscall
    
    # input second value
    mov rax, 0
    mov rdi, 0
    lea rsi, inputBuffer2
    mov rdx, 20
    syscall

    lea rax, inputBuffer1
    call StringToInt
    mov number1, rax

    lea rax, inputBuffer2
    call StringToInt
    mov number2, rax

    mov rax, number1
    mov rbx, number2
    mov sil, operatorBuffer
    cmp sil, '+'
    je  add
    cmp sil, '-'
    je  sub
    cmp sil, '*'
    je  mul
    cmp sil, '/'
    je  div

add:
    add rax, rbx
    jmp out

sub:
    sub rax, rbx
    jmp out

mul:
    imul rax, rbx
    jmp out

div:
    xor rdx, rdx 
    idiv rbx
    jmp out

out:
    lea rbx, outputBuffer
    call IntToString

    mov rax, 1
    mov rdi, 1
    lea rsi, outputBuffer
    mov rdx, 21
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


.section .data
inputBuffer1: .skip 21 
inputBuffer2: .skip 21 
operatorBuffer: .skip 2
number1: .quad 0
number2: .quad 0
outputBuffer: .skip 20
newline: .asciz "\n"
