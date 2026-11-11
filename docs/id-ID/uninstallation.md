---
title: Uninstallation
description: Hapus paket dan kembalikan tema boot sebelumnya.
---

# Uninstallation

```sh
sudo pacman -Rns argvus-boot-splash
```

Kemudian pilih tema lain dan bangun kembali, jika tidak splash lama akan tetap berada di dalam
initramfs:

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```

`pacman -Rns` juga menghapus `/etc/plymouth/plymouthd.conf` jika tidak ada yang lain
created it.

Hook penghapusan paket hanya mencetak pengingat — itu tidak menebak tema
yang Anda inginkan sebagai gantinya, dan itu tidak menyentuh initramfs Anda.

## Langkah selanjutnya

- [Pemecahan Masalah](/docs/argvus-boot-splash/troubleshooting/) — mengembalikan splash sebelumnya.
- [Instalasi](/docs/argvus-boot-splash/installation/) — menginstal ulang nanti.
