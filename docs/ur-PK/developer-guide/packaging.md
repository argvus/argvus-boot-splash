---
title: پیکیجنگ
description: ۔ﺲﭩﮔﺭﺎﭨ ﮏﯿﻣ ﺭﻭﺍ ،ﻦﺋﻻ﻿ ﭗﺋﺎﭘ ﮉﻠﺑ ،ﺎﭩﯾﮈ ﺎﭩﯿﻣ ﺞﯿﮑﯿﭘ ﭺﺭﺁ
---

# پیکجنگ

          ﮧﮐﺮﺘﺸﻣ ،PKGBUILDs ﻭﺩ :ﮯﮨ ﯽﺗﺎﺟ ﯽﮐ ﮯﺴﯿﮐ ﺭﺍﻭﺍﺪﯿﭘ ﺭﻭﺍ ﻒﯾﺮﻌﺗ ﯽﮐ ﺞﯿﮑﯿﭘ ﭺﺭﺁ
                         ۔ﺲﭩﮔﺭﺎﭨ ﮏﯿﻣ ﺭﻭﺍ ﻦﺋﻻ﻿ ﭗﺋﺎﭘ ﮉﻠﺑ ﻞﮐﻮﻟ ،ﺲﮑُﮨ ﻝﺎﭩﺴﻧﺍ ،ﺰﻨﺸﮑﻨﻓ

                                                       ﮟﯿﮭﮑﯾﺩ ﮯﯿﻟ ﮯﮐ ﻉﻮﺿﻮﻣ ﺩﻮﺧ[                                                                ﺮﭽﮑﯿﭩﯿﮐﺭﺁ ﻢﯿﮭﺗ](/docs/argvus-boot-splash/developer-guide/theme/)                                                               ﺭﻭﺍ CI ،ﻖﯾﺪﺼﺗ ;
                                                                  ﮟﯿﮭﮑﯾﺩ ﺰﯿﻠﯾﺭ[                                                             ﺯﺰﯿﻠﯾﺭ ﺭﻭﺍ ﯽﺋﺁ ﯽﺳ](/docs/argvus-boot-splash/developer-guide/ci-releases/).

##                                                         ﮈﻮﻠﯿﭘ ﮏﯾﺍ ،PKGBUILD ﻭﺩ

`packaging/arch/remote/PKGBUILD` ﺭﻭﺍ `packaging/arch/local/PKGBUILD` ﮟﯿﮨ ﮯﺴﯿﺟ ﮏﯾﺍ
سوائے `source=` کے:

| | `local` | `ci` |
| --- | --- | --- |
| ماخذ | `${pkgname}-${pkgver}.tar.gz` (`make build` کے ذریعے بنایا گیا) | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| کی طرف سے استعمال کیا جاتا ہے | ڈویلپرز، `make build` | GitHub ایکشن ریلیز |

                 ﺭﻭﺍ ،ﮟﯿﮨ ﮯﺗﺮﮐ ﻝﺎﮐ ﻮﮐ ﺰﻨﺸﮑﻨﻓ ﯽﮨ ﮏﯾﺍ ﮯﺳ `packaging/arch/common/functions.sh` ﮞﻮﻧﻭﺩ
`tools/sh/validate.sh` اپنے میٹا ڈیٹا کا دعویٰ کرتا ہے (`pkgname`, `pkgver`, `pkgrel`،
`pkgdesc`، `arch`، `license`، `depends`، `makedepends`، `options`) ایک جیسا ہے،
                                       ۔ﮯﺘﮑﺳ ﮟﯿﮩﻧ ﮧﺑ ﮯﺳ ﯽﺷﻮﻣﺎﺧ ﮞﻮﻧﻭﺩ ﮧﯾ ﮯﯿﻟ ﺱﺍ

مشترکہ میٹا ڈیٹا:

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

##                                                                   ﻝﺎﻌﻓﺍ ﮧﮐﺮﺘﺸﻣ

`packaging/arch/common/functions.sh` ﮟﯿﮨ ﮯﺗﺮﮐ ﻝﺎﻤﻌﺘﺳﺍ ﮞﻮﻧﻭﺩ ﻮﺟ ﮯﮨ ﺎﺗﺮﮐ ﻢﮨﺍﺮﻓ ﻦﺸﮑﻨﻓ ﻦﯿﺗ
PKGBUILDs:

