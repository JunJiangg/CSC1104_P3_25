# Task 1.5: Text File Zipper - Code Documentation

## Overview

This task implements a text file compression utility in both **C** and **Python**. 
The program scans a resources directory for all `.txt` files and compresses them into a ZIP archive.

---

## C Implementation

### File Location
`src/main/1.5/c-zipper/src/main/c/list_textfile_zip.c`

### Build Instructions


### Dependencies
- **libzip**: External library for ZIP file creation and manipulation (Zip.h)
- **Standard C Libraries**:
  - `stdio.h`: Standard input/output
  - `stdlib.h`: Memory allocation and general utilities
  - `string.h`: String manipulation functions
  - `ctype.h`: Character classification (tolower)
  - `dirent.h`: Directory reading
  - `sys/stat.h`: File statistics
  - `unistd.h`: POSIX API (getcwd)
  - `limits.h`: System limits (PATH_MAX)

- **Algorithm**:
  1. Get current working directory
  2. Construct path to resources directory (`../resources`)
  3. Open resources directory
  4. Create ZIP archive (`../output/mytxt.zip`)
  5. Iterate through directory entries
  6. Filter files with `.txt` extension
  7. Validate each file is a regular file (using `stat()`)
  8. Add valid files to the ZIP archive
  9. Close directory and ZIP file
  10. Print summary statistics

## Python Implementation

### File Location
`src/main/1.5/python-zipper/src/main/py/list_textfile_zip.py`


### Dependencies
- **pathlib**: Path manipulation (Python 3.4+, standard library)
- **zipfile**: ZIP file creation (standard library)

- **Purpose**: Main entry point for the compression program
- **Algorithm**:
  1. Determine base directory:
     - `__file__`: Path to this script
     - `.resolve()`: Convert to absolute path
     - `.parent.parent`: Navigate up to `src/main/`
  2. Construct paths to resources and output directories
  3. Validate resources directory exists
  4. Scan directory and filter `.txt` files using list comprehension
  5. Create ZIP file with DEFLATE compression
  6. Add all `.txt` files to the archive
  7. Print summary statistics

## Algorithm Comparison: C vs Python

| Aspect | C | Python |
|--------|---|--------|
| **Path Safety** | Manual buffer overflow prevention | Automatic (pathlib) |
| **Directory Reading** | `opendir()/readdir()` loop | `iterdir()` with filtering |
| **File Filtering** | Manual extension checking | `.suffix.lower()` property |
| **File Validation** | `stat()` + `S_ISREG()` | `path.is_file()` |
| **ZIP Creation** | External libzip library | Built-in zipfile module |
| **Error Handling** | Manual checks at each step | Exceptions (implicit handling) |
| **Code Length** | ~140 lines | ~70 lines |
| **Execution** | Compiled binary | Interpreted script |

## Directory Structure

1.5/
├── c-zipper/
│   └── src/
│       ├── main/
│       │   ├── c/
│       │   │   └── list_textfile_zip.c    [C implementation]
│       │   └── output/                     [Output ZIP files]
│       └── resources/                      [Input .txt files]
│
├── python-zipper/
│   └── src/
│       ├── main/
│       │   ├── py/
│       │   │   └── list_textfile_zip.py   [Python implementation]
│       │   └── output/                     [Output ZIP files]
│       └── resources/                      [Input .txt files]
│
└── scripts/
    ├── bootstrap_pi.sh
    └── create_test_file.sh

---

### Expected Output
Both versions will:
1. Display the current working directory
2. Display the resources directory being scanned
3. List each `.txt` file as it's added to the archive
4. Display the total count of files compressed
5. Report the output ZIP file path


## Key Features

✅ **Case-Insensitive Extension Matching**: Both versions handle `.txt`, `.TXT`, `.Txt`, etc.

✅ **Safe Path Handling**: C version prevents buffer overflows; Python uses pathlib

✅ **Regular File Validation**: Both versions ensure only regular files are added (not directories)

✅ **Clear Error Messages**: Informative error reporting for debugging

✅ **Cross-Platform Compatibility**: Python version works on Windows, Linux, macOS

✅ **Comprehensive Documentation**: Detailed comments explaining every section

---

## Testing Recommendations

1. **Resource Files**: Ensure `resources/` directory contains `.txt` files
2. **Output Directory**: Verify `output/` directory exists and is writable
3. **File Permissions**: Check that the script has permission to read input files
4. **ZIP Verification**: Inspect generated ZIP file to confirm all files were added correctly

---

## Notes

- Both implementations handle relative paths correctly
- The ZIP archive uses flat structure (no directory hierarchy)
- Previous ZIP files are overwritten on each run
- Error handling is comprehensive to prevent data loss