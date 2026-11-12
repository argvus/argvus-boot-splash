---
title: التثبيت
description: .ﺔﻣﺰﺤﻟﺍ ﻂﺑﺍﻭﺭ ﻪﺑ ﻡﻮﻘﺗ ﺎﻣﻭ ،ﺖﻴﺒﺜﺘﻟﺍ ﺕﺍﺭﺎﻴﺧ ،ﺕﺎﺒﻠﻄﺘﻤﻟﺍ
---

# التثبيت

             .Arch ﻰﻠﻋ ﻢﺋﺎﻗ ﻡﺎﻈﻧ ﻰﻠﻋ Argvus ﻞﻴﻤﺤﺗ ﺔﺷﺎﺷ ﻰﻠﻋ ﻝﻮﺼﺤﻠﻟ ﻪﺟﺎﺘﺤﺗ ﺎﻣ ﻞﻛ

                                    ﻰﻟﺇ ﺮﻈﻧﺍ ،ﻪﻳﻮﺘﺤﻳ ﺎﻣﻭ ﻉﻮﺿﻮﻤﻟﺍ ﻪﻴﻠﻋ ﻭﺪﺒﻳ ﺎﻤﻟ
[                                                                          ﻊﺟﺮﻣ](/docs/argvus-boot-splash/reference/)                                  ﻰﻟﺇ ﺮﻈﻧﺍ ،ﻚﻟﺫ ﻦﻣ ًﻻ﻿ﺪﺑ ﺭﺪﺼﻤﻟﺍ ﻦﻣ ﻪﺋﺎﻨﺑ ﺓﺩﺎﻋﻹ﻿ .
[                                                                   ﺭﻮﻄﻤﻟﺍ ﻞﻴﻟﺩ](/docs/argvus-boot-splash/developer-guide/).

## المتطلبات

- .(ﻪﻴﻠﻋ ﺪﻤﺘﻌﺗ ﺔﻣﺰﺤﻟﺍ) `plymouth` ﻡﺪﺨﺘﺴﻳ Arch ﻰﻠﻋ ﻢﺋﺎﻗ ﻡ
-             ﻝﺍ .**dracut** ﻭﺃ (ﺵﺭﺃ ﻲﻓ ﻲﺿﺍﺮﺘﻓﻹ﻿ﺍ) **initramfs: **mkinitcpio ﺪﻟﻮﻣ
                 .ﻚﻠﺟﺃ ﻦﻣ initramfs ءﺎﻨﺑ ﺪﻴﻌﻳﻭ ﺩﻮﺟﻮﻣ ﻮﻫ ﺎﻤﻋ ﻒﺸﻜﻟﺎﺑ ﺖّﺒﺜﻤﻟﺍ ﻡﻮﻘﻳ
-                 ,mkinitcpio ﻊﻣ .ﻚﺑ ﺹﺎﺨﻟﺍ initramfs ﻦﻳﻮﻜﺗ ﻲﻓ Plymouth ﻦﻴﻜﻤﺗ ﺐﺠﻳ
  تأكد من وجود `plymouth` في قائمة `HOOKS` الخاصة بـ `/etc/mkinitcpio.conf`:

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```

                                          .ﻮﺘﻠﻟ ﺍﺬﻫ ﺮﻴﻴﻐﺘﺑ ﺖﻤﻗ ﺍﺫﺇ ﻞﻴﻐﺸﺘﻟﺍ ﺪﻋﺃ

-                            ﻲﻓ ﻂﻘﻓ ﻞﻤﻌﻳ ﻉﻮﺿﻮﻤﻟﺍ ؛ﺔﻳﺩﺎﻋ ﺔﻴﻣﻮﺳﺭ ﺔﺴﻠﺠﻟ ﺏﻮﻠﻄﻣ ءﻲﺷ ﻻ﻿
  مسار التمهيد.

##                                        (ﻪﺑ ﻰﺻﻮﻣ) ﻲﻤﺳﺮﻟﺍ ﻡﺰﺤﻟﺍ ﻉﺩﻮﺘﺴﻣ :1 ﺭﺎﻴﺨﻟﺍ

                                    Argvus ﻡﺰﺣ ﻉﺩﻮﺘﺴﻣ ﻲﻓ ﺔﻌﻗﻮﻤﻟﺍ ﻡﺰﺤﻟﺍ ﺮﺸﻧ ﻢﺘﻳ
(`argvus/packages`، ﺭﺎﺴﻤﻟﺍ `public/arch/$arch`). ﻰﻟﺇ ﻪﻔﺿﺃ `/etc/pacman.conf`:

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```

                            ﻉﻭﺮﺸﻤﻟﺍ ﺮﺸﻨﻳ ﻱﺬﻟﺍ ﻒﻴﻀﻤﻟﺎﺑ `<PACKAGES_REPO_BASE_URL>` ﻝﺪﺒﺘﺳﺍ
    ،ًﻻ﻿ﻭﺃ ﻉﺩﻮﺘﺴﻤﻟﺍ ﻊﻴﻗﻮﺗ ﺡﺎﺘﻔﻣ ﺩﺭﻮﺘﺳﺍ .(Gitea ﻭﺃ GitLab ﻭﺃ GitHub) ﻰﻠﻋ ﻉﺩﻮﺘﺴﻤﻟﺍ
                                       :ﻞﻴﻤﺤﺘﻟﺍ ﺾﻓﺮﻳ `pacman` ﻥﺈﻓ ﻻ﻿ﺇﻭ

