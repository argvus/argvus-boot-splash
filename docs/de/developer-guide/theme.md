---
title: Themenarchitektur
description: Wie der Plymouth-Deskriptor, die Assets und das Skript zusammengefügt werden.
---

# Themenarchitektur

Wie das Plymouth-Thema aufgebaut ist: der Deskriptor, das Asset-Set und was `argvus.script` Abschnitt für Abschnitt macht.

Für Verpackung und Releases siehe [packaging](/docs/argvus-boot-splash/developer-guide/packaging/) und [CI und Releases](/docs/argvus-boot-splash/developer-guide/ci-releases/). Für die Nutzung siehe den [Benutzerhandbuch](/docs/argvus-boot-splash/).

## Deskriptor

Plymouth-Themen sind deklarative Deskriptoren, die von der Skript-Engine von Plymouth interpretiert werden. Es gibt zwei Teile:

`src/usr/share/plymouth/themes/argvus/argvus.plymouth`:

```ini
[Plymouth Theme]
Name=Argvus
Description=Argvus boot splash theme
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/argvus
ScriptFile=/usr/share/plymouth/themes/argvus/argvus.script
```
Notizen:

- `ModuleName=script` wählt den integrierten Skript-Interpreter von Plymouth aus. Es gibt kein
  kompiliertes Modul; `ImageDir` und `ScriptFile` müssen **absolute Pfade** sein,
  da das initramfs ein anderes Arbeitsverzeichnis als Ihre Sitzung hat.
- Der Dateiname ist der Name des Themes: `argvus.plymouth` ⇒ Theme `argvus`, das ist
  das, was `plymouth-set-default-theme argvus` auswählt.
- `argvus.script` ist die einzige Code-Datei. Sie läuft innerhalb der eingebetteten VM von Plymouth
  (verlinkt in `plymouthd` und das initramfs). Daraus folgende Einschränkungen: keine Datei-I/O, keine Threads, keine externen Prozesse, kein Fließkomma,
  `MathInt` ist Ihre einzige Arithmetik, und die Sprache ist ein kleiner C-ähnlicher Dialekt
  (Arrays sind key-basierte Objekte, `Sprite()` Objekte müssen vor der Verwendung erstellt werden).

## Rendering-Modell

- Ein einheitlicher Hintergrund (`Window.SetBackgroundTopColor` / `SetBackgroundBottomColor`).
- **Sprites** sind die einzigen Zeichenprimitive. Jeder `Sprite()` hat ein Bild, eine `(x, y)`-Position, eine **z-Reihenfolge** und eine Deckkraft in `[0, 1]`. Später ruft `SetPosition` win auf; es gibt keinen Szenengraphen.
- Der Fortschritt wird gezeichnet, indem ein Bild in jedem Frame erneut `ImageScale` wird und `SetImage` auf dem Sprite aufgerufen wird — es gibt kein Clipping oder ein Teil-Zeichenprimitive.
- Plymouth meldet den Status über die Callbacks, die das Skript registriert:
  `PlymouthSetBootProgressFunction`, `PlymouthSetDisplayPasswordFunction`,
  `PlymouthSetDisplayNormalFunction`, `PlymouthSetRefreshFunction`.
- `Plymouth.SetRefreshRate(20)` sorgt dafür, dass der Refresh-Callback mit 20 FPS ausgeführt wird; die einzige zeitgesteuerte Animation des Themes (das Einblenden) hängt davon ab.

## Asset-Inventar

Alle Assets befinden sich in `src/usr/share/plymouth/themes/argvus/`.

