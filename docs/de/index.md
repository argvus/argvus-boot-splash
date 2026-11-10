---
title: ARGVUS Boot Splash
description: Plymouth-Thema und Installationsanleitung für die ARGVUS-Desktop-Umgebung
---

# ARGVUS Boot-Splash

Der Argvus Boot-Splash ist ein [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/)-Theme für das Argvus-Desktop-Ökosystem. Es ist das, was Sie sehen zwischen dem Einschalten des Geräts und dem Moment, in dem Ihre grafische Sitzung startet.

## Dokumentation

Diese Dokumentation ist in zwei Hauptabschnitte gegliedert:

### Benutzerhandbuch
Installations- und Nutzungshinweise für Endbenutzer und Systemadministratoren.

| Leitfaden | Inhalt |
| --- | --- |
| [Installation](/docs/argvus-boot-splash/installation/) | Anforderungen, die drei Installationsoptionen, was die Paket-Hooks bewirken |
| [Verwendung](/docs/argvus-boot-splash/usage/) | Installation überprüfen, Vorschau ohne Neustart, Themes wechseln oder zurücksetzen, Befehlsübersicht |
| [UKI- und systemd-boot-Splash](/docs/argvus-boot-splash/uki-splash/) | Verwendung von `argvus-uki-splash.bmp` in einem UKI-Bootablauf |
| [Deinstallation](/docs/argvus-boot-splash/uninstallation/) | Paket entfernen und das vorherige Theme wiederherstellen |
| [Fehlerbehebung](/docs/argvus-boot-splash/troubleshooting/) | Häufige Symptome und deren Ursachen |
| [Referenz](/docs/argvus-boot-splash/reference/) | Installierte Dateien, Paket-Metadaten, Farbwerte |

### [Entwicklerleitfaden](/docs/argvus-boot-splash/developer-guide/)
Technische Dokumentation für Mitwirkende und Maintainer.

- [Thema Architektur](/docs/argvus-boot-splash/developer-guide/theme/) — Plymouth-Beschreiber, Rendering-Modell und Anpassung
- [Verpackung](/docs/argvus-boot-splash/developer-guide/packaging/) — Build-Pipeline und Paketrezepturen
- [CI und Releases](/docs/argvus-boot-splash/developer-guide/ci-releases/) — Validierungs-, Test- und Release-Workflow

## Schneller Start

Für Arch-basierte Systeme:

```sh
sudo pacman -S argvus-boot-splash   # or: sudo pacman -U ./argvus-boot-splash-<version>-1-any.pkg.tar.zst
```
Der Installer setzt das Theme als Standard und erzeugt Ihr Initramfs automatisch neu.

---

- **Repository:** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **Lizenz:** GPL-3.0-only
- **Fehlerberichte:** [GitHub Issues](https://github.com/argvus/argvus-boot-splash/issues)
