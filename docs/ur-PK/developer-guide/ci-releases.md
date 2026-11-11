---
title: CI and Releases
description:                                 ۔ﻮﻠﻓ ﮎﺭﻭ ﺰﯿﻠﯾﺭ ﺭﻭﺍ ،ﻂﺨﺘﺳﺩ ،ﻡﺎﻤﻀﻧﺍ ﻞﺴﻠﺴﻣ ،ﻖﯾﺪﺼﺗ
---

#                                                              ﺯﺰﯿﻠﯾﺭ ﺭﻭﺍ ﯽﺋﺁ ﯽﺳ

                          ﺭﻭﺍ ﻦﺋﻻ﻿ ﭗﺋﺎﭘ ﺰﯿﻠﯾﺭ ،ﺰﺑﺎﺟ ﮯﮐ ﻡﺎﻤﻀﻧﺍ ﻞﻘﺘﺴﻣ ،ﭧﯿﮔ ﯽﻘﯾﺪﺼﺗ
the versioning rules.

                                                        ﮟﯿﮭﮑﯾﺩ ﮯﯿﻟ ﮯﮐ ﺩﻮﺧ ﺞﮑﯿﭘ[                                                                       ﮓﻨﺠﯿﮑﯿﭘ](/docs/argvus-boot-splash/developer-guide/packaging/)                                                          ﮟﯿﮭﮑﯾﺩ ﮯﯿﻟ ﮯﮐ ﻢﯿﮭﺗ ;
[                                                                ﺮﭽﮑﯿﭩﯿﮐﺭﺁ ﻢﯿﮭﺗ](/docs/argvus-boot-splash/developer-guide/theme/).

## Validation

`tools/sh/validate.sh` ﮯﮨ ﭧﯿﮔ ﮧﺑﻮﻠﻄﻣ:

- `bash`، `makepkg`، `shellcheck` ؛ﮯﮨ ﺕﺭﻭﺮﺿ ﯽﮐ
- `shellcheck` + `bash -n` on `tools/sh/*.sh` and `packaging/arch/common/*.sh`;
- ﮟﯿﮨ ﮯﺗﺮﮐ ﮧﻧﺯﺍﻮﻣ ﺎﮐ ﯽﻣﺎﻘﻣ ﺭﻭﺍ ﺯﺍﺭﺩ ﺭﻭﺩ — ﺎﭩﯾﮈ ﺎﭩﯿﻣ ﺎﯿﮔ ﻻ﻿ﺎﮑﻧ ﺭﻭﺍ ﮟﯿﮨ ﮯﺗﺮﮐ ﺵﻼ﻿ﺗ ﻮﮐ
  match;
- `makepkg -p PKGBUILD --printsrcinfo` ﺭﺪﻧﺍ ﮯﮐ `ci/` ﺭﻭﺍ `local/` (ﮯﮨ ﺎﺗﺮﮐ ﮧﯾﺰ
                                ؛ﮯﮨ ﺎﺗﺮﮐ makepkg ﮯﺴﯿﺟ ﮟﯿﺋﺎﻨﺑ ﮯﺳ ﮯﻘﯾﺮﻃ ﮯﺳﺍ ﻞﺋﺎﻓ
- `git diff --check` (ﻥﺎﺸﻧ ﮯﮐ ﻉﺯﺎﻨﺗ/ﺲﯿﭙﺳﺍ ﭧﺋﺍﻭ).

##                                                                   ﻡﺎﻤﻀﻧﺍ ﻞﺴﻠﺴﻣ

`.github/workflows/ci.yml` (`main`، `archlinux:latest` ﺶﭘ ﮟﯿﻣ ﺮﻨﯿﭩﻨﮐ/PR):

1. `base-devel git namcap pacman-contrib shellcheck sudo` ؛ﮟﯾﺮﮐ ﻝﺎﭩﺴﻧﺍ
2. `make validate`;
3. ﻮﮨ **ﮯﮐ ﺭﺎﯿﺘﺧﺍ ﺹﺎﺧ ﯽﺴﮐ ﺮﯿﻐﺑ** ﻮﺟ ﮟﯾﺮﮐ ﺮﯿﻤﻌﺗ ﺮﭘ ﺭﻮﻃ ﮯﮐ ﺭﺯﻮﯾ `builder` ﮯ
   (`sudo -u builder env HOME=/home/builder make build`) — makepkg ﮯﮨ ﺎﺗﺮﮐ ﺭﺎﮑﻧﺍ ﮯﺳ ﮯﻧﻼ﻿ﭼ
                     ؛ﮯﮨ `chown`ed ﮯﻠﮩﭘ ﺲﯿﭙﺳﺍ ﮎﺭﻭ ﺭﻭﺍ ،ﺮﭘ ﺭﻮﻃ ﮯﮐ ﭦﻭﺭ
4. ۔ﮯﮨ ﺎﺗﻼ﻿ﭼ ﮫﺗﺎﺳ ﮯﮐ cspell.json ﻮﮐ cspell-action@v6 ﻡﺎﮐ `spellcheck` 

 cspell.json  `cspell-action@v6`  `cspell.json` `namcap` ﺮﭘ ﮯﻧﻮﮨ ﻝﺎﭩﺴﻧﺍ `pkgbuild_local.sh` ﮟﯿﮨ ﮯﺗﻮﮨ ﺮﮨﺎﻇ ﺯﮉﻠﺑ ﯽﻣﺎﻘﻣ ﮯﯿ
ﮫﺗﺎﺳ ﮯﮐ ﺲﯿﭙﺳﺍ ﮎﺭﻭ ﮯﮨ `cspell.json` ﻦﺸﯾﺮﮕﯿﻔﻨﮐ ﮏﯿﭼ ﻞﯿﭙﺳﺍ ۔CI ﮧﮐ ﺎﺴﯿﺟ ﭧﻨﻟ ﯽﮨﻭ
`.cspell/custom-dictionary-workspace.txt` ﺕﺎﺣﻼ﻿ﻄﺻﺍ ﯽﮑﯿﻨﮑﺗ ﮯﺌﻧ — ﯼﺮﻨﺸﮐﮈ ﮟﯿﻣ
  ۔ﺎﮔ ﮯﺋﺎﺟ ﻮﮨ ﻡﺎﮐﺎﻧ CI ﮧﻧﺭﻭ ،ﮟﯿﺌﮨﺎﭼ ﮯﻧﻮﮨ ﮟﯿﻣ ﺖﻐﻟ ﺱﺍ (ﻡﺎﻧ ﮯﮐ ﻝﻮﭨ ،ﮮﮉﻨﮭﺟ ﮯﮐ ﻞﯿﺷ)

## ﻦﺋﻻ﻿ ﭗﺋﺎﭘ ﺰﯿﻠﯾﺭ

`.github/workflows/release.yml` — ﻞﻣﺍﻮﻋ ﮯﻟﺍﻭ ﮯﻧﺮﮐ ﻝﺎﻌﻓ: `v*` ﺎﯾ ،ﺎﻧﺎﺑﺩ ﯽﮐ ﮓﯿﭨ
`workflow_dispatch` ﭖﻭﺮﮔ ﺮﺼﻋ ﻢﮨ .(ﺮﯿﻤﻌﺗ ﮦﺭﺎﺑﻭﺩ ﮦﺪﺷ ﻝﻭﺮﭩﻨﮐ) ﮫﺗﺎﺳ ﮯﮐ ﮓﯿﭨ ﮦﺩﻮﺟﻮﻣ
`release-<ref>`، ۔ﮟﯿﮩﻧ ﯽﺧﻮﺴﻨﻣ ﯽﺋﻮﮐ

Steps:

1.                     ۔(ﮯﮨ ﺎﺗﺮﮐ ﻝﺎﻤﻌﺘﺳﺍ `inputs.tag` ﭻﯿﭙﺳﮈ) ﮓﯿﭨ **ﭦﺅﺁ ﮏﯿﭼ**
2.                                             ﮯﮨ ﺎﺗﺮﮐ ﻖﯾﺪﺼﺗ ﯽﮐ ﮓﯿﭨ :**ﻡﺪﻗ ﻥﮊﺭﻭ**
`^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$`، ﺮﮔﺍ ﮯﮨ ﺎﺗﺎﺟ ﻮﮨ ﻡﺎﮐﺎﻧ `url` ﻮﮨ ﯽﻟﺎﺧ
`packaging/arch/remote/PKGBUILD`، ﮯﺳ ﮓﯿﭨ ﺮﮭﭘ `pkgver` ۔ﮯﮨ ﺎﺘﮭﮑﻟ ﮦﺭﺎﺑﻭﺩ ﻮﮐ
3. **Validate**: `make validate`.
4. ﮯﮨ ﺎﺗﺮﮐ ﻖﯾﺪﺼﺗ ﺭﻭﺍ ﮯﮨ ﺎﺗﺮﮐ ﻞﺣ) `builder`: `updpkgsums` ﮯﮐ ﺕﺍﺭﺎﯿﺘﺧﺍ
                                                  ﺮﮭﭘ (`sha256sums` ﯽﻘﯿﻘﺣ
`makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`.
`.pkg.tar.zst` ۔ﮯﮨ ﺎﺗﺎﺟ ﻮﮨ ﻡﺎﮐﺎﻧ ﻮﺗ ﻮﮨ ﮧﻧ ﺩﻮﺟﻮﻣ ﯽﺋﻮﮐ ﺮﮔﺍ ﺭﻭﺍ ﮯﮨ ﺎﺗﺎﮕﻟ ﮧﺘﭘ ﺎ
5. **namcap** ۔ﺮﭘ ﺞﯿﮑﯿﭘ
6. **Sign**: imports `GPG_PRIVATE_KEY` into a throwaway `GNUPGHOME` (`mktemp -d`,
ﮯﮨ ﯽﺗﺎﮭﮐ ﻞﯿﻣ ﮫﺗﺎﺳ ﮯﮐ (ﺎﯾ ﺖﺧﺎﻨﺷ ﺮﺼﺘﺨﻣ) `GPG_KEY_ID` ﮧﯾ ﮧﮐ ﮯﮨ ﺎﺗﺮﮐ ﻖﯾﺪﺼﺗ ﯽﮐ
            ﮫﺗﺎﺳ ﮯﮐ ﺲﺟ ﮯﮨ ﺎﺗﺮﮐ ﻖﯿﻠﺨﺗ `.sig` ﮓﻟﺍ ﮏﯾﺍ ﺭﻭﺍ ،(ﭧﻧﺮﭘ ﺮﮕﻨﻓ
`--pinentry-mode loopback --passphrase-fd 0`.
7. ﺮﮔﺍ ﮯﮨ ﯽﺗﺎﺟ ﻮﮨ ﻡﺎﮐﺎﻧ ﺰﯿﻠﯾﺭ — ﮟﯿﻣ `GNUPGHOME` ﮯﺌﻧ ﮏﯾﺍ **ﮟﯾﺮﮐ ﻖﯾﺪﺼﺗ ﯽﮐ ﻂﺨﺘ
                                                    ۔ﯽﮑﺳﻮﮨ ﮟﯿﮩﻧ ﻖﯾﺪﺼﺗ ﯽﮐ ﻂﺨﺘﺳﺩ
8.         + ﺞﯿﮑﯿﭘ ،`upload-artifact@v4`، `retention-days: 1`) **ﮟﯾﺮﮐ ﮈﻮﻠﭘﺍ ﭧﮑﯿﻔﯿﭨﺭﺁ**
                                                    .(`if-no-files-found: error` ،ﻂﺨﺘﺳﺩ
9.   ﮟﯾﺮﮐ ﻞﻘﻧ ،ﮟﯾﺮﮐ ﮏﯿﭼ ﮫﺗﺎﺳ ﮯﮐ PACKAGES_REPO_TOKEN ﻮﮐ `argvus/packages` :**ﺖﻋﺎﺷﺍ**
                   ﮟﯿﺋﻼ﻿ﭼ ،ﮟﯿﻣ `PACKAGES_REPO_TOKEN` ﻮﮐ `.sig` ﺭﻭﺍ ﺞﯿﮑﯿﭘ
    `public/arch/x86_64` `repo-add -R argvus.db.tar.gz <pkg>`، ﻦﺋﺎﺳ `argvus.db.tar.gz`،
`argvus.files.tar.gz`, `argvus.db` ﺭﻭﺍ `argvus.files`، ﮧﮐ ﺎﺴﯿﺟ ﮟﯾﺮﮐ ﭧﯿﻤﮐ 
`github-actions[bot]` ۔ﮯﮨ ﺩﻮﺟﻮﻣ ﺮﭘ 0 ﻕﺮﻓ ،ﮟﯿﮩﻧ ﯽﻠﯾﺪﺒﺗ ﯽﺋﻮﮐ ﮯﯿﮐ ﭧﯿﻤﮐ ﺮﯿﻐﺑ ۔ﮟﯿﺋﺎﺑﺩ ﺭ
10. **GitHub ﺰﯿﻠﯾﺭ**: `softprops/action-gh-release@v2` ﺲﭨﻮﻧ ﮦﺪﺷ ﺭﺎﯿﺗ ﮫﺗﺎﺳ ﮯﮐ
                                        ۔ﺮﭘ ﺭﻮﻃ ﮯﮐ ﮞﻮﺛﺎﺛﺍ ﻮﮐ ﻂﺨﺘﺳﺩ + ﺞﯿﮑﯿﭘ ﺭﻭﺍ

##                                                     ﺯﺍﺭ ﺭﻭﺍ ﺎﻧﺮﮐ ﻂﺨﺘﺳﺩ ،ﺰﻤﺴﮑﯿﭼ

-                                                                   ﮯﮨ ﮟﯿﮩﻧ ﯽﺋﻮﮐ`SKIP`: `sha256sums`                ﮯﮨ ﺎﺗﺎﺟ ﺎﯿﮐ ﺏﺎﺴﺣ ﺖﻗﻭ ﮯﮐ ﮉﻠﺑ ﻮﺟ ،ﮯﮨ ﺎﺗﻮﮨ ﭧﺴﺠﺋﺍﮈ ﯽﻘﯿﻘﺣ ﮏﯾﺍ ﮧﺸﯿﻤﮨ
                         .(CI ﺰﯿﻠﯾﺭ) ﮯﻌﯾﺭﺫ ﮯﮐ `updpkgsums` ﺎﯾ (ﯽﻣﺎﻘﻣ) ﺖﻗﻭ
-                                ۔ﮟﯿﮭﮐﺭ **ﯽﻟﺎﺧ** ﻮﮐ `sha256sums=()` ﮟﯿﻣ ﯼﻭﺭﺰﯾﺭ
- (`.sig`, `argvus.db.tar.gz`,  ﺞﯿﮑﯿﭘ) ﮟﯿﮨ ﮦﺪﺷ ﻂﺨﺘﺳﺩ ﮯ
`argvus.files.tar.gz`، `argvus.db`، `argvus.files`).
- `GPG_PASSPHRASE` ۔ﮯﮨ ﺎﺘﯾﺩ ﺮﮐ ﺩﺮﺘﺴﻣ ﻮﮐ ﺰﯾﺮﻓ ﺱﺎﭘ ﯽﻟﺎﺧ ﮏﯾﺍ ﻮﻠﻓ ﮎﺭﻭ ؛ﮯﯿﮨﺎﭼ ﺎﻧﻮﮨ ﮟ

Prepare the key:

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```

              :ﮟﯿﻣ **Settings → Secrets and variables → Actions** ﮯﮐ ﯼﺮﭩﯾﺯﻮﭙﯾﺭ

| Secret | Value |
| --- | --- |
| `GPG_PRIVATE_KEY` | `gpg --armor --export-secret-keys KEY_ID` output |
| `GPG_KEY_ID` | expected key ID or fingerprint |
| `GPG_PASSPHRASE` | non-empty passphrase of the signing key |
| `PACKAGES_REPO_TOKEN` | PAT with `contents:write` on `argvus/packages` |

##                                                            ﺎﻧﺮﮐ ﻊﺋﺎﺷ ﺰﯿﻠﯾﺭ ﮏﯾﺍ

Before tagging:

1.          :ﮟﯾﺮﮭﺑ `url` ﮟﯿﻣ `packaging/arch/remote/PKGBUILD` ﮫﺗﺎﺳ ﮯﮐ ﯼﺮﭩﯾﺯﻮﭙﯾﺭ ﯽﻠﺻﺍ
   - GitHub: `url="https://github.com/argvus/argvus-boot-splash"` (ﺬﺧﺎﻣ )
     `${url}/archive/refs/tags/v${pkgver}.tar.gz` ﮯﮨ ﺎﺗﺮﮐ ﻝﺎﻤﻌﺘﺳﺍ);
   - GitLab: `source=` ﮟﯾﺮﮐ ﭧﺴﺟﮉﯾﺍ ﻮﮐ
`https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz`;
   - without `url`              ۔ﮫﺗﺎﺳ ﮯﮐ ﻡﺎﻐﯿﭘ ﺢﺿﺍﻭ ﮏﯾﺍ **ﮯﮨ ﯽﺗﺎﺟ ﻮﮨ ﻡﺎﮐﺎﻧ ﺮﮐ ﮫﺟﻮﺑ ﻥﺎﺟ** ﺰﯿﻠﯾﺭ ،
2. `packaging/arch/local/PKGBUILD` ﺭﻭﺍ ﮟﯾﺮﮐ ﮓﻨﮨﺁ ﻢﮨ ﺎﭩﯾﮈ ﺎﭩﯿﻣ/ﺰﻧﮊﺭﻭ ﮟﯿﻣ
`packaging/arch/remote/PKGBUILD`.
3. Tag and push:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```

ﺎﮐ ﺱﺍ ﮧﮐ ﺎﺴﯿﺟ ﮯﮨ ﺎﺘﮑﺳ ﺎﺟ ﺎﯿﮐ ﻉﻭﺮﺷ ﮫﺗﺎﺳ ﮯﮐ ﮓﯿﭨ `v*` ﺩﻮﺟﻮﻣ ﺮﭘ ﺭﻮﻃ ﯽ
`tag` ۔ﮯﮨ ﺪﯿﻔﻣ ﮯﯿﻟ ﮯﮐ ﺮﯿﻤﻌﺗ ﮦﺭﺎﺑﻭﺩ ﮦﺪﺷ ﻝﻭﺮﭩﻨﮐ ﮏﯾﺍ ﻮﺟ ،ﭧﭘ ﻥﺍ

## Versioning

- `pkgver` ﮟﯿﻣ SemVer، `pkgrel` ۔ﺩﺍﺪﻌﺗ ﯽﮐ ﺰﯿﻠﯾﺭ ﮟﯿﻣ

##                                                              ﮓﻨﭨﻮﺷ ﻞﺑﺮﭨ ﺮﭙﻠﯾﻭﮈ

ﮏﯾﺍ ﺎﯾ ،ﮓﯿﭨ v* ﺐﺋﺎﻏ ،`url` ﯽﻟﺎﺧ **۔ﮯﮨ ﯽﺌﮔ ﻮﮨ ﻡﺎﮐﺎﻧ 
(ﻝﺎﺑﺭﺎﭨ GitLab ﮧﻠﺑﺎﻘﻤﺑ GitHub) ﺎﺗﺎﮭﮐ ﮟﯿﮩﻧ ﻞﯿﻣ ﮯﺳ ﻥﺎﺑﺰﯿﻣ ﻮﺟ ﭧﯿﻣﺭﺎﻓ ﻞﯾﺍ ﺭﺁ ﻮﯾ ﻮﯿ
ﮯﮨ ﺎﺗﺎﺟ ﻮﮨ ﻡﺎﮐﺎﻧ ﺪﻠﺟ ﺮﭘ ﮯﻧﻮﮨ ﯽﻟﺎﺧ ﺭﻭﺍ ﮯﮨ ﺎﺗﺮﮐ ﻖﯾﺪﺼﺗ ﯽﮐ ﻥﺮﭩﯿﭘ ﮓﯿﭨ ﻮﻠﻓ ﮎﺭﻭ ۔(ﭦﺅﺁ
 `v*` `url`.

**`updpkgsums` ﮯﮨ ﯼﺭﻭﺮﺿ ﺎﻧﺎﺟ ﺎﯿﮐ ﺶﭘ ﮯﻠﮩﭘ ﮯﺳ ﺱﺍ ﺭﻭﺍ ﮯﯿﮨﺎﭼ ﺎﻧﻮﮨ ﺩﻮﺟﻮﻣ ﮓﯿﭨ *
۔ﮯﮨ ﺎﺗﺎﺟ ﻮﮨ ﻡﺎﮐﺎﻧ ﺎﻨﺠﯿﮭﺑ ﮫﺗﺎﺳ ﮯﮐ ﮓﯿﭨ ﺩﻮﺟﻮﻣ ﺮﭘ ﺭﻮﻃ ﯽﻣﺎﻘﻣ ﻑﺮﺻ ﮞﺎﮩﯾ ؛ﮯﮨ ﯽﺘﻠﭼ ﺏﺎﺟ 

**`make validate` ﻞﮐﻮﻟ ﺭﻭﺍ ﭦﻮﻤﯾﺭ" ﮧﮐ ﮯﮨ ﺎﺗﺮﮐ ﭦﺭﻮﭘﺭ PKGBUILD ۔"ﮯﮨ ﮟﯿﮩﻧ ﮓﻨﮨﺁ ﻢ
.(ﮟﯿﮩﻧ `source=`) ﮟﯾﺮﮐ ﯽﭘﺎﮐ ﯽﮐ ﺯﮉﻠﯿﻓ ﮯﮐ ﺎﭩﯾﮈ ﺎﭩﯿﻣ ﮟﯿﻣ ﮮﺮﺳﻭﺩ ﮯﺳ PKGBUIL

                    ﮟﯾﺮﮐ ﻞﻣﺎﺷ ﮯﺳﺍ **۔ﮯﮨ ﺎﺗﺎﺟ ﻮﮨ ﻡﺎﮐﺎﻧ ﮏﯿﭼ ﻞﯿﭙﺳﺍ ﺮﭘ ﺡﻼ﻿ﻄﺻﺍ ﯽﺌﻧ**
`.cspell/custom-dictionary-workspace.txt` (`argvus` ﯼﺮﻨﺸﮐﮈ، `addWords:
true`), not to `ignorePaths`.

**`sudo` ﮯﻧ `make install` ﺎﯾ `libfakeroot.so … LD_PRELOAD` ﯽﮐ ﺖﺳﺍﻮﺧﺭﺩ ﺭﺪﻧﺍ 
ﮮﺮﮐ ﻝﺎﻤﻌﺘﺳﺍ ﮧﮐ ﮯﮐ ﺱﺍ ﮯﺋﺎﺠﺑ ﮯﮨ ﺎﺘﺠﯿﮭﺑ ﺮﭘ make install ﻮﺟ `package()`
 `make install` `install -Dm*`ﮞﻮﻧﻭﺩ ۔ PKGBUILDﺯ `arch_package_splash_payload` ﮯﮨ ﺎﺗﺮﮐ ﮧﮐ ﻮﺟ ،ﮟﯿﮨ ﮯﺗﺮﮐ ﻝ
۔ﻮﮨ ﯽﺋﺍﺮﮐ ﮧﻧ ﻑﺭﺎﻌﺘﻣ ﮦﺭﺎﺑﻭﺩ ﻝﺎﮐ `make` ﮯﻧ ﯽﺴﮐ ﮧﮐ ﮟﯿﺋﺎﻨﺑ ﯽﻨﯿﻘﯾ ﻮﮐ ﺕﺎﺑ

**`makepkg` ﮟﯿﺋﻼ﻿ﭼ ﺮﭘ ﺭﻮﻃ ﮯﮐ ﻑﺭﺎﺻ ﻡﺎﻋ ﻮﮐ ﺮﯿﻤﻌﺗ ۔ﮯﯿﮨﺎﭼ ﺎﻧﻼ﻿ﭼ ﮟﯿﮩﻧ ﺮﭘ ﺭﻮﻃ 
                                                   ۔`sudo -u <user> make build` ﺎﯾ ،ﻑﺭﺎﺻ

۔ﺎﯿﮔ ﺎﯾﺎﻨﺑ ﮟﯿﮩﻧ ﮦﺭﺎﺑﻭﺩ initramfs **۔ﯽﺋﺁ ﮟﯿﮩﻧ ﯽﻠﯾﺪﺒﺗ ﯽﺋﻮﮐ ﮟﯿﻣ ﺶﯿﻠﭙﺳﺍ ﻦﮑﯿﻟ ﮯﮨ ﺎﯿ
     ﺎﯾ ،ﮟﯾﺮﮐ ﻝﺎﮐ ﻮﮐ `sudo plymouth --show-splash` ﮯﺋﺎﺠﺑ ﮯﮐ ﮯﻧﺮﮐ ﭦﻮﺑ ﯼﺭ ،ﮯﯿﻟ ﮯﮐ ﭻﻧﺎﺟ ﯽﻣﺎﻘﻣ
`sudo mkinitcpio -P` / `sudo dracut --regenerate-all` ۔ﮟﯾﺮﮐ ﺮﯿﻤﻌﺗ ﮦﺭﺎﺑﻭﺩ ﮫﺗﺎﺳ ﮯﮐ
