# 🐚 Bash Projects

My collection of minimal and useful Bash scripts (not always useful tbh), organized by category.  
Each tool is contained in its own subdirectory and may be independently installed or used.

---

## Repository Structure

This repository follows a modular layout:

```
bash-projects/
├── rice_linux/
│   └── matrixr/       # Matrix rain effect with color config
├── README.md
```

Each directory under a category (like `rice_linux`) represents a **standalone script/tool**, complete with its own code and README (if applicable).

---

## Available Tools

### `rice_linux/matrixr`

> Matrix rain terminal animation with configurable colors.  
> Lightweight Bash implementation with no dependencies.

- Configurable color themes
- Persistent user config in `~/.cache/matrixr`
- Simple CLI interface: `--color`, `--reset`, `--help`

[View matrixr](https://github.com/tsukum0/bash-projects/tree/main/rice_linux/matrixr)

---

##  How to Use

You can install individual tools either by cloning this repo or downloading from GitHub raw.

### Clone the repo

```bash
git clone https://github.com/tsukum0/bash-projects.git
cd bash-projects/rice_linux/matrixr
sudo bash matrixr_install.sh
```

### Download single script

```bash
curl -L https://raw.githubusercontent.com/tsukum0/bash-projects/main/rice_linux/matrixr/matrixr.sh -o matrixr.sh
sudo bash matrixr_install.sh
```

---

## License

MIT License © [tsukum0](https://github.com/tsukum0)
