---
title: دليل المطور
description:                                       .ARGVUS ﻲﻤﻫﺎﺴﻤﻟ ﺮﻳﻮﻄﺘﻟﺍﻭ ﻢﻴﻤﺼﺘﻟﺍ ﺕﺍﺩﺎﺷﺭﺇ
---

#                                                   ﺭﻮﻄﻤﻟﺍ ﻞﻴﻟﺩ — ﺱﻮﻏﺭﺃ ءﺪﺑ ﺔﺷﺎﺷ

                        ﺙﻮﻤﻴﻠﻴﺑ ﻒﻴﻛ :`argvus-boot-splash` ﻉﺩﻮﺘﺴﻤﻟ ﺔﻴﻨﻘﺘﻟﺍ ﻖﺋﺎﺛﻮﻟﺍ
             ﺕﺍﺭﺍﺪﺻﻹ﻿ﺍ ﻢﺘﺗ ﻒﻴﻛﻭ ،Arch ﺔﻣﺰﺣ ءﺎﻨﺑ ﻢﺘﻳ ﻒﻴﻛﻭ ،ﻉﻮﺿﻮﻤﻟﺍ ﻊﻴﻤﺠﺗ ﻢﺘﻳ ﻒﻴﻛ
تم التوقيع عليها ونشرها.

           ،`.plymouth` ﻒﺻﻭ) ﺕﺎﻧﺎﻴﺒﻟﺍ ﻮﻫ ﻉﻮﺿﻮﻤﻟﺍ — ﺎﻨﻫ ﻊﻴﻤﺠﺗ ﺓﻮﻄﺧ ﺪﺟﻮﺗ ﻻ﻿
