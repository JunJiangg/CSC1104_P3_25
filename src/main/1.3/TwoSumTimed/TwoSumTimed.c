/*
 * Benchmark version of TwoSum - measures only algorithm performance
 * No user interaction - runs automated timing tests
 */

#include <stdio.h>
#include <stdbool.h>
#include <time.h>

typedef struct {
    bool found;
    int firstNum;
    int secondNum;
    int firstIndex;
    int secondIndex;
} TwoSumResult;

TwoSumResult findTwoSum(int *numbers, int size, int target) {
    TwoSumResult result = {false, 0, 0, -1, -1};
    
    for (int i = 0; i < size - 1; i++) {
        for (int j = i + 1; j < size; j++) {
            if (numbers[i] + numbers[j] == target) {
                result.found = true;
                result.firstNum = numbers[i];
                result.secondNum = numbers[j];
                result.firstIndex = i;
                result.secondIndex = j;
                return result;
            }
        }
    }
    return result;
}

void runSingleTest() {
    int testArray[] = {10, 15, 3, 7, 22, 8, 12, 5};
    int arraySize = 8;
    int target = 18;
    
    printf("\n=== Single Execution Test ===\n");
    printf("Array: [10, 15, 3, 7, 22, 8, 12, 5]\n");
    printf("Target: %d\n\n", target);
    
    clock_t start = clock();
    TwoSumResult result = findTwoSum(testArray, arraySize, target);
    clock_t end = clock();
    
    double time_seconds = ((double)(end - start)) / CLOCKS_PER_SEC;
    double time_microseconds = time_seconds * 1000000;
    
    if (result.found) {
        printf("Result: Found %d + %d = %d\n", 
               result.firstNum, result.secondNum, target);
    } else {
        printf("Result: No pair found\n");
    }
    
    printf("Execution time: %.9f seconds (%.3f microseconds)\n", 
           time_seconds, time_microseconds);
}

void runBenchmark() {
    int testArray[] = {10, 15, 3, 7, 22, 8, 12, 5};
    int arraySize = 8;
    int target = 18;
    int iterations = 100000;
    
    printf("\n=== Benchmark Test (Multiple Iterations) ===\n");
    printf("Running %d iterations...\n", iterations);
    
    clock_t start = clock();
    
    for (int i = 0; i < iterations; i++) {
        findTwoSum(testArray, arraySize, target);
    }
    
    clock_t end = clock();
    
    double total_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    double avg_time = total_time / iterations;
    double avg_microseconds = avg_time * 1000000;
    
    printf("Total time: %.6f seconds\n", total_time);
    printf("Average per iteration: %.9f seconds (%.3f microseconds)\n", 
           avg_time, avg_microseconds);
    printf("Iterations per second: %.0f\n\n", iterations / total_time);
}

int main() {
    printf("\n╔════════════════════════════════════════╗\n");
    printf("║  Two Sum - C Performance Benchmark    ║\n");
    printf("╚════════════════════════════════════════╝\n");
    
    runSingleTest();
    runBenchmark();
    
    return 0;
}

/*
 * Compilation: gcc -O2 -o TwoSum_benchmark TwoSum_benchmark.c
 * Execution: ./TwoSum_benchmark
 */