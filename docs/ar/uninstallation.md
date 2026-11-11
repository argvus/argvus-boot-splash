---
title: Uninstallation
description: .ﻚﺑ ﺹﺎﺨﻟﺍ ﻖﺑﺎﺴﻟﺍ ﺪﻴﻬﻤﺘﻟﺍ ﻉﻮﺿﻮﻣ ﺓﺩﺎﻌﺘﺳﺍﻭ ﺔﻣﺰﺤﻟﺍ ﺔﻟﺍﺯﺈﺑ ﻢﻗ
---

# Uninstallation

```sh
sudo pacman -Rns argvus-boot-splash
```

ﻞﺧﺍﺩ ﻢﻳﺪﻘﻟﺍ ﺽﺮﻌﻟﺍ ﻰﻘﺒﻴﺳ ﻻ﻿ﺇﻭ ،ءﺎﻨﺒﻟﺍ ﺪﻋﺃﻭ ﺮﺧﺁ ﺎًﻋﻮﺿﻮﻣ ﺮﺘﺧﺍ ﻢﺛ
initramfs:

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```

 also removes 

 if nothing else
created it.

ﻉﻮﺿﻮﻣ ﻱﺃ ﻦﻤﺨﻳ ﻻ﻿ﻭ — ﻂﻘﻓ ﺍًﺮﻴﻛﺬﺗ ﻊﺒﻄﻳ ﺔﻣﺰﺤﻟﺍ ﺔﻟﺍﺯﺇ ﻑﺎﻄﺧ
.ﻚﺑ ﺹﺎﺨﻟﺍ initramfs ﺲﻤﻳ ﻻ﻿ ﻮﻫﻭ ،ﻚﻟﺫ ﻦﻣ ﺎًﻟﺪﺑ ﺪﻳﺮﺗ

##                                                                ﺔﻴﻟﺎﺘﻟﺍ ﺕﺍﻮﻄﺨﻟﺍ

- Troubleshooting — restoring the previous splash.
- [Installation](/docs/argvus-boot-splash/troubleshooting/) — reinstalling later.
 /etc/plymouth/plymouthd.conf  `pacman -Rns` `/etc/plymouth/plymouthd.conf`  

- [Troubleshooting](/docs/argvus-boot-splash/installation/) — restoring the previous splash.
