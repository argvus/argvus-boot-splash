---
title: User Guide
description: Installation and usage guide for the ARGVUS boot splash theme.
---

# Argvus Boot Splash — User Guide

Argvus boot splash is a [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/)
theme for the Argvus desktop ecosystem. It is what you see between powering the
machine on and the moment your graphical session starts: a dark background, the
Argvus logo and wordmark, a progress bar that follows the real boot progress, and
a password dialog for encrypted (LUKS) volumes.

The quickest path for an Arch-based system is:

```sh
sudo pacman -S argvus-boot-splash   # or: sudo pacman -U ./argvus-boot-splash-<version>-1-any.pkg.tar.zst
```

The installer sets the theme as default and regenerates your initramfs
automatically. If nothing changes at boot, the usual cause is a missing
initramfs rebuild — see [troubleshooting](user-guide/troubleshooting.md).

This guide is for **users**. If you want to build, modify, sign or publish the
package, read the [developer guide](developer-guide.md) instead.

## Guides

| Guide | Contents |
| --- | --- |
| [Installation](user-guide/installation.md) | Requirements, the three install options, what the package hooks do |
| [Usage](user-guide/usage.md) | Verify the install, preview without rebooting, switch or revert themes, command cheat sheet |
| [UKI and systemd-boot splash](user-guide/uki-splash.md) | Using `argvus-uki-splash.bmp` in a UKI boot flow |
| [Uninstallation](user-guide/uninstallation.md) | Removing the package and restoring the previous theme |
| [Troubleshooting](user-guide/troubleshooting.md) | Common symptoms and their causes |
| [Reference](user-guide/reference.md) | Installed files, package metadata, color values |

## Elsewhere

- Repository root: [README.md](../../README.md) — overview and layout
- Development process: [DEVELOPMENT.md](../../DEVELOPMENT.md) — builds, signing, releases
- Contributing: [CONTRIBUTING.md](../../CONTRIBUTING.md)
- Security policy: [SECURITY.md](../../SECURITY.md)
- License: [GPL-3.0-or-later](../../LICENSE)
- Portuguese version: [Guia do usuário](../pt-br/user-guide.md)
