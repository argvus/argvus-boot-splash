---
title: Reference
description: ইনস্টল করা ফাইল, প্যাকেজ মেটাডেটা, এবং রঙের মান।
---

# Reference

যে সফ্টওয়্যার প্যাকেজটি ইনস্টল করে এবং এটি কোন মান ব্যবহার করে তার জন্য প্রযুক্তিগত রেফারেন্স।

## আপনি যা পাবেন

| Component | Description |
| --- | --- |
| আর্গভাস লোগো | শব্দচিহ্নের উপরে আঁকা কেন্দ্রীভূত চিহ্ন |
| Wordmark | `ARGVUS` text below the logo |
| প্রগতি বার | পাতলা বার যেটির প্রস্থ প্লাইমাউথের বুট প্রগ্রেসকে প্রতিফলিত করে |
| পাসওয়ার্ড ডায়ালগ | লুকস প্রম্পট একটি লুকানো এন্ট্রি ফিল্ড সহ (`•` bullets) |
| ফেড-ইন | যখন প্লাইমাউথ শুরু হয়, তখন প্রায় ১ সেকেন্ডে স্প্ল্যাশ ফেড ইন করে |
| ইউকেআই বিটম্যাপ | `argvus-uki-splash.bmp`UKI / systemd-boot ভিত্তিক বুটের জন্য |

প্যাকেজটির নাম হলো `argvus-boot-splash` এবং এটি পুরনো
`argvus-plymouth` প্যাকেজটি প্রতিস্থাপন করে যদি আপনি এটি ইনস্টল করে থাকেন।

## ইনস্টল করা ফাইলসমূহ

`/usr/share/plymouth/themes/argvus/` এর অধীনে:

| File | Size | Purpose |
| --- | --- | --- |
| `argvus.plymouth` | — | theme descriptor (name, description, module) |
| `argvus.script` | — | the theme script (Plymouth's own scripting language) |
| `argvus-logo.png` | 256x256 | logo, RGBA |
| `argvus-text.png` | 400x53 | wordmark, RGBA |
| `progress-bar.png` | 400x4 | filled part of the progress bar |
| `progress-bar-track.png` | 400x4 | unfilled track |
| `entry-box.png` | 400x48 | password entry field |
| `entry-line.png` | 300x2 | password field rule/underline |
| `bullet.png` | 12x12 | masked character |
| `logo-glow.png` | 260x300 | logo glow artwork |
| `argvus-uki-splash.bmp` | 400x400, 32-bit | UKI/systemd-boot splash bitmap |

প্লাস লাইসেন্স `/usr/share/licenses/argvus-boot-splash/LICENSE` এ।

## প্যাকেজ মেটাডাটা

| Field | Value |
| --- | --- |
| Name | `argvus-boot-splash` |
| Architecture | `any` |
| Depends | `plymouth` |
| Optional depends | `mkinitcpio`, `dracut` |
| Conflicts / replaces | `argvus-plymouth` |
| License | GPL-3.0-only |

## Colors

| Element | Color |
| --- | --- |
| Background | `#111316` |
| Accent (logo, wordmark, progress fill) | `#3590BD` |
| Progress track | `#262933` |
| Password prompt text | light gray-blue (`#B8C4CE`) |

থিমটি যে কোনো রেজোলিউশনে একটি শক্ত ডার্ক ব্যাকগ্রাউন্ড ব্যবহার করে, তাই এটি কখনও
লাইট এবং ডার্ক ভেরিয়ান্টের মধ্যে স্বয়ংক্রিয়ভাবে পরিবর্তিত হয় না।

## সাহায্য পাওয়া

- প্রকল্পের ইস্যু ট্র্যাকার-এ বাগ রিপোর্ট করুন এবং ফিচার অনুরোধ করুন।
- নিরাপত্তা বিষয়: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) অনুসরণ করুন — একটি পাবলিক
  issue for vulnerabilities.
- সোর্স, বিল্ড এবং রিলিজ খোলবেন না: রিপোজিটরির রুট ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)).
- অবদান রাখুন: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)।
- লাইসেন্স: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)।

## পরবর্তী ধাপ

- [ইনস্টলেশন](/docs/argvus-boot-splash/installation/)
- [ব্যবহার](/docs/argvus-boot-splash/usage/)
- [সমস্যা সমাধান](/docs/argvus-boot-splash/troubleshooting/)
