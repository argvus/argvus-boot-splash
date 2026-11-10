---
title: Installazione
description: Requisiti, opzioni di installazione e cosa fanno i hook del pacchetto.
---

# Installazione

Tutto ciò di cui hai bisogno per ottenere il boot splash Argvus su un sistema basato su Arch.

Per vedere come appare il tema e cosa contiene, consulta il
[reference](/docs/argvus-boot-splash/reference/). Per ricostruirlo dal codice sorgente, consulta invece la
[guida per sviluppatori](/docs/argvus-boot-splash/developer-guide/).

## Requisiti

- Un sistema basato su Arch che utilizza `plymouth` (il pacchetto dipende da esso).
- Un generatore di initramfs: **mkinitcpio** (predefinito di Arch) o **dracut**. L'installatore rileva quello presente e ricostruisce l'initramfs per te.
- Plymouth deve essere abilitato nella configurazione dell'initramfs. Con mkinitcpio, assicurati che `plymouth` sia nella lista `HOOKS` di `/etc/mkinitcpio.conf`:

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```
Riavvia se hai appena cambiato questo.

- Nulla è necessario per una sessione grafica normale; il tema funziona solo nel percorso di avvio.

## Opzione 1: repository dei pacchetti ufficiale (consigliato)

I pacchetti firmati sono pubblicati nel repository dei pacchetti Argvus (`argvus/packages`, percorso `public/arch/$arch`). Aggiungilo a `/etc/pacman.conf`:

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```
Sostituisci `<PACKAGES_REPO_BASE_URL>` con l'host su cui il progetto pubblica il repository (GitHub, GitLab o Gitea). Importa prima la chiave di firma del repository, altrimenti `pacman` rifiuta il download:

```sh
# 1. import the project's public signing key into your pacman keyring
pacman-key --add /path/to/argvus-signing-key.asc
pacman-key --lsign <key-id>

# 2. refresh and install
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```
## Opzione 2: rilasciare il file del pacchetto

Ogni rilascio con tag pubblica un `.pkg.tar.zst` (più il suo `.sig`) come risorsa di rilascio. Installalo direttamente:

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
Se tieni alla sicurezza della catena di approvvigionamento, verifica la firma distaccata rispetto alla chiave pubblica del progetto prima di installare:

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
## Opzione 3: installazione manuale

Utile sui sistemi non Arch, o se vuoi semplicemente provare il tema senza
impacchettarlo. Copia la directory del tema nel percorso dei temi di Plymouth:

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# or: sudo mkinitcpio -P        # Arch
# or: sudo dracut --regenerate-all
```
Plymouth può anche essere abilitato in `/etc/default/grub` con `GRUB_CMDLINE_LINUX` contenente `splash`, e `quiet` fornisce la classica sensazione di avvio minimo.

## Cosa fa l'installer

Dopo l'installazione o l'aggiornamento, gli hook del pacchetto vengono eseguiti automaticamente:

1. `plymouth-set-default-theme argvus` — scrive `argvus` in `/etc/plymouth/plymouthd.conf`.
2. `mkinitcpio -P` se mkinitcpio esiste, altrimenti `dracut --regenerate-all`.

Se nessun generatore viene trovato, l'installer stampa un avviso e devi ricostruire l'initramfs da solo. Un cambio di tema diventa visibile solo all'avvio dopo che l'initramfs è stato rigenerato — riavviare senza questo passaggio è la ragione più comune per cui «lo splash non è cambiato».

Alla rimozione, il pacchetto stampa solo un promemoria: scegliere un tema diverso e ricostruire l'initramfs è lasciato a te. Vedi [disinstallazione](/docs/argvus-boot-splash/uninstallation/)].

## Passaggi successivi

- [Usage](/docs/argvus-boot-splash/usage/) — verifica l'installazione, anteprima senza riavviare, cambia temi.
- [UKI e systemd-boot splash](/docs/argvus-boot-splash/uki-splash/) — usa il bitmap in un UKI.
- [Troubleshooting](/docs/argvus-boot-splash/troubleshooting/) — se lo splash non è cambiato.
