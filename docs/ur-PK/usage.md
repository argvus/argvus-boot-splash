---
title: استعمال
description:      ۔ﮟﯾﺮﮐ ﻞﯾﺪﺒﺗ ﺰﻤﯿﮭﺗ ﺭﻭﺍ ،ﮟﯾﺮﮐ ﮦﺭﺎﻈﻧ ﺶﯿﭘ ﮯﮐ ﭦﻮﺒﯾﺭ ﺮﯿﻐﺑ ،ﮟﯾﺮﮐ ﻖﯾﺪﺼﺗ ﯽﮐ ﻝﺎﭩﺴﻧﺍ
---

# استعمال

۔ﮟﯾﺮﮐ ﭻﺋﻮﺳ ﺮﭘ ﻢﯿﮭﺗ ﮮﺮﺳﻭﺩ ﺮﮐ ﮌﻮﮭﭼ ﮯﺳﺍ ﺭﻭﺍ ،ﮟﯾﺮﮐ ﮦﺭﺎﻈﻧ ﺶﯿﭘ ﮯﯿﮐ ﻉﻭﺮﺷ ﮦﺭﺎﺑﻭﺩ ﺮﯿﻐﺑ
                                                          ﮟﯿﮭﮑﯾﺩ ،ﮯﯿﻟ ﮯﮐ ﺐﯿﺼﻨﺗ[                                                                         ﺐﯿﺼﻨﺗ](/docs/argvus-boot-splash/installation/).

##                                                            ﺎﻧﺮﮐ ﻖﯿﺛﻮﺗ ﯽﮐ ﺐﯿﺼﻨﺗ

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```

##                                                        ﮦﺭﺎﻈﻧ ﺶﯿﭘ ﮯﮐ ﭦﻮﺒﯾﺭ ﺮﯿﻐﺑ

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```

