#!/usr/bin/env python3
"""
Virtual Memory Paging System - Process A
Implements paging function for Raspberry Pi platform
"""

# Page table for Process A (32 entries, None indicates invalid page)
page_table = {
    0: 9, 1: 1, 2: 14, 3: 10, 4: None, 5: 13, 6: 8, 7: 15,
    8: None, 9: 30, 10: 18, 11: None, 12: 21, 13: 27, 14: None, 15: 22,
    16: 29, 17: None, 18: 19, 19: 26, 20: 17, 21: 25, 22: None, 23: 31,
    24: 20, 25: 0, 26: 5, 27: 4, 28: None, 29: None, 30: 3, 31: 2
}

def binary_to_decimal(binary_str):
    """Convert binary string to decimal integer"""
    try:
        return int(binary_str, 2)
    except ValueError:
        return None

def decimal_to_binary(decimal, width):
    """Convert decimal to binary string with specified width"""
    return format(decimal, f'0{width}b')

def format_address(address):
    """Format 13-bit address as 'xxxxx xxxx xxxx'"""
    return f"{address[:5]} {address[5:9]} {address[9:13]}"

def main():
    print("=== Virtual Memory Paging System - Process A ===\n")
    
    # Input 1: Virtual memory page number (5-bit binary)
    page_number_str = input("Enter the 5-bit binary virtual page number (e.g., 11010): ").strip()
    
    # Input 2: Virtual page offset (8-bit binary)
    page_offset_str = input("Enter the 8-bit binary virtual page offset (e.g., 01011010): ").strip()
    
    # Validate input lengths
    if len(page_number_str) != 5:
        print(f"Error: Page number must be exactly 5 bits! (Got {len(page_number_str)} bits)")
        return
    
    if len(page_offset_str) != 8:
        print(f"Error: Page offset must be exactly 8 bits! (Got {len(page_offset_str)} bits)")
        return
    
    # Validate binary format
    if not all(bit in '01' for bit in page_number_str):
        print("Error: Page number must contain only 0 and 1!")
        return
    
    if not all(bit in '01' for bit in page_offset_str):
        print("Error: Page offset must contain only 0 and 1!")
        return
    
    # Convert to decimal
    page_num = binary_to_decimal(page_number_str)
    offset = binary_to_decimal(page_offset_str)
    
    # Construct virtual address (13-bit: 5-bit page + 8-bit offset)
    virtual_address = page_number_str + page_offset_str
    formatted_virtual = format_address(virtual_address)
    
    print("\n--- Results ---")
    print(f"The virtual memory address you keyed in is: {formatted_virtual}")
    
    # Check if page is valid
    if page_num not in page_table or page_table[page_num] is None:
        print(f"Error: Page fault! Page {page_num} is not mapped to any frame.")
        return
    
    # Get frame number from page table
    frame_number = page_table[page_num]
    
    # Convert frame number to 5-bit binary
    frame_binary = decimal_to_binary(frame_number, 5)
    
    # Construct physical address (5-bit frame + 8-bit offset)
    physical_address = frame_binary + page_offset_str
    formatted_physical = format_address(physical_address)
    
    print(f"The physical memory address to be accessed after paging is: {formatted_physical}")
    
    # Additional information
    print("\n--- Additional Information ---")
    print(f"Page Number (decimal): {page_num}")
    print(f"Frame Number (decimal): {frame_number}")
    print(f"Offset (decimal): {offset}")
    print(f"Virtual Address (binary): {virtual_address}")
    print(f"Physical Address (binary): {physical_address}")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nProgram interrupted by user.")
    except Exception as e:
        print(f"\nError occurred: {e}")
