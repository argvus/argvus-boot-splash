---
title: الاستخدام
description:                     .ﺕﺎﻤﺴﻟﺍ ﺮﻴﻴﻐﺗﻭ ،ﻞﻴﻐﺸﺘﻟﺍ ﺓﺩﺎﻋﺇ ﻥﻭﺪﺑ ﺔﻨﻳﺎﻌﻣ ،ﺖﻴﺒﺜﺘﻟﺍ ﻦﻣ ﻖﻘﺤﺗ
---

# الاستخدام

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
(دفقة → تفاصيل → سبلاش).

##                                                                  ﺵﺮﻟﺍ ﻩﺮﻬﻈﻳ ﺎﻣ

| المرحلة | المظهر |
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

ملفات التكوين المفيدة:

| ملف | الغرض |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` مكتوب بواسطة الحزمة |
| `/etc/mkinitcpio.conf` | يجب أن يتضمن `HOOKS=(... plymouth ...)` `plymouth` |
| `/etc/plymouth/plymouthd.conf` (مرة أخرى) | `PLYMOUTH_TOGGLE_KEY` وما إلى ذلك هي عالمية وليست لكل سمة |

##                                                                 ﺮﻣﺍﻭﻷ﻿ﺍ ﺶﻏ ﺔﻗﺭﻭ

| الأمر | تأثير |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | جعل `argvus` السمة الافتراضية |
| `sudo plymouth-update-theme` | تطبيق التغيير على تشغيل بليموث |
| `sudo plymouth --show-splash` | إظهار البداية في الجلسة الحالية |
| `sudo plymouth --show-details` | إظهار رسائل التمهيد المطولة بدلاً من ذلك |
| `sudo plymouthquit` | غادر بليموث واستعد جلستك |
| `sudo mkinitcpio -P` | إعادة بناء القوس initramfs |
| `sudo dracut --regenerate-all` | أعد بناء initramfs باستخدام dracut |

##                                                                ﺔﻴﻟﺎﺘﻟﺍ ﺕﺍﻮﻄﺨﻟﺍ

- [UKI ﻉﻼ﻿ﻗﻹ﻿ﺍ ﻡﺎﻈﻧﻭ systemd-boot](/docs/argvus-boot-splash/uki-splash/)
- [                                                                 ﺖﻴﺒﺜﺘﻟﺍ ءﺎﻐﻟﺇ](/docs/argvus-boot-splash/uninstallation/)
- Troubleshooting

- [                                                        ﺎﻬﺣﻼ﻿ﺻﺇﻭ ءﺎﻄﺧﻷ﻿ﺍ ﻑﺎﺸﻜﺘﺳﺍ](/docs/argvus-boot-splash/troubleshooting/)
