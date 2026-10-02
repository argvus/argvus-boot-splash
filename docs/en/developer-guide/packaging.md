---
title: Packaging
description: Arch package metadata, build pipeline, and Make targets.
---

# Packaging

How the Arch package is defined and produced: the two PKGBUILDs, the shared
functions, the install hooks, the local build pipeline and the Make targets.

For the theme itself see [theme architecture](/docs/argvus-boot-splash/developer-guide/theme/); for validation, CI and
releases see [CI and releases](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Two PKGBUILDs, one payload

`packaging/arch/ci/PKGBUILD` and `packaging/arch/local/PKGBUILD` are identical
except for `source=`:

| | `local` | `ci` |
| --- | --- | --- |
| source | `${pkgname}-${pkgver}.tar.gz` (built by `make build`) | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| used by | developers, `make build` | GitHub Actions release |

Both call the same functions from `packaging/arch/common/functions.sh`, and
`tools/sh/validate.sh` asserts their metadata (`pkgname`, `pkgver`, `pkgrel`,
`pkgdesc`, `arch`, `license`, `depends`, `makedepends`, `options`) is identical,
so the two cannot silently drift.

Shared metadata:

```bash
pkgname=argvus-boot-splash
pkgver=0.2.0
pkgrel=1
arch=('any')                 # pure data package
depends=('plymouth')
optdepends=('mkinitcpio: rebuild initramfs (Arch Linux)'
            'dracut: rebuild initramfs (alternative)')
options=('!debug')
conflicts=('argvus-plymouth') # renamed predecessor
replaces=('argvus-plymouth')
```

## Shared functions

`packaging/arch/common/functions.sh` provides three functions used by both
PKGBUILDs:

- `arch_normalize_source_tree` (`prepare()`) — GitHub tag archives extract to
  `<repo>-v<version>`, while the local tarball extracts to
  `<pkgname>-<pkgver>`. This renames the single top-level directory to
  `${srcdir}/${pkgname}-${pkgver}`, erroring out if the source directory is
  missing, ambiguous, or the destination already exists.
- `arch_check_splash_payload` (`check()`) — asserts every theme asset exists in
  the extracted source. This is the package's only "test suite"; the list of
  required files is in the [asset inventory](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory).
- `arch_package_splash_payload` (`package()`) — walks `src/usr` with
  `find -print0` and installs each file with `install -Dm644` into `$pkgdir`
  (NUL-safe, works with spaces in names), then installs `LICENSE` to
  `/usr/share/licenses/argvus-boot-splash/LICENSE`.

Note there is no `make install` call inside `package()`: everything is
`install -Dm*`, so the package is self-contained and rootless-build friendly.
That is deliberate — an old `package()` that called `make install` produced
`sudo`/`libfakeroot.so` failures.

## Install hooks

`packaging/arch/{ci,local}/argvus-boot-splash.install` (identical):

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`,
  then `mkinitcpio -P` if available, else `dracut --regenerate-all`, else a
  warning telling the user to rebuild manually.
- `post_remove()` → informational message only; the theme is not switched back
  automatically (safer than guessing).

## Local build pipeline

`tools/sh/pkgbuild_local.sh` (invoked by `make build`):

1. Verifies `makepkg`, `sha256sum`, `tar`, `awk`, `find` and that the PKGBUILD
   exists; sources the PKGBUILD to read `pkgname`/`pkgver` and validates both
   against allow-list regexes (`^[a-z0-9@._+-]+$` for the name, a dotted version
   pattern for the version).
2. Builds `build/artifacts/${pkgname}-${pkgver}.tar.gz` with
   `tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner`
   and `--transform "s#^\./#${pkgname}-${pkgver}/#"` — a deterministic,
   reproducible archive. It excludes `.git`, `build/`, `dist/`, `target/`,
   `tools/`, `release`/`packages-repo` scratch dirs, and any `src/`, `pkg/` or
   package leftovers inside the packaging directories.
3. Computes the archive's `sha256` and injects it with `sed` into a **temporary
   copy** of the local PKGBUILD (`.PKGBUILD.local.XXXXXX`, removed by an `EXIT`
   trap). The repository always keeps `sha256sums=()` empty; `SKIP` is never
   used.
4. Deletes any pre-existing `${pkgname}-${pkgver}-*.pkg.tar.zst` from
   `build/dist/` so a stale package can't be mistaken for this build.
5. Runs `makepkg -p <generated PKGBUILD> --nodeps --noconfirm --needed
   --cleanbuild --force --check` with `BUILDDIR`/`SRCDEST` in `build/artifacts/`
   and `PKGDEST` in `build/dist/`. Extra arguments are forwarded to `makepkg`;
   `MAKEPKG_FLAGS` overrides the default flag set (word-split on purpose).
6. Fails unless exactly one `.pkg.tar.zst` matches, then runs `namcap` on it if
   installed.

Outputs:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```

## Make targets

| Target | Effect |
| --- | --- |
| `make build` (alias `make package`) | run `tools/sh/pkgbuild_local.sh` → `build/` |
| `make install` (alias `make install-package`) | `sudo pacman -U` the single package in `build/dist/`; errors if the count is not exactly 1 |
| `make validate` | `tools/sh/validate.sh`: shellcheck + `bash -n` + PKGBUILD metadata sync + `makepkg --printsrcinfo` per PKGBUILD + `git diff --check` |
| `make lint` (alias `make lint-shell`) | shellcheck over `tools`, `packaging/arch/common`, `src` (`SC1090`, `SC2034`, `SC2154` disabled), `bash -n`, `git diff --check` |
| `make spellcheck` | `cspell --config cspell.json .` if `cspell` is installed, otherwise skipped |
| `make changelog` | `git-cliff -o CHANGELOG.md` |
| `make clean` | `rm -rf build/` |
| `make help` | target list (default goal) |

CI runs `make validate` and `make build`; nothing in CI runs `make install` or
`make changelog` (see [known gaps](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)).

## Prerequisites

An Arch-based system with `make`, `git`, `gnupg` and the `base-devel` group:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```

- `pacman-contrib` provides `updpkgsums` (regenerates PKGBUILD checksums).
- `shellcheck` validates the repository shell scripts and the shared Arch
  packaging functions.
- Optional: `git-cliff` (changelog, `make changelog`), `namcap` (package
  linting) and cspell (local spellcheck). CI installs all of them.
