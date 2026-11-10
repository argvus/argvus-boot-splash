---
title: Confezionamento
description: Metadati del pacchetto Arch, pipeline di compilazione e obiettivi Make.
---
# Confezione

Come viene definito e prodotto il pacchetto Arch: i due PKGBUILD, il condiviso
funzioni, i hook di installazione, la pipeline di build locale e i target di Make. 

Per il tema stesso vedi [theme architecture](/docs/argvus-boot-splash/developer-guide/theme/); per la validazione, CI e
rilasci vedi [CI e releases](/docs/argvus-boot-splash/developer-guide/ci-releases/). 

## Due PKGBUILD, un carico utile

`packaging/arch/remote/PKGBUILD` e `packaging/arch/local/PKGBUILD` sono identiche
Tranne `source=`: 

| | `local` | `ci` |
| --- | --- | --- |
| Fonte | `${pkgname}-${pkgver}.tar.gz` (costruito da `make build`) | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| Usato da | sviluppatori, `make build` | GitHub Azioni rilascio |

Entrambi chiamano le stesse funzioni da `packaging/arch/common/functions.sh`, e `tools/sh/validate.sh` asserisce che i loro metadati (`pkgname`, `pkgver`, `pkgrel`, `pkgdesc`, `arch`, `license`, `depends`, `makedepends`, `options`) siano identici, quindi i due non possono deviare silenziosamente.

Metadati condivisi:

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
## Funzioni condivise

`packaging/arch/common/functions.sh` fornisce tre funzioni utilizzate da entrambi i PKGBUILD:

- `arch_normalize_source_tree` (`prepare()`) — gli archivi dei tag di GitHub vengono estratti in `<repo>-v<version>`, mentre il pacchetto locale viene estratto in `<pkgname>-<pkgver>`. Questo rinomina la singola directory di livello superiore in `${srcdir}/${pkgname}-${pkgver}`, generando un errore se la directory di origine è mancante, ambigua o se la destinazione esiste già.
- `arch_check_splash_payload` (`check()`) — verifica che ogni risorsa del tema esista nella sorgente estratta. Questo è l'unico “test suite” del pacchetto; l'elenco dei file richiesti si trova nell'[inventario delle risorse](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory).
- `arch_package_splash_payload` (`package()`) — attraversa `src/usr` con `find -print0` e installa ogni file con `install -Dm644` in `$pkgdir` (compatibile con NUL, funziona con spazi nei nomi), quindi installa `LICENSE` in `/usr/share/licenses/argvus-boot-splash/LICENSE`.

Nota che non c'è alcuna chiamata `make install` all'interno di `package()`: tutto è `install -Dm*`, quindi il pacchetto è autosufficiente e compatibile con build rootless. Questo è intenzionale — un vecchio `package()` che chiamava `make install` produceva errori `sudo`/`libfakeroot.so`.

## Installazione dei hook

`packaging/arch/{ci,local}/argvus-boot-splash.install` (identico):

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`, poi `mkinitcpio -P` se disponibile, altrimenti `dracut --regenerate-all`, altrimenti un avviso che informa l'utente di ricostruire manualmente.
- `post_remove()` → solo messaggio informativo; il tema non viene ripristinato automaticamente (più sicuro che indovinare).

## Pipeline di build locale

`tools/sh/pkgbuild_local.sh` (invocato da `make build`):

1. Verifica `makepkg`, `sha256sum`, `tar`, `awk`, `find` e che il PKGBUILD esista; importa il PKGBUILD per leggere `pkgname`/`pkgver` e valida entrambi
   contro le regex della lista consentita (`^[a-z0-9@._+-]+$` per il nome, un modello con punti per la versione).
2. Costruisce `build/artifacts/${pkgname}-${pkgver}.tar.gz` con
   `tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner`
   e `--transform "s#^\./#${pkgname}-${pkgver}/#"` — un archivio deterministico,
   riproducibile. Esclude `.git`, `build/`, `dist/`, `target/`,
   `tools/`, `release`/`packages-repo` directory temporanee e qualsiasi `src/`, `pkg/` o
   avanzamento dei pacchetti all'interno delle directory di packaging.
3. Calcola `sha256` dell'archivio e lo inietta con `sed` in una **copia temporanea** del PKGBUILD locale (`.PKGBUILD.local.XXXXXX`, rimossa da un trappola `EXIT`). Il repository mantiene sempre `sha256sums=()` vuoto; `SKIP` non viene mai usato.
4. Elimina qualsiasi `${pkgname}-${pkgver}-*.pkg.tar.zst` preesistente da
   `build/dist/` in modo che un pacchetto obsoleto non possa essere scambiato per questa build.
5. Esegue ` with ` with `/`/` in ` in build/artifacts/ e `PKGDEST` in `build/dist/`. Eventuali argomenti extra vengono inoltrati a `makepkg`; `MAKEPKG_FLAGS` sovrascrive l'insieme di flag predefinito (divisione delle parole intenzionale). 6. Fallisce a meno che non ci sia esattamente un `.pkg.tar.zst` corrispondente, quindi lo esegue su `namcap` se installato.

Output:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```
## Obiettivi di Make

| Obiettivo | Effetto |
| --- | --- |
| `make build` (alias `make package`) | esegue `tools/sh/pkgbuild_local.sh` → `build/` |
| `make install` (alias `make install-package`) | `sudo pacman -U` il singolo pacchetto in `build/dist/`; genera errori se il conteggio non è esattamente 1 |
| `make validate` | `tools/sh/validate.sh`: shellcheck + `bash -n` + sincronizzazione metadati PKGBUILD + `makepkg --printsrcinfo` per PKGBUILD + `git diff --check` |
| `make lint` (alias `make lint-shell`) | shellcheck su `tools`, `packaging/arch/common`, `src` (`SC1090`, `SC2034`, `SC2154` disabilitati), `bash -n`, `git diff --check` |
| `make spellcheck` | `cspell --config cspell.json .` se `cspell` è installato, altrimenti saltato |
| `make clean` | `rm -rf build/` |
| `make help` | lista degli obiettivi (obiettivo predefinito) |

CI esegue `make validate` e `make build`; nulla in CI esegue `make install`
(vedi [known gaps](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)).

## Prerequisiti

Un sistema basato su Arch con `make`, `git`, `gnupg` e il gruppo `base-devel`:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```
- `pacman-contrib` fornisce `updpkgsums` (rigenera i checksum di PKGBUILD).
- `shellcheck` valida gli script shell del repository e le funzioni condivise del packaging di Arch.
- Facoltativo: `namcap` (controllo del pacchetto) e cspell (controllo ortografico locale). Il CI installa tutti loro.
