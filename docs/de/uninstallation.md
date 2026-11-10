---
title: Deinstallation
description: Entfernen Sie das Paket und stellen Sie Ihr vorheriges Boot-Theme wieder her.
---
# Deinstallation

```sh
sudo pacman -Rns argvus-boot-splash
```
Wähle dann ein anderes Thema und baue es neu, sonst bleibt der alte Splash im Initramfs:

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```
`pacman -Rns` entfernt auch `/etc/plymouth/plymouthd.conf`, wenn sonst niemand es erstellt hat.

Der Deinstallations-Hook des Pakets druckt nur eine Erinnerung aus — er errät nicht, welches Theme Sie stattdessen möchten, und er berührt Ihr initramfs nicht.

## Nächste Schritte

- [Fehlerbehebung](/docs/argvus-boot-splash/troubleshooting/) — Wiederherstellung des vorherigen Splash.
- [Installation](/docs/argvus-boot-splash/installation/) — spätere Neuinstallation.
