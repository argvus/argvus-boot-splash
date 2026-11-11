---
title: ARGVUS Boot Splash
description: ARGVUS ডেস্কটপ পরিবেশের জন্য প্লাইমাউথ থিম এবং ইনস্টলেশন গাইড
---

# ARGVUS বুট স্প্ল্যাশ

Argvus বুট স্প্ল্যাশ হল Argvus ডেস্কটপ ইকোসিস্টেমের জন্য একটি [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/) থিম। এটি আপনি যেটি দেখেন মেশিন চালু করার মুহূর্ত থেকে আপনার গ্রাফিকাল সেশন শুরু হওয়ার সময় পর্যন্ত।

## Documentation

এই ডকুমেন্টেশনটি দুইটি প্রধান অংশে সংগঠিত:

### ব্যবহারকারী গাইড
শেষ ব্যবহারকারী এবং সিস্টেম প্রশাসকদের জন্য ইনস্টলেশন এবং ব্যবহার নির্দেশিকা।

| Guide | Contents |
| --- | --- |
| [ইনস্টলেশন](/docs/argvus-boot-splash/installation/)| প্রয়োজনীয়তা, তিনটি ইনস্টলেশন বিকল্প, প্যাকেজ হুকগুলি কী করে |
| [ব্যবহার](/docs/argvus-boot-splash/usage/)| ইনস্টলেশন যাচাই করুন, রিবুট না করেই প্রিভিউ করুন, থিম পরিবর্তন বা পূর্বাবস্থায় ফিরিয়ে আনুন, কমান্ড চিট শিট |
| [ইউকিআই এবং systemd-boot স্প্ল্যাশ](/docs/argvus-boot-splash/uki-splash/)| ব্যবহার করে `argvus-uki-splash.bmp`একটি UKI বুট ফ্লোতে |
| [অপসারণ](/docs/argvus-boot-splash/uninstallation/)| প্যাকেজটি সরানো এবং পূর্ববর্তী থিমটি পুনরায় স্থাপন করা |
| [সমস্যা সমাধান](/docs/argvus-boot-splash/troubleshooting/)| সাধারণ লক্ষণ এবং তাদের কারণ |
| [Reference](/docs/argvus-boot-splash/reference/) for the installed and user paths.

### [ডেভেলপার গাইড](/docs/argvus-boot-splash/developer-guide/)
অবদানকারীরা এবং রক্ষণাবেক্ষণকারীদের জন্য প্রযুক্তিগত ডকুমেন্টেশন।

- [থিম আর্কিটেকচার](/docs/argvus-boot-splash/developer-guide/theme/) — প্লিমাউথ ডিসক্রিপ্টর, রেন্ডারিং মডেল, এবং কাস্টমাইজেশন
- [প্যাকেজিং](/docs/argvus-boot-splash/developer-guide/packaging/) — পাইপলাইন তৈরি করুন এবং রেসিপি প্যাকেজ করুন
- [সিআই এবং রিলিজ](/docs/argvus-boot-splash/developer-guide/ci-releases/) — ভ্যালিডেশন, টেস্টিং, এবং রিলিজ ওয়ার্কফ্লো

## দ্রুত শুরু

আর্ক-ভিত্তিক সিস্টেমগুলির জন্য:

```sh
sudo pacman -S argvus-boot-splash   # or: sudo pacman -U ./argvus-boot-splash-<version>-1-any.pkg.tar.zst
```

ইনস্টলার থিমকে ডিফল্ট হিসেবে সেট করে এবং স্বয়ংক্রিয়ভাবে আপনার initramfs পুনরায় জেনারেট করে।

---

- **রিপোজিটরি:** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **License:** GPL-3.0-only
- **বাগ রিপোর্ট:** [GitHub Issues](https://github.com/argvus/argvus-boot-splash/issues)
