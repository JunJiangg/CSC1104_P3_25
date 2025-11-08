.global main
.extern printf

.section .data
    // Sample array of integers to analyze
    sampleArray:    .word 45, 23, 89, 12, 67, 34, 91, 56
    arrayLength:    .word 8
    
    // Text strings for program output
    .align 3
    welcomeMsg:     .asciz "\n=== Largest Number Finder (ARM64) ===\n"
    arrayMsg:       .asciz "Analyzing array: "
    numberFmt:      .asciz "%d "
    newline:        .asciz "\n"
    resultMsg:      .asciz "\n%d is the largest number\n\n"

.section .text
.align 2

/*
 * printWelcome: Displays welcome message
 * Modifies: x0
 */
printWelcome:
    stp     x29, x30, [sp, #-16]!   // save frame pointer and link register
    mov     x29, sp                  // set up frame pointer
    
    adrp    x0, welcomeMsg           // load address of welcome message
    add     x0, x0, :lo12:welcomeMsg
    bl      printf                   // call printf
    
    ldp     x29, x30, [sp], #16      // restore registers
    ret                               // return to caller

/*
 * printArray: Displays all numbers in the array
 * Parameters: x19 = array address, w20 = array size
 * Modifies: x0, x1, w21, w22
 */
printArray:
    stp     x29, x30, [sp, #-48]!    // save registers with space
    mov     x29, sp
    stp     x19, x20, [sp, #16]      // save x19, x20
    stp     x21, x22, [sp, #32]      // save x21, x22
    
    // Print "Analyzing array: " message
    adrp    x0, arrayMsg
    add     x0, x0, :lo12:arrayMsg
    bl      printf
    
    // Initialize loop counter
    mov     w21, #0                   // counter starts at 0
    
print_loop:
    cmp     w21, w20                  // check if counter < size
    b.ge    print_done                // exit loop if done
    
    // Calculate offset and load element
    lsl     w22, w21, #2              // offset = counter * 4 bytes
    ldr     w1, [x19, w22, sxtw]      // load array[counter]
    
    // Print the number
    adrp    x0, numberFmt
    add     x0, x0, :lo12:numberFmt
    bl      printf
    
    // Increment counter
    add     w21, w21, #1
    b       print_loop
    
print_done:
    // Print newline
    adrp    x0, newline
    add     x0, x0, :lo12:newline
    bl      printf
    
    ldp     x21, x22, [sp, #32]       // restore registers
    ldp     x19, x20, [sp, #16]
    ldp     x29, x30, [sp], #48
    ret

/*
 * findMaximum: Core algorithm to find largest number
 * Parameters: x19 = array address, w20 = array size
 * Returns: w0 = largest number found
 * Modifies: w0, w21, w22, w23
 */
findMaximum:
    stp     x29, x30, [sp, #-32]!     // save registers
    mov     x29, sp
    stp     x19, x20, [sp, #16]
    
    // Load first element as initial maximum
    ldr     w21, [x19]                // w21 holds current maximum
    
    // Start loop from index 1
    mov     w22, #1
    
search_loop:
    // Check if we've examined all elements
    cmp     w22, w20
    b.ge    search_complete
    
    // Load current element
    lsl     w23, w22, #2              // calculate byte offset
    ldr     w23, [x19, w23, sxtw]     // w23 = current element
    
    // Compare with current maximum
    cmp     w23, w21
    b.le    not_larger                // skip if not larger
    
    // Update maximum if current is larger
    mov     w21, w23
    
not_larger:
    add     w22, w22, #1              // move to next element
    b       search_loop
    
search_complete:
    mov     w0, w21                   // return maximum in w0
    
    ldp     x19, x20, [sp, #16]
    ldp     x29, x30, [sp], #32
    ret

/*
 * main: Program entry point
 * Orchestrates the entire program flow
 */
main:
    stp     x29, x30, [sp, #-48]!     // save registers with space
    mov     x29, sp
    stp     x19, x20, [sp, #16]       // save callee-saved registers
    str     x21, [sp, #32]
    
    // Display welcome message
    bl      printWelcome
    
    // Load array address into x19
    adrp    x19, sampleArray
    add     x19, x19, :lo12:sampleArray
    
    // Load array size into w20
    adrp    x0, arrayLength
    add     x0, x0, :lo12:arrayLength
    ldr     w20, [x0]                 // dereference to get actual value
    
    // Display the array contents
    bl      printArray
    
    // Find the maximum value
    bl      findMaximum
    mov     w21, w0                   // save result in w21
    
    // Display the result
    adrp    x0, resultMsg
    add     x0, x0, :lo12:resultMsg
    mov     w1, w21                   // pass maximum as argument
    bl      printf
    
    // Return 0 for successful execution
    mov     w0, #0
    
    ldr     x21, [sp, #32]
    ldp     x19, x20, [sp, #16]
    ldp     x29, x30, [sp], #48
    ret

/*
 * Compilation and Execution:
 * -------------------------
 * To assemble and link:
 *   as -o largest_finder.o largest_finder.s
 *   gcc -o largest_finder largest_finder.o
 * 
 * Or compile directly:
 *   gcc -o largest_finder largest_finder.s
 * 
 * Run the program:
 *   ./largest_finder