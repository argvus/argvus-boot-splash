# Arch packaging

This directory contains the release and local Arch Linux package metadata.

- `ci/PKGBUILD` fetches the tagged `argvus-boot-splash` source archive.
- `local/PKGBUILD` consumes the deterministic archive created by `make build`.
- `common/functions.sh` normalizes extracted source directories and installs
  the Plymouth payload.
- `ci/argvus-boot-splash.install` and `local/argvus-boot-splash.install` select the theme
  and rebuild the initramfs after package installation or upgrade.

Run `makepkg --printsrcinfo` from either the `ci` or `local` directory when
checking package metadata directly.
