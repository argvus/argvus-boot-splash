---
title: Risoluzione dei problemi
description: Sintomi comuni della schermata di avvio e come risolverli.
---
# Risoluzione dei problemi

**Lo splash non è cambiato dopo l'installazione.**
L'initramfs non è stato rigenerato. Esegui `sudo mkinitcpio -P` (o `sudo dracut --regenerate-all`) e riavvia. Se il tuo sistema utilizza più kernel, assicurati che quello con cui avvii abbia il nuovo initramfs.

**Nessuno splash; lo schermo è nero o mostra solo testo.**
`plymouth` manca dai hook dell'initramfs. Controlla `/etc/mkinitcpio.conf`
`HOOKS=(...)` contiene `plymouth`, poi ricostruisci e riavvia. Su Ubuntu/Debian, conferma anche che `plymouth` e `plymouth-x11`/`plymouth-themes` siano installati e che `GRUB_CMDLINE_LINUX` abbia `splash quiet`.

**Solo il logo, nessun progresso.**
Alcuni passaggi di avvio non sono riportati dal tuo init, oppure il callback del progresso non viene mai chiamato — nulla è rotto dalla tua parte. La barra si riempie in base al progresso riportato da Plymouth, che in alcune configurazioni è assente (ad esempio con le sequenze di systemd senza `plymouth-spawn` o certi moduli dracut).

**Il prompt della password è posizionato male o invisibile.**
La finestra di dialogo è posizionata rispetto al marchio e alla geometria del tracciato, quindi risoluzioni estreme (modalità testo molto piccola) possono spingerla fuori dallo schermo. Usa una risoluzione normale e segnalalo se accade a risoluzioni comuni.

**Plymouth si chiude presto / vedi la console di testo invece.**
Qualcosa ha disabilitato Plymouth: il parametro di avvio `quiet` senza `splash`, un hook `plymouth` rimosso, o un driver che Plymouth non può usare. Plymouth esce sulla console di testo invece di bloccare la macchina: questo è un comportamento previsto.

**Il tema non viene applicato dopo l'aggiornamento da `argvus-plymouth`.**
Il nuovo pacchetto sostituisce quello vecchio; verifica che `/etc/plymouth/plymouthd.conf` dica `PLYMOUTH_THEME_NAME=argvus` e ricostruisci l’initramfs.

**L’installazione fallisce durante la verifica della firma.**
La chiave del repository manca o è obsoleta nel tuo portachiavi. Reimporta la chiave pubblica corrente, poi `sudo pacman -Sy`.

**Schermata di blocco / sospensione sembra invariata.** 
Il tema copre solo l'avvio. Le schermate di ibernazione/ripresa sono controllate separatamente
(`systemd-homed`, schermi armadietti, `plymouth` uso nel bersaglio di sonno del tuo
initramfs). 

**Una Plymouth vagante è ancora in corso dopo un'anteprima.** 
`sudo plymouthquit` ripristina la sessione. Se lo schermo rimane nero, passa a
Un altro terminale virtuale (`Ctrl+Alt+F2`) — la tua sessione è intatta. 

## Prossimi passi

- [Installation](/docs/argvus-boot-splash/installation/) — riprova con un metodo diverso. 
- [Usage](/docs/argvus-boot-splash/usage/) — scheda di consigli dei comandi.
