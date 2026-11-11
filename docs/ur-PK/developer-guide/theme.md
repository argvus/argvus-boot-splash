---
title: Theme Architecture
description:                  ۔ﮟﯿﮨ ﮯﺗﺎﺟ ﮯﯿﮐ ﮯﮭﭩﮐﺍ ﺡﺮﻃ ﺲﮐ ﭧﭘﺮﮑﺳﺍ ﺭﻭﺍ ،ﮯﺛﺎﺛﺍ ،ﺮﭩﭘﺮﮑﺳﮈ ﮫﺗﻮﻤﯿﻠﭘ
---

#                                                                 ﺮﭽﮑﯿﭩﯿﮐﺭﺁ ﻢﯿﮭﺗ

              ﺎﯿﮐ ﺭﻭﺍ ،ﭧﯿﺳ ﮧﺛﺎﺛﺍ ،ﯽﺘﺣﺎﺿﻭ :ﮯﮨ ﺎﯿﮔ ﺎﯾﺩ ﺐﯿﺗﺮﺗ ﺡﺮﻃ ﺲﮐ ﻢﯿﮭﺗ ﮫﭨﻮﻤﯿﻠﭘ
`argvus.script` ۔ﮯﮨ ﺎﺗﺮﮐ ﻡﺎﮐ ﻖﺑﺎﻄﻣ ﮯﮐ ﻦﺸﮑﯿﺳ ﺮﮨ

.(/docs/argvus-boot-splash/)[ﺎﻤﻨﮨﺭ ﻑﺭﺎﺻ]

## Descriptor

ﮯﮨ ﯽﺗﺎﺟ ﯽﮐ ﮯﻌﯾﺭﺫ ﮯﮐ ﭧﭘﺮﮑﺳﺍ ﮯﮐ ﮫﭨﻮﻤﺋﻼ﻿ﭘ ﺢﯾﺮﺸﺗ ﯽﮐ ﻦﺟ ﮟﯿﮨ ﻅﺎﻔﻟﺍ ﯽﺘﺣﺎﺿﻭ ﮧﯿﻧﺎﯿﺑ ﺰﻤﯿﮭ
                                                       :ﮟﯿﮨ ﮯﺼﺣ ﻭﺩ ﮯﮐ ﺱﺍ ۔ﻦﺠﻧﺍ

`src/usr/share/plymouth/themes/argvus/argvus.plymouth`:

```ini
[Plymouth Theme]
Name=Argvus
Description=Argvus boot splash theme
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/argvus
ScriptFile=/usr/share/plymouth/themes/argvus/argvus.script
```

Notes:

- `ModuleName=script` ﮟﯿﮩﻧ ﯽﺋﻮﮐ ۔ﮯﮨ ﺎﺗﺮﮐ ﺐﺨﺘﻨﻣ ﻮﮐ ﺮﭩﯾﺮﭘﺮﭩﻧﺍ ﭧﭘﺮﮑﺳﺍ ﻥﺍ ﭧﻠﺑ ﮯﮐ ﮫﺗﻮﻤﯿ
،ﮟﯿﮨ ﯽﻣﺯﻻ﻿ ﺎﻧﻮﮨ **ﮯﺘﺳﺍﺭ ﻞﻤﮑﻣ** ScriptFile ﺭﻭﺍ `ImageDir` ؛ﻝﻮﯾﮈﺎﻣ 
                    ۔ﮯﮨ ﻒﻠﺘﺨﻣ ﮯﺳ ﻦﺸﯿﺳ ﮯﮐ ﭖﺁ ﯼﺮﭩﮐﺮﺋﺍﮈ ﮓﻨﮐﺭﻭ ﺎﮐ initramfs ﮧﮑﻧﻮﯿﮐ
-  ﮯﮨ ﻮﺟ ،`ScriptFile` ﻢﯿﮭﺗ ⇒ `argvus.plymouth` :ﮯﮨ ﻡﺎﻧ ﺎﮐ ﻢﯿﮭﺗ ﻡﺎﻧ ﺎﮐ ﻞﺋﺎﻓ
 `argvus` `plymouth-set-default-theme argvus` ۔ﮯﮨ ﺎﺗﺮﮐ ﺐﺨﺘﻨﻣ ﺎﯿﮐ
- `argvus.script` ۔ﮯﮨ ﯽﺘﻠﭼ ﺭﺪﻧﺍ ﮯﮐ ﻢﯾﺍ ﯼﻭ ﮈﮉﯿﺒﻤﯾﺍ ﮯﮐ ﮫﺗٔﻮﻤﺋﻼ﻿ﭘ ﮧﯾ ۔ﮯﮨ ﻞﺋﺎﻓ ﮈﻮﮐ ﺪ
  (`plymouthd` ﺭﻭﺍ initramfs ﺎﯿﮔ ﺎﯿﮐ ﮏﻨﻟ ﮟﯿﻣ). ﮞﺎﯾﺪﻨﺑﺎﭘ ﯽﻟﺍﻭ ﮯﻧﻮﮨ ﺍﺪﯿﭘ ﮯ
  that: ،ﮟﯿﮩﻧ ﭧﻨﺋﺍﻮﭘ ﮓﻨﭨﻮﻠﻓ ﯽﺋﻮﮐ ،ﮟﯿﮩﻧ ﻞﻤﻋ ﯽﺟﺭﺎﺧ ﯽﺋﻮﮐ ،ﮟﯿﮩﻧ ﺯﮉﯾﺮﮭﺗ ﯽﺋﻮﮐ ،ﮟﯿﮩﻧ I/O ﻞﺋﺎﻓ
