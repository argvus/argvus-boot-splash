---
title: موضوع العمارة
description:                                        .ﺺﻨﻟﺍﻭ ﻝﻮﺻﻷ﻿ﺍﻭ ﺙﻮﻤﻴﻠﺑ ﻒﺻﺍﻭ ﻊﻴﻤﺠﺗ ﻢﺘﻳ ﻒﻴﻛ
---

#                                                                  ﻉﻮﺿﻮﻤﻟﺍ ﺔﺳﺪﻨﻫ

                        ﺍﺫﺎﻣﻭ ،ﻝﻮﺻﻷ﻿ﺍ ﺔﻋﻮﻤﺠﻣ ،ﻒﺻﻮﻟﺍ :ﺙﻮﻤﻴﻠﺑ ﻉﻮﺿﻮﻣ ﻊﻴﻤﺠﺗ ﻢﺘﻳ ﻒﻴﻛ

 does, section by section.

للتغليف والإصدارات، انظر التغليف و
CI والإصدارات. للاستخدام، راجع
user guide.

## واصف

ﺙﻮﻤﻴﻠﺑ ﺺﻧ ﺎﻫﺮﺴﻔﻳ ﺔﻴﻧﻼ﻿ﻋﺇ ﺕﺎﻔﺻﺍﻭ ﻲﻫ ﺙﻮﻤﻴﻠﺑ ﺕﺎﻋﻮﺿﻮﻣ
                                                           :ﻦﻳﺃﺰﺟ ﻙﺎﻨﻫ .ﻙﺮﺤﻤﻟﺍ

 `argvus.script` `src/usr/share/plymouth/themes/argvus/argvus.plymouth`:

```ini
[Plymouth Theme]
Name=Argvus
Description=Argvus boot splash theme
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/argvus
ScriptFile=/usr/share/plymouth/themes/argvus/argvus.script
```

ملحوظات:

- `ModuleName=script` ﺪﺟﻮﻳ ﻻ﻿ .ﺙﻮﻤﻴﻠﺑ ﻲﻓ ﺞﻣﺪﻤﻟﺍ ﺹﻮﺼﻨﻟﺍ ﻢﺟﺮﺘﻣ ﺭﺎﺘﺨﻳ
,**ﺔﻘﻠﻄﻣ ﺕﺍﺭﺎﺴﻣ** ScriptFile ﻭ `ImageDir` ﻥﻮﻜﺗ ﻥﺃ ﺐﺠﻳ ؛ﺔﻌﻤﺠﻤﻟﺍ ﺓ
                           .ﻚﺘﺴﻠﺟ ﻦﻋ ﻒﻠﺘﺨﻣ ﻞﻤﻋ ﻞﻴﻟﺩ ﻰﻠﻋ ﻱﻮﺘﺤﻳ initramfs ـﻟﺍ ﻥﻷ﻿
-  ﻲﻫ ﻲﺘﻟﺍﻭ ،`ScriptFile` ﺔﻤﺴﻟﺍ ⇒ `argvus.plymouth` :ﺔﻤﺴﻟﺍ ﻢﺳﺍ ﻮﻫ ﻒﻠﻤﻟﺍ ﻢﺳﺍ
                                             . `argvus` `plymouth-set-default-theme argvus` ﻩﺭﺎﺘﺨﻳ ﻱﺬﻟﺍ ﺎﻣ
- `argvus.script` ﺯﺎﻬﺟ ﻞﺧﺍﺩ ﻞﻤﻌﻳ .ﺪﻴﺣﻮﻟﺍ ﻱﺰﻣﺮﻟﺍ ﻒﻠﻤﻟﺍ ﻮﻫ Plymouth ﺞﻣﺪﻤﻟﺍ ﻱﺮﻫﺎﻈ
                   ﻦﻋ ﺔﺠﺗﺎﻨﻟﺍ ﺩﻮﻴﻘﻟﺍ .(initramfs ﻭ `plymouthd` ـﺑ ﻂﺒﺗﺮﻣ)
  that:              ,ﺔﻳﺮﺸﻋ ﺩﺍﺪﻋﺃ ﻻ﻿ ،ﺔﻴﺟﺭﺎﺧ ﺕﺎﻴﻠﻤﻋ ﻻ﻿ ،ﻁﻮﻴﺧ ﻻ﻿ ،ﺝﺍﺮﺧﺇ/ﻝﺎﺧﺩﺇ ﺕﺎﻔﻠﻣ ﺪﺟﻮﺗ ﻻ﻿
`MathInt` ﺔﻐﻠﺑ ﺔﻬﻴﺒﺷ ﺓﺮﻴﻐﺻ ﺔﺠﻬﻟ ﻲﻫ ﺔﻐﻠﻟﺍﻭ ،ﻚﻳﺪﻟ ﺪﻴﺣﻮﻟﺍ ﺏﺎﺴﺤﻟﺍ ﻮﻫ C
.(ﻡﺍﺪﺨﺘﺳﻻ﻿ﺍ ﻞﺒﻗ `Sprite()` ﺕﺎﻨﺋﺎﻛ ءﺎﺸﻧﺇ ﺐﺠﻳ ،ﺢﻴﺗﺎﻔﻤﻟﺎﺑ ﺔﻃﻮﺑﺮﻣ ﺕﺎﻨﺋﺎﻛ ﻲﻫ

##                                                                    ﺽﺮﻌﻟﺍ ﺝﺫﻮﻤﻧ

-                                    / `Window.SetBackgroundTopColor`) ﺓﺪﺣﺍﻭ ﺔﺤﻄﺴﻣ ﺔﺒﻠﺻ ﺔﻴﻔﻠﺧ
  `SetBackgroundBottomColor`).
