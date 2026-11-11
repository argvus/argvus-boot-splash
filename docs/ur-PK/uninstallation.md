---
title: Uninstallation
description:                            ۔ﮟﯾﺮﮐ ﻝﺎﺤﺑ ﻮﮐ ﻢﯿﮭﺗ ﭦﻮﺑ ﮧﻘﺑﺎﺳ ﮯﻨﭘﺍ ﺭﻭﺍ ﮟﯾﺩ ﺎﭩﮨ ﺞﯿﮑﯿﭘ
---

# Uninstallation

```sh
sudo pacman -Rns argvus-boot-splash
```

ﺎﮔ ﮯﺋﺎﺟ ﮦﺭ ﺭﺪﻧﺍ ﺵﻼ﻿ﭙﺳﺍ ﺎﻧﺍﺮﭘ ﮧﻧﺭﻭ ،ﮟﯾﺮﮐ ﺮﯿﻤﻌﺗ ﮦﺭﺎﺑﻭﺩ ﺭﻭﺍ ﮟﯾﺮﮐ ﺐﺨﺘﻨﻣ ﻢﯿﮭﺗ ﺭﻭﺍ ﮏﯾ
initramfs:

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```

`pacman -Rns` ﻮﺗ ﻮﮨ ﮧﻧ ﺭﻭﺍ ﮫﭽﮐ ﺮﮔﺍ `/etc/plymouth/plymouthd.conf` ﮯﮨ ﺎﺘﯾﺩ ﺎﭩﮨ ﯽﮭﺑ ﻮﮐ
created it.

ﮯﮨ ﻢﯿﮭﺗ ﺎﺳ ﻥﻮﮐ ﮧﮐ ﺎﺗﺎﮕﻟ ﮟﯿﮩﻧ ﮦﺯﺍﺪﻧﺍ ﮧﯾ — ﮯﮨ ﺎﺗﺮﮐ ﭧﻧﺮﭘ ﯽﻧﺎﮨﺩ ﺩﺎﯾ ﮏﯾﺍ ﻑﺮﺻ ﮏﮨ ﺎﮐ 
              ۔ﺎﺗﺮﮐ ﮟﯿﮩﻧ ﺮﺛﺎﺘﻣ ﻮﮐ initramfs ﮯﮐ ﭖﺁ ﮧﯾ ﺭﻭﺍ ،ﻖﺑﺎﻄﻣ ﮯﮐ ﺶﮨﺍﻮﺧ ﯽﮐ ﭖﺁ

##                                                                   ﺕﺎﻣﺍﺪﻗﺍ ﮯﻠﮔﺍ

- [                                                                 ﺎﻧﺮﮐ ﻞﺣ ﻞﺋﺎﺴﻣ](/docs/argvus-boot-splash/troubleshooting/)                                                    ۔ﺎﻧﺮﮐ ﻝﺎﺤﺑ ﻮﮐ ﺶﻠﭙﺳ ﮯﻠﮭﭽﭘ —
- [Installation](/docs/argvus-boot-splash/installation/) for the installed and user paths.
