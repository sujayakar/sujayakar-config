# sujayakar-config

Dotfiles for Fedora Asahi Linux on Apple Silicon (M4 MacBook Pro).

## What's included

- **emacs/** — Emacs 30 config with use-package, doom-one theme, eglot (Rust LSP), magit, undo-tree, emacs-mcp-server
- **sway/** — Sway (Wayland i3) config with wofi, foot terminal, swaylock
- **waybar/** — Minimal status bar: workspaces, volume, wifi, battery, clock, idle inhibitor
- **.bashrc** — Fedora defaults + cargo, nvm, emacsclient alias

## Install

### 1. System packages

```bash
sudo dnf install emacs sway waybar wofi swaylock foot brightnessctl grim slurp socat
```

### 2. Rust toolchain

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
rustup component add rust-analyzer
```

### 3. Clone and symlink

```bash
git clone https://github.com/sujayakar/sujayakar-config ~/src/sujayakar-config

# Emacs
mkdir -p ~/.config/emacs
ln -sf ~/src/sujayakar-config/emacs/init.el ~/.config/emacs/init.el

# Sway
mkdir -p ~/.config/sway
ln -sf ~/src/sujayakar-config/sway/config ~/.config/sway/config

# Waybar
mkdir -p ~/.config/waybar
ln -sf ~/src/sujayakar-config/waybar/config.jsonc ~/.config/waybar/config.jsonc
ln -sf ~/src/sujayakar-config/waybar/style.css ~/.config/waybar/style.css

# Bashrc
ln -sf ~/src/sujayakar-config/.bashrc ~/.bashrc
```

### 4. Emacs MCP server (for Claude Code integration)

```bash
git clone https://github.com/rhblind/emacs-mcp-server ~/.config/emacs/site-lisp/emacs-mcp-server
```

Register with Claude Code:
```bash
claude mcp add emacs -- ~/.config/emacs/site-lisp/emacs-mcp-server/mcp-wrapper.sh ~/.config/emacs/emacs-mcp-server.sock
```

### 5. Emacs daemon

```bash
systemctl --user enable --now emacs
```

Open frames with `e` (alias for `emacsclient -c -a ""`).

### 6. Start sway

Log out, select **Sway** at the SDDM login screen.

## Sway keybindings

| Key | Action |
|-----|--------|
| `Mod+Return` | Terminal (foot) |
| `Mod+d` | App launcher (wofi) |
| `Mod+e` | Emacs |
| `Mod+Shift+q` | Kill window |
| `Mod+j/k/l/;` | Focus left/down/up/right |
| `Mod+1-0` | Switch workspace |
| `Mod+Shift+1-0` | Move window to workspace |
| `Mod+f` | Fullscreen |
| `Mod+h/v` | Split horizontal/vertical |
| `Mod+r` | Resize mode |
| `Mod+Shift+c` | Reload config |
| `Mod+Shift+e` | Exit sway |
| `Mod+Shift+x` | Lock screen |
| `Mod+F1/F2` | Brightness down/up |

## Emacs keybindings

| Key | Action |
|-----|--------|
| `C-x C-z` | Find file in project |
| `C-x C-r` | Revert buffer |
| `C-x C-c` | Close frame (not daemon) |
| `C-x g` | Magit status |
| `C-x u` | Undo tree |
| `M-.` | Go to definition |
| `M-,` | Go back |
| `M-?` | Find references |
| `C-c r` | Rename symbol |
| `C-c a` | Code actions |
| `M-x reload-init` | Reload init.el |
