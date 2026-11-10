---
title: UKI- und systemd-boot-Splash
description: Verwenden Sie das ARGVUS-Splash-Bitmap in einem UKI-Bootvorgang.
---
# UKI- und systemd-boot-Splash

Das Paket enthält außerdem `argvus-uki-splash.bmp` (400x400, 32-Bit unkomprimiert
BMP). Es ist für UKI-/systemd-boot-Startabläufe gedacht, bei denen das Splash-Bild
in das einheitliche Kernel-Image eingebettet wird, anstatt aus dem
Initramfs gelesen zu werden.

Die Bitmap wird *nicht* vom Plymouth-Theme verwendet und es wird nichts automatisch für Sie registriert: Das Einbetten hängt davon ab, wie Sie Ihr UKI erstellen. Typische
Anwender sind:

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```
Führen Sie den UKI-Build (oder `bootctl set-splash`) erneut aus, wann immer sich das Bild ändert, und denken Sie daran, die Datei auf das ESP zu kopieren, wenn Sie woanders bauen. systemd-boot skaliert die Bitmap auf die Konsole, sodass ein quadratisches Bild zentriert erscheint.

Wenn Sie nur mkinitcpio oder dracut verwenden, können Sie diese Datei vollständig ignorieren — die reguläre [installation](/docs/argvus-boot-splash/installation/) deckt diesen Pfad ab.

## Nächste Schritte

- [Usage](/docs/argvus-boot-splash/usage/)
- [Troubleshooting](/docs/argvus-boot-splash/troubleshooting/)
