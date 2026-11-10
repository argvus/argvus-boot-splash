---
title: Riferimento
description: File installati, metadati del pacchetto e valori dei colori.
---

# Riferimento

Riferimento tecnico su ciò che il pacchetto installa e quali valori utilizza.

## Cosa ottieni

| Componente | Descrizione |
| --- | --- |
| Logo Argvus | Marchio centrato, disegnato sopra il marchio testuale |
| Marchio testuale | Testo `ARGVUS` sotto il logo |
| Barra di avanzamento | Barra sottile la cui larghezza riflette il progresso di avvio di Plymouth |
| Finestra di dialogo password | Prompt LUKS con un campo di inserimento mascherato (`•` punti) |
| Effetto dissolvenza | Lo splash compare in ~1 secondo quando Plymouth si avvia |
| Bitmappa UKI | `argvus-uki-splash.bmp` per boot basati su UKI / systemd-boot |

Il nome del pacchetto è `argvus-boot-splash` e sostituisce il pacchetto più vecchio
`argvus-plymouth` se era installato.

## File installati

Sotto `/usr/share/plymouth/themes/argvus/`:

| File | Dimensione | Scopo |
| --- | --- | --- |
| `argvus.plymouth` | — | descrittore del tema (nome, descrizione, modulo) |
| `argvus.script` | — | script del tema (linguaggio di scripting proprietario di Plymouth) |
| `argvus-logo.png` | 256x256 | logo, RGBA |
| `argvus-text.png` | 400x53 | marchio testuale, RGBA |
| `progress-bar.png` | 400x4 | parte riempita della barra di avanzamento |
| `progress-bar-track.png` | 400x4 | traccia non riempita |
| `entry-box.png` | 400x48 | campo di inserimento password |
| `entry-line.png` | 300x2 | regola/sottolineatura del campo password |
| `bullet.png` | 12x12 | carattere mascherato |
| `logo-glow.png` | 260x300 | grafica effetto alone del logo |
| `argvus-uki-splash.bmp` | 400x400, 32-bit | bitmap di avvio UKI/systemd-boot |

Più la licenza in `/usr/share/licenses/argvus-boot-splash/LICENSE`.

## Metadati del pacchetto

| Campo | Valore |
| --- | --- |
| Nome | `argvus-boot-splash` |
| Architettura | `any` |
| Dipendenze | `plymouth` |
| Dipendenze opzionali | `mkinitcpio`, `dracut` |
| Conflitti / sostituisce | `argvus-plymouth` |
| Licenza | GPL-3.0-only |

## Colori

| Elemento | Colore |
| --- | --- |
| Sfondo | `#111316` |
| Accento (logo, marchio, riempimento progresso) | `#3590BD` |
| Traccia del progresso | `#262933` |
| Testo della richiesta password | grigio-blu chiaro (`#B8C4CE`) |

Il tema utilizza uno sfondo scuro solido a qualsiasi risoluzione, quindi non
passa mai automaticamente tra varianti chiare e scure.

## Ottenere aiuto

- Segnala bug e richiedi funzionalità nel tracker dei problemi del progetto.
- Problemi di sicurezza: segui [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) — non aprire un problema pubblico per vulnerabilità.
- Codice sorgente, build e release: la radice del repository ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)).
- Contribuisci: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).
- Licenza: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE).

## Passi successivi

- [Installazione](/docs/argvus-boot-splash/installation/)
- [Uso](/docs/argvus-boot-splash/usage/)
- [Risoluzione dei problemi](/docs/argvus-boot-splash/troubleshooting/)
