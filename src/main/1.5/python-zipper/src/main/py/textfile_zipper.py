from pathlib import Path
import zipfile
import time  # For timing measurements


    #Helper function to find last dot, reject names with no extension
    #check if extension is a file text case-insensitive
def is_text_file(path: Path) -> bool:
    """Check if a file has .txt extension (case-insensitive)."""
    return path.is_file() and path.suffix.lower() == ".txt"

    #Utility function to build resources folder path or output folder path
    #Resources folder path stores various types of files
    #Output stores output zips
def directory_builder(base_dir: Path, type: str) -> Path:
    """Build directory paths for resources and output folders."""
    if type == "resources":
        return base_dir / "resources"
    elif type == "output":
        return base_dir / "output"
    raise ValueError(f"Unknown type: {type}")


def main() -> None:
    """Main function: Find all .txt files and compress them into a ZIP archive."""
    # Start timing
    start_time = time.time()
    start_process_time = time.process_time()
    
    print("==============================================")
    print("  Python Text File Zipper - Performance Test")
    print("==============================================\n")
    
    # Get the base directory (navigate up from script location)
    base_dir = Path(__file__).resolve().parent.parent

    # Construct paths to resources and output directories
    resources_dir = directory_builder(base_dir, "resources")
    output_dir = directory_builder(base_dir, "output")

    # Check if resources directory exists
    print(f"Scanning: {resources_dir}")
    if not resources_dir.exists():
        raise FileNotFoundError(f"Resources dir not found: {resources_dir}")

    # Find all .txt files in resources directory
    txt_files = [p for p in resources_dir.iterdir() if is_text_file(p)]
    count = len(txt_files)

    # Create ZIP file and add all .txt files
    zip_path = output_dir / "text_file.zip"
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
        for p in txt_files:
            zf.write(p, arcname=p.name)

    # End timing
    end_time = time.time()
    end_process_time = time.process_time()
    
    # Calculate elapsed times
    real_time = (end_time - start_time) * 1000  # Convert to milliseconds
    cpu_time = (end_process_time - start_process_time) * 1000  # Convert to milliseconds
    
    # Print summary
    print("\n==============================================")
    print("             RESULTS SUMMARY")
    print("==============================================")
    print(f"Files processed: {count} .txt files")
    print(f"Output archive:  text_file.zip")
    print(f"\n--- Performance Metrics ---")
    print(f"CPU Time:        {cpu_time:.3f} ms")
    print(f"Real Time:       {real_time:.3f} ms")
    print(f"Language:        Python")
    print(f"Interpreter:     Python {__import__('sys').version.split()[0]}")
    print("==============================================")


if __name__ == "__main__":
    main()