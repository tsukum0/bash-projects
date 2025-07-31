# programstrp

Manage window transparency on Linux (X11) using [Devilspie 1](http://live.gnome.org/Devilspie).  
Ideal for XFCE/XFWM4, i3, Openbox and similar WMs.

---

## Features
 
- Automatically creates `.ds` config files for Devilspie  
- Set global opacity for multiple applications  
- Set per-application opacity  
- Restart or stop the Devilspie daemon easily

---

## Requirements

- **Devilspie 1**  
- `bash`, `curl`, `sed`, `grep`  
- X11 Window Manager (XFWM4, i3, etc.)

Install on Arch:

```bash
sudo pacman -S devilspie
```

---

## Installation

Run the script:

```bash
./programstrp --install
```

You'll be prompted to:

- Install locally (`~/.local/bin`)  
- Install globally (`/usr/local/bin`)  
- Use the local file or download the GitHub version

After installing:

```bash
programstrp --help
```

---

## Available Commands

```bash
programstrp --install
```
> Installs the script.

```bash
programstrp --uninstall
```
> Removes the script and cleans up the cache.

```bash
programstrp --apply
```
> Creates `.ds` files with 80% opacity for all apps listed in the GitHub `list.txt`.

```bash
programstrp --set 75
```
> Sets all `.ds` files to opacity 75%.

```bash
programstrp --set 90 --for Alacritty
```
> Sets or creates a `.ds` file for "Alacritty" with 90% opacity.

```bash
programstrp --restart
```
> Restarts Devilspie (`devilspie -a`).

```bash
programstrp --stop
```
> Stops all `devilspie -a` processes.

---

## Used Directories

- Config files: `~/.devilspie/`  
- Internal cache: `~/.cache/programstrp/`

---

## Generated `.ds` file

Example config for Alacritty:

```lisp
(if
    (is (application_name) "Alacritty")
    (opacity 80)
)
```

---

## Tip: How to find an application's class name

Run:

```bash
xprop | grep WM_CLASS
```

Click the desired window, and use the returned value with `--for`.

---

## App List

The `--apply` command downloads a remote `list.txt`, where each line represents an app name.  
Each entry generates a corresponding file: `~/.devilspie/<app>.ds`.

---

## Repository

Hosted at:  
`https://github.com/tsukum0/bash-projects/tree/main/rice_linux/programstrp`

---

## Note

This script **does not work under Wayland**. Use it only on X11.

---

## License

MIT License © [tsukum0](https://github.com/tsukum0)

---

Be transparent!!!
