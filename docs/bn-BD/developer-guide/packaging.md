---
title: প্যাকেজিং
description: আর্ক প্যাকেজ মেটাডেটা, বিল্ড পাইপলাইন, এবং মেক টার্গেট।
---

# প্যাকেজিং

আর্ক প্যাকেজটি কীভাবে সংজ্ঞায়িত এবং উৎপন্ন হয়: দুটি PKGBUILD, শেয়ার করা
ফাংশন, ইনস্টল হুক, স্থানীয় বিল্ড পাইপলাইন এবং Make টার্গেট।

থিমের জন্য দেখুন [theme architecture](/docs/argvus-boot-splash/developer-guide/theme/); যাচাই, CI এবং
রিলিজের জন্য দেখুন [CI and releases](/docs/argvus-boot-splash/developer-guide/ci-releases/)।

## দুটি PKGBUILD, একটি পে-লোড

`packaging/arch/remote/PKGBUILD` এবং `packaging/arch/local/PKGBUILD` একই।
`source=` ছাড়া:

| | `local` | `ci` |
| --- | --- | --- |
| উৎস | `${pkgname}-${pkgver}.tar.gz` (`make build` দ্বারা নির্মিত) | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| দ্বারা ব্যবহৃত | বিকাশকারী, `make build` | GitHub অ্যাকশন রিলিজ |

উভয়ই `packaging/arch/common/functions.sh` থেকে একই ফাংশনগুলি কল করে, এবং
`tools/sh/validate.sh` তাদের মেটাডেটা (`pkgname`, `pkgver`, `pkgrel`,
`pkgdesc`, `arch`, `license`, `depends`, `makedepends`, `options`) একই হওয়া দাবি করে,
সুতরাং দুইটি চুপচাপ তলিয়ে যেতে পারে না।

ভাগ করা মেটাডেটা:

```bash
pkgname=argvus-boot-splash
pkgver=0.2.0
pkgrel=1
arch=('any')                 # pure data package
depends=('plymouth')
optdepends=('mkinitcpio: rebuild initramfs (Arch Linux)'
            'dracut: rebuild initramfs (alternative)')
options=('!debug')
conflicts=('argvus-plymouth') # renamed predecessor
replaces=('argvus-plymouth')
```

## ভাগ করা ফাংশনগুলি

`packaging/arch/common/functions.sh` প্রদান করে তিনটি ফাংশন যা উভয়
PKGBUILDs:

- `arch_normalize_source_tree` (`prepare()`) দ্বারা ব্যবহৃত হয় — GitHub ট্যাগ আর্কাইভগুলি
`<repo>-v<version>`-এ বের করা হয়, যখন স্থানীয় টারবাল
`<pkgname>-<pkgver>`। এটি একক শীর্ষ-স্তরের ডিরেক্টরির নাম পরিবর্তন করে
এ, এবং ত্রুটি দেখায় যদি উত্স ডিরেক্টরি
অনুপস্থিত, অস্পষ্ট, অথবা গন্তব্য ইতিমধ্যেই বিদ্যমান থাকে।
-  `${srcdir}/${pkgname}-${pkgver}` `arch_check_splash_payload` (`check()`) — নিশ্চিত করে যে প্রতিটি থিম অ্যাসেট
প্রত্যাহৃত উৎস। এটি প্যাকেজের একমাত্র "টেস্ট স্যুট"; তালিকা
প্রয়োজনীয় ফাইলগুলো [অ্যাসেট ইনভেন্টরি](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory)-তে রয়েছে।
- `arch_package_splash_payload` (`package()`) — `src/usr` সঙ্গে হাঁটছে
`find -print0` এবং প্রতিটি ফাইল `install -Dm644` দিয়ে `$pkgdir` তে ইনস্টল করে
(NUL-নিরাপদ, নামের মধ্যে স্থান থাকা সত্ত্বেও কাজ করে), তারপর `LICENSE` কে
`/usr/share/licenses/argvus-boot-splash/LICENSE`.

এ ইনস্টল করে। লক্ষ্য করুন যে package() এর ভিতরে কোনো `make install` কল নেই: সবকিছুই
 `package()` `install -Dm*`, তাই প্যাকেজটি স্বনির্ভর এবং রুটলেস-বিল্ডের জন্য উপযোগী।
এটি পরিকল্পিত — একটি পুরনো `package()` যা `make install` তৈরি করেছিল
`sudo`/`libfakeroot.so` ব্যর্থতা।

## ইনস্টল হুক

