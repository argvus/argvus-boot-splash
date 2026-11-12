---
title: Percikan Boot ARGVUS
description: Tema Plymouth dan panduan instalasi untuk lingkungan desktop ARGVUS
---

# ARGBUS Boot Splash

Argvus boot splash adalah tema [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/) untuk ekosistem desktop Argvus. Ini adalah yang Anda lihat antara saat menyalakan mesin dan momen saat sesi grafis Anda dimulai.

## Dokumentasi

Dokumentasi ini disusun dalam dua bagian utama:

### Panduan Pengguna
Panduan instalasi dan penggunaan untuk pengguna akhir dan administrator sistem.

| Panduan | Isi |
| --- | --- |
| [Instalasi](/docs/argvus-boot-splash/installation/)| Persyaratan, tiga opsi instalasi, apa yang dilakukan hook paket |
| [Penggunaan](/docs/argvus-boot-splash/usage/)| Verifikasi pemasangan, pratinjau tanpa mem-boot ulang, ubah atau kembalikan tema, lembar contekan perintah |
| [UKI dan splash systemd-boot](/docs/argvus-boot-splash/uki-splash/)| Menggunakan `argvus-uki-splash.bmp`dalam alur boot UKI |
| [Pencopotan pemasangan](/docs/argvus-boot-splash/uninstallation/)| Menghapus paket dan mengembalikan tema sebelumnya |
| [Pemecahan Masalah](/docs/argvus-boot-splash/troubleshooting/)| Gejala umum dan penyebabnya |
| [Reference](/docs/argvus-boot-splash/reference/) for the installed and user paths.

### [Panduan Pengembang](/docs/argvus-boot-splash/developer-guide/)
Dokumentasi teknis untuk kontributor dan pemelihara.

- [Arsitektur Tema](/docs/argvus-boot-splash/developer-guide/theme/) — deskriptor Plymouth, model rendering, dan kustomisasi
- [Pengemasan](/docs/argvus-boot-splash/developer-guide/packaging/) — Bangun pipeline dan resep paket
- [CI dan Rilis](/docs/argvus-boot-splash/developer-guide/ci-releases/) — Validasi, pengujian, dan alur kerja rilis

## Mulai Cepat

Untuk sistem berbasis Arch:

```sh
sudo pacman -S argvus-boot-splash   # or: sudo pacman -U ./argvus-boot-splash-<version>-1-any.pkg.tar.zst
```

Penginstal mengatur tema sebagai default dan secara otomatis menghasilkan ulang initramfs Anda.

---

- **Repositori:** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **Lisensi:** Khusus GPL-3.0
- **Laporan Bug:** [GitHub Issues](https://github.com/argvus/argvus-boot-splash/issues)
