# matrixr

Matrix rain terminal effect with configurable colors.  
Press Ctrl+C to stop.

---

## Features

- Customizable color scheme (default terminal colors or choose from 8 colors)
- Config saved in `~/.cache/matrixr/config`
- Command-line options for quick color set and reset
- Lightweight bash script with no dependencies

---

## Screenshot

![Matrix rain effect](https://github.com/tsukum0/bash-projects/blob/main/rice_linux/matrixr/image.png?raw=true)

---

## Installation

### Option 1: Clone via Git

```bash
git clone https://github.com/tsukum0/bash-projects/tree/main/rice_linux/matrixr.git
cd matrixr
sudo bash matrixr_install.sh
```

### Option 2: Download via curl

```bash
curl -L https://raw.githubusercontent.com/tsukum0/bash-projects/refs/heads/main/rice_linux/matrixr/matrixr_install.sh
sudo bash matrixr_install.sh
```

> The install script will copy `matrixr.sh` to `/usr/local/bin/matrixr` and make it executable.

---

## Usage

Run the script:

```bash
matrixr
```

### Options

- `-h`, `--help`  
  Show this help message.

- `--color <color>`  
  Set the color. Accepts: `default`, `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white` or `0-8`.

- `--reset`  
  Reset configuration (deletes cached config).

---

## Configuration

Colors and settings are stored in `~/.cache/matrixr/config`.  
You can change color interactively on first run or via `--color` option.

---

## License

MIT License © [tsukum0](https://github.com/tsukum0)

---

Enjoy your matrix rain! 🌧️💚
