---
title: Disinstallazione
description: Rimuovi il pacchetto e ripristina il tuo tema di avvio precedente.
---
# Disinstallazione

```sh
sudo pacman -Rns argvus-boot-splash
```
Poi scegli un altro tema e ricostruisci, altrimenti il vecchio splash rimane all'interno dell'initramfs:

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```
`pacman -Rns` rimuove anche `/etc/plymouth/plymouthd.conf` se nessun altro lo ha creato.

Il hook di rimozione del pacchetto stampa solo un promemoria — non indovina quale tema vuoi invece, e non tocca il tuo initramfs.

## Passi successivi

- [Risoluzione dei problemi](/docs/argvus-boot-splash/troubleshooting/) — ripristinare lo splash precedente.
- [Installazione](/docs/argvus-boot-splash/installation/) — reinstallare più tardi.
