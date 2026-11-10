---
title: UKI et démarrage systemd-boot
description: Utilisez le bitmap de démarrage ARGVUS dans un flux de démarrage UKI.
---
# UKI et écran de démarrage systemd-boot

Le paquet inclut également `argvus-uki-splash.bmp` (400x400, BMP non compressé 32 bits). Il est destiné aux flux de démarrage UKI / systemd-boot, où l'image de démarrage est intégrée dans l'image du noyau unifiée au lieu d'être lue depuis l'initramfs.

La bitmap *n'est pas* utilisée par le thème Plymouth et rien n'est enregistré automatiquement pour vous : l'intégration dépend de la manière dont vous construisez votre UKI. Les utilisateurs typiques sont :

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```
Relancez la construction UKI (ou `bootctl set-splash`) chaque fois que l'image change, et n'oubliez pas de copier le fichier sur l'ESP si vous construisez ailleurs. systemd-boot ajuste la taille de l'image bitmap à celle de la console, donc une image carrée apparaît centrée.

Si vous utilisez uniquement mkinitcpio ou dracut, vous pouvez ignorer ce fichier complètement — l'[installation](/docs/argvus-boot-splash/installation/) couvre ce chemin.

## Étapes suivantes

- [Utilisation](/docs/argvus-boot-splash/usage/)
- [Dépannage](/docs/argvus-boot-splash/troubleshooting/)
