---
title: Schermata di avvio ARGVUS
description: Tema Plymouth e guida all'installazione per l'ambiente desktop ARGVUS
---

# Schermata di Avvio ARGVUS

Lo splash di avvio di Argvus è un tema [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/)] per l'ecosistema desktop Argvus. È ciò che si vede tra l'accensione del computer e il momento in cui inizia la sessione grafica.

## Documentazione

Questa documentazione è organizzata in due sezioni principali:

### Guida per l'Utente
Guide all'installazione e all'uso per utenti finali e amministratori di sistema.

| Guide | Contenuti |
| --- | --- |
| [Installazione](/docs/argvus-boot-splash/installation/) | Requisiti, le tre opzioni di installazione, cosa fanno gli hook del pacchetto |
| [Utilizzo](/docs/argvus-boot-splash/usage/) | Verificare l'installazione, anteprima senza riavviare, cambiare o ripristinare i temi, cheat sheet dei comandi |
| [UKI e splash di systemd-boot](/docs/argvus-boot-splash/uki-splash/) | Uso di `argvus-uki-splash.bmp` in un flusso di avvio UKI |
| [Disinstallazione](/docs/argvus-boot-splash/uninstallation/) | Rimozione del pacchetto e ripristino del tema precedente |
| [Risoluzione dei problemi](/docs/argvus-boot-splash/troubleshooting/) | Sintomi comuni e loro cause |
| [Riferimento](/docs/argvus-boot-splash/reference/) | File installati, metadata del pacchetto, valori dei colori |

### [Guida per sviluppatori](/docs/argvus-boot-splash/developer-guide/)
Documentazione tecnica per contribuenti e manutentori.

- [Architettura](/docs/argvus-boot-splash/developer-guide/theme/) — Descrittore Plymouth, modello di rendering e personalizzazione
- [Confezionamento](/docs/argvus-boot-splash/developer-guide/packaging/) — Pipeline di build e ricette dei pacchetti
- [CI e Rilasci](/docs/argvus-boot-splash/developer-guide/ci-releases/) — Validazione, test e flusso di lavoro per il rilascio

## Avvio Rapido

Per sistemi basati su Arch:

```sh
sudo pacman -S argvus-boot-splash   # or: sudo pacman -U ./argvus-boot-splash-<version>-1-any.pkg.tar.zst
```
L'installer imposta il tema come predefinito e rigenera automaticamente il tuo initramfs.

---

- **Repository:** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **Licenza:** GPL-3.0-only
- **Segnalazioni di bug:** [GitHub Issues](https://github.com/argvus/argvus-boot-splash/issues)
