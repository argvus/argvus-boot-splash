---
title: ARGVUS Boot Splash
description: Plymouth theme and installation guide for ARGVUS desktop environment
---

# ARGVUS Boot Splash

Argvus boot splash is a [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/) theme for the Argvus desktop ecosystem. It is what you see between powering the machine on and the moment your graphical session starts.

## Documentation

This documentation is organized in two main sections:

### [User Guide](user-guide/)
Installation and usage guides for end users and system administrators.

- [Installation](user-guide/installation.md) — System requirements and installation methods
- [Usage](user-guide/usage.md) — Verification, preview, and theme management
- [Troubleshooting](user-guide/troubleshooting.md) — Common issues and solutions
- [Uninstallation](user-guide/uninstallation.md) — Removing the package

### [Developer Guide](developer-guide/)
Technical documentation for contributors and maintainers.

- [Theme Architecture](developer-guide/theme.md) — Plymouth descriptor, rendering model, and customization
- [Packaging](developer-guide/packaging.md) — Build pipeline and package recipes
- [CI and Releases](developer-guide/ci-releases.md) — Validation, testing, and release workflow

## Quick Start

For Arch-based systems:

```sh
sudo pacman -S argvus-boot-splash
```

The installer sets the theme as default and regenerates your initramfs automatically.

---

- **Repository:** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **License:** GPL-3.0-or-later
- **Bug Reports:** [GitHub Issues](https://github.com/argvus/argvus-boot-splash/issues)
