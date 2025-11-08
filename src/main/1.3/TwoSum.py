"""
This program checks if any two numbers in a list sum to a target value.
"""

import sys

def find_two_sum(numbers, target):
    """
    Find two numbers in the list that sum to target.
    Uses nested loop approach for clarity.
    
    Parameters:
        numbers: list of integers
        target: the sum we're looking for
    
    Returns:
        tuple (num1, num2, index1, index2) if found
        None if no pair found
    """
    n = len(numbers)
    
    # Check each pair of numbers
    for i in range(n - 1):
        for j in range(i + 1, n):
            # If this pair sums to target, we found it
            if numbers[i] + numbers[j] == target:
                return (numbers[i], numbers[j], i, j)
    
    # No pair found
    return None


def display_array(numbers):
    """Display the array in a nice format"""
    print(f"Array: {numbers}")


def display_result(result, target):
    """
    Display the search result in required format.
    
    Parameters:
        result: tuple of (num1, num2, idx1, idx2) or None
        target: the target sum
    """
    print()
    if result:
        num1, num2, idx1, idx2 = result
        print(f"There are two numbers in the list summing to the keyed-in number {target}")
        print(f"  -> {num1} + {num2} = {target}")
        print(f"  -> Found at positions {idx1} and {idx2}")
    else:
        print(f"There are not two numbers in the list summing to the keyed-in number {target}")
    print()


def run_preset_mode():
    """Use predefined test data"""
    print("\n--- Preset Data Mode ---")
    
    # Predefined array for testing
    test_array = [10, 15, 3, 7, 22, 8, 12, 5]
    
    display_array(test_array)
    
    # Get target sum from user
    try:
        target = int(input("\nEnter the target sum: "))
    except ValueError:
        print("Invalid input! Please enter a valid integer.")
        return
    
    # Find two sum
    result = find_two_sum(test_array, target)
    display_result(result, target)


def run_user_input_mode():
    """Let user enter their own numbers"""
    print("\n--- User Input Mode ---")
    
    # Get array size
    try:
        size = int(input("How many numbers in your array? "))
        if size < 2:
            print("Please enter at least 2 numbers.")
            return
    except ValueError:
        print("Invalid input!")
        return
    
    # Get numbers from user
    numbers = []
    print(f"\nEnter {size} numbers:")
    
    for i in range(size):
        try:
            num = int(input(f"  Number {i + 1}: "))
            numbers.append(num)
        except ValueError:
            print("Invalid input! Please enter an integer.")
            return
    
    display_array(numbers)
    
    # Get target sum
    try:
        target = int(input("\nEnter the target sum: "))
    except ValueError:
        print("Invalid input! Please enter a valid integer.")
        return
    
    # Find two sum
    result = find_two_sum(numbers, target)
    display_result(result, target)


def display_menu():
    """Show the main menu"""
    print("\n" + "=" * 45)
    print("      Two Sum Checker Program")
    print("=" * 45)
    print("1. Use preset data")
    print("2. Enter your own numbers")
    print("3. Exit")
    print("=" * 45)


def get_menu_choice():
    """Get and validate menu choice"""
    try:
        choice = int(input("Enter your choice (1-3): "))
        if 1 <= choice <= 3:
            return choice
        else:
            print("Please enter a number between 1 and 3.")
            return None
    except ValueError:
        print("Invalid input! Please enter a number.")
        return None


def main():
    """Main program loop"""
    print("\nWelcome to the Two Sum Checker!")
    print("This program finds if any two numbers in a list sum to your target value.\n")
    
    # Keep running until user exits
    while True:
        display_menu()
        choice = get_menu_choice()
        
        if choice is None:
            continue
        
        if choice == 1:
            run_preset_mode()
        elif choice == 2:
            run_user_input_mode()
        elif choice == 3:
            print("\nThank you for using the program. Goodbye!\n")
            sys.exit(0)


# Program entry point
if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        # Handle Ctrl+C gracefully
        print("\n\nProgram interrupted. Exiting...")
        sys.exit(0)
    except Exception as e:
        # Handle unexpected errors
        print(f"\nAn error occurred: {e}")
        sys.exit(1)


"""
Execution:
----------
python3 two_sum_checker.py

or make executable:
chmod +x two_sum_checker.py
./two_sum_checker.py

Algorithm Explanation:
---------------------
The program uses a nested loop approach:
1. Outer loop: check each number (i from 0 to n-2)
2. Inner loop: check all numbers after it (j from i+1 to n-1)
3. If numbers[i] + numbers[j] equals target, we found the pair!
4. This ensures we check every possible pair exactly once

Time Complexity: O(n²) where n is the array size
Space Complexity: O(1) - only uses a few variables
"""