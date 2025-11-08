/*
 * Largest Number Finder
 * Author: [Your Name]
 * Date: [Date]
 * 
 * This program finds the largest number from a list of integers.
 * It supports both predefined arrays and user input.
 */

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

// Function prototypes
int findLargestNumber(int *arr, int count);
void displayArray(int *arr, int count);
void processPresetData();
void processUserInput();
int getUserChoice();

/*
 * findLargestNumber: Finds the maximum value in an integer array
 * Parameters:
 *   arr - pointer to the integer array
 *   count - number of elements in the array
 * Returns: the largest integer found
 */
int findLargestNumber(int *arr, int count) {
    if (count <= 0) {
        printf("Error: Empty array!\n");
        return INT_MIN;
    }
    
    int maxValue = arr[0];  // start with first element
    
    // iterate through remaining elements
    for (int i = 1; i < count; i++) {
        if (arr[i] > maxValue) {
            maxValue = arr[i];
        }
    }
    
    return maxValue;
}

/*
 * displayArray: Prints all elements in the array
 */
void displayArray(int *arr, int count) {
    printf("Numbers in the list: [");
    for (int i = 0; i < count; i++) {
        printf("%d", arr[i]);
        if (i < count - 1) {
            printf(", ");
        }
    }
    printf("]\n");
}

/*
 * processPresetData: Uses a predefined set of numbers
 */
void processPresetData() {
    int testNumbers[] = {45, 23, 89, 12, 67, 34, 91, 56, 78, 21};
    int arraySize = sizeof(testNumbers) / sizeof(testNumbers[0]);
    
    printf("\n--- Preset Data Mode ---\n");
    displayArray(testNumbers, arraySize);
    
    int result = findLargestNumber(testNumbers, arraySize);
    printf("\n%d is the largest number\n\n", result);
}

/*
 * processUserInput: Allows user to enter their own numbers
 */
void processUserInput() {
    int numCount;
    
    printf("\n--- User Input Mode ---\n");
    printf("How many numbers do you want to enter? ");
    
    if (scanf("%d", &numCount) != 1 || numCount <= 0) {
        printf("Invalid input! Please enter a positive number.\n");
        // clear input buffer
        while (getchar() != '\n');
        return;
    }
    
    // dynamically allocate memory for the array
    int *userNumbers = (int *)malloc(numCount * sizeof(int));
    if (userNumbers == NULL) {
        printf("Memory allocation failed!\n");
        return;
    }
    
    // get numbers from user
    printf("Enter %d numbers (separated by spaces or Enter):\n", numCount);
    for (int i = 0; i < numCount; i++) {
        printf("Number %d: ", i + 1);
        if (scanf("%d", &userNumbers[i]) != 1) {
            printf("Invalid input! Please enter an integer.\n");
            free(userNumbers);
            while (getchar() != '\n');
            return;
        }
    }
    
    displayArray(userNumbers, numCount);
    
    int result = findLargestNumber(userNumbers, numCount);
    printf("\n%d is the largest number\n\n", result);
    
    // free allocated memory
    free(userNumbers);
}

/*
 * getUserChoice: Displays menu and gets user selection
 */
int getUserChoice() {
    int choice;
    
    printf("========================================\n");
    printf("   Largest Number Finder Program\n");
    printf("========================================\n");
    printf("1. Use preset data\n");
    printf("2. Enter your own numbers\n");
    printf("3. Exit\n");
    printf("========================================\n");
    printf("Enter your choice (1-3): ");
    
    if (scanf("%d", &choice) != 1) {
        while (getchar() != '\n');  // clear buffer
        return -1;
    }
    
    return choice;
}

/*
 * main: Entry point of the program
 */
int main() {
    int choice;
    int keepRunning = 1;
    
    while (keepRunning) {
        choice = getUserChoice();
        
        switch (choice) {
            case 1:
                processPresetData();
                break;
            case 2:
                processUserInput();
                break;
            case 3:
                printf("\nThank you for using the program. Goodbye!\n");
                keepRunning = 0;
                break;
            default:
                printf("\nInvalid choice! Please select 1, 2, or 3.\n\n");
                break;
        }
    }
    
    return 0;
}

/*
 * Compilation instructions:
 * gcc -o largest_finder largest_finder.c -Wall
 * 
 * Run with:
 * ./largest_finder
 */