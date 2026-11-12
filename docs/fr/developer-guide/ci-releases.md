---
title: CI et Versions
description: Validation, intégration continue, signature et flux de travail de publication.
---
# CI et releases

La passerelle de validation, les jobs d'intégration continue, le pipeline de release et
les règles de versioning.

Pour le package lui-même, voir [packaging](/docs/argvus-boot-splash/developer-guide/packaging/) ; pour le thème, voir
[architecture du thème](/docs/argvus-boot-splash/developer-guide/theme/).

## Validation

`tools/sh/validate.sh` est la passerelle requise :

- nécessite `bash`, `makepkg`, `shellcheck` ;
- `shellcheck` + `bash -n` sur `tools/sh/*.sh` et `packaging/arch/common/*.sh` ;
- récupère à la fois les PKGBUILDs et compare les métadonnées extraites — remote et local doivent correspondre ;
- `makepkg -p PKGBUILD --printsrcinfo` à l'intérieur de `ci/` et `local/` (analyse le fichier comme le fait makepkg) ;
- `git diff --check` (espaces/marqueurs de conflit).

## Intégration continue

`.github/workflows/ci.yml` (push/PR vers `main`, conteneur `archlinux:latest`) :

1. installer `base-devel git namcap pacman-contrib shellcheck sudo` ;
2. `make validate` ;
3. Build en tant qu’utilisateur `builder` **non privilégié**.
   (`sudo -u builder env HOME=/home/builder make build`) — makepkg refuse de s’exécuter
   en tant que racine, et l’espace de travail est `chown` en premier ;
4. Un travail `spellcheck` séparé fonctionne `cspell-action@v6` avec `cspell.json`.

`namcap` s’enchaîne à l’intérieur de `pkgbuild_local.sh` une fois installé, donc les constructions locales apparaissent
la même peluche que le CI. La configuration du correcteur orthographique est `cspell.json` avec l’espace de travail
Dictionnaire en `.cspell/custom-dictionary-workspace.txt` — Nouveaux termes techniques
(drapeaux de coque, noms d’outils) doivent être dans ce dictionnaire, sinon le CI échoue.

## Pipeline de sortie

`.github/workflows/release.yml` — déclencheurs : pousser une étiquette `v*`, ou
`workflow_dispatch` avec un tag existant (reconstruction contrôlée). Groupe de concurrence
`release-<ref>`, pas d’annulation.

Étapes :

1. **Vérifier** le tag (le dispatch utilise `inputs.tag`).
2. **Étape de version** : valide le tag contre `^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$`, échoue si `url` est vide dans `packaging/arch/remote/PKGBUILD`, puis réécrit `pkgver` à partir du tag.
3. **Valider** : `make validate`.
4. **Construire** en tant que `builder` non privilégié : `updpkgsums` (résout et valide le véritable `sha256sums`) puis `makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`.
   Localise le `.pkg.tar.zst` et échoue si aucun n'existe.
5. **namcap** sur le paquet.
6. **Signer** : importe `GPG_PRIVATE_KEY` dans un `GNUPGHOME` temporaire (`mktemp -d`, mode 700), vérifie que la clé secrète importée correspond à `GPG_KEY_ID` (ID court ou empreinte), et crée un `.sig` détaché avec `--pinentry-mode loopback --passphrase-fd 0`.
7. **Vérifier la signature** dans un `GNUPGHOME` frais — la version échoue si la signature ne se vérifie pas.
8. **Téléverser l'artefact** (`upload-artifact@v4`, `retention-days: 1`, paquet +)
   signature, `if-no-files-found: error`).
9. **Publier** : vérifiez `argvus/packages` avec `PACKAGES_REPO_TOKEN`, copiez le
   paquet et `.sig` dans `public/arch/x86_64`, exécutez
   `repo-add -R argvus.db.tar.gz <pkg>`, signez `argvus.db.tar.gz`,
   `argvus.files.tar.gz`, `argvus.db` et `argvus.files`, puis validez comme
   `github-actions[bot]` et poussez. Un diff sans changement retourne 0 sans valider.
