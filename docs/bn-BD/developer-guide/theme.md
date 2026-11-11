---
title: Theme Architecture
description: কীভাবে Plymouth ডেসক্রিপ্টর, অ্যাসেট এবং স্ক্রিপ্ট একসাথে রাখা হয়।
---

# থিম আর্কিটেকচার

কীভাবে Plymouth থিম একত্রিত করা হয়: ডেসক্রিপ্টর, অ্যাসেট সেট, এবং যা
`argvus.script` করেঃ, ধারা অনুযায়ী।

প্যাকেজিং এবং রিলিজের জন্য দেখুন [packaging](/docs/argvus-boot-splash/developer-guide/packaging/) এবং
[CI এবং রিলিজ](/docs/argvus-boot-splash/developer-guide/ci-releases/)। ব্যবহারের জন্য দেখুন
[user guide](/docs/argvus-boot-splash/)।

## Descriptor

Plymouth থিমগুলো হলো ঘোষণামূলক বর্ণনাকারী যা Plymouth-এর স্ক্রিপ্ট দ্বারা ব্যাখ্যা করা হয়
ইঞ্জিন। এখানে দুটি অংশ রয়েছে:

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

- `ModuleName=script` প্লাইমাউথের বিল্ট-ইন স্ক্রিপ্ট ইন্টারপ্রেটার নির্বাচন করে। কোনো
কম্পাইলড মডিউল নেই; `ImageDir` এবং `ScriptFile` অবশ্যই **পূর্ণ পাথ** হতে হবে,
কারণ initramfs-এর কাজের ডিরেক্টরি আপনার সেশনের থেকে ভিন্ন।
- ফাইলের নাম হলো থিমের নাম: `argvus.plymouth` ⇒ থিম `argvus`, যা হলো
যে `plymouth-set-default-theme argvus` নির্বাচিত করে।
- `argvus.script` হলো একমাত্র কোড ফাইল। এটি Plymouth-এর এমবেডেড ভিএম
-র ভিতরে চলে (`plymouthd` এবং initramfs-এ লিঙ্ক করা হয়েছে)।
  that: কোনও ফাইল I/O নেই, কোনও থ্রেড নেই, কোনও বাহ্যিক প্রক্রিয়া নেই, কোনও ফ্লোটিং পয়েন্ট নেই,
`MathInt` হল আপনার একমাত্র গণিত, এবং ভাষাটি একটি ছোট C-এর মতো ডায়ালেক্ট
(অ্যারে হল কীযুক্ত অবজেক্ট, `Sprite()` অবজেক্ট ব্যবহারের আগে তৈরি করতে হবে)।

## রেন্ডারিং মডেল

- একটি সমতল সলিড ব্যাকগ্রাউন্ড (`Window.SetBackgroundTopColor` /
  `SetBackgroundBottomColor`).
- **স্প্রাইট** হলো একমাত্র চিত্রাঙ্কন প্রাথমিক উপাদান। প্রতিটি `Sprite()`-এর একটি চিত্র, একটি
 [0, 1]  `(x, y)`  `[0, 1]` `SetPosition` অবস্থান, একটি **z-order** এবং একটি অস্বচ্ছতা আছে `ImageScale`-তে। পরে SetPosition
win কল করে; কোন দৃশ্য গ্রাফ নেই।
- প্রগতি দেখানো হয় প্রতিটি ফ্রেমে একটি চিত্র পুনঃপ্রদর্শন করে এবং
`SetImage` স্প্রাইটে — কোনো ক্লিপিং বা আংশিক-চিত্র primitives নেই।
- Plymouth রিপোর্টগুলি কলব্যাকের মাধ্যমে অবস্থা জানান যে স্ক্রিপ্টটি রেজিস্টার করে:
  `PlymouthSetBootProgressFunction`, `PlymouthSetDisplayPasswordFunction`,
  `PlymouthSetDisplayNormalFunction`, `PlymouthSetRefreshFunction`.
- `Plymouth.SetRefreshRate(20)` রিফ্রেশ কলব্যাকটি 20 FPS-এ চালায়;
থিমের একমাত্র সময়-নির্ধারিত অ্যানিমেশন (fade-in) এর উপর এটি নির্ভর করে।

## অ্যাসেট ইনভেন্টরি

