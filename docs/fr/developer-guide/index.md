---
title: Guide du développeur
description: Orientations architecturales et de développement pour les contributeurs d'ARGVUS.
---
# Argvus Boot Splash — Guide du développeur

Documentation technique pour le dépôt `argvus-boot-splash` : comment le thème Plymouth est assemblé, comment le package Arch est construit, et comment les versions sont signées et publiées.

Il n'y a pas d'étape de compilation ici — le thème est constitué de données (un descripteur `.plymouth`, un `.script`, et des images) plus une recette de paquet Arch. « Construire » signifie produire un paquet reproductible :

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```
Avant de valider un changement : `make validate && make build`, et ajoutez de nouveaux termes techniques à `.cspell/custom-dictionary-workspace.txt` sinon le travail de vérification orthographique échoue.

Si vous voulez seulement *utiliser* le thème, lisez le [guide de l'utilisateur](/docs/argvus-boot-splash/). Pour l'équivalent orienté processus de ce fichier (git flow, secrets, processus de publication) consultez [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) et [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).

## Guides

| Guide | Contenu |
| --- | --- |
| [Architecture du thème](/docs/argvus-boot-splash/developer-guide/theme/) | Descripteur, modèle de rendu, inventaire des ressources, parcours du script, constantes de mise en page, jetons de conception, bitmap UKI, comment modifier le thème |
| [Emballage](/docs/argvus-boot-splash/developer-guide/packaging/) | Les deux PKGBUILDs, `functions.sh` partagé, hooks d'installation, pipeline de construction locale, cibles Make, prérequis |
| [CI et versions](/docs/argvus-boot-splash/developer-guide/ci-releases/) | `validate.sh`, `ci.yml`, `release.yml` étape par étape, sommes de contrôle, signature, secrets, publication et gestion des versions |
| [Conventions et lacunes connues](/docs/argvus-boot-splash/developer-guide/workflow/) | Règles internes, carte de la documentation, et incohérences trouvées lors de l'audit du dépôt |

## Référence rapide

| Chemin | Ce que c'est |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | charge utile du thème installée sous `/usr` |
| `packaging/arch/{ci,local}/PKGBUILD` | recettes de version et de paquet local |
| `packaging/arch/common/functions.sh` | partage `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | archive tarball déterministe + pilote `makepkg` |
| `tools/sh/validate.sh` | porte de validation requise |
| `.github/workflows/` | `ci.yml` (valider, construire, vérifier l'orthographe), `release.yml` (étiquettes `v*`) |

## Ailleurs

- Racine du dépôt : [README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
- Documentation destinée aux utilisateurs : [guide de l'utilisateur](/docs/argvus-boot-splash/)
- Processus de développement : [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
- Contribution : [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
- Politique de sécurité : [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
- Licence : [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
- Version portugaise : [Guia do desenvolvedor](/pt/docs/argvus-boot-splash/developer-guide/)
