---
title: Uninstallation
description: Remove the package and restore your previous boot theme.
---

# Uninstallation

```sh
sudo pacman -Rns argvus-boot-splash
```

Then pick another theme and rebuild, otherwise the old splash stays inside the
initramfs:

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```

`pacman -Rns` also removes `/etc/plymouth/plymouthd.conf` if nothing else
created it.

The package's removal hook only prints a reminder — it does not guess which theme
you want instead, and it does not touch your initramfs.

## Next steps

- [Troubleshooting](/docs/argvus-boot-splash/troubleshooting/) — restoring the previous splash.
- [Installation](/docs/argvus-boot-splash/installation/) — reinstalling later.