- ﻭ ،ﺓﺭﻮﺻ ﻪﻟ `Sprite()` ﻞﻛ .ﺔﻴﻣﻮﺳﺮﻟﺍ ﺕﺎﻴﻬﻳﺪﺒﻟﺍ ﻦﻣ ﺓﺪﻴﺣﻮﻟﺍ ﻲﻫ **(Sprites)
موضع `(x, y)` و**ترتيب z** والعتامة في `[0, 1]`. لاحقًا `SetPosition`
                                             .ﺪﻬﺸﻣ ﻂﻄﺨﻣ ﺪﺟﻮﺗ ﻻ﻿ ؛ﺕﺎﻤﻟﺎﻜﻤﻟﺍ ﺯﻮﻔﻳ
-       ءﺎﻋﺪﺘﺳﺍﻭ ﺭﺎﻃﺇ ﻞﻛ ﻲﻓ ﺓﺭﻮﺼﻟ `ImageScale` ﺓﺩﺎﻋﺇ ﻖﻳﺮﻃ ﻦﻋ ﻡّﺪﻘﺘﻟﺍ ﻢﺳﺭ ﻢﺘﻳ

 on the sprite — there is no clipping or partial-draw primitive.
- :ﻝﺎﺼﺗﻻ﻿ﺍ ﺩﻭﺩﺭ ﻝﻼ﻿ﺧ ﻦﻣ ﻞﺠﺴﻳ ﻲﺼﻨﻟﺍ ﺞﻣﺎﻧﺮﺒﻟﺍ ﻥﺄﺑ ﺪﻴﻔُﺗ ﺙﻮﻤﻴﻠﺑ ﺮﻳﺭﺎﻘ
   `SetImage` `PlymouthSetBootProgressFunction`, `PlymouthSetDisplayPasswordFunction`,
  `PlymouthSetDisplayNormalFunction`, `PlymouthSetRefreshFunction`.
-

يجعل رد الاتصال التحديث يعمل بمعدل 20 إطارًا في الثانية؛ ال
.ﺎﻬﻴﻠﻋ ﺪﻤﺘﻌﺗ (ﻲﺷﻼ﻿ﺘﻟﺍ) ﻉﻮﺿﻮﻤﻠﻟ ﺔﺘﻗﺆﻤﻟﺍ ﺓﺪﻴﺣﻮﻟﺍ ﺔﻛﺮﺤﺘﻤﻟﺍ ﻡﻮﺳﺮﻟﺍ

## ﻝﻮﺻﻷ﻿ﺍ ﺩﺮﺟ

                                       . `Plymouth.SetRefreshRate(20)` `src/usr/share/plymouth/themes/argvus/` ﻲﻓ ﺓﺩﻮﺟﻮﻣ ﻝﻮﺻﻷ﻿ﺍ ﻊﻴﻤﺟ

| ملف | الحجم | تنسيق | الدور | يستخدم بواسطة `argvus.script` |
| --- | --- | --- | --- | --- |
| `argvus.plymouth` | — | ايني | واصف الموضوع | محملة بواسطة `plymouthd` |
| `argvus.script` | — | البرنامج النصي Plymouth | منطق الموضوع | نعم |
| `argvus-logo.png` | 256x256 | RGBA 8 بت | الشعار الرئيسي | نعم (`logo.base_scale = 0.72`) |
| `argvus-text.png` | 400x53 | RGBA 8 بت | العلامة النصية `ARGVUS` | نعم (`text.scale = 0.80`) |
| `progress-bar.png` | 400x4 | لوحة 1 بت | شريط مملوء | نعم |
| `progress-bar-track.png` | 400x4 | لوحة 1 بت | المسار الشاغر | نعم |
| `entry-box.png` | 400x48 | RGB 16 بت | حقل إدخال كلمة المرور | نعم |
| `bullet.png` | 12x12 | لوحة 4 بت | شخصية ملثمة واحدة | نعم |
|  `entry-line.png`  `logo-glow.png` `argvus-uki-splash.bmp` | 400x400 | BMP 32-bit | UKI / systemd-boot splash | no (consumed by the boot loader) |

                 ﻊﺟﺮﻤﻟﺍ ﺽﺮﻋ ﻮﻫ ﺔﻤﻠﻜﻟﺍ ﺭﺎﻌﺷ :ﻂﻴﻄﺨﺗ ﺓﺪﺣﻮﻛ ﺓﺭﻮﺼﻟﺍ ﺽﺮﻋ ﻡﺍﺪﺨﺘﺳﺍ ﻢﺘﻳ
       ﺭﻭﺮﻤﻟﺍ ﺔﻤﻠﻛ ﻝﺎﺧﺩﺇﻭ ﻡﺪﻘﺘﻟﺍ ﻂﻳﺮﺷ ،ﻡﺪﻘﺘﻟﺍ ﺭﺎﺴﻣﻭ (1.0 ﺱﺎﻴﻘﻤﻟﺍ ﺪﻨﻋ ﻞﺴﻜﺑ 400)
