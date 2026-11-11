---
title: Troubleshooting
description: .ﺎﻬﺣﻼ﻿ﺻﺇ ﺔﻴﻔﻴﻛﻭ ﺔﻌﺋﺎﺸﻟﺍ ﺏﻮﺳﺎﺤﻟﺍ ﺪﻴﻬﻤﺗ ﺔﺷﺎﺷ ﺽﺍﺮﻋﺃ
---

# Troubleshooting

**.ﺖﻴﺒﺜﺘﻟﺍ ﺪﻌﺑ ﺵﺮﻟﺍ ﺮﻴﻐﺘﻳ ﻢﻟ**
( ﻭﺃ) sudo mkinitcpio -P ﻞﻴﻐﺸﺘﺑ ﻢﻗ .initramfs ءﺎﺸﻧﺇ ﺓﺩﺎﻋﺇ ﻢﺘﻳ ﻢ
sudo mkinitcpio -P) and reboot. If your system uses multiple kernels,
.ﺪﻳﺪﺠﻟﺍ initramfs ﻰﻠﻋ ﻞﺼﺣ ﻪﻋﻼ﻿ﻗﺈﺑ ﺖﻤﻗ ﻱﺬﻟﺍ ﺯﺎﻬﺠﻟﺍ ﻥﺃ ﻦﻣ ﺪﻛﺄﺗ

**.ﻂﻘﻓ ﺺﻧ ﻭﺃ ءﺍﺩﻮﺳ ﺔﺷﺎﺸﻟﺍ ؛ﻕﻼ﻿ﻃﻹ﻿ﺍ ﻰﻠﻋ ﺔﻴﺒﻴﺣﺮﺗ ﺔﺷﺎﺷ ﻱﺃ ﺪﺟﻮﻳ ﻻ﻿**
`sudo mkinitcpio -P` is missing from the initramfs hooks. Check `sudo dracut --regenerate-all`
`plymouth` contains `/etc/mkinitcpio.conf`  `HOOKS=(...)` `plymouth`  `plymouth`  HOOKS=(...) , then rebuild and reboot. On Ubuntu/Debian,
    `plymouth-x11`/`plymouth-themes` ﻭ plymouth ﺖﻴﺒﺜﺗ ﻦﻣ ﺎًﻀﻳﺃ ﺪﻛﺄﺗ
                                  .splash quiet ﻪﻳﺪﻟ `GRUB_CMDLINE_LINUX` ﻥﺃ

                                                       **.ﻡﺪﻘﺗ ﻻ﻿ ،ﺭﺎﻌﺸﻟﺍ ﻂﻘﻓ**
ﻡﺪﻘﺘﻟﺍ ءﺎﻋﺪﺘﺳﺍ ﻥﺃ ﻭﺃ ،ﻚﺑ ﺹﺎﺨﻟﺍ init ـﻟﺍ ﺔﻄﺳﺍﻮﺑ ﺎﻬﻨﻋ ﻍﻼ﻿ﺑﻹ﻿ﺍ ﻢﺘﻳ ﻻ﻿ ﻉﻼ﻿ﻗﻹ﻿ﺍ ﺕﺍﻮﻄﺧ ﺾﻌ
                   ﺙﻮﻤﻴﻠﺑ ﻦﻣ ﺊﻠﺘﻤﻳ ﺐﻴﻀﻘﻟﺍ .ﻚﺒﻧﺎﺟ ﻦﻣ ﺭﻮﺴﻜﻣ ءﻲﺷ ﻻ﻿ — ﺍًﺪﺑﺃ ﻞﺼﺘُﻳ ﻢﻟ