- `arch_normalize_source_tree` (`prepare()`) — GitHub ﮟﯿﻟﺎﮑﻧ ﺯﻮﯿﺋﺎﮐﺭﺁ ﮓﯿﭨ
`<repo>-v<version>`، ﮯﮨ ﺎﺗﺎﺟ ﻻ﻿ﺎﮑﻧ ﻮﮐ ﻝﺎﺑﺭﺎﭨ ﻞﮐﻮﻟ ﮧﮑﺒﺟ
`<pkgname>-<pkgver>`ﮯﮨ ﺎﺘﯾﺩ ﻝﺪﺑ ﻡﺎﻧ ﺎﮐ ﯼﺮﭩﮑﯾﺮﺋﺍﮈ ﮯﮐ ﺢﻄﺳ ٰﯽﻠﻋﺍ ﺪﺣﺍﻭ ﮧﯾ ۔
`${srcdir}/${pkgname}-${pkgver}`، ﮯﮨ ﺎﮨﺭ ﮮﺩ ﺭﺮﯾﺍ ﻮﺗ ﻮﮨ ﮧﻠﺌﺴﻣ ﮟﯿﻣ ﯼﺮﭩﮑﯾﺮﺋﺍﮈ ﺱﺭﻮﺳ ﺮﮔﺍ
                                         ۔ﮯﮨ ﺩﻮﺟﻮﻣ ﮯﺳ ﮯﻠﮩﭘ ﻝﺰﻨﻣ ﺎﯾ ،ﻢﮩﺒﻣ ،ﺐﺋﺎﻏ
- `arch_check_splash_payload` (`check()`) — ﮯﮨ ﺎﺗﺎﻨﺑ ﯽﻨﯿﻘﯾ ﻮﮐ ﯽﮔﺩﻮﺟﻮﻣ ﯽﮐ ﭧﺴﺳﺍ ﻢﯿﮭﺗ
                           ﺖﺳﺮﮩﻓ ؛ﮯﮨ "ﭧﺋﻮﺳ ﭧﺴﯿﭨ" ﺪﺣﺍﻭ ﺎﮐ ﺞﯿﮑﯿﭘ ﮧﯾ ۔ﺬﺧﺎﻣ ﮦﺫﻮﺧﺎﻣ
                                                          ﮟﯿﮨ ﮟﯿﻣ ﮟﯿﻠﺋﺎﻓ ﯼﺭﻭﺮﺿ[                                                            ﺖﺳﺮﮩﻓ ﯽﮐ ﺕﺎﺟ ﮧﺛﺎﺛﺍ](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory).
- `arch_package_splash_payload` (`package()`) — `src/usr` ﮯﮨ ﺎﺘﻠﭼ ﮫﺗﺎﺳ ﮯﮐ
`find -print0` ﻮﮐ ﻞﺋﺎﻓ ﺮﮨ ﺭﻭﺍ `install -Dm644` ﮫﺗﺎﺳ ﮯﮐ `$pkgdir` ﮯ
(NUL-ﮯﮨ ﺎﺗﺮﮐ ﻡﺎﮐ ﮫﺗﺎﺳ ﮯﮐ ﮞﻮﮩﮕﺟ ﯽﻟﺎﺧ ﮟﯿﻣ ﮞﻮﻣﺎﻧ ،ﻅﻮﻔﺤﻣ)، ﺮﮭﭘ `LICENSE` ﮯ
`/usr/share/licenses/argvus-boot-splash/LICENSE`.

ﮯﮨ ﮫﭽﮐ ﺐﺳ :ﮯﮨ ﮟﯿﮩﻧ ﺩﻮﺟﻮﻣ ﻝﺎﮐ `make install` ﺭﺪﻧﺍ ﮯﮐ `package()` ﮧﮐ ﮟﯾ
`install -Dm*`، ۔ﮯﮨ ﮧﻧﺎﺘﺳﻭﺩ ﮯﯿﻟ ﮯﮐ ﮉﻠﺑ ﺲﯿﻟ ﭦﻭﺭ ﺭﻭﺍ ﺭﺎﺘﺨﻣ ﺩﻮﺧ ﺞﯿﮑﯿﭘ ﺍﺬﮩﻟ
ﺎﯿﮐ ﺍﺪﯿﭘ make install ﮯﻧ ﺲﺟ `package()` ﺎﻧﺍﺮﭘ ﮏﯾﺍ — ﮯﮨ ﺮﮐ ﮫﺟﻮﺑ ﻥﺎﺟ
 `make install` `sudo`/`libfakeroot.so` ۔ﮞﺎﯿﻣﺎﮐﺎﻧ

##                                                                   ﮟﯾﺮﮐ ﺐﺼﻧ ﺲﮑﮨ