a `.script`، ﺔﻣﺰﺣ ﺔﻔﺻﻭ ﻰﻟﺇ ﺔﻓﺎﺿﻹ﻿ﺎﺑ (ﺭﻮﺼﻟﺍﻭ Arch. "ﺝﺎﺘﻧﻹ﻿ﺍ ﻲﻨﻌﻳ "ءﺎﻨﺒﻟﺍ
حزمة قابلة للتكرار:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```

Before committing a change:

, and add new technical
terms to

 or the spellcheck job fails.

إذا كنت تريد فقط *استخدام* السمة، فاقرأ دليل المستخدم. ل
ﺭﺍﺪﺻﻹ﻿ﺍ ،ﺭﺍﺮﺳﻷ﻿ﺍ ،git flow) ﻒﻠﻤﻟﺍ ﺍﺬﻫ ﻦﻣ ﺔﻴﻠﻤﻌﻟﺍ ﻮﺤﻧ ﺔﻬﺟﻮﻤﻟﺍ ﺔﺨ

## أدلة

| دليل | المحتويات |
| --- | --- |

##                                                                      ﻊﻳﺮﺳ ﻊﺟﺮﻣ

| المسار | ما هو |
| --- | --- |
|  `make validate && make build`  `.cspell/custom-dictionary-workspace.txt`  `functions.sh`  `validate.sh`  `ci.yml`  `release.yml` `src/usr/share/plymouth/themes/argvus/` | theme payload installed under `/usr` |
| `packaging/arch/{ci,local}/PKGBUILD` | الافراج عن وصفات الحزمة المحلية |
| `packaging/arch/common/functions.sh` | مشترك `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | القطران الحتمي + سائق `makepkg` |
| `tools/sh/validate.sh` | بوابة التحقق المطلوبة |
| `.github/workflows/` | `ci.yml` (التحقق من الصحة والإنشاء والتدقيق الإملائي)، `release.yml` (العلامات `v*`) |

## في مكان آخر

-                   (/docs/argvus-boot-splash/)[ﻡﺪﺨﺘﺴﻤﻟﺍ ﻞﻴﻟﺩ] :ﻡﺪﺨﺘﺴﻤﻠﻟ ﺔﻬﺟﻮﻤﻟﺍ ﻖﺋﺎﺛﻮﻟﺍ
-                             (https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)[DEVELOPMENT.md] :ﺮﻳﻮﻄﺘﻟﺍ ﺔﻴﻠﻤﻋ
-                                 (https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)[CONTRIBUTING.md] :ﺔﻤﻫﺎﺴﻤﻟﺍ

                                       ﺃﺮﻗﺍ ،ﺐﻟﺎﻘﻟﺍ *ﻡﺍﺪﺨﺘﺳﺍ* ﻂﻘﻓ ﺪﻳﺮﺗ ﺖﻨﻛ ﺍﺫﺇ[                                                                 ﻡﺪﺨﺘﺴﻤﻟﺍ ﻞﻴﻟﺩ](/docs/argvus-boot-splash/)                                                                          ـﻟ .
                                                                 ﺮﻈﻧﺍ (ﺔﻴﻠﻤﻌﻟﺍ[DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)                                                                             ﻭ
[المساهمة.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).
| [                                                                 ﻉﻮﺿﻮﻤﻟﺍ ﺔﺳﺪﻨﻫ](/docs/argvus-boot-splash/developer-guide/theme/)| ﺔﻤﺴﻟﺍ ﻞﻳﺪﻌﺗ ﺔﻴﻔﻴﻛ ،ﺔﻴﻄﻘﻨﻟﺍ UKI ﺔﻄﻳﺮﺧ ،ﻢﻴﻤﺼﺘﻟﺍ ﺯﻮﻣﺭ ،ﻂﻴﻄﺨﺘﻟﺍ ﺖﺑﺍﻮﺛ ،ﻲﺠﻣﺮﺒﻟﺍ ﺺ
| [Packaging](/docs/argvus-boot-splash/developer-guide/packaging/) | The two PKGBUILDs, shared functions.sh, install hooks, local build pipeline, Make targets, prerequisites |
| [CI والإصدارات](/docs/argvus-boot-splash/developer-guide/ci-releases/) | validate.sh وci.yml وrelease.yml خطوة بخطوة والمجاميع الاختبارية والتوقيع والأسرار والنشر والإصدار |
| [                                                   ﺔﻓﻭﺮﻌﻤﻟﺍ ﺕﺍﺮﻐﺜﻟﺍﻭ ﺕﺎﻴﻗﺎﻔﺗﻻ﻿ﺍ](/docs/argvus-boot-splash/developer-guide/workflow/)| ﻉﺩﻮﺘﺴﻤﻟﺍ ﻖﻴﻗﺪﺗ ءﺎﻨﺛﺃ ﺎﻬﻴﻠﻋ ﺭﻮﺜﻌﻟﺍ ﻢﺗ ﻲﺘﻟﺍ ﺕﺎﻀﻗﺎﻨﺘﻟﺍﻭ ،ﻖﺋﺎﺛﻮﻟﺍ ﺔﻄﻳﺮﺧ ،ﻝﺰﻨﻤﻟﺍ
                                                               :ﻉﺩﻮﺘﺴﻤﻟﺍ ﺭﺬﺟ -[README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
                                                  ﻡﺪﺨﺘﺴﻤﻠﻟ ﺔﻬﺟﻮﻤﻟﺍ ﺕﺍﺪﻨﺘﺴﻤﻟﺍ -[                                                                 ﻡﺪﺨﺘﺴﻤﻟﺍ ﻞﻴﻟﺩ](/docs/argvus-boot-splash/)
                                                              :ﺮﻳﻮﻄﺘﻟﺍ ﺔﻴﻠﻤﻋ -[DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
                                                                   :ﺔﻤﻫﺎﺴﻤﻟﺍ -[CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
                                                                :ﻥﺎﻣﻷ﻿ﺍ ﺔﺳﺎﻴﺳ -[SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
                                                                     :ﺔﺼﺧﺮﻟﺍ -[                                                              ﻂﻘﻓ 3.0-ﻝﺇ ﻲﺑ ﻲﺟ](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
                                                          :ﺔﻴﻟﺎﻐﺗﺮﺒﻟﺍ ﺔﺨﺴﻨﻟﺍ -[                                                                   ﺭﻮﻄﻤﻟﺍ ﻞﻴﻟﺩ](/pt/docs/argvus-boot-splash/developer-guide/)
