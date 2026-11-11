---
title: Reference
description: File yang diinstal, metadata paket, dan nilai warna.
---

# Reference

Referensi teknis untuk apa yang diinstal paket dan nilai-nilai apa yang digunakannya.

## Apa yang Anda dapatkan

| Component | Description |
| --- | --- |
| Logo Argvus | Tanda di tengah, digambar di atas kata merek |
| Wordmark | `ARGVUS` text below the logo |
| Bilah kemajuan | Bilah tipis yang lebarnya mencerminkan kemajuan boot Plymouth |
| Dialog kata sandi | Prompt LUKS dengan bidang input yang disembunyikan (`•` bullets) |
| Fade-in | Efek splash memudar dalam ~1 detik saat Plymouth mulai |
| Bitmap UKI | `argvus-uki-splash.bmp`untuk boot berbasis UKI / systemd-boot |

Nama paketnya adalah `argvus-boot-splash` dan ini menggantikan paket
`argvus-plymouth` yang lebih lama jika Anda sudah menginstalnya.

## File yang diinstal

Di bawah `/usr/share/plymouth/themes/argvus/`:

| File | Size | Purpose |
| --- | --- | --- |
| `argvus.plymouth` | — | theme descriptor (name, description, module) |
| `argvus.script` | — | the theme script (Plymouth's own scripting language) |
| `argvus-logo.png` | 256x256 | logo, RGBA |
| `argvus-text.png` | 400x53 | wordmark, RGBA |
| `progress-bar.png` | 400x4 | filled part of the progress bar |
| `progress-bar-track.png` | 400x4 | unfilled track |
| `entry-box.png` | 400x48 | password entry field |
| `entry-line.png` | 300x2 | password field rule/underline |
| `bullet.png` | 12x12 | masked character |
| `logo-glow.png` | 260x300 | logo glow artwork |
| `argvus-uki-splash.bmp` | 400x400, 32-bit | UKI/systemd-boot splash bitmap |

Plus lisensi di `/usr/share/licenses/argvus-boot-splash/LICENSE`.

## Metadata paket

| Field | Value |
| --- | --- |
| Name | `argvus-boot-splash` |
| Architecture | `any` |
| Depends | `plymouth` |
| Optional depends | `mkinitcpio`, `dracut` |
| Conflicts / replaces | `argvus-plymouth` |
| License | GPL-3.0-only |

## Colors

| Element | Color |
| --- | --- |
| Background | `#111316` |
| Accent (logo, wordmark, progress fill) | `#3590BD` |
| Progress track | `#262933` |
| Password prompt text | light gray-blue (`#B8C4CE`) |

Tema ini menggunakan latar belakang gelap solid pada resolusi apa pun, sehingga tidak pernah
secara otomatis beralih antara varian terang dan gelap.

## Mendapatkan bantuan

- Laporkan bug dan minta fitur di pelacak masalah proyek.
- Masalah keamanan: ikuti [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) — jangan buka untuk publik
  issue for vulnerabilities.
- Sumber, membangun dan merilis: akar repositori ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)).
- Kontribusi: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).
- Lisensi: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE).

## Langkah selanjutnya

- [Instalasi](/docs/argvus-boot-splash/installation/)
- [Penggunaan](/docs/argvus-boot-splash/usage/)
- [Pemecahan Masalah](/docs/argvus-boot-splash/troubleshooting/)