```sh
# 1. import the project's public signing key into your pacman keyring
pacman-key --add /path/to/argvus-signing-key.asc
pacman-key --lsign <key-id>

# 2. refresh and install
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```

##                                                     ﺔﻣﺰﺤﻟﺍ ﻒﻠﻣ ﺭﺍﺪﺻﺇ :2 ﺭﺎﻴﺨﻟﺍ

ﺭﺍﺪﺻﺈﻛ (ﻪﺑ ﺹﺎﺨﻟﺍ .sig ﻰﻟﺇ ﺔﻓﺎﺿﻹ﻿ﺎﺑ) `.pkg.tar.zst` ﺮﺸﻨﻳ ﻡﻮﺳﻮﻣ ﺭ
                                                      :ﺓﺮﺷﺎﺒﻣ ﻪﺘﻴﺒﺜﺘﺑ ﻢﻗ .ﻞﺻﻷ﻿ﺍ

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

              ﻞﺑﺎﻘﻣ ﻞﺼﻔﻨﻤﻟﺍ ﻊﻴﻗﻮﺘﻟﺍ ﻦﻣ ﻖﻘﺤﺗ ،ﺪﻳﺭﻮﺘﻟﺍ ﺔﻠﺴﻠﺳ ﺔﻓﺎﻈﻨﺑ ﻢﺘﻬﺗ ﺖﻨﻛ ﺍﺫﺇ
                                            :ﺖﻴﺒﺜﺘﻟﺍ ﻞﺒﻗ ﻉﻭﺮﺸﻤﻠﻟ ﻡﺎﻌﻟﺍ ﺡﺎﺘﻔﻤﻟﺍ

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

