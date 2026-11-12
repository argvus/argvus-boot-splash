---
title: ڈویلپر گائیڈ
description: ARGVUS ۔ﯽﺋﺎﻤﻨﮨﺭ ﯽﮐ ﯽﻗﺮﺗ ﺭﻭﺍ ﺮﯿﻤﻌﺗ ﻦﻓ ﮯﯿﻟ ﮯﮐ ﮞﻭﺭﺍﺩ ﺖﮐﺍﺮﺷ
---

#                                                ﮉﯿﺋﺎﮔ ﺮﭙﻠﯾﻮﯾﮈ — ﺶﯿﻠﭙﺳ ﭦﻮﺑ ﺱﻮﮔﺭﺁ

`argvus-boot-splash` ﮯﺴﯿﮐ ﮫﺗﻮﻤﯿﻠﭘ :ﺕﺍﺰﯾﻭﺎﺘﺳﺩ ﯽﮑﯿﻨﮑﺗ ﮯﯿﻟ ﮯﮐ ﯼﺮﭩﯾﺯﻮﭙﯾﺭ
ﮟﯿﮨ ﮯﺴﯿﮐ ﺯﺰﯿﻠﯾﺭ ﺭﻭﺍ ،ﮯﮨ ﺎﺗﺎﺟ ﺎﯾﺎﻨﺑ ﮯﺴﯿﮐ ﺞﯿﮑﯿﭘ ﭺﺭﺁ ،ﮯﮨ ﺎﺗﺎﺟ ﺎﯿﮐ ﺎﮭﭩﮐﺍ ﮯﺴﯿﮐ ﻢﯿﮭﺗ
دستخط اور شائع.

