---
title:                                                    ﺔﻓﻭﺮﻌﻤﻟﺍ ﺕﺍﻮﺠﻔﻟﺍﻭ ﺕﺎﻴﻗﺎﻔﺗﻻ﻿ﺍ
description:                            .ﻉﺩﻮﺘﺴﻤﻟﺍ ﻖﻴﻗﺪﺗ ﺞﺋﺎﺘﻧﻭ ،ﻖﺋﺎﺛﻮﻟﺍ ﺔﻄﻳﺮﺧ ،ﻝﺰﻨﻤﻟﺍ ﺪﻋﺍﻮﻗ
---

# ﺔﻓﻭﺮﻌﻤﻟﺍ ﺕﺍﻮﺠﻔﻟﺍﻭ ﺕﺎﻴﻗﺎﻔﺗﻻ﻿ﺍ

ءﺎﻨﺛﺃ ﺓﺩﻮﺟﻮﻤﻟﺍ ﺕﺎﻘﺳﺎﻨﺘﻟﺍ ﻡﺪﻋ ﻰﻟﺇ ﺔﻓﺎﺿﻹ﻿ﺎﺑ ،ﻉﺩﻮﺘﺴﻤﻟﺍ ﺍﺬﻫ ﻲﻓ ﺕﺍﺮ
                                            .ﺦﺴﻨﻟﺍ ﻦﻣ ًﻻ﻿ﺪﺑ ﺡﻼ﻿ﺻﻹ﻿ﺍ ﻖﺤﺘﺴﻳ — ﻪﻘﻴﻗﺪﺗ


## Conventions

- Shell: `set -euo pipefail`, tabs for indentation, `printf`/`error` messages to
stderr، ﺓﺭﺪﻗ ﺕﺎﺻﻮﺤﻓ `command -v`، ﻒﻴﻈﻨﺗ shellcheck (ﺮﻈﻧﺍ
  `.editorconfig`).
-            .git ﻲﻓ ﺎًﻏﺭﺎﻓ sha256sums=() ﻙﺮﺗﺍ ؛ﺍًﺪﺑﺃ `sha256sums=('SKIP')` ﺐﺘﻜﺗ ﻻ﻿
- ﺔﺠﺗﺎﻨﻟﺍ ﺕﺎﻔﻠﻤﻟﺍ ﻭﺃ ،ﺔﻣﺰﺤﻟﺍ ﺕﺎﻔﻠﻣ ﻭﺃ ،( `sha256sums=()` `build/`) ءﺎﻨﺒﻟﺍ ﺕﺎﺟﺮﺨﻣ ﻡﺍﺰﺘﻟﺎﺑ
  `.PKGBUILD.local.*` copies.
- ،`splash`، `layout` :ﻞﺠﺴﻟﺍ ﻞﺒﻗ ﻦﻣ ﺔﻣﺪﺨﺘﺴﻤﻟﺍ ﺕﺎﻗﺎﻄﻨﻟﺍ ﻊﻣ ﺔﻳﺪﻴ
  `pkgbuild`, `release`, `chore`, `ci`, `build`, `docs`.
- Branch naming: `feat/…`, `fix/…`, `docs/…`, `chore/…`, `refactor/…`.
-                                       .ﺪﻴﺣﻮﺗﻭ ﺞﻣﺩ ،ﺞﻣﺪﻟﺍ ﻞﺒﻗ ﺪﺣﺍﻭ ﻊﺟﺍﺮﻣ ﺔﻘﻓﺍﻮﻣ
-                            .`/usr/share/licenses/argvus-boot-splash/LICENSE` ـﻛ ﻪﻨﺤﺷ ﻢﺗ .GPL-3.0-only :ﺔﺼﺧﺮﻟﺍ

##                                                               ﺔﻓﻭﺮﻌﻤﻟﺍ ﺕﺍﺮﻐﺜﻟﺍ

                             :ﻉﺩﻮﺘﺴﻤﻟﺍ ﻖﻴﻗﺪﺗ ءﺎﻨﺛﺃ ﺔﻘﺛﻮﻣ ﺕﺎﻀﻗﺎﻨﺗ ﻰﻠﻋ ﺭﻮﺜﻌﻟﺍ ﻢﺗ

- `README.md` advertises `make test`                          ﻞﻴﺒﻘﻟﺍ ﺍﺬﻫ ﻦﻣ ءﻲﺷ ﺪﺟﻮﻳ ﻻ﻿ ﻦﻜﻟ ،ﺙﻮﻤﻴﻠﺒﻟ ﺓﺮﺷﺎﺒﻣ ﺔﻨﻳﺎﻌﻤﻟ
`sudo plymouth --show-splash` / `sudo plymouthquit`.
-             ﺎﻤﻬﺒﻠﻄﺘﻳﻭ ﺔﻟﻮﻤﺤﻟﺍ ﻲﻓ logo-glow.png ﻭ `entry-line.png` ﻦﺤﺷ ﻢﺘﻳ
 `logo-glow.png` `arch_check_splash_payload()`، ﻦﻜﻟ `argvus.script` ﺎﻣﺇ .ﺍًﺪﺑﺃ ﺎﻬﻠﻴﻤﺤﺘﺑ ﻡﻮﻘﻳ ﻻ﻿
