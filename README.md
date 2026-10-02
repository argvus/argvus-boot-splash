# Argvus Splash

Plymouth boot splash theme for the Argvus desktop ecosystem.

The package installs the theme under
`/usr/share/plymouth/themes/argvus/`, including the boot logo, progress bar,
password prompt assets, and UKI splash bitmap.

## Repository layout

```text
src/usr/share/plymouth/themes/argvus/  package payload
packaging/arch/ci/PKGBUILD             release package metadata
packaging/arch/local/PKGBUILD          local package metadata
packaging/arch/common/                 shared packaging functions
tools/sh/pkgbuild_local.sh             local source archive and package build
tools/sh/validate.sh                   repository and metadata validation
build/                                 ignored build artifacts
docs/en/                               documentation in English
docs/pt-br/                            documentação em português
```

## Documentation

- [User guide (en)](docs/en/user-guide.md) ·
  [Guia do usuário (pt-br)](docs/pt-br/user-guide.md) — installation, usage,
  troubleshooting
- [Developer guide (en)](docs/en/developer-guide.md) ·
  [Guia do desenvolvedor (pt-br)](docs/pt-br/developer-guide.md) — theme
  architecture, packaging, CI and releases

## Build and validate

On Arch Linux, install the package prerequisites and run:

```sh
make validate
make build
```

The package is written to `build/dist/`. Install it with `make install`.

For a direct Plymouth preview, use `make test` from an environment where a
Plymouth daemon and graphical display are available. The preview may require
polkit authentication when run as an unprivileged user.

## Theme colors

| Element | Color |
| --- | --- |
| Background | `#111316` |
| Accent | `#3590BD` |
| Progress track | `#262933` |
