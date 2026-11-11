---
title: Packaging
description: Arch paket meta verileri, derleme hattı ve Make hedefleri.
---

# Packaging

Arch paketinin nasıl tanımlandığı ve üretildiği: iki PKGBUILD, paylaşılan
fonksiyonları, kurulum kancaları, yerel derleme hattı ve Make hedefleri.

Temanın kendisi için [tema mimarisi](/docs/argvus-boot-splash/developer-guide/theme/); doğrulama, CI ve
sürümler için [CI ve sürümler](/docs/argvus-boot-splash/developer-guide/ci-releases/) bakınız.

## İki PKGBUILD, bir içerik paketi

`packaging/arch/remote/PKGBUILD` ve `packaging/arch/local/PKGBUILD`,
except for `source=`:

| | `local` | `ci` |
| --- | --- | --- |
| source | `${pkgname}-${pkgver}.tar.gz` (built by `make build`) | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| used by | developers, `make build` | GitHub Actions release |

ile tamamen aynıdır. Her ikisi de `packaging/arch/common/functions.sh`'den aynı işlevleri çağırır ve
`tools/sh/validate.sh`, onların meta verisinin (`pkgname`, `pkgver`, `pkgrel`,
`pkgdesc`, `arch`, `license`, `depends`, `makedepends`, `options`) aynı olduğunu doğrular,
bu yüzden ikisi sessizce sürüklenemez.

Shared metadata:

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

## Paylaşılan işlevler

`packaging/arch/common/functions.sh`,
PKGBUILDs:

- `arch_normalize_source_tree` (`prepare()`) tarafından kullanılan üç işlev sağlar — GitHub etiket arşivleri
`<repo>-v<version>` içine çıkarılırken, yerel tarball
`<pkgname>-<pkgver>`. Bu, tek üst düzey dizinin adını
`${srcdir}/${pkgname}-${pkgver}` olarak değiştirir ve kaynak dizin
eksik, belirsiz veya hedef zaten mevcutsa hata verir.
- `arch_check_splash_payload` (`check()`) — her tema varlığının
çıkarılan kaynak. Bu, paketin tek "test paketi"dir; liste
Gerekli dosyalar [varlık envanterinde](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory) bulunmaktadır.
- `arch_package_splash_payload` (`package()`) — `src/usr` ile yürür
`find -print0` ve her dosyayı `install -Dm644` ile `$pkgdir` içine kurar
(NUL-güvenli, isimlerde boşluklarla çalışır), ardından `LICENSE`'yi
`/usr/share/licenses/argvus-boot-splash/LICENSE`.

'ye kurar. package() içinde `make install` çağrısı olmadığını unutmayın: her şey
 `package()` `install -Dm*` olduğundan paket kendi kendine yeten ve root'suz derleme dostudur.
Bu kasıtlıdır — eski bir `package()`, `make install` çağırdı ve
`sudo`/`libfakeroot.so` hatalarına yol açtı.

## Kurulum kancaları

`packaging/arch/{ci,local}/argvus-boot-splash.install` (aynı):

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`,
o zaman `mkinitcpio -P` mevcutsa, yoksa `dracut --regenerate-all`, yoksa a
Kullanıcıya manuel olarak yeniden inşa etmesini söyleyen uyarı.
- `post_remove()` → yalnızca bilgilendirme mesajı; tema geri değiştirilmedi
otomatik olarak (tahmin etmekten daha güvenli).

## Yerel derleme hattı

`tools/sh/pkgbuild_local.sh` (`make build` tarafından çağrıldı):

1. , `makepkg`, `sha256sum`, `tar`, `awk`, `find` ve PKGBUILD
'nin var olduğunu doğrular; PKGBUILD'i kaynak olarak alır ve `pkgname`/`pkgver`'yi okur ve her ikisini de
izin-liste regexlerine karşı (isim için `^[a-z0-9@._+-]+$`, versiyon için bir noktalı versiyon
deseni).
2. `build/artifacts/${pkgname}-${pkgver}.tar.gz` ile
`tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner`
ve `--transform "s#^\./#${pkgname}-${pkgver}/#"` — deterministik,
çoğaltılabilir arşiv. `.git`, `build/`, `dist/`, `target/`,
, `tools/`, `release`/`packages-repo` geçici dizinlerini ve paketleme dizinlerinin içindeki herhangi bir `src/`, `pkg/` veya
paket kalıntısını içermez.
3. Arşivin `sha256`'sini hesaplar ve bunu **geçici bir
kopyasına** `sed` ile enjekte eder; yerel PKGBUILD (`.PKGBUILD.local.XXXXXX`, bir `EXIT`
tuzağı ile kaldırıldı). Depo her zaman `sha256sums=()`'yi boş tutar; `SKIP` asla
   used.
4. değildir.
 `${pkgname}-${pkgver}-*.pkg.tar.zst` `build/dist/` böylece bayat bir paket bu derleme ile karıştırılamaz.
5. `makepkg -p <generated PKGBUILD> --nodeps --noconfirm --needed
--cleanbuild --force --check` with `BUILDDIR`/`SRCDEST` in `build/artifacts/` çalıştırır
ve `PKGDEST` içinde `build/dist/`. Ek argümanlar `makepkg`'ye iletilir;
`MAKEPKG_FLAGS` varsayılan bayrak setinin üzerine yazar (kelime bölme kasıtlı).
6. Tam olarak bir `.pkg.tar.zst` eşleşmediği sürece başarısız olur, ardından `namcap` üzerinde çalışır
   installed.

Outputs:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```

## Hedefler

| Target | Effect |
| --- | --- |
| `make build` (alias `make package`) | run `tools/sh/pkgbuild_local.sh` → `build/` |
| `make install` (alias `make install-package`) | `sudo pacman -U`tek paket içinde`build/dist/`; sayısı tam olarak 1 değilse hatalar |
| `make validate` | `tools/sh/validate.sh`: shellcheck + `bash -n` + PKGBUILD metadata sync + `makepkg --printsrcinfo` per PKGBUILD + `git diff --check` |
| `make lint` (alias `make lint-shell`) | shellcheck over `tools`, `packaging/arch/common`, `src` (`SC1090`, `SC2034`, `SC2154` disabled), `bash -n`, `git diff --check` |
| `make spellcheck` | `cspell --config cspell.json .` if `cspell` is installed, otherwise skipped |
| `make clean` | `rm -rf build/` |
| `make help` | target list (default goal) |

CI, `make validate` ve `make build` çalıştırır; CI, `make install`
çalıştırmaz (bkz. [bilinen boşluklar](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)).

## Prerequisites

`make`, `git`, `gnupg` ve `base-devel` grubu ile bir Arch tabanlı sistem:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```

- `pacman-contrib`, `updpkgsums` sağlar (PKGBUILD özetlerini yeniden oluşturur).
- `shellcheck`, depo kabuk betiklerini ve paylaşılan Arch
  packaging functions.
- Optional: `namcap` (package
linting) ve cspell (yerel yazım denetimi) doğrular. CI bunların hepsini yükler.