`packaging/arch/{ci,local}/argvus-boot-splash.install` (ﮞﺎﺴﮑﯾ):

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`،
           a ﮧﻧﺭﻭ ،dracut --regenerate-all ﮧﻧﺭﻭ ،ﻮﮨ ﺏﺎﯿﺘﺳﺩ ﺮﮔﺍ `mkinitcpio -P` ﺮﮭﭘ
              ۔ﮦﺎﺒﺘﻧﺍ ﮯﺋﻮﮨ ﮯﺘﯾﺩ ﺖﯾﺍﺪﮨ ﯽﮐ ﮯﻧﺮﮐ ﺮﯿﻤﻌﺗ ﮦﺭﺎﺑﻭﺩ ﺮﭘ ﺭﻮﻃ ﯽﺘﺳﺩ ﻮﮐ ﻑﺭﺎﺻ
-  `dracut --regenerate-all` `post_remove()` → ﺎﯿﮔ ﺎﯿﮐ ﮟﯿﮩﻧ ﻞﯾﺪﺒﺗ ﺲﭘﺍﻭ ﻉﻮﺿﻮﻣ ؛ﻡﺎﻐﯿﭘ ﯽﺗﺎﻣﻮﻠﻌﻣ ﻑﺮﺻ
                                  ۔(ﻅﻮﻔﺤﻣ ﮦﺩﺎﯾﺯ ﮯﺳ ﮯﻧﺎﮕﻟ ﮦﺯﺍﺪﻧﺍ) ﺮﭘ ﺭﻮﻃ ﺭﺎﮐﺩﻮﺧ

##                                                        ﻦﺋﻻ﻿ ﭗﺋﺎﭘ ﺎﮐ ﺮﯿﻤﻌﺗ ﯽﻣﺎﻘﻣ

`tools/sh/pkgbuild_local.sh` (`make build` ﺎﯿﮔ ﺎﯾﻼ﻿ﺑ ﮯﻌﯾﺭﺫ ﮯﮐ):

1. تصدیق کرتا ہے `makepkg`, `sha256sum`, `tar`, `awk`, `find` اور PKGBUILD
ﮮﺮﮐ ﻖﯾﺪﺼﺗ ﯽﮐ ﮞﻮﻧﻭﺩ ﺭﻭﺍ ﮯﮬﮍﭘ ﻮﮐ `pkgname`/`pkgver` ﮧﮐﺎﺗ ﮯﮨ ﺎﺗﺮ
       (ﻥﮊﺭﻭ ﺭﺍﺩ ﮧﻄﻘﻧ ﮏﯾﺍ ،`^[a-z0-9@._+-]+$` ﮯﯿﻟ ﮯﮐ ﻡﺎﻧ) ﻑﻼ﻿ﺧ ﮯﮐ ﺲﮑﯿﺠﯾﺭ ﭧﺴﻟ ﺅﻻ﻿ﺍ
                                                           ۔(ﮧﻧﻮﻤﻧ ﮯﯿﻟ ﮯﮐ ﮯﺨﺴﻧ
2. `build/artifacts/${pkgname}-${pkgver}.tar.gz` ﮯﮨ ﺎﺗﺮﮐ ﺭﺎﯿﺗ ﮫﺗﺎﺳ ﮯﮐ
`tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner`
،ﻦﯿﻌﺘﻣ ﮏﯾﺍ — `--transform "s#^\./#${pkgname}-${pkgver}/#"` ﺭﻭﺍ
   دوبارہ پیدا کرنے کے قابل محفوظ شدہ دستاویزات. اس میں `.git`، `build/`، `dist/`، `target/`،
   `tools/`، `release`/`packages-repo` سکریچ ڈائر، اور کوئی بھی `src/`، `pkg/` یا
                                    ۔ﺞﯿﮑﯿﭘ ﮯﺋﻮﮨ ﮯﭽﺑ ﺭﺪﻧﺍ ﮯﮐ ﺰﯾﺮﭩﮑﯾﺮﺋﺍﮈ ﮓﻨﺠﯿﮑﯿﭘ
3.                                                       ﮯﮨ ﺎﺗﺎﮕﻟ ﺏﺎﺴﺣ ﺎﮐ ﻮﯿﺋﺎﮐﺭﺁ`sha256`                                                          ﮯﮨ ﺎﺗﺮﮐ ﻞﺧﺍﺩ ﮯﺳﺍ ﺭﻭﺍ`sed`                                                               ﮟﯿﻣ ﯽﺿﺭﺎﻋ** ﮏﯾﺍ
(ﯽﺌﮔ ﯼﺩ ﺎﭩﮨ ﮯﺳ ﺐﻧﺎﺟ ﯽﮐ `.PKGBUILD.local.XXXXXX`, `EXIT`) ﯽﭘﺎﮐ ﯽﮐ PKGBUILD
ﮟﯿﮩﻧ ﯽﮭﺒﮐ SKIP ؛ﮯﮨ ﺎﺘﮭﮐﺭ ﯽﻟﺎﺧ ﻮﮐ `sha256sums=()` ﮧﺸﯿﻤﮨ ﮦﺮﯿﺧﺫ ۔(
   استعمال کیا جاتا ہے
4. ﮦﺩﻮﺟﻮﻣ ﯽﮭﺑ ﯽﺴﮐ ﮯﺳ  `SKIP` `${pkgname}-${pkgver}-*.pkg.tar.zst` ﮯﮨ ﺎﺗﺮﮐ ﻑﺬﺣ ﻮﮐ
`build/dist/` ۔ﮯﺋﺎﺟ ﺎﮭﺠﻤﺳ ﮧﻧ ﻂﻠﻏ ﮯﯿﻟ ﮯﮐ ﮉﻠﺑ ﺱﺍ ﻮﮐ ﺞﮑﯿﭘ ﯽﻧﺍﺮﭘ ﮏﯾﺍ ﮧﮐﺎﺗ
5. ` with ` ﮯﮨ ﺎﺗﻼ﻿ﭼ
`/` with ` in `/SRCDEST in `build/arti
   اور `PKGDEST` میں `build/dist/`۔ اضافی دلائل `makepkg` کو بھیجے جاتے ہیں۔
