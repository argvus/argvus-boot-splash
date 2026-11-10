---
title: Referenz
description: Installierte Dateien, Paket-Metadaten und Farbwerte.
---

# Referenz

Technische Referenz dafür, was das Paket installiert und welche Werte es verwendet.

## Was Sie bekommen

| Komponente | Beschreibung |
| --- | --- |
| Argvus-Logo | Zentriertes Zeichen, über dem Schriftzug dargestellt |
| Schriftzug | `ARGVUS` Text unter dem Logo |
| Fortschrittsbalken | Dünner Balken, dessen Breite den Bootfortschritt von Plymouth widerspiegelt |
| Passwortdialog | LUKS-Eingabeaufforderung mit einem maskierten Eingabefeld (`•` Punkte) |
| Einblenden | Der Splash-Bildschirm blendet beim Start von Plymouth über ~1 Sekunde ein |
| UKI-Bitmap | `argvus-uki-splash.bmp` für UKI / systemd-boot basierte Boots |

Der Paketname ist `argvus-boot-splash` und es ersetzt das ältere `argvus-plymouth` Paket, wenn Sie es installiert hatten.

## Installierte Dateien

Unter `/usr/share/plymouth/themes/argvus/`:

| Datei | Größe | Zweck |
| --- | --- | --- |
| `argvus.plymouth` | — | Theme-Beschreiber (Name, Beschreibung, Modul) |
| `argvus.script` | — | Das Theme-Skript (Plymouths eigene Skriptsprache) |
| `argvus-logo.png` | 256x256 | Logo, RGBA |
| `argvus-text.png` | 400x53 | Markenwort, RGBA |
| `progress-bar.png` | 400x4 | Gefüllter Teil der Fortschrittsleiste |
| `progress-bar-track.png` | 400x4 | Ungefüllte Spur |
| `entry-box.png` | 400x48 | Passwort-Eingabefeld |
| `entry-line.png` | 300x2 | Passwortfeld-Regel/Unterstrich |
| `bullet.png` | 12x12 | Maskiertes Zeichen |
| `logo-glow.png` | 260x300 | Logo-Glühkunstwerk |
| `argvus-uki-splash.bmp` | 400x400, 32-Bit | UKI/systemd-boot Splash-Bitmap |

Plus die Lizenz bei `/usr/share/licenses/argvus-boot-splash/LICENSE`.

## Paket-Metadaten

| Feld | Wert |
| --- | --- |
| Name | `argvus-boot-splash` |
| Architektur | `any` |
| Abhängigkeiten | `plymouth` |
| Optionale Abhängigkeiten | `mkinitcpio`, `dracut` |
| Konflikte / ersetzt | `argvus-plymouth` |
| Lizenz | GPL-3.0-only |

## Farben

| Element | Farbe |
| --- | --- |
| Hintergrund | `#111316` |
| Akzent (Logo, Wortmarke, Fortschrittsanzeige) | `#3590BD` |
| Fortschrittsleiste | `#262933` |
| Passwortaufforderung Text | hellgrau-blau (`#B8C4CE`) |

Das Theme verwendet bei jeder Auflösung einen einfarbig dunklen Hintergrund, sodass es niemals automatisch zwischen hellen und dunklen Varianten wechselt.

## Hilfe erhalten

- Melden Sie Fehler und fordern Sie Funktionen im Issue-Tracker des Projekts an.
- Sicherheitsprobleme: folgen Sie [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) — öffnen Sie kein öffentliches Issue für Sicherheitslücken.
- Quellcode, Builds und Releases: das Repository-Stammverzeichnis ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)).
- Beitrag leisten: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).
- Lizenz: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE).

## Nächste Schritte

- [Installation](/docs/argvus-boot-splash/installation/)
- [Verwendung](/docs/argvus-boot-splash/usage/)
- [Fehlerbehebung](/docs/argvus-boot-splash/troubleshooting/)
