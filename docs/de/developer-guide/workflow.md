---
title: Konventionen und bekannte Lücken
description: Hausregeln, Dokumentationskarte und Feststellungen der Repository-Prüfung.
---

# Konventionen und bekannte Lücken

Hausregeln für Änderungen in diesem Repository, sowie die beim
Audit festgestellten Inkonsistenzen – es lohnt sich, diese zu beheben, anstatt sie zu kopieren.

Für die technische Referenz siehe [Themenarchitektur](/docs/argvus-boot-splash/developer-guide/theme/),
[Packaging](/docs/argvus-boot-splash/developer-guide/packaging/) und [CI und Releases](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Konventionen

- Shell: `set -euo pipefail`, Tabs zur Einrückung, `printf`/`error`-Nachrichten an stderr, `command -v`-Fähigkeitsprüfungen, Shellcheck sauber (siehe `.editorconfig`).
- Niemals `sha256sums=('SKIP')` schreiben; `sha256sums=()` im Git leer lassen.
- Keine Build-Ergebnisse (`build/`), Paketdateien oder generierte `.PKGBUILD.local.*`-Kopien committen.
- Konventionelle Commits mit den in der Historie verwendeten Scopes: `splash`, `layout`, `pkgbuild`, `release`, `chore`, `ci`, `build`, `docs`.
- Branch-Namen: `feat/…`, `fix/…`, `docs/…`, `chore/…`, `refactor/…`.
- Eine Freigabe durch einen Reviewer vor dem Merge, Squash-Merge.
- Lizenz: GPL-3.0-only. Ausgeliefert als `/usr/share/licenses/argvus-boot-splash/LICENSE`.
- Befolgen Sie den Prozess in [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) und [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md).

## Bekannte Lücken

Dokumentierte Unstimmigkeiten, die bei der Überprüfung des Repositories gefunden wurden:

- `README.md` bewirbt `make test` für eine direkte Plymouth-Vorschau, aber ein solches Ziel existiert nicht in der [Makefile](https://github.com/argvus/argvus-boot-splash/blob/main/Makefile). Die tatsächlichen Befehle sind `sudo plymouth --show-splash` / `sudo plymouthquit`.
- `entry-line.png` und `logo-glow.png` werden im Payload mitgeliefert und werden von `arch_check_splash_payload()` benötigt, aber `argvus.script` lädt sie nie. Entweder verbinden Sie sie mit dem Skript oder entfernen Sie sie aus dem Payload und der Checkliste.
- `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` ist installiert, wird aber nie bei irgendetwas registriert; der [Benutzerleitfaden](/docs/argvus-boot-splash/uki-splash/) dokumentiert den manuellen `bootctl`/`ukify`-Schritt.
- Die kanonischen Dokumente befinden sich im Root-Verzeichnis des Repositories (`README.md`, `DEVELOPMENT.md`) und überschneiden sich mit den Anleitungen in `docs/`. Halten Sie sie konsistent
  beim Ändern von beidem. Beitragsrichtlinien (`CONTRIBUTING.md`, `SECURITY.md`) befinden sich im Repository der Organisation `.github`.

## Dokumentationsübersicht

| Dokument | Zielgruppe | Umfang |
| --- | --- | --- |
| `README.md` | alle | ein einleitender Absatz und Layout |
| `DEVELOPMENT.md` | Maintainer | Aufbau, Signierung, Freigabeprozess |
| [`CONTRIBUTING.md`](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) (org `.github`) | Mitwirkende | Git-Workflow, PR-Regeln, Geheimnisrichtlinie |
| [`docs/user-guide.md`](/docs/argvus-boot-splash/) | Endanwender | Installation, Nutzung, Fehlerbehebung |
| [`docs/developer-guide.md`](/docs/argvus-boot-splash/developer-guide/) | Entwickler | Thema-Innereien, Verpackung, CI |
