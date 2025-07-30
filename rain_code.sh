#!/bin/bash

# Matrix rain with configurable color (including default terminal color)
# Press Ctrl+C to stop

# ======= CONFIG SECTION =======
# SELECTED_COLOR=0  # 0 = default terminal color, 1=black, 2=red ... 8=white
SELECTED_COLOR=7
TRAIL_LENGTH=5
ACTIVE_DENSITY=5
FRAME_DELAY=0.02
# ==============================

# Map color names to numbers for --color option
color_name_to_num() {
    case "$1" in
        default) echo 0 ;;
        black) echo 1 ;;
        red) echo 2 ;;
        green) echo 3 ;;
        yellow) echo 4 ;;
        blue) echo 5 ;;
        magenta) echo 6 ;;
        cyan) echo 7 ;;
        white) echo 8 ;;
        [0-8]) echo "$1" ;;  # direct number
        *) echo "" ;;        # invalid
    esac
}

prompt_for_color() {
    echo "Choose a color for the Matrix rain effect:"
    echo -e "  0) \033[0mDefault terminal color\033[0m"
    echo -e "  1) \033[30mBlack\033[0m"
    echo -e "  2) \033[31mRed\033[0m"
    echo -e "  3) \033[32mGreen\033[0m"
    echo -e "  4) \033[33mYellow\033[0m"
    echo -e "  5) \033[34mBlue\033[0m"
    echo -e "  6) \033[35mMagenta\033[0m"
    echo -e "  7) \033[36mCyan\033[0m"
    echo -e "  8) \033[37mWhite\033[0m"
    echo -n "Enter number [0-8]: "
    read color
    if [[ "$color" =~ ^[0-8]$ ]]; then
        script_path="$(realpath "$0")"
        sed -i.bak "s/^SELECTED_COLOR=.*/SELECTED_COLOR=$color/" "$script_path"
        echo "Color set to $color. Restarting script..."
        exec "$script_path"
    else
        echo "Invalid choice. Please run again."
        exit 1
    fi
}

reset_config() {
    script_path="$(realpath "$0")"
    # Replace the SELECTED_COLOR line to empty (or 0 if you prefer default)
    sed -i.bak "s/^SELECTED_COLOR=.*/SELECTED_COLOR=/" "$script_path"
    echo "Color configuration reset in the script."
}

# --- Handle command-line args ---

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
  --reset            Reset the color configuration in the script (prompts on next run)
  --color <color>    Set the rain color and restart the script immediately
                     Colors: default black red green yellow blue magenta cyan white or 0-8
  -h, --help         Show this help message and exit

If no options are given and SELECTED_COLOR is unset, the script prompts for color.
EOF
    exit 0
}

# Check for help flag
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
fi

if [[ "$1" == "--reset" ]]; then
    reset_config
    exit 0
fi

if [[ "$1" == "--color" ]]; then
    if [[ -z "$2" ]]; then
        echo "Usage: $0 --color <color>"
        echo "Colors: default black red green yellow blue magenta cyan white or 0-8"
        exit 1
    fi
    color_num=$(color_name_to_num "$2")
    if [[ -z "$color_num" ]]; then
        echo "Invalid color: $2"
        echo "Valid colors: default black red green yellow blue magenta cyan white or 0-8"
        exit 1
    fi
    script_path="$(realpath "$0")"
    sed -i.bak "s/^SELECTED_COLOR=.*/SELECTED_COLOR=$color_num/" "$script_path"
    echo "Color set to $color_num. Restarting script..."
    exec "$script_path"
fi

# --- Prompt if SELECTED_COLOR not set (optional) ---
if [ -z "$SELECTED_COLOR" ]; then
    prompt_for_color
fi

cols=$(tput cols)
lines=$(tput lines)
tput civis
trap "tput cnorm; clear; exit" SIGINT

declare -a drops
for ((i=0; i<cols; i++)); do
    drops[i]=-1
done

clear

while true; do
    for ((i=0; i<cols; i++)); do
        if (( drops[i] == -1 )); then
            (( RANDOM % 100 < ACTIVE_DENSITY )) && drops[i]=0
            continue
        fi

        y=${drops[i]}

        for ((j=0; j<TRAIL_LENGTH; j++)); do
            char_y=$(( y - j ))
            if (( char_y >= 0 && char_y < lines )); then
                char=$(printf "%x" $(( RANDOM % 16 )))
                printf "\033[%d;%dH" "$char_y" "$i"

                if (( SELECTED_COLOR == 0 )); then
                    # Default terminal color, no color escape
                    printf "%s" "$char"
                else
                    if (( j == 0 )); then
                        # Bold bright color for head
                        printf "\033[1;3%dm%s\033[0m" "$((SELECTED_COLOR - 1))" "$char"
                    else
                        # Normal color for trail
                        printf "\033[3%dm%s\033[0m" "$((SELECTED_COLOR - 1))" "$char"
                    fi
                fi
            fi
        done

        # Clear tail
        tail_y=$(( y - TRAIL_LENGTH ))
        if (( tail_y >= 0 && tail_y < lines )); then
            printf "\033[%d;%dH " "$tail_y" "$i"
        fi

        drops[i]=$(( y + 1 ))
        if (( drops[i] > lines + TRAIL_LENGTH )); then
            drops[i]=-1
        fi
    done
    sleep "$FRAME_DELAY"
done
