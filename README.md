# 🐚 Bash Projects

My collection of minimal and useful Bash scripts (not always useful tbh), organized by category.  
Each tool is contained in its own subdirectory and may be independently installed or used.

---

## Repository Structure

This repository follows a modular layout:

```
bash-projects/
├── rice_linux/
│   ├── matrixr/        # Matrix rain effect with color config
│   └── programstrp/    # Devilspie-based window opacity manager
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

### `rice_linux/programstrp`

> X11 window opacity manager using [Devilspie 1](http://live.gnome.org/Devilspie).  
> Allows global or per-app opacity control, restartable with a single command.

- Uses `devilspie -a` to apply transparency rules  
- Creates and manages `.ds` files under `~/.devilspie/`  
- Simple command-line interface: `--apply`, `--set`, `--restart`, `--for`

[View programstrp](https://github.com/tsukum0/bash-projects/tree/main/rice_linux/programstrp)

---

## How to Use

You can install individual tools either by cloning this repo or downloading from GitHub raw.

### Clone the repo

```bash
git clone https://github.com/tsukum0/bash-projects.git
cd bash-projects/rice_linux/<toolname>
sudo bash <toolname>_install.sh
```

### Download single script

```bash
curl -L https://raw.githubusercontent.com/tsukum0/bash-projects/main/rice_linux/<toolname>/<toolname>.sh -o <toolname>.sh
sudo bash <toolname>_install.sh
```

_Replace `<toolname>` with `matrixr` or `programstrp`._

---

## License

MIT License © [tsukum0](https://github.com/tsukum0)
