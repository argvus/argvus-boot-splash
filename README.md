# Argvus Plymouth Theme

Boot splash theme for Plymouth based on the Argvus Dark Aether visual identity.

## Colors

| Element  | Color     |
|----------|-----------|
| Background | `#111316` |
| Accent   | `#3590BD`  |
| Bar track | `#262933` |

## Structure

```
argvus-splash/
├── Makefile
├── README.md
├── tools/
│   └── build-local-package.sh
├── packaging/
│   └── arch/
│       ├── PKGBUILD
│       ├── PKGBUILD.local
│       └── argvus-splash.install
└── src/
    ├── argvus.plymouth
    ├── argvus.script
    ├── argvus-logo.png
    ├── argvus-text.png
    ├── progress-bar.png
    ├── progress-bar-track.png
    ├── bullet.png          # bolinhas do campo de senha (LUKS)
    └── entry-line.png      # linha do campo de senha (LUKS)
```

## Installation

```bash
# Direct install
sudo make install
sudo make set-theme
sudo make rebuild

# Arch Linux package
make build

# Or build directly from the Arch packaging directory
cd packaging/arch && makepkg -si
```

The local package created by `make build` is moved to `dist/`.

## Preview

Use `plymouthd --mode=boot; plymouth --show-splash` to preview without rebooting.
