---
title: Désinstallation
description: Retirez le paquet et restaurez votre thème de démarrage précédent.
---
# Désinstallation

```sh
sudo pacman -Rns argvus-boot-splash
```
Puis choisissez un autre thème et reconstruisez, sinon l'ancienne image de démarrage reste à l'intérieur du initramfs :

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```
`pacman -Rns` supprime également `/etc/plymouth/plymouthd.conf` si rien d'autre ne l'a créé.

Le hook de suppression du paquet se contente d'afficher un rappel — il ne devine pas quel thème vous souhaitez à la place, et il ne touche pas à votre initramfs.

## Prochaines étapes

- [Dépannage](/docs/argvus-boot-splash/troubleshooting/) — restauration du splash précédent.
- [Installation](/docs/argvus-boot-splash/installation/) — réinstallation ultérieure.
