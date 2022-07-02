; An implementation of FizzBuzz for x86-64 assembly on Linux.

; Syscalls
%define write 0x01
%define exit 0x3c

; Values for syscalls
%define stdout 1
%define exit_success 0

; Data

section .data
    fizz db `Fizz\n`
    fizz_len equ $ - fizz
    buzz db `Buzz\n`
    buzz_len equ $ - buzz
    fizzbuzz db `FizzBuzz\n`
    fizzbuzz_len equ $ - buzz

; Code

section .text

    global _start

_start:

    ; Entry

    ; Save rbx
    push rbx
    ; Use as counter
    mov rbx, 1

iter:

    ; If the counter is 101, then we are done
    cmp rbx, 101
    je end

    ; Check if divisible by 3
    mov rdx, 0
    mov rax, rbx
    mov rcx, 3
    div rcx
    cmp rdx, 0
    jne not_div_3

    ; Check if divisible by 5
    mov rdx, 0
    mov rax, rbx
    mov rcx, 5
    div rcx,
    cmp rdx, 0
    jne print_fizz

    ; Print FizzBuzz
    mov rax, write
    mov rdi, stdout
    mov rsi, fizzbuzz
    mov rdx, fizzbuzz_len
    syscall

    jmp continue

print_fizz:

    ; Print Fizz
    mov rax, write
    mov rdi, stdout
    mov rsi, fizz
    mov rdx, fizz_len
    syscall

    jmp continue

not_div_3:

    ; Check if divisible by 5
    mov rdx, 0
    mov rax, rbx
    mov rcx, 5
    div rcx,
    cmp rdx, 0
    jne print_num

    ; Print Buzz
    mov rax, write
    mov rdi, stdout
    mov rsi, buzz
    mov rdx, buzz_len
    syscall

    jmp continue

print_num:

    ; Print the number
    mov rdi, rbx
    call print_u64

continue:

    ; Perform another iteration of the loop with the counter incremented
    inc rbx
    jmp iter

end:

    ; Restore rbx
    pop rbx

    ; Exit with code 0
    mov rax, exit
    mov rdi, exit_success
    syscall

print_u64:

    ; Prints an unsigned 64 bit integer
    ; Input: rdi

    ; Save stack pointer
    push rbp
    mov rbp, rsp

    ; Store in rax
    mov rax, rdi

    ; Add a newline
    dec rsp
    mov byte [rsp], 10

print_u64_iter:

    ; Divide rax by 10
    mov rdx, 0
    mov r8, 10
    div r8

    ; Add '0' to remainder to get the char
    add rdx, 48
    ; Store char on stack
    dec rsp
    mov [rsp], dl

    ; If the rest is not zero, keep going
    cmp rax, 0
    jne print_u64_iter

    ; Print the bytes
    mov rax, write
    mov rdi, stdout
    mov rsi, rsp
    ; Determine the length
    mov rdx, rbp
    sub rdx, rsp
    syscall

    ; Restore stack pointer
    mov rsp, rbp
    pop rbp

    ; Return without a value
    ret
