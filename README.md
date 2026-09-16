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
```

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
