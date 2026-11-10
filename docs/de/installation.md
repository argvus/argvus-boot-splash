---
title: Installation
description: Anforderungen, Installationsoptionen und was die Paket-Hooks tun.
---

# Installation

Alles, was Sie benötigen, um den Argvus-Boot-Splash auf einem Arch-basierten System zu erhalten.

Wie das Theme aussieht und was es enthält, siehe die
[Referenz](/docs/argvus-boot-splash/reference/). Um es stattdessen aus dem Quellcode neu zu erstellen, siehe die
[Entwickleranleitung](/docs/argvus-boot-splash/developer-guide/).

## Anforderungen

- Ein Arch-basiertes System, das `plymouth` verwendet (das Paket ist davon abhängig).
- Ein initramfs-Generator: **mkinitcpio** (Arch-Standard) oder **dracut**. Der Installer erkennt, welches vorhanden ist, und erstellt das initramfs für Sie neu.
- Plymouth muss in Ihrer initramfs-Konfiguration aktiviert sein. Bei mkinitcpio stellen Sie sicher, dass `plymouth` in der `HOOKS`-Liste von `/etc/mkinitcpio.conf` ist:

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```
Starten Sie neu, wenn Sie dies gerade geändert haben.

- Für eine normale grafische Sitzung ist nichts erforderlich; das Thema wird nur im Boot-Pfad ausgeführt.

## Option 1: offizielles Paket-Repository (empfohlen)

Die signierten Pakete werden im Argvus-Paket-Repository veröffentlicht
(`argvus/packages`, Pfad `public/arch/$arch`). Fügen Sie es zu `/etc/pacman.conf` hinzu:

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```
Ersetzen Sie `<PACKAGES_REPO_BASE_URL>` durch den Host, auf dem das Projekt das Repository veröffentlicht (GitHub, GitLab oder Gitea). Importieren Sie zuerst den Repository-Signaturschlüssel, sonst verweigert `pacman` den Download:

```sh
# 1. import the project's public signing key into your pacman keyring
pacman-key --add /path/to/argvus-signing-key.asc
pacman-key --lsign <key-id>

# 2. refresh and install
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```
## Option 2: Paketdatei veröffentlichen

Jede markierte Veröffentlichung publiziert eine `.pkg.tar.zst` (plus ihre `.sig`) als Veröffentlichungs-Asset. Installieren Sie sie direkt:

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
Wenn Ihnen die Sauberkeit der Lieferkette wichtig ist, überprüfen Sie die abgelegte Signatur gegen den öffentlichen Schlüssel des Projekts, bevor Sie sie installieren:

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
## Option 3: manuelle Installation

Nützlich auf Nicht-Arch-Systemen oder wenn Sie das Thema einfach nur ausprobieren möchten, ohne es zu verpacken. Kopieren Sie das Themenverzeichnis in den Themenpfad von Plymouth:

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# or: sudo mkinitcpio -P        # Arch
# or: sudo dracut --regenerate-all
```
Plymouth kann auch in `/etc/default/grub` mit `GRUB_CMDLINE_LINUX` aktiviert werden, das `splash` enthält, und `quiet` gibt das klassische Minimal-Boot-Gefühl.

## Was der Installer macht

Nach der Installation oder dem Upgrade laufen die Paket-Hooks automatisch:

1. `plymouth-set-default-theme argvus` — schreibt `argvus` in `/etc/plymouth/plymouthd.conf`.
2. `mkinitcpio -P`, wenn mkinitcpio existiert, andernfalls `dracut --regenerate-all`.

Wenn kein Generator gefunden wird, zeigt der Installer eine Warnung an und Sie müssen das initramfs selbst neu erstellen. Ein Themenwechsel wird nur beim Boot sichtbar, nachdem das initramfs neu generiert wurde — ein Neustart ohne diesen Schritt ist der mit Abstand häufigste Grund dafür, dass „der Splash nicht geändert wurde“.

Beim Entfernen gibt das Paket nur eine Erinnerung aus: Das Auswählen eines anderen Themas und das Neuaufbauen des initramfs bleibt Ihnen überlassen. Siehe [Deinstallation](/docs/argvus-boot-splash/uninstallation/)].

## Nächste Schritte

- [Usage](/docs/argvus-boot-splash/usage/) — Überprüfen Sie die Installation, Vorschau ohne Neustart, Themen wechseln.
- [UKI und systemd-boot splash](/docs/argvus-boot-splash/uki-splash/) — Verwenden Sie das Bitmap in einem UKI.
- [Fehlerbehebung](/docs/argvus-boot-splash/troubleshooting/) — falls sich das Splash nicht geändert hat.
