---
title: Instalasi
description: Persyaratan, opsi instalasi, dan apa yang dilakukan paket hooks.
---

# Instalasi

Segala yang Anda butuhkan untuk mendapatkan splash boot Argvus pada sistem berbasis Arch.

Untuk melihat seperti apa tema dan apa yang dikandungnya, lihat
[referensi](/docs/argvus-boot-splash/reference/). Untuk membangunnya dari sumber, lihat panduan pengembang
[panduan pengembang](/docs/argvus-boot-splash/developer-guide/).

## Persyaratan

- Sistem berbasis Arch yang menggunakan `plymouth` (paket bergantung padanya).
- Generator initramfs: **mkinitcpio** (default Arch) atau **dracut**.
installer mendeteksi mana yang ada dan membangun kembali initramfs untuk Anda.
- Plymouth harus diaktifkan dalam konfigurasi initramfs Anda. Dengan mkinitcpio,
  pastikan `plymouth` ada dalam daftar `HOOKS` dari `/etc/mkinitcpio.conf`:

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```

Restart jika Anda baru saja mengubah ini.

- Tidak ada yang dibutuhkan untuk sesi grafis normal; tema hanya berjalan di Repositori paket resmi
  jalur booting.

## Opsi 1: (disarankan)

Paket yang ditandatangani diterbitkan ke repositori paket Argvus
(`argvus/packages`, jalur `public/arch/$arch`). Tambahkan ke `/etc/pacman.conf`:

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```

Ganti `<PACKAGES_REPO_BASE_URL>` dengan host tempat proyek menerbitkan repositori
(GitHub, GitLab, atau Gitea). Impor kunci penandatanganan repositori terlebih dahulu,
jika tidak `pacman` menolak pengunduhan:

```sh
# 1. import the project's public signing key into your pacman keyring
pacman-key --add /path/to/argvus-signing-key.asc
pacman-key --lsign <key-id>

# 2. refresh and install
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```

## Opsi 2: file paket rilis

Setiap rilis yang diberi tag menerbitkan `.pkg.tar.zst` (ditambah `.sig`) sebagai rilis
aset. Instalasi langsung:

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

Jika Anda peduli dengan kebersihan rantai pasokan, verifikasi tanda tangan yang terpisah dengan kunci publik proyek
sebelum menginstal:

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

## Opsi 3: instalasi manual

Berguna pada sistem non-Arch, atau jika Anda hanya ingin mencoba tema tanpa
pengemasan. Salin direktori tema ke jalur tema Plymouth:

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# or: sudo mkinitcpio -P        # Arch
# or: sudo dracut --regenerate-all
```

Plymouth juga dapat diaktifkan di `/etc/default/grub` dengan `GRUB_CMDLINE_LINUX`
yang berisi `splash`, dan `quiet` memberikan nuansa boot minimal klasik.

## Apa yang dilakukan penginstal

Setelah instalasi atau peningkatan, hook paket berjalan secara otomatis:

1. `plymouth-set-default-theme argvus` — menulis `argvus` ke dalam
`/etc/plymouth/plymouthd.conf`.
2. `mkinitcpio -P` jika mkinitcpio ada, jika tidak `dracut --regenerate-all`.

Jika tidak ada generator yang ditemukan, pemasang akan mencetak peringatan dan Anda harus
membangun ulang initramfs sendiri. Perubahan tema hanya akan terlihat saat boot setelah
initramfs dihasilkan kembali — me-reboot tanpa langkah itu adalah yang paling
alasan umum untuk "percikan tidak berubah".

Saat dihapus, paket hanya mencetak pengingat: memilih tema yang berbeda dan
membangun kembali initramfs diserahkan kepada Anda. Lihat
[pencopotan pemasangan](/docs/argvus-boot-splash/uninstallation/).

## Langkah selanjutnya

- [Penggunaan](/docs/argvus-boot-splash/usage/) — verifikasi instalasi, pratinjau tanpa melakukan reboot, beralih
  tema.
- [UKI dan layar awal systemd-boot](/docs/argvus-boot-splash/uki-splash/) — gunakan bitmap di UKI.
- [Pemecahan Masalah](/docs/argvus-boot-splash/troubleshooting/) — jika layar awal tidak berubah.