`packaging/arch/{ci,local}/argvus-boot-splash.install` (একই):

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`,
তারপর `mkinitcpio -P` যদি উপলব্ধ থাকে, নয়তো `dracut --regenerate-all`, নয়তো a
ব্যবহারকারীকে ম্যানুয়ালি পুনর্নির্মাণ করতে বলার সতর্কতা।
- `post_remove()` → শুধুমাত্র তথ্যবহুল বার্তা; থিমটি আবার পরিবর্তিত হয়নি
স্বয়ংক্রিয়ভাবে (অনুমান করার তুলনায় নিরাপদ)।

## স্থানীয় বিল্ড পাইপলাইন

`tools/sh/pkgbuild_local.sh` (`make build` দ্বারা আহ্বান করা হয়েছে):

1. যাচাই করে `makepkg`, `sha256sum`, `tar`, `awk`, `find` এবং যে PKGBUILD
বিদ্যমান; PKGBUILD উৎস থেকে `pkgname`/`pkgver` পড়ে এবং উভয়
   against allow-list regexes (

 for the name, a dotted version
সংস্করণের জন্য প্যাটার্ন)।
2. Builds

 with

   and

 — a deterministic,
পুনরায় প্রজননযোগ্য আর্কাইভ। এটি  --transform "s#^\./#${pkgname}-${pkgver}/#"  tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner  build/artifacts/${pkgname}-${pkgver}.tar.gz  `^[a-z0-9@._+-]+$`  `build/artifacts/${pkgname}-${pkgver}.tar.gz`  `tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner`  `--transform "s#^\./#${pkgname}-${pkgver}/#"` `.git`, `build/`, `dist/`, `target/`,
, `tools/`, `release`/`packages-repo` স্ক্র্যাচ ডিরেক্টরি এবং যে কোনো `src/`, `pkg/` বা
প্যাকেজিং ডিরেক্টরির মধ্যে অবশিষ্ট অংশগুলি বাদ দেয়।
3. আর্কাইভের `sha256` গণনা করে এবং স্থানীয় PKGBUILD-এর একটি **অস্থায়ী
কপি**-তে `sed` এর মাধ্যমে ইনজেক্ট করে (`.PKGBUILD.local.XXXXXX`, একটি `EXIT`
ট্র্যাপ দ্বারা মুছে ফেলা হয়েছে)। রিপোজিটরি সর্বদা `sha256sums=()` খালি রাখে; `SKIP` কখনও
   ব্যবহৃত
4. হয় না। পূর্বে বিদ্যমান যে কোনও `${pkgname}-${pkgver}-*.pkg.tar.zst` কে
`build/dist/` তাই একটি পুরনো প্যাকেজকে এই বিল্ডের সাথে বিভ্রান্ত করা যাবে না।
5. `makepkg -p <generated PKGBUILD> --nodeps --noconfirm --needed
--cleanbuild --force --check` with `BUILDDIR`/`SRCDEST` in `build/artifacts/` চালায়
এবং `PKGDEST` `build/dist/`-তে। অতিরিক্ত আর্গুমেন্ট গুলি `makepkg`-তে ফরওয়ার্ড করা হয়;
`MAKEPKG_FLAGS` ডিফল্ট ফ্ল্যাগ সেটকে ওভাররাইড করে (উদ্দেশ্যপুর্ণভাবে শব্দ-বিভাজন)।
6. ব্যর্থ হয় যদি একদম একটিই `.pkg.tar.zst` মেলে, তারপর `namcap`-এ এটি চালায় যদি
   ইনস্টল করা

Outputs:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```

## মেক টার্গেটগুলি

| লক্ষ্য | প্রভাব |
| --- | --- |
| `make build` (ওরফে `make package`) | `tools/sh/pkgbuild_local.sh` চালান → `build/` |
| `make install` (alias `make install-package`) | `sudo pacman -U`একটি প্যাকেজে`build/dist/`; যদি সংখ্যা ঠিক 1 না হয় তবে ত্রুটি |
| `make validate` | `tools/sh/validate.sh`: শেলচেক + `bash -n` + PKGBUILD মেটাডেটা সিঙ্ক + `makepkg --printsrcinfo` প্রতি PKGBUILD + `git diff --check` |
| `make lint` (alias `make lint-shell`) | shellcheck over `tools`, `packaging/arch/common`, `src` (`SC1090`, `SC2034`, `SC2154` disabled), `bash -n`, `git diff --check` |
| `make spellcheck` | `cspell --config cspell.json .` যদি `cspell` ইনস্টল করা থাকে, অন্যথায় এড়িয়ে যায় |
| `make clean` | `rm -rf build/` |
| `make help` | লক্ষ্য তালিকা (ডিফল্ট লক্ষ্য) |

CI চালায় `make validate` এবং `make build`; CI তে কিছুই চালায় না `make install`
(দেখুন [প্রচলিত ফাঁক](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)).

## পূর্বশর্ত

একটি আর্ক-ভিত্তিক সিস্টেম যার মধ্যে রয়েছে `make`, `git`, `gnupg` এবং `base-devel` গ্রুপ:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```

- `pacman-contrib` `updpkgsums` প্রদান করে (PKGBUILD চেকসাম পুনরায় তৈরি করে)।
- `shellcheck` রিপোজিটরি শেল স্ক্রিপ্ট এবং শেয়ার করা আর্ক
  প্যাকেজিং ফাংশন।
- ঐচ্ছিক: `namcap` (প্যাকেজ
লিন্টিং) এবং cspell (লোকাল বানান পরীক্ষা) যাচাই করে। CI এদের সকলকেই ইনস্টল করে।
