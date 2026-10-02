---
title: Troubleshooting
description: Common boot splash symptoms and how to fix them.
---

# Troubleshooting

**The splash did not change after installing.**
The initramfs was not regenerated. Run `sudo mkinitcpio -P` (or
`sudo dracut --regenerate-all`) and reboot. If your system uses multiple kernels,
make sure the one you boot got the new initramfs.

**No splash at all; the screen is black or text only.**
`plymouth` is missing from the initramfs hooks. Check `/etc/mkinitcpio.conf`
`HOOKS=(...)` contains `plymouth`, then rebuild and reboot. On Ubuntu/Debian,
also confirm `plymouth` and `plymouth-x11`/`plymouth-themes` are installed and
that `GRUB_CMDLINE_LINUX` has `splash quiet`.

**Only the logo, no progress.**
Some boot steps are not reported by your init, or the progress callback is
never called — nothing is broken on your side. The bar fills from Plymouth's
reported progress, which is absent in a few setups (for example with systemd's
`plymouth-spawn`-less sequences or certain dracut modules).

**The password prompt is misplaced or invisible.**
The dialog is positioned from the wordmark and track geometry, so extreme
resolutions (very small text mode) can push it off-screen. Use a normal
resolution, and report it if it happens at common resolutions.

**Plymouth quits early / you see the text console instead.**
Something disabled Plymouth: the `quiet` boot parameter without `splash`, a
`plymouth` hook removed, or a driver that Plymouth cannot use. Plymouth exits to
the text console rather than freezing the machine — this is expected behavior.

**The theme is not applied after upgrading from `argvus-plymouth`.**
The new package replaces the old one; verify `/etc/plymouth/plymouthd.conf` says
`PLYMOUTH_THEME_NAME=argvus` and rebuild the initramfs.

**Install fails on signature verification.**
The repository key is missing or outdated in your keyring. Re-import the current
public key, then `sudo pacman -Sy`.

**Lock screen / suspend looks unchanged.**
The theme only covers boot. Hibernate/resume screens are controlled separately
(`systemd-homed`, screen lockers, `plymouth` usage in the sleep target of your
initramfs).

**A stray Plymouth is still running after a preview.**
`sudo plymouthquit` restores your session. If the screen stays black, switch to
another virtual terminal (`Ctrl+Alt+F2`) — your session is intact.

## Next steps

- [Installation](installation.md) — retry with a different method.
- [Usage](usage.md) — commands cheat sheet.