۔ﮯﮨ ﺎﺘﮑﺳﺮﮐ ﺐﻠﻃ ﻖﯾﺪﺼﺗ ﭧِﮑﻟﻮﭘ ﮦﺭﺎﻈﻧ ﺶﯿﭘ ﻮﺗ ﮯﺋﺎﺟ ﺎﯾﻼ﻿ﭼ ﺮﭘ ﺭﻮﻃ ﮯﮐ ﻑﺭﺎﺻ ﻡﺎﻋ ﮏﯾﺍ ﮯﺳﺍ ﺐ
:ﮟﯿﮨ ﮯﺘﮑﺳ ﺮﮐ ﺭﺮﻘﻣ ﯽﮭﺑ ﯽﺘﺳﺩﺮﺑﺯ ﻮﮐ ﺕﻻ﻿ﺎﺣ ﭖﺁ ؛ﮯﮨ ﯽﺘﮬﮍﺑ ﮯﮔﺁ ﮫﺗﺎﺳ ﮯﮐ ﺖﻓﺭ ﺶﯿﭘ ﯽﻋﻮﻨﺼﻣ

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```

ﮟﯿﺋﺎﺑﺩ <kbd>Esc</kbd> ﮯﯿﻟ ﮯﮐ ﮯﻧﺎﺟ ﺮﭘ ﻦﯾﺮﮑﺳﺍ ﮯﻠﮔﺍ ،ﻮﮨ ﺮﭘ
(سپلیش → تفصیلات → سپلیش)۔

##                                                             ﮯﮨ ﯽﺗﺎﮭﮐﺩ ﮏﭙﮭﭼ ﺎﯿﮐ

| اسٹیج | ظاہری شکل |
| --- | --- |
| ﮏﯾﺮﭨ ﺲﯾﺮﮔﺍﺮﭘ ،ﮎﺭﺎﻣ ﮈﺭﻭ ،ﻮﮔﻮﻟ :ﮯﮨ ﺎﺗﻮﮨ ﺮﮨﺎﻇ ﮫﭽﮐ ﺐﺳ ﮟﯿﻣ ﮉﻨﮑﯿﺳ 1 ًﺎﺒﯾﺮﻘﺗ | ﭖﺍ ﭦﺭ
| ﮯﮨ ﯽﺗﻮﮨ ﻉﻭﺮﺷ ﺎﻧﺮﮭﺑ ﮯﺳ ﻑﺮﻃ ﮟﯿﺋﺎﺑ ﺭﺎﺑ ،ﮯﮨ ﺎﺘﯾﺩ ﻉﻼ﻿ﻃﺍ ﯽﮐ ﺖﻓﺭ ﺶﯿﭘ ﮫﺗﻮﻤﯿﻠﭘ ﯽﮨ ﮯﺴﯿﺟ
| ﮟﯿﮨ ﮯﺗﻮﮨ ﺮﮨﺎﻇ ﮯﭽﯿﻧ ﮯﮐ ﺭﺎﺑ ﺲﭩﻠﺑ ﮦﺪﺷ ﮏﺳﺎﻣ ﺭﻭﺍ ﻦﺘﻣ ﭧﭙﻣﺍﺮﭘ ،ﮯﮨ ﺎﺗﺎﺟ ﻮﮨ ﻢﮬﺪﻣ ﮏﺗ ٪
| ﮯﮨ ﯽﺗﺎﺟ ﺁ ﺮﭘ ﺖﯿﻓﺎﻔﺷ ﻞﻤﮑﻣ ﮦﺭﺎﺑﻭﺩ ﺶﻠﭙﺳﺍ ،ﮯﮨ ﺎﺗﺎﺟ ﻮﮨ ﺐﺋﺎﻏ ﮒﻼ﻿ﯿﺋﺍﮈ | ﺎﯿﮔ ﺎﯿﻟ ﺮﮐ ﻝ

##                                                ﺎﻧﺮﮐ ﺲﭘﺍﻭ ﺎﯾ ﺎﻧﺮﮐ ﻞﯾﺪﺒﺗ ﻮﮐ ﻢﯿﮭﺗ

```sh
# switch theme (any theme name under /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# then regenerate the initramfs
sudo mkinitcpio -P              # or: sudo dracut --regenerate-all
```

مفید کنفیگریشن فائلیں:

| فائل | مقصد |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` پیکیج کے ذریعہ لکھا گیا |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` میں `plymouth` شامل ہونا ضروری ہے۔
| `/etc/plymouth/plymouthd.conf` (دوبارہ) | `PLYMOUTH_TOGGLE_KEY` وغیرہ عالمی ہیں، فی تھیم نہیں |

##                                                                 ﭧﯿﺷ ﭧﯿﭼ ﺯﮉﻧﺎﻤﮐ

| کمانڈ | اثر |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | `argvus` کو ڈیفالٹ تھیم بنائیں |
| `sudo plymouth-update-theme` | تبدیلی کو چلانے والے Plymouth پر لاگو کریں۔
| `sudo plymouth --show-splash` | موجودہ سیشن میں سپلیش دکھائیں |
| `sudo plymouth --show-details` | اس کے بجائے وربوز بوٹ پیغامات دکھائیں |
| `sudo plymouthquit` | Plymouth چھوڑیں اور اپنے سیشن کو بحال کریں۔
| `sudo mkinitcpio -P` | آرک initramfs کو دوبارہ بنائیں |
| `sudo dracut --regenerate-all` | initramfs کو dracut کے ساتھ دوبارہ بنائیں |

##                                                                   ﺕﺎﻣﺍﺪﻗﺍ ﮯﻠﮔﺍ

- [UKI ﺭﻭﺍ systemd-boot ﺵﻼ﻿ﭙﺳﺍ](/docs/argvus-boot-splash/uki-splash/)
- [                                                               ﺎﻧﺎﭩﮨ ﻦﺸﯿﻟﺎﭩﺴﻧﺍ](/docs/argvus-boot-splash/uninstallation/)
- [                                                                 ﺎﻧﺮﮐ ﻞﺣ ﻞﺋﺎﺴﻣ](/docs/argvus-boot-splash/troubleshooting/)