##                                                       ﻱﻭﺪﻴﻟﺍ ﺖﻴﺒﺜﺘﻟﺍ :3 ﺭﺎﻴﺨﻟﺍ

                  ﻥﻭﺩ ﺔﻤﺴﻟﺍ ﺔﺑﺮﺠﺗ ﻂﻘﻓ ﺪﻳﺮﺗ ﺖﻨﻛ ﺍﺫﺇ ﻭﺃ ،ﺶﺗﺭﺁ ﺮﻴﻏ ﺔﻤﻈﻧﺃ ﻰﻠﻋ ﺪﻴﻔﻣ
                    :Plymouth ـﺑ ﺹﺎﺨﻟﺍ ﻢﻴﺜﻟﺍ ﺭﺎﺴﻣ ﻰﻟﺇ ﻢﻴﺜﻟﺍ ﻞﻴﻟﺩ ﺦﺴﻧﺍ .ﻒﻴﻠﻐﺘﻟﺍ

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# or: sudo mkinitcpio -P        # Arch
# or: sudo dracut --regenerate-all
```

              `.sig` ﻊﻣ `/etc/default/grub` ﻲﻓ ﺙﻮﻤﻴﻠﺑ ﻦﻴﻜﻤﺗ ﺎًﻀﻳﺃ ﻦﻜﻤﻳ
.ﻰﻧﺩﻷ﻿ﺍ ﻉﻼ﻿ﻗﻹ﻿ﺎﺑ ﻲﻜﻴﺳﻼ﻿ﻜﻟﺍ ﺱﺎﺴﺣﻹ﻿ﺍ ﻲﻄﻌﻳ `GRUB_CMDLINE_LINUX` ﻭ `splash` dracut --regenerate-all  mkinitcpio -P  /etc/plymouth/plymouthd.conf  argvus  plymouth-set-default-theme argvus  `quiet` `plymouth-set-default-theme argvus`  `argvus`  `/etc/plymouth/plymouthd.conf`  `mkinitcpio -P`  `dracut --regenerate-all`   ءﺍﻮﺘﺣ

##                                                                ﺖﺒﺜﻤﻟﺍ ﻪﻠﻌﻔﻳ ﺎﻣ

                            :ﺎًﻴﺋﺎﻘﻠﺗ ﺔﻣﺰﺤﻟﺍ ﻒﺋﺎﻇﻭ ﻞﻤﻌﺗ ،ﺔﻴﻗﺮﺘﻟﺍ ﻭﺃ ﺖﻴﺒﺜﺘﻟﺍ ﺪﻌﺑ

1.

 — writes

 into

.
2.

 if mkinitcpio exists, otherwise

.

ﻚﻴﻠﻋ ﺐﺠﻳﻭ ﺮﻳﺬﺤﺗ ﺔﻋﺎﺒﻄﺑ ﺖﺒﺜﻤﻟﺍ ﻡﻮﻘﻳ ،ﻦﻳﺪﻟﻮﻤﻟﺍ ﻦﻣ ﻱﺃ ﻰﻠﻋ ﺭﻮﺜﻌﻟﺍ
ﺪﻌﺑ ﻂﻘﻓ ﻉﻼ﻿ﻗﻹ﻿ﺍ ﺪﻨﻋ ًﺎﻴﺋﺮﻣ ﻢﻴﺜﻟﺍ ﺮﻴﻴﻐﺗ ﺢﺒﺼﻳ .ﻚﺴﻔﻨﺑ initramfs ءﺎﻨ
            ﺮﺜﻛﻷ﻿ﺍ ﻲﻫ ﺓﻮﻄﺨﻟﺍ ﻩﺬﻫ ﻥﻭﺪﺑ ﻞﻴﻐﺸﺘﻟﺍ ﺓﺩﺎﻋﺇ — initramfs ﺪﻴﻟﻮﺗ ﺓﺩﺎﻋﺇ ﻢﺘﻳ
                                              ."ﺵﺮﻟﺍ ﺮﻴﻐﺘﻳ ﻢﻟ" ـﻟ ﻊﺋﺎﺸﻟﺍ ﺐﺒﺴﻟﺍ

                ﻭ ﻒﻠﺘﺨﻣ ﻉﻮﺿﻮﻣ ﺭﺎﻴﺘﺧﺍ :ﺮﻴﻛﺬﺗ ﺔﻋﺎﺒﻄﺑ ﻂﻘﻓ ﺔﻣﺰﺤﻟﺍ ﻡﻮﻘﻳ ،ﺔﻟﺍﺯﻹ﻿ﺍ ﺪﻨﻋ
                                          ﺮﻈﻧﺍ .ﻚﻟ ﺔﻛﻭﺮﺘﻣ initramfs ءﺎﻨﺑ ﺓﺩﺎﻋﺇ
[                                                                 ﺖﻴﺒﺜﺘﻟﺍ ءﺎﻐﻟﺇ](/docs/argvus-boot-splash/uninstallation/).

##                                                                ﺔﻴﻟﺎﺘﻟﺍ ﺕﺍﻮﻄﺨﻟﺍ

- [                                                                       ﻡﺍﺪﺨﺘﺳﺍ](/docs/argvus-boot-splash/usage/)                     ﻞﻳﺪﺒﺘﻟﺍ ،ﻞﻴﻐﺸﺘﻟﺍ ﺓﺩﺎﻋﺇ ﻥﻭﺪﺑ ﺔﻨﻳﺎﻌﻤﻟﺍ ،ﺖﻴﺒﺜﺘﻟﺍ ﻦﻣ ﻖﻘﺤﺘﻟﺍ —
المواضيع.
- [UKI ﻭ systemd-boot splash](/docs/argvus-boot-splash/uki-splash/) — ﻲﻓ ﺔﻴﻄﻘﻨﻟﺍ ﺓﺭﻮﺼﻟﺍ ﻡﺪﺨﺘﺳﺍ UKI.
- [استكشاف الأخطاء وإصلاحها](/docs/argvus-boot-splash/troubleshooting/) للمسارات المثبتة والمستخدمين.
