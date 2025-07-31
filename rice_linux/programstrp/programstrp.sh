#!/bin/bash

CACHE_DIR="$HOME/.cache/programstrp"
DEVIL_RUN_DIR="$HOME/.devilspie"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="programstrp"
SCRIPT_PATH="$(realpath "$0")"

RAW_SCRIPT_URL="https://raw.githubusercontent.com/tsukum0/bash-projects/refs/heads/main/rice_linux/programstrp/programstrp.sh"
RAW_LIST_URL="https://raw.githubusercontent.com/tsukum0/bash-projects/refs/heads/main/rice_linux/programstrp/auto/list.txt"

NO_INSTALL=false
[[ "$(grep -q "NO_INSTALL=true" "$SCRIPT_PATH" && echo yes)" == "yes" ]] && NO_INSTALL=true

print_help() {
    cat <<EOF
Usage: programstrp [command]

Commands:
  --install                         Install the program (local or GitHub raw; local or global)
  --uninstall                       Uninstall the program (local, global or both)
  --apply                           Download and apply Devilspie config files
  --set VALUE                       Set global opacity (e.g. 80)
  --set VALUE --for APP             Set opacity only for specific app
  --stop                            Kill all devilspie -a processes
  --restart                         Restart devilspie -a (kill and launch again)
  -h, --help                        Show this help message
EOF
}

install_self() {
    echo "Where do you want to install programstrp?"
    echo "  1) Local (~/.local/bin) - no sudo required"
    echo "  2) Global (/usr/local/bin) - requires sudo"
    read -rp "Choose 1 or 2: " loc_choice

    echo "Do you want to install the local script or the GitHub raw version?"
    echo "  1) Local script ($SCRIPT_PATH)"
    echo "  2) GitHub raw ($RAW_SCRIPT_URL)"
    read -rp "Choose 1 or 2: " src_choice

    if [[ "$loc_choice" == "1" && -f "/usr/local/bin/$SCRIPT_NAME" ]]; then
        read -rp "Global installation detected at /usr/local/bin/$SCRIPT_NAME. Remove it? [Y/n] " remove_global
        if [[ "$remove_global" =~ ^[Yy]?$ ]]; then
            sudo rm -f "/usr/local/bin/$SCRIPT_NAME" && echo "[*] Global installation removed." || echo "[!] Failed to remove global installation."
        fi
    fi

    if [[ "$loc_choice" == "1" && -f "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
        echo "[*] Removing existing local installation at $INSTALL_DIR/$SCRIPT_NAME"
        rm -f "$INSTALL_DIR/$SCRIPT_NAME" && echo "[*] Local installation removed."
    fi

    if [[ "$loc_choice" == "2" && -f "/usr/local/bin/$SCRIPT_NAME" ]]; then
        echo "[*] Removing existing global installation at /usr/local/bin/$SCRIPT_NAME"
        sudo rm -f "/usr/local/bin/$SCRIPT_NAME" && echo "[*] Global installation removed."
    fi

    case "$loc_choice" in
        1)
            mkdir -p "$INSTALL_DIR"
            case "$src_choice" in
                1) cp "$SCRIPT_PATH" "$INSTALL_DIR/$SCRIPT_NAME" ;;
                2) curl -fsSL "$RAW_SCRIPT_URL" -o "$INSTALL_DIR/$SCRIPT_NAME" ;;
                *) echo "[!] Invalid source option, aborting."; exit 1 ;;
            esac
            chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
            echo "[+] Set executable permissions on $INSTALL_DIR/$SCRIPT_NAME"

            if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
                SHELL_RC="$HOME/.bashrc"
                [[ -n "$ZSH_VERSION" ]] && SHELL_RC="$HOME/.zshrc"
                echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_RC"
                source "$SHELL_RC"
                echo "[+] Added $INSTALL_DIR to PATH in $SHELL_RC and sourced it."
            fi

            echo "=== IMPORTANT ==="
            echo "If 'programstrp' command not found after this, run:"
            echo "  hash -r"
            echo "or restart your terminal session."
            ;;
        2)
            case "$src_choice" in
                1) sudo cp "$SCRIPT_PATH" /usr/local/bin/$SCRIPT_NAME ;;
                2) sudo curl -fsSL "$RAW_SCRIPT_URL" -o /usr/local/bin/$SCRIPT_NAME ;;
                *) echo "[!] Invalid source option, aborting."; exit 1 ;;
            esac
            sudo chmod +x /usr/local/bin/$SCRIPT_NAME
            echo "[+] Installed to /usr/local/bin/$SCRIPT_NAME"
            ;;
        *) echo "[!] Invalid location option, aborting install."; exit 1 ;;
    esac
}

uninstall_self() {
    echo "Do you want to uninstall programstrp?"
    echo "  1) Uninstall local (~/.local/bin/programstrp)"
    echo "  2) Uninstall global (/usr/local/bin/programstrp)"
    echo "  3) Both"
    read -rp "Choose 1, 2 or 3: " uninstall_choice

    [[ "$uninstall_choice" == "1" || "$uninstall_choice" == "3" ]] && rm -f "$INSTALL_DIR/$SCRIPT_NAME" && echo "[+] Local removed."
    [[ "$uninstall_choice" == "2" || "$uninstall_choice" == "3" ]] && sudo rm -f "/usr/local/bin/$SCRIPT_NAME" && echo "[+] Global removed."

    echo "[*] Removing cache..."
    rm -rf "$CACHE_DIR"
    echo "[+] Cache cleaned."

    stop_devilspie
    echo "[OK] programstrp uninstalled."
}

restart_devilspie() {
    pkill -f "devilspie -a" && echo "[+] Killed all devilspie -a" || echo "[*] No running devilspie -a"
    nohup devilspie -a >/dev/null 2>&1 &
    echo "[+] Restarted devilspie -a"
}

stop_devilspie() {
    pkill -f "devilspie -a" && echo "[+] Killed all devilspie -a" || echo "[!] No devilspie -a running"
}

apply_configs() {
    echo "[*] Downloading list of apps..."
    mkdir -p "$CACHE_DIR" "$DEVIL_RUN_DIR"
    curl -fsSL "$RAW_LIST_URL" -o "$CACHE_DIR/list.txt" || { echo "[!] Failed to download list.txt"; exit 1; }

    > "$CACHE_DIR/files.txt"

    while read -r APP; do
        [[ -z "$APP" ]] && continue
        FILE="$DEVIL_RUN_DIR/$APP.ds"

        # Criar arquivo com opacidade 80, sempre que não existir
        if [[ ! -f "$FILE" ]]; then
            cat > "$FILE" <<EOF
(if
    (is (application_name) "$APP")
    (opacity 80)
)
EOF
            echo "[+] Created $FILE with opacity 80"
        else
            echo "[-] $FILE already exists, skipping creation"
        fi

        echo "$FILE" >> "$CACHE_DIR/files.txt"
    done < "$CACHE_DIR/list.txt"

    echo "80" > "$CACHE_DIR/global_opacity"
    echo "[+] Configs applied with default opacity 80."
    restart_devilspie
}

set_global_opacity() {
    VALUE="$1"
    echo "$VALUE" > "$CACHE_DIR/global_opacity"

    for FILE in "$DEVIL_RUN_DIR"/*.ds; do
        [[ -f "$FILE" ]] || continue

        # Captura opacidade atual
        OLD_VALUE=$(sed -n -E 's/.*\(opacity ([0-9]+)\).*/\1/p' "$FILE")
        if [[ "$OLD_VALUE" != "$VALUE" ]]; then
            sed -i -E "s/\(opacity [0-9]+\)/\(opacity $VALUE\)/" "$FILE"
            echo "[+] Changed opacity from $OLD_VALUE to $VALUE in $(basename "$FILE")"
        else
            echo "[-] No change needed for $(basename "$FILE"), already at $VALUE"
        fi
    done

    echo "[+] Global opacity set to $VALUE%."
    restart_devilspie
}

set_app_opacity() {
    VALUE="$1"
    APP="$2"
    FILE="$DEVIL_RUN_DIR/$APP.ds"

    mkdir -p "$DEVIL_RUN_DIR"

    if [[ ! -f "$FILE" ]]; then
        echo "[!] File $FILE not found, creating..."
        cat > "$FILE" <<EOF
(if
    (is (application_name) "$APP")
    (opacity $VALUE)
)
EOF
        echo "[+] Created new config file $FILE"
    else
        sed -i -E "s/\(opacity [0-9]+\)/\(opacity $VALUE\)/" "$FILE"
        echo "[+] Updated opacity for $APP in $FILE"
    fi

    restart_devilspie
}

check_install_location() {
    if [[ "$SCRIPT_PATH" != "$INSTALL_DIR/$SCRIPT_NAME" && "$NO_INSTALL" == "false" ]]; then
        echo "You are running $SCRIPT_NAME from: $SCRIPT_PATH"
        echo "It is recommended to install it to $INSTALL_DIR for global use."
        read -rp "Do you want to install it now? [Y/n] " ans
        if [[ "$ans" =~ ^[Yy]?$ ]]; then
            install_self
            exit 0
        else
            sed -i "0,/^# === FLAGS ===/s|^# === FLAGS ===|# === FLAGS ===\nNO_INSTALL=true|" "$SCRIPT_PATH"
            echo "[!] Install skipped. You won't be asked again."
        fi
    fi
}

# === FLAGS ===

# handler
if [[ $# -eq 0 ]]; then
    print_help
    exit 0
fi

case "$1" in
    --install) install_self ;;
    --uninstall) uninstall_self ;;
    --restart) restart_devilspie ;;
    --apply) apply_configs ;;
    --set)
        if [[ "$3" == "--for" && -n "$4" ]]; then
            set_app_opacity "$2" "$4"
        else
            set_global_opacity "$2"
        fi
        ;;
    --stop) stop_devilspie ;;
    -h|--help) print_help ;;
    *) check_install_location; echo "[!] Invalid command. Use -h for help."; exit 1 ;;
esac