`MathInt` ﺎﺳ ﺎﭨﻮﮭﭼ ﮏﯾﺍ ﻥﺎﺑﺯ ﺭﻭﺍ ،ﮯﮨ ﻥﺎﺑﺯ ﯽﺑﺎﺴﺣ ﺪﺣﺍﻭ ﯽﮐ ﭖﺁ C ﮯﮨ ﭧﮑﻠﺋﺍﮈ 
۔(ﮟﯿﮨ ﯼﺭﻭﺮﺿ ﯽﻧﺎﻨﺑ ﮯﻠﮩﭘ ﮯﺳ ﮯﻧﺮﮐ ﻝﺎﻤﻌﺘﺳﺍ ءﺎﯿﺷﺍ `Sprite()` ،ﮟﯿﮨ ﯽﺗﺎﺟ ﯽﮐ ﺐﺗ

##                                                                   ﻝﮈﺎﻣ ﮓﻧﺭﮉﻨٔﯾﺭ

-                                    / `Window.SetBackgroundTopColor`) ﺮﻈﻨﻣ ﺲﭘ ﺱﻮﮭﭨ ﺭﺍﻮﻤﮨ ﮏﯾﺍ
  `SetBackgroundBottomColor`).
- ﮏﯾﺍ ،ﮯﮨ ﺮﯾﻮﺼﺗ ﮏﯾﺍ ﺎﮐ `Sprite()` ﺮﮨ ۔ﮟﯿﮨ ﺯﻮﯿﭩﯿﻣﺮﭘ ﮓﻨﺋﺍﺭﮈ ﺪﺣﺍﻭ **ﺲﭩﺋﺍﺮﭙﺳﺍ
  `(x, y)` position, a **z-order** and an opacity in `[0, 1]`. Later `SetPosition`
                                        ۔ﮯﮨ ﮟﯿﮩﻧ ﻑﺍﺮﮔ ﻦﯿﺳ ﯽﺋﻮﮐ ؛ﮟﯿﮨ ﮯﺘﺘﯿﺟ ﺰﻟﺎﮐ
- ﮯﮨ ﯽﺗﺎﺟ ﯽﮐ ﻞﺻﺎﺣ ﮯﮐ ﺮﮐ ﻝﺎﮐ ﺭﻭﺍ ﮯﮐ ﺮﮐ `ImageScale` ﮦﺭﺎﺑﻭﺩ ﻮﮐ ﺮﯾﻮﺼﺗ ﮏﯾﺍ ﮟﯿﻣ 
`SetImage` ۔ﮯﮨ ﮟﯿﮩﻧ ﻮﯿﭩِﻣﺮﭘ ﺍﺭﮈ-ﯼﻭﺰﺟ ﺎﯾ ﮓﻨﭙﻠﮐ ﯽﺋﻮﮐ — ﺮﭘ ﭧﺋﺍﺮﭙﺳ ﺱﺍ
- :ﮟﯿﮨ ﯽﺗﺮﮐ ﻥﺎﯿﺑ ﮯﻌﯾﺭﺫ ﮯﮐ ﺲﮑﯿﺑ ﻝﺎﮐ ﮟﯿﻣ ﺕﺭﻮﺻ ﯽﮐ ﮯﻧﻮﮨ ﺮﭩﺴﺟﺭ ﮯﮐ ﭧﭘﺮﮑﺳﺍ ﺲﭨﺭﻮﭘﺭ ﯽﮐ ﮫﺗ
  `PlymouthSetBootProgressFunction`, `PlymouthSetDisplayPasswordFunction`,
  `PlymouthSetDisplayNormalFunction`, `PlymouthSetRefreshFunction`.
- `Plymouth.SetRefreshRate(20)` 20 ﻮﮐ ﮏﯿﺑ ﻝﺎﮐ ﺶﯾﺮﻔﯾﺭ FPS ؛ﮯﮨ ﺎﺗﺮﮐ ﻡﺎﮐ ﺎﮐ ﮯﻧﻼ﻿ﭼ ﺮﭘ
                        ۔ﮯﮨ ﺮﺼﺤﻨﻣ ﺮﭘ ﯽﺳﺍ (ﻥﺍ-ﮉﯿِﻓ) ﯼﺮﯾﺬﭘ ﺖﮐﺮﺣ ﯽﺘﻗﻭ ﺪﺣﺍﻭ ﯽﮐ ﻢﯿﮭﺗ

##                                                             ﺖﺳﺮﮩﻓ ﯽﮐ ﺕﺎﺟ ﮧﺛﺎﺛﺍ

                                   ۔ﮟﯿﮨ ﺩﻮﺟﻮﻣ ﮟﯿﻣ `src/usr/share/plymouth/themes/argvus/` ﮯﺛﺎﺛﺍ ﻡﺎﻤﺗ

| File | Size | Format | Role | Used by `argvus.script` |
| --- | --- | --- | --- | --- |
| `argvus.plymouth` | — | INI | theme descriptor | loaded by `plymouthd` |
| `argvus.script` | — | Plymouth script | theme logic | yes |
| `argvus-logo.png` | 256x256 | RGBA 8-bit | main logo | yes (`logo.base_scale = 0.72`) |
| `argvus-text.png` | 400x53 | RGBA 8-bit | `ARGVUS` wordmark | yes (`text.scale = 0.80`) |
| `progress-bar.png` | 400x4 | 1-bit palette | filled bar | yes |
| `progress-bar-track.png` | 400x4 | 1-bit palette | unfilled track | yes |
| `entry-box.png` | 400x48 | RGB 16-bit | password entry field | yes |
| `bullet.png` | 12x12 | 4-bit palette | one masked character | yes |
|  `entry-line.png`  `logo-glow.png` `argvus-uki-splash.bmp` | 400x400 | BMP 32-bit | UKI / systemd-boot splash | no (consumed by the boot loader) |

