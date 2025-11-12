#!/bin/bash
# Shell script to build and run the C text file zipper
# For: Linux/Raspberry Pi/macOS
# Usage: ./run_c_zipper.sh

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Navigate to the C source directory (from scripts folder to c folder)
cd "$SCRIPT_DIR/../c/"

# Compile the C file
echo "Compiling textfile_zipper.c..."
gcc -std=c11 -Wall -Wextra -O2 textfile_zipper.c -o textfile_zipper $(pkg-config --cflags --libs libzip)

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    echo ""
    # Make the executable runnable (chmod +x)
    echo "chmod-ing textfile_zipper.exe executable..."
    chmod +x textfile_zipper
    echo "Running textfile_zipper..."
    echo "================================"
    # Run the executable
    ./textfile_zipper
    echo "================================"
else
    echo "Compilation failed!"
    exit 1
fi
