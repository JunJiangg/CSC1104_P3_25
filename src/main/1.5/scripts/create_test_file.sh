# file path: scripts/make_test_files.sh
#!/usr/bin/env bash
set -euo pipefail
# Create some sample files in the current directory:
echo "Creating first text file"  > first.txt
echo "Creating Capital TXT Extension"   > b.TXT
echo "Creating notes.txt"  > notes.txt
echo "Creating app.log    > app.log
echo "Creating data.csv"   > data.csv
echo "✅ Created: a.txt, b.TXT, notes.txt (and a couple of non-txt files)"