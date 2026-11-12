---
title: UKI ﻭ systemd-boot ﺔﻳﺍﺪﺒﻟﺍ ﺔﺷﺎﺷ
description: UKI.  ﺪﻴﻬﻤﺗ ﻖﻓﺪﺗ ﻲﻓ ARGVUS ﺔﻳﺍﺪﺒﻟﺍ ﺓﺭﻮﺻ ﻡﺪﺨﺘﺳﺍ
---

# UKI ﻭ systemd-boot ﺔﻳﺍﺪﺒﻟﺍ ﺔﺷﺎﺷ

            (ﻁﻮﻐﻀﻣ ﺮﻴﻏ ﺖﺑ-400x400، 32) `argvus-uki-splash.bmp` ﻦﺤﺷ ﺎًﻀﻳﺃ ﺔﻣﺰﺤﻟﺍ ﻦﻤﻀﺘﺗ
BMP). ﺪﻴﻬﻤﺘﻟﺍ ﺕﺎﻘﻓﺪﺘﻟ ﺺﺼﺨﻣ ﻮﻫﻭ UKI / systemd-boot، ﻉﻼ﻿ﻗﻹ﻿ﺍ ﺓﺭﻮﺻ ﻥﻮﻜﺗ ﺚﻴﺣ
                           ﻦﻣ ﻪﺗءﺍﺮﻗ ﻢﺘﻳ ﻥﺃ ﻦﻣ ًﻻ﻿ﺪﺑ ﺓﺪﺣﻮﻤﻟﺍ ﺓﺍﻮﻨﻟﺍ ﺓﺭﻮﺻ ﻲﻓ ﻦﻤﻀﻣ
com.initramfs.

       ﺎﻬﻟ ءﻲﺷ ﻱﺃ ﻞﻴﺠﺴﺗ ﻢﺘﻳ ﻢﻟﻭ ﺙﻮﻤﻴﻠﺑ ﻉﻮﺿﻮﻣ ﻞﺒﻗ ﻦﻣ ﺔﻣﺪﺨﺘﺴﻣ *ﺖﺴﻴﻟ* ﺔﻄﻘﻨﻟﺍ ﺓﺭﻮﺻ
                 ﻲﺟﺫﻮﻤﻧ .ﻚﺑ ﺹﺎﺨﻟﺍ UKI ءﺎﻨﺑ ﺔﻴﻔﻴﻛ ﻰﻠﻋ ﻪﻨﻴﻤﻀﺗ ﺪﻤﺘﻌﻳ :ﺎًﻴﺋﺎﻘﻠﺗ ﺖﻧﺃ
المستهلكين هم:

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```

                ﻭ ،ﺓﺭﻮﺼﻟﺍ ﺕﺮﻴﻐﺗ ﺎﻤﻠﻛ (`bootctl set-splash` ﻭﺃ) UKI ءﺎﻨﺑ ﻞﻴﻐﺸﺗ ﺪﻋﺃ
ﻊﺳﻮﺘﻠﻟ ﻞﺑﺎﻗ systemd-boot .ﺮﺧﺁ ﻥﺎﻜﻣ ﻲﻓ ءﺎﻨﺒﻟﺎﺑ ﺖﻤﻗ ﺍﺫﺇ ESP ﻰﻟﺇ ﻒﻠﻤﻟﺍ ﺦﺴﻨﺗ ﻥﺃ ﺮﻛ
.ﻒﺼﺘﻨﻤﻟﺍ ﻲﻓ ﺔﻌﺑﺮﻣ ﺓﺭﻮﺻ ﺮﻬﻈﻳ ﺚﻴﺤﺑ ،ﻢﻜﺤﺘﻟﺍ ﺓﺪﺣﻭ ﻰﻠﻋ ﺏﺎﻣ ﺖﺒﻟﺍ ﺽﺮ

— ﺎًﻣﺎﻤﺗ ﻒﻠﻤﻟﺍ ﺍﺬﻫ ﻞﻫﺎﺠﺗ ﻚﻨﻜﻤﻳ ،ﻂﻘﻓ dracut ﻭﺃ mkinitcpio ﻡﺪﺨﺘﺴ
regular installation covers that path.

##                                                                ﺔﻴﻟﺎﺘﻟﺍ ﺕﺍﻮﻄﺨﻟﺍ

- Usage
- Troubleshooting

                                                                         ﻢﻈﺘﻨﻣ[                                                                         ﺖﻴﺒﺜﺗ](/docs/argvus-boot-splash/installation/)                                                              .ﻖﻳﺮﻄﻟﺍ ﻚﻟﺫ ﻲﻄﻐﻳ

- [                                                                       ﻡﺍﺪﺨﺘﺳﺍ](/docs/argvus-boot-splash/usage/)

- [                                                        ﺎﻬﺣﻼ﻿ﺻﺇﻭ ءﺎﻄﺧﻷ﻿ﺍ ﻑﺎﺸﻜﺘﺳﺍ](/docs/argvus-boot-splash/troubleshooting/)
