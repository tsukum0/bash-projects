#!/bin/bash

SCRIPT_NAME="matrixr"
INSTALL_PATH="/usr/local/bin/$SCRIPT_NAME"
SOURCE_SCRIPT="matrixr.sh"  # your script filename here

echo "Installing $SCRIPT_NAME to $INSTALL_PATH..."

if [ ! -f "$SOURCE_SCRIPT" ]; then
    echo "Error: $SOURCE_SCRIPT not found in current directory."
    exit 1
fi

# Copy and make executable
sudo cp "$SOURCE_SCRIPT" "$INSTALL_PATH"
sudo chmod +x "$INSTALL_PATH"

# Check if /usr/local/bin is in PATH
if ! echo "$PATH" | grep -q "/usr/local/bin"; then
    echo "/usr/local/bin is not in your PATH."
    echo "Adding it temporarily for this session."
    export PATH=$PATH:/usr/local/bin
    echo "To add permanently, add the following line to your shell profile (~/.bashrc, ~/.zshrc, etc):"
    echo "    export PATH=\$PATH:/usr/local/bin"
fi

# Test if the command is now found
if command -v "$SCRIPT_NAME" >/dev/null 2>&1; then
    echo "Installation successful! You can run your script with:"
    echo "  $SCRIPT_NAME -h"
else
    echo "Warning: The command $SCRIPT_NAME is still not found."
    echo "Try restarting your terminal or run:"
    echo "  export PATH=\$PATH:/usr/local/bin"
fi
