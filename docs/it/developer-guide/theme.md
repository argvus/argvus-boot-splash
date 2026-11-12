---
title: Tema Architettura
description: Come vengono messi insieme il descrittore di Plymouth, gli asset e lo script.
---

# Architettura del tema

Come è strutturato il tema Plymouth: il descrittore, il set di asset e cosa
fa `argvus.script`, sezione per sezione.

Per il packaging e le release, vedere [packaging](/docs/argvus-boot-splash/developer-guide/packaging/) e
[CI e release](/docs/argvus-boot-splash/developer-guide/ci-releases/). Per l'utilizzo, vedere la
[guida dell'utente](/docs/argvus-boot-splash/).

## Descrittore

I temi Plymouth sono descrittori dichiarativi interpretati dal motore
di script di Plymouth. Ci sono due parti:

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
Note:

- `ModuleName=script` seleziona l'interprete di script integrato di Plymouth. Non esiste un modulo compilato; `ImageDir` e `ScriptFile` devono essere **percorsi assoluti**, perché l'initramfs ha una directory di lavoro diversa dalla tua sessione.
- Il nome del file è il nome del tema: `argvus.plymouth` ⇒ tema `argvus`, che è ciò che `plymouth-set-default-theme argvus` seleziona.
- `argvus.script` è l'unico file di codice. Viene eseguito all'interno della VM incorporata di Plymouth (collegata in `plymouthd` e nell'initramfs). Vincoli che ne derivano: nessuna I/O su file, nessun thread, nessun processo esterno, nessun punto mobile, `MathInt` è la tua unica aritmetica, e il linguaggio è un piccolo dialetto simile al C (gli array sono oggetti indicizzati, gli oggetti `Sprite()` devono essere creati prima dell'uso).

## Modello di rendering

- Uno sfondo solido unico (`Window.SetBackgroundTopColor` / `SetBackgroundBottomColor`).
- **Sprite** sono le uniche primitive di disegno. Ogni `Sprite()` ha un'immagine, una posizione `(x, y)`, un **ordine z** e un'opacità in `[0, 1]`. Successivamente `SetPosition` chiama win; non c'è un grafo della scena.
- Il progresso viene disegnato ri-`ImageScale`-ando un'immagine ogni frame e chiamando `SetImage` sullo sprite — non ci sono primitive di ritaglio o di disegno parziale.
- Plymouth segnala lo stato attraverso callback che lo script registra: `PlymouthSetBootProgressFunction`, `PlymouthSetDisplayPasswordFunction`, `PlymouthSetDisplayNormalFunction`, `PlymouthSetRefreshFunction`.
- `Plymouth.SetRefreshRate(20)` fa eseguire la callback di aggiornamento a 20 FPS; l'unica animazione temporizzata del tema (il fade-in) dipende da essa.

## Inventario degli asset

Tutti gli asset si trovano in `src/usr/share/plymouth/themes/argvus/`.

| File | Dimensione | Formato | Ruolo | Utilizzato da `argvus.script` |
| --- | --- | --- | --- | --- |
| `argvus.plymouth` | — | INI | descrittore del tema | caricato da `plymouthd` |
| `argvus.script` | — | script Plymouth | logica del tema | sì |
| `argvus-logo.png` | 256x256 | RGBA 8-bit | logo principale | sì (`logo.base_scale = 0.72`) |
| `argvus-text.png` | 400x53 | RGBA 8-bit | marchio di parola `ARGVUS` | sì (`text.scale = 0.80`) |
| `progress-bar.png` | 400x4 | palette 1-bit | barra piena | sì |
| `progress-bar-track.png` | 400x4 | palette 1-bit | traccia vuota | sì |
| `entry-box.png` | 400x48 | RGB 16-bit | campo di inserimento password | sì |
| `bullet.png` | 12x12 | palette 4-bit | un carattere mascherato | sì |
| `entry-line.png` | 300x2 | palette 1-bit | regola di inserimento/sottolineatura | no (vedi [gap conosciuti](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `logo-glow.png` | 260x300 | palette 8-bit | grafica bagliore del logo | no (vedi [gap conosciuti](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `argvus-uki-splash.bmp` | 400x400 | BMP a 32-bit | UKI / splash di systemd-boot | no (consumato dal boot loader) |

La larghezza dell'immagine è usata come unità di layout: il marchio è la larghezza di riferimento
(400 px alla scala 1.0) e la traccia di progresso, la barra di progresso e il campo di inserimento della password
sono tutti derivati da essa, quindi la composizione rimane coerente se
l'asset del marchio viene riesportato.

`arch_check_splash_payload()` in `packaging/arch/common/functions.sh` richiede
che **tutti** i file sopra esistano; aggiungere un asset significa aggiungerlo a quella lista. Vedi
[confezione](/docs/argvus-boot-splash/developer-guide/packaging/#shared-functions).

## Panoramica dello script

`src/usr/share/plymouth/themes/argvus/argvus.script`, dall'alto verso il basso.

### 1. Sfondo

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```
Stesso valore in alto e in basso ⇒ un riempimento uniforme, senza gradiente. I componenti sono i canali a 8 bit di `#111316` divisi per 255.

### 2. Risorse e ridimensionamento

Ogni immagine viene caricata tramite `Image("name")`, che risolve relativamente a `ImageDir`. Il ridimensionamento è esplicito:

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```
La cache `logo.frame[...]` è intenzionale: `ImageScale` su ogni frame allocarebbe una nuova immagine per frame; il logo viene scalato una volta e memorizzato nella cache in base alla larghezza di destinazione, quindi un ridimensionamento richiede solo una nuova voce.

Il marchio segue la stessa idea su `text.scale = 0.80`, ma viene scalato una volta in linea. La barra di avanzamento e il tracciato vengono quindi scalati su `text.image.GetWidth()` — cioè la barra corrisponde sempre alla larghezza del marchio, qualunque sia la dimensione reale del marchio in pixel.

### 3. Disposizione

Ogni elemento è centrato sull'asse orizzontale della finestra:

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```
Nota il `- 35`: lo stack è centrato sull'intera composizione (logo + marchio testuale + traccia), non solo sul logo, quindi il blocco si trova leggermente sopra il centro verticale dello schermo. Il posizionamento verticale è quindi relativo all'elemento precedente (`text.y = logo.y + logo.image.GetHeight() + 16`, `progress_track.y = text.y + text.image.GetHeight() + 28`, ...), il che significa che la composizione scala come un'unica unità con la risoluzione.

Ordine Z utilizzato qui:

| Z| Folletto |
| --- | --- |
| 100 | logo, marchio testuale, traccia di progresso |
| 101 | barra di progresso (sopra la traccia) |
| 200 | campo di inserimento password |
| 201 | testo del prompt della password |
| 202 | puntini della password |

### 4. Avanzamento del boot

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
Registrato con `PlymouthSetBootProgressFunction(progress_callback)`. La morsa conta: un'immagine a larghezza zero non è valida in alcune versioni di Plymouth, quindi la barra non scompare mai completamente e il progresso non può mai superare la larghezza della traccia. La posizione dello sprite è fissa; cambia solo la larghezza dell'immagine — non viene utilizzata alcuna operazione di riempimento o ritaglio.

### 5. Finestra di dialogo della password

`display_password_callback(prompt, bullets)`:

1. Diminuisce lo splash: `logo.opacity = 0.15` e marchio a `0.15`, mentre la traccia e la barra rimangono a `1.0`.
2. Visualizza il prompt con `Image.Text(prompt, 0.72, 0.77, 0.81)` — l'unica immagine generata a runtime nel tema. La sua posizione è conosciuta solo qui, perché dipende dall'altezza del testo.
3. Posiziona il campo di inserimento sotto il prompt: password.entry.y = password.prompt.y + password.prompt.image.GetHeight() + 14. Al momento del caricamento `password.entry.y` è `0` con un commento che indica che la posizione reale dipende dal prompt.
4. Disegna i bullet con un ciclo crea-o-riutilizza:

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* create sprite + image */ }
       /* ...position at entry.x + 16 + index * bullet.width ... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```
Gli sprite vengono raggruppati e riutilizzati tra i prompt invece di essere ricreati;
i proiettili vecchi sono nascosti con opacità `0`. I proiettili sono centrati verticalmente
riguardo all'altezza del campo di inserimento.

`display_normal_callback()` è l'inverso: ripristina l'opacità `1.0`, nasconde il
prompt, il campo di inserimento e ogni proiettile raggruppato. Registrato con
`PlymouthSetDisplayNormalFunction`, Plymouth lo chiama quando la parola d'ordine viene
accettata o annullata e l'avvio continua.

Conseguenza: `logo.opacity` è una variabile, non una costante, perché sia il fade
che lo stato della password si moltiplicano in essa.

### 6. Effetto di comparsa

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
Il callback di aggiornamento continua a funzionare per tutto il boot (è economico e Plymouth lo chiama continuamente); la guardia `fade.complete` lo rende un'operazione nulla dopo l'animazione. Il logo utilizza `logo.opacity * fade.opacity` invece di un semplice assegnamento affinché lo stato attenuato dalla password sopravviva al fade: dopo che il fade è completato, `fade.opacity == 1` e il logo mostra nuovamente `logo.opacity`.

Le revisioni precedenti di questo tema avevano anche animazioni pulse/spawn; sono state rimosse in `0.2.0` ("chore: remove pulse effects"). Non reintrodurre l'animazione per frame della barra di progresso — la barra deve rimanere una rappresentazione fedele del progresso di avvio.

## Costanti del layout

Fonte unica di verità per la regolazione della composizione:

| Costante | Valore | Significato |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | scala del logo rispetto alla sua dimensione nativa 256x256 |
| `logo.y` offset | `-35` | solleva il blocco centrato sopra la metà dello schermo |
| `text.scale` | `0.80` | scala della parola-logo rispetto alla sua dimensione nativa 400x53 |
| `text.y` gap | `+16` | fondo del logo → cima della parola-logo |
| `progress_track.y` gap | `+28` | fondo della parola-logo → cima della traccia |
| `password.prompt.y` gap | `+24` | fondo della traccia → cima del testo del prompt |
| `password.entry.y` gap | `+14` | fondo del prompt → cima del campo di inserimento |
| offset x del bullet | `+16` | sinistra dell’inserimento → primo bullet |
| `logo.opacity` (dialogo) | `0.15` | oscuramento dello splash mentre viene richiesta una passphrase |
| colore del prompt | `0.72, 0.77, 0.81` | `Image.Text` RGB, ~`#B8C4CE` |
| dissolvenza | 20 fotogrammi a 20 FPS | ~1 s di dissolvenza in ingresso |

## Token di design

| Token | Esadecimale | Dove si trova |
| --- | --- | --- |
| Sfondo | `#111316` | script (`0.0667, 0.0745, 0.0863`) |
| Accento | `#3590BD` | logo / marchio / pixel di riempimento progresso |
| Traccia progresso | `#262933` | `progress-bar-track.png` |
| Testo prompt | `#B8C4CE` | script (chiamata `Image.Text`) |

I colori di accento e della traccia sono incorporati nelle risorse PNG, non sono espressi nello script, quindi ricolorare significa riesportare le risorse (o modificare la tavolozza).
Il tema è solo scuro e non ha variante chiara.

## Formato bitmap UKI

`argvus-uki-splash.bmp` è un BMP Windows non compresso a 32-bit, 400x400 (`PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32`).
È una risorsa autonoma: lo script Plymouth non lo carica mai, e il pacchetto Arch non lo registra da nessuna parte — incorporarlo in un UKI è un passaggio dell'utente (vedi la [guida utente](/docs/argvus-boot-splash/uki-splash/)).

Se lo sostituisci, mantienilo un BMP semplice non compresso a 32 bit di dimensioni comparabili; systemd-boot e `ukify` non ridimensionano formati arbitrari e le immagini grandi consumano molta memoria all'avvio iniziale.

## Modifica del tema

Ciclo pratico:

1. Modifica `src/usr/share/plymouth/themes/argvus/argvus.script` (e/o i PNG).
2. Installa nel tuo Plymouth live, o visualizza in anteprima dalla directory sorgente:

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # check, then: sudo plymouthquit
   ```

3. `make validate && make build` prima di effettuare il commit.

Regole che mantengono il tema funzionante:

- Non introdurre mai API non Plymouth. Il motore è un dialetto ristretto; verifica
  la versione target di `plymouth` che supporti prima di utilizzare un'API che non
  hai mai usato prima.
- `ImageDir`/`ScriptFile` in `argvus.plymouth` devono rimanere assoluti e devono corrispondere
  al percorso installato `/usr/share/plymouth/themes/argvus`.
- Mantieni ogni asset elencato in `arch_check_splash_payload()` sincronizzato con i
  file inclusi in `src/` — il pacchetto `check()` eseguito in CI.
- La larghezza della barra di avanzamento deve rimanere una funzione fedele del progresso riportato;
  il limite a `[1, track width]` non deve essere rimosso.
- Testa la finestra di dialogo della passphrase, non solo lo splash di avvio: è lo stato più
  probabile da rompere e quello che gli utenti notano di più.
- La callback di aggiornamento viene eseguita per tutto l'avvio; mantieni libera la
  distribuzione del lavoro per frame dove possibile.