ﮯﮨ ﯽﺋﺍﮌﻮﭼ ﯽﺗﺎﺟ ﮧﻟﺍﻮﺣ ﻥﺎﺸﻧ ﯽﻈﻔﻟ :ﮯﮨ ﺎﺗﺎﺟ ﺎﯿﮐ ﻝﺎﻤﻌﺘﺳﺍ ﺮﭘ ﺭﻮﻃ ﮯﮐ ﭧﻧﻮﯾ ﭦﺅﺁ ﮯﻟ ﻮﮐ ﯽ
ﯼﺮﭩﻧﺍ ﮈﺭﻭ ﺱﺎﭘ ﺭﻭﺍ ﺭﺎﺑ ﺲﯾﺮﮔﻭﺮﭘ ،ﮏﯾﺮﭨ ﺲﯾﺮﮔﻭﺮﭘ ﺭﻭﺍ (ﺮﭘ 1.0 ﻞﯿﮑﺳﺍ
                      ﺮﮔﺍ ﮯﮨ ﯽﺘﮨﺭ ﮓﻨﮨﺁ ﻢﮨ ﺐﯿﮐﺮﺗ ﺍﺬٰﮩﻟ ،ﮟﯿﮨ ﺫﻮﺧﺎﻣ ﮯﺳ ﺱﺍ ﺐﺳ ﻥﺍﺪﯿﻣ
                                        ۔ﮯﮨ ﺎﯿﮔ ﺎﯿﮐ ﺪﻣﺁﺮﺑ ﮦﺭﺎﺑﻭﺩ ﮧﺛﺎﺛﺍ ﮎﺭﺎﻣﮈﺭﻭ

 in 

 requires
ﮟﯿﮭﮑﯾﺩ ۔ﮯﺋﺎﺟ ﺎﯿﮐ ﻞﻣﺎﺷ ﮟﯿﻣ ﺖﺳﺮﮩﻓ ﺱﺍ ﮯﺳﺍ ﮧﮐ ﮯﮨ ﺐﻠﻄﻣ ﺎﮐ ﮯﻧﺮﮐ ﻞﻣﺎ
packaging.

## ﻭﺮﮭﺗ ﮎﺍﻭ ﭧﭘﺮﮑﺳﺍ

, top to bottom.

### 1. Background

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```

ﮟﯿﮨ  ءﺍﺰﺟﺍ ۔ﮟﯿﮩﻧ ﭧﻨﯾﮉﯾﺮﮔ ﯽﺋﻮﮐ ،ﺅﺍﺮﮭﺑ ﺭﺍﻮﻤﮨ ﮏﯾﺍ ⇒ ﺭﺪﻗ ﯽﮨ ﮏﯾﺍ ﮯﭽ
 src/usr/share/plymouth/themes/argvus/argvus.script  packaging/arch/common/functions.sh  `arch_check_splash_payload()`  `packaging/arch/common/functions.sh`  `src/usr/share/plymouth/themes/argvus/argvus.script` `#111316` ۔ﺎﯿﮔ ﺎﯿﮐ ﻢﯿﺴﻘﺗ ﮯﺳ 255 ﻮﮐ ﺰﻠﻨﯿﭼ ﭧﺑ-8 ﮯﮐ

###                                                            ﺶﺋﺎﻤﯿﭘ ﺭﻭﺍ ﮯﺛﺎﺛﺍ .2

    ﮯﮨ ﺎﺗﺮﮐ ﻞﺣ ًﺎﺘﺒﺴﻧ ﮯﮐ ﻮﺟ ،ﮯﮨ ﯽﺗﺎﺟ ﯽﮐ ﮈﻮﻟ ﮯﻌﯾﺭﺫ ﮯﮐ `Image("name")` ﺮﯾﻮﺼﺗ ﺮﮨ
`ImageDir`ﮯﮨ ﺢﺿﺍﻭ ﮓﻨﻠﯿﮑﺳﺍ ۔:

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```

`logo.frame[...]` ﺮﭘ ﻢﯾﺮﻓ ﺮﮨ :ﮯﮨ ﯼﺩﺍﺭﺍ ﺶﯿﮐ `ImageScale` ﺎﮔﻮﮨ
ﮯﮨ ﺎﺗﺎﺟ ﺎﯿﮐ ﺶﯿﮐ ﮧﻌﯾﺭﺫ ﮯﮐ ﻑﺪﮨ ﺭﻭﺍ ﮯﮨ ﺎﺗﺎﺟ ﺎﯿﮐ ﻞﯿﮑﺳﺍ ﮧﺒﺗﺮﻣ ﮏﯾﺍ ﻮﮔﻮﻟ ؛ﮟﯾﺮﮐ ﺺﺘﺨﻣ ﺮ
                        ۔ﻮﮨ ﺭﺎﮐﺭﺩ ﺝﺍﺭﺪﻧﺍ ﺎﯿﻧ ﮏﯾﺍ ﻑﺮﺻ ﮯﯿﻟ ﮯﮐ ﺰﺋﺎﺴﯾﺭ ﮧﮐﺎﺗ ﯽﺋﺍﮌﻮﭼ

ﮯﮨ ﺎﯿﮔ ﺎﯿﮐ ﮧﻧﺎﻤﯿﭘ ﺮﭘ  ﺭﺎﺑ ﮏﯾﺍ ﮯﺳﺍ ﻦﮑﯿﻟ ،ﺮﭘ `text.scale = 0.80` ﮯ
 — ﮯﮨ ﺎﺗﺎﺟ ﺎﯿﮐ ﮧﻧﺎﻤﯿﭘ ﮏﺗ `text.image.GetWidth()` ﻮﮐ ﺭﺎﺑ ﺭﻭﺍ ﮏﯾﺮﭨ ﺲﯾﺮﮔﻭﺮﭘ ﺮﮭﭘ ۔ﻦﺋﻻ﻿ ﻥﺍ
ﻮﮨ ﯽﮭﺑ ﮫﭽﮐ ﺮﭘ ﺭﻮﻃ ﯽﻘﯿﻘﺣ ﮎﺭﺎﻣ ﮈﺭﻭ ﮯﮨﺎﭼ ،ﮯﮨ ﺎﺗﻮﮨ ﻖﺑﺎﻄﻣ ﮯﮐ ﯽﺋﺍﮌﻮﭼ ﯽﮐ ﮎﺭﺎﻣ ﮈﺭﻭ ﮧﺸﯿ
pixel size is.

### 3. Layout

                             :ﮯﮨ ﺎﯿﮔ ﺎﯿﮐ ﺯﻮﮐﺮﻣ ﺮﭘ ﺭﻮﺤﻣ ﯽﻘﻓﺍ ﮯﮐ ﻭﮉﻧﻭ ﻮﮐ ﺮﺼﻨﻋ ﺮﮨ

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```

`- 35` ﮯﮨ ﺯﻮﮐﺮﻣ ﺮﭘ (ﮯﮐ + ﻮﮔﻮﻟ) ﻦﺸﯾﺯﻮﭙﻤﮐ ﯼﺭﻮﭘ ﮏﯿﭩﺳﺍ :ﮟﯾﺮﮐ ﭦﻮﻧ ﺮﭘ
            ﮯﮨ ﺎﺘﮭﭩﯿﺑ ﺮﭘﻭﺍ ﺎﺳ ﺍﮌﻮﮭﺗ ﮎﻼ﻿ﺑ ﮯﯿﻟ ﺱﺍ ،ﮟﯿﮩﻧ ﻮﮔﻮﻟ ﻑﺮﺻ ،(ﮏﯾﺮﭨ + ﮎﺭﺎﻣﮈﺭﻭ
                             ﺎﮔﻮﮨ ﻖﺑﺎﻄﻣ ﮯﮐ ﺮﮭﭘ ﻡﺎﻘﻣ ﯼﺩﻮﻤﻋ ۔ﻂﺳﻭ ﯼﺩﻮﻤﻋ ﮯﮐ ﻦﯾﺮﮑﺳﺍ
                                                 ,`text.y = logo.y + logo.image.GetHeight() + 16`) ﺮﺼﻨﻋ ﻼ﻿ﮭﭽﭘ
`progress_track.y = text.y + text.image.GetHeight() + 28`, …)، ﮯﮨ ﺐﻠﻄﻣ ﺎﮐ ﺲﺟ
                         ۔ﮯﮨ ﯽﺗﺮﮐ ﻞﯿﮑﺳﺍ ﺡﺮﻃ ﯽﮐ ﭧﻧﻮﯾ ﮏﯾﺍ ﮫﺗﺎﺳ ﮯﮐ ﻦﺷﻮﻟﻭﺰﯾﺭ ﺐﯿﮐﺮﺗ

