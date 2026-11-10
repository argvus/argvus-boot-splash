---
title: Guida per sviluppatori
description: Linee guida sull'architettura e sullo sviluppo per i contributori di ARGVUS.
---

# Argvus Boot Splash — Guida per Sviluppatori

Documentazione tecnica per il repository `argvus-boot-splash`: come viene assemblato il tema Plymouth, come viene costruito il pacchetto Arch e come le versioni vengono firmate e pubblicate.

Qui non c'è alcun passaggio di compilazione — il tema è dati (un descrittore `.plymouth`, un `.script` e immagini) più una ricetta per il pacchetto Arch. "Costruire" significa produrre un pacchetto riproducibile:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```
Prima di confermare una modifica: `make validate && make build`, e aggiungi nuovi termini tecnici a `.cspell/custom-dictionary-workspace.txt` o il lavoro di controllo ortografico fallirà.

Se vuoi solo *usare* il tema, leggi la [guida per l'utente](/docs/argvus-boot-splash/). Per la controparte orientata al processo di questo file (git flow, segreti, processo di rilascio) vedi [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) e [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).

## Guide

| Guide | Contenuti |
| --- | --- |
| [Architettura del tema](/docs/argvus-boot-splash/developer-guide/theme/) | Descriptor, modello di rendering, inventario degli asset, walkthrough dello script, costanti di layout, design token, bitmap UKI, come modificare il tema |
| [Packaging](/docs/argvus-boot-splash/developer-guide/packaging/) | I due PKGBUILD, `functions.sh` condiviso, hook di installazione, pipeline di build locale, target di Make, prerequisiti |
| [CI e rilasci](/docs/argvus-boot-splash/developer-guide/ci-releases/) | `validate.sh`, `ci.yml`, `release.yml` passo passo, checksum, firma, segreti, pubblicazione e versionamento |
| [Convenzioni e lacune conosciute](/docs/argvus-boot-splash/developer-guide/workflow/) | Regole interne, mappa della documentazione e incoerenze trovate durante l’audit del repository |

## Riferimento rapido

| Percorso | Cos'è |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | payload del tema installato sotto `/usr` |
| `packaging/arch/{ci,local}/PKGBUILD` | ricette di rilascio e pacchetto locale |
| `packaging/arch/common/functions.sh` | condiviso `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | tarball deterministico + driver `makepkg` |
| `tools/sh/validate.sh` | gate di convalida richiesto |
| `.github/workflows/` | `ci.yml` (valida, costruisci, controllo ortografia), `release.yml` (tag `v*`) |

## Altrove

- Radice del repository: [README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
- Documentazione per gli utenti: [user guide](/docs/argvus-boot-splash/)
- Processo di sviluppo: [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
- Contribuire: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
- Politica di sicurezza: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
- Licenza: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
- Versione portoghese: [Guia do desenvolvedor](/pt/docs/argvus-boot-splash/developer-guide/)