ﻥﺎﻛ ﺍﺫﺇ ﺎًﻜﺳﺎﻤﺘﻣ ﺐﻴﻛﺮﺘﻟﺍ ﻞﻈﻳ ﺍﺬﻟ ،ﻪﻨﻣ ﺔﻘﺘﺸﻣ ﻝﻮﻘﺤﻟﺍ ﻞﻛ
                                           .ﺔﻳﺭﺎﺠﺘﻟﺍ ﺔﻣﻼ﻿ﻌﻟﺍ ﻞﺻﺃ ﺮﻳﺪﺼﺗ ﺓﺩﺎﻋﺇ ﻢﺗ

`arch_check_splash_payload()` ﻲﻓ `packaging/arch/common/functions.sh` ﺐﻠﻄﺘﻳ
ﺮﻈﻧﺍ .ﺔﻤﺋﺎﻘﻟﺍ ﻚﻠﺗ ﻰﻟﺇ ﻪﺘﻓﺎﺿﺇ ﻲﻨﻌﻳ ﻞﺻﺃ ﺔﻓﺎﺿﺇ ؛ﺓﺩﻮﺟﻮﻣ ﻥﻮﻜﺗ ﻥﺃ ﺐﺠﻳ ﻩﻼ﻿ﻋﺃ ﺕﺎﻔﻠﻤﻟﺍ *

##                                                           ﻲﺠﻣﺮﺒﻟﺍ ﺺﻨﻟﺍ ﺽﺍﺮﻌﺘﺳﺍ

`src/usr/share/plymouth/themes/argvus/argvus.script`، ﻞﻔﺳﻷ﻿ﺍ ﻰﻟﺇ ﻰﻠﻋﻷ﻿ﺍ ﻦﻣ.

### 1. الخلفية

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```

              ﻲﻫ ﺕﺎﻧﻮﻜﻤﻟﺍ .ﺝﺭﺪﺗ ﻥﻭﺪﺑ ،ﺔﺤﻄﺴﻣ ﺔﺌﺒﻌﺗ ⇒ ﻞﻔﺳﻷ﻿ﺍﻭ ﻰﻠﻋﻷ﻿ﺍ ﻲﻓ ﺔﻤﻴﻘﻟﺍ ﺲﻔﻧ
                         .255 ﻰﻠﻋ ﺔﻣﻮﺴﻘﻣ `#111316` ـﻟ ﺖﺑ 8 ﺕﺍﺫ ﺕﺍﻮﻨﻘﻟﺍ

###                                                               ﻊﺳﻮﺘﻟﺍﻭ ﻝﻮﺻﻷ﻿ﺍ .2

                 ﻰﻟﺇ ﺔﺒﺴﻨﻟﺎﺑ ﻞﺤﻳ ﻱﺬﻟﺍ ،`Image("name")` ﺮﺒﻋ ﺓﺭﻮﺻ ﻞﻛ ﻞﻴﻤﺤﺗ ﻢﺘﻳ
