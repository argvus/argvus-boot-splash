---
title: Conventions et lacunes connues
description: Règles de la maison, carte de documentation et résultats de l'audit du dépôt.
---

# Conventions et lacunes connues

Règles internes pour les modifications de ce dépôt, ainsi que les incohérences
trouvées lors de son audit — il vaut mieux les corriger plutôt que les copier.

Pour la référence technique, voir [architecture du thème](/docs/argvus-boot-splash/developer-guide/theme/),
[emballage](/docs/argvus-boot-splash/developer-guide/packaging/) et [CI et versions](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Congrès

- Shell : `set -euo pipefail`, tabulations pour l'indentation, `printf`/`error` messages vers stderr, `command -v` vérifications de capacité, shellcheck propre (voir `.editorconfig`).
- Ne jamais écrire `sha256sums=('SKIP')` ; garder `sha256sums=()` vide dans git.
- Ne pas committer les résultats de compilation (`build/`), fichiers de paquet, ou copies générées `.PKGBUILD.local.*`.
- Commits conventionnels avec les scopes utilisés par l'historique : `splash`, `layout`, `pkgbuild`, `release`, `chore`, `ci`, `build`, `docs`.
- Nomination des branches : `feat/…`, `fix/…`, `docs/…`, `chore/…`, `refactor/…`.
- Une approbation du relecteur avant fusion, squash-merge.
- Licence : GPL-3.0-only. Fourni comme `/usr/share/licenses/argvus-boot-splash/LICENSE`.
- Suivre le processus dans [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) et [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md).

## Lacunes connues

Incohérences documentées trouvées lors de l'audit du dépôt :

- `README.md` annonce `make test` pour un aperçu direct de Plymouth, mais aucune cible de ce type n'existe dans le [Makefile](https://github.com/argvus/argvus-boot-splash/blob/main/Makefile). Les commandes réelles sont `sudo plymouth --show-splash` / `sudo plymouthquit`.
- `entry-line.png` et `logo-glow.png` sont inclus dans la charge utile et sont requis par `arch_check_splash_payload()`, mais `argvus.script` ne les charge jamais. Il faut soit les intégrer dans le script, soit les retirer de la charge utile et de la liste de vérification.
- `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` est installé mais jamais enregistré auprès de quoi que ce soit ; le [guide utilisateur](/docs/argvus-boot-splash/uki-splash/) documente la procédure manuelle `bootctl`/`ukify`.
- La documentation canonique se trouve à la racine du dépôt (`README.md`, `DEVELOPMENT.md`) et chevauche les guides dans `docs/`. Il faut les maintenir cohérents.
  lors de la modification de l'un ou l'autre. Les politiques de contribution (`CONTRIBUTING.md`, `SECURITY.md`) vivent dans le dépôt de l'organisation `.github`.

## Plan de documentation

| Document | Public | Portée |
| --- | --- | --- |
| `README.md` | tout le monde | aperçu et mise en page d'un paragraphe |
| `DEVELOPMENT.md` | mainteneurs | processus de construction, signature, publication |
| [`CONTRIBUTING.md`](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) (org `.github`) | contributeurs | flux git, règles de PR, politique sur les secrets |
| [`docs/user-guide.md`](/docs/argvus-boot-splash/) | utilisateurs finaux | installation, utilisation, dépannage |
| [`docs/developer-guide.md`](/docs/argvus-boot-splash/developer-guide/) | développeurs | interne des thèmes, emballage, CI |