.ﻖﻘﺤﺘﻟﺍ ﺔﻤﺋﺎﻗﻭ ﺔﻟﻮﻤﺤﻟﺍ ﻦﻣ ﻢﻬﻓﺬﺣﺍ ﻭﺃ ﻲﺠﻣﺮﺒﻟﺍ ﺺﻨﻟﺎﺑ ﻢﻬﻠﻴﺻﻮﺘﺑ ﻢﻗ
- `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` is installed but
؛ءﻲﺷ ﻱﺃ ﻊﻣ ﻞﻴﺠﺴﺘﻟﺍ ﻢﺘﻳ ﻢﻟ
  `bootctl`/`ukify` step.
-                                       ) ﻉﺩﻮﺘﺴﻤﻟﺍ ﺭﺬﺟ ﻲﻓ ﺔﻴﻤﺳﺮﻟﺍ ﺕﺍﺪﻨﺘﺴﻤﻟﺍ ﺪﺟﻮﺗ`README.md`,
`DEVELOPMENT.md`) ﻲﻓ ﺔﻟﺩﻷ﻿ﺍ ﻊﻣ ﻞﺧﺍﺪﺗﻭ `docs/`. ﺔﻘﺴﺘﻣ ﺎﻬﻴﻠﻋ ﻆﻓﺎﺣ
    (`CONTRIBUTING.md`، `SECURITY.md`) ﺔﻤﻫﺎﺴﻤﻟﺍ ﺕﺎﺳﺎﻴﺳ .ﺎﻤﻬﻨﻣ ﻱﺃ ﺮﻴﻴﻐﺗ ﺪﻨﻋ
                                     .`.github` ﺔﻤﻈﻨﻤﻟﺍ ﻉﺩﻮﺘﺴﻣ ﻲﻓ ﺶﻴﻌﻳ

##                                                                  ﻖﺋﺎﺛﻮﻟﺍ ﺔﻄﻳﺮﺧ

| Document | Audience | Scope |
| --- | --- | --- |
| `README.md` | everyone | one-paragraph overview and layout |
| `DEVELOPMENT.md` | maintainers | build, signing, release process |

                                                   ﺮﻈﻧﺍ ﻲﻨﻔﻟﺍ ﻊﺟﺮﻤﻟﺍ ﻰﻠﻋ ﻉﻼ﻿ﻃﻼ﻿ﻟ[                                                                 ﻉﻮﺿﻮﻤﻟﺍ ﺔﺳﺪﻨﻫ](/docs/argvus-boot-splash/developer-guide/theme/),
[                                                                       ﻒﻴﻠﻐﺘﻟﺍ](/docs/argvus-boot-splash/developer-guide/packaging/)                                                                             ﻭ[                                                     ﺕﺍﺭﺍﺪﺻﻹ﻿ﺍﻭ ﺮﻤﺘﺴﻤﻟﺍ ﻞﻣﺎﻜﺘﻟﺍ](/docs/argvus-boot-splash/developer-guide/ci-releases/).
                                                             ﻲﻓ ﺔﻴﻠﻤﻌﻟﺍ ﻊﺒﺗﺍ -[CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)                                                                             ﻭ
  [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md).
                                                                ﻲﻓ ﺩﻮﺟﻮﻣ ﻑﺪﻬﻟﺍ[                                                                 ﺕﺎﻤﻴﻠﻌﺘﻟﺍ ﻒﻠﻣ](https://github.com/argvus/argvus-boot-splash/blob/main/Makefile)                                                          ﻲﻫ ﺔﻴﻘﻴﻘﺤﻟﺍ ﺮﻣﺍﻭﻷ﻿ﺍ .
  [                                                                 ﻡﺪﺨﺘﺴﻤﻟﺍ ﻞﻴﻟﺩ](/docs/argvus-boot-splash/uki-splash/)                                                                   ﻞﻴﻟﺪﻟﺍ ﻖﺛﻮﻳ
| [`CONTRIBUTING.md`](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)(org `.github`                      | ﺭﺍﺮﺳﻷ﻿ﺍ ﺔﺳﺎﻴﺳ ،ﺐﺤﺴﻟﺍ ﺪﻋﺍﻮﻗ ،ﺖﻴﺟ ﻞﻤﻋ ﺮﻴﺳ | ﻥﻮﻤﻫﺎﺴﻤﻟﺍ | (
| [`docs/user-guide.md`](/docs/argvus-boot-splash/)          | ﺎﻬﺣﻼ﻿ﺻﺇﻭ ءﺎﻄﺧﻷ﻿ﺍ ﻑﺎﺸﻜﺘﺳﺍ ،ﻡﺍﺪﺨﺘﺳﻻ﻿ﺍ ،ﺖﻴﺒﺜﺘﻟﺍ | ﻥﻮﻴﺋﺎﻬﻨﻟﺍ ﻥﻮﻣﺪﺨﺘﺴﻤﻟﺍ |
| [`docs/developer-guide.md`](/docs/argvus-boot-splash/developer-guide/)(/docs/argvus-boot-splash/developer-guide/) | developers | theme internals, packaging, CI |
