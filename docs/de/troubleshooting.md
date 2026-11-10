---
title: Fehlerbehebung
description: Häufige Symptome beim Systemstart-Bildschirm und wie man sie behebt.
---
# Fehlerbehebung

**Der Splash hat sich nach der Installation nicht geändert.**
Das Initramfs wurde nicht neu generiert. Führen Sie `sudo mkinitcpio -P` (oder `sudo dracut --regenerate-all`) aus und starten Sie neu. Wenn Ihr System mehrere Kernel verwendet, stellen Sie sicher, dass der gebootete Kernel das neue Initramfs erhalten hat.

**Kein Splash; der Bildschirm ist schwarz oder zeigt nur Text.**
`plymouth` fehlt in den Initramfs-Hooks. Überprüfen Sie `/etc/mkinitcpio.conf`. `HOOKS=(...)` enthält `plymouth`, dann neu aufbauen und neu starten. Unter Ubuntu/Debian bestätigen Sie auch, dass `plymouth` und `plymouth-x11`/`plymouth-themes` installiert sind und dass `GRUB_CMDLINE_LINUX` `splash quiet` enthält.

**Nur das Logo, kein Fortschritt.**
Einige Boot-Schritte werden von Ihrem Init nicht gemeldet oder der Fortschritts-Callback wird nie aufgerufen — auf Ihrer Seite ist nichts kaputt. Die Leiste füllt sich basierend auf dem von Plymouth gemeldeten Fortschritt, der in einigen Setups fehlt (zum Beispiel bei systemd's `plymouth-spawn`-losen Sequenzen oder bestimmten Dracut-Modulen).

**Die Passwortabfrage ist falsch positioniert oder unsichtbar.**
Der Dialog wird relativ zum Logo und zur Spurgeometrie positioniert, daher kann eine extreme
Auflösung (sehr kleiner Textmodus) ihn vom Bildschirm verschieben. Verwenden Sie eine normale
Auflösung und melden Sie es, falls dies bei gängigen Auflösungen auftritt.

**Plymouth beendet sich früh / Sie sehen stattdessen die Textkonsole.**
Etwas hat Plymouth deaktiviert: der `quiet` Boot-Parameter ohne `splash`, ein
`plymouth` Hook wurde entfernt oder ein Treiber, den Plymouth nicht verwenden kann. Plymouth
wechselt in die Textkonsole, anstatt das System einzufrieren – dies ist erwartetes Verhalten.

**Das Theme wird nach dem Upgrade von `argvus-plymouth` nicht angewendet.**
Das neue Paket ersetzt das alte; prüfen Sie, ob `/etc/plymouth/plymouthd.conf` `PLYMOUTH_THEME_NAME=argvus` sagt
und erstellen Sie das initramfs neu.

**Installation schlägt bei der Signaturprüfung fehl.**
Der Repository-Schlüssel fehlt oder ist in Ihrem Schlüsselring veraltet. Importieren Sie den aktuellen
öffentlichen Schlüssel erneut und dann `sudo pacman -Sy`.

**Sperrbildschirm / Ruhezustand sieht unverändert aus.**
Das Thema deckt nur den Start ab. Ruhezustands-/Resume-Bildschirme werden separat gesteuert (`systemd-homed`, Bildschirmsperren, `plymouth` Verwendung im Sleep-Target Ihres initramfs).

**Ein einzelnes Plymouth läuft noch nach einer Vorschau.**
`sudo plymouthquit` stellt Ihre Sitzung wieder her. Wenn der Bildschirm schwarz bleibt, wechseln Sie zu einer anderen virtuellen Konsole (`Ctrl+Alt+F2`) — Ihre Sitzung bleibt erhalten.

## Nächste Schritte

- [Installation](/docs/argvus-boot-splash/installation/) — erneut mit einer anderen Methode versuchen.
- [Verwendung](/docs/argvus-boot-splash/usage/) — Befehlsübersicht.
