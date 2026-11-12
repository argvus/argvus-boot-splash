---
title: CI dan Rilis
description: Validasi, integrasi berkelanjutan, penandatanganan, dan alur kerja rilis.
---

# CI dan rilis

Gerbang validasi, pekerjaan integrasi berkelanjutan, pipeline rilis dan
aturan pembuatan versi.

Untuk paket itu sendiri lihat [packaging](/docs/argvus-boot-splash/developer-guide/packaging/); untuk tema lihat
[arsitektur tema](/docs/argvus-boot-splash/developer-guide/theme/).

## Validasi

`tools/sh/validate.sh` adalah gerbang yang diperlukan:

- memerlukan `bash`, `makepkg`, `shellcheck`;
- `shellcheck` + `bash -n` pada `tools/sh/*.sh` dan `packaging/arch/common/*.sh`;
- sumber baik PKGBUILD dan membandingkan metadata yang diekstrak — remote dan lokal harus
  cocok;
- `makepkg -p PKGBUILD --printsrcinfo` di dalam `ci/` dan `local/` (mengurai file
seperti yang dilakukan makepkg);
- `git diff --check` (spasi/penanda konflik).

## Integrasi berkelanjutan

`.github/workflows/ci.yml` (push/PR ke `main`, `archlinux:latest` container):

1. pasang `base-devel git namcap pacman-contrib shellcheck sudo`;
2. `make validate`;
3. build sebagai pengguna `builder` **tanpa hak istimewa**
(`sudo -u builder env HOME=/home/builder make build`) — makepkg menolak dijalankan
sebagai root, dan workspace `chown`ed terlebih dahulu;
4. pekerjaan `spellcheck` yang terpisah menjalankan `cspell-action@v6` dengan `cspell.json`.

`namcap` berjalan di dalam `pkgbuild_local.sh` ketika diinstal, jadi build lokal menampilkan
lint yang sama seperti CI. Konfigurasi ejaan adalah `cspell.json` dengan kamus
di `.cspell/custom-dictionary-workspace.txt` — istilah teknis baru
(flag shell, nama alat) termasuk dalam kamus itu, jika tidak CI gagal.

## pipeline rilis

`.github/workflows/release.yml` — pemicu: push dari tag `v*`, atau
`workflow_dispatch` dengan tag yang sudah ada (rebuild terkontrol). Grup konkurensi
`release-<ref>`, tanpa pembatalan.

Langkah-langkah:

1. **Periksa** tag (dispatch menggunakan `inputs.tag`).
2. **Langkah versi**: memvalidasi tag terhadap
`^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$`, gagal jika `url` kosong di
`packaging/arch/remote/PKGBUILD`, kemudian menulis ulang `pkgver` dari tag.
3. **Validasi**: `make validate`.
4. **Bangun** sebagai `builder` tanpa hak istimewa: `updpkgsums` (menyelesaikan dan memvalidasi
nyata `sha256sums`) lalu
`makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`.
Menemukan `.pkg.tar.zst` dan gagal jika tidak ada.
5. **namcap** pada paket.
6. **Tanda**: mengimpor `GPG_PRIVATE_KEY` ke dalam `GNUPGHOME` sementara (`mktemp -d`,
mode 700), memverifikasi bahwa kunci rahasia yang diimpor cocok dengan `GPG_KEY_ID` (ID pendek atau sidik jari
), dan membuat `.sig` terpisah dengan
`--pinentry-mode loopback --passphrase-fd 0`.
7. **Verifikasi tanda tangan** di `GNUPGHOME` yang baru — rilis gagal jika tanda tangan
tidak terverifikasi.
8. **Unggah artefak** (`upload-artifact@v4`, `retention-days: 1`, paket +
tanda tangan, `if-no-files-found: error`).
9. **Terbitkan**: ambil `argvus/packages` dengan `PACKAGES_REPO_TOKEN`, salin paket
dan `.sig` ke `public/arch/x86_64`, jalankan
`repo-add -R argvus.db.tar.gz <pkg>`, tanda tangani `argvus.db.tar.gz`,
`argvus.files.tar.gz`, `argvus.db` dan `argvus.files`, lalu commit sebagai
`github-actions[bot]` dan push. Diff tanpa perubahan keluar 0 tanpa commit.
10. **rilis GitHub**: `softprops/action-gh-release@v2` dengan catatan yang dihasilkan
dan paket + tanda tangan sebagai aset.

