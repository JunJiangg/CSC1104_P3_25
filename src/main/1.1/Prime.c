#include <stdio.h>
#include <stdbool.h>

// Bool function to check if a number is prime
bool check_prime(int n) {
    if (n <= 1) return false;  // 0 and 1 are not prime numbers
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0)        // If divisible by any number other than 1 and itself
            return false;      // Its not prime number
    }
    return true;               // If no divisor found, its a prime number
}

int main() {
    int number;

    // Prompt the user for input
    printf("Enter an integer: ");
    scanf("%d", &number);  // Take input and store into number

    // Check and print result
    if (check_prime(number))
        printf("The keyed-in number %d is a prime number.\n", number);
    else
        printf("The keyed-in number %d is not a prime number.\n", number);
    return 0;
}


