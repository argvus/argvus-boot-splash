# Argvus Splash

<div align="center">

[![CI](https://github.com/argvus/argvus-boot-splash/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/argvus/argvus-boot-splash/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/argvus/argvus-boot-splash)](./LICENSE)
[![Language: Shell](https://img.shields.io/badge/Shell-POSIX-4EAA25?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Platform: Arch Linux | Wayland](https://img.shields.io/badge/platform-Arch%20Linux%20%7C%20Wayland-1793D1?logo=archlinux&logoColor=white)](https://archlinux.org/)
[![Pull requests](https://img.shields.io/github/issues-pr/argvus/argvus-boot-splash)](https://github.com/argvus/argvus-boot-splash/pulls)
[![Issues](https://img.shields.io/github/issues/argvus/argvus-boot-splash)](https://github.com/argvus/argvus-boot-splash/issues)
[![Last commit](https://img.shields.io/github/last-commit/argvus/argvus-boot-splash)](https://github.com/argvus/argvus-boot-splash/commits/main)
[![Docs](https://img.shields.io/badge/docs-project-blue)](./docs/)

</div>

Plymouth boot splash theme for the Argvus desktop ecosystem.

The package installs the theme under
`/usr/share/plymouth/themes/argvus/`, including the boot logo, progress bar,
password prompt assets, and UKI splash bitmap.

## Repository layout

```text
src/usr/share/plymouth/themes/argvus/  package payload
packaging/arch/remote/PKGBUILD             release package metadata
packaging/arch/local/PKGBUILD          local package metadata
packaging/arch/common/                 shared packaging functions
tools/sh/pkgbuild_local.sh             local source archive and package build
tools/sh/validate.sh                   repository and metadata validation
build/                                 ignored build artifacts
docs/en/                               documentation in English
docs/pt-br/                            documentação em português
```

## Documentation

- [User guide (en)](docs/en/index.md) ·
  [Guia do usuário (pt-br)](docs/pt-br/index.md) — installation, usage,
  troubleshooting
- [Developer guide (en)](docs/en/developer-guide/index.md) ·
  [Guia do desenvolvedor (pt-br)](docs/pt-br/developer-guide/index.md) — theme
  architecture, packaging, CI and releases

## Build and validate

On Arch Linux, install the package prerequisites and run:

```sh
make validate
make build
```

The package is written to `build/dist/`. Install it with `make install`.

To preview the splash without rebooting, run `sudo plymouth --show-splash` and
then `sudo plymouthquit`; see the usage guide for details. There is no `make test`
target.

## Theme colors

| Element | Color |
| --- | --- |
| Background | `#111316` |
| Accent | `#3590BD` |
| Progress track | `#262933` |

## Contributing and policies

- [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) — contribution workflow
- [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) — private vulnerability reports
- [Code of Conduct](https://github.com/argvus/.github/blob/main/policies/CODE_OF_CONDUCT.md) — community standards
- [AI usage policy](https://github.com/argvus/.github/blob/main/policies/IA_USAGE.md) — rules for AI-assisted contributions
