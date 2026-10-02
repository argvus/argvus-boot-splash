---
title: Installation
description: Requirements, install options, and what the package hooks do.
---

# Installation

Everything you need to get the Argvus boot splash on an Arch-based system.

For what the theme looks like and what it contains, see the
[reference](/docs/argvus-boot-splash/reference/). To rebuild it from source instead, see the
[developer guide](/docs/argvus-boot-splash/developer-guide/).

## Requirements

- An Arch-based system using `plymouth` (the package depends on it).
- An initramfs generator: **mkinitcpio** (Arch default) or **dracut**. The
  installer detects whichever is present and rebuilds the initramfs for you.
- Plymouth must be enabled in your initramfs configuration. With mkinitcpio,
  make sure `plymouth` is in the `HOOKS` list of `/etc/mkinitcpio.conf`:

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```

  Reboot if you just changed this.

- Nothing is needed for a normal graphical session; the theme only runs in the
  boot path.

## Option 1: official package repository (recommended)

The signed packages are published to the Argvus package repository
(`argvus/packages`, path `public/arch/$arch`). Add it to `/etc/pacman.conf`:

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```

Replace `<PACKAGES_REPO_BASE_URL>` with the host the project publishes the
repository on (GitHub, GitLab or Gitea). Import the repository signing key first,
otherwise `pacman` refuses the download:

```sh
# 1. import the project's public signing key into your pacman keyring
pacman-key --add /path/to/argvus-signing-key.asc
pacman-key --lsign <key-id>

# 2. refresh and install
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```

## Option 2: release package file

Each tagged release publishes a `.pkg.tar.zst` (plus its `.sig`) as a release
asset. Install it directly:

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

If you care about supply-chain hygiene, verify the detached signature against the
project's public key before installing:

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

## Option 3: manual installation

Useful on non-Arch systems, or if you just want to try the theme without
packaging. Copy the theme directory into Plymouth's theme path:

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# or: sudo mkinitcpio -P        # Arch
# or: sudo dracut --regenerate-all
```

Plymouth can also be enabled in `/etc/default/grub` with `GRUB_CMDLINE_LINUX`
containing `splash`, and `quiet` gives the classic minimal-boot feel.

## What the installer does

After install or upgrade, the package hooks run automatically:

1. `plymouth-set-default-theme argvus` — writes `argvus` into
   `/etc/plymouth/plymouthd.conf`.
2. `mkinitcpio -P` if mkinitcpio exists, otherwise `dracut --regenerate-all`.

If neither generator is found, the installer prints a warning and you must
rebuild the initramfs yourself. A theme change only becomes visible at boot after
the initramfs is regenerated — rebooting without that step is the single most
common reason for "the splash did not change".

On removal the package only prints a reminder: choosing a different theme and
rebuilding the initramfs is left to you. See
[uninstallation](/docs/argvus-boot-splash/uninstallation/).

## Next steps

- [Usage](/docs/argvus-boot-splash/usage/) — verify the installation, preview without rebooting, switch
  themes.
- [UKI and systemd-boot splash](/docs/argvus-boot-splash/uki-splash/) — use the bitmap in a UKI.
- [Troubleshooting](/docs/argvus-boot-splash/troubleshooting/) — if the splash did not change.
