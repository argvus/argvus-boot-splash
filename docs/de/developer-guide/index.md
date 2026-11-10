---
title: Entwicklerhandbuch
description: Architektur- und Entwicklungshinweise für ARGVUS-Beitragende.
---
# Argvus Boot Splash — Entwicklerhandbuch

Technische Dokumentation für das `argvus-boot-splash`-Repository: wie das Plymouth-Theme zusammengestellt wird, wie das Arch-Paket gebaut wird und wie Versionen signiert und veröffentlicht werden.

Es gibt hier keinen Kompilierungsschritt — das Theme ist Daten (ein `.plymouth`-Deskriptor, ein `.script` und Bilder) plus ein Arch-Paket-Rezept. „Bauen“ bedeutet, ein reproduzierbares Paket zu erzeugen:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```
Bevor Sie eine Änderung übergeben: `make validate && make build`, und neue technische Begriffe zu `.cspell/custom-dictionary-workspace.txt` hinzufügen, sonst schlägt der Rechtschreibprüfungsjob fehl.

Wenn Sie nur das *Theme* verwenden möchten, lesen Sie den [Benutzerleitfaden](/docs/argvus-boot-splash/). Für die prozessorientierte Entsprechung dieser Datei (git flow, Geheimnisse, Release-Prozess) siehe [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) und [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).

## Anleitungen

| Leitfaden | Inhalt |
| --- | --- |
| [Themenarchitektur](/docs/argvus-boot-splash/developer-guide/theme/) | Descriptor, Rendering-Modell, Asset-Inventar, Skript-Durchgang, Layout-Konstanten, Design-Tokens, UKI-Bitmap, wie man das Theme verändert |
| [Packaging](/docs/argvus-boot-splash/developer-guide/packaging/) | Die beiden PKGBUILDs, geteiltes `functions.sh`, Installations-Hooks, lokale Build-Pipeline, Make-Ziele, Voraussetzungen |
| [CI und Releases](/docs/argvus-boot-splash/developer-guide/ci-releases/) | `validate.sh`, `ci.yml`, `release.yml` Schritt für Schritt, Checksummen, Signierung, Secrets, Veröffentlichung und Versionierung |
| [Konventionen und bekannte Lücken](/docs/argvus-boot-splash/developer-guide/workflow/) | Hausregeln, Dokumentationsübersicht und Inkonsistenzen, die bei der Prüfung des Repositories gefunden wurden |

## Schnellreferenz

| Pfad | Was es ist |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | Theme-Payload installiert unter `/usr` |
| `packaging/arch/{ci,local}/PKGBUILD` | Release- und lokale Paket-Rezepte |
| `packaging/arch/common/functions.sh` | Geteilte `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | Deterministisches Tarball + `makepkg`-Treiber |
| `tools/sh/validate.sh` | Erforderliches Validierungstor |
| `.github/workflows/` | `ci.yml` (validieren, bauen, Rechtschreibprüfung), `release.yml` (Tags `v*`) |

## Sonstiges

- Repository-Wurzel: [README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
- Benutzerhandbuch: [Benutzerhandbuch](/docs/argvus-boot-splash/)
- Entwicklungsprozess: [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
- Beiträge: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
- Sicherheitsrichtlinie: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
- Lizenz: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
- Portugiesische Version: [Guia do desenvolvedor](/pt/docs/argvus-boot-splash/developer-guide/)
