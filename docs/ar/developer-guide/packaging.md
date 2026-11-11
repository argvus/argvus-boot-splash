---
title: Packaging
description:                          .Make ﻑﺍﺪﻫﺃﻭ ،ءﺎﻨﺒﻟﺍ ﻊﻴﻤﺠﺗ ﻂﺧ ،Arch ﺔﻣﺰﺣ ﻒﻳﺮﻌﺗ ﺕﺎﻧﺎﻴﺑ
---

# Packaging

                        ﻙﺮﺘﺸﻤﻟﺍ ،PKGBUILD ﺎﻔﻠﻣ :Arch ﺔﻣﺰﺣ ﺝﺎﺘﻧﺇﻭ ﻒﻳﺮﻌﺗ ﻢﺘﻳ ﻒﻴﻛ
                  .Make ﻑﺍﺪﻫﺃﻭ ﻲﻠﺤﻤﻟﺍ ءﺎﻨﺒﻟﺍ ﺐﻴﺑﺎﻧﺃ ﻂﺧ ،ﺖﻴﺒﺜﺘﻟﺍ ﺕﺎﻓﺎﻄﺧ ،ﻝﺍﻭﺪﻟﺍ

                                                             ﺮﻈﻧﺍ ﻪﺴﻔﻧ ﻉﻮﺿﻮﻤﻠﻟ[                                                                 ﻉﻮﺿﻮﻤﻟﺍ ﺔﺳﺪﻨﻫ](/docs/argvus-boot-splash/developer-guide/theme/)                                                   ﻭ ﺮﻤﺘﺴﻤﻟﺍ ﻞﻣﺎﻜﺘﻟﺍ ،ﻖﻘﺤﺘﻠﻟ ;
                                                                  ﻯﺮﺗ ﺕﺍﺭﺍﺪﺻﻹ﻿ﺍ[                                                     ﺕﺍﺭﺍﺪﺻﻹ﻿ﺍﻭ ﺮﻤﺘﺴﻤﻟﺍ ﻞﻣﺎﻜﺘﻟﺍ](/docs/argvus-boot-splash/developer-guide/ci-releases/).

##                                                 ﺓﺪﺣﺍﻭ ﺔﻟﻮﻤﺣ ،PKGBUILD ﻦﻣ ﻥﺎﻨﺛﺍ

`packaging/arch/remote/PKGBUILD` ﻭ `packaging/arch/local/PKGBUILD` ﻥﺎﻘﺑﺎﻄﺘﻣ
except for `source=`:

| | `local` | `ci` |
| --- | --- | --- |
| source | `${pkgname}-${pkgver}.tar.gz` (built by `make build`) | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| used by | developers, `make build` | GitHub Actions release |

                               ﻭ ،`packaging/arch/common/functions.sh` ﻦﻣ ﻝﺍﻭﺪﻟﺍ ﺲﻔﻧ ﻲﻋﺪﺘﺴﻳ ﺎﻤﻫﻼ﻿ﻛ
`tools/sh/validate.sh` asserts their metadata (`pkgname`, `pkgver`, `pkgrel`,
`pkgdesc`, `arch`, `license`, `depends`, `makedepends`, `options`) is identical,
                                               .ﺖﻤﺼﺑ ﻑﺍﺮﺠﻧﻻ﻿ﺍ ﻦﻴﻨﺛﻼ﻿ﻟ ﻦﻜﻤﻳ ﻻ﻿ ﺍﺬﻟ

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

## ﺔﻛﺮﺘﺸﻤﻟﺍ ﻒﺋﺎﻇﻮﻟﺍ

                          ﺎﻤﻫﻼ﻿ﻛ ﻞﺒﻗ ﻦﻣ ﻡﺪﺨﺘﺴُﺗ ﻒﺋﺎﻇﻭ ﺙﻼ﻿ﺛ `packaging/arch/common/functions.sh` ﺮﻓﻮﻳ
PKGBUILDs:

