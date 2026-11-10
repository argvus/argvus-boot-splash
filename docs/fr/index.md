---
title: Écran de démarrage ARGVUS
description: Guide de thème et d'installation de Plymouth pour l'environnement de bureau ARGVUS
---

# ARGVUS Écran de démarrage

L'écran de démarrage Argvus est un thème [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/) pour l'écosystème de bureau Argvus. C'est ce que vous voyez entre l'allumage de la machine et le moment où votre session graphique commence.

## Documentation

Cette documentation est organisée en deux sections principales :

### Guide de l'utilisateur
Guides d'installation et d'utilisation pour les utilisateurs finaux et les administrateurs système.

| Guide | Contenu |
| --- | --- |
| [Installation](/docs/argvus-boot-splash/installation/) | Exigences, les trois options d'installation, ce que font les hooks du paquet |
| [Utilisation](/docs/argvus-boot-splash/usage/) | Vérifier l'installation, prévisualiser sans redémarrer, changer ou rétablir les thèmes, aide-mémoire des commandes |
| [UKI et écran de démarrage systemd-boot](/docs/argvus-boot-splash/uki-splash/) | Utilisation de `argvus-uki-splash.bmp` dans un flux de démarrage UKI |
| [Désinstallation](/docs/argvus-boot-splash/uninstallation/) | Supprimer le paquet et restaurer le thème précédent |
| [Dépannage](/docs/argvus-boot-splash/troubleshooting/) | Symptômes courants et leurs causes |
| [Référence](/docs/argvus-boot-splash/reference/) | Fichiers installés, métadonnées du paquet, valeurs de couleur |

### [Guide du développeur](/docs/argvus-boot-splash/developer-guide/)
Documentation technique pour les contributeurs et les mainteneurs.

- [Architecture thématique](/docs/argvus-boot-splash/developer-guide/theme/) — Descripteur Plymouth, modèle de rendu et personnalisation
- [Emballage](/docs/argvus-boot-splash/developer-guide/packaging/) — Pipeline de construction et recettes de paquet
- [CI et Versions](/docs/argvus-boot-splash/developer-guide/ci-releases/) — Workflow de validation, test et publication

## Démarrage rapide

Pour les systèmes basés sur Arch :

```sh
sudo pacman -S argvus-boot-splash   # or: sudo pacman -U ./argvus-boot-splash-<version>-1-any.pkg.tar.zst
```
L'installateur définit le thème par défaut et régénère automatiquement votre initramfs.

---

- **Dépôt :** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **Licence :** GPL-3.0-only
- **Rapports de bogues :** [GitHub Issues](https://github.com/argvus/argvus-boot-splash/issues)
