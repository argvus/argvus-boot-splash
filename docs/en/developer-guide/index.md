---
title: Developer Guide
description: Architecture and development guidance for ARGVUS contributors.
---

# Argvus Boot Splash — Developer Guide

Technical documentation for the `argvus-boot-splash` repository: how the Plymouth
theme is put together, how the Arch package is built, and how releases are
signed and published.

There is no compilation step here — the theme is data (a `.plymouth` descriptor,
a `.script`, and images) plus an Arch package recipe. "Building" means producing
a reproducible package:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```

Before committing a change: `make validate && make build`, and add new technical
terms to `.cspell/custom-dictionary-workspace.txt` or the spellcheck job fails.

If you only want to *use* the theme, read the [user guide](/docs/argvus-boot-splash/). For
the process-oriented counterpart of this file (git flow, secrets, changelog
discipline) see [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) and
[CONTRIBUTING.md](https://github.com/argvus/argvus-boot-splash/blob/main/CONTRIBUTING.md).

## Guides

| Guide | Contents |
| --- | --- |
| [Theme architecture](/docs/argvus-boot-splash/developer-guide/theme/) | Descriptor, rendering model, asset inventory, script walkthrough, layout constants, design tokens, UKI bitmap, how to modify the theme |
| [Packaging](/docs/argvus-boot-splash/developer-guide/packaging/) | The two PKGBUILDs, shared `functions.sh`, install hooks, local build pipeline, Make targets, prerequisites |
| [CI and releases](/docs/argvus-boot-splash/developer-guide/ci-releases/) | `validate.sh`, `ci.yml`, `release.yml` step by step, checksums, signing, secrets, publishing, versioning and changelog |
| [Conventions and known gaps](/docs/argvus-boot-splash/developer-guide/workflow/) | House rules, documentation map, and inconsistencies found while auditing the repository |

## Quick reference

| Path | What it is |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | theme payload installed under `/usr` |
| `packaging/arch/{ci,local}/PKGBUILD` | release and local package recipes |
| `packaging/arch/common/functions.sh` | shared `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | deterministic tarball + `makepkg` driver |
| `tools/sh/validate.sh` | required validation gate |
| `.github/workflows/` | `ci.yml` (validate, build, spellcheck), `release.yml` (tags `v*`) |

## Elsewhere

- Repository root: [README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
- User-facing docs: [user guide](/docs/argvus-boot-splash/)
- Development process: [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
- Contributing: [CONTRIBUTING.md](https://github.com/argvus/argvus-boot-splash/blob/main/CONTRIBUTING.md)
- Security policy: [SECURITY.md](https://github.com/argvus/argvus-boot-splash/blob/main/SECURITY.md)
- License: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
- Portuguese version: [Guia do desenvolvedor](/pt/docs/argvus-boot-splash/developer-guide/)
