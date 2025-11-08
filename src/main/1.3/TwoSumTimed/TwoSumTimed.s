/*
 * Wrapper to benchmark the ARM assembly version
 * Links with TwoSum.s and measures execution time
 */

#include <stdio.h>
#include <time.h>

// External assembly functions
extern void printWelcome();
extern int findTwoSum(int *array, int size, int target, int *num1, int *num2);

int main() {
    int testArray[] = {10, 15, 3, 7, 22, 8, 12, 5};
    int arraySize = 8;
    int target = 18;
    int num1, num2;
    int iterations = 100000;
    
    printf("\n╔════════════════════════════════════════╗\n");
    printf("║  Two Sum - ARM Assembly Benchmark     ║\n");
    printf("╚════════════════════════════════════════╝\n");
    
    // Single test
    printf("\n=== Single Execution Test ===\n");
    printf("Array: [10, 15, 3, 7, 22, 8, 12, 5]\n");
    printf("Target: %d\n\n", target);
    
    clock_t start = clock();
    int found = findTwoSum(testArray, arraySize, target, &num1, &num2);
    clock_t end = clock();
    
    double time_seconds = ((double)(end - start)) / CLOCKS_PER_SEC;
    double time_microseconds = time_seconds * 1000000;
    
    if (found) {
        printf("Result: Found %d + %d = %d\n", num1, num2, target);
    } else {
        printf("Result: No pair found\n");
    }
    
    printf("Execution time: %.9f seconds (%.3f microseconds)\n", 
           time_seconds, time_microseconds);
    
    // Benchmark
    printf("\n=== Benchmark Test (Multiple Iterations) ===\n");
    printf("Running %d iterations...\n", iterations);
    
    start = clock();
    
    for (int i = 0; i < iterations; i++) {
        findTwoSum(testArray, arraySize, target, &num1, &num2);
    }
    
    end = clock();
    
    double total_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    double avg_time = total_time / iterations;
    double avg_microseconds = avg_time * 1000000;
    
    printf("Total time: %.6f seconds\n", total_time);
    printf("Average per iteration: %.9f seconds (%.3f microseconds)\n", 
           avg_time, avg_microseconds);
    printf("Iterations per second: %.0f\n\n", iterations / total_time);
    
    return 0;
}

/*
 * Compilation: gcc -O2 -o TwoSum_benchmark_asm TwoSum_benchmark_wrapper.c TwoSum.s
 * Execution: ./TwoSum_benchmark_asm
 */