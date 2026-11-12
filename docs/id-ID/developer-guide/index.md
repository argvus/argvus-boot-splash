---
title: Panduan Pengembang
description: Panduan arsitektur dan pengembangan untuk kontributor ARGVUS.
---

# Argvus Boot Splash — Panduan Pengembang

Dokumentasi teknis untuk repositori `argvus-boot-splash`: bagaimana tema Plymouth
disusun, bagaimana paket Arch dibuat, dan bagaimana rilis
ditandatangani dan diterbitkan.

Tidak ada langkah kompilasi di sini — tema ini adalah data (deskriptor `.plymouth`,
sebuah `.script`, dan gambar) ditambah resep paket Arch. "Membangun" berarti menghasilkan
paket yang dapat direproduksi:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```

Sebelum melakukan perubahan: `make validate && make build`, dan tambahkan istilah teknis baru
ke `.cspell/custom-dictionary-workspace.txt` atau tugas pemeriksa ejaan akan gagal.

Jika Anda hanya ingin *menggunakan* tema, bacalah [panduan pengguna](/docs/argvus-boot-splash/). Untuk
rekan berorientasi proses dari file ini (git flow, rahasia, rilis
proses) lihat [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) dan
[KONTRIBUSI.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).

## Panduan

| Panduan | Isi |
| --- | --- |
| [Arsitektur tema](/docs/argvus-boot-splash/developer-guide/theme/)| Deskriptor, model rendering, inventaris aset, walkthrough skrip, konstanta tata letak, token desain, bitmap UKI, cara memodifikasi tema |
| [Kemasan](/docs/argvus-boot-splash/developer-guide/packaging/)| Dua PKGBUILD, dibagikan`functions.sh`, pasang hooks, pipeline build lokal, target Make, prasyarat |
| [CI dan rilis](/docs/argvus-boot-splash/developer-guide/ci-releases/) | `validate.sh`, `ci.yml`, `release.yml`langkah demi langkah, checksum, penandatanganan, rahasia, penerbitan dan versi |
| [Konvensi dan kesenjangan yang diketahui](/docs/argvus-boot-splash/developer-guide/workflow/)| Aturan rumah, peta dokumentasi, dan ketidakkonsistenan yang ditemukan saat mengaudit repositori |

## Referensi cepat

| Jalur | Apa itu |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | payload tema diinstal di bawah `/usr` |
| `packaging/arch/{ci,local}/PKGBUILD` | rilis dan resep paket lokal |
| `packaging/arch/common/functions.sh` | dibagikan `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | tarball deterministik + driver `makepkg` |
| `tools/sh/validate.sh` | gerbang validasi yang diperlukan |
| `.github/workflows/` | `ci.yml` (validasi, build, periksa ejaan), `release.yml` (tag `v*`) |

## Di tempat lain

- Root repositori: [README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
- Dokumen untuk pengguna: [panduan pengguna](/docs/argvus-boot-splash/)
- Proses pengembangan: [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
- Ber kontribusi: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
- Kebijakan keamanan: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
- Lisensi: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
- Versi Portugis: [Guia do desenvolvedor](/pt/docs/argvus-boot-splash/developer-guide/)
