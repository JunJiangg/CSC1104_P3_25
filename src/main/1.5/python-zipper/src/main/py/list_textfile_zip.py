from pathlib import Path
import zipfile

def is_text_file(path: Path) -> bool:
    return path.is_file() and path.suffix.lower() == ".txt"

def directory_builder(base_dir: Path, type: str) -> Path:
    if type == "resources":
        return base_dir / "resources"
    elif type == "output":
        return base_dir / "output"
    raise ValueError(f"Unknown type: {type}")

def main() -> None:
    # Base = the folder that contains this script's "main" folder
    # .../python-zipper/src/main/py/list_textfile_zip.py  (example)
    # base_dir = .../python-zipper/src/main
    base_dir = Path(__file__).resolve().parent.parent

    resources_dir = directory_builder(base_dir, "resources")
    output_dir    = directory_builder(base_dir, "output")

    print(f"Scanning: {resources_dir}")
    if not resources_dir.exists():
        raise FileNotFoundError(f"Resources dir not found: {resources_dir}")

    txt_files = [p for p in resources_dir.iterdir() if is_text_file(p)]
    count = len(txt_files)

    zip_path = output_dir / "text_file.zip"
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
        for p in txt_files:
            zf.write(p, arcname=p.name)

    print(f"There are number of {count} .txt files and compressed into a .zip file")

if __name__ == "__main__":
    main()