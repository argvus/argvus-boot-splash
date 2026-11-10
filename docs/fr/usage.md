---
title: Utilisation
description: Vérifiez l'installation, prévisualisez sans redémarrer et changez de thème.
---

# Utilisation

Comment vérifier le thème, le prévisualiser sans redémarrer et en changer.
Pour l'installation, voir [installation](/docs/argvus-boot-splash/installation/)].

## Vérification de l'installation

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```
## Aperçu sans redémarrage

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```
L'aperçu peut demander une authentification polkit lorsqu'il est exécuté en tant qu'utilisateur régulier. La barre de progression avance avec la progression simulée ; vous pouvez également forcer les états :

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```
Pendant que l'écran d'accueil est affiché, appuyez sur <kbd>Esc</kbd> pour passer à l'écran suivant (accueil → détails → accueil).

## Ce que montre l'écran d'accueil

| Étape | Apparence |
| --- | --- |
| Démarrage | Tout apparaît progressivement sur ~1 seconde : logo, nom, barre de progression |
| Démarrage du système | La barre se remplit de gauche à droite tandis que Plymouth indique la progression |
| Volume chiffré | L'écran d'accueil s'assombrit à 15%, le texte du prompt et les points masqués apparaissent en dessous de la barre |
| Mot de passe accepté | La fenêtre disparaît, l'écran d'accueil revient à pleine opacité |

## Changer ou revenir au thème

```sh
# switch theme (any theme name under /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# then regenerate the initramfs
sudo mkinitcpio -P              # or: sudo dracut --regenerate-all
```
Fichiers de configuration utiles :

| Fichier | But |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` écrit par le paquet |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` doit inclure `plymouth` |
| `/etc/plymouth/plymouthd.conf` (encore) | `PLYMOUTH_TOGGLE_KEY` etc. sont globaux, pas par thème |

## Fiche de commandes

| Commande | Effet |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | rendre `argvus` le thème par défaut |
| `sudo plymouth-update-theme` | appliquer le changement à Plymouth en cours d'exécution |
| `sudo plymouth --show-splash` | afficher le splash dans la session en cours |
| `sudo plymouth --show-details` | afficher à la place les messages détaillés du démarrage |
| `sudo plymouthquit` | quitter Plymouth et restaurer votre session |
| `sudo mkinitcpio -P` | reconstruire l'initramfs d'Arch |
| `sudo dracut --regenerate-all` | reconstruire l'initramfs avec dracut |

## Étapes suivantes

- [UKI et démarrage systemd-boot splash](/docs/argvus-boot-splash/uki-splash/)
- [Désinstallation](/docs/argvus-boot-splash/uninstallation/)
- [Résolution des problèmes](/docs/argvus-boot-splash/troubleshooting/)