(systemd ﻊﻣ ﻝﺎﺜﻤﻟﺍ ﻞﻴﺒﺳ ﻰﻠﻋ) ﺕﺍﺩﺍﺪﻋﻹ﻿ﺍ ﺾﻌﺑ ﻲﻓ ﻪﻴﻟﺇ ﺮﻘﺘﻔﻳ ﻱﺬﻟﺍﻭ ،ﻪﻨﻋ ﻎﻠﺒﻤﻟﺍ ﻡﺪﻘﺘ
dracut).  ﺕﺍﺪﺣﻭ ﺾﻌﺑ ﻭﺃ  `splash quiet` `plymouth-spawn` ﻥﻭﺪﺑ ﺕﻼ﻿ﺴﻠﺴﺗ

                                **.ﻲﺋﺮﻣ ﺮﻴﻏ ﻭﺃ ﺊﻃﺎﺧ ﻥﺎﻜﻣ ﻲﻓ ﺭﻭﺮﻤﻟﺍ ﺔﻤﻠﻛ ﻪﺟﻮﻣ**
               ﻑﺮﻄﺘﻣ ﻮﻬﻓ ﻚﻟﺬﻟ ،ﺭﺎﺴﻤﻟﺍ ﻦﻳﻮﻜﺗﻭ ﺔﻳﺭﺎﺠﺘﻟﺍ ﺔﻣﻼ﻿ﻌﻟﺍ ﻦﻣ ﺭﺍﻮﺤﻟﺍ ﻊﺿﻭ ﻢﺘﻳ
    ﺎًﻴﻌﻴﺒﻃ ﺎًﻌﺿﻭ ﻡﺪﺨﺘﺳﺍ .ﺝﺭﺎﺨﻠﻟ ﺔﺷﺎﺸﻟﺍ (ﺍًﺪﺟ ﺮﻴﻐﺼﻟﺍ ﺺﻨﻟﺍ ﻊﺿﻭ) ﺔﻗﺪﻟﺍ ﻊﻓﺪﺗ ﻥﺃ ﻦﻜﻤﻳ
                               .ﺔﻌﺋﺎﺸﻟﺍ ﺕﺎﻗﺪﻟﺍ ﺪﻨﻋ ﺖﺛﺪﺣ ﺍﺫﺇ ﺎﻬﻨﻋ ﻍﻼ﻿ﺑﻹ﻿ﺍﻭ ،ﺔﻗﺪﻟﺍ

**.ﻚﻟﺫ ﻦﻣ ًﻻ﻿ﺪﺑ ﺹﻮﺼﻨﻟﺍ ﺓﺪﺣﻭ ﻯﺮﺘﺳ / ﺍًﺮﻜﺒﻣ ﺐﺤﺴﻨﻳ ﺙﻮﻤﻴﻠﺑ**
       ﺃ ،splash ﻥﻭﺪﺑ `quiet` ﻉﻼ﻿ﻗﻹ﻿ﺍ ﺔﻤﻠﻌﻣ :ﺙﻮﻤﻴﻠﺑ ﻞّﻄﻋ ءﻲﺷ
 `splash` `plymouth`             ﻰﻟﺇ ﺙﻮﻤﻴﻠﺑ ﺝﺮﺨﺗ .ﻪﻣﺍﺪﺨﺘﺳﺍ ﺙﻮﻤﻴﻠﺒﻟ ﻦﻜﻤﻳ ﻻ﻿ ﻖﺋﺎﺳ ﻭﺃ ،ﻑﺎﻄﺨﻟﺍ ﺔﻟﺍﺯﺇ ﻢﺗ
                      .ﻊﻗﻮﺘﻣ ﻙﻮﻠﺴﻟﺍ ﺍﺬﻫ — ﺯﺎﻬﺠﻟﺍ ﺪﻴﻤﺠﺗ ﻦﻣ ًﻻ﻿ﺪﺑ ﺹﻮﺼﻨﻟﺍ ﻢﻜﺤﺗ ﺓﺪﺣﻭ

                       **.`argvus-plymouth` ﻦﻣ ﺔﻴﻗﺮﺘﻟﺍ ﺪﻌﺑ ﺔﻤﺴﻟﺍ ﻖﻴﺒﻄﺗ ﻢﺘﻳ ﻻ﻿**
              `/etc/plymouth/plymouthd.conf` ﻪﻟﻮﻘﻳ ﺎﻤﻣ ﻖﻘﺤﺗ ؛ﺔﻤﻳﺪﻘﻟﺍ ﻞﺤﻣ ﻞﺤﺗ ﺓﺪﻳﺪﺠﻟﺍ ﺔﻣﺰﺤﻟﺍ