| Datei | Größe | Format | Rolle | Verwendet von `argvus.script` |
| --- | --- | --- | --- | --- |
| `argvus.plymouth` | — | INI | Themenbeschreibung | geladen von `plymouthd` |
| `argvus.script` | — | Plymouth-Skript | Themenlogik | ja |
| `argvus-logo.png` | 256x256 | RGBA 8-Bit | Hauptlogo | ja (`logo.base_scale = 0.72`) |
| `argvus-text.png` | 400x53 | RGBA 8-Bit | `ARGVUS` Wortmarke | ja (`text.scale = 0.80`) |
| `progress-bar.png` | 400x4 | 1-Bit-Palette | gefüllte Leiste | ja |
| `progress-bar-track.png` | 400x4 | 1-Bit-Palette | ungefüllte Spur | ja |
| `entry-box.png` | 400x48 | RGB 16-Bit | Passwort-Eingabefeld | ja |
| `bullet.png` | 12x12 | 4-Bit-Palette | ein maskiertes Zeichen | ja |
| `entry-line.png` | 300x2 | 1-Bit-Palette | Eingaberegel/Unterstreichen | nein (siehe [bekannte Lücken](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `logo-glow.png` | 260x300 | 8-Bit-Palette | Logo-Glühkunst | nein (siehe [bekannte Lücken](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `argvus-uki-splash.bmp` | 400x400 | BMP 32-Bit | UKI / systemd-boot Splash | nein (vom Bootloader verwendet) |

Die Bildbreite wird als Layouteinheit verwendet: Das Wortzeichen ist die Referenzbreite
(400 px bei Skalierung 1.0) und die Fortschrittsspur, die Fortschrittsleiste und das Passwortfeld
werden alle davon abgeleitet, sodass die Komposition kohärent bleibt, wenn das
Wortzeichen-Asset erneut exportiert wird.

`arch_check_splash_payload()` in `packaging/arch/common/functions.sh` erfordert,
dass **alle** oben genannten Dateien vorhanden sind; das Hinzufügen eines Assets bedeutet, es zu dieser Liste hinzuzufügen. Siehe
[packaging](/docs/argvus-boot-splash/developer-guide/packaging/#shared-functions).

## Skript-Durchlauf

`src/usr/share/plymouth/themes/argvus/argvus.script`, von oben nach unten.

### 1. Hintergrund

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```
Gleicher Wert oben und unten ⇒ eine flache Füllung, kein Verlauf. Die Komponenten sind die 8-Bit-Kanäle von `#111316` geteilt durch 255.

### 2. Assets und Skalierung

Jedes Bild wird über `Image("name")` geladen, das relativ zu `ImageDir` aufgelöst wird. Die Skalierung ist explizit:

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```
Der `logo.frame[...]`-Cache ist beabsichtigt: `ImageScale` bei jedem Frame würde für jedes Frame ein neues Bild erzeugen; das Logo wird einmal skaliert und nach Zielbreite zwischengespeichert, sodass eine Größenänderung nur einen neuen Eintrag erfordert.

Das Wortzeichen folgt derselben Idee bei `text.scale = 0.80`, wird jedoch einmal inline skaliert. Fortschrittsanzeige und Balken werden dann auf `text.image.GetWidth()` skaliert – d. h. der Balken entspricht immer der Breite des Wortzeichens, egal wie groß die tatsächliche Pixelgröße des Wortzeichens ist.

### 3. Layout

Jedes Element ist auf der horizontalen Achse des Fensters zentriert:

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```
Beachten Sie `- 35`: Der Stapel ist auf die gesamte Komposition zentriert (Logo + Schriftzug + Fortschrittsleiste), nicht nur auf das Logo, sodass der Block leicht oberhalb der vertikalen Bildschirmmitte positioniert ist. Die vertikale Platzierung erfolgt dann relativ zum vorherigen Element (`text.y = logo.y + logo.image.GetHeight() + 16`, `progress_track.y = text.y + text.image.GetHeight() + 28`, …), was bedeutet, dass die Komposition als eine Einheit mit der Auflösung skaliert.

Verwendete Z-Reihenfolge:

| Z | Sprite |
| --- | --- |
| 100 | Logo, Schriftzug, Fortschrittsleiste |
| 101 | Fortschrittsbalken (über der Leiste) |
| 200 | Passwort-Eingabefeld |
| 201 | Passwort-Aufforderungstext |
| 202 | Passwort-Punkte |

### 4. Boot-Fortschritt

```js
fun progress_callback(duration, progress)
{
    width = MathInt(progress_bar.original_image.GetWidth() * progress);
    if (width < 1) width = 1;
    if (width > progress_bar.original_image.GetWidth())
        width = progress_bar.original_image.GetWidth();
    progress_bar.image = ImageScale(progress_bar.original_image, width,
                                     progress_bar.original_image.GetHeight());
    progress_bar.sprite.SetImage(progress_bar.image);
}
```
Registriert bei `PlymouthSetBootProgressFunction(progress_callback)`. Die Klammer ist wichtig: Ein Bild mit null Breite ist in einigen Plymouth-Versionen ungültig, sodass die Leiste nie vollständig verschwindet und der Fortschritt die Breite der Spur niemals überschreiten kann.
Die Sprite-Position ist fest; nur die Bildbreite ändert sich – keine Füll- oder Clip-Operation wird verwendet.

### 5. Passwortdialog

`display_password_callback(prompt, bullets)`:

1. Dimmt den Splash: `logo.opacity = 0.15` und Wortmarke bei `0.15`, während die Spur und Leiste bei `1.0` bleiben.
2. Rendert das Eingabefeld mit `Image.Text(prompt, 0.72, 0.77, 0.81)` — das einzige zur Laufzeit generierte Bild im Theme. Seine Position ist nur hier bekannt, da sie von der Texthöhe abhängt.
3. Positioniert das Eingabefeld unterhalb des Prompts: password.entry.y = password.prompt.y + password.prompt.image.GetHeight() + 14. Zur Ladezeit ist `password.entry.y` `0` mit einem Kommentar, dass die echte Position auf den Prompt wartet.
4. Zeichnet Aufzählungspunkte mit einer Erstellen-oder-Wiederverwenden-Schleife:

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* create sprite + image */ }
       /* ...position at entry.x + 16 + index * bullet.width ... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```
Sprites werden gepoolt und über verschiedene Eingabeaufforderungen hinweg wiederverwendet, anstatt neu erstellt zu werden; veraltete Kugeln werden mit der Opazität `0` ausgeblendet. Kugeln sind vertikal zentriert zur Höhe des Eingabefeldes.

`display_normal_callback()` ist das Gegenteil: es stellt die Opazität `1.0` wieder her, blendet die Eingabeaufforderung, das Eingabefeld und jede gepoolte Kugel aus. Registriert mit `PlymouthSetDisplayNormalFunction` ruft Plymouth es auf, wenn das Passwort akzeptiert oder abgebrochen wird und der Bootvorgang fortgesetzt wird.

Folge: `logo.opacity` ist eine Variable, keine Konstante, da sowohl das Ausblenden als auch der Passwortzustand in sie einfließen.

### 6. Einblenden

```js
Plymouth.SetRefreshRate(20);
fun refresh_callback()
{
    if (!fade.complete) {
        fade.frame += 1;
        fade.opacity = fade.frame / 20;      /* 20 frames @ 20 FPS = 1s */
        if (fade.opacity > 1) fade.opacity = 1;
        text.sprite.SetOpacity(fade.opacity);
        progress_track.sprite.SetOpacity(fade.opacity);
        progress_bar.sprite.SetOpacity(fade.opacity);
        if (fade.frame >= 20) fade.complete = 1;
    }
    logo.sprite.SetOpacity(logo.opacity * fade.opacity);
}
```
Der Refresh-Callback läuft während des gesamten Bootvorgangs weiter (er ist günstig und Plymouth ruft ihn kontinuierlich auf); die `fade.complete`-Schutzmaßnahme macht ihn nach der Animation zu einer No-Op. Das Logo verwendet `logo.opacity * fade.opacity` statt einer einfachen Zuweisung, damit der durch das Passwort gedimmte Zustand die Ausblendung überlebt: Nachdem die Ausblendung abgeschlossen ist, zeigen `fade.opacity == 1` und das Logo `logo.opacity` wieder an.

Frühere Versionen dieses Themas hatten ebenfalls Pulse-/Spawn-Animationen; sie wurden in `0.2.0` („chore: remove pulse effects“) entfernt. Bitte führen Sie keine Frame-für-Frame-Animation der Fortschrittsleiste wieder ein — die Leiste muss eine treue Darstellung des Boot-Fortschritts bleiben.

## Layout-Konstanten

Einzige Wahrheit für die Abstimmung der Komposition:

| Konstante | Wert | Bedeutung |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | Logo-Skalierung im Vergleich zu seinem nativen 256x256 |
| `logo.y` Offset | `-35` | hebt den zentrierten Block über die Bildschirmmitte |
| `text.scale` | `0.80` | Wortmarke-Skalierung im Vergleich zu ihrer nativen 400x53 |
| `text.y` Abstand | `+16` | Logo-Boden → Wortmarke oben |
| `progress_track.y` Abstand | `+28` | Wortmarke-Boden → Titel oben |
| `password.prompt.y` Abstand | `+24` | Titel-Boden → Aufforderungstext oben |
| `password.entry.y` Abstand | `+14` | Aufforderung-Boden → Eingabefeld oben |
| Aufzählung X Offset | `+16` | linker Rand Eingabe → erste Aufzählung |
| `logo.opacity` (Dialog) | `0.15` | Bildschirm abdunkeln, während eine Passphrase abgefragt wird |
| Eingabefeldfarbe | `0.72, 0.77, 0.81` | `Image.Text` RGB, ~`#B8C4CE` |
| Einblenden | 20 Frames bei 20 FPS | ~1 s Einblenden |

## Design-Token

| Token | Hex | Wo es lebt |
| --- | --- | --- |
| Hintergrund | `#111316` | Skript (`0.0667, 0.0745, 0.0863`) |
| Akzent | `#3590BD` | Logo / Wortmarke / Fortschrittsfüllpixel |
| Fortschrittsanzeige | `#262933` | `progress-bar-track.png` |
| Eingabetext | `#B8C4CE` | Skript (`Image.Text` Aufruf) |

Akzent- und Trackfarben sind in den PNG-Assets eingebrannt, nicht im Skript ausgedrückt, daher bedeutet Neubemalen, die Assets erneut zu exportieren (oder die Farbpalette zu bearbeiten). Das Theme ist nur dunkel und hat keine helle Variante.

## UKI Bitmap-Format

`argvus-uki-splash.bmp` ist ein 400x400, 32-Bit unkomprimiertes Windows BMP (`PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32`). Es ist ein eigenständiges Asset: Das Plymouth-Skript lädt es nie, und das Arch-Paket registriert es auch nirgends — es in ein UKI einzubetten ist der Schritt des Benutzers (siehe den [Benutzerleitfaden](/docs/argvus-boot-splash/uki-splash/)).

Wenn Sie es ersetzen, halten Sie es als einfaches, unkomprimiertes 32-Bit-BMP von vergleichbarer Größe; systemd-boot und `ukify` skalieren keine beliebigen Formate, und große Bilder verbrauchen beim frühen Booten viel Speicher.

## Ändern des Themas

Praktische Vorgehensweise:

1. Bearbeiten Sie `src/usr/share/plymouth/themes/argvus/argvus.script` (und/oder die PNGs).
2. Installieren Sie es in Ihrem Live-Plymouth oder sehen Sie es aus dem Quellbaum vorab an:

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # check, then: sudo plymouthquit
   ```

3. `make validate && make build` vor dem Commit durchführen.

Regeln, die das Theme funktionsfähig halten:

- Nie nicht-Plymouth-APIs einführen. Die Engine ist ein eingeschränktes Dialekt; prüfen Sie die Zielversion von `plymouth`, die Sie unterstützen, bevor Sie eine API verwenden, die Sie zuvor noch nicht benutzt haben.
- `ImageDir`/`ScriptFile` in `argvus.plymouth` müssen absolut bleiben und dem installierten Pfad `/usr/share/plymouth/themes/argvus` entsprechen.
- Halten Sie jedes in `arch_check_splash_payload()` aufgelistete Asset synchron mit den Dateien, die in `src/` ausgeliefert werden — das Packaging `check()` läuft in CI.
- Die Breite der Fortschrittsleiste muss eine treue Funktion des gemeldeten Fortschritts bleiben; die Begrenzung auf `[1, track width]` darf nicht entfernt werden.
- Testen Sie den Passphrasen-Dialog, nicht nur den Boot-Splash: Es ist der Zustand, der am wahrscheinlichsten fehlschlägt und den die Benutzer am meisten bemerken.
- Der Refresh-Callback läuft während des gesamten Boots; halten Sie die pro Frame zugewiesene Arbeit nach Möglichkeit frei.
