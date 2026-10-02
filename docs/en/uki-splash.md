---
title: UKI and systemd-boot Splash
description: Use the ARGVUS splash bitmap in a UKI boot flow.
---

# UKI and systemd-boot splash

The package also ships `argvus-uki-splash.bmp` (400x400, 32-bit uncompressed
BMP). It is meant for UKI / systemd-boot boot flows, where the splash image is
embedded into the unified kernel image instead of being read from the
initramfs.

The bitmap is *not* used by the Plymouth theme and nothing is registered for
you automatically: embedding it depends on how you build your UKI. Typical
consumers are:

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```

Re-run the UKI build (or `bootctl set-splash`) whenever the image changes, and
remember to copy the file to the ESP if you build elsewhere. systemd-boot scales
the bitmap to the console, so a square image appears centered.

If you only use mkinitcpio or dracut, you can ignore this file entirely — the
regular [installation](/docs/argvus-boot-splash/installation/) covers that path.

## Next steps

- [Usage](/docs/argvus-boot-splash/usage/)
- [Troubleshooting](/docs/argvus-boot-splash/troubleshooting/)