সমস্ত সম্পদ `src/usr/share/plymouth/themes/argvus/`-তে থাকা হয়।

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
| `entry-line.png`| 300x2 | 1-বিট প্যালেট | এন্ট্রি নিয়ম/আন্ডারলাইন | না (দেখুন [পরিচিত ফাঁক](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `logo-glow.png`| 260x300 | ৮-বিট প্যালেট | লোগো গ্লো আর্টওয়ার্ক | নেই (দেখুন[পরিচিত ফাঁক](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `argvus-uki-splash.bmp` | 400x400 | BMP 32-বিট | UKI / systemd-boot স্প্ল্যাশ | না (বুট লোডার দ্বারা ব্যবহৃত) |

চিত্রের প্রস্থ লেআউট ইউনিট হিসাবে ব্যবহৃত হয়: ওয়ার্ডমার্কটি রেফারেন্স প্রস্থ
(স্কেল 1.0-এ 400 পিক্সেল) এবং প্রগ্রেস ট্র্যাক, প্রগ্রেস বার এবং পাসওয়ার্ড এন্ট্রি
ক্ষেত্র তাদের থেকে নির্ধারিত হয়, তাই যদি
ওয়ার্ডমার্ক সম্পদটি পুনঃরপ্তানি করা হয়, কম্পোজিশন সঙ্গতিপূর্ণ থাকে।

`arch_check_splash_payload()`-এ `packaging/arch/common/functions.sh` প্রয়োজন
**সকল** ফাইল উপরের উপরে থাকতে হবে; একটি অ্যাসেট যোগ করা মানে এটি সেই তালিকায় যোগ করা।
[প্যাকেজিং](/docs/argvus-boot-splash/developer-guide/packaging/#shared-functions) দেখুন।

## স্ক্রিপ্ট ওয়াকথ্রু

`src/usr/share/plymouth/themes/argvus/argvus.script`, উপরের থেকে নীচ পর্যন্ত।

### 1. Background

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```

একই মান উপরে এবং নীচে ⇒ একটি সমতল ফিল, কোনো গ্রেডিয়েন্ট নয়। উপাদানগুলি হল
`#111316` এর 8-বিট চ্যানেলগুলো 255 দিয়ে ভাগ করা হয়েছে।

### 2. সম্পদ এবং স্কেলিং

প্রতিটি ইমেজ `Image("name")` এর মাধ্যমে লোড করা হয়, যা
`ImageDir` এর সাথে আপেক্ষিক হিসেবে সমাধান করে। স্কেলিং স্পষ্ট:

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```

`logo.frame[...]` ক্যাশে ইচ্ছাকৃত: `ImageScale` প্রতিটি ফ্রেমে হবে
প্রতিটি ফ্রেমের জন্য একটি নতুন ছবি বরাদ্দ করুন; লোগোটিকে একবার স্কেল করা হয়েছে এবং টার্গেট
প্রস্থ অনুযায়ী ক্যাশে করা হয়েছে, তাই শুধুমাত্র একটি নতুন এন্ট্রি প্রয়োজন।

ওয়ার্ডমার্ক একই চিন্তাভাবনা অনুসরণ করে `text.scale = 0.80`-তে, তবে এটি একবারই ইনলাইন স্কেল করা হয়
। প্রগতি ট্র্যাক এবং বার তারপর `text.image.GetWidth()`-তে স্কেল করা হয় —
অর্থাৎ, বারের চওড়া সর্বদা ওয়ার্ডমার্কের চওড়ার সাথে মিল হয়, ওয়ার্ডমার্কের বাস্তব
pixel size is.

### 3. Layout

যাই হোক না কেন। প্রতিটি উপাদান উইন্ডোর অনুভূমিক অক্ষের উপরে কেন্দ্রীভূত:

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```

। লক্ষ্য করুন `- 35`: স্ট্যাকটি পুরো সংমিশ্রণ (লোগো +
ওয়ার্ডমার্ক + ট্র্যাক) এর উপরে কেন্দ্রীভূত, কেবল লোগোর উপর নয়, তাই ব্লকটি সামান্য উপরে বসে থাকে
স্ক্রিনের উল্লম্ব মধ্য। উল্লম্ব অবস্থান তখন সম্পর্কিত হয়
পূর্ববর্তী উপাদান (`text.y = logo.y + logo.image.GetHeight() + 16`,
`progress_track.y = text.y + text.image.GetHeight() + 28`, …), যা অর্থ
কম্পোজিশন রেজোলিউশনের সাথে একক হিসেবে স্কেল করে।

Z-order used here:

| Z | Sprite |
| --- | --- |
| 100 | logo, wordmark, progress track |
| 101 | progress bar (above the track) |
| 200 | password entry field |
| 201 | password prompt text |
| 202 | password bullets |

### ৪. বুট প্রগতি

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

`PlymouthSetBootProgressFunction(progress_callback)` এর সাথে নিবন্ধিত। ক্ল্যাম্প
matters: কিছু Plymouth সংস্করণে শূন্য-প্রস্থের চিত্র অবৈধ, তাই বার
কখনও পুরোপুরি অদৃশ্য হয় না, এবং অগ্রগতি কখনও ট্র্যাক প্রস্থ ছাড়িয়ে যেতে পারে না।
স্প্রাইটের অবস্থান স্থির; শুধুমাত্র চিত্রের প্রস্থ পরিবর্তিত হয় — কোন_fill বা কাট নেই
operation is used.

### ৫. পাসওয়ার্ড ডায়ালগ

`display_password_callback(prompt, bullets)`:

1. স্প্ল্যাশটি নিচু করে: `logo.opacity = 0.15` এবং `0.15`-এ ওয়ার্ডমার্ক, যখন
ট্র্যাক এবং বার `1.0`-এ থাকে।
2. প্রম্পটটি `Image.Text(prompt, 0.72, 0.77, 0.81)`-এ রেন্ডার করে — থিমে একমাত্র
রানটাইম-উত্পন্ন ইমেজ। এর অবস্থান কেবল এখানেই জানা যায়,
কারণ এটি টেক্সটের উচ্চতার উপর নির্ভর করে।
3. প্রম্পটের নিচে এন্ট্রি ফিল্ডের অবস্থান নির্ধারণ করে: `password.entry.y =
password.prompt.y + password.prompt.image.GetHeight() + 14`। লোড সময়
`password.entry.y` হল `0` একটি মন্তব্য সহ যে আসল অবস্থান
   prompt.
4. অপেক্ষা করছে। একটি তৈরি-অথবা-পুনঃব্যবহার লুপ দিয়ে বুলেট আঁকে:

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* create sprite + image */ }
       /* ...position at entry.x + 16 + index * bullet.width ... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```

স্প্রাইটগুলি পুনরায় তৈরি করার পরিবর্তে প্রম্পটগুলির মধ্যে পুল করা হয় এবং পুনঃব্যবহার করা হয়;
পুরনো গুলিগুলো Opacity `0` দিয়ে লুকানো আছে। গুলিগুলো উল্লম্বভাবে কেন্দ্রীভূত।
এন্ট্রি ফিল্ডের উচ্চতার বিপরীতে।

`display_normal_callback()` হল বিপরীত: এটি অস্বচ্ছতা পুনরায় স্থাপন করে `1.0`, লুকায়
প্রম্পট, এন্ট্রি এবং প্রতিটি পুল করা বুলেট।
`PlymouthSetDisplayNormalFunction` এর সাথে নিবন্ধিত, প্লাইমাউথ এটি কল করে যখন পাসফ্রেজ
গৃহীত বা বাতিল হয় এবং বুট চালিয়ে যায়।

Consequence: `logo.opacity` একটি পরিবর্তনশীল, ধ্রুবক নয়, কারণ উভয় ফেড
এবং পাসওয়ার্ড স্টেট এতে গুণিত হয়।

### 6. ফেড-ইন

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

রিফ্রেশ কলব্যাক পুরো বুটের জন্য চালু থাকে (এটি সস্তা এবং Plymouth
এটি ক্রমাগত কল করে); `fade.complete` গার্ড এটিকে
অ্যানিমেশনের পরে নো-অপ বানায়। লোগো একটি সাধারণ
অ্যাসাইনমেন্টের পরিবর্তে `logo.opacity * fade.opacity` ব্যবহার করে যাতে পাসওয়ার্ড দ্বারা ডিমড অবস্থাটি ফেডের পরে টিকে থাকে:
ফেড সম্পন্ন হলে, `fade.opacity == 1` এবং লোগো আবার দেখায় `logo.opacity`।

এই থিমের পূর্ববর্তী সংস্করণগুলিতেও পালস/স্প্যান অ্যানিমেশন ছিল; সেগুলি
পরে সরানো হয়েছে `0.2.0` ("chore: remove pulse effects")। প্রগতি বারটির প্রতি-ফ্রেম
অ্যানিমেশন পুনঃপ্রবর্তন করবেন না — বারটি অবশ্যই
boot progress.

## লেআউট ধ্রুবকসমূহ

কম্পোজিশন টিউন করার জন্য একক সত্যের উৎস:

| Constant | Value | Meaning |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | logo scale vs. its native 256x256 |
| `logo.y` offset | `-35`| মধ্য-স্ক্রিনের উপরে কেন্দ্রিত ব্লকটি তুলছে |
| `text.scale` | `0.80` | wordmark scale vs. its native 400x53 |
| `text.y` gap | `+16` | logo bottom → wordmark top |
| `progress_track.y` gap | `+28` | wordmark bottom → track top |
| `password.prompt.y` gap | `+24` | track bottom → prompt text top |
| `password.entry.y` gap | `+14` | prompt bottom → entry field top |
| bullet x offset | `+16` | entry left → first bullet |
| `logo.opacity` (dialog) | `0.15` | splash dimming while a passphrase is requested |
| prompt color | `0.72, 0.77, 0.81` | `Image.Text` RGB, ~`#B8C4CE` |
| fade | 20 frames @ 20 FPS | ~1 s fade-in |

## ডিজাইন টোকেন

| Token | Hex | Where it lives |
| --- | --- | --- |
| Background | `#111316` | script (`0.0667, 0.0745, 0.0863`) |
| Accent | `#3590BD` | logo / wordmark / progress fill pixels |
| Progress track | `#262933` | `progress-bar-track.png` |
| Prompt text | `#B8C4CE` | script (`Image.Text` call) |

অ্যাকসেন্ট এবং ট্র্যাক রঙ PNG অ্যাসেটে অন্তর্ভুক্ত,
স্ক্রিপ্টে প্রকাশ করা হয়নি, তাই রিকলোরিং মানে অ্যাসেটগুলি পুনঃরফতানি করা (অথবা প্যালেট সম্পাদনা) করা।
থিমটি শুধুমাত্র ডার্ক এবং এতে কোনো লাইট ভেরিয়েন্ট নেই।

## UKI বিটম্যাপ ফরম্যাট

`argvus-uki-splash.bmp` একটি 400x400, 32-বিট অসম্প্রেসড উইন্ডোজ BMP
(`PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32`). এটি একটি
স্বতন্ত্র সম্পদ: প্লাইমাউথ স্ক্রিপ্ট এটি কখনও লোড করে না, এবং আর্ক প্যাকেজ করে
এটি কোথাও নিবন্ধন করবেন না — একটি UKI-তে এটি এমবেড করা ব্যবহারকারীর ধাপ (দেখুন
[ব্যবহারকারী নির্দেশিকা](/docs/argvus-boot-splash/uki-splash/)).

আপনি যদি এটি প্রতিস্থাপন করেন, এটি একটি সাধারণ অনসংকুচিত 32-বিট BMP রাখুন যা তুলনামূলক আকারের;
systemd-boot এবং `ukify` যেকোন ফরম্যাট এবং বড় চিত্র স্কেল করে না এবং প্রাথমিক বুটে বড় চিত্রগুলো
মেমোরি-ভক্ষী।

## থিম পরিবর্তন করা

Practical loop:

1. সম্পাদনা করুন `src/usr/share/plymouth/themes/argvus/argvus.script` (এবং/অথবা PNG ফাইলগুলো)।
2. আপনার লাইভ প্লাইমাউথ-এ ইনস্টল করুন, বা উৎস ট্রি থেকে প্রিভিউ করুন:

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # check, then: sudo plymouthquit
   ```

3. `make validate && make build` কমিট করার আগে।

থিম কাজ করে রাখার নিয়মসমূহ:

- কখনই নন-প্লাইমাউথ API ব্যবহার করবেন না। ইঞ্জিন একটি সীমিত ভাষা; ব্যবহার করার আগে যে API-টি আপনি ব্যবহার করেননি তা পরীক্ষার জন্য
লক্ষ্য সংস্করণ `plymouth` যা আপনি সমর্থন করেন।
  used before.
- `ImageDir`/`ScriptFile`-কে `argvus.plymouth`-এ পুরোপুরি অপরিবর্তিত রাখতে হবে এবং এটি
-এ ইনস্টল করা পথ `/usr/share/plymouth/themes/argvus`-এর সাথে মিলতে হবে।
- প্রতিটি সম্পদ যা `arch_check_splash_payload()`-এ তালিকাভুক্ত আছে তা
-এ থাকা ফাইলগুলির সাথে তালমিল রাখতে হবে যা `src/`-এ শিপ হয় — প্যাকেজিং `check()` CI-তে চলে।
- প্রোগ্রেস বারের প্রস্থ অবশ্যই রিপোর্টকৃত অগ্রগতির সঠিক ফাংশন হিসেবে থাকতে হবে;
`[1, track width]`-এ ক্ল্যাম্পটি অপসারণ করা চলবে না।
- পাসফ্রেজ ডায়ালগ পরীক্ষা করুন, শুধু বুট স্প্ল্যাশ নয়: এটি সবচেয়ে
ভাঙার সম্ভাবনা বেশি এবং ব্যবহারকারীরা সবচেয়ে বেশি লক্ষ্য করে।
- রিফ্রেশ কলব্যাক পুরো বুটের জন্য চলে; প্রতি-ফ্রেম কাজের বরাদ্দ রাখা
  free where possible.
