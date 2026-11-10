---
title: Convenzioni e Lacune Note
description: Regole della casa, mappa della documentazione e risultati della verifica del repository.
---

# Convenzioni e lacune conosciute

Regole interne per le modifiche in questo repository, oltre alle incoerenze rilevate durante
la sua revisione — vale la pena correggerle piuttosto che copiarle.

Per il riferimento tecnico vedere [architettura del tema](/docs/argvus-boot-splash/developer-guide/theme/),
[packaging](/docs/argvus-boot-splash/developer-guide/packaging/) e [CI e rilasci](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Convenzioni

- Shell: `set -euo pipefail`, tabulazioni per l'indentazione, messaggi `printf`/`error` verso stderr, controlli delle capacità `command -v`, shellcheck pulito (vedi `.editorconfig`).  
- Non scrivere mai `sha256sums=('SKIP')`; mantenere `sha256sums=()` vuoto in git.  
- Non commettere i risultati della build (`build/`), i file dei pacchetti o le copie generate `.PKGBUILD.local.*`.  
- Commit convenzionali con gli ambiti usati dalla cronologia: `splash`, `layout`, `pkgbuild`, `release`, `chore`, `ci`, `build`, `docs`.  
- Nomenclatura dei rami: `feat/…`, `fix/…`, `docs/…`, `chore/…`, `refactor/…`.  
- Approvazione di un revisore prima del merge, merge con squash.  
- Licenza: GPL-3.0-only. Distribuito come `/usr/share/licenses/argvus-boot-splash/LICENSE`.  
- Seguire il processo in [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) e [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md).  

## Lacune note

Incoerenze documentate trovate durante l'audit del repository:

- `README.md` pubblicizza `make test` per un'anteprima diretta di Plymouth, ma nessun tale obiettivo esiste nel [Makefile](https://github.com/argvus/argvus-boot-splash/blob/main/Makefile). I comandi reali sono `sudo plymouth --show-splash` / `sudo plymouthquit`.
- `entry-line.png` e `logo-glow.png` vengono forniti nel payload e sono richiesti da `arch_check_splash_payload()`, ma `argvus.script` non li carica mai. O integrateli nello script o rimuoveteli dal payload e dalla lista di controllo.
- `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` è installato ma mai registrato con nulla; la [guida utente](/docs/argvus-boot-splash/uki-splash/) documenta il passaggio manuale `bootctl`/`ukify`.
- I documenti canonici si trovano nella radice del repository (`README.md`, `DEVELOPMENT.md`) e si sovrappongono alle guide in `docs/`. Manteneteli coerenti
  quando si modificano uno qualsiasi. Le politiche di contributo (`CONTRIBUTING.md`, `SECURITY.md`) vivono nel repository dell'organizzazione `.github`.

## Mappa della documentazione

| Documento | Pubblico | Ambito |
| --- | --- | --- |
| `README.md` | tutti | panoramica e layout in un paragrafo |
| `DEVELOPMENT.md` | manutentori | costruzione, firma, processo di rilascio |
| [`CONTRIBUTING.md`](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) (org `.github`) | contribuenti | flusso git, regole PR, politica dei segreti |
| [`docs/user-guide.md`](/docs/argvus-boot-splash/) | utenti finali | installazione, utilizzo, risoluzione dei problemi |
| [`docs/developer-guide.md`](/docs/argvus-boot-splash/developer-guide/) | sviluppatori | internals del tema, packaging, CI |