`ImageDir`. ﺢﻳﺮﺻ ﺱﺎﻴﻘﻟﺍ:

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```

ﻥﻮﻜﻴﺳ ﺭﺎﻃﺇ ﻞﻛ ﻰﻠﻋ ImageScale :ﺓﺩﻮﺼﻘﻣ `logo.frame[...]` ﺖﻗﺆﻤﻟﺍ ﻦﻳﺰﺨﺘﻟﺍ ﺓ
ﻑﺪﻬﻟﺍ ﺐﺴﺣ ﺎًﺘﻗﺆﻣ ﻪﻨﻳﺰﺨﺗﻭ ﺓﺪﺣﺍﻭ ﺓﺮﻣ ﺭﺎﻌﺸﻟﺍ ﻢﺠﺣ ﺮﻴﻴﻐﺗ ﻢﺘﻳ ؛ﺭﺎﻃﺇ ﻞﻜﻟ ﺓﺪﻳﺪﺟ ﺓﺭﻮﺻ ﺺﻴ
.ﻂﻘﻓ ﺪﻳﺪﺟ ﻝﺎﺧﺩﺇ ﻰﻟﺇ ﻢﺠﺤﻟﺍ ﺮﻴﻴﻐﺗ ﺝﺎﺘﺤﻳ ﺚﻴﺤﺑ ﺽﺮﻌﻟﺍ

         ﺓﺪﺣﺍﻭ ﺓﺮﻣ ﻩﺮﻴﺒﻜﺗ ﻢﺗ ﻪﻨﻜﻟ ، `ImageScale` `text.scale = 0.80` ﻲﻓ ﺓﺮﻜﻔﻟﺍ ﺲﻔﻧ ﺭﺎﻌﺸﻟﺍ ﻊﺒﺘﻳ
        — `text.image.GetWidth()` ﻰﻟﺇ ﻂﻳﺮﺸﻟﺍﻭ ﻡﺪﻘﺘﻟﺍ ﺭﺎﺴﻣ ﺱﺎﻴﻘﻣ ﻞﻳﺪﻌﺗ ﻢﺘﻳ ﻢﺛ .ﻞﺴﻠﺴﺘﻣ
ﺔﻳﺭﺎﺠﺘﻟﺍ ﺔﻣﻼ﻿ﻌﻠﻟ ﻲﻘﻴﻘﺤﻟﺍ ﺽﺮﻌﻟﺍ ﻥﺎﻛ ﺎﻤﻬﻣ ،ﺔﻳﺭﺎﺠﺘﻟﺍ ﺔﻣﻼ﻿ﻌﻟﺍ ﺽﺮﻋ ﻖﺑﺎﻄﻳ ﺎًﻤﺋﺍﺩ ﻂﻳﺮﺸﻟﺍ
حجم البكسل هو.

### 3. التخطيط

:ﺓﺬﻓﺎﻨﻠﻟ ﻲﻘﻓﻷ﻿ﺍ ﺭﻮﺤﻤﻟﺍ ﻰﻠﻋ ﺰﻛﺮﻤﺘﻳ ﺮﺼﻨﻋ ﻞﻛ

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```

              + ﺭﺎﻌﺸﻟﺍ) ﻞﻣﺎﻜﻟﺍ ﺐﻴﻛﺮﺘﻟﺍ ﻰﻠﻋ ﺰّﻛﺮﻣ ﺲﻳﺪﻜﺘﻟﺍ :`- 35` ﻆﺣﻻ﻿
             ﻕﻮﻓ ًﻼ﻿ﻴﻠﻗ ﺲﻠﺠﺗ ﺔﻠﺘﻜﻟﺎﻓ ﺍﺬﻟ ،ﻂﻘﻓ ﺭﺎﻌﺸﻟﺍ ﺲﻴﻟﻭ ،(ﺭﺎﺴﻤﻟﺍ + ﺔﻤﻠﻜﻟﺍ ﺔﻣﻼ﻿ﻋ
ـﻟ ﺔﺒﺴﻨﻟﺎﺑ ﻱﺩﻮﻤﻌﻟﺍ ﻊﺿﻮﻤﻟﺍ ﻥﻮﻜﻳ ﻢﺛ .ﺔﺷﺎﺸﻠﻟ ﻱﺩﻮﻤﻌﻟﺍ ﻂﺳﻮﻟﺍ
                                             ,`text.y = logo.y + logo.image.GetHeight() + 16`) ﻖﺑﺎﺴﻟﺍ ﺮﺼﻨﻌﻟﺍ
`progress_track.y = text.y + text.image.GetHeight() + 28`، …)، ـﻟﺍ ﻲﻨﻌﻳ ﺎﻤﻣ
                                          .ﺔﻗﺪﻟﺍ ﻊﻣ ﺓﺪﺣﺍﻭ ﺓﺪﺣﻮﻛ ﺔﺒﻴﻛﺮﺘﻟﺍ ﺝﺭﺪﺘﺗ

الترتيب Z المستخدم هنا:

| ض | سبرايت |
| --- | --- |
| 100 | شعار، علامة نصية، مسار التقدم |
| 101 | شريط التقدم (فوق المسار) |
| 200 | حقل إدخال كلمة المرور |
| 201 | نص المطالبة بكلمة المرور |
| 202 | نقاط كلمة المرور |

###                                                                  ﻉﻼ﻿ﻗﻹ﻿ﺍ ﻡﺪﻘﺗ .4

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

                                            ﻚﺒﺸﻤﻟﺍ .`PlymouthSetBootProgressFunction(progress_callback)` ﻯﺪﻟ ﻞﺠﺴﻣ
matters:            ﻂﻳﺮﺸﻟﺍ ﺍﺬﻟ ،ﺙﻮﻤﻴﻠﺑ ﺕﺍﺭﺍﺪﺻﺇ ﺾﻌﺑ ﻲﻓ ﺔﺤﻟﺎﺻ ﺮﻴﻏ ﻱﺮﻔﺼﻟﺍ ﺽﺮﻌﻟﺍ ﺕﺍﺫ ﺓﺭﻮﺼﻟﺍ
                 .ﺍًﺪﺑﺃ ﺭﺎﺴﻤﻟﺍ ﺽﺮﻋ ﺯﻭﺎﺠﺘﻳ ﻥﺃ ﻡﺪﻘﺘﻠﻟ ﻦﻜﻤﻳ ﻻ﻿ﻭ ،ﺍًﺪﺑﺃ ﺎًﻣﺎﻤﺗ ﻲﻔﺘﺨﻳ ﻻ﻿
                    ﺺﻗ ﻭﺃ ﺔﺌﺒﻌﺗ ﻻ﻿ — ﻂﻘﻓ ﺓﺭﻮﺼﻟﺍ ﺽﺮﻋ ﺮﻴﻐﺘﻳ ؛ﺔﺘﺑﺎﺜﻟﺍ ﺔﻴﺼﺨﺸﻟﺍ ﻊﺿﻮﻣ
يتم استخدام العملية.

###                                                       ﺭﻭﺮﻤﻟﺍ ﺔﻤﻠﻛ ﺭﺍﻮﺣ ﻊﺑﺮﻣ . ٥

`display_password_callback(prompt, bullets)`:

