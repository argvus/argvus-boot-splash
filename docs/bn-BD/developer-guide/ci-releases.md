---
title: CI এবং রিলিজ
description: যাচাইকরণ, ক্রমাগত ইন্টিগ্রেশন, স্বাক্ষর এবং প্রকাশ ওয়ার্কফ্লো।
---

# CI এবং প্রকাশ।

ভ্যালিডেশন গেট, কন্টিনিউয়াস ইন্টিগ্রেশন জব, রিলিজ পাইপলাইন এবং
সংস্করণ করার নিয়ম।

। প্যাকেজটির জন্য দেখুন [প্যাকেজিং](/docs/argvus-boot-splash/developer-guide/packaging/); থিমের জন্য দেখুন
[থিম আর্কিটেকচার](/docs/argvus-boot-splash/developer-guide/theme/)।

## বৈধতা

`tools/sh/validate.sh` প্রয়োজনীয় গেট:

- প্রয়োজন করে `bash`, `makepkg`, `shellcheck`;
- `shellcheck` + `bash -n` এ `tools/sh/*.sh` এবং `packaging/arch/common/*.sh`;
- উভয় PKGBUILD উৎস এবং তুলনা করে নিষ্কাশিত মেটাডেটা — দূরবর্তী এবং স্থানীয় অবশ্যই
  ম্যাচ
- `makepkg -p PKGBUILD --printsrcinfo` মধ্যে `ci/` এবং `local/` (ফাইলটি
পার্স করে যেভাবে makepkg করে);
- `git diff --check` (স্পেস/সংশ্লেষণ চিহ্ন).

## ক্রমাগত সংহতকরণ

`.github/workflows/ci.yml` (`main`, `archlinux:latest` কন্টেইনারে push/PR):

1. `base-devel git namcap pacman-contrib shellcheck sudo` ইনস্টল করুন;
2. `make validate`;
3. একজন **অপ্রিভিলেজড** `builder` ব্যবহারকারী হিসেবে তৈরি করুন
   (`sudo -u builder env HOME=/home/builder make build`) — makepkg চালাতে অস্বীকার করছে
মূল হিসেবে, এবং কর্মক্ষেত্রটি প্রথমে `chown`ed।
4. একটি পৃথক `spellcheck` জব `cspell-action@v6` চালায় `cspell.json` দিয়ে।

`namcap` ইনস্টল করলে `pkgbuild_local.sh` এর ভিতরে চলে, তাই স্থানীয় বিল্ডগুলো প্রকাশ পায়
CI এর মতো একই লিন্ট। স্পেলচেক কনফিগারেশন হলো `cspell.json` ওয়ার্কস্পেসের সাথে
`.cspell/custom-dictionary-workspace.txt` তে অভিধান — নতুন প্রযুক্তিগত শব্দসমূহ
(শেল ফ্ল্যাগ, টুল নাম) সেই অভিধানে থাকা উচিত, না হলে CI ব্যর্থ হবে।

## রিলিজ পাইপলাইন

`.github/workflows/release.yml` — ট্রিগার: একটি `v*` ট্যাগ পুশ করা, অথবা
`workflow_dispatch` একটি বিদ্যমান ট্যাগের সাথে (নিয়ন্ত্রিত পুনঃনির্মাণ)। কনকারেন্সি গ্রুপ
`release-<ref>`, কোনো বাতিলকরণ নেই।

পদক্ষেপ:

1. **চেকআউট** ট্যাগটি (ডিসপ্যাচ ব্যবহার করে `inputs.tag`)।
2. **ভার্সন ধাপ**: ট্যাগটি
 `^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$` `url` এর সাথে যাচাই করে, যদি
তে `packaging/arch/remote/PKGBUILD` খালি থাকে তাহলে ব্যর্থ হয়, তারপর ট্যাগ থেকে `pkgver` পুনর্লিখন করে।
3. **ভ্যালিডেট**: `make validate`।
4. **বিল্ড** অপরিবর্তিত `builder` হিসেবে: `updpkgsums` (
আসল `sha256sums`) তারপর
`makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`.
`.pkg.tar.zst` অবস্থান করে এবং যদি কিছু না থাকে, ব্যর্থ হয়।
5. **namcap** প্যাকেজে।
6. **Sign**: একটি throwaway GNUPGHOME-এ `GPG_PRIVATE_KEY` আমদানি করে ( `GNUPGHOME` `mktemp -d`,
মোড ৭০০), ইমপোর্ট করা সিক্রেট কীটি `GPG_KEY_ID` (ছোট আইডি বা
ফিঙ্গারপ্রিন্ট) এর সাথে মেলে কিনা যাচাই করে, এবং একটি আলাদা `.sig` তৈরি করে
`--pinentry-mode loopback --passphrase-fd 0` এর সাথে।
7. **স্বাক্ষর যাচাই করুন** একটি নতুন `GNUPGHOME` তে — যদি
স্বাক্ষর যাচাই না করে তবে রিলিজ ব্যর্থ হয়।
8. **আর্টিফ্যাক্ট আপলোড করুন** (`upload-artifact@v4`, `retention-days: 1`, প্যাকেজ +
স্বাক্ষর, `if-no-files-found: error`)।
9. **প্রকাশ করুন**: `argvus/packages` `PACKAGES_REPO_TOKEN` দিয়ে চেক আউট করুন,
প্যাকেজ এবং `.sig` `public/arch/x86_64` তে কপি করুন,
`repo-add -R argvus.db.tar.gz <pkg>` চালান, `argvus.db.tar.gz` স্বাক্ষর করুন,
`argvus.files.tar.gz`, `argvus.db` এবং `argvus.files`, তারপর
হিসেবে কমিট করুন `github-actions[bot]` এবং পুশ করুন। কোনো পরিবর্তন না থাকলে ডিফ 0 কমিট ছাড়াই এক্সিট করে।
10. **GitHub রিলিজ**: `softprops/action-gh-release@v2` তৈরি করা নোট সহ
এবং প্যাকেজ + স্বাক্ষর হিসাবে অ্যাসেট।

