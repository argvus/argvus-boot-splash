---
title: ইনস্টলেশন
description: প্রয়োজনীয়তা, ইনস্টলেশন বিকল্পসমূহ, এবং প্যাকেজের হুকগুলি কী করে।
---

# ইনস্টলেশন

আর্ক-ভিত্তিক সিস্টেমে Argvus বুট স্প্ল্যাশ পাওয়ার জন্য যা কিছু প্রয়োজন।

থিমটি কেমন দেখায় এবং এতে কী কী আছে, তা দেখার জন্য, দেখুন
[রেফারেন্স](/docs/argvus-boot-splash/reference/)। পরিবর্তে সোর্স থেকে এটি পুনর্নির্মাণ করতে,
[ডেভেলপার গাইড](/docs/argvus-boot-splash/developer-guide/) দেখুন।

## প্রয়োজনীয়তা

- একটি আর্ক-ভিত্তিক সিস্টেম যা `plymouth` ব্যবহার করে (প্যাকেজটি এর উপর নির্ভরশীল)।
- একটি initramfs জেনারেটর: **mkinitcpio** (আর্ক ডিফল্ট) বা **dracut**।
ইনস্টলার যা উপস্থিত তা সনাক্ত করে এবং আপনার জন্য initramfs পুনঃনির্মাণ করে।
- আপনার initramfs কনফিগারেশনে Plymouth সক্ষম থাকতে হবে। mkinitcpio এর সাথে,
নিশ্চিত করুন যে `plymouth` রয়েছে `HOOKS` এর `/etc/mkinitcpio.conf` তালিকায়:

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```

আপনি যদি এটি পরিবর্তন করে থাকেন তবে রিবুট করুন।

- সাধারণ গ্রাফিক্যাল সেশনের জন্য কিছুই প্রয়োজন নেই; থিমটি শুধুমাত্র
  বুট পথ।

## অপশন 1: অফিসিয়াল প্যাকেজ রেপোজিটরিতে চলে (প্রস্তাবিত)

স্বাক্ষরিত প্যাকেজগুলো Argvus প্যাকেজ রেপোজিটরিতে প্রকাশিত হয়
(`argvus/packages`, পথ `public/arch/$arch`)। এটি `/etc/pacman.conf`-তে যোগ করুন:

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```

`<PACKAGES_REPO_BASE_URL>`'কে সেই হোস্ট দিয়ে প্রতিস্থাপন করুন যেখানে প্রকল্পটি
রিপোজিটরি প্রকাশ করে (GitHub, GitLab বা Gitea)। আগে রিপোজিটরি সাইনিং কী আমদানি করুন, না হলে
, `pacman` ডাউনলোড প্রত্যাখ্যান করবে:

```sh
# 1. import the project's public signing key into your pacman keyring
pacman-key --add /path/to/argvus-signing-key.asc
pacman-key --lsign <key-id>

# 2. refresh and install
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```

## বিকল্প 2: রিলিজ প্যাকেজ ফাইল

প্রতিটি ট্যাগ করা রিলিজে একটি `.pkg.tar.zst` (তার `.sig` সহ) রিলিজ হিসেবে প্রকাশ করা হয়
সম্পদ। সরাসরি এটি ইনস্টল করুন:

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

যদি আপনি সরবরাহ-চেইন পরিচ্ছন্নতা সম্পর্কে যত্নশীল হন, ইনস্টল করার আগে বিচ্ছিন্ন স্বাক্ষরটি
প্রকল্পের পাবলিক কী-এর সাথে যাচাই করুন:

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

## বিকল্প ৩: ম্যানুয়াল ইনস্টলেশন

নন-আর্ক সিস্টেমে কার্যকর, অথবা আপনি শুধু থিমটি চেষ্টা করতে চাইলে
প্যাকেজিং। থিম ডিরেক্টরিটি Plymouth-এর থিম পাথে কপি করুন:

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# or: sudo mkinitcpio -P        # Arch
# or: sudo dracut --regenerate-all
```

Plymouth `/etc/default/grub`-এ `GRUB_CMDLINE_LINUX` দিয়ে সক্রিয় করা যেতে পারে
যা `splash` ধারণ করে, এবং `quiet` ক্লাসিক মিনিমাল-বুট অনুভূতি দেয়।

## ইনস্টলার যা করে

ইনস্টল বা আপগ্রেডের পরে, প্যাকেজ হুকগুলি স্বয়ংক্রিয়ভাবে চলে:

1. `plymouth-set-default-theme argvus` — `argvus` কে
`/etc/plymouth/plymouthd.conf`-এ লিখে।
2. যদি mkinitcpio বিদ্যমান থাকে, অন্যথায়  `mkinitcpio -P` `dracut --regenerate-all`।

যদি কোনো জেনারেটর পাওয়া না যায়, ইনস্টলার একটি সতর্কতা মুদ্রণ করে এবং আপনাকে
নিজেই initramfs তৈরি করতে হবে। একটি থিম পরিবর্তন কেবল বুটের সময় দৃশ্যমান হয় পরে
initramfs পুনরায় তৈরি করা হচ্ছে — সেই ধাপটি বাদ দিয়ে রিবুট করা একমাত্র সবচেয়ে
"স্প্ল্যাশ পরিবর্তন হয়নি" এর সাধারণ কারণ।

প্যাকেজটি অপসারণের সময় কেবল একটি অনুস্মারক মুদ্রণ করে: একটি ভিন্ন থিম নির্বাচন করা এবং
initramfs পুনর্নির্মাণ করা আপনার উপর ছাড়া হয়েছে। দেখুন
[অনইনস্টলেশন](/docs/argvus-boot-splash/uninstallation/)।

## পরবর্তী ধাপ

- [ব্যবহার](/docs/argvus-boot-splash/usage/) — ইনস্টলেশন যাচাই করুন, পুনরায় বুট করা ছাড়া প্রিভিউ করুন,
  থিম
- [UKI এবং systemd-boot স্প্ল্যাশ](/docs/argvus-boot-splash/uki-splash/) — UKI তে বিটম্যাপ ব্যবহার করুন।
- [সমস্যা সমাধান](/docs/argvus-boot-splash/troubleshooting/) — যদি স্প্ল্যাশ পরিবর্তিত না হয়।