`MAKEPKG_FLAGS` ۔(ﮯﮨ ﺎﯿﮔ ﺎﯿﮐ ﻢﯿﺴﻘﺗ ﻮﮐ ﻅﺎﻔﻟﺍ ﺮﮐ ﮫﺟﻮﺑ ﻥﺎﺟ) ﮯﮨ ﺎﺗﺮﮐ ﮉﯿﺋﺍﺭ ﺭﻭﻭﺍ
6. ﺮﮔﺍ ﮯﮨ ﺎﺘﻠﭼ namcap ﺮﭘ ﺱﺍ ﺮﮭﭘ ،ﮯﺋﺎﮭﮐ ﮧﻧ ﻞﯿﻣ `.pkg.tar.zst` ﮏﯾﺍ ﻞﮑ
   نصب

آؤٹ پٹ:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```

##                                                                   ﮟﯿﺋﺎﻨﺑ ﻑﺍﺪﮨﺍ

| ہدف | اثر |
| --- | --- |
|  `namcap` `make build` (alias `make package`) | run `tools/sh/pkgbuild_local.sh` → `build/` |
| `make install` (alias `make install-package`) | `sudo pacman -U`                                                              ﮟﯿﻣ ﺞﯿﮑﯿﭘ ﯽﮨ ﮏﯾﺍ`build/dist/`                                          | ﮞﺎﯿﻄﻠﻏ ﻮﺗ ﻮﮨ ﮧﻧ 1 ﻞﮑﻟﺎﺑ ﯽﺘﻨﮔ ﺮﮔﺍ ;
| `make validate` | `tools/sh/validate.sh`: shellcheck + `bash -n` + PKGBUILD میٹا ڈیٹا مطابقت پذیری + `makepkg --printsrcinfo` فی PKGBUILD + `git diff --check` |
| `make lint` (عرف `make lint-shell`) | شیل چیک اوور `tools`, `packaging/arch/common`, `src` (`SC1090`, `SC2034`, `SC2154` غیر فعال), `bash -n`, `git diff --check` |
| `make spellcheck` | `cspell --config cspell.json .` اگر `cspell` انسٹال ہے، بصورت دیگر چھوڑ دیا جائے گا
| `make clean` | `rm -rf build/` |
| `make help` | ہدف کی فہرست (پہلے سے طے شدہ مقصد) |

CI `make validate` اور `make build` چلاتا ہے۔ CI میں کچھ بھی نہیں چلتا ہے `make install`
                                                                       ﮟﯿﮭﮑﯾﺩ)[                                                                     ﺕﻼ﻿ﺧ ﺭﻮﮩﺸﻣ](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)).

## شرطیں

`make`، `git`، `gnupg` ﺭﻭﺍ `base-devel`

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```

- `pacman-contrib` `updpkgsums` ﮯﮨ ﺎﺗﺮﮐ ﻢﮨﺍﺮﻓ (PKGBUILD ﮯﮨ ﺎﺗﺮﮐ ﺭﺎﯿﺗ ﮦﺭﺎﺑﻭ
- `shellcheck` ﮯﮨ ﺎﺗﺮﮐ ﻖﯾﺪﺼﺗ ﯽﮐ ﮎﺭﺁ ﮧﮐﺮﺘﺸﻣ ﺭﻭﺍ ﺲﭩﭘﺮﮑﺳﺍ ﻞﯿﺷ ﯼﺮﭩﯾﺯﻮﭙﯾﺭ
  پیکیجنگ کے افعال
- اختیاری: `namcap` (پیکیج
            .ﮯﮨ ﺎﺗﺮﮐ ﻝﺎﭩﺴﻧﺍ ﻮﮐ ﺐﺳ ﻥﺍ CI .(ﭻﻧﺎﺟ ﯽﮐ ﮯﺠﮨ ﯽﻣﺎﻘﻣ) cspell ﺭﻭﺍ (ﮓﻨﭩﻨِﻟ