Z-order used here:

| Z | Sprite |
| --- | --- |
| 100 | logo, wordmark, progress track |
| 101 | progress bar (above the track) |
| 200 | password entry field |
| 201 | password prompt text |
| 202 | password bullets |

###                                                              ﺖﻓﺭ ﺶﯿﭘ ﯽﮐ ﭦﻮﺑ ۔۴

```js
fun progress_callback(duration, progress)
{
    width = MathInt(progress_bar.original_image.GetWidth() * progress);
    if (width < 1) width = 1;
    if (width > progress_bar.original_image.GetWidth())
        width = progress_bar.original_image.GetWidth();
    progress_bar.image = ImageScale(progress_bar.original_image, width,
                                     progress_bar.original_image.GetHeight());
    progress_bar.sprite.SetImage(progress_bar.image);
}
```

`PlymouthSetBootProgressFunction(progress_callback)` ﭗﻤﯿﻠﮐ ۔ﮈﺮﭩﺴﺟﺭ ﮫﺗﺎﺳ ﮯﮐ
matters:               ﺭﺎﺑ ﮯﯿﻟ ﺱﺍ ،ﮯﮨ ﺮﺒﺘﻌﻣ ﺮﯿﻏ ﺮﯾﻮﺼﺗ ﮫﺗﮈِﻭ ﻭﺮﯾﺯ ﮟﯿﻣ ﺰﻧﮊﺭﻭ ﮫﺗﺅﺎﻣ ﯼﻼ﻿ﭘ ﮫﭽﮐ
۔ﯽﺘﮑﺳ ﮪﮍﺑ ﮟﯿﮩﻧ ﮦﺩﺎﯾﺯ ﮯﺳ ﯽﺋﺍﮌﻮﭼ ﯽﮐ ﮏﯾﺮﭨ ﯽﮭﺒﮐ ﯽﻗﺮﺗ ﺭﻭﺍ ،ﺎﺗﻮﮨ ﮟﯿﮩﻧ ﺐﺋﺎﻏ ﺮﭘ ﺭﻮﻃ ﻞﻤ
ﭗﻠﮐ ﯽﮨ ﮧﻧ ﺭﻭﺍ ﯽﺋﺍﺮﮭﺑ ﯽﺋﻮﮐ ﮧﻧ — ﮯﮨ ﯽﺘﻟﺪﺑ ﯽﺋﺍﮌﻮﭼ ﯽﮐ ﺮﯾﻮﺼﺗ ﻑﺮﺻ ؛ﮯﮨ ﺭﺮﻘﻣ ﻦﺸﯾﺯﻮﭘ ﯽﮐ
operation is used.

