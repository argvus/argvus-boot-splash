---
title: Verwendung
description: Überprüfen Sie die Installation, sehen Sie eine Vorschau ohne Neustart und wechseln Sie die Themen.
---

# Verwendung

Wie man das Thema überprüft, es ohne Neustart vorschaut und zu einem anderen wechselt.
Für die Installation siehe [installation](/docs/argvus-boot-splash/installation/)].

## Überprüfung der Installation

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```
## Vorschau ohne Neustart

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```
Die Vorschau kann nach einer polkit-Authentifizierung fragen, wenn sie als normaler Benutzer ausgeführt wird. Die Fortschrittsanzeige bewegt sich mit dem simulierten Fortschritt; Sie können auch Zustände erzwingen:

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```
Während der Splash angezeigt wird, drücke <kbd>Esc</kbd>, um zum nächsten Bildschirm zu wechseln (Splash → Details → Splash).

## Was der Splash zeigt

| Phase | Darstellung |
| --- | --- |
| Start | Alles blendet in ~1 Sekunde ein: Logo, Schriftzug, Fortschrittsanzeige |
| Booten | Die Leiste füllt sich von links, während Plymouth den Fortschritt meldet |
| Verschlüsseltes Volume | Splash wird auf 15 % gedimmt, Eingabeaufforderung und maskierte Punkte erscheinen unter der Leiste |
| Passphrase akzeptiert | Dialog verschwindet, Splash kehrt in volle Deckkraft zurück |

## Ändern oder Zurücksetzen des Themas

```sh
# switch theme (any theme name under /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# then regenerate the initramfs
sudo mkinitcpio -P              # or: sudo dracut --regenerate-all
```
Nützliche Konfigurationsdateien:

| Datei | Zweck |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` vom Paket geschrieben |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` muss `plymouth` enthalten |
| `/etc/plymouth/plymouthd.conf` (nochmals) | `PLYMOUTH_TOGGLE_KEY` usw. sind global, nicht pro Theme |

## Befehle Spickzettel

| Befehl | Wirkung |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | mache `argvus` zum Standard-Theme |
| `sudo plymouth-update-theme` | wende die Änderung auf das laufende Plymouth an |
| `sudo plymouth --show-splash` | zeige den Splash im aktuellen Sitzung |
| `sudo plymouth --show-details` | zeige stattdessen ausführliche Bootmeldungen |
| `sudo plymouthquit` | verlasse Plymouth und stelle deine Sitzung wieder her |
| `sudo mkinitcpio -P` | rebuild das Arch initramfs |
| `sudo dracut --regenerate-all` | rebuild das initramfs mit dracut |

## Nächste Schritte

- [UKI und systemd-boot splash](/docs/argvus-boot-splash/uki-splash/)
- [Deinstallation](/docs/argvus-boot-splash/uninstallation/)
- [Fehlerbehebung](/docs/argvus-boot-splash/troubleshooting/)
