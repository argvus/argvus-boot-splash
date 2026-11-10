---
title: UKI e schermata di avvio di systemd-boot
description: Usa il bitmap di splash ARGVUS in un flusso di avvio UKI.
---
# UKI e splash di systemd-boot

Il pacchetto include anche `argvus-uki-splash.bmp` (400x400, BMP non compresso a 32 bit). È destinato ai flussi di avvio UKI / systemd-boot, dove l'immagine di splash è incorporata nell'immagine del kernel unificato invece di essere letta dall'initramfs.

La bitmap *non* viene utilizzata dal tema Plymouth e non viene registrato nulla automaticamente per te: l'incorporazione dipende da come costruisci il tuo UKI. I consumatori tipici sono:

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```
Esegui nuovamente la build UKI (o `bootctl set-splash`) ogni volta che l'immagine cambia e ricorda di copiare il file nell'ESP se compili altrove. systemd-boot ridimensiona la bitmap per la console, quindi un'immagine quadrata appare centrata.

Se usi solo mkinitcpio o dracut, puoi ignorare completamente questo file — l'[installazione](/docs/argvus-boot-splash/installation/) copre quel percorso.

## Prossimi passi

- [Uso](/docs/argvus-boot-splash/usage/)
- [Risoluzione dei problemi](/docs/argvus-boot-splash/troubleshooting/)
