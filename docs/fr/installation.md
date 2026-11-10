---
title: Installation
description: Exigences, options d'installation et ce que font les hooks du paquet.
---

# Installation

Tout ce dont vous avez besoin pour obtenir l'écran de démarrage Argvus sur un système basé sur Arch.

Pour voir à quoi ressemble le thème et ce qu'il contient, consultez le
[reference](/docs/argvus-boot-splash/reference/)]. Pour le reconstruire à partir des sources, consultez plutôt le
[guide du développeur](/docs/argvus-boot-splash/developer-guide/)].

## Exigences

- Un système basé sur Arch utilisant `plymouth` (le paquet en dépend).
- Un générateur d'initramfs : **mkinitcpio** (par défaut sur Arch) ou **dracut**. L'installateur détecte celui qui est présent et reconstruit l'initramfs pour vous.
- Plymouth doit être activé dans votre configuration initramfs. Avec mkinitcpio, assurez-vous que `plymouth` figure dans la liste `HOOKS` de `/etc/mkinitcpio.conf` :

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```
Redémarrez si vous venez de modifier ceci.

- Rien n'est nécessaire pour une session graphique normale ; le thème ne s'exécute que dans le chemin de démarrage.

## Option 1 : dépôt de paquets officiel (recommandé)

Les paquets signés sont publiés dans le dépôt de paquets Argvus (`argvus/packages`, chemin `public/arch/$arch`). Ajoutez-le à `/etc/pacman.conf` :

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```
Remplacez `<PACKAGES_REPO_BASE_URL>` par l'hôte sur lequel le projet publie le dépôt (GitHub, GitLab ou Gitea). Importez d'abord la clé de signature du dépôt, sinon `pacman` refuse le téléchargement :

```sh
# 1. import the project's public signing key into your pacman keyring
pacman-key --add /path/to/argvus-signing-key.asc
pacman-key --lsign <key-id>

# 2. refresh and install
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```
## Option 2 : publier le fichier du package

Chaque version étiquetée publie un `.pkg.tar.zst` (ainsi que son `.sig`) en tant qu’élément de la version. Installez-le directement :

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
Si vous vous souciez de l'hygiène de la chaîne d'approvisionnement, vérifiez la signature détachée par rapport à la clé publique du projet avant l'installation :

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
## Option 3 : installation manuelle

Utile sur les systèmes non-Arch, ou si vous voulez simplement essayer le thème sans le packager. Copiez le répertoire du thème dans le chemin du thème de Plymouth :

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# or: sudo mkinitcpio -P        # Arch
# or: sudo dracut --regenerate-all
```
Plymouth peut également être activé dans `/etc/default/grub` avec `GRUB_CMDLINE_LINUX` contenant `splash`, et `quiet` donne l'impression classique d'un démarrage minimal.

## Ce que fait l'installateur

Après l'installation ou la mise à niveau, les hooks du paquet s'exécutent automatiquement :

1. `plymouth-set-default-theme argvus` — écrit `argvus` dans `/etc/plymouth/plymouthd.conf`.
2. `mkinitcpio -P` si mkinitcpio existe, sinon `dracut --regenerate-all`.

Si aucun des générateurs n'est trouvé, l'installateur affiche un avertissement et vous devez reconstruire l'initramfs vous-même. Un changement de thème ne devient visible au démarrage qu'après la régénération de l'initramfs — redémarrer sans cette étape est la raison la plus fréquente pour laquelle « le splash n'a pas changé ».

Lors de la suppression, le paquet se contente d'afficher un rappel : le choix d'un thème différent et la reconstruction de l'initramfs vous incombe. Voir [uninstallation](/docs/argvus-boot-splash/uninstallation/)].

## Étapes suivantes

- [Usage](/docs/argvus-boot-splash/usage/) — vérifier l'installation, prévisualiser sans redémarrer, changer les thèmes.
- [UKI et écran de démarrage systemd-boot](/docs/argvus-boot-splash/uki-splash/) — utiliser le bitmap dans un UKI.
- [Dépannage](/docs/argvus-boot-splash/troubleshooting/) — si l'écran de démarrage n'a pas changé.
