---
title: Emballage
description: Métadonnées du package Arch, pipeline de construction et cibles Make.
---

# Emballage

Comment le paquet Arch est défini et produit : les deux PKGBUILD, les fonctions partagées, les hooks d'installation, le pipeline de construction local et les cibles Make.

Pour le thème lui-même, voir [architecture du thème](/docs/argvus-boot-splash/developer-guide/theme/) ; pour la validation, l'intégration continue et les versions, voir [CI et versions](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Deux PKGBUILD, un seul contenu

`packaging/arch/remote/PKGBUILD` et `packaging/arch/local/PKGBUILD` sont identiques sauf pour `source=` :

| | `local` | `ci` |
| --- | --- | --- |
| source | `${pkgname}-${pkgver}.tar.gz` (construit par `make build`) | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| utilisé par | développeurs, `make build` | publication GitHub Actions |

Les deux appellent les mêmes fonctions depuis `packaging/arch/common/functions.sh`, et `tools/sh/validate.sh` affirme que leurs métadonnées (`pkgname`, `pkgver`, `pkgrel`, `pkgdesc`, `arch`, `license`, `depends`, `makedepends`, `options`) sont identiques, donc les deux ne peuvent pas dériver silencieusement.

Métadonnées partagées :

```bash
pkgname=argvus-boot-splash
pkgver=0.2.0
pkgrel=1
arch=('any')                 # pure data package
depends=('plymouth')
optdepends=('mkinitcpio: rebuild initramfs (Arch Linux)'
            'dracut: rebuild initramfs (alternative)')
options=('!debug')
conflicts=('argvus-plymouth') # renamed predecessor
replaces=('argvus-plymouth')
```
## Fonctions partagées

`packaging/arch/common/functions.sh` fournit trois fonctions utilisées à la fois par les PKGBUILD :

- `arch_normalize_source_tree` (`prepare()`) — Les archives de tags GitHub sont extraites vers `<repo>-v<version>`, tandis que le tarball local est extrait vers `<pkgname>-<pkgver>`. Cela renomme le répertoire de niveau supérieur unique en `${srcdir}/${pkgname}-${pkgver}`, en générant une erreur si le répertoire source est manquant, ambigu ou si la destination existe déjà.
- `arch_check_splash_payload` (`check()`) — vérifie que chaque ressource du thème existe dans la source extraite. Il s'agit du seul « ensemble de tests » du paquet ; la liste des fichiers requis se trouve dans l'[inventaire des ressources](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory).
- `arch_package_splash_payload` (`package()`) — parcourt `src/usr` avec `find -print0` et installe chaque fichier avec `install -Dm644` dans `$pkgdir` (compatible NUL, fonctionne avec les espaces dans les noms), puis installe `LICENSE` dans `/usr/share/licenses/argvus-boot-splash/LICENSE`.

Notez qu'il n'y a aucun appel `make install` à l'intérieur de `package()` : tout est `install -Dm*`, donc le package est autonome et compatible avec une construction sans privilèges root. C'est délibéré — un ancien `package()` qui appelait `make install` produisait des échecs `sudo`/`libfakeroot.so`.

## Installer des hooks

`packaging/arch/{ci,local}/argvus-boot-splash.install` (identique) :

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`, puis `mkinitcpio -P` si disponible, sinon `dracut --regenerate-all`, sinon un avertissement indiquant à l'utilisateur de reconstruire manuellement.
- `post_remove()` → message d'information seulement ; le thème n'est pas rétabli automatiquement (plus sûr que de deviner).

## Pipeline de construction locale

`tools/sh/pkgbuild_local.sh` (appelé par `make build`) :

1. Vérifie `makepkg`, `sha256sum`, `tar`, `awk`, `find` et que le PKGBUILD existe ; source le PKGBUILD pour lire `pkgname`/`pkgver` et valide les deux
   contre les expressions régulières de liste autorisée (`^[a-z0-9@._+-]+$` pour le nom, un modèle en version pointillée pour la version).
2. Construit `build/artifacts/${pkgname}-${pkgver}.tar.gz` avec
   `tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner`
   et `--transform "s#^\./#${pkgname}-${pkgver}/#"` — une archive déterministe,
   reproductible. Elle exclut les répertoires temporaires `.git`, `build/`, `dist/`, `target/`,
   `tools/`, `release`/`packages-repo`, ainsi que tout reste de `src/`, `pkg/` ou
   de paquet à l'intérieur des répertoires de packaging.
3. Calcule le `sha256` de l'archive et l'injecte avec `sed` dans une **copie temporaire** du PKGBUILD local (`.PKGBUILD.local.XXXXXX`, supprimé par un piège `EXIT`). Le dépôt garde toujours `sha256sums=()` vide ; `SKIP` n'est jamais
   utilisé.
4. Supprime tout `${pkgname}-${pkgver}-*.pkg.tar.zst` existant de
   `build/dist/` afin qu'un paquet obsolète ne soit pas confondu avec cette construction.
5. Exécute `makepkg -p <generated PKGBUILD> --nodeps --noconfirm --needed
   --cleanbuild --force --check` with `BUILDDIR`/`SRCDEST` in `build/artifacts/`
   et `PKGDEST` dans `build/dist/`. Les arguments supplémentaires sont transmis à `makepkg` ;
   `MAKEPKG_FLAGS` remplace l'ensemble de drapeaux par défaut (séparé en mots intentionnellement).
6. Échoue à moins qu'exactement un `.pkg.tar.zst` corresponde, puis exécute `namcap` dessus s'il est installé.

Sorties :

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```
## Cibles Make

| Cible | Effet |
| --- | --- |
| `make build` (alias `make package`) | exécute `tools/sh/pkgbuild_local.sh` → `build/` |
| `make install` (alias `make install-package`) | `sudo pacman -U` le paquet unique dans `build/dist/` ; erreurs si le nombre n'est pas exactement 1 |
| `make validate` | `tools/sh/validate.sh` : shellcheck + `bash -n` + synchronisation des métadonnées PKGBUILD + `makepkg --printsrcinfo` par PKGBUILD + `git diff --check` |
| `make lint` (alias `make lint-shell`) | shellcheck sur `tools`, `packaging/arch/common`, `src` (`SC1090`, `SC2034`, `SC2154` désactivés), `bash -n`, `git diff --check` |
| `make spellcheck` | `cspell --config cspell.json .` si `cspell` est installé, sinon ignoré |
| `make clean` | `rm -rf build/` |
| `make help` | liste des cibles (objectif par défaut) |

CI exécute `make validate` et `make build` ; rien dans CI n'exécute `make install`
(voir [lacunes connues](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)).

## Prérequis

Un système basé sur Arch avec `make`, `git`, `gnupg` et le groupe `base-devel` :

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```
- `pacman-contrib` fournit `updpkgsums` (régénère les sommes de contrôle PKGBUILD).
- `shellcheck` valide les scripts shell du dépôt et les fonctions de packaging Arch partagées.
- Optionnel : `namcap` (vérification des paquets) et cspell (correction orthographique locale). Le CI installe tous ces outils.
