---
title: Conventions and Known Gaps
description: House rules, documentation map, and repository audit findings.
---

# Conventions and known gaps

House rules for changes in this repository, plus the inconsistencies found while
auditing it — worth fixing rather than copying.

For the technical reference see [theme architecture](theme.md),
[packaging](packaging.md) and [CI and releases](ci-releases.md).

## Conventions

- Shell: `set -euo pipefail`, tabs for indentation, `printf`/`error` messages to
  stderr, `command -v` capability checks, shellcheck clean (see
  `.editorconfig`).
- Never write `sha256sums=('SKIP')`; keep `sha256sums=()` empty in git.
- Do not commit build outputs (`build/`), package files, or generated
  `.PKGBUILD.local.*` copies.
- Conventional Commits with the scopes used by the history: `splash`, `layout`,
  `pkgbuild`, `release`, `chore`, `ci`, `build`, `docs`.
- Branch naming: `feat/…`, `fix/…`, `docs/…`, `chore/…`, `refactor/…`.
- One reviewer approval before merge, squash-merge.
- License: GPL-3.0-or-later. Shipped as `/usr/share/licenses/argvus-boot-splash/LICENSE`.
- Follow the process in [CONTRIBUTING.md](../../../CONTRIBUTING.md) and
  [DEVELOPMENT.md](../../../DEVELOPMENT.md).

## Known gaps

Documented inconsistencies found while auditing the repository:

- `README.md` advertises `make test` for a direct Plymouth preview, but no such
  target exists in the [Makefile](../../../Makefile). The real commands are
  `sudo plymouth --show-splash` / `sudo plymouthquit`.
- `entry-line.png` and `logo-glow.png` ship in the payload and are required by
  `arch_check_splash_payload()`, but `argvus.script` never loads them. Either
  wire them into the script or drop them from the payload and the check list.
- `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` is installed but
  never registered with anything; the
  [user guide](../user-guide/uki-splash.md) documents the manual
  `bootctl`/`ukify` step.
- The canonical docs live at the repository root (`README.md`,
  `DEVELOPMENT.md`, `CONTRIBUTING.md`) and overlap with the guides in `docs/`.
  Keep them consistent when changing either.

## Documentation map

| Document | Audience | Scope |
| --- | --- | --- |
| `README.md` | everyone | one-paragraph overview and layout |
| `DEVELOPMENT.md` | maintainers | build, signing, release process |
| `CONTRIBUTING.md` | contributors | git flow, PR rules, secrets policy |
| [`docs/user-guide.md`](../user-guide.md) | end users | installation, usage, troubleshooting |
| [`docs/developer-guide.md`](../developer-guide.md) | developers | theme internals, packaging, CI |