###                                                              ﮒﻼ﻿ﯿﺋﺍﮈ ﮈﺭﻭ ﺱﺎﭘ .5

`display_password_callback(prompt, bullets)`:

1.     ﮧﮑﺒﺟ ،ﺮﭘ 0.15 ﻥﺎﺸﻧ ﯽﻈﻔﻟ ﺭﻭﺍ `logo.opacity = 0.15` :ﮯﮨ ﺎﺗﺮﮐ ﻢﮐ ﮏﻤﭼ
                                        ۔ﮟﯿﮨ ﺮﭘ  `0.15` `1.0` ﺭﺎﺑ ﺭﻭﺍ ﮏﯾﺮﭨ
2.                         ﺪﺣﺍﻭ — ﮯﮨ ﺎﺗﺮﮐ ﺶﯿﭘ ﮫﺗﺎﺳ ﮯﮐ `Image.Text(prompt, 0.72, 0.77, 0.81)` ﻮﮐ ﭧﭙﻣﻭﺮﭘ
     ,ﮯﮨ ﻡﻮﻠﻌﻣ ﮞﺎﮩﯾ ﻑﺮﺻ ﻦﺸﯾﺯﻮﭘ ﯽﮐ ﺱﺍ ۔ﺮﯾﻮﺼﺗ ﮦﺪﺷ ﺍﺪﯿﭘ ﮯﻌﯾﺭﺫ ﮯﮐ ﻢﺋﺎﭨ ﻥﺭ ﮟﯿﻣ ﻢﯿﮭﺗ
                                         ۔ﮯﮨ ﺮﺼﺤﻨﻣ ﺮﭘ ﯽﺋﺎﭽﻧﻭﺍ ﯽﮐ ﻦﺘﻣ ﮧﯾ ﮧﮑﻧﻮﯿﮐ
3.                     = password.entry.y` :ﮯﮨ ﺎﺘﮭﮐﺭ ﮯﭽﯿﻧ ﮯﮐ ﭧﭙﻣﺍﺮﭘ ﻮﮐ ﮉﻠﯿﻓ ﯽﻠﺧﺍﺩ
password.prompt.y + password.prompt.image.GetHeight() + 14ﺖﻗﻭ ﮯﮐ ﮯﻧﻮﮨ ﮈﻮﻟ ۔
`password.entry.y`، `0` ﮯﮨ ﺎﮨﺭ ﺮﮐ ﺭﺎﻈﺘﻧﺍ ﻡﺎﻘﻣ ﻞﺻﺍ ﮧﮐ ﮯﮨ ﮦﺮﺼﺒﺗ ﮏﯾﺍ
   prompt.
4.               :ﮯﮨ ﺎﺘﭽﻨﯿﮭﮐ ﮫﺗﺎﺳ ﮯﮐ ﭖﻮﻟ ﮯﻟﺍﻭ ﮯﻧﺮﮐ ﻝﺎﻤﻌﺘﺳﺍ ﮦﺭﺎﺑﻭﺩ ﺎﯾ ﭧﺌﯾﺮﮐ ﻮﮐ ﭧﻠﺑ

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* create sprite + image */ }
       /* ...position at entry.x + 16 + index * bullet.width ... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```

؛ﮯﮨ ﺎﺗﺎﺟ ﺎﯿﮐ ﻝﺎﻤﻌﺘﺳﺍ ﮦﺭﺎﺑﻭﺩ ﮟﯿﻣ ﺲﭩﭙﻣﺍﺮﭘ ﺭﻭﺍ ﮯﮨ ﺎﺗﺎﺟ ﺎﮭﮐﺭ ﮟﯿﻣ
۔ﮟﯿﮨ ﮟﯿﻣ ﺰﮐﺮﻣ ﺮﭘ ﺭﻮﻃ ﯼﺩﻮﻤﻋ ﮞﺎﯿﻟﻮﮔ ۔ﮟﯿﮨ ﯽﺋﻮﮨ ﯽﭙﮭﭼ ﮫﺗﺎﺳ ﮯﮐ `0` ﺖﯿﻓ
                                              ۔ﻑﻼ﻿ﺧ ﮯﮐ ﯽﺋﺎﭽﻧﻭﺍ ﯽﮐ ﮉﻠﯿﻓ ﮯﮐ ﮯﻠﺧﺍﺩ

`display_normal_callback()` ﺖﯿﻓﺎﻔﺷ ﮧﯾ :ﮯﮨ ﺎﭩﻟﺍ `1.0` ﮯﮨ ﺎﺗﺎﭙﮭﭼ ،ﮯﮨ ﺎﺗﺮﮐ ﻝﺎﺤﺑ
ﮈﺮﭩﺴﺟﺭ ﮫﺗﺎﺳ ﮯﮐ  ۔ﯽﻟﻮﮔ ﮧﮐﺮﺘﺸﻣ ﺮﮨ ﺭﻭﺍ ﮧﻠﺧﺍﺩ ،ﭧﭙﻣﻭﺮﭘ

