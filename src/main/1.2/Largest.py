#!/usr/bin/env python3
"""
Largest Number Finder
Author: [Your Name]
Date: [Date]

This program finds the largest number from a list of integers.
It provides multiple ways to input data and display results.
"""

import sys


class NumberAnalyzer:
    """
    A class to handle finding the largest number in a collection.
    This makes the code more organized and reusable.
    """
    
    def __init__(self, numbers=None):
        """Initialize with an optional list of numbers"""
        self.numbers = numbers if numbers else []
    
    def find_largest(self):
        """
        Find and return the largest number in the list.
        Returns None if the list is empty.
        """
        if not self.numbers:
            print("Error: No numbers to analyze!")
            return None
        
        # Start with the first number as our maximum
        max_value = self.numbers[0]
        
        # Check each number to see if it's larger
        for num in self.numbers[1:]:
            if num > max_value:
                max_value = num
        
        return max_value
    
    def display_numbers(self):
        """Display all numbers in a formatted way"""
        if not self.numbers:
            print("No numbers to display.")
            return
        
        print(f"Numbers in the list: {self.numbers}")
        print(f"Total count: {len(self.numbers)}")


def display_menu():
    """Show the main menu options to the user"""
    print("\n" + "=" * 45)
    print("    Largest Number Finder Program")
    print("=" * 45)
    print("1. Use preset sample data")
    print("2. Enter numbers manually")
    print("3. Exit program")
    print("=" * 45)


def get_user_choice():
    """
    Get and validate user's menu choice.
    Returns the choice as an integer, or None if invalid.
    """
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


def process_preset_data():
    """Use predefined sample data for demonstration"""
    print("\n--- Preset Sample Data ---")
    sample_numbers = [45, 23, 89, 12, 67, 34, 91, 56, 78, 21]
    
    analyzer = NumberAnalyzer(sample_numbers)
    analyzer.display_numbers()
    
    result = analyzer.find_largest()
    if result is not None:
        print(f"\n{result} is the largest number\n")


def process_manual_input():
    """Let user enter numbers one by one"""
    print("\n--- Manual Input Mode ---")
    
    try:
        count = int(input("How many numbers do you want to enter? "))
        if count <= 0:
            print("Please enter a positive number.")
            return
    except ValueError:
        print("Invalid input! Please enter a valid number.")
        return
    
    numbers = []
    print(f"\nEnter {count} numbers:")
    
    for i in range(count):
        try:
            num = int(input(f"  Number {i + 1}: "))
            numbers.append(num)
        except ValueError:
            print("Invalid input! Skipping this entry.")
            continue
    
    if not numbers:
        print("No valid numbers were entered.")
        return
    
    analyzer = NumberAnalyzer(numbers)
    analyzer.display_numbers()
    
    result = analyzer.find_largest()
    if result is not None:
        print(f"\n{result} is the largest number\n")

def main():
    """
    Main program loop.
    Handles user interaction and program flow.
    """
    print("\nWelcome to the Largest Number Finder!")
    
    # Keep running until user chooses to exit
    while True:
        display_menu()
        choice = get_user_choice()
        
        if choice is None:
            continue
        
        if choice == 1:
            process_preset_data()
        elif choice == 2:
            process_manual_input()
        elif choice == 3:
            print("\nThank you for using the program. Goodbye!\n")
            sys.exit(0)


# This is the entry point of the program
if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        # Handle Ctrl+C gracefully
        print("\n\nProgram interrupted by user. Exiting...")
        sys.exit(0)
    except Exception as e:
        # Catch any unexpected errors
        print(f"\nAn unexpected error occurred: {e}")
        sys.exit(1)


"""
Execution Instructions:
----------------------

Method 1: Direct execution
    python3 largest_finder.py

Method 2: Make it executable (Linux/Mac)
    chmod +x largest_finder.py
    ./largest_finder.py

Features:
---------
- Interactive menu system
- Multiple input methods
- Error handling for invalid inputs
- Clean, organized code structure
- Detailed comments for learning

Notes:
------
- Works on any system with Python 3.x
- No external dependencies required
- Can be easily extended with more features
"""