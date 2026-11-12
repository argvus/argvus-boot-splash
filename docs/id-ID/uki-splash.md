---
title: UKI dan systemd-boot Splash
description: Gunakan bitmap splash ARGVUS dalam alur boot UKI.
---

# UKI dan splash systemd-boot

Paket ini juga mengirimkan `argvus-uki-splash.bmp` (400x400, BMP
32-bit tidak dikompresi). Ini dimaksudkan untuk alur boot UKI / systemd-boot, di mana gambar splash adalah
yang tertanam ke dalam gambar kernel terpadu alih-alih dibaca dari
initramfs.

. Bitmap ini *tidak* digunakan oleh tema Plymouth dan tidak ada yang terdaftar untuk
Anda secara otomatis: menyematkannya tergantung pada bagaimana Anda membangun UKI Anda.
konsumen adalah:

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```

Biasanya jalankan kembali pembangunan UKI (atau `bootctl set-splash`) setiap kali gambar berubah, dan
ingat untuk menyalin berkas ke ESP jika Anda membangunnya di tempat lain. systemd-boot menyesuaikan ukurannya
bitmap ke konsol, sehingga gambar persegi terlihat berada di tengah.

Jika Anda hanya menggunakan mkinitcpio atau dracut, Anda dapat mengabaikan file ini sepenuhnya — [instalasi](/docs/argvus-boot-splash/installation/) reguler
mencakup jalur tersebut.

## Langkah selanjutnya

- [Penggunaan](/docs/argvus-boot-splash/usage/)
- [Pemecahan Masalah](/docs/argvus-boot-splash/troubleshooting/)