## Checksum, penandatanganan dan rahasia

- Tidak ada `SKIP`: `sha256sums` selalu merupakan ringkasan nyata, dihitung saat membangun
waktu (lokal) atau melalui `updpkgsums` (rilis CI).
- Biarkan `sha256sums=()` **kosong** di repositori.
- Rilis ditandatangani GPG (paket `.sig`, `argvus.db.tar.gz`,
`argvus.files.tar.gz`, `argvus.db`, `argvus.files`).
- `GPG_PASSPHRASE` harus tidak kosong; alur kerja menolak passphrase yang kosong.

Siapkan kuncinya:

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```

Di **Pengaturan → Rahasia dan variabel → Aksi** dari repositori:

| Rahasia | Nilai |
| --- | --- |
| `GPG_PRIVATE_KEY` | Keluaran `gpg --armor --export-secret-keys KEY_ID` |
| `GPG_KEY_ID` | ID kunci atau sidik jari yang diharapkan |
| `GPG_PASSPHRASE` | frasa sandi yang tidak kosong dari kunci penandatanganan |
| `PACKAGES_REPO_TOKEN` | PAT dengan `contents:write` pada `argvus/packages` |

## Mempublikasikan rilisan

Sebelum memberi tag:

1. Isi `url` di `packaging/arch/remote/PKGBUILD` dengan repositori yang sebenarnya:
   - GitHub: `url="https://github.com/argvus/argvus-boot-splash"` (sumber
menggunakan `${url}/archive/refs/tags/v${pkgver}.tar.gz`);
   - GitLab: sesuaikan `source=` ke
`https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz`;
   - tanpa `url`, rilis **gagal dengan sengaja** dengan pesan yang jelas.
2. Sinkronkan versi/metadata di `packaging/arch/local/PKGBUILD` dan
`packaging/arch/remote/PKGBUILD`.
3. Tandai dan dorong:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```

Alur kerja juga dapat dimulai secara manual dengan tag `v*` yang ada sebagai input
`tag`-nya, yang berguna untuk membangun ulang secara terkendali.

## Pembuatan versi

- SemVer dalam `pkgver`, jumlah rilis dalam `pkgrel`.

## Pemecahan masalah pengembang

**Rilis gagal pada tahap "Mengambil sumber".** `url` kosong, tag `v*` hilang, atau format URL arsip
yang tidak sesuai dengan host (tata letak tarball GitHub vs GitLab
). Alur kerja memvalidasi pola tag dan gagal lebih awal jika
`url`.

**`updpkgsums` tidak dapat menemukan sumber.** Tag harus ada dan didorong sebelum
pekerjaan rilis dijalankan; pengiriman dengan tag yang hanya ada secara lokal gagal di sini.

**`make validate` melaporkan "metadata PKGBUILD jarak jauh dan lokal tidak sinkron".**
Salin bidang metadata (bukan `source=`) dari satu PKGBUILD ke PKGBUILD lainnya.

**Pemeriksaan ejaan gagal pada istilah baru.** Tambahkan ke
`.cspell/custom-dictionary-workspace.txt` (kamus `argvus`, `addWords:
true`), not to `abaikanPaths`.

**`sudo` diminta di dalam `make install`, atau `libfakeroot.so … LD_PRELOAD`
kesalahan.** Sebuah `package()` yang menjalankan `make install` alih-alih menggunakan
`install -Dm*`. Kedua PKGBUILDs memanggil `arch_package_splash_payload`, yang tidak dilakukan oleh
; pastikan tidak ada yang memperkenalkan kembali panggilan `make`.

**`makepkg` menolak untuk dijalankan.** Tidak boleh dijalankan sebagai root. Jalankan build sebagai pengguna
biasa, atau `sudo -u <user> make build`.

**Paket terpasang tetapi layar splash tidak berubah.** Initramfs tidak dibangun ulang.
Untuk pengujian lokal, panggil `sudo plymouth --show-splash` alih-alih me-reboot, atau
bangun ulang dengan  `sudo mkinitcpio -P` `sudo dracut --regenerate-all` / sudo dracut --regenerate-all.
