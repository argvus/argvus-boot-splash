---
title: Reference
description: Installed files, package metadata, and color values.
---

# Reference

Technical reference for what the package installs and which values it uses.

## What you get

| Component | Description |
| --- | --- |
| Argvus logo | Centered mark, drawn above the wordmark |
| Wordmark | `ARGVUS` text below the logo |
| Progress bar | Thin bar whose width mirrors Plymouth's boot progress |
| Password dialog | LUKS prompt with a masked entry field (`•` bullets) |
| Fade-in | The splash fades in over ~1 second when Plymouth starts |
| UKI bitmap | `argvus-uki-splash.bmp` for UKI / systemd-boot based boots |

The package name is `argvus-boot-splash` and it replaces the older
`argvus-plymouth` package if you had it installed.

## Installed files

Under `/usr/share/plymouth/themes/argvus/`:

| File | Size | Purpose |
| --- | --- | --- |
| `argvus.plymouth` | — | theme descriptor (name, description, module) |
| `argvus.script` | — | the theme script (Plymouth's own scripting language) |
| `argvus-logo.png` | 256x256 | logo, RGBA |
| `argvus-text.png` | 400x53 | wordmark, RGBA |
| `progress-bar.png` | 400x4 | filled part of the progress bar |
| `progress-bar-track.png` | 400x4 | unfilled track |
| `entry-box.png` | 400x48 | password entry field |
| `entry-line.png` | 300x2 | password field rule/underline |
| `bullet.png` | 12x12 | masked character |
| `logo-glow.png` | 260x300 | logo glow artwork |
| `argvus-uki-splash.bmp` | 400x400, 32-bit | UKI/systemd-boot splash bitmap |

Plus the license at `/usr/share/licenses/argvus-boot-splash/LICENSE`.

## Package metadata

| Field | Value |
| --- | --- |
| Name | `argvus-boot-splash` |
| Architecture | `any` |
| Depends | `plymouth` |
| Optional depends | `mkinitcpio`, `dracut` |
| Conflicts / replaces | `argvus-plymouth` |
| License | GPL-3.0-or-later |

## Colors

| Element | Color |
| --- | --- |
| Background | `#111316` |
| Accent (logo, wordmark, progress fill) | `#3590BD` |
| Progress track | `#262933` |
| Password prompt text | light gray-blue (`#B8C4CE`) |

The theme uses a solid dark background at any resolution, so it never
auto-switches between light and dark variants.

## Getting help

- Report bugs and request features in the project's issue tracker.
- Security issues: follow [SECURITY.md](https://github.com/argvus/argvus-boot-splash/blob/main/SECURITY.md) — do not open a public
  issue for vulnerabilities.
- Source, builds and releases: the repository root ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)).
- Contribute: [CONTRIBUTING.md](https://github.com/argvus/argvus-boot-splash/blob/main/CONTRIBUTING.md).
- License: [GPL-3.0-or-later](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE).

## Next steps

- [Installation](/docs/argvus-boot-splash/installation/)
- [Usage](/docs/argvus-boot-splash/usage/)
- [Troubleshooting](/docs/argvus-boot-splash/troubleshooting/)
