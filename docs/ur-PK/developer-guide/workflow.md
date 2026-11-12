---
title:                                                             ءﻼ﻿ﺧ ﻑﻭﺮﻌﻣ ﺭﻭﺍ ﺝﺍﻭﺭ
description:                   ۔ﺞﺋﺎﺘﻧ ﮯﮐ ﭦﮈﺁ ﯼﺮﭩﯾﺯﻮﭙﯾﺭ ﺭﻭﺍ ،ﮧﺸﻘﻧ ﺎﮐ ﺕﺍﺰﯾﻭﺎﺘﺳﺩ ،ﺪﻋﺍﻮﻗ ﮯﮐ ﺮﮭﮔ
---

#                                                              ﻼ﻿ﺧ ﻑﻭﺮﻌﻣ ﺭﻭﺍ ﺝﺍﻭﺭ

ﮟﯾﺩﺎﻀﺗ ﯽﻟﺍﻭ ﮯﻧﺎﺟ ﯽﺋﺎﭘ ﮦﺰﺋﺎﺟ ِﻥﺍﺭﻭﺩ ﺭﻭﺍ ،ﺰﻟﻭﺭ ﺱﺅﺎﮨ ﮯﯿﻟ ﮯﮐ ﮞﻮﯿﻠﯾﺪﺒﺗ ﮟﯿﻣ ﯼﺮﭩﯾﺯﻮﭙﯾﺭ
              ۔ﮯﮨ ﺪﻨﻣ ﮦﺪﺋﺎﻓ ﮦﺩﺎﯾﺯ ﺎﻧﺮﮐ ﺖﺳﺭﺩ ﮯﺋﺎﺠﺑ ﮯﮐ ﮯﻧﺮﮐ ﻞﻘﻧ — ﺎﻧﺮﮐ ﭦﮈﺁ ﺎﮐ ﺱﺍ


## کنونشنز

- شیل: `set -euo pipefail`، انڈینٹیشن کے لیے ٹیبز، `printf`/`error` پیغامات
stderr، `command -v` ﭻﻧﺎﺟ ﯽﮐ ﺖﯿﺣﻼ﻿ﺻ، shellcheck ﮟﯿﮭﮑﯾﺩ) ﻑﺎﺻ
  `.editorconfig`).
-         ۔ﮟﯿﮭﮐﺭ ﯽﻟﺎﺧ sha256sums=() ﮟﯿﻣ git ؛ﮟﯿﮭﮑﻟ ﮧﻧ `sha256sums=('SKIP')` ﯽﮭﺒﮐ
- ﮟﯾﺮﮐ ﮧﻧ ﭧﯿﻤﮐ ﮟﯿﻠﺋﺎﻓ ﯽﺌﮔ ﯽﮐ ﭧﯾﺮﯿﻨﯿﺟ ﺎﯾ ،ﮟﯿﻠﺋﺎﻓ ﺞﯿﮑﯿﭘ ،( `sha256sums=()` `build/`) ﺲﭩﭘ ﭦ
  `.PKGBUILD.local.*` کاپیاں۔
- ،`splash`، `layout` :ﺭﺎﮐ ﮦﺮﺋﺍﺩ ﮯﻟﺍﻭ ﮯﻧﻮﮨ ﻝﺎﻤﻌﺘﺳﺍ ﮟﯿﻣ ﺦﯾﺭﺎﺗ ﺭ
  `pkgbuild`, `release`, `chore`, `ci`, `build`, `docs`.
- برانچ کا نام: `feat/…`, `fix/…`, `docs/…`, `chore/…`, `refactor/…`۔
-                     ۔ﺝﺮﻣ-ﺵﺍﻮﮑﺳ ،ﯼﺭﻮﻈﻨﻣ ﯽﮐ ﮯﻟﺍﻭ ﮯﻨﯿﻟ ﮦﺰﺋﺎﺟ ﮏﯾﺍ ﮯﻠﮩﭘ ﮯﺳ ﮯﻧﺮﮐ ﺝﺮﻣ
-                    ۔`/usr/share/licenses/argvus-boot-splash/LICENSE` :ﺎﯿﮔ ﺎﺠﯿﮭﺑ ﺮﭘ ﺭﻮﻃ ﮯﮐ ۔ﻑﺮﺻ-GPL-3.0 :ﺲﻨﺴﺋﻻ﻿

##                                                                      ﺕﻼ﻿ﺧ ﻡﻮﻠﻌﻣ

                           :ﮯﺌﮔ ﮯﺋﺎﭘ ﺕﺍﺩﺎﻀﺗ ﯼﺰﯾﻭﺎﺘﺳﺩ ﮯﺋﻮﮨ ﮯﺗﺮﮐ ﭦﮈﺁ ﺎﮐ ﯼﺮﭨﺯﻮﭙﯾﺭ

- `README.md` `make test` ﮟﯿﮩﻧ ﮫﭽﮐ ﺎﺴﯾﺍ ﻦﮑﯿﻟ ،ﮯﮨ ﺎﺗﺮﮐ ﺮﯿﮩﺸﺗ ﯽﮐ ﻮﯾﻮﯾﺮ
   `sudo plymouth --show-splash` `sudo plymouthquit` / `entry-line.png`.