10. **Publication GitHub** : `softprops/action-gh-release@v2` avec les notes générées
    et le paquet + signature comme ressources.

## Sommes de contrôle, signature et secrets

- Il n'existe pas de `SKIP` : `sha256sums` est toujours un vrai digest, calculé au moment de la construction
  (localement) ou via `updpkgsums` (CI de publication).
- Gardez `sha256sums=()` **vide** dans le dépôt.
- Les publications sont signées GPG (paquet `.sig`, `argvus.db.tar.gz`,
  `argvus.files.tar.gz`, `argvus.db`, `argvus.files`).
- `GPG_PASSPHRASE` doit être non vide ; le workflow rejette une phrase de passe vide.

Préparez la clé :

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```
Dans **Paramètres → Secrets et variables → Actions** du dépôt :

| Secret | Valeur |
| --- | --- |
| `GPG_PRIVATE_KEY` | sortie `gpg --armor --export-secret-keys KEY_ID` |
| `GPG_KEY_ID` | ID de clé ou empreinte attendue |
| `GPG_PASSPHRASE` | phrase secrète non vide de la clé de signature |
| `PACKAGES_REPO_TOKEN` | PAT avec `contents:write` sur `argvus/packages` |

## Publier une version

Avant de taguer :

1. Remplissez `url` dans `packaging/arch/remote/PKGBUILD` avec le véritable dépôt :
   - GitHub : `url="https://github.com/argvus/argvus-boot-splash"` (la source utilise `${url}/archive/refs/tags/v${pkgver}.tar.gz`) ;
   - GitLab : ajustez `source=` à `https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz` ;
   - sans `url`, la publication **échoue volontairement** avec un message clair.
2. Synchronisez les versions/métadonnées dans `packaging/arch/local/PKGBUILD` et `packaging/arch/remote/PKGBUILD`.
3. Taggez et poussez :

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```
Le flux de travail peut également être démarré manuellement avec une balise `v*` existante comme balise
   Entrée `tag`, utile pour une reconstruction contrôlée.

## Gestion des versions

- SemVer dans `pkgver`, nombre de versions dans `pkgrel`.

## Dépannage du développeur

**La version échoue lors de la « Récupération des sources ».** `url` vide, balise `v*` manquante ou un
format d'URL d'archive qui ne correspond pas à l'hôte (archive tar GitHub vs GitLab
mise en page). Le workflow valide le modèle de balise et échoue très tôt sur une page vide.
`url`.

**`updpkgsums` ne trouve pas la source.** La balise doit exister et être poussée avant
le travail de publication s'exécute ; la répartition avec une balise qui n'existe que localement échoue ici.

**`make validate` signale que « les métadonnées PKGBUILD distantes et locales sont désynchronisées ».**
Copiez les champs de métadonnées (et non `source=`) d'un PKGBUILD à l'autre.

**La vérification orthographique échoue pour un nouveau terme.** Ajoutez-le à
`.cspell/custom-dictionary-workspace.txt` (le dictionnaire `argvus`, `addWords :
true`), not to `ignorePaths`.

**`sudo` demandé à l'intérieur de `make install` ou `libfakeroot.so … LD_PRELOAD` erreurs.** Un `package()` qui se lance vers `make install` au lieu d'utiliser `install -Dm*`. Les deux PKGBUILD appellent `arch_package_splash_payload`, ce qui ne le fait pas ; assurez-vous que personne n'a réintroduit un appel `make`.

**`makepkg` refuse de s'exécuter.** Il ne doit pas être exécuté en tant que root. Exécutez la construction en tant qu'utilisateur normal, ou `sudo -u <user> make build`.

**Le package s'installe mais l'écran de démarrage reste inchangé.** L'initramfs n'a pas été reconstruit. Pour les tests locaux, appelez `sudo plymouth --show-splash` au lieu de redémarrer, ou reconstruisez avec `sudo mkinitcpio -P` / `sudo dracut --regenerate-all`.
