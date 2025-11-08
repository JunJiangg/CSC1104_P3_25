from pathlib import Path
import zipfile


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

    # Print summary
    print(f"There are number of {count} .txt files and compressed into a .zip file")


if __name__ == "__main__":
    main()