- `logo-glow.png` اور `arch_check_splash_payload()` پے لوڈ میں جہاز اور اس کی ضرورت ہے
  `argvus.script`, but printf never loads them. Either
               ۔ﮟﯾﺩ ﺮﮐ ﻑﺬﺣ ﮯﺳ ﭧﺴﻟ ﮏﯿﭼ ﺭﻭﺍ ﮈﻮﻟ ﮯﭘ ﺎﯾ ﮟﯾﺮﮐ ﻞﻣﺎﺷ ﮟﯿﻣ ﭧﭘﺮﮑﺳﺍ ﮟﯿﮩﻧﺍ
- `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` ﻦﮑﯿﻟ ﮯﮨ ﺐﺼﻧ
                                       ﮧﯾ ؛ﺍﻮﮨ ﮟﯿﮩﻧ ﺮﭩﺴﺟﺭ ﯽﮭﺒﮐ ﮫﺗﺎﺳ ﮯﮐ ﺰﯿﭼ ﯽﺴﮐ
  `bootctl`/`ukify` مرحلہ۔
-           ,`README.md`) ﮟﯿﮨ ﺩﻮﺟﻮﻣ ﺮﭘ ﭦﻭﺭ ﮯﮐ ﯼﺮﭩﯾﺯﻮﭙﯾﺭ ﺕﺍﺰﯾﻭﺎﺘﺳﺩ ﻞﮑﯿﻧﻮﻨﯿﮐ
`DEVELOPMENT.md`) ﺭﻭﺍ `docs/` ۔ﮟﯿﮭﮐﺭ ﮟﯿﻣ ﺖﻘﺑﺎﻄﻣ ﮟﯿﮩﻧﺍ ۔ﮟﯾﺮﮐ ﭗﯿﻟﺭﻭﻭﺍ
(`CONTRIBUTING.md`، `SECURITY.md`) ﮞﺎﯿﺴﯿﻟﺎﭘ ﯽﮐ ﺖﮐﺍﺮﺷ ۔ﮯﺋﺎﺟ ﺎﯿﮐ ﻞﯾﺪﺒﺗ ﻮﮐ ﮏﯾ
`.github` ۔ﮟﯿﮨﺭ ﺭﺪﻧﺍ ﮯﮐ ﻢﯿﻈﻨﺗ ﮟﯿﻣ ﯼﺮﭨﺯﻮﭙﯾﺭ

##                                                              ﮧﺸﻘﻧ ﺎﮐ ﺕﺍﺰﯾﻭﺎﺘﺳﺩ

| دستاویز | سامعین | دائرہ کار |
| --- | --- | --- |
| `README.md` | ہر کوئی | ایک پیراگراف کا جائزہ اور ترتیب |
| `DEVELOPMENT.md` | دیکھ بھال کرنے والے | تعمیر، دستخط، رہائی کا عمل |

                                                    ﮟﯿﮭﮑﯾﺩ ﮯﯿﻟ ﮯﮐ ﮧﻟﺍﻮﺣ ﯽﮑﯿﻨﮑﺗ[                                                                ﺮﭽﮑﯿﭩﯿﮐﺭﺁ ﻢﯿﮭﺗ](/docs/argvus-boot-splash/developer-guide/theme/),
[                                                                       ﮓﻨﺠﯿﮑﯿﭘ](/docs/argvus-boot-splash/developer-guide/packaging/)                                                                           ﺭﻭﺍ[                                                             ﺯﺰﯿﻠﯾﺭ ﺭﻭﺍ ﯽﺋﺁ ﯽﺳ](/docs/argvus-boot-splash/developer-guide/ci-releases/).
                                                              ﮟﯾﺮﮐ ﺪﻣﺁﺭﺩ ﻞﻤﻋ -[CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)                                                                           ﺭﻭﺍ
  [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md).
                                                                  ﮯﮨ ﺩﻮﺟﻮﻣ ﻑﺪﮨ[                                                                      ﻞﺋﺎﻓ ﮏﯿﻣ](https://github.com/argvus/argvus-boot-splash/blob/main/Makefile)                                                             ﮟﯿﮨ ﺯﮉﻧﺎﻤﮐ ﯽﻠﺻﺍ .
  [                                                               ﯽﺋﺎﻤﻨﮨﺭ ﯽﮐ ﻑﺭﺎﺻ](/docs/argvus-boot-splash/uki-splash/)                                                             ﯽﺘﺳﺩ ﺎﮐ ﺕﺍﺰﯾﻭﺎﺘﺳﺩ
| [`CONTRIBUTING.md`](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)                                                                          ﮒﺭﺍ)`.github`                           | ﯽﺴﯿﻟﺎﭘ ﯽﮐ ﺯﺍﺭ ،ﺪﻋﺍﻮﻗ ﮯﮐ ﺭﺁ ﯽﭘ ،ﻮﻠﻓ ﭧﮔ | ﻥﻭﺎﻌﻣ | (
| [`docs/user-guide.md`](/docs/argvus-boot-splash/)                              | ﻞﺣ ﺎﮐ ﻞﺋﺎﺴﻣ ،ﻝﺎﻤﻌﺘﺳﺍ ،ﺐﯿﺼﻨﺗ | ﻦﯿﻓﺭﺎﺻ ﯽﻣﺎﺘﺘﺧﺍ |
| [`docs/developer-guide.md`](/docs/argvus-boot-splash/developer-guide/)(/docs/argvus-boot-splash/developer-guide/) | developers | theme internals, packaging, CI |
