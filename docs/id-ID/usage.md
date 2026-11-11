---
title: Usage
description: Verifikasi instalasi, pratinjau tanpa me-reboot, dan ganti tema.
---

# Usage

Cara memverifikasi tema, pratinjau tanpa me-reboot, dan beralih darinya.
Untuk instalasi, lihat [instalasi](/docs/argvus-boot-splash/installation/).

## Memverifikasi instalasi

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```

## Pratinjau tanpa me-reboot

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```

Pratinjau mungkin akan meminta autentikasi polkit ketika dijalankan sebagai pengguna biasa. Bar kemajuan
bergerak seiring dengan kemajuan yang disimulasikan; Anda juga dapat memaksa status:

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```

Saat layar splash muncul, tekan <kbd>Esc</kbd> untuk beralih ke layar berikutnya
(splash → details → splash).

## Apa yang ditampilkan splash

| Stage | Appearance |
| --- | --- |
| Startup | Semua memudar dalam ~1 detik: logo, wordmark, jalur kemajuan |
| Booting | Bilah terisi dari kiri saat Plymouth melaporkan kemajuan |
| Volume terenkripsi | Layar splash meredup hingga 15%, teks prompt dan titik-titik tersembunyi muncul di bawah bilah |
| Frasa sandi diterima | Dialog hilang, tampilan kembali ke opasitas penuh |

## Mengubah atau mengembalikan tema

```sh
# switch theme (any theme name under /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# then regenerate the initramfs
sudo mkinitcpio -P              # or: sudo dracut --regenerate-all
```

Useful configuration files:

| File | Purpose |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` written by the package |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` must include `plymouth` |
| `/etc/plymouth/plymouthd.conf` (again) | `PLYMOUTH_TOGGLE_KEY` etc. are global, not per-theme |

## Lembar contekan perintah

| Command | Effect |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | make `argvus` the default theme |
| `sudo plymouth-update-theme` | apply the change to the running Plymouth |
| `sudo plymouth --show-splash` | show the splash in the current session |
| `sudo plymouth --show-details` | show verbose boot messages instead |
| `sudo plymouthquit` | leave Plymouth and restore your session |
| `sudo mkinitcpio -P` | rebuild the Arch initramfs |
| `sudo dracut --regenerate-all` | rebuild the initramfs with dracut |

## Langkah selanjutnya

- [UKI dan splash systemd-boot](/docs/argvus-boot-splash/uki-splash/)
- [Pencopotan pemasangan](/docs/argvus-boot-splash/uninstallation/)
- [Pemecahan Masalah](/docs/argvus-boot-splash/troubleshooting/)