1.      ﺎﻤﻨﻴﺑ ،0.15 ﺪﻨﻋ ﺔﻤﻠﻜﻟﺍ ﺔﻣﻼ﻿ﻋﻭ `logo.opacity = 0.15` :ﻥﺎﻌﻤﻠﻟﺍ ﻒﻔﺨﻳ
                                     . `0.15` `1.0` ﺪﻨﻋ ﺭﺎﺒﻟﺍﻭ ﺭﺎﺴﻤﻟﺍ ﻰﻘﺒﺗ
2.                              ﺪﻴﺣﻮﻟﺍ — `Image.Text(prompt, 0.72, 0.77, 0.81)` ﻡﺍﺪﺨﺘﺳﺎﺑ ﺔﺒﻟﺎﻄﻤﻟﺍ ﺽﺮﻌﻳ
               ،ﻂﻘﻓ ﺎﻨﻫ ﻑﻭﺮﻌﻣ ﺎﻬﻌﻗﻮﻣ .ﻉﻮﺿﻮﻤﻟﺍ ﻲﻓ ﻞﻴﻐﺸﺘﻟﺍ ءﺎﻨﺛﺃ ﺎﻫﺅﺎﺸﻧﺇ ﻢﺗ ﺓﺭﻮﺻ
                                                    .ﺺﻨﻟﺍ ﻉﺎﻔﺗﺭﺍ ﻰﻠﻋ ﺪﻤﺘﻌﻳ ﻪﻧﻷ﻿
3.                                = password.entry.y` :ﻪﺟﻮﻤﻟﺍ ﻞﻔﺳﺃ ﻝﺎﺧﺩﻹ﻿ﺍ ﻞﻘﺣ ﻊﻀﻳ
   password.prompt.y + password.prompt.image.GetHeight() + 14`. ﻞﻴﻤﺤﺘﻟﺍ ﺖﻗﻭ ﺪﻨ
