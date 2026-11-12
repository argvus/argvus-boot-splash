---
title: Kemasan
description: Metadata paket Arch, pipeline build, dan target Make.
---

# Pengemasan

Bagaimana paket Arch didefinisikan dan diproduksi: dua PKGBUILD, fungsi
yang dibagikan, hook instalasi, pipeline build lokal, dan target Make.

Untuk tema itu sendiri lihat [arsitektur tema](/docs/argvus-boot-splash/developer-guide/theme/); untuk validasi, CI dan
rilis lihat [CI dan rilis](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Dua PKGBUILD, satu payload

`packaging/arch/remote/PKGBUILD` dan `packaging/arch/local/PKGBUILD` identik
kecuali `source=`:

| | `local` | `ci` |
| --- | --- | --- |
| sumber | `${pkgname}-${pkgver}.tar.gz` (dibangun oleh `make build`) | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| digunakan oleh | pengembang, `make build` | Rilis Tindakan GitHub |

Keduanya memanggil fungsi yang sama dari `packaging/arch/common/functions.sh`, dan
`tools/sh/validate.sh` menegaskan metadata mereka (`pkgname`, `pkgver`, `pkgrel`,
`pkgdesc`, `arch`, `license`, `depends`, `makedepends`, `options`) identik,
sehingga keduanya tidak bisa melayang secara diam-diam.

Metadata bersama:

```bash
pkgname=argvus-boot-splash
pkgver=0.2.0
pkgrel=1
arch=('any')                 # pure data package
depends=('plymouth')
optdepends=('mkinitcpio: rebuild initramfs (Arch Linux)'
            'dracut: rebuild initramfs (alternative)')
options=('!debug')
conflicts=('argvus-plymouth') # renamed predecessor
replaces=('argvus-plymouth')
```

## Fungsi bersama

`packaging/arch/common/functions.sh` menyediakan tiga fungsi yang digunakan oleh kedua
PKGBUILD:

- `arch_normalize_source_tree` (`prepare()`) — arsip tag GitHub diekstrak ke
`<repo>-v<version>`, sementara tarball lokal diekstrak ke

. This renames the single top-level directory to

, erroring out if the source directory is
hilang, ambigu, atau tujuan sudah ada.
-

 (

) — asserts every theme asset exists in
sumber yang diekstrak. Ini adalah satu-satunya "test suite" paket ini; daftar file
yang diperlukan ada di [inventaris aset](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory).
- `<pkgname>-<pkgver>` (`${srcdir}/${pkgname}-${pkgver}` package()  arch_package_splash_payload  check()  `arch_check_splash_payload` ) — menelusuri  `check()`  `arch_package_splash_payload`  `package()` `src/usr` dengan
`find -print0` dan memasang setiap file dengan `install -Dm644` ke dalam `$pkgdir`
(Aman untuk NUL, bekerja dengan spasi dalam nama), kemudian menginstal `LICENSE` ke
`/usr/share/licenses/argvus-boot-splash/LICENSE`.

Perlu dicatat tidak ada panggilan `make install` di dalam `package()`: semuanya
`install -Dm*`, sehingga paket ini mandiri dan ramah terhadap pembuatan tanpa root.
Itu disengaja — sebuah `package()` lama yang disebut `make install` menghasilkan
kegagalan `sudo`/`libfakeroot.so`.

## Pasang kait

`packaging/arch/{ci,local}/argvus-boot-splash.install` (identik):

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`,
kemudian `mkinitcpio -P` jika tersedia, jika tidak `dracut --regenerate-all`, jika tidak
peringatan yang memberitahu pengguna untuk membangunnya secara manual.
- `post_remove()` → hanya pesan informasional; tema tidak dikembalikan otomatis (lebih aman daripada menebak).


## Jalur pembangunan lokal

`tools/sh/pkgbuild_local.sh` (dipanggil oleh `make build`):

1. Memverifikasi `makepkg`, `sha256sum`, `tar`, `awk`, `find` dan bahwa PKGBUILD
ada; memuat PKGBUILD untuk membaca `pkgname`/`pkgver` dan memvalidasi kedua
terhadap regex daftar-izinkan (`^[a-z0-9@._+-]+$` untuk nama, versi bertitik
pola untuk versi).
2. Membangun `build/artifacts/${pkgname}-${pkgver}.tar.gz` dengan
`tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner`
dan `--transform "s#^\./#${pkgname}-${pkgver}/#"` — sebuah deterministik,
arsip yang dapat direproduksi. Ini mengecualikan direktori scratch `.git`, `build/`, `dist/`, `target/`,
`tools/`, `release`/`packages-repo`, dan sisa paket `src/`, `pkg/`, atau
di dalam direktori pengemasan.
3. Menghitung `sha256` dari arsip dan menyuntikkannya dengan `sed` ke dalam **salinan sementara
** dari PKGBUILD lokal (`.PKGBUILD.local.XXXXXX`, dihapus oleh jebakan `EXIT`
). Repositori selalu menjaga `sha256sums=()` tetap kosong; `SKIP` tidak pernah
   digunakan.
4. Menghapus `${pkgname}-${pkgver}-*.pkg.tar.zst` yang sudah ada dari
`build/dist/` sehingga paket basi tidak bisa dikira sebagai build ini.
5. Menjalankan `makepkg -p <generated PKGBUILD> --nodeps --noconfirm --needed
--cleanbuild --force --check` with `BUILDDIR`/`SRCDEST` in `build/artifacts/`
dan `PKGDEST` di `build/dist/`. Argumen tambahan diteruskan ke `makepkg`;
`MAKEPKG_FLAGS` menggantikan set bendera default (pemisahan kata disengaja).
6. Gagal kecuali tepat satu `.pkg.tar.zst` cocok, lalu menjalankan `namcap` di atasnya jika
   dipasang.

Outputs:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```

## Membuat target

| Sasaran | Efek |
| --- | --- |
| `make build` (alias `make package`) | jalankan `tools/sh/pkgbuild_local.sh` → `build/` |
| `make install` (alias `make install-package`) | `sudo pacman -U` paket tunggal di `build/dist/`; kesalahan jika jumlahnya tidak tepat 1 |
| `make validate` | `tools/sh/validate.sh`: shellcheck + `bash -n` + sinkronisasi metadata PKGBUILD + `makepkg --printsrcinfo` per PKGBUILD + `git diff --check` |
| `make lint` (alias `make lint-shell`) | shellcheck over `tools`, `packaging/arch/common`, `src` (`SC1090`, `SC2034`, `SC2154` disabled), `bash -n`, `git diff --check` |
| `make spellcheck` | `cspell --config cspell.json .` jika `cspell` diinstal, jika tidak, lewati |
| `make clean` | `rm -rf build/` |
| `make help` | daftar target (tujuan default) |

CI menjalankan `make validate` dan `make build`; tidak ada di CI yang menjalankan `make install`
(lihat [celah yang diketahui](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)).

## Prasyarat

Sebuah sistem berbasis Arch dengan `make`, `git`, `gnupg` dan grup `base-devel`:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```

- `pacman-contrib` menyediakan `updpkgsums` (menghasilkan ulang checksum PKGBUILD).
- `shellcheck` memvalidasi skrip shell repositori dan berbagi Arch
  fungsi pengemasan.
- Opsional: `namcap` (paket
linting) dan cspell (pemeriksaan ejaan lokal). CI menginstal semuanya.
