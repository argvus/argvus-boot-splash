---
title: Usage
description:                     .ﺕﺎﻤﺴﻟﺍ ﺮﻴﻴﻐﺗﻭ ،ﻞﻴﻐﺸﺘﻟﺍ ﺓﺩﺎﻋﺇ ﻥﻭﺪﺑ ﺔﻨﻳﺎﻌﻣ ،ﺖﻴﺒﺜﺘﻟﺍ ﻦﻣ ﻖﻘﺤﺗ
---

# Usage

            .ﺎﻬﻨﻣ ﻞﻳﻮﺤﺘﻟﺍﻭ ،ﻞﻴﻐﺸﺘﻟﺍ ﺓﺩﺎﻋﺇ ﻥﻭﺪﺑ ﺎﻬﺘﻨﻳﺎﻌﻣ ،ﺔﻤﺴﻟﺍ ﻦﻣ ﻖﻘﺤﺘﻟﺍ ﺔﻴﻔﻴﻛ
                                                                 ﺮﻈﻧﺍ ،ﺖﻴﺒﺜﺘﻠﻟ[                                                                         ﺖﻴﺒﺜﺗ](/docs/argvus-boot-splash/installation/).

##                                                              ﺖﻴﺒﺜﺘﻟﺍ ﻦﻣ ﻖﻘﺤﺘﻟﺍ

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```

##                                                    ﻞﻴﻐﺸﺘﻟﺍ ﺓﺩﺎﻋﺇ ﻥﻭﺪﺑ ﺔﻨﻳﺎﻌﻤﻟﺍ

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```

                      .ﻱﺩﺎﻋ ﻡﺪﺨﺘﺴﻤﻛ ﻞﻴﻐﺸﺘﻟﺍ ﺪﻨﻋ polkit ﺔﻗﺩﺎﺼﻣ ﺔﻨﻳﺎﻌﻤﻟﺍ ﺐﻠﻄﻳ ﺪﻗ
                   :ﺕﻻ﻿ﺎﺤﻟﺍ ﺽﺮﻓ ﺎًﻀﻳﺃ ﻚﻨﻜﻤﻳ ؛ﻰﻛﺎﺤﻤﻟﺍ ﻡﺪﻘﺘﻟﺍ ﻊﻣ ﻡﺪﻘﺘﻳ ﻡﺪﻘﺘﻟﺍ ﻂﻳﺮﺷ

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```

ﺔﻴﻟﺎﺘﻟﺍ ﺔﺷﺎﺸﻟﺍ ﻰﻟﺇ ﻞﻘﻨﺘﻠﻟ <kbd>Esc</kbd> ﻰﻠﻋ ﻂﻐﺿﺍ ،ﺔﻴﺒﻴ
(splash → details → splash).

##                                                                  ﺵﺮﻟﺍ ﻩﺮﻬﻈﻳ ﺎﻣ

| Stage | Appearance |
| --- | --- |
| ﻡﺪﻘﺘﻟﺍ ﺭﺎﺴﻣ ،ﺔﻳﺭﺎﺠﺘﻟﺍ ﺔﻣﻼ﻿ﻌﻟﺍ ،ﺭﺎﻌﺸﻟﺍ :ﺓﺪﺣﺍﻭ ﺔﻴﻧﺎﺛ ﻲﻟﺍﻮﺣ ﻝﻼ﻿ﺧ ﺎًﻴﺠﻳﺭﺪﺗ ﺮﻬﻈﻳ ءﻲﺷ
     | ﻡﺪﻘﺘﻟﺍ ﻦﻋ Plymouth ﺞﻣﺎﻧﺮﺑ ﻎﻠﺒﻳ ﺎﻤﻨﻴﺑ ﺭﺎﺴﻴﻟﺍ ﻦﻣ ﻂﻳﺮﺸﻟﺍ ﺊﻠﺘﻤﻳ | ﺪﻴﻬﻤﺘﻟﺍ |
| ﻂﻳﺮﺸﻟﺍ ﻞﻔﺳﺃ ﺔﻨﻄﺒﻣ ﻁﺎﻘﻧﻭ ﺔﺒﻟﺎﻄﻤﻟﺍ ﺺﻧ ﺮﻬﻈﻳ ،٪15 ﻰﻟﺇ ﺔﻴﺴﻴﺋﺮﻟﺍ ﺔﺷﺎﺸﻟﺍ ﻰﺷﻼ﻿ﺘﺗ | ﺓﺮ
| ﺔﻠﻣﺎﻛ ﺡﻮﺿﻭ ﺔﺟﺭﺩ ﻰﻟﺇ ﻱﺪﻴﻬﻤﺘﻟﺍ ﺽﺮﻌﻟﺍ ﺩﻮﻌﻳﻭ ،ﺭﺍﻮﺤﻟﺍ ﻲﻔﺘﺨﻳ | ﺭﻭﺮﻤﻟﺍ ﺓﺭﺎﺒﻋ ﻝﻮﺒﻗ ﻢ

##                                                         ﺔﻤﺴﻟﺍ ﺓﺩﺎﻌﺘﺳﺍ ﻭﺃ ﺮﻴﻴﻐﺗ

```sh
# switch theme (any theme name under /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# then regenerate the initramfs
sudo mkinitcpio -P              # or: sudo dracut --regenerate-all
```

Useful configuration files:

| File | Purpose |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` written by the package |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` must include `plymouth` |
| `/etc/plymouth/plymouthd.conf` (again) | `PLYMOUTH_TOGGLE_KEY` etc. are global, not per-theme |

##                                                                 ﺮﻣﺍﻭﻷ﻿ﺍ ﺶﻏ ﺔﻗﺭﻭ

| Command | Effect |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | make `argvus` the default theme |
| `sudo plymouth-update-theme` | apply the change to the running Plymouth |
| `sudo plymouth --show-splash` | show the splash in the current session |
| `sudo plymouth --show-details` | show verbose boot messages instead |
| `sudo plymouthquit` | leave Plymouth and restore your session |
| `sudo mkinitcpio -P` | rebuild the Arch initramfs |
| `sudo dracut --regenerate-all` | rebuild the initramfs with dracut |

##                                                                ﺔﻴﻟﺎﺘﻟﺍ ﺕﺍﻮﻄﺨﻟﺍ

- [UKI ﻉﻼ﻿ﻗﻹ﻿ﺍ ﻡﺎﻈﻧﻭ systemd-boot](/docs/argvus-boot-splash/uki-splash/)
- [                                                                 ﺖﻴﺒﺜﺘﻟﺍ ءﺎﻐﻟﺇ](/docs/argvus-boot-splash/uninstallation/)
- Troubleshooting

- [                                                        ﺎﻬﺣﻼ﻿ﺻﺇﻭ ءﺎﻄﺧﻷ﻿ﺍ ﻑﺎﺸﻜﺘﺳﺍ](/docs/argvus-boot-splash/troubleshooting/)
