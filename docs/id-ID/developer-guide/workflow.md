---
title: Konvensi dan Kesenjangan yang Dikenal
description: Aturan rumah, peta dokumentasi, dan temuan audit repositori.
---

# Konvensi dan kesenjangan yang dikenal

Aturan rumah untuk perubahan di repositori ini, plus ketidakkonsistenan yang ditemukan saat
mengauditnya — lebih baik diperbaiki daripada disalin.

Untuk referensi teknis lihat [arsitektur tema](/docs/argvus-boot-splash/developer-guide/theme/),
[kemasan](/docs/argvus-boot-splash/developer-guide/packaging/)dan [CI dan rilis](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Conventions

- Shell: `set -euo pipefail`, tab untuk indentasi, `printf`/`error` pesan ke
stderr, pemeriksaan kemampuan `command -v`, pembersihan shellcheck (lihat
  `.editorconfig`).
- Jangan menulis `sha256sums=('SKIP')`; biarkan `sha256sums=()` kosong di git.
- Jangan meng-commit hasil build (`build/`), file paket, atau
  `.PKGBUILD.local.*` copies.
- yang dihasilkan Komit Konvensional dengan ruang lingkup yang digunakan oleh sejarah: `splash`, `layout`,
`pkgbuild`, `release`, `chore`, `ci`, `build`, `docs`.
- Penamaan cabang: `feat/…`, `fix/…`, `docs/…`, `chore/…`, `refactor/…`.
- Persetujuan satu peninjau sebelum penggabungan, squash-merge.
- Lisensi: GPL-3.0-saja. Dikirim sebagai `/usr/share/licenses/argvus-boot-splash/LICENSE`.
- Ikuti proses di [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) dan
[DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md).

## Kekurangan yang diketahui

Ketidakkonsistenan yang terdokumentasi ditemukan saat mengaudit repositori:

- `README.md` mengiklankan `make test` untuk pratinjau Plymouth langsung, tetapi tidak ada
target ada di [Makefile](https://github.com/argvus/argvus-boot-splash/blob/main/Makefile). Perintah nyata adalah
`sudo plymouth --show-splash` / `sudo plymouthquit`.
- `entry-line.png` dan `logo-glow.png` dikirim dalam payload dan dibutuhkan oleh
`arch_check_splash_payload()`, tetapi `argvus.script` tidak pernah memuatnya. Atau
hubungkan mereka ke dalam skrip atau hapus mereka dari payload dan daftar periksa.
- `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` terpasang tetapi
tidak pernah terdaftar dengan apa pun;
[panduan pengguna](/docs/argvus-boot-splash/uki-splash/) mendokumentasikan manual
  `bootctl`/`ukify` step.
- Dokumen kanonik berada di root repositori (`README.md`,
`DEVELOPMENT.md`) dan tumpang tindih dengan panduan di `docs/`. Jaga konsistensi mereka
saat mengubah salah satunya. Kebijakan kontribusi (`CONTRIBUTING.md`, `SECURITY.md`)
berada di repositori organisasi `.github`.

## Peta dokumentasi

| Document | Audience | Scope |
| --- | --- | --- |
| `README.md` | everyone | one-paragraph overview and layout |
| `DEVELOPMENT.md` | maintainers | build, signing, release process |
| [`CONTRIBUTING.md`](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)(org `.github`) | kontributor | alur git, aturan PR, kebijakan rahasia |
| [`docs/user-guide.md`](/docs/argvus-boot-splash/)| pengguna akhir | pemasangan, penggunaan, pemecahan masalah |
| [`docs/developer-guide.md`](/docs/argvus-boot-splash/developer-guide/)(/docs/argvus-boot-splash/developer-guide/) | developers | theme internals, packaging, CI |
