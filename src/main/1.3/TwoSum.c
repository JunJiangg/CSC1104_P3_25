/* Program checks if any two numbers in a list sum to a target value. */

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

// Structure to hold the result of two sum search
typedef struct {
    bool found;
    int firstNum;
    int secondNum;
    int firstIndex;
    int secondIndex;
} TwoSumResult;

// Function prototypes
TwoSumResult findTwoSum(int *numbers, int size, int target);
void displayArray(int *numbers, int size);
void displayResult(TwoSumResult result, int target);
void runPresetMode();
void runUserInputMode();
int getMenuChoice();

/*
 * findTwoSum: Searches for two numbers that sums to target
 * Uses nested loop.
 * Parameters:
 *   numbers - array of integers to search
 *   size - number of elements in array
 *   target - the sum we're looking for
 * Returns: TwoSumResult structure with the findings
 */
TwoSumResult findTwoSum(int *numbers, int size, int target) {
    TwoSumResult result = {false, 0, 0, -1, -1};
    
    // Check each pair of numbers
    for (int i = 0; i < size - 1; i++) {
        for (int j = i + 1; j < size; j++) {
            // If this pair sums to target, we found it
            if (numbers[i] + numbers[j] == target) {
                result.found = true;
                result.firstNum = numbers[i];
                result.secondNum = numbers[j];
                result.firstIndex = i;
                result.secondIndex = j;
                return result;  // Return first match found
            }
        }
    }
    
    return result;  // No match found
}

/* displayArray: Shows all numbers in the array */
void displayArray(int *numbers, int size) {
    printf("Array: [");
    for (int i = 0; i < size; i++) {
        printf("%d", numbers[i]);
        if (i < size - 1) {
            printf(", ");
        }
    }
    printf("]\n");
}

/* displayResult: Prints the search result with formatting */
void displayResult(TwoSumResult result, int target) {
    printf("\n");
    if (result.found) {
        printf("There are two numbers in the list summing to the keyed-in number %d\n", target);
        printf("  -> %d + %d = %d\n", result.firstNum, result.secondNum, target);
        printf("  -> Found at positions %d and %d\n", result.firstIndex, result.secondIndex);
    } else {
        printf("There are not two numbers in the list summing to the keyed-in number %d\n", target);
    }
    printf("\n");
}

/* runPresetMode: Uses predefined test data */
void runPresetMode() {
    int testArray[] = {10, 15, 3, 7, 22, 8, 12, 5};
    int arraySize = sizeof(testArray) / sizeof(testArray[0]);
    int targetSum;
    
    printf("\n--- Preset Data Mode ---\n");
    displayArray(testArray, arraySize);
    
    printf("\nEnter the target sum: ");
    if (scanf("%d", &targetSum) != 1) {
        printf("Invalid input!\n");
        while (getchar() != '\n');  // clear buffer
        return;
    }
    
    TwoSumResult result = findTwoSum(testArray, arraySize, targetSum);
    displayResult(result, targetSum);
}

/* runUserInputMode: Lets user define their own array */
void runUserInputMode() {
    int arraySize, targetSum;
    
    printf("\n--- User Input Mode ---\n");
    printf("How many numbers in your array? ");
    
    if (scanf("%d", &arraySize) != 1 || arraySize < 2) {
        printf("Please enter at least 2 numbers.\n");
        while (getchar() != '\n');
        return;
    }
    
    // Dynamically allocate array
    int *userArray = (int *)malloc(arraySize * sizeof(int));
    if (userArray == NULL) {
        printf("Memory allocation failed!\n");
        return;
    }
    
    // Get array elements from user
    printf("\nEnter %d numbers:\n", arraySize);
    for (int i = 0; i < arraySize; i++) {
        printf("  Number %d: ", i + 1);
        if (scanf("%d", &userArray[i]) != 1) {
            printf("Invalid input! Please enter an integer.\n");
            free(userArray);
            while (getchar() != '\n');
            return;
        }
    }
    
    displayArray(userArray, arraySize);
    
    printf("\nEnter the target sum: ");
    if (scanf("%d", &targetSum) != 1) {
        printf("Invalid input!\n");
        free(userArray);
        while (getchar() != '\n');
        return;
    }
    
    TwoSumResult result = findTwoSum(userArray, arraySize, targetSum);
    displayResult(result, targetSum);
    
    // Clean up
    free(userArray);
}

/*
 * getMenuChoice: Displays menu and gets user selection
 */
int getMenuChoice() {
    int choice;
    
    printf("=============================================\n");
    printf("      Two Sum Checker Program\n");
    printf("=============================================\n");
    printf("1. Use preset data\n");
    printf("2. Enter your own numbers\n");
    printf("3. Exit\n");
    printf("=============================================\n");
    printf("Enter your choice (1-3): ");
    
    if (scanf("%d", &choice) != 1) {
        while (getchar() != '\n');  // clear buffer
        return -1;
    }
    
    return choice;
}

/* main: Program entry point */
int main() {
    int choice;
    bool keepRunning = true;
    
    printf("\nWelcome to the Two Sum Checker!\n");
    printf("This program finds if any two numbers in a list sum to your target value.\n\n");
    
    while (keepRunning) {
        choice = getMenuChoice();
        
        switch (choice) {
            case 1:
                runPresetMode();
                break;
            case 2:
                runUserInputMode();
                break;
            case 3:
                printf("\nThank you for using the program. Goodbye!\n\n");
                keepRunning = false;
                break;
            default:
                printf("\nInvalid choice! Please select 1-3.\n\n");
                break;
        }
    }
    
    return 0;
}

/*
 * Compilation:
 * gcc -o two_sum_checker two_sum_checker.c -Wall

 * Execution:
 * ./two_sum_checker
 
 * Algorithm Explanation:
 * ---------------------
 * The program uses a nested loop approach:
 * 1. Outer loop: check each number (i from 0 to n-2)
 * 2. Inner loop: check all numbers after it (j from i+1 to n-1)
 * 3. If numbers[i] + numbers[j] equals target, we found the pair!
 * 4. This ensures we check every possible pair exactly once
 * 
 * Time Complexity: O(n²) where n is the array size
 * Space Complexity: O(1) - only uses a few variables
 */