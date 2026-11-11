---
title: Developer Guide
description: ARGVUS অবদানকারীদের জন্য স্থাপত্য এবং উন্নয়ন নির্দেশিকা।
---

# আর্গভাস বুট স্প্ল্যাশ — ডেভেলপার গাইড

`argvus-boot-splash` রিপোজিটরির জন্য প্রযুক্তিগত ডকুমেন্টেশন: Plymouth
থিমটি কীভাবে তৈরি করা হয়, Arch প্যাকেজটি কীভাবে নির্মিত হয়, এবং কীভাবে রিলিজগুলি
signed and published.

করা হয়। এখানে কোনো কম্পাইলেশন ধাপ নেই — থিমটি হলো ডেটা (একটি `.plymouth` বর্ণনাপত্র,
একটি `.script`, এবং ছবি) প্লাস একটি Arch প্যাকেজ রেসিপি। "তৈরি করা" এর মানে হলো
a reproducible package:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```

পরিবর্তন করার আগে: `make validate && make build`, এবং নতুন প্রযুক্তিগত
পদগুলো `.cspell/custom-dictionary-workspace.txt`-এ যোগ করুন অথবা বানান পরীক্ষা কাজ ব্যর্থ হবে।

যদি আপনি কেবল থিমটি *ব্যবহার* করতে চান, [ব্যবহারকারী গাইড](/docs/argvus-boot-splash/) পড়ুন।
এই ফাইলের প্রক্রিয়াভিত্তিক সমমুখী অংশের জন্য (git flow, secrets, রিলিজ
প্রক্রিয়া) দেখুন [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) এবং
[CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)।

## Guides

| Guide | Contents |
| --- | --- |
| [থিম আর্কিটেকচার](/docs/argvus-boot-splash/developer-guide/theme/)| বর্ণনাকারী, রেন্ডারিং মডেল, অ্যাসেট ইনভেন্টরি, স্ক্রিপ্ট ওয়াকথ্রু, লেআউট কনস্ট্যান্টস, ডিজাইন টোকেন, ইউকে আই বিটম্যাপ, থিম কিভাবে পরিবর্তন করবেন |
| [প্যাকেজিং](/docs/argvus-boot-splash/developer-guide/packaging/)| দুটি PKGBUILD, শেয়ার করা হয়েছে`functions.sh`, হুক ইনস্টল করুন, স্থানীয় বিল্ড পাইপলাইন, মেক টার্গেট, প্রয়োজনীয়তাসমূহ |
| [সিআই এবং রিলিজ](/docs/argvus-boot-splash/developer-guide/ci-releases/) | `validate.sh`, `ci.yml`, `release.yml`ধাপে ধাপে, চেকসাম, স্বাক্ষর, গোপনীয়তা, প্রকাশনা এবং সংস্করণায়ন |
| [প্রথা এবং পরিচিত ফাঁক](/docs/argvus-boot-splash/developer-guide/workflow/)| হাউস রুলস, ডকুমেন্টেশন ম্যাপ, এবং রিপোজিটরি অডিট করার সময় পাওয়া অসঙ্গতি |

## তাত্ক্ষণিক রেফারেন্স

| Path | What it is |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | theme payload installed under `/usr` |
| `packaging/arch/{ci,local}/PKGBUILD` | release and local package recipes |
| `packaging/arch/common/functions.sh` | shared `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | deterministic tarball + `makepkg` driver |
| `tools/sh/validate.sh` | required validation gate |
| `.github/workflows/` | `ci.yml` (validate, build, spellcheck), `release.yml` (tags `v*`) |

## Elsewhere

- রেপোজিটরি রুট: [README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
- ব্যবহারকারী-উন্মুখ ডকুমেন্টেশন: [user guide](/docs/argvus-boot-splash/)
- ডেভেলপমেন্ট প্রক্রিয়া: [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
- অবদানকারী: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
- সুরক্ষা নীতি: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
- লাইসেন্স: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
- পর্তুগিজ সংস্করণ: [Guia do desenvolvedor](/pt/docs/argvus-boot-splash/developer-guide/)