## চেকসাম, সাইনিং এবং সিক্রেটস

- `SKIP` নামের কোনো কিছু নেই: `sha256sums` সবসময় একটি সত্যিকারের ডাইজেস্ট, যা বিল্ডের সময় হিসাব করা হয়
সময় (স্থানীয়) বা `updpkgsums` (রিলিজ CI) এর মাধ্যমে।
- রিপোজিটরিতে `sha256sums=()` **খালি** রাখুন।
- রিলিজগুলো GPG-স্বাক্ষরিত (প্যাকেজ `.sig`, `argvus.db.tar.gz`,
`argvus.files.tar.gz`, `argvus.db`, `argvus.files`)।
- `GPG_PASSPHRASE` খালি হতে পারবে না; ওয়ার্কফ্লো একটি খালি পাসফ্রেজ গ্রহণ করে না।

কী প্রস্তুত করুন:

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```

রিপোজিটরির **Settings → Secrets and variables → Actions**-এ:

| গোপন | মান |
| --- | --- |
| `GPG_PRIVATE_KEY` | `gpg --armor --export-secret-keys KEY_ID` আউটপুট |
| `GPG_KEY_ID` | প্রত্যাশিত কী আইডি বা আঙুলের ছাপ |
| `GPG_PASSPHRASE` | সাইনিং কী এর অ-খালি পাসফ্রেজ |
| `PACKAGES_REPO_TOKEN` | `contents:write`-এ `argvus/packages` এর সাথে PAT |

## একটি রিলিজ প্রকাশ করা

ট্যাগ করার আগে:

1. `url` বাস্তব রিপোজিটরির সাথে `packaging/arch/remote/PKGBUILD`-এ পূরণ করুন:
   - GitHub: `url="https://github.com/argvus/argvus-boot-splash"` (সোর্স
ব্যবহার করে `${url}/archive/refs/tags/v${pkgver}.tar.gz`);
   - GitLab: `source=` কে
এ সমন্বয় করুন `https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz`;
   - ছাড়া `url`, রিলিজটি **উদ্দেশ্যমূলকভাবে ব্যর্থ হয়** স্পষ্ট বার্তা সহ।
2. `packaging/arch/local/PKGBUILD` এবং
`packaging/arch/remote/PKGBUILD`.
3. ট্যাগ এবং পুশ:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```

কাজের প্রবাহটি বিদ্যমান `v*` ট্যাগকে
ইনপুট হিসাবে ব্যবহার করে ম্যানুয়ালি শুরু করাও যায়, যা একটি নিয়ন্ত্রিত পুনর্নির্মাণের জন্য উপকারী।

## সংস্করণ করা

- SemVer  `tag` `pkgver`, রিলিজ সংখ্যা `pkgrel`।

## ডেভেলপার ট্রাবলশুটিং

**'Retrieving sources' এ রিলিজ ব্যর্থ হয়েছে।** খালি `url`, অনুপস্থিত `v*` ট্যাগ, বা এমন একটি
আর্কাইভ URL ফর্ম্যাট যা হোস্টের সাথে মেলে না (GitHub বনাম GitLab টারবোল
লেআউট)। ওয়ার্কফ্লো ট্যাগ প্যাটার্নটি যাচাই করে এবং খালি
`url`.

তে আগে ব্যর্থ হয় **`updpkgsums` সোর্স খুঁজে পাওয়া যায়নি।** ট্যাগটি অবশ্যই থাকা এবং পুশ করা থাকতে হবে আগে
রিলিজ জব চলে; শুধুমাত্র লোকাল হিসেবে থাকা একটি ট্যাগ দিয়ে ডিসপ্যাচ করা এখানে ব্যর্থ হয়।

**`make validate` রিপোর্ট করে 'রিমোট এবং লোকাল PKGBUILD মেটাডেটা সিঙ্কে নেই'।**
এক PKGBUILD থেকে অন্যটিতে মেটাডেটা ফিল্ডগুলি (`source=` নয়) কপি করুন।

**একটি নতুন টার্মে বানান পরীক্ষা ব্যর্থ হয়।** এটিকে
`.cspell/custom-dictionary-workspace.txt` (`argvus` অভিধান, `addWords:
true`), not to `ignorePaths`।

**`sudo` `make install` এর ভিতরে অনুরোধ করা হয়েছে, বা `libfakeroot.so … LD_PRELOAD`
ত্রুটি।** একটি `package()` যা ব্যবহার না করে
 `make install` `install -Dm*`। উভয় PKGBUILDs `arch_package_splash_payload` কল করে, যা
করে না; নিশ্চিত করুন যে কেউ `make` কল পুনঃপ্রবর্তন করেনি।

**`makepkg` চালাতে অস্বীকার করে।** এটি root হিসেবে চালানো যাবে না। বিল্ডটি একটি সাধারণ
ব্যবহারকারী হিসেবে চালান, বা `sudo -u <user> make build`।

**প্যাকেজটি ইনস্টল হয় তবে স্প্ল্যাশ অপরিবর্তিত থাকে।** initramfs পুনর্নির্মাণ করা হয়নি।
স্থানীয় পরীক্ষার জন্য, রিবুট করার পরিবর্তে `sudo plymouth --show-splash` কল করুন, অথবা
`sudo mkinitcpio -P` / `sudo dracut --regenerate-all` দিয়ে পুনর্নির্মাণ করুন।
