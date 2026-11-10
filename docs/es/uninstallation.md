---
title: Desinstalación
description: Retira el paquete y restaura tu tema de arranque anterior.
---
# Desinstalación

```sh
sudo pacman -Rns argvus-boot-splash
```
Luego elige otro tema y reconstruye, de lo contrario, la antigua pantalla de inicio permanecerá dentro del initramfs:

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```
`pacman -Rns` también elimina `/etc/plymouth/plymouthd.conf` si nada más lo creó.

El gancho de desinstalación del paquete solo imprime un recordatorio; no adivina qué tema deseas en su lugar, y no toca tu initramfs.

## Próximos pasos

- [Solución de problemas](/docs/argvus-boot-splash/troubleshooting/) — restaurando la pantalla de inicio anterior.
- [Instalación](/docs/argvus-boot-splash/installation/) — reinstalando más tarde.
