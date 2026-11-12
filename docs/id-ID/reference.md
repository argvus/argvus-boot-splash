---
title: Referensi
description: File yang diinstal, metadata paket, dan nilai warna.
---

# Referensi

Referensi teknis untuk apa yang diinstal paket dan nilai-nilai apa yang digunakannya.

## Apa yang Anda dapatkan

| Komponen | Deskripsi |
| --- | --- |
| Logo Argvus | Tanda di tengah, digambar di atas kata merek |
| Tanda Kata | Teks `ARGVUS` di bawah logo |
| Bilah kemajuan | Bilah tipis yang lebarnya mencerminkan kemajuan boot Plymouth |
| Dialog kata sandi | Prompt LUKS dengan bidang input yang disembunyikan (`•` bullets) |
| Fade-in | Efek splash memudar dalam ~1 detik saat Plymouth mulai |
| Bitmap UKI | `argvus-uki-splash.bmp`untuk boot berbasis UKI / systemd-boot |

Nama paketnya adalah `argvus-boot-splash` dan ini menggantikan paket
`argvus-plymouth` yang lebih lama jika Anda sudah menginstalnya.

## File yang diinstal

Di bawah `/usr/share/plymouth/themes/argvus/`:

| Berkas | Ukuran | Tujuan |
| --- | --- | --- |
| `argvus.plymouth` | — | deskriptor tema (nama, deskripsi, modul) |
| `argvus.script` | — | skrip tema (bahasa skrip Plymouth sendiri) |
| `argvus-logo.png` | 256x256 | logo, RGBA |
| `argvus-text.png` | 400x53 | tanda kata, RGBA |
| `progress-bar.png` | 400x4 | mengisi bagian dari bilah kemajuan |
| `progress-bar-track.png` | 400x4 | trek tidak terisi |
| `entry-box.png` | 400x48 | bidang entri kata sandi |
| `entry-line.png` | 300x2 | aturan bidang kata sandi/garis bawah |
| `bullet.png` | 12x12 | karakter bertopeng |
| `logo-glow.png` | 260x300 | logo cahaya karya seni |
| `argvus-uki-splash.bmp` | 400x400, 32-bit | UKI/systemd-boot splash bitmap |

Plus lisensi di `/usr/share/licenses/argvus-boot-splash/LICENSE`.

## Metadata paket

| Bidang | Nilai |
| --- | --- |
| Nama | `argvus-boot-splash` |
| Arsitektur | `any` |
| Tergantung | `plymouth` |
| Opsional tergantung | `mkinitcpio`, `dracut` |
| Konflik / penggantian | `argvus-plymouth` |
| Lisensi | Khusus GPL-3.0 |

## Warna

| Elemen | Warna |
| --- | --- |
| Latar Belakang | `#111316` |
| Aksen (logo, tanda kata, isian kemajuan) | `#3590BD` |
| Jalur kemajuan | `#262933` |
| Teks perintah kata sandi | abu-abu muda-biru (`#B8C4CE`) |

Tema ini menggunakan latar belakang gelap solid pada resolusi apa pun, sehingga tidak pernah
secara otomatis beralih antara varian terang dan gelap.

## Mendapatkan bantuan

- Laporkan bug dan minta fitur di pelacak masalah proyek.
- Masalah keamanan: ikuti [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) — jangan buka untuk publik
  masalah kerentanan.
- Sumber, membangun dan merilis: akar repositori ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)).
- Kontribusi: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).
- Lisensi: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE).

## Langkah selanjutnya

- [Instalasi](/docs/argvus-boot-splash/installation/)
- [Penggunaan](/docs/argvus-boot-splash/usage/)
- [Pemecahan Masalah](/docs/argvus-boot-splash/troubleshooting/)
