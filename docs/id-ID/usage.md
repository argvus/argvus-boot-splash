---
title: Penggunaan
description: Verifikasi instalasi, pratinjau tanpa me-reboot, dan ganti tema.
---

# Penggunaan

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
(percikan → detail → percikan).

## Apa yang ditampilkan splash

| Tahap | Penampilan |
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

File konfigurasi yang berguna:

| Berkas | Tujuan |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` ditulis dengan paket |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` harus menyertakan `plymouth` |
| `/etc/plymouth/plymouthd.conf` (lagi) | `PLYMOUTH_TOGGLE_KEY` dll. bersifat global, bukan per tema |

## Lembar contekan perintah

| Perintah | Efek |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | jadikan `argvus` sebagai tema default |
| `sudo plymouth-update-theme` | terapkan perubahan pada Plymouth |
| `sudo plymouth --show-splash` | tampilkan splash di sesi saat ini |
| `sudo plymouth --show-details` | tampilkan pesan boot verbose sebagai gantinya |
| `sudo plymouthquit` | tinggalkan Plymouth dan pulihkan sesi Anda |
| `sudo mkinitcpio -P` | membangun kembali Arch initramfs |
| `sudo dracut --regenerate-all` | membangun kembali initramf dengan dracut |

## Langkah selanjutnya

- [UKI dan splash systemd-boot](/docs/argvus-boot-splash/uki-splash/)
- [Pencopotan pemasangan](/docs/argvus-boot-splash/uninstallation/)
- [Pemecahan Masalah](/docs/argvus-boot-splash/troubleshooting/)