, Plymouth calls it when the passphrase is
۔ﮯﮨ ﺎﺘﮨﺭ ﯼﺭﺎﺟ ﭦﻮﺑ ﺭﻭﺍ ﺥﻮﺴﻨﻣ ﺎﯾ ﮦﺪﺷ ﻝﻮﺒﻗ

Consequence: 

 is a variable, not a constant, because both the fade
۔ﮯﮨ ﯽﺗﺎﺟ ﯼﺩ ﺏﺮﺿ ﮟﯿﻣ ﺱﺍ ﺖﻟﺎﺣ ﯽﮐ ﮈﺭﻭ ﺱﺎﭘ ﺭﻭﺍ

### ﻥﺍ-ﮉﯿﻓ .6

```js
Plymouth.SetRefreshRate(20);
fun refresh_callback()
{
    if (!fade.complete) {
        fade.frame += 1;
        fade.opacity = fade.frame / 20;      /* 20 frames @ 20 FPS = 1s */
        if (fade.opacity > 1) fade.opacity = 1;
        text.sprite.SetOpacity(fade.opacity);
        progress_track.sprite.SetOpacity(fade.opacity);
        progress_bar.sprite.SetOpacity(fade.opacity);
        if (fade.frame >= 20) fade.complete = 1;
    }
    logo.sprite.SetOpacity(logo.opacity * fade.opacity);
}
```

( ﮫﺘﻤﺋﻼ﻿ﭘ ﺭﻭﺍ ﮯﮨ ﺎﺘﺴﺳ ﮧﯾ) ﮯﮨ ﯽﺘﮨﺭ ﯽﺘﻠﭼ ﻥﺍﺭﻭﺩ ﮯﮐ ﭦﻮﺑ ﮮﺭﻮﭘ ﮏﯿﺑ ﻝﺎ
calls it continuously); the 

 guard makes it a no-op after the
animation. The logo uses 

 instead of a plain
