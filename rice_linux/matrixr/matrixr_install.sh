#!/bin/bash

TARGET="/usr/local/bin/matrixr"
GITHUB_RAW_URL="https://raw.githubusercontent.com/tsukum0/bash-projects/refs/heads/main/rice_linux/matrixr/matrixr.sh"

echo "Install matrixr script"
echo "Choose installation source:"
echo "  1) Local script file"
echo "  2) Download from GitHub (raw)"
read -rp "Enter choice [1-2]: " choice

case "$choice" in
  1)
    read -rp "Enter local script file path (default ./matrixr.sh): " local_path
    local_path=${local_path:-./matrixr.sh}
    if [[ ! -f "$local_path" ]]; then
      echo "Local file not found: $local_path"
      exit 1
    fi
    echo "Installing from local file: $local_path"
    sudo cp "$local_path" "$TARGET"
    ;;
  2)
    echo "Downloading from GitHub: $GITHUB_RAW_URL"
    sudo curl -fsSL "$GITHUB_RAW_URL" -o "$TARGET"
    if [[ $? -ne 0 ]]; then
      echo "Failed to download from GitHub."
      exit 1
    fi
    ;;
  *)
    echo "Invalid choice."
    exit 1
    ;;
esac

sudo chmod +x "$TARGET"
echo "Installed matrixr to $TARGET"
echo "You can run it by typing: matrixr"

exit 0