- `arch_normalize_source_tree` (`prepare()`) — ﺕﺎﻣﻼ﻿ﻋ ﻒﻴﺷﺭﺃ GitHub ﻰﻟﺇ ﺝﺮﺨﺘﺴﻳ
`<repo>-v<version>`، ﻒﻴﺷﺭﺃ ﻡﻮﻘﻳ ﺎﻤﻨﻴﺑ tar ﻰﻟﺇ ﻂﻐﻀﻟﺍ ﻚﻔﺑ ﻲﻠﺤﻤﻟﺍ

. This renames the single top-level directory to

, erroring out if the source directory is
.ﻞﻌﻔﻟﺎﺑ ﺓﺩﻮﺟﻮﻣ ﺔﻬﺟﻮﻟﺍ ﻭﺃ ،ﺾﻣﺎﻏ ،ﺩﻮﻘﻔﻣ
- 

 (

) — asserts every theme asset exists in
                ﺔﻤﺋﺎﻗ ؛ﺔﻣﺰﺤﻠﻟ ﺓﺪﻴﺣﻮﻟﺍ "ﺭﺎﺒﺘﺧﻻ﻿ﺍ ﺔﻋﻮﻤﺠﻣ" ﻮﻫ ﺍﺬﻫ .ﺝﺮﺨﺘﺴﻤﻟﺍ ﺭﺪﺼﻤﻟﺍ
                                                    ﻲﻓ ﺓﺩﻮﺟﻮﻣ ﺔﺑﻮﻠﻄﻤﻟﺍ ﺕﺎﻔﻠﻤﻟﺍ[                                                                     ﻝﻮﺻﻷ﻿ﺍ ﺩﺮﺟ](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory).
-  check()  arch_check_splash_payload  ${srcdir}/${pkgname}-${pkgver}  `<pkgname>-<pkgver>`  `${srcdir}/${pkgname}-${pkgver}`  `arch_check_splash_payload`  `check()` `arch_package_splash_payload` (`package()`) — ﻲﺸﻤﻳ `src/usr` ﻊﻣ
`find -print0` ﻡﺍﺪﺨﺘﺳﺎﺑ ﻒﻠﻣ ﻞﻛ ﺖﺒﺜﻳﻭ `install -Dm644` ﻲﻓ `$pkgdir`
     ﻰﻠﻋ `LICENSE` ﺖﺒﺜﻳ ﻢﺛ ،(ءﺎﻤﺳﻷ﻿ﺍ ﻲﻓ ﺕﺎﻏﺍﺮﻔﻟﺍ ﻊﻣ ﻞﻤﻌﻳ ،NUL ﻊﻣ ﻦﻣﺁ)  
`/usr/share/licenses/argvus-boot-splash/LICENSE`.

    ءﻲﺷ ﻞﻛ :package() ﻞﺧﺍﺩ make install ـﻟ ءﺎﻋﺪﺘﺳﺍ ﺪﺟﻮﻳ ﻻ﻿ ﻪﻧﺃ ﻆﺣﻻ﻿
install -Dm*، ﺭﺬﺠﻟﺍ ﺕﺎﻴﺣﻼ﻿ﺻ ﻥﻭﺪﺑ ءﺎﻨﺒﻠﻟ ﺔﻘﻳﺪﺻﻭ ﺎًﻴﺗﺍﺫ ﺔﻴﻔﺘﻜﻣ ﺔﻣﺰﺤﻟﺍ ﻥﺈﻓ ﺍﺬﻟ
  ﻪﺟﺎﺘﻧﺇ ﻢﺗ `make install` ﻲﻋﺪُﺘﺳﺍ ﻱﺬﻟﺍ ﻢﻳﺪﻘﻟﺍ `package()` — ﺪﻤﻌﺘﻣ ﺍﺬﻫ
                                  . make install  package()  `install -Dm*`  `package()`  `make install` `sudo`/`libfakeroot.so` ﺕﺎﻗﺎﻔﺧﺇ

##                                                                 ﻒﻴﻃﺎﻄﺨﻟﺍ ﺖﻴﺒﺜﺗ