`PLYMOUTH_THEME_NAME=argvus` and rebuild the initramfs.

**.ﻊﻴﻗﻮﺘﻟﺍ ﻦﻣ ﻖﻘﺤﺘﻟﺍ ﻲﻓ ﺖﻴﺒﺜﺘﻟﺍ ﻞﺸﻓ**
ﻲﻟﺎﺤﻟﺍ  ﺩﺍﺮﻴﺘﺳﺍ ﺪﻋﺃ .ﻚﺤﻴﺗﺎﻔﻣ ﺔﻠﺴﻠﺳ ﻲﻓ ﻢﻳﺪﻗ ﻭﺃ ﺩﻮﻘﻔﻣ ﻉﺩﻮﺘﺴﻤﻟﺍ ﺡ
public key, then `sudo pacman -Sy`.

**.ﺮﻴﻴﻐﺗ ﻥﻭﺩ ﻭﺪﺒﺗ ﻥﻮﻜﺴﻟﺍ / ﻞﻔﻘﻟﺍ ﺔﺷﺎﺷ**
ﻞﺼﻔﻨﻣ ﻞﻜﺸﺑ ﻑﺎﻨﺌﺘﺳﻻ﻿ﺍ/ﺕﺎﺒﺳﻹ﻿ﺍ ﺕﺎﺷﺎﺷ ﻲﻓ ﻢﻜﺤﺘﻟﺍ ﻢﺘﻳ .ﻂﻘﻓ ﻉﻼ﻿ﻗﻹ﻿ﺍ ﺔﺷﺎ
(`systemd-homed`، ﻡﺍﺪﺨﺘﺳﺍ ،ﺔﺷﺎﺸﻟﺍ ﻝﺎﻔﻗﺃ `plymouth` ﻚﺑ ﺹﺎﺨﻟﺍ ﻥﻮﻜﺴﻟﺍ ﻑﺪ
initramfs).

                             **.ﻖﺒﺴﻣ ﺽﺮﻋ ﺪﻌﺑ ﻞﻤﻌﺗ ﺔﻟﺎﻀﻟﺍ ﺙﻮﻤﻳﻼ﻿ﺑ ﺓﺭﺎﻴﺳ ﻝﺍﺰﻳ ﻻ﻿**
`sudo plymouthquit` ﻰﻟﺇ ﻞﻳﺪﺒﺘﻟﺎﺑ ﻢﻗ ،ءﺍﺩﻮﺳ ﺔﺷﺎﺸﻟﺍ ﺖﻴﻘﺑ ﺍﺫﺇ .ﻚﺘﺴﻠﺟ ﺪﻴﻌﺘﺴﻳ
                        .ﺔﻤﻴﻠﺳ ﻚﺘﺴﻠﺟ — (`Ctrl+Alt+F2`) ﻯﺮﺧﺃ ﺔﻴﺿﺍﺮﺘﻓﺍ ﺔﻴﻓﺮﻃ

##                                                                ﺔﻴﻟﺎﺘﻟﺍ ﺕﺍﻮﻄﺨﻟﺍ

- [                                                                       ﺖﻴﺒﺜﺘﻟﺍ](/docs/argvus-boot-splash/installation/)                                                .ﺔﻔﻠﺘﺨﻣ ﺔﻘﻳﺮﻄﺑ ﻯﺮﺧﺃ ﺓﺮﻣ ﻝﻭﺎﺣ —
- [Usage](/docs/argvus-boot-splash/usage/) for the installed and user paths.
