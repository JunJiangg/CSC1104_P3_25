    .text                            // Code section begins

    // DATA SECTION - Read-only strings

    .section .rodata
prompt:
    .string "Enter an integer: "
format_in:
    .string "%d"                     // Format string for scanf
msg_prime:
    .string "The keyed-in number %d is a prime number.\n"
msg_not_prime:
    .string "The keyed-in number %d is not a prime number.\n"

    // ================================
    // CODE SECTION
    // ================================
    .text
    .global main                     // Make main visible to linker
    .type main, %function

// ================================
// Function to determine if a number is prime
// Input:   w0 = integer to check for primality
// Output:  w0 = 1 if prime, 0 if not prime
// Algorithm: Trial division up to sqrt(n)
// ================================
check_prime:
    // --- Function: Save registers and set up stack frame ---
    stp x29, x30, [sp, -32]!    // Push frame pointer (x29) and link register (x30)
                                 // Move sp down by 32 bytes to have empty memory space
    mov x29, sp                  // Set frame pointer to current stack pointer
    str w19, [sp, 16]            // Store value of w19 into stack
    
    mov w19, w0                  // Save input number (n) from w0 into w19
    
    // --- Check if n <= 1 (base case) ---
    cmp w19, 1                   // Compare n (in w19) with 1
    ble not_prime                // Branch if n <= 1 (not prime by definition)
    
    // --- Initialize loop: i = 2 ---
    mov w1, 2                    // w1 = i (loop counter starts at 2)
    
loop_start:
    // --- Check loop condition: i * i <= n ---
    mul w2, w1, w1               // w2 = i * i (square of current divisor)
    cmp w2, w19                  // Compare i*i with n
    bgt is_prime                 // If i*i > n, no divisors found, it's prime
    
    // --- Check if n is divisible by i (n % i == 0) ---
    sdiv w3, w19, w1             // w3 = n / i (signed division)
    msub w4, w3, w1, w19         // [msub: multiply-subtract instruction] | w4 = n - (n/i)*i = n % i (modulo operation)
    
    cbz w4, not_prime            // Compare and Branch if Zero: if remainder == 0, not prime
    
    // - Increment loop counter and continue -
    add w1, w1, 1                // i = i + 1 (next divisor to test)
    b loop_start                 // Branch back to start of loop

is_prime:
    mov w0, 1                    // Return true (1) - number is prime
    b check_prime_end            // Jump to function epilogue

not_prime:
    mov w0, 0                    // Return false (0) - number is not prime

check_prime_end:
    // -- Restore registers and return --
    ldr w19, [sp, 16]            // Restore w19 from stack
    ldp x29, x30, [sp], 32       // Pop frame pointer and link register
                                 // Post-increment sp by 32 bytes
    ret                          // Return to caller (address in x30)

// ================================
// main is the entry point
// - Prompts user for input
// - Reads an integer
// - Checks if it's prime
// - Displays the result
// ================================
main:
    // --- Function  ---
    stp x29, x30, [sp, -32]!     // Save frame pointer and link register
    mov x29, sp                   // Set up frame pointer
    
    // --- Print prompt: "Enter an integer: " ---
    adrp x0, prompt               // Load high 21 bits of prompt address
    add x0, x0, :lo12:prompt      // Add low 12 bits to complete address
    bl printf                     // Call printf function
    
    // --- Read integer input from user ---
    sub sp, sp, 16                // Allocate 16 bytes on stack for input variable
    adrp x0, format_in            // Load address of format string "%d"
    add x0, x0, :lo12:format_in   // Complete the address
    mov x1, sp                    // x1 = address where scanf will store input
    bl scanf                      // Call scanf to read integer
    
    // --- Load the input number into register ---
    ldr w19, [sp]                 // w19 = user's input number (load from stack)
    add sp, sp, 16                // Deallocate stack space (clean up)
    
    // --- Call check_prime function ---
    mov w0, w19                   // w0 = number to check (function argument)
    bl check_prime                // Call check_prime function
                                  // Returns: w0 = 1 if prime, 0 if not
    
    // --- Check result and print appropriate message ---
    cbz w0, print_not_prime       // If w0 == 0 (not prime), jump to print_not_prime
    
print_prime:
    // Print: "The keyed-in number X is a prime number."
    adrp x0, msg_prime            // Load address of prime message
    add x0, x0, :lo12:msg_prime   // Complete the address
    mov w1, w19                   // w1 = the number (for %d in format string)
    bl printf                     // Call printf
    b main_end                    // Skip the not_prime section
    
print_not_prime:
    // Print: "The keyed-in number X is not a prime number."
    adrp x0, msg_not_prime        // Load address of not-prime message
    add x0, x0, :lo12:msg_not_prime // Complete the address
    mov w1, w19                   // w1 = the number (for %d in format string)
    bl printf                     // Call printf
    
main_end:
    // --- Function Epilogue: Clean up and return ---
    mov w0, 0                     // Return 0 (success status)
    ldp x29, x30, [sp], 32        // Restore frame pointer and link register
    ret                           // Return to operating system

    .size main, .-main            // Define size of main function for linker