`packaging/arch/{ci,local}/argvus-boot-splash.install` (ﻞﺛﺎﻤﺘﻣ):

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`،
              a ﻻ﻿ﺇﻭ ،dracut --regenerate-all ﻻ﻿ﺇﻭ ،ﺎًﺣﺎﺘﻣ ﻥﺎﻛ ﺍﺫﺇ `mkinitcpio -P` ﻢﺛ
                                      .ًﺎﻳﻭﺪﻳ ءﺎﻨﺒﻟﺍ ﺓﺩﺎﻋﺈﺑ ﻡﺪﺨﺘﺴﻤﻟﺍ ﻍﻼ﻿ﺑﻹ﻿ ﺮﻳﺬﺤﺗ
-  `dracut --regenerate-all` `post_remove()` → ﻉﻮﺿﻮﻤﻟﺍ ﻞﻳﺪﺒﺗ ﺓﺩﺎﻋﺇ ﻢﺘﻳ ﻢﻟ ؛ﻂﻘﻓ ﺔﻴﻣﻼ﻿ﻋﺇ ﺔﻟﺎﺳﺭ
                                              .(ﻦﻴﻤﺨﺘﻟﺍ ﻦﻣ ﺎًﻧﺎﻣﺃ ﺮﺜﻛﺃ) ﺎًﻴﺋﺎﻘﻠﺗ

##                                                        ﻲﻠﺤﻤﻟﺍ ءﺎﻨﺒﻟﺍ ﺐﻴﺑﺎﻧﺃ ﻂﺧ

`tools/sh/pkgbuild_local.sh` (ﺔﻄﺳﺍﻮﺑ ﻩﺅﺎﻋﺪﺘﺳﺍ ﻢﺗ `make build`):

1. Verifies `makepkg`, `sha256sum`, `tar`, `awk`, `find` and that the PKGBUILD
ﺎﻤﻫﻼ﻿ﻛ ﻦﻣ ﻖﻘﺤﺘﻟﺎﺑ ﻡﻮﻘﻳﻭ `pkgname`/`pkgver` ﺓءﺍﺮﻘﺑ PKGBUILD ﺭﺪﺼ
          (ﺔﻄﻘﻨﻣ ﺔﺨﺴﻧ ،ﻢﺳﻼ﻿ﻟ `^[a-z0-9@._+-]+$`) ﺡﺎﻤﺴﻟﺍ ﺔﻤﺋﺎﻘﻟ ﻡﺎﻈﺘﻧﻻ﻿ﺍ ﺮﻴﺑﺎﻌﺗ ﺪﺿ
                                                                .(ﺭﺍﺪﺻﻺ﻿ﻟ ﻂﻤﻨﻟﺍ
2.                                                      ﻊﻣ `build/artifacts/${pkgname}-${pkgver}.tar.gz` ﻲﻨﺒﻳ
`tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner`
                                                   ،ﻲﻤﺘﺣ — `--transform "s#^\./#${pkgname}-${pkgver}/#"` ﻭ
،`.git`، `build/`، `dist/`، `target/` ﺪﻌ
   `tools/`, `release`/`packages-repo` scratch dirs, and any `src/`, `pkg/` or
                                            .ﻒﻴﻠﻐﺘﻟﺍ ﺕﺍﺪﻠﺠﻣ ﻞﺧﺍﺩ ﺎﻳﺎﻘﺒﻟﺍ ﻒﻴﻠﻐﺗ
3.            ﺖﻗﺆﻣ** ﻲﻓ sed ـﺑ ﻪﻨﻘﺤﻳﻭ ﻒﻴﺷﺭﻸ﻿ﻟ `sha256` ﺐﺴﺤﻳ
`sed`  ﺔﻄﺳﺍﻮﺑ ﺎﻬﺘﻟﺍﺯﺇ ﺖﻤﺗ ،`.PKGBUILD.local.XXXXXX`) ﻲﻠﺤﻤ
ﺍًﺪﺑﺃ ﻥﻮﻜﻳ ﻻ﻿ `EXIT` ؛ﺎًﻏﺭﺎﻓ `sha256sums=()` ـﺑ ﺎًﻤﺋﺍﺩ ﻉﺩﻮﺘﺴﻤﻟﺍ ﻆﻔﺘﺤﻳ
   used.
4.                                       ﻦﻣ ﺎًﻘﺒﺴﻣ ﺩﻮﺟﻮﻣ  `SKIP` `${pkgname}-${pkgver}-*.pkg.tar.zst` ﻱﺃ ﻑﺬﺤﻳ

 so a stale package can't be mistaken for this build.
5. Runs `makepkg -p 

 --nodeps --noconfirm --needed
   --cleanbuild --force --check

