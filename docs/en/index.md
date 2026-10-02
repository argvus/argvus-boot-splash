---
title: ARGVUS Boot Splash
description: Plymouth theme and installation guide for ARGVUS desktop environment
---

# ARGVUS Boot Splash

Argvus boot splash is a [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/) theme for the Argvus desktop ecosystem. It is what you see between powering the machine on and the moment your graphical session starts.

## Documentation

This documentation is organized in two main sections:

### User Guide
Installation and usage guides for end users and system administrators.

| Guide | Contents |
| --- | --- |
| [Installation](/docs/argvus-boot-splash/installation/) | Requirements, the three install options, what the package hooks do |
| [Usage](/docs/argvus-boot-splash/usage/) | Verify the install, preview without rebooting, switch or revert themes, command cheat sheet |
| [UKI and systemd-boot splash](/docs/argvus-boot-splash/uki-splash/) | Using `argvus-uki-splash.bmp` in a UKI boot flow |
| [Uninstallation](/docs/argvus-boot-splash/uninstallation/) | Removing the package and restoring the previous theme |
| [Troubleshooting](/docs/argvus-boot-splash/troubleshooting/) | Common symptoms and their causes |
| [Reference](/docs/argvus-boot-splash/reference/) | Installed files, package metadata, color values |

### [Developer Guide](/docs/argvus-boot-splash/developer-guide/)
Technical documentation for contributors and maintainers.

- [Theme Architecture](/docs/argvus-boot-splash/developer-guide/theme/) — Plymouth descriptor, rendering model, and customization
- [Packaging](/docs/argvus-boot-splash/developer-guide/packaging/) — Build pipeline and package recipes
- [CI and Releases](/docs/argvus-boot-splash/developer-guide/ci-releases/) — Validation, testing, and release workflow

## Quick Start

For Arch-based systems:

```sh
sudo pacman -S argvus-boot-splash   # or: sudo pacman -U ./argvus-boot-splash-<version>-1-any.pkg.tar.zst
```

The installer sets the theme as default and regenerates your initramfs automatically.

---

- **Repository:** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **License:** GPL-3.0-or-later
- **Bug Reports:** [GitHub Issues](https://github.com/argvus/argvus-boot-splash/issues)
