---
title: Usage
description: Verify the install, preview without rebooting, and switch themes.
---

# Usage

How to verify the theme, preview it without rebooting, and switch away from it.
For installation, see [installation](installation.md).

## Verifying the installation

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```

## Previewing without rebooting

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```

The preview may ask for polkit authentication when run as a regular user. The
progress bar advances with the simulated progress; you can also force states:

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```

While the splash is up, press <kbd>Esc</kbd> to cycle to the next screen
(splash → details → splash).

## What the splash shows

| Stage | Appearance |
| --- | --- |
| Startup | Everything fades in over ~1 second: logo, wordmark, progress track |
| Booting | The bar fills from the left as Plymouth reports progress |
| Encrypted volume | Splash dims to 15%, prompt text and masked bullets appear below the bar |
| Passphrase accepted | Dialog disappears, splash returns to full opacity |

## Changing or reverting the theme

```sh
# switch theme (any theme name under /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# then regenerate the initramfs
sudo mkinitcpio -P              # or: sudo dracut --regenerate-all
```

Useful configuration files:

| File | Purpose |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` written by the package |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` must include `plymouth` |
| `/etc/plymouth/plymouthd.conf` (again) | `PLYMOUTH_TOGGLE_KEY` etc. are global, not per-theme |

## Commands cheat sheet

| Command | Effect |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | make `argvus` the default theme |
| `sudo plymouth-update-theme` | apply the change to the running Plymouth |
| `sudo plymouth --show-splash` | show the splash in the current session |
| `sudo plymouth --show-details` | show verbose boot messages instead |
| `sudo plymouthquit` | leave Plymouth and restore your session |
| `sudo mkinitcpio -P` | rebuild the Arch initramfs |
| `sudo dracut --regenerate-all` | rebuild the initramfs with dracut |

## Next steps

- [UKI and systemd-boot splash](uki-splash.md)
- [Uninstallation](uninstallation.md)
- [Troubleshooting](troubleshooting.md)