`password.entry.y` is `0`                                              ﺮﻈﺘﻨﻳ ﻲﻘﻴﻘﺤﻟﺍ ﻊﻗﻮﻤﻟﺍ ﻥﺃ ﻖﻴﻠﻌﺗ ﻊﻣ
اِسْتَدْعَى.
4.                           :ﻡﺍﺪﺨﺘﺳﻻ﻿ﺍ ﺓﺩﺎﻋﺇ ﻭﺃ ءﺎﺸﻧﻹ﻿ﺍ ﺔﻘﻠﺣ ﻡﺍﺪﺨﺘﺳﺎﺑ ﺕﺎﻘﻠﻄﻟﺍ ﻢﺳﺮﻳ

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* create sprite + image */ }
       /* ...position at entry.x + 16 + index * bullet.width ... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```

؛ﺎﻬﺋﺎﺸﻧﺇ ﺓﺩﺎﻋﺇ ﻦﻣ ًﻻ﻿ﺪﺑ ﺕﺎﺒﻟﺎﻄﻤﻟﺍ ﺮﺒﻋ ﺎﻬﻣﺍﺪﺨﺘﺳﺍ ﺓﺩﺎﻋﺇﻭ ﺔﻴﻣﻮﺳﺮﻟﺍ ﺕﺎﻴﺼﺨﺸﻟﺍ ﻊﻴﻤﺠﺗ ﻢ
ﻂﺳﻮﻟﺍ ﻲﻓ ًﺎﻳﺩﻮﻤﻋ ﺔﻔﻄﺼﻣ ﺓﺮﻴﺧﺬﻟﺍ .`0` ﺔﻴﻓﺎﻔﺸﻟﺍ ﺔﻄﺳﺍﻮﺑ ﺔﻴﻔﺨﻣ ﺓﺪﺳﺎﻔﻟﺍ
.ﻝﺎﺧﺩﻹ﻿ﺍ ﻞﻘﺣ ﻉﺎﻔﺗﺭﺍ ﺪﺿ

`display_normal_callback()`                                                      ﺔﻣﺎﺘﻌﻟﺍ ﺪﻴﻌﺘﺴﻳ :ﺲﻜﻌﻟﺍ ﻮﻫ`1.0`                                                                          ﻲﻔﺨﻳ
ﻯﺪﻟ ﻞﺠﺴﻣ .ﺔﻌﻤﺠﻣ ﺔﺻﺎﺻﺭ ﻞﻛﻭ ﻝﺎﺧﺩﻹ﻿ﺍ ،ﺔﺒﻟﺎﻄﻤﻟﺍ
`PlymouthSetDisplayNormalFunction`، ﺭﻭﺮﻤﻟﺍ ﺓﺭﺎﺒﻋ ﻥﻮﻜﺗ ﺎﻣﺪﻨﻋ ﻪﻴﻤﺴﺗ ﺙﻮﻤﻴﻠﺑ
                                              .ﻉﻼ﻿ﻗﻹ﻿ﺍ ﺮﻤﺘﺴﻳﻭ ﻩﺅﺎﻐﻟﺇ ﻭﺃ ﻪﻟﻮﺒﻗ ﻢﺗ

Consequence: `logo.opacity` ﻲﺷﻼ﻿ﺘﻟﺍ ﻦﻣ ﻞﻛ ﻥﻷ﻿ ،ﺎًﺘﺑﺎﺛ ﺲﻴﻟﻭ ،ﺮﻴﻐﺘﻣ ﻮﻫ
                                                 .ﺎﻬﻴﻓ ﻒﻋﺎﻀﺗ ﺭﻭﺮﻤﻟﺍ ﺔﻤﻠﻛ ﺔﻟﺎﺣﻭ

###                                                                 ﻝﻮﺧﺪﻟﺍ ﻲﺷﻼ﻿ﺗ .6

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

Plymouth ﻭ ﺔﺼﻴﺧﺭ ﺎﻬﻧﺇ) ﻉﻼ﻿ﻗﻹ﻿ﺍ ﺓﺮﺘﻓ ﻝﺍﻮﻃ ﻞﻤﻌﻟﺍ ﻲﻓ ﺚﻳﺪﺤﺘﻠﻟ ءﺎﻋﺪﺘﺳ
calls it continuously); the

 guard makes it a no-op after the
animation. The logo uses

 instead of a plain
ﺪﻌﺑ :ﻲﺷﻼ﻿ﺘﻟﺍ ﺪﻌﺑ ﺭﻭﺮﻤﻟﺍ ﺔﻤﻠﻛ ﺔﻄﺳﺍﻮﺑ ﻢﻴﺘﻌﺘﻟﺍ ﺔﻟﺎﺣ ﻰﻘﺒﺗ ﺚﻴﺤﺑ ﻦﻴﻴ
.ﻯﺮﺧﺃ ﺓﺮﻣ `fade.complete` `logo.opacity * fade.opacity`  ﺮﻬﻈﻳ ﺭﺎﻌﺸﻟﺍﻭ `fade.opacity == 1` ﺮﻬ

ﺖﻧﺎﻛ ﺪﻘﻟ ؛ﺭﻮﻬﻈﻟﺍ/ﺾﺒﻨﻠﻟ ﺔﻛﺮﺤﺘﻣ ﺕﺎﻣﻮﺳﺭ ﻰﻠﻋ ﺎًﻀﻳﺃ ﻱﻮﺘﺤﺗ ﺖﻧﺎﻛ ﻉﻮﺿﻮﻤﻟﺍ ﺍﺬﻫ ﻦﻣ ﺔﻘﺑﺎﺴﻟ
ﺭﺎﻃﺇ ﻞﻜﻟ ﺎﻬﻟﺎﺧﺩﺇ ﺪﻴﻌﺗ ﻻ﻿ .("ﺾﺒﻨﻟﺍ ﺕﺍﺮﻴﺛﺄﺗ ﺔﻟﺍﺯﺇ :ﺔَﻤْﻬَﻤﻟﺍ")  `logo.opacity` `0.2.0` ﻲﻓ
                   ـﻟ ًﺎﻘﻴﻗﺩ ًﻼ﻿ﻴﺜﻤﺗ ﻂﻳﺮﺸﻟﺍ ﻞﻈﻳ ﻥﺃ ﺐﺠﻳ — ﻡﺪﻘﺘﻟﺍ ﻂﻳﺮﺸﻟ ﺔﻛﺮﺤﺘﻣ ﻡﻮﺳﺭ
تقدم التمهيد.

##                                                                  ﻂﻴﻄﺨﺘﻟﺍ ﺖﺑﺍﻮﺛ

                                               :ﻦﻳﻮﻜﺘﻟﺍ ﻂﺒﻀﻟ ﺔﻘﻴﻘﺤﻠﻟ ﺪﺣﺍﻭ ﺭﺪﺼﻣ

| ثابت | القيمة | معنى |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | مقياس الشعار مقابل 256 × 256 الأصلي |
| `logo.y` offset | `-35`                                    | ﺔﺷﺎﺸﻟﺍ ﻒﺼﺘﻨﻣ ﻕﻮﻓ ﺔﻳﺰﻛﺮﻤﻟﺍ ﺔﻠﺘﻜﻟﺍ ﻊﻓﺮﻳ |
| `text.scale` | `0.80` | مقياس الكلمات النصية مقابل 400 × 53 الأصلي |
| فجوة `text.y` | `+16` | أسفل الشعار → أعلى العلامة النصية |
| فجوة `progress_track.y` | `+28` | العلامة النصية أسفل → المسار العلوي |
| فجوة `password.prompt.y` | `+24` | المسار السفلي → النص الفوري أعلى |
| فجوة `password.entry.y` | `+14` | موجه أسفل → حقل الإدخال أعلى |
| رصاصة × إزاحة | `+16` | دخول اليسار → الرصاصة الأولى |
| `logo.opacity` (الحوار) | `0.15` | تعتيم البداية أثناء طلب عبارة المرور |
| لون موجه | `0.72, 0.77, 0.81` | `Image.Text` RGB، ~`#B8C4CE` |
| تتلاشى | 20 إطارًا بمعدل 20 إطارًا في الثانية | ~1 ثانية تتلاشى |

##                                                                   ﻢﻴﻤﺼﺘﻟﺍ ﺯﻮﻣﺭ

| الرمز المميز | عرافة | أين يعيش |
| --- | --- | --- |
| الخلفية | `#111316` | البرنامج النصي (`0.0667, 0.0745, 0.0863`) |
| لهجة | `#3590BD` | الشعار/العلامة النصية/ملء التقدم بالبكسلات |
| مسار التقدم | `#262933` | `progress-bar-track.png` |
| نص موجه | `#B8C4CE` | البرنامج النصي (استدعاء `Image.Text`) |

                  ﻲﻓ ﺎﻬﻨﻋ ﺍًﺮﺒﻌﻣ ﺲﻴﻟﻭ ،PNG ﺕﺎﻔﻠﻣ ﻲﻓ ﺔﻨﻤﻀﻣ ﺭﺎﺴﻤﻟﺍﻭ ﺰﻴﻴﻤﺘﻟﺍ ﻥﺍﻮﻟﺃ
.(ﻥﺍﻮﻟﻷ﻿ﺍ ﺔﺣﻮﻟ ﻞﻳﺪﻌﺗ ﻭﺃ) ﻝﻮﺻﻷ﻿ﺍ ﺮﻳﺪﺼﺗ ﺓﺩﺎﻋﺇ ﻲﻨﻌﺗ ﻦﻳﻮﻠﺘﻟﺍ ﺓﺩﺎﻋﺇ ﺍﺬﻟ ،ﻲﺠﻣﺮﺒﻟﺍ ﺺﻨﻟﺍ
.ﺔﺤﺗﺎﻓ ﺔﺨﺴﻧ ﻰﻠﻋ ﻱﻮﺘﺤﻳ ﻻ﻿ﻭ ﻂﻘﻓ ﻦﻛﺍﺩ ﻉﻮﺿﻮﻤﻟﺍ

##                                                         UKI ﻁﺎﻘﻨﻟﺍ ﺔﻄﻳﺮﺧ ﻖﻴﺴﻨﺗ

`argvus-uki-splash.bmp` ﻒﻠﻣ ﻮﻫ BMP ﻡﺎﻈﻨﻟ Windows 400 ﻢﺠﺤﺑ ﻁﻮﻐﻀﻣ ﺮﻴﻏx400 ﺖﺑ 32 ﺔﻗﺪﺑﻭ
(`PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32`). ﻪﻧﺇ
         ﻚﻟﺬﺑ ﻡﻮﻘﺗ Arch ﺔﻣﺰﺣﻭ ،ﺍًﺪﺑﺃ ﻪﻠﻴﻤﺤﺘﺑ ﻡﻮﻘﻳ ﻻ﻿ ﺙﻮﻤﻴﻠﺑ ﺖﺒﻳﺮﻜﺳ :ﻞﻘﺘﺴﻤﻟﺍ ﻞﺻﻷ﻿ﺍ
                  ﺮﻈﻧﺍ) ﻡﺪﺨﺘﺴﻤﻟﺍ ﺓﻮﻄﺧ ﻮﻫ UKI ﻲﻓ ﻪﻨﻴﻤﻀﺗ — ﻥﺎﻜﻣ ﻱﺃ ﻲﻓ ﻪﻠﻴﺠﺴﺗ ﻡﺪﻋ

              ؛ﻪﺑﺎﺸﻣ ﻢﺠﺤﺑ ﺖﺑ 32 ﻁﻮﻐﻀﻣ ﺮﻴﻏ BMP ﻒﻠﻤﻛ ﻪﺑ ﻆﻔﺘﺣﺍ ،ﻪﻟﺍﺪﺒﺘﺳﺎﺑ ﺖﻤﻗ ﺍﺫﺇ
systemd-boot ﻭ `ukify` ﺓﺮﻴﺒﻜﻟﺍ ﺭﻮﺼﻟﺍﻭ ﺔﻴﺋﺍﻮﺸﻌﻟﺍ ﺕﺎﻘﻴﺴﻨﺘﻟﺍ ﻥﺎﻣّﻮﻘﻳ ﻻ﻿
                                               .ﺮﻜﺒﻤﻟﺍ ﻉﻼ﻿ﻗﻹ﻿ﺍ ﺪﻨﻋ ﺓﺮﻛﺍﺬﻟﺍ ﻲﻬﺘﺸﻳ

##                                                                    ﺔﻤﺴﻟﺍ ﻞﻳﺪﻌﺗ

حلقة عملية:

1.                                        .(PNG ﺕﺎﻔﻠﻣ ﻭﺃ/ﻭ) `src/usr/share/plymouth/themes/argvus/argvus.script` ﺭﺮﺣ
2.              :ﺭﺪﺼﻤﻟﺍ ﺓﺮﺠﺷ ﻦﻣ ﺔﻨﻳﺎﻌﻣ ﻭﺃ ،ﻚﺑ ﺹﺎﺨﻟﺍ ﻲﺤﻟﺍ Plymouth ﻰﻠﻋ ﺖﻴﺒﺜﺘﻟﺎﺑ ﻢﻗ

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # check, then: sudo plymouthquit
   ```

3. `make validate && make build` ﻡﺍﺰﺘﻟﻻ﻿ﺍ ﻞﺒﻗ.

                                           :ﻉﻮﺿﻮﻤﻟﺍ ﻞﻤﻋ ﻰﻠﻋ ﻆﻓﺎﺤﺗ ﻲﺘﻟﺍ ﺪﻋﺍﻮﻘﻟﺍ

- ﻦﻣ ﻖﻘﺤﺗ ؛ﺓﺪﻴﻘﻣ ﺔﺠﻬﻟ ﻪﻟ ﻙﺮﺤﻤﻟﺍ .ﺍًﺪﺑﺃ ﺙﻮﻤﻴﻠﺒﻟ ﺔﻌﺑﺎﺘﻟﺍ ﺮﻴﻏ ﺕﺎﻘﻴﺒ
ﻚﻟﺬﺑ ﻢﻘﺗ ﻢﻟ ﺕﺎﻘﻴﺒﻄﺘﻟﺍ ﺔﺠﻣﺮﺑ ﺔﻬﺟﺍﻭ ﻡﺍﺪﺨﺘﺳﺍ ﻞﺒﻗ ﺎﻬﻤﻋﺪﺗ ﻲﺘﻟﺍ `plymouth` ﻦﻣ
تستخدم من قبل.
- ﻖﺑﺎﻄﺘﻳ ﻥﺃ ﺐﺠﻳﻭ ﺎًﻘﻠﻄﻣ argvus.plymouth ﻲﻓ `ImageDir`/`ScriptFile`
                                              . `argvus.plymouth` `/usr/share/plymouth/themes/argvus` ﺖﺒﺜﻤﻟﺍ ﺭﺎﺴﻤﻟﺍ
-                             ﻊﻣ `arch_check_splash_payload()` ﻲﻓ ﺝﺭﺪﻣ ﻞﺻﺃ ﻞﻛ ﻦﻣﺍﺰﺗ ﻰﻠﻋ ﻆﻓﺎﺣ
.CI ﻲﻓ ﻞﻤﻌﻳ check() ﻒﻴﻠﻐﺘﻟﺍ — `src/` ﻲﻓ ﻦﺤﺸُﺗ ﻲﺘﻟﺍ ﺕﺎﻔﻠﻤﻟﺍ
-                      ؛ﻪﻨﻋ ﻎﻠﺒﻤﻟﺍ ﻡﺪﻘﺘﻠﻟ ﺔﻘﻴﻗﺩ ﺔﻔﻴﻇﻭ ﻡﺪﻘﺘﻟﺍ ﻂﻳﺮﺷ ﺽﺮﻋ ﻞﻈﻳ ﻥﺃ ﺐﺠﻳ
                                    . `check()` `[1, track width]` ﻦﻋ ﻚﺒﺸﻤﻟﺍ ﺔﻟﺍﺯﺇ ﻡﺪﻋ ﺐﺠﻳ
-        ﺮﺜﻛﻷ﻿ﺍ ﺔﻟﺎﺤﻟﺍ ﺎﻬﻧﺇ :ﺔﻳﺍﺪﺒﻟﺍ ﺔﺷﺎﺷ ﺩﺮﺠﻣ ﺲﻴﻟﻭ ،ﺭﻭﺮﻤﻟﺍ ﺓﺭﺎﺒﻋ ﺭﺍﻮﺣ ﻊﺑﺮﻣ ﺮﺒﺘﺧﺍ
                              .ﺮﺜﻛﺃ ﻥﻮﻣﺪﺨﺘﺴﻤﻟﺍ ﻪﻈﺣﻼ﻿ﻳ ﺎﻣ ﻮﻫﻭ ﺮﺴﻜﻨﻳ ﻥﺃ ﺢﺟﺮﻤﻟﺍ ﻦﻣ
-           ﺭﺎﻃﺇ ﻞﻜﻟ ﻞﻤﻌﻟﺍ ﺺﻴﺼﺨﺘﺑ ﻆﻔﺘﺣﺍ ؛ﻉﻼ﻿ﻗﻹ﻿ﺍ ﺔﻴﻠﻤﻋ ﻝﺍﻮﻃ ﺚﻳﺪﺤﺘﻠﻟ ءﺍﺪﻨﻟﺍ ﺩﺭ ﻞﻤﻌﻳ
مجانا حيثما أمكن ذلك.

                                                        ﺮﻈﻧﺍ ﺕﺍﺭﺍﺪﺻﻹ﻿ﺍﻭ ﻒﻴﻠﻐﺘﻠﻟ[                                                                       ﻒﻴﻠﻐﺘﻟﺍ](/docs/argvus-boot-splash/developer-guide/packaging/)                                                                             ﻭ
[                                                     ﺕﺍﺭﺍﺪﺻﻹ﻿ﺍﻭ ﺮﻤﺘﺴﻤﻟﺍ ﻞﻣﺎﻜﺘﻟﺍ](/docs/argvus-boot-splash/developer-guide/ci-releases/)                                                              ﺮﻈﻧﺍ ،ﻡﺍﺪﺨﺘﺳﻼ﻿ﻟ .
[                                                                 ﻡﺪﺨﺘﺴﻤﻟﺍ ﻞﻴﻟﺩ](/docs/argvus-boot-splash/).
| entry-line.png | 300x2 | 1-bit palette | entry rule/underline | no (see [known gaps](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| logo-glow.png | 260x300 | 8-bit palette | logo glow artwork | no (see [known gaps](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
[                                                                       ﻒﻴﻠﻐﺘﻟﺍ](/docs/argvus-boot-splash/developer-guide/packaging/#shared-functions).
[                                                                 ﻡﺪﺨﺘﺴﻤﻟﺍ ﻞﻴﻟﺩ](/docs/argvus-boot-splash/uki-splash/)).
