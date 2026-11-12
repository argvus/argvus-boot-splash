---
title: CI والإصدارات
description:                             .ﺭﺍﺪﺻﻹ﻿ﺍ ﻞﻤﻋ ﺮﻴﺳﻭ ،ﻊﻴﻗﻮﺘﻟﺍ ،ﺮﻤﺘﺴﻤﻟﺍ ﻞﻣﺎﻜﺘﻟﺍ ،ﻖﻘﺤﺘﻟﺍ
---

#                                                      ﺕﺍﺭﺍﺪﺻﻹ﻿ﺍﻭ ﺮﻤﺘﺴﻤﻟﺍ ﻞﻣﺎﻜﺘﻟﺍ

                       ﻭ ﺭﺍﺪﺻﻹ﻿ﺍ ﺐﻴﺑﺎﻧﺃ ﻂﺧ ،ﺮﻤﺘﺴﻤﻟﺍ ﻞﻣﺎﻜﺘﻟﺍ ﻒﺋﺎﻇﻭ ،ﻖﻘﺤﺘﻟﺍ ﺔﺑﺍﻮﺑ
قواعد الإصدار.

                                                             ﺮﻈﻧﺍ ﺎﻬﺴﻔﻧ ﺔﻣﺰﺤﻠﻟ[                                                                       ﻒﻴﻠﻐﺘﻟﺍ](/docs/argvus-boot-splash/developer-guide/packaging/)                                                               ﻉﻮﺿﻮﻤﻟﺍ ﺔﻳﺅﺮﻟ ;
[                                                                 ﻉﻮﺿﻮﻤﻟﺍ ﺔﺳﺪﻨﻫ](/docs/argvus-boot-splash/developer-guide/theme/).

## التحقق من الصحة

`tools/sh/validate.sh` ﺔﺑﻮﻠﻄﻤﻟﺍ ﺔﺑﺍﻮﺒﻟﺍ ﻮﻫ:

-                 ؛`bash`، `makepkg`، `shellcheck` ﺐﻠﻄﺘﻳ
- `shellcheck` + `bash -n` على `tools/sh/*.sh` و`packaging/arch/common/*.sh`؛
- ﺔﻴﻠﺤﻣﻭ ﺓﺪﻴﻌﺑ ﻥﻮﻜﺗ ﻥﺃ ﺐﺠﻳ — ﺔﺟﺮﺨﺘﺴﻤﻟﺍ ﺔﻴﻔﺻﻮﻟﺍ ﺕﺎﻧﺎﻴﺒﻟﺍ ﻥﺭﺎﻘﺗﻭ PKGBUILDs ﻦﻣ ﻞﻛ ﺭ
  مباراة؛
- `makepkg -p PKGBUILD --printsrcinfo` ﻞﺧﺍﺩ `ci/` ﻭ `local/` (ﻞﻴﻠﺤﺘﺑ ﻡﻮﻘﻳ
                                            ;(makepkg ﺎﻬﻠﻌﻔﻳ ﻲﺘﻟﺍ ﺔﻘﻳﺮﻄﻟﺎﺑ ﻒﻠﻣ
- `git diff --check` (ﻉﺍﺮﺼﻟﺍ ﺕﺎﻣﻼ﻿ﻋ/ءﺎﻀﻴﺑ ﺕﺎﻓﺎﺴﻣ).

## ﺮﻤﺘﺴﻤﻟﺍ ﻞﻣﺎﻜﺘﻟﺍ

 (push/PR to

, `.github/workflows/ci.yml` base-devel git namcap pacman-contrib shellcheck sudo  archlinux:latest  `main`  container):

1. install

;
2.  `archlinux:latest`  `base-devel git namcap pacman-contrib shellcheck sudo` `make validate`;
3. build as an **unprivileged**

 user
   (

) — makepkg refuses to run
   as root, and the workspace is

ed first;
4. .`builder` ﻡﺍﺪﺨﺘﺳﺎﺑ `sudo -u builder env HOME=/home/builder make build` `chown`  ﻞﻴﻐﺸﺗ ﻰﻠﻋ `spellcheck` ﺔﻠﺼﻔ

 cspell.json  `cspell-action@v6`  `cspell.json` `namcap`                                                                  ﻞﺧﺍﺪﻟﺎﺑ ﻱﺮﺠﻳ`pkgbuild_local.sh`                                        ﺔﻴﻠﺤﻤﻟﺍ ﺕﺎﻴﻨﺒﻟﺍ ﺮﻬﻈﺗ ﺚﻴﺤﺑ ،ﺖﻴﺒﺜﺘﻟﺍ ﺪﻨﻋ
ﻞﻤﻌﻟﺍ ﺔﺣﺎﺴﻣ ﻊﻣ `cspell.json` ﻮﻫ ﻲﺋﻼ﻿ﻣﻹ﻿ﺍ ﻖﻴﻗﺪﺘﻟﺍ ﻦﻳﻮﻜﺗ .CI ﻞﺜﻣ ﺪﻋﺍﻮﻘﻟﺍ ﻦﻣ ﻖﻘ
                              ﺓﺪﻳﺪﺟ ﺔﻴﻨﻘﺗ ﺕﺎﺤﻠﻄﺼﻣ — `.cspell/custom-dictionary-workspace.txt` ﻲﻓ ﺱﻮﻣﺎﻗ
 .ﺮﻤﺘﺴﻤﻟﺍ ﻞﻣﺎﻜﺘﻟﺍ ﻞﺸﻔﻴﺳ ﻻ﻿ﺇﻭ ،ﺱﻮﻣﺎﻘﻟﺍ ﻚﻟﺫ ﻰﻟﺇ ﻲﻤﺘﻨﺗ (ﺕﺍﻭﺩﻷ﻿ﺍ ءﺎﻤﺳﺃ ،ﺔﻓﺪﺼﻟﺍ ﻡﻼ﻿ﻋﺃ)

##                                                                ﺮﺸﻨﻟﺍ ﺐﻴﺑﺎﻧﺃ ﻂﺧ

`.github/workflows/release.yml` — ﻢﺳﻭ ﻊﻓﺩ :ﺮﻴﺜﻳ `v*`، ﻭﺃ
`workflow_dispatch` ﻦﻣﺍﺰﺘﻟﺍ ﺔﻋﻮﻤﺠﻣ .(ﺎﻬﺑ ﻢﻜﺤﺘُﻣ ءﺎﻨﺑ ﺓﺩﺎﻋﺇ) ﺩﻮﺟﻮﻣ ﻢﺳﻭ ﻊﻣ
`release-<ref>`، ءﺎﻐﻟﺇ ﺪﺟﻮﻳ ﻻ﻿.

خطوات:

1.                             .(`inputs.tag` ﻡﺪﺨﺘﺴﻳ ﻊﻳﺯﻮﺘﻟﺍ) ﻢﺳﻮﻟﺍ **ﺺﺤﻓﺍ**
2.                                     ﻞﺑﺎﻘﻣ ﺔﻣﻼ﻿ﻌﻟﺍ ﺔﺤﺻ ﻦﻣ ﻖﻘﺤﺘﻳ :**ﺭﺍﺪﺻﻹ﻿ﺍ ﺓﻮﻄﺧ**
`^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$`، ﺖﻧﺎﻛ ﺍﺫﺇ ﻞﺸﻔﻳ `url` ﻲﻓ ﺔﻏﺭﺎﻓ
`packaging/arch/remote/PKGBUILD`، ﺔﺑﺎﺘﻛ ﺪﻴﻌﻳ ﻢﺛ `pkgver` ﻢﺳﻮﻟﺍ ﻦﻣ.
3. **التحقق**: `make validate`.
4. ( ﻰﻠﻋ ﻕﺩﺎﺼﻳﻭ ﻞﺤﻳ) `builder`: `updpkgsums` ﺰﻴﻤﺘﻣ ﺮ
                                                ﻢﺛ (`sha256sums` ﻲﻘﻴﻘﺣ
`makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`.
                               .ﺍًﺩﻮﺟﻮﻣ ﻦﻜﻳ ﻢﻟ ﺍﺫﺇ ﻞﺸﻔﻳﻭ `.pkg.tar.zst` ﺩﺪﺤﻳ
5.                                                         .ﺓﻮﺒﻌﻟﺍ ﻰﻠﻋ **ﺏﺎﻜﻣﺎﻧ**
6. ,mktemp -d) ﺓﺪﺣﺍﻭ ﺓﺮﻣ ﻡﺍﺪﺨﺘﺳﻼ﻿ﻟ GNUPGHOME ﻰﻟﺇ `GPG_PRIVATE_KEY`
ﻭﺃ ﺮﻴﺼﻘﻟﺍ ﻑﺮﻌﻤﻟﺍ)  mktemp -d  `GNUPGHOME`  `mktemp -d` `GPG_KEY_ID` ﻖﺑﺎﻄﻳ ﺩﺭﻮﺘﺴﻤﻟﺍ ﻱﺮﺴﻟﺍ ﺡﺎﺘﻔﻤﻟﺍ ﻥﺃ ﻦﻣ ﻖﻘﺤﺘﻳ ،
                                ﻊﻣ ﺔﻠﺼﻔﻨﻣ `.sig` ﺊﺸﻨُﺗﻭ ،(ﻊﺒﺻﻹ﻿ﺍ ﺔﻤﺼﺑ
`--pinentry-mode loopback --passphrase-fd 0`.
7.             ﺍﺫﺇ ﺔﻴﻠﻤﻌﻟﺍ ﻞﺸﻔﺗ — ﺪﻳﺪﺠﻟﺍ `GNUPGHOME` ﻲﻓ **ﻊﻴﻗﻮﺘﻟﺍ ﻦﻣ ﻖﻘﺤﺗ**
                                                     .ﻪﻨﻣ ﻖﻘﺤﺘﻟﺍ ﻢﺘﻳ ﻻ﻿ ﻊﻴﻗﻮﺘﻟﺍ
8.                 + ﺔﻣﺰﺤﻟﺍ ,`upload-artifact@v4`, `retention-days: 1`) **ﺮﺛﻷ﻿ﺍ ﻞﻴﻤﺤﺗ**
                                                  .(`if-no-files-found: error` ،ﻊﻴﻗﻮﺘﻟﺍ
9.              ـﻟﺍ ﺦﺴﻧﺍ ،PACKAGES_REPO_TOKEN ﻊﻣ `argvus/packages` ﻦﻣ ﻖﻘﺤﺗ :**ﺮﺸﻧ**
                       ﻞﻴﻐﺸﺗ ،`PACKAGES_REPO_TOKEN` ﻰﻟﺇ `.sig` ﻭ ﻡﺰﺣ
    `public/arch/x86_64` `repo-add -R argvus.db.tar.gz <pkg>`، ﻊﻴﻗﻮﺗ `argvus.db.tar.gz`،
`argvus.files.tar.gz` ﻭ `argvus.db` ﻭ `argvus.files`، ـﻛ ﻡﺍﺰﺘﻟﻻ﻿ﺍ ﻢﺛ
`github-actions[bot]` ﻡﺍﺰﺘﻟﻻ﻿ﺍ ﻥﻭﺩ 0 ﺝﺮﺨﻳ ﺮﻴﻴﻐﺗ ﻼ﻿ﺑ ﻕﺮﻓ .ﻂﻐﺿﺍﻭ.
10.                        ﺓﺪَّﻟﻮﻤﻟﺍ ﺕﺎﻈﺣﻼ﻿ﻤﻟﺍ ﻊﻣ GitHub**: `softprops/action-gh-release@v2` ﺭﺍﺪﺻﺇ**
.ﻝﻮﺻﺄﻛ ﻊﻴﻗﻮﺘﻟﺍ + ﺩﺮﻄﻟﺍﻭ

##                                             ﺭﺍﺮﺳﻷ﻿ﺍﻭ ﻊﻴﻗﻮﺘﻟﺍ ،ﻉﻮﻤﺠﻤﻟﺍ ﻦﻣ ﻖﻘﺤﺘﻟﺍ

- ءﺎﻨﺒﻟﺍ ﺪﻨﻋ ﺔﺑﻮﺴﺤﻣ ،ﺔﻴﻘﻴﻘﺣ ﺔﺻﻼ﻿ﺧ ﺎًﻤﺋﺍﺩ `SKIP`: `sha256sums` ﺪﺟﻮﻳ
                           .(CI ﺭﺍﺪﺻﺇ) `updpkgsums` ﺮﺒﻋ ﻭﺃ (ﻲﻠﺤﻤﻟﺍ) ﺖﻗﻮﻟﺍ
-                                  .ﻉﺩﻮﺘﺴﻤﻟﺍ ﻲﻓ **ﺎًﻏﺭﺎﻓ** `sha256sums=()` ﻙﺮﺗﺍ
-        ،`.sig`، `argvus.db.tar.gz` ﺔﻣﺰﺤﻟﺍ) GPG ﺔﻄﺳﺍﻮﺑ ﺔﻌﻗﻮﻣ ﺕﺍﺭﺍﺪﺻﻹ﻿ﺍ
`argvus.files.tar.gz`، `argvus.db`، `argvus.files`).
-          .ﺔﻏﺭﺎﻓ ﺭﻭﺮﻣ ﺓﺭﺎﺒﻋ ﻞﻤﻌﻟﺍ ﺮﻴﺳ ﺾﻓﺮﻳ ؛ﺎًﻏﺭﺎﻓ `GPG_PASSPHRASE` ﻥﻮﻜﻳ ﻻ﻿ﺃ ﺐﺠﻳ

تحضير المفتاح:

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```

                   :ﻉﺩﻮﺘﺴﻤﻟﺍ ﻲﻓ **ﺕﺍءﺍﺮﺟﻹ﻿ﺍ → ﺕﺍﺮﻴﻐﺘﻤﻟﺍﻭ ﺭﺍﺮﺳﻷ﻿ﺍ → ﺕﺍﺩﺍﺪﻋﻹ﻿ﺍ** ﻲﻓ

| سر | القيمة |
| --- | --- |
| `GPG_PRIVATE_KEY` | إخراج `gpg --armor --export-secret-keys KEY_ID` |
| `GPG_KEY_ID` | معرف المفتاح المتوقع أو بصمة الإصبع |
| `GPG_PASSPHRASE` | عبارة مرور غير فارغة لمفتاح التوقيع |
| `PACKAGES_REPO_TOKEN` | بات مع `contents:write` على `argvus/packages` |

## ﺭﺍﺪﺻﺇ ﺮﺸﻧ

قبل وضع العلامات:

1.                  :ﻲﻘﻴﻘﺤﻟﺍ ﻉﺩﻮﺘﺴﻤﻟﺎﺑ packaging/arch/remote/PKGBUILD ﻲﻓ `url` ﻸ﻿ﻣﺍ
   - GitHub:  `packaging/arch/remote/PKGBUILD` `url="https://github.com/argvus/argvus-boot-splash"` (ﺭﺪﺼﻤﻟﺍ
                                                    ;(`${url}/archive/refs/tags/v${pkgver}.tar.gz` ﻡﺪﺨﺘﺴﻳ
   - GitLab: ﻂﺒﺿ `source=` ﻰﻟﺇ
`https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz`;
   -                 .ﺔﺤﺿﺍﻭ ﺔﻟﺎﺳﺭ ﻊﻣ **ﺪﺼﻗ ﻦﻋ** ﺭﺍﺪﺻﻹ﻿ﺍ ﻞﺸﻔﻳ ،`url` ﻥﻭﺪﺑ
2.                        ﻭ `packaging/arch/local/PKGBUILD` ﻲﻓ ﺔﻴﻔﺻﻮﻟﺍ ﺕﺎﻧﺎﻴﺒﻟﺍ/ﺕﺍﺭﺍﺪﺻﻹ﻿ﺍ ﺔﻨﻣﺍﺰﻣ
`packaging/arch/remote/PKGBUILD`.
3. العلامة والدفع:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```

ـﻛ ﻞﻌﻔﻟﺎﺑ ﺓﺩﻮﺟﻮﻣ `v*` ﺔﻣﻼ﻿ﻋ ﻡﺍﺪﺨﺘﺳﺎﺑ ﺎًﻳﻭﺪﻳ ﻞﻤﻌﻟﺍ ﺮﻴﺳ ءﺪﺑ ﺎًﻀﻳﺃ ﻦﻜﻤﻳ
                       .ﺎﻬﺑ ﻢﻜﺤﺘُﻣ ءﺎﻨﺑ ﺓﺩﺎﻋﻹ﻿ ﺪﻴﻔﻣ ﻮﻫﻭ ،`tag` ﻝﺎﺧﺩﺇ

## الإصدار

- SemVer ﻲﻓ `pkgver`، ﻲﻓ ﺕﺍﺭﺍﺪﺻﻹ﻿ﺍ ﺩﺪﻋﻭ `pkgrel`.

##                                                             ﺭﻮﻄﻤﻟﺍ ءﺎﻄﺧﺃ ﻞﻴﻠﺤﺗ

ﻭﺃ ،ﺓﺩﻮﻘﻔﻤﻟﺍ ﺔﻣﻼ﻿ﻌﻟﺍ v* ﻭﺃ ،ﻍﺭﺎﻓ `url` **."ﺭﺩﺎﺼﻤﻟﺍ ﻉ
      (GitLab tarball ﻞﺑﺎﻘﻣ GitHub) ﻒﻴﻀﻤﻟﺍ ﻊﻣ ﻖﺑﺎﻄﺘﻳ ﻻ﻿ ﻱﺬﻟﺍ ﻒﻴﺷﺭﻷ﻿ﺍ ﻥﺍﻮﻨﻋ ﻖﻴﺴﻨﺗ
             ﻍﺭﺎﻓ ﺩﻮﺟﻭ ﺪﻨﻋ ﺍًﺮﻜﺒﻣ ﻞﺸﻔﻳﻭ ﺔﻣﻼ﻿ﻌﻟﺍ ﻂﻤﻧ ﻦﻣ ﻞﻤﻌﻟﺍ ﺮﻴﺳ ﻖﻘﺤﺘﻳ .(ﻂﻴﻄﺨﺘﻟﺍ
 `v*` `url`.

**`updpkgsums` ﺎًﻘﺒﺴﻣ ﺎﻬﻌﻓﺩ ﻢﺘﻳ ﻥﺃﻭ ﺓﺩﻮﺟﻮﻣ ﺔﻣﻼ﻿ﻌﻟﺍ ﻥﻮﻜﺗ ﻥﺃ ﺐﺠﻳ **.ﺭﺪﺼﻤﻟﺍ ﻰﻠ
.ﺎﻨﻫ ﻞﺸﻔﻳ ﻂﻘﻓ ﺎًﻴﻠﺤﻣ ﺓﺩﻮﺟﻮﻣ ﺔﻣﻼ﻿ﻌﺑ ﻝﺎﺳﺭﻹ﻿ﺍ ؛ﺭﺍﺪﺻﻹ﻿ﺍ ﺔﻔﻴﻇﻭ ﻞﻴﻐﺸﺗ ﻢ

  **."ﺔﻨﻣﺍﺰﺘﻣ ﺮﻴﻏ ﺔﻴﻠﺤﻤﻟﺍﻭ ﺓﺪﻴﻌﺒﻟﺍ PKGBUILD ﺕﺎﻧﺎﻴﺑ" :`make validate` ﺮﻳﺮﻘﺗ**
.ﺮﺧﻵ﻿ﺍ ﻰﻟﺇ ﺪﺣﺍﻭ PKGBUILD ﻦﻣ (`source=` ﺲﻴﻟﻭ) ﺔﻴﻔﺻﻮﻟﺍ ﺕﺎﻧﺎﻴﺒﻟﺍ ﻝﻮﻘﺣ ﺦﺴﻧﺍ

                             ﻰﻟﺇ ﻪﻔﺿﺃ **.ﺪﻳﺪﺟ ﺢﻠﻄﺼﻣ ﻰﻠﻋ ﻲﺋﻼ﻿ﻣﻹ﻿ﺍ ﻖﻴﻗﺪﺘﻟﺍ ﺭﺬﻌﺘﻳ**
`.cspell/custom-dictionary-workspace.txt` (ﺱﻮﻣﺎﻗ `argvus`، `addWords:
true`), not to `ignorePaths`.

          libfakeroot.so … LD_PRELOAD ﻭﺃ ،make install ﻞﺧﺍﺩ `sudo` ﺐﻠﻃ**
ﻡﺍﺪﺨﺘﺳﻻ﻿ﺍ ﻦﻣ ًﻻ﻿ﺪﺑ `make install` ﻲﻋﺪﺘﺴﻳ ﻱﺬﻟﺍ  `libfakeroot.so … LD_PRELOAD` `package()` ﺞﻣﺎﻧﺮﺑ **. ءﺎﻄﺧ
 `make install` `install -Dm*`. ﻼ﻿ﻛ PKGBUILDs ﻲﻋﺪﺘﺴﻳ `arch_package_splash_payload`، ـﺑ ﻡﻮﻘﻳ ﻱﺬﻟﺍ
                    .`make` ﺔﻤﻟﺎﻜﻣ ﻝﺎﺧﺩﺇ ﺩﺎﻋﺃ ﺪﺣﺃ ﻻ﻿ ﻥﺃ ﻦﻣ ﺪﻛﺄﺗ ؛ﺲﻴﻟ

**`makepkg` ﻱﺩﺎﻋ ﻡﺪﺨﺘﺴﻤﻛ ءﺎﻨﺒﻟﺍ ﻞﻴﻐﺸﺘﺑ ﻢﻗ .ﻝﻭﺆﺴﻤﻛ ﻪﻠﻴﻐﺸﺗ ﻢﺘﻳ ﻻ﻿ﺃ ﺐﺠﻳ **
                                               .`sudo -u <user> make build` ﻭﺃ ،ﻡﺪﺨﺘﺴﻤﻟﺍ

.initramfs ءﺎﻨﺑ ﺓﺩﺎﻋﺇ ﻢﺘﻳ ﻢﻟ **.ﺔﻴﺣﺎﺘﺘﻓﻻ﻿ﺍ ﺎﻬﺘﺷﺎﺷ ﺮﻴﻐﺘﻳ ﻢﻟ ﻦﻜﻟﻭ ﺔﻣﺰﺤﻟﺍ ﺖﻴﺒﺜﺗ ﻢﺗ
ﻭﺃ ،ﻞﻴﻐﺸﺘﻟﺍ ﺓﺩﺎﻋﺇ ﻦﻣ ﺎًﻟﺪﺑ `sudo plymouth --show-splash` ـﺑ ﻞﺼﺗﺍ ،ﻲﻠﺤﻤﻟﺍ ﺭ
                    .`sudo mkinitcpio -P` / `sudo dracut --regenerate-all` ﻡﺍﺪﺨﺘﺳﺎﺑ ءﺎﻨﺒﻟﺍ ﺪﻋﺃ
