---
title: CI and Releases
description: Validation, continuous integration, signing, and release workflow.
---

# CI and releases

The validation gate, the continuous integration jobs, the release pipeline and
the versioning rules.

For the package itself see [packaging](packaging.md); for the theme see
[theme architecture](theme.md).

## Validation

`tools/sh/validate.sh` is the required gate:

- requires `bash`, `makepkg`, `shellcheck`;
- `shellcheck` + `bash -n` on `tools/sh/*.sh` and `packaging/arch/common/*.sh`;
- sources both PKGBUILDs and compares extracted metadata — CI and local must
  match;
- `makepkg -p PKGBUILD --printsrcinfo` inside `ci/` and `local/` (parses the
  file the way makepkg does);
- `git diff --check` (whitespace/conflict markers).

## Continuous integration

`.github/workflows/ci.yml` (push/PR to `main`, `archlinux:latest` container):

1. install `base-devel git namcap pacman-contrib shellcheck sudo`;
2. `make validate`;
3. build as an **unprivileged** `builder` user
   (`sudo -u builder env HOME=/home/builder make build`) — makepkg refuses to run
   as root, and the workspace is `chown`ed first;
4. a separate `spellcheck` job runs `cspell-action@v6` with `cspell.json`.

`namcap` runs inside `pkgbuild_local.sh` when installed, so local builds surface
the same lint as CI. Spellcheck config is `cspell.json` with the workspace
dictionary in `.cspell/custom-dictionary-workspace.txt` — new technical terms
(shell flags, tool names) belong in that dictionary, otherwise CI fails.

## Release pipeline

`.github/workflows/release.yml` — triggers: push of a `v*` tag, or
`workflow_dispatch` with an existing tag (controlled rebuild). Concurrency group
`release-<ref>`, no cancellation.

Steps:

1. **Checkout** the tag (dispatch uses `inputs.tag`).
2. **Version step**: validates the tag against
   `^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$`, fails if `url` is empty in
   `packaging/arch/ci/PKGBUILD`, then rewrites `pkgver` from the tag.
3. **Validate**: `make validate`.
4. **Build** as unprivileged `builder`: `updpkgsums` (resolves and validates the
   real `sha256sums`) then
   `makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`.
   Locates the `.pkg.tar.zst` and fails if none exists.
5. **namcap** on the package.
6. **Sign**: imports `GPG_PRIVATE_KEY` into a throwaway `GNUPGHOME` (`mktemp -d`,
   mode 700), verifies the imported secret key matches `GPG_KEY_ID` (short ID or
   fingerprint), and creates a detached `.sig` with
   `--pinentry-mode loopback --passphrase-fd 0`.
7. **Verify signature** in a fresh `GNUPGHOME` — the release fails if the
   signature does not verify.
8. **Upload artifact** (`upload-artifact@v4`, `retention-days: 1`, package +
   signature, `if-no-files-found: error`).
9. **Publish**: check out `argvus/packages` with `PACKAGES_REPO_TOKEN`, copy the
   package and `.sig` into `public/arch/x86_64`, run
   `repo-add -R argvus.db.tar.gz <pkg>`, sign `argvus.db.tar.gz`,
   `argvus.files.tar.gz`, `argvus.db` and `argvus.files`, then commit as
   `github-actions[bot]` and push. A no-change diff exits 0 without committing.
10. **GitHub release**: `softprops/action-gh-release@v2` with generated notes
    and the package + signature as assets.

## Checksums, signing and secrets

- There is no `SKIP`: `sha256sums` is always a real digest, computed at build
  time (local) or via `updpkgsums` (release CI).
- Keep `sha256sums=()` **empty** in the repository.
- Releases are GPG-signed (package `.sig`, `argvus.db.tar.gz`,
  `argvus.files.tar.gz`, `argvus.db`, `argvus.files`).
- `GPG_PASSPHRASE` must be non-empty; the workflow rejects an empty passphrase.

Prepare the key:

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```

In **Settings → Secrets and variables → Actions** of the repository:

| Secret | Value |
| --- | --- |
| `GPG_PRIVATE_KEY` | `gpg --armor --export-secret-keys KEY_ID` output |
| `GPG_KEY_ID` | expected key ID or fingerprint |
| `GPG_PASSPHRASE` | non-empty passphrase of the signing key |
| `PACKAGES_REPO_TOKEN` | PAT with `contents:write` on `argvus/packages` |

## Publishing a release

Before tagging:

1. Fill in `url` in `packaging/arch/ci/PKGBUILD` with the real repository:
   - GitHub: `url="https://github.com/argvus/argvus-boot-splash"` (the source
     uses `${url}/archive/refs/tags/v${pkgver}.tar.gz`);
   - GitLab: adjust `source=` to
     `https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz`;
   - without `url`, the release **fails on purpose** with a clear message.
2. Sync versions/metadata in `packaging/arch/local/PKGBUILD` and
   `packaging/arch/ci/PKGBUILD`.
3. Regenerate and commit `CHANGELOG.md` (see
   [versioning](#versioning-and-changelog)).
4. Tag and push:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```

   The workflow can also be started manually with an existing `v*` tag as its
   `tag` input, which is useful for a controlled rebuild.

## Versioning and changelog

- SemVer in `pkgver`, release count in `pkgrel`.
- `CHANGELOG.md` is generated by `git-cliff` from Conventional Commits, using
  `cliff.toml`: groups `feat`, `fix`, `docs`, `refactor`, `test`, `ci`, `perf`,
  `build`; `chore` commits are skipped; commits are sorted oldest-first.
- Generate **before** tagging, commit the result, then tag — otherwise the
  commits are already attributed to the new version and the dated section only
  settles on the next run.

  ```sh
  make changelog
  git add CHANGELOG.md
  git commit -m "docs(changelog): update for v0.1.0"
  git tag v0.1.0
  git push origin v0.1.0
  ```

- Unreleased entries appear under `## [Unreleased]`; `[Unreleased]` becomes
  `## [X.Y.Z] - <date>` once a tag exists.
- `git-cliff --unreleased --strip header` previews pending changes,
  `git-cliff --bump` suggests the next version.
- A repository without any commit makes `make changelog` fail
  (`reference 'refs/heads/main' not found`).

## Developer troubleshooting

**Release fails at "Retrieving sources".** Empty `url`, missing `v*` tag, or an
archive URL format that does not match the host (GitHub vs GitLab tarball
layout). The workflow validates the tag pattern and fails early on an empty
`url`.

**`updpkgsums` cannot find the source.** The tag must exist and be pushed before
the release job runs; dispatching with a tag that only exists locally fails here.

**`make validate` reports "CI and local PKGBUILD metadata is out of sync".**
Copy the metadata fields (not `source=`) from one PKGBUILD to the other.

**Spellcheck fails on a new term.** Add it to
`.cspell/custom-dictionary-workspace.txt` (the `argvus` dictionary, `addWords:
true`), not to `ignorePaths`.

**`sudo` requested inside `make install`, or `libfakeroot.so … LD_PRELOAD`
errors.** A `package()` that shells out to `make install` instead of using
`install -Dm*`. Both PKGBUILDs call `arch_package_splash_payload`, which does
not; make sure nobody reintroduced a `make` call.

**`makepkg` refuses to run.** It must not run as root. Run the build as a normal
user, or `sudo -u <user> make build`.

**Package installs but the splash is unchanged.** The initramfs was not rebuilt.
For local testing, call `sudo plymouth --show-splash` instead of rebooting, or
rebuild with `sudo mkinitcpio -P` / `sudo dracut --regenerate-all`.
