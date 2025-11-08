Objective is to:
- Create multiple `.txt` files in the working directory.
- Develop **both a Python** 
  1. Lists all `.txt` files in a specific directory.
  2. Counts how many `.txt` files exist.
  3. Compresses them into a single `.zip` file named **`mytxt.zip`**.
  4. Prints this output message:

### 🔹 Program Flow
1. Get the **current working directory** using `Path.cwd()`.
2. Build directory paths for `resources` and `output` using `directoryStringBuilder()`.
3. Search `resources` for all `.txt` files.
4. Compress the filtered `.txt` files into `output/text_file.zip`.
5. Print the final output message.

### ⚙️ Design Logic
1. **Directory abstraction:**  
   A helper function `directoryStringBuilder()` dynamically builds target paths like `resources` or `output`, keeping the code modular and adaptable.

2. **Dynamic scanning:**  
   The main script uses `Path.iterdir()` to iterate through the chosen directory and filters files ending in `.txt` or `.TXT`.

3. **File verification:**  
   The function `isTextFile()` ensures that only actual files (not folders) with a `.txt` suffix are included.

4. **Compression and archiving:**  
   Using Python’s `zipfile` module, all valid `.txt` files are compressed into one zip file.

5. **Output confirmation:**  
   Finally, the number of `.txt` files processed is counted and printed in the exact format specified by the assignment.

  ### 🧰 Python Concepts Used

| Concept | Purpose | Example |
|----------|----------|---------|
| `pathlib` | For file path handling and directory traversal (instead of `os.path`) | `Path.cwd()` , `path.suffix`, `path.iterdir()` |
| `zipfile` | To create and manage `.zip` archives | `ZipFile(zip_path, "w", ZIP_DEFLATED)` |
| `list comprehension` | To efficiently filter `.txt` files in a directory | `[f for f in dir.iterdir() if f.suffix == ".txt"]` |
| `modular functions` | Reusability and clarity | `isTextFile(path)` , `directoryStringBuilder(currentDir, type)` |
| `string formatting (f-strings)` | For dynamic output messages | `f"There are number of {count} .txt files..."` |