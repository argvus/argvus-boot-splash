---
title: Uso
description: Verifica l'installazione, visualizza in anteprima senza riavviare e cambia tema.
---

# Uso

Come verificare il tema, visualizzarlo in anteprima senza riavviare e passare a un altro.
Per l'installazione, vedere [installation](/docs/argvus-boot-splash/installation/).

## Verifica dell'installazione

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```
## Anteprima senza riavviare

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```
L'anteprima potrebbe richiedere l'autenticazione polkit quando eseguita come utente normale. La barra di avanzamento procede con il progresso simulato; puoi anche forzare gli stati:

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```
Mentre lo splash è attivo, premi <kbd>Esc</kbd> per passare alla schermata successiva (splash → dettagli → splash).

## Cosa mostra lo splash

| Fase | Aspetto |
| --- | --- |
| Avvio | Tutto svanisce progressivamente in ~1 secondo: logo, marchio, barra di avanzamento |
| Avvio sistema | La barra si riempie da sinistra mentre Plymouth segnala l'avanzamento |
| Volume crittografato | Lo splash si attenua al 15%, il testo del prompt e i puntini mascherati appaiono sotto la barra |
| Passphrase accettata | La finestra di dialogo scompare, lo splash ritorna a piena opacità |

## Modificare o ripristinare il tema

```sh
# switch theme (any theme name under /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# then regenerate the initramfs
sudo mkinitcpio -P              # or: sudo dracut --regenerate-all
```
File di configurazione utili:

| File | Scopo |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` scritto dal pacchetto |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` deve includere `plymouth` |
| `/etc/plymouth/plymouthd.conf` (di nuovo) | `PLYMOUTH_TOGGLE_KEY` ecc. sono globali, non per tema |

## Tabella dei comandi rapida

| Comando | Effetto |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | rendere `argvus` il tema predefinito |
| `sudo plymouth-update-theme` | applicare la modifica al Plymouth attualmente in esecuzione |
| `sudo plymouth --show-splash` | mostrare lo splash nella sessione corrente |
| `sudo plymouth --show-details` | mostrare invece messaggi di avvio dettagliati |
| `sudo plymouthquit` | uscire da Plymouth e ripristinare la sessione |
| `sudo mkinitcpio -P` | ricostruire l'initramfs di Arch |
| `sudo dracut --regenerate-all` | ricostruire l'initramfs con dracut |

## Passaggi successivi

- [UKI e schermata di avvio systemd-boot](/docs/argvus-boot-splash/uki-splash/)
- [Disinstallazione](/docs/argvus-boot-splash/uninstallation/)
- [Risoluzione dei problemi](/docs/argvus-boot-splash/troubleshooting/)
