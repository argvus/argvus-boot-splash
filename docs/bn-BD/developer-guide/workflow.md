---
title: রীতিনীতি এবং পরিচিত ফাঁকসমূহ
description: হাউস রুলস, ডকুমেন্টেশন মানচিত্র, এবং রেপোজিটরি অডিট ফলাফল।
---

# রীতিনীতি এবং পরিচিত ফাঁকসমূহ

এই রেপোজিটরিতে পরিবর্তনের জন্য হাউস রুলস, এছাড়াও পাওয়া অসঙ্গতিগুলো
এটি অডিট করা — অনুলিপি করার চেয়ে মেরামত করা ভালো।

প্রযুক্তিগত রেফারেন্সের জন্য দেখুন [থিম আর্কিটেকচার](/docs/argvus-boot-splash/developer-guide/theme/),
[প্যাকেজিং](/docs/argvus-boot-splash/developer-guide/packaging/)এবং [সিআই এবং রিলিজ](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Conventions

- শেল: `set -euo pipefail`, ইন্ডেন্টেশনের জন্য ট্যাব, `printf`/`error` বার্তা
stderr, `command -v` সক্ষমতা যাচাই, shellcheck পরিষ্কার (দেখুন
  `.editorconfig`).
- কখনো `sha256sums=('SKIP')` লিখবেন না; git-এ `sha256sums=()` খালি রাখুন।
- build আউটপুট (`build/`), প্যাকেজ ফাইল, বা উত্পন্ন ফাইল কমিট করবেন না
  `.PKGBUILD.local.*` copies.
- ঐতিহ্য অনুযায়ী ব্যবহৃত স্কোপ সহ Conventional Commits: `splash`, `layout`,
`pkgbuild`, `release`, `chore`, `ci`, `build`, `docs`।
- শাখার নামকরণ: `feat/…`, `fix/…`, `docs/…`, `chore/…`, `refactor/…`।
- একজন সমীক্ষকের অনুমোদন মার্জের আগে, স্কোয়াশ-মার্জ।
- লাইসেন্স: GPL-3.0-শুধুমাত্র। শিপ করা হয়েছে `/usr/share/licenses/argvus-boot-splash/LICENSE` হিসাবে।
- [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) এবং
[DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) এ উল্লিখিত প্রক্রিয়াগুলি অনুসরণ করুন।

## পরিচিত ফাঁকসমূহ

রেপোজিটরি নিরীক্ষণ করার সময় পাওয়া নথিভুক্ত অসঙ্গতিগুলি:

- `README.md` সরাসরি Plymouth প্রিভিউর জন্য `make test` প্রচার করে, কিন্তু এমন কোনো
লক্ষ্যটি [Makefile](https://github.com/argvus/argvus-boot-splash/blob/main/Makefile)-এ বিদ্যমান। প্রকৃত কমান্ডগুলি হল
`sudo plymouth --show-splash` / `sudo plymouthquit`।
- `entry-line.png` এবং `logo-glow.png` পে-লোডে পাঠানো হয় এবং
`arch_check_splash_payload()` দ্বারা প্রয়োজন, কিন্তু `argvus.script` সেগুলি কখনো লোড করে না। অথবা
স্ক্রিপ্টে তাদের সংযুক্ত করুন বা পে-লোড এবং চেকলিস্ট থেকে তাদের বাদ দিন।
- ইনস্টল করা হয়েছে কিন্তু
কখনো কোন কিছুর সঙ্গে নিবন্ধিত হয়নি;
[ব্যবহারকারীর গাইড](/docs/argvus-boot-splash/uki-splash/) ম্যানুয়ালটি দস্তাবেজ করে।
   `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` `bootctl`/`ukify` step.
- প্রামাণিক ডকুমেন্টগুলো রেপোজিটরি রুটে রাখা হয়েছে (`README.md`,
`DEVELOPMENT.md`) এবং `docs/`-তে নির্দেশকের সাথে ওভারল্যাপ করুন। যে কোনওটি পরিবর্তন করলে এগুলি সঙ্গতিপূর্ণ রাখুন
। অবদান নীতি (`CONTRIBUTING.md`, `SECURITY.md`)
সংস্থার `.github` রিপোজিটরিতে থাকে।

## ডকুমেন্টেশন মানচিত্র

| Document | Audience | Scope |
| --- | --- | --- |
| `README.md` | everyone | one-paragraph overview and layout |
| `DEVELOPMENT.md` | maintainers | build, signing, release process |
| [`CONTRIBUTING.md`](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)(অর্গ `.github`) | অবদানকারীরা | গিট ফ্লো, পিআর নিয়ম, সিক্রেট নীতি |
| [`docs/user-guide.md`](/docs/argvus-boot-splash/)| চূড়ান্ত ব্যবহারকারী | ইনস্টলেশন, ব্যবহার, সমস্যার সমাধান |
| [`docs/developer-guide.md`](/docs/argvus-boot-splash/developer-guide/)(/docs/argvus-boot-splash/developer-guide/) | developers | theme internals, packaging, CI |
