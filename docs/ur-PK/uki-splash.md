---
title: UKI ﺭﻭﺍ systemd-boot ﺶﻠﭙﺳﺍ
description:                       ۔ﮟﯾﺮﮐ ﻝﺎﻤﻌﺘﺳﺍ ﭗﯿﻣ ﭧﺑ ﺶﯿﻠﭙﺳﺍ ARGVUS ﮟﯿﻣ ﻮﻠﻓ ﭦﻮﺑ ﯽﺋﺁ ﮯﮐ ﻮﯾ
---

# UKI ﺭﻭﺍ systemd-boot ﺶﻠﭙﺳﺍ

            ﮯﮨ ﺎﺘﺠﯿﮭﺑ ﯽﮭﺑ (ﮉﺴﯾﺮﭙﻤﮐ ﺮﯿﻏ ﭧﺑ-400x400، 32) `argvus-uki-splash.bmp` `bootctl set-splash`  ﺞﯿﮑﯿﭘ
BMP). ﮧﯾ UKI / systemd-boot ﮯﮨ ﺞﯿﻣﺍ ﺵﻼ﻿ﭙﺳ ﮞﺎﮩﺟ ،ﮯﮨ ﮯﯿﻟ ﮯﮐ ﻮﻠﻓ ﭦﻮﺑ
                ﮯﺋﺎﺟ ﺎﮬﮍﭘ ﮯﺳﺍ ﮧﮐ ﮯﮐ ﺱﺍ ﮯﺋﺎﺠﺑ ﺎﯿﮔ ﺎﯿﮐ ﻁﻮﺑﺮﻣ ﮟﯿﻣ ﺞﯿﻣﺍ ﻞﻧﺮﮐ ﮦﺪﺤﺘﻣ
initramfs.

ﮯﮨ ﺎﯿﮔ ﺎﯿﮐ ﮟﯿﮩﻧ ﺮﭩﺴﺟﺭ ﯽﮭﺑ ﮫﭽﮐ ﺭﻭﺍ ﺎﺗﺎﺟ ﺎﯿﮐ ﮟﯿﮩﻧ ﻝﺎﻤﻌﺘﺳﺍ ﮟﯿﻣ ﻢﯿﮭﺗ ﮫﺗﺅﺎﻤﯿﻠﭘ ﻮﮐ ﭗ
ﻡﺎﻋ ۔ﮟﯿﮨ ﮯﺗﺎﻨﺑ ﮯﺴﯿﮐ UKI ﺎﻨﭘﺍ ﭖﺁ ﮧﮐ ﮯﮨ ﺮﭘ ﺕﺎﺑ ﺱﺍ ﺭﺎﺼﺤﻧﺍ ﺎﮐ ﺱﺍ
صارفین ہیں:

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```

UKI بلڈ کو دوبارہ چلائیں (یا

) whenever the image changes, and
ﮯﮨ ﺎﺗﺮﮐ ﻞﯿﮑﺳﺍ ﻮﮐ systemd-boot  ۔ﮟﯾﺮﮐ ﯽﭘﺎﮐ ﮟﯿﻣ ESP ﻮﮐ ﻞﺋﺎﻓ ﻮﺗ ﮟ
۔ﻮﮨ ﺮﮨﺎﻇ ﮟﯿﻣ ﺰﮐﺮﻣ ﺮﯾﻮﺼﺗ ﻊﺑﺮﻣ ﮏﯾﺍ ﮧﮐﺎﺗ ،ﺮﭘ ﻝﻮﺴﻨﮐ ﻮﮐ ﭗﯿﻣ ﭧِﺑ

— ﮟﯿﮨ ﮯﺘﮑﺳ ﺮﮐ ﺯﺍﺪﻧﺍﺮﻈﻧ ﻞﮑﻟﺎﺑ ﻮﮐ ﻞﺋﺎﻓ ﺱﺍ ﭖﺁ ﻮﺗ ،ﮟﯿﮨ ﮯﺗﺮﮐ ﻝﺎﻤﻌﺘﺳﺍ dracut ﺎﯾ mkin
                                                                       ﮦﺪﻋﺎﻗﺎﺑ[                                                                         ﺐﯿﺼﻨﺗ](/docs/argvus-boot-splash/installation/)                                                         ۔ﮯﮨ ﺎﺘﮑﮬﮈ ﻮﮐ ﮯﺘﺳﺍﺭ ﺱﺍ

##                                                                   ﺕﺎﻣﺍﺪﻗﺍ ﮯﻠﮔﺍ

- [                                                                       ﻝﺎﻤﻌﺘﺳﺍ](/docs/argvus-boot-splash/usage/)
- [                                                                 ﺎﻧﺮﮐ ﻞﺣ ﻞﺋﺎﺴﻣ](/docs/argvus-boot-splash/troubleshooting/)