ﺪﻌﺑ ﮯﮐ  :ﮯﮨﺭ ﺭﺍﺮﻗﺮﺑ ﺪﻌﺑ ﮯﮐ ﻝﺍﻭﺯ ﺖﻟﺎﺣ ﮦﺪﺷ ﻢﮬﺪﻣ ﮯﺳ ﮈﺭﻭ ﺱﺎﭘ ﮧﮐﺎﺗ
۔ﮯﮨ ﺎﺗﺎﮭﮐﺩ  `PlymouthSetDisplayNormalFunction` `logo.opacity` ﮦﺭﺎﺑﻭﺩ ﻮﮔﻮﻟ ﺭﻭﺍ  logo.opacity * fade.opacity  `fade.complete`  `logo.opacity * fade.opacity` `fade.opacity == 1` ،ﮯﮨ ﺎﺗﺎﺟ ﻮﮨ ﻞﻤﮑ

             ﮟﯿﮭﺗ ﮦﻭ ؛ﮟﯿﮭﺗ ﺰﻨﺸﯿﻤﯿﻧﺍ ﻥﺎﭙﺳﺍ/ﺲﻠﭘ ﯽﮭﺑ ﮟﯿﻣ ﺰﻧﮊﺭﻭ ﮯﮐ ﮯﻠﮩﭘ ﮯﮐ ﻢﯿﮭﺗ ﺱﺍ
 `logo.opacity` `0.2.0` ﮟﯿﺋﺍﻭﺮﮐ ﮧﻧ ﻑﺭﺎﻌﺘﻣ ﮦﺭﺎﺑﻭﺩ ﻮﮐ ﻢﯾﺮﻓ ﺮﮨ ۔("ﺎﻧﺎﭩﮨ ﺲﭩﮑﯿﻔﯾﺍ ﺲﻠﭘ :ﻡﺎ
        ﮯﮨ ﯼﺭﻭﺮﺿ ﺎﻨﮨﺭ ﺮﭘ ﺭﻮﻃ ﮯﮐ ﯽﮔﺪﻨﺋﺎﻤﻧ ﺺﻠﺨﻣ ﮏﯾﺍ ﻮﮐ ﺭﺎﺑ — ﺖﮐﺮﺣ ﯽﮐ ﺭﺎﺑ ﺲﯾﺮﮔﻭﺮﭘ
boot progress.

##                                                                ﻞﻘﺘﺴﻣ ﮯﮐ ﭦﺅﺁ ﮯﻟ

                                 :ﺬﺧﺎﻣ ﺪﺣﺍﻭ ﺎﮐ ﯽﺋﺎﭽﺳ ﮯﯿﻟ ﮯﮐ ﮯﻧﺮﮐ ﺖﺳﺭﺩ ﻮﮐ ﺐﯿﮐﺮﺗ

| Constant | Value | Meaning |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | logo scale vs. its native 256x256 |
| `logo.y` offset | `-35`                           | ﮯﮨ ﺎﺗﺎﮭﭨﺍ ﺮﭘﻭﺍ ﮯﮐ ﻥﺎﯿﻣﺭﺩ ﮯﮐ ﻦﯾﺮﮑﺳﺍ ﻮﮐ ﮎﻼ﻿ﺑ ﯼﺰﮐﺮﻣ |
| `text.scale` | `0.80` | wordmark scale vs. its native 400x53 |
| `text.y` gap | `+16` | logo bottom → wordmark top |
| `progress_track.y` gap | `+28` | wordmark bottom → track top |
| `password.prompt.y` gap | `+24` | track bottom → prompt text top |
| `password.entry.y` gap | `+14` | prompt bottom → entry field top |
| bullet x offset | `+16` | entry left → first bullet |
| `logo.opacity` (dialog) | `0.15` | splash dimming while a passphrase is requested |
| prompt color | `0.72, 0.77, 0.81` | `Image.Text` RGB, ~`#B8C4CE` |
| fade | 20 frames @ 20 FPS | ~1 s fade-in |

##                                                                    ﻦﮐﻮﭨ ﻦﺋﺍﺰﯾﮈ

| Token | Hex | Where it lives |
| --- | --- | --- |
| Background | `#111316` | script (`0.0667, 0.0745, 0.0863`) |
| Accent | `#3590BD` | logo / wordmark / progress fill pixels |
| Progress track | `#262933` | `progress-bar-track.png` |
| Prompt text | `#B8C4CE` | script (`Image.Text` call) |

      ﺎﯿﮔ ﺎﯿﮐ ﮟﯿﮩﻧ ﻥﺎﯿﺑ ﮟﯿﮩﻧﺍ ،ﮟﯿﮨ ﻞﻣﺎﺷ ﮟﯿﻣ ﮞﻮﺛﺎﺛﺍ PNG ﮓﻧﺭ ﮯﮐ ﮏﯾﺮﭨ ﺭﻭﺍ ﭧﻨﯿﺴﮑﯾﺍ
۔(ﺎﻧﺮﮐ ﻢﯿﻣﺮﺗ ﮟﯿﻣ ﭧﯿﻠﯿﭘ ﺎﯾ) ﺎﻧﺮﮐ ﺪﻣﺁﺮﺑ ﮦﺭﺎﺑﻭﺩ ﻮﮐ ﮞﻮﺛﺎﺛﺍ ﮯﮨ ﺐﻠﻄﻣ ﺎﮐ ﮯﻨﻟﺪﺑ ﮓﻧﺭ ﮯﯿ
                          ۔ﮯﮨ ﮟﯿﮩﻧ ﻥﮊﺭﻭ ﭧﺋﻻ﻿ ﯽﺋﻮﮐ ﺎﮐ ﺱﺍ ﺭﻭﺍ ﮯﮨ ﮎﺭﺍﮈ ﻑﺮﺻ ﻢﯿﮭﺗ ﮧﯾ

## UKI ﭧﯿﻣﺭﺎﻓ ﭗﯿﻣ ﭧﺑ

 is a 400x400, 32-bit uncompressed Windows BMP
(

). It is a
ﮯﮨ ﺎﺗﺮﮐ  ﺞﮑﯿﭘ Arch ﺭﻭﺍ ،ﺎﺗﺮﮐ ﮈﻮﻟ ﮟﯿﮩﻧ ﯽﮭﺒﮐ ﮯﺳﺍ ﭧﭘﺮﮑﺳﺍ Plymouth
( ﮟﯿﮭﮑﯾﺩ) ﮯﮨ ﻡﺪﻗ ﺎﮐ ﻑﺭﺎﺻ ﺎﻧﺮﮐ ﮉﯿﺒﻤﯾﺍ ﮟﯿﻣ UKI ﮯﺳﺍ — ﮟﯾﺮﮐ ﮧﻧ ﺮﭩﺴ

؛ﻮﮨ ﺮﺑﺍﺮﺑ ًﺎﺒﯾﺮﻘﺗ ﻢﺠﺣ ﺎﮐ ﺲﺟ ﮟﯿﮭﮐﺭ BMP ﭧِﺑ-32 ﮉﺴﯾﺮﭙﻤﮐ ﺮﯿﻏ ﮦﺩﺎﺳ ﮏﯾﺍ ﮯﺳﺍ ﻮﺗ ،ﮟﯾﺮﮐ ﻞ
systemd-boot ﺭﻭﺍ  PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32  `argvus-uki-splash.bmp`  `PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32` `ukify` ﮟﯿﮨ ﮯﺗﺮﮐ ﮟﯿﮩﻧ ﻞﯿﮑﺳﺍ ﻮﮐ ﺮﯾﻭﺎﺼﺗ ﯼﮍﺑ ﺭﻭﺍ ﺲﭩﯿﻣﺭ
                                        ۔ﻻ﻿ﺍﻭ ﮯﻧﺎﮭﮐ ﯼﺭﻮﻤﯿﻣ ﮦﺩﺎﯾﺯ ﺮﭘ ﭦﻮﺑ ﯽﺋﺍﺪﺘﺑﺍ

##                                                           ﺎﻧﺮﮐ ﯽﻠﯾﺪﺒﺗ ﮟﯿﻣ ﻢﯿﮭﺗ

Practical loop:

1. `src/usr/share/plymouth/themes/argvus/argvus.script` (ﺎﯾ/ﺭﻭﺍ PNGs) ۔ﮟﯾﺮﮐ ﭦﮉﯾﺍ ﻮﮐ
2.               :ﮟﯾﺮﮐ ﮦﺭﺎﻈﻧ ﺶﯿﭘ ﮯﺳ ﯼﺮﭨ ﺱﺭﻮﺳ ﺎﯾ ،ﮟﯾﺮﮐ ﻝﺎﭩﺴﻧﺍ ﺮﭘ ﮫﺗﻮﻤﯿﻠﭘ ﻮﯿﺋﻻ﻿ ﮯﻨﭘﺍ

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # check, then: sudo plymouthquit
   ```

3. `make validate && make build` ۔ﮯﻠﮩﭘ ﮯﺳ ﮯﻧﺮﮐ ﭧﻤﮐ ﻮﮐ

                                   :ﮟﯿﮨ ﮯﺘﯾﺩ ﺩﺪﻣ ﮟﯿﻣ ﮯﻧﺮﮐ ﻡﺎﮐ ﻮﮐ ﻢﯿﮭﺗ ﻮﺟ ﺪﻋﺍﻮﻗ

-      ﮟﯾﺮﮐ ﮏﯿﭼ ؛ﮯﮨ ﻥﺎﺑﺯ ﺩﻭﺪﺤﻣ ﮏﯾﺍ ﻦﺠﻧﺍ ۔ﮟﯿﺋﺍﻭﺮﮐ ﻑﺭﺎﻌﺘﻣ ﺖﻣ APIs ﮫﺗﻮﻤﯿﻠﭘ ﺮﯿﻏ ﯽﮭﺒﮐ
ﮟﯿﮨ ﮯﺗﺮﮐ ﺖﯾﺎﻤﺣ ﭖﺁ ﯽﮐ ﺲﺟ ﻥﮊﺭﻭ ﻑﺪﮨ ﮦﻭ ﺎﮐ `plymouth` ،ﺎﯿﮐ ﮟﯿﮩﻧ ﻝﺎﻤﻌﺘﺳﺍ ﮯﻧ 
  used before.
- 

/

 in 

 must stay absolute and must match
  the installed path 

.
- Keep every asset listed in 

 in sync with the
  files that ship in 

 — the packaging 

 runs in CI.
-     ؛ﮯﯿﮨﺎﭼ ﯽﻨﮨﺭ ﻦﺸﮑﻨﻓ ﺭﺍﺩﺎﻓﻭ ﮏﯾﺍ ﻖﺑﺎﻄﻣ ﮯﮐ ﯽﻗﺮﺗ ﮦﺪﺷ ﭦﺭﻮﭘﺭ ﯽﺋﺍﮌﻮﭼ ﯽﮐ ﺭﺎﺑ ﺲﯾﺮﮔﻭﺮﭘ
 check()  src/  arch_check_splash_payload()  /usr/share/plymouth/themes/argvus  argvus.plymouth  ScriptFile  `ImageDir`  `ScriptFile`  `argvus.plymouth`  `/usr/share/plymouth/themes/argvus`  `arch_check_splash_payload()`  `src/`  `check()` `[1, track width]` ۔ﮯﯿﮨﺎﭼ ﺎﻧﺎﺟ ﮟﯿﮩﻧ ﺎﯾﺎﭩﮨ ﻮﮐ ﭗﻤﻠﮐ ﺮﭘ
-       ﺮﺗ ﮦﺩﺎﯾﺯ ﻮﺟ ﮯﮨ ﺖﻟﺎﺣ ﮦﻭ ﮧﯾ :ﮟﯿﮩﻧ ﺵﻼ﻿ﭙﺳﺍ ﭦﻮﺑ ﻑﺮﺻ ،ﮟﯿﭽﻧﺎﺟ ﻮﮐ ﮒﻼ﻿ﯿﺋﺍﮈ ﺰﯾﺮﻓ ﺱﺎﭘ
              ۔ﮟﯿﮨ ﮯﺗﺮﮐ ﭦﻮﻧ ﮦﺩﺎﯾﺯ ﮯﺳ ﺐﺳ ﻦﯿﻓﺭﺎﺻ ﮯﺴﺟ ﮦﻭ ﺭﻭﺍ ﻥﺎﮑﻣﺍ ﮦﺩﺎﯾﺯ ﺎﮐ ﮯﻨﭨﻮﭨ
-  ﮟﯿﮭﮐﺭ ﺭﺍﺮﻗﺮﺑ ﻢﯿﺴﻘﺗ ﯽﮐ ﻡﺎﮐ ﮯﮐ ﻢﯾﺮﻓ ﺮﮨ ؛ﮯﮨ ﯽﺘﻠﭼ ﮯﯿﻟ ﮯﮐ ﭦﻮﺑ ﮮﺭﻮﭘ ﮏﯿﺑ ﻝﺎﮐ ﺶﯾﺮﻓ ﯼﺭ
  free where possible.

                                               ﮟﯿﮭﮑﯾﺩ ﮯﯿﻟ ﮯﮐ ﺯﺰﯿﻠﯾﺭ ﺭﻭﺍ ﮓﻨﺠﮑﯿﭘ[                                                                       ﮓﻨﺠﯿﮑﯿﭘ](/docs/argvus-boot-splash/developer-guide/packaging/)                                                                           ﺭﻭﺍ
[                                                             ﺯﺰﯿﻠﯾﺭ ﺭﻭﺍ ﯽﺋﺁ ﯽﺳ](/docs/argvus-boot-splash/developer-guide/ci-releases/)                                                      ﮟﯿﮭﮑﯾﺩ ،ﮯﯿﻟ ﮯﮐ ﻝﺎﻤﻌﺘﺳﺍ .
[                                                               ﯽﺋﺎﻤﻨﮨﺭ ﯽﮐ ﻑﺭﺎﺻ](/docs/argvus-boot-splash/).
| entry-line.png | 300x2 | 1-bit palette | entry rule/underline | no (see [known gaps](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| logo-glow.png | 260x300 | 8-bit palette | logo glow artwork | no (see [known gaps](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
[                                                                       ﮓﻨﺠﯿﮑﯿﭘ](/docs/argvus-boot-splash/developer-guide/packaging/#shared-functions).
[                                                               ﯽﺋﺎﻤﻨﮨﺭ ﯽﮐ ﻑﺭﺎﺻ](/docs/argvus-boot-splash/uki-splash/)).
