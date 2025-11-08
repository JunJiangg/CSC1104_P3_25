# Function to determine if a number is prime
def is_prime(n):
    if n <= 1:
        return False  # 0 and 1 are not prime
    for i in range(2, int(n ** 0.5) + 1):  # Only check up to sqrt(n)
        if n % i == 0:
            return False  # Found a factor, not prime
    return True  # No factors found, it's prime

try:
    # Ask user for input and convert to integer
    number = int(input("Enter an integer: "))

    # Check and print result
    if is_prime(number):
        print(f"The keyed-in number {number} is a prime number.")
    else:
        print(f"The keyed-in number {number} is not a prime number.")
except ValueError:
    # Handle invalid input (non-integer)
    print("Invalid input. Please enter an integer.")