BUILDDIR

SRCDEST

build/artifacts/`
   and   in   /   with   `build/dist/`  ` with `  `/`  ` in ` `PKGDEST` in `build/dist/`. Extra arguments are forwarded to `makepkg`;
`MAKEPKG_FLAGS` (ﺪﺼﻗ ﻦﻋ ﺕﺎﻤﻠﻜﻟﺍ ﻢﻴﺴﻘﺗ ﻢﺗ) ﺔﻴﺿﺍﺮﺘﻓﻻ﻿ﺍ ﺕﺎﻣﻼ﻿ﻌﻟﺍ ﺔﻋﻮﻤﺠﻣ ﺯﻭﺎﺠﺘﻳ.
6. ﺍﺫﺇ ﻪﻴﻠﻋ namcap ﻞّﻐﺸﻳ ﻢﺛ ،ﻂﺒﻀﻟﺎﺑ ﺪﺣﺍﻭ `.pkg.tar.zst` ﻖﺑﺎﻄﺗ ﺍﺫﺇ ﻻ﻿ﺇ
   installed.

Outputs:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```

##                                                                      ﺎًﻓﺍﺪﻫﺃ ﻊﺿ

| Target | Effect |
| --- | --- |
|  `namcap` `make build` (alias `make package`) | run `tools/sh/pkgbuild_local.sh` → `build/` |
| `make install` (alias `make install-package`) | `sudo pacman -U`                                                             ﻲﻓ ﺓﺪﺣﺍﻮﻟﺍ ﺔﻣﺰﺤﻟﺍ`build/dist/`                                           | 1 ﻂﺒﻀﻟﺎﺑ ﺩﺪﻌﻟﺍ ﻦﻜﻳ ﻢﻟ ﺍﺫﺇ ءﺎﻄﺧﺃ ;
| `make validate` | `tools/sh/validate.sh`: shellcheck + `bash -n` + PKGBUILD metadata sync + `makepkg --printsrcinfo` per PKGBUILD + `git diff --check` |
| `make lint` (alias `make lint-shell`) | shellcheck over `tools`, `packaging/arch/common`, `src` (`SC1090`, `SC2034`, `SC2154` disabled), `bash -n`, `git diff --check` |
| `make spellcheck` | `cspell --config cspell.json .` if `cspell` is installed, otherwise skipped |
| `make clean` | `rm -rf build/` |
| `make help` | target list (default goal) |

make install ﻞّﻐﺸﻳ CI ﻲﻓ ءﻲﺷ ﻻ﻿ ؛make build ﻭ `make validate` ﻦﻣ ﻞ
                                                                         ﺮﻈﻧﺍ)[                                                              ﺔﻓﻭﺮﻌﻤﻟﺍ ﺕﺍﺮﻐﺜﻟﺍ](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)).

## Prerequisites

An Arch-based system with  make install  `make build`  `make install` `make`, `git`, `gnupg` and the `base-devel` group:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```

- `pacman-contrib` provides `updpkgsums` (regenerates PKGBUILD checksums).
- `shellcheck` ﻭ ﻉﺩﻮﺘﺴﻤﻟﺎﺑ ﺔﺻﺎﺨﻟﺍ ﺔﻓﺪﺼﻟﺍ ﺕﺎﺘﺑﺮﻜﺳ ﺔﺤﺻ ﻦﻣ ﻖﻘﺤﺘﻳArch ﺔﻛﺮﺘﺸﻤﻟﺍ
  packaging functions.
- Optional: `namcap` (package
          .ﺎﻬﻨﻣ ﻞﻛ ﺖﻴﺒﺜﺘﺑ CI ﻡﻮﻘﻳ .(ﻲﻠﺤﻣ ﻲﺋﻼ﻿ﻣﺇ ﻖﻗﺪﻣ) cspell ﻭ (ﻲﺠﻣﺮﺒﻟﺍ ﻖﻴﻗﺪﺘﻟﺍ
