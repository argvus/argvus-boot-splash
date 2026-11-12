---
title: Verpackung
description: Arch-Paket-Metadaten, Build-Pipeline und Make-Ziele.
---

# Verpackung

Wie das Arch-Paket definiert und hergestellt wird: die beiden PKGBUILDs, die gemeinsamen Funktionen, die Installations-Hooks, die lokale Build-Pipeline und die Make-Ziele.

Für das Thema selbst siehe [Themenarchitektur](/docs/argvus-boot-splash/developer-guide/theme/); für Validierung, CI und Releases siehe [CI und Releases](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Zwei PKGBUILDs, ein Payload

`packaging/arch/remote/PKGBUILD` und `packaging/arch/local/PKGBUILD` sind identisch, außer für `source=`:

| | `local` | `ci` |
| --- | --- | --- |
| Quelle | `${pkgname}-${pkgver}.tar.gz` (erstellt von `make build`) | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| verwendet von | Entwicklern, `make build` | GitHub Actions Release |

Beide rufen dieselben Funktionen von `packaging/arch/common/functions.sh` auf, und `tools/sh/validate.sh` überprüft, dass ihre Metadaten (`pkgname`, `pkgver`, `pkgrel`, `pkgdesc`, `arch`, `license`, `depends`, `makedepends`, `options`) identisch sind, sodass die beiden nicht stillschweigend abweichen können.

Gemeinsame Metadaten:

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
## Gemeinsame Funktionen

`packaging/arch/common/functions.sh` stellt drei Funktionen bereit, die von beiden PKGBUILDs verwendet werden:

- `arch_normalize_source_tree` (`prepare()`) — GitHub-Tag-Archive werden nach `<repo>-v<version>` extrahiert, während das lokale Tarball nach `<pkgname>-<pkgver>` extrahiert wird. Dies benennt das einzelne oberste Verzeichnis in `${srcdir}/${pkgname}-${pkgver}` um und gibt einen Fehler aus, wenn das Quellverzeichnis fehlt, mehrdeutig ist oder das Ziel bereits existiert.
- `arch_check_splash_payload` (`check()`) — prüft, dass jede Theme-Ressource im extrahierten Quellverzeichnis vorhanden ist. Dies ist die einzige „Testsuite“ des Pakets; die Liste der erforderlichen Dateien befindet sich im [Asset-Inventar](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory).
- `arch_package_splash_payload` (`package()`) — durchläuft `src/usr` mit `find -print0` und installiert jede Datei mit `install -Dm644` nach `$pkgdir` (NUL-sicher, funktioniert mit Leerzeichen in Namen), anschließend wird `LICENSE` nach `/usr/share/licenses/argvus-boot-splash/LICENSE` installiert.

Beachten Sie, dass es keinen `make install`-Aufruf innerhalb von `package()` gibt: alles ist `install -Dm*`, sodass das Paket eigenständig und rootless-build-freundlich ist. Das ist absichtlich — ein altes `package()`, das `make install` aufrief, verursachte `sudo`/`libfakeroot.so`-Fehler.

## Installations-Hooks

`packaging/arch/{ci,local}/argvus-boot-splash.install` (identisch):

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`, dann `mkinitcpio -P`, falls verfügbar, sonst `dracut --regenerate-all`, andernfalls eine Warnung, die den Benutzer auffordert, neu zu bauen.
- `post_remove()` → nur Informationsmeldung; das Theme wird nicht automatisch zurückgesetzt (sicherer als zu raten).

## Lokale Build-Pipeline

`tools/sh/pkgbuild_local.sh` (aufgerufen von `make build`):

1. Überprüft `makepkg`, `sha256sum`, `tar`, `awk`, `find` und dass die PKGBUILD existiert; bezieht die PKGBUILD, um `pkgname`/`pkgver` zu lesen und validiert beides
   gegen Allow-List-Regexes (`^[a-z0-9@._+-]+$` für den Namen, ein gepunktetes Muster für die Version).
2. Baut `build/artifacts/${pkgname}-${pkgver}.tar.gz` mit
   `tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner`
   und `--transform "s#^\./#${pkgname}-${pkgver}/#"` — ein deterministisches, reproduzierbares Archiv. Es schließt `.git`, `build/`, `dist/`, `target/`, `tools/`, `release`/`packages-repo` Scratch-Verzeichnisse und alle `src/`, `pkg/` oder Paketreste innerhalb der Verpackungsverzeichnisse aus.
3. Berechnet `sha256` des Archivs und injiziert es mit `sed` in eine **temporäre Kopie** des lokalen PKGBUILD (`.PKGBUILD.local.XXXXXX`, entfernt durch einen `EXIT`-Trap). Das Repository hält `sha256sums=()` immer leer; `SKIP` wird nie verwendet.
4. Löscht alle vorhandenen `${pkgname}-${pkgver}-*.pkg.tar.zst` von
   `build/dist/`, damit ein veraltetes Paket nicht mit diesem Build verwechselt werden kann.
5. Führt ` with ` with `/`/` in ` in build/artifacts/ aus und `PKGDEST` in `build/dist/`. Zusätzliche Argumente werden an `makepkg` weitergeleitet; `MAKEPKG_FLAGS` überschreibt die standardmäßige Flagsammlung (bewusst Wortteilung).
6. Schlägt fehl, wenn nicht genau ein `.pkg.tar.zst` übereinstimmt, und führt dann `namcap` darauf aus, falls installiert.

Ausgaben:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```
## Make-Ziele

| Ziel | Effekt |
| --- | --- |
| `make build` (Alias `make package`) | `tools/sh/pkgbuild_local.sh` → `build/` ausführen |
| `make install` (Alias `make install-package`) | `sudo pacman -U` das einzelne Paket in `build/dist/`; Fehler, wenn die Anzahl nicht genau 1 ist |
| `make validate` | `tools/sh/validate.sh`: shellcheck + `bash -n` + PKGBUILD-Metadaten-Synchronisation + `makepkg --printsrcinfo` pro PKGBUILD + `git diff --check` |
| `make lint` (Alias `make lint-shell`) | shellcheck über `tools`, `packaging/arch/common`, `src` (`SC1090`, `SC2034`, `SC2154` deaktiviert), `bash -n`, `git diff --check` |
| `make spellcheck` | `cspell --config cspell.json .`, wenn `cspell` installiert ist, ansonsten übersprungen |
| `make clean` | `rm -rf build/` |
| `make help` | Zielliste (Standardziel) |

CI führt `make validate` und `make build` aus; nichts in CI führt `make install` aus
(siehe [bekannte Lücken](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)).

## Voraussetzungen

Ein Arch-basiertes System mit `make`, `git`, `gnupg` und der `base-devel` Gruppe:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```
- `pacman-contrib` stellt `updpkgsums` bereit (regeneriert PKGBUILD-Prüfsummen).
- `shellcheck` prüft die Repository-Shell-Skripte und die gemeinsam genutzten Arch-Paketierungsfunktionen.
- Optional: `namcap` (Paket-Linting) und cspell (lokale Rechtschreibprüfung). CI installiert alle davon.
