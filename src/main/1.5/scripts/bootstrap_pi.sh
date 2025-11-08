# file path: scripts/bootstrap_pi.sh
#!/usr/bin/env bash
set -euo pipefail
sudo apt update
sudo apt install -y python3 gcc make zip
echo "✅ Raspberry Pi ready: python3, gcc, make, zip installed."