،ﺮﭩﭘﺮﮑﺳﮈ `.plymouth` ﮏﯾﺍ) ﮯﮨ ﺎﭩﯾﮈ ﻉﻮﺿﻮﻣ — ﮯﮨ ﮟﯿﮩﻧ ﮧﻠﺣﺮﻣ ﻦﺸﯿﻠﺋﺎﭙﻤﮐ ﯽﺋﻮﮐ ﮞ
a `.script`        ﮯﮨ ﺎﻧﺮﮐ ﺍﺪﯿﭘ ﺐﻠﻄﻣ ﺎﮐ "ﺮﯿﻤﻌﺗ" ۔ﯽﭙﺴﯾﺭ ﺞﮑﯿﭘ ﭺﺭﺁ ﮏﯾﺍ ﮫﺗﺎﺳ ﮯﮐ (ﺮﯾﻭﺎﺼﺗ ﺭﻭﺍ ،
ایک تولیدی پیکیج:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```

              ﮟﯾﺮﮐ ﻞﻣﺎﺷ ﯽﮑﯿﻨﮑﺗ ﯽﺌﻧ ﺭﻭﺍ ،`make validate && make build` :ﮯﻠﮩﭘ ﮯﺳ ﮯﻧﺮﮐ ﯽﻠﯾﺪﺒﺗ
         ۔ﺎﮔ ﮯﺋﺎﺟ ﻮﮨ ﻡﺎﮐﺎﻧ ﻡﺎﮐ ﺎﮐ ﭻﻧﺎﺟ ﯽﮐ ﮯﺠﮨ ﺎﯾ ﮏﺗ `.cspell/custom-dictionary-workspace.txt` ﻮﮐ ﻂﺋﺍﺮﺷ

                           (ﺰﯿﻠﯾﺭ ،ﺯﺍﺭ ،ﻮﻠﻓ ﭧﮔ) ﺐﺼﻨﻣ ﻢﮨ ﯽﻨﺒﻣ ﺮﭘ ﻞﻤﻋ ﺎﮐ ﻞﺋﺎﻓ ﺱﺍ

## رہنما

| گائیڈ | مشمولات |
| --- | --- |

##                                                                     ﮧﻟﺍﻮﺣ ﯼﺭﻮﻓ

| راستہ | یہ کیا ہے |
| --- | --- |
|  `functions.sh`  `validate.sh`  `ci.yml`  `release.yml` `src/usr/share/plymouth/themes/argvus/` | theme payload installed under `/usr` |
| `packaging/arch/{ci,local}/PKGBUILD` | ریلیز اور مقامی پیکیج کی ترکیبیں |
| `packaging/arch/common/functions.sh` | مشترکہ `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | ڈیٹرمنسٹک ٹربال + `makepkg` ڈرائیور |
| `tools/sh/validate.sh` | مطلوبہ توثیق گیٹ |
| `.github/workflows/` | `ci.yml` (تصدیق کریں، تعمیر کریں، ہجے چیک کریں)، `release.yml` (ٹیگز `v*`) |

## کہیں اور

-                         (/docs/argvus-boot-splash/)[ﮉﯿﺋﺎﮔ ﻑﺭﺎﺻ] :ﺕﺍﺰﯾﻭﺎﺘﺳﺩ ﮯﯿﻟ ﮯﮐ ﻑﺭﺎﺻ
-                               (https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)[DEVELOPMENT.md] :ﻞﻤﻋ ﺎﮐ ﯽﻗﺮﺗ
-                               (https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)[CONTRIBUTING.md] :ﯼﺭﺎﮐ ﺖﮐﺍﺮﺷ

                         ﮟﯿﮬﮍﭘ ﻮﺗ ،ﮟﯿﮨ ﮯﺘﮨﺎﭼ ﺎﻧﺮﮐ *ﻝﺎﻤﻌﺘﺳﺍ* ﻮﮐ ﻢﯿﮭﺗ ﻑﺮﺻ ﭖﺁ ﺮﮔﺍ[                                                               ﯽﺋﺎﻤﻨﮨﺭ ﯽﮐ ﻑﺭﺎﺻ](/docs/argvus-boot-splash/)                                                                      ﮯﯿﻟ ﮯﮐ .
                                                                   ﮟﯿﮭﮑﯾﺩ (ﻞﻤﻋ[DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)                                                                           ﺭﻭﺍ
[CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).
| [                                                                ﺮﭽﮑﯿﭩﯿﮐﺭﺁ ﻢﯿﮭﺗ](/docs/argvus-boot-splash/developer-guide/theme/)| ﮟﯾﺮﮐ ﻞﯾﺪﺒﺗ ﮯﺴﯿﮐ ﻮﮐ ﻢﯿﮭﺗ ،ﭗﯿﻣ ﭧﺑ ﯽﺋﺁ ﮯﮐ ﻮﯾ ،ﺰﻨﮐﻮﭨ ﻦﺋﺍﺰﯾﮈ ،ﺮﺻﺎﻨﻋ ﻞﻘﺘﺴﻣ ﮯﮐ ﭦﺅﺁ
| [Packaging](/docs/argvus-boot-splash/developer-guide/packaging/) | The two PKGBUILDs, shared functions.sh, install hooks, local build pipeline, Make targets, prerequisites |
| [CI اور ریلیز](/docs/argvus-boot-splash/developer-guide/ci-releases/) | validate.sh، ci.yml، release.yml مرحلہ وار، چیکسم، دستخط، راز، اشاعت اور ورژن بنانا |
| [                                                             ﻼ﻿ﺧ ﻑﻭﺮﻌﻣ ﺭﻭﺍ ﺝﺍﻭﺭ](/docs/argvus-boot-splash/developer-guide/workflow/)| ﺕﺍﺩﺎﻀﺗ ﯽﻟﺍﻭ ﮯﻧﺎﺟ ﯽﺋﺎﭘ ﺖﻗﻭ ﮯﺗﺮﮐ ﭦﮈﺁ ﺎﮐ ﯼﺮﭨﺯﻮﭙﯾﺭ ﺭﻭﺍ ،ﮧﺸﻘﻧ ﺎﮐ ﺕﺍﺰﯾﻭﺎﺘﺳﺩ ،ﺰﻟﻭﺭ
                                                            :ﮍﺟ ﯽﮐ ﮦﺎﮔ ﮦﺮﯿﺧﺫ -[README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
                                                      :ﺕﺍﺰﯾﻭﺎﺘﺳﺩ ﮯﯿﻟ ﮯﮐ ﻑﺭﺎﺻ -[                                                               ﯽﺋﺎﻤﻨﮨﺭ ﯽﮐ ﻑﺭﺎﺻ](/docs/argvus-boot-splash/)
                                                                :ﻞﻤﻋ ﯽﺗﺎﯿﻗﺮﺗ -[DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
                                                                      :ﺖﮐﺍﺮﺷ -[CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
                                                            :ﯽﺴﯿﻟﺎﭘ ﯽﭨﺭﻮﯿﮑﯿﺳ -[SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
                                                                      :ﺲﻨﺴﺋﻻ﻿ -[                                                             ﻑﺮﺻ-3.0-ﻞﯾﺍ ﯽﭘ ﯽﺟ](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
                                                               :ﻥﮊﺭﻭ ﯽﻟﺎﮕﺗﺮﭘ -[                                                                  ﮉﯿﺋﺎﮔ ﺮﭙﻠﯾﻭﮈ](/pt/docs/argvus-boot-splash/developer-guide